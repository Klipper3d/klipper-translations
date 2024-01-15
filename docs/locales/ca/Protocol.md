# Protocol

El protocol de missatgeria Klipper s'utilitza per a la comunicació de baix nivell entre el programari amfitrió Klipper i el programari del microcontrolador Klipper. A un alt nivell, el protocol es pot pensar com una sèrie de cadenes d'ordres i resposta que es comprimeixen, es transmeten i després es processen al costat receptor. Una sèrie d'exemple d'ordres en format llegible per humans sense comprimir podria semblar:

```
set_digital_out pin=PA3 value=1
set_digital_out pin=PA7 value=1
schedule_digital_out oid=8 clock=4000000 value=0
queue_step oid=7 interval=7458 count=10 add=331
queue_step oid=7 interval=11717 count=4 add=1281
```

Consulteu el document [mcu commands](MCU_Commands.md) per obtenir informació sobre les ordres disponibles. Consulteu el document [debugging](Debugging.md) per obtenir informació sobre com traduir un fitxer G-Code a les seves ordres de microcontrolador llegibles per humans corresponents.

Aquesta pàgina proporciona una descripció d'alt nivell del propi protocol de missatgeria Klipper. Descriu com es declaren els missatges, es codifiquen en format binari (l'esquema de "compressió") i es transmeten.

L'objectiu del protocol és habilitar un canal de comunicació sense errors entre l'amfitrió i el microcontrolador que sigui de baixa latència, baix ample de banda i poca complexitat per al microcontrolador.

## Interfície de microcontrolador

El protocol de transmissió Klipper es pot pensar com un mecanisme [RPC](https://ca.wikipedia.org/wiki/Remote_Procedure_Call) entre el microcontrolador i l'amfitrió. El programari del microcontrolador declara les ordres que l'amfitrió pot invocar juntament amb els missatges de resposta que pot generar. L'amfitrió utilitza aquesta informació per ordenar al microcontrolador que realitzi accions i que interpreti els resultats.

### Declaració d'ordres

El programari del microcontrolador declara una "ordre" mitjançant la macro DECL_COMMAND() al codi C. Per exemple:

```
DECL_COMMAND(command_update_digital_out, "update_digital_out oid=%c value=%c");
```

L'anterior declara una ordre anomenada "update_digital_out". Això permet que l'amfitrió "invoqui" aquesta ordre que provocaria que la funció C command_update_digital_out() s'executi al microcontrolador. L'anterior també indica que l'ordre pren dos paràmetres enters. Quan s'executa el codi command_update_digital_out() C, se li passarà una matriu que conté aquests dos nombres enters: el primer correspon a l''oid' i el segon al 'valor'.

En general, els paràmetres es descriuen amb la sintaxi d'estil printf() (per exemple, "%u"). El format correspon directament a la vista llegible per l'home de les ordres (per exemple, "update_digital_out oid=7 value=1"). A l'exemple anterior, "value=" és un nom de paràmetre i "%c" indica que el paràmetre és un nombre enter. Internament, el nom del paràmetre només s'utilitza com a documentació. En aquest exemple, el "%c" també s'utilitza com a documentació per indicar que l'enter esperat té una mida d'1 byte (la mida de l'enter declarada no afecta l'anàlisi o la codificació).

La construcció del microcontrolador recopilarà totes les ordres declarades amb DECL_COMMAND(), determinarà els seus paràmetres i disposarà que es puguin cridar.

### Declaració de respostes

Per enviar informació del microcontrolador a l'amfitrió es genera una "resposta". Tots dos es declaren i es transmeten mitjançant la macro C sendf(). Per exemple:

```
sendf("status clock=%u status=%c", sched_read_time(), sched_is_shutdown());
```

L'anterior transmet un missatge de resposta "estat" que conté dos paràmetres sencers ("rellotge" i "estat"). La construcció del microcontrolador troba automàticament totes les trucades sendf() i genera codificadors per a elles. El primer paràmetre de la funció sendf() descriu la resposta i té el mateix format que les declaracions d'ordres.

L'amfitrió pot organitzar el registre d'una funció de devolució de trucada per a cada resposta. Així, en efecte, les ordres permeten a l'amfitrió invocar funcions C al microcontrolador i les respostes permeten que el programari del microcontrolador invoqui codi a l'amfitrió.

La macro sendf() només s'ha d'invocar des dels controladors d'ordres o tasques, i no s'ha d'invocar des d'interrupcions o temporitzadors. El codi no necessita emetre un sendf() en resposta a una ordre rebuda, no està limitat en el nombre de vegades que es pot invocar sendf() i pot invocar sendf() en qualsevol moment des d'un gestor de tasques.

#### Respostes de sortida

Per simplificar la depuració, també hi ha una funció C output(). Per exemple:

```
output("The value of %u is %s with size %u.", x, buf, buf_len);
```

La funció output() és similar en l'ús a printf(): té la intenció de generar i formatar missatges arbitraris per als humans.

### Declaració d'enumeraments

Les enumeracions permeten que el codi amfitrió utilitzi identificadors de cadena per als paràmetres que el microcontrolador gestiona com a nombres enters. Es declaren al codi del microcontrolador, per exemple:

```
DECL_ENUMERATION("spi_bus", "spi", 0);

DECL_ENUMERATION_RANGE("pin", "PC0", 16, 8);
```

Si el primer exemple, la macro DECL_ENUMERATION() defineix una enumeració per a qualsevol missatge d'ordre/resposta amb un nom de paràmetre "spi_bus" o un nom de paràmetre amb un sufix de "_spi_bus". Per a aquests paràmetres, la cadena "spi" és un valor vàlid i es transmetrà amb un valor enter de zero.

També és possible declarar un rang d'enumeració. En el segon exemple, un paràmetre "pin" (o qualsevol paràmetre amb un sufix de "_pin") acceptaria PC0, PC1, PC2, ..., PC7 com a valors vàlids. Les cadenes es transmetran amb nombres enters 16, 17, 18, ..., 23.

### Declaració de constants

També es poden exportar constants. Per exemple, el següent:

```
DECL_CONSTANT("SERIAL_BAUD", 250000);
```

exportaria una constant anomenada "SERIAL_BAUD" amb un valor de 250000 des del microcontrolador a l'amfitrió. També és possible declarar una constant que sigui una cadena, per exemple:

```
DECL_CONSTANT_STR("MCU", "pru");
```

## Codificació de missatges de baix nivell

Per aconseguir el mecanisme RPC anterior, cada comanda i resposta es codifica en un format binari per a la transmissió. En aquesta secció es descriu el sistema de transmissió.

### Blocs de missatges

Totes les dades enviades des de l'amfitrió al microcontrolador i viceversa estan contingudes en "blocs de missatges". Un bloc de missatges té una capçalera de dos bytes i un tràiler de tres bytes. El format d'un bloc de missatges és:

```
<1 byte length><1 byte sequence><n-byte content><2 byte crc><1 byte sync>
```

El byte de longitud conté el nombre de bytes del bloc de missatges, inclosos els bytes de la capçalera i el tràiler (per tant, la longitud mínima del missatge és de 5 bytes). La longitud màxima del bloc de missatges és actualment de 64 bytes. El byte de seqüència conté un número de seqüència de 4 bits en els bits d'ordre inferior i els bits d'ordre superior sempre contenen 0x10 (els bits d'ordre superior es reserven per a un ús futur). Els bytes de contingut contenen dades arbitràries i el seu format es descriu a la secció següent. Els bytes crc contenen un CCITT [CRC] de 16 bits (https://en.wikipedia.org/wiki/Cyclic_redundancy_check) del bloc de missatges, inclosos els bytes de capçalera però exclosos els bytes del tràiler. El byte de sincronització és 0x7e.

El format del bloc de missatges està inspirat en marcs de missatges [HDLC](https://ca.wikipedia.org/wiki/HDLC). Igual que en HDLC, el bloc de missatges pot contenir opcionalment un caràcter de sincronització addicional a l'inici del bloc. A diferència de l'HDLC, un caràcter de sincronització no és exclusiu de l'enquadrament i pot estar present al contingut del bloc de missatges.

### Contingut del bloc de missatges

Cada bloc de missatges enviat des de l'amfitrió al microcontrolador conté una sèrie de zero o més ordres de missatge al seu contingut. Cada comanda comença amb una [Quantitat de longitud variable](#variable-length-quantities) (VLQ) identificador d'ordre enter codificat seguit de zero o més paràmetres VLQ per a l'ordre donada.

Com a exemple, les quatre ordres següents es poden col·locar en un únic bloc de missatges:

```
update_digital_out oid=6 value=1
update_digital_out oid=5 value=0
get_config
get_clock
```

i codificats en els vuit nombres enters VLQ següents:

```
<id_update_digital_out><6><1><id_update_digital_out><5><0><id_get_config><id_get_clock>
```

Per codificar i analitzar el contingut del missatge, tant l'amfitrió com el microcontrolador han d'acordar els identificadors de l'ordre i el nombre de paràmetres que té cada comanda. Així, a l'exemple anterior, tant l'amfitrió com el microcontrolador sabrien que "id_update_digital_out" sempre va seguit de dos paràmetres, i que "id_get_config" i "id_get_clock" tenen zero paràmetres. L'amfitrió i el microcontrolador comparteixen un "diccionari de dades" que mapeja les descripcions de les ordres (per exemple, "update_digital_out oid=%c value=%c") amb els seus identificadors d'ordres enters. En processar les dades, l'analitzador sabrà esperar un nombre específic de paràmetres codificats VLQ seguint un identificador d'ordre donat.

El contingut del missatge per als blocs enviats des del microcontrolador a l'amfitrió segueix el mateix format. Els identificadors d'aquests missatges són "identificadors de resposta", però tenen el mateix propòsit i segueixen les mateixes regles de codificació. A la pràctica, els blocs de missatges enviats des del microcontrolador a l'amfitrió mai contenen més d'una resposta al contingut del bloc de missatges.

#### Quantitats de longitud variable

Consulteu l'[article de la wikipedia](https://en.wikipedia.org/wiki/Variable-length_quantity) per obtenir més informació sobre el format general dels nombres enters codificats VLQ. Klipper utilitza un esquema de codificació que admet nombres enters positius i negatius. Els enters propers a zero utilitzen menys bytes per codificar i els enters positius normalment codifiquen amb menys bytes que els enters negatius. La taula següent mostra el nombre de bytes que cada nombre sencer necessita per codificar:

| Enter | Mida codificada |
| --- | --- |
| -32 .. 95 | 1 |
| -4096 .. 12287 | 2 |
| -524288 .. 1572863 | 3 |
| -67108864 .. 201326591 | 4 |
| -2147483648 .. 4294967295 | 5 |

#### Cordes de longitud variable

Com a excepció a les regles de codificació anteriors, si un paràmetre d'una ordre o resposta és una cadena dinàmica, aleshores el paràmetre no es codifica com un simple enter VLQ. En lloc d'això, es codifica mitjançant la transmissió de la longitud com un nombre enter codificat VLQ seguit del propi contingut:

```
<VLQ encoded length><n-byte contents>
```

Les descripcions d'ordres que es troben al diccionari de dades permeten tant a l'amfitrió com al microcontrolador saber quins paràmetres d'ordres utilitzen una codificació VLQ senzilla i quins paràmetres utilitzen la codificació de cadena.

## Diccionari de dades

Per tal que s'estableixin comunicacions significatives entre el microcontrolador i l'amfitrió, ambdues parts han d'acordar un "diccionari de dades". Aquest diccionari de dades conté els identificadors d'enters per a les ordres i les respostes juntament amb les seves descripcions.

La construcció del microcontrolador utilitza el contingut de les macros DECL_COMMAND() i sendf() per generar el diccionari de dades. La compilació assigna automàticament identificadors únics a cada comanda i resposta. Aquest sistema permet que tant l'amfitrió com el codi del microcontrolador utilitzin noms descriptius llegibles per l'home sense problemes, sense deixar de fer servir un ample de banda mínim.

L'amfitrió consulta el diccionari de dades quan es connecta per primera vegada al microcontrolador. Una vegada que l'amfitrió descarrega el diccionari de dades del microcontrolador, fa servir aquest diccionari de dades per codificar totes les ordres i analitzar totes les respostes del microcontrolador. Per tant, l'amfitrió ha de gestionar un diccionari de dades dinàmics. Tanmateix, per mantenir el programari del microcontrolador senzill, el microcontrolador sempre utilitza el seu diccionari de dades estàtics (compilats).

El diccionari de dades es consulta enviant ordres "identifica" al microcontrolador. El microcontrolador respondrà a cada ordre d'identificació amb un missatge "identificar_resposta". Com que aquestes dues ordres són necessàries abans d'obtenir el diccionari de dades, els seus identificadors enters i tipus de paràmetres estan codificats tant al microcontrolador com a l'amfitrió. L'identificador de resposta "identificar_resposta" és 0, l'identificador de l'ordre "identificar" és 1. A part de tenir identificadors codificats, l'ordre d'identificació i la seva resposta es declaren i es transmeten de la mateixa manera que altres ordres i respostes. No hi ha cap altra ordre o resposta codificada.

El format del propi diccionari de dades transmeses és una cadena JSON comprimida zlib. El procés de creació del microcontrolador genera la cadena, la comprimeix i l'emmagatzema a la secció de text del flash del microcontrolador. El diccionari de dades pot ser molt més gran que la mida màxima del bloc de missatges: l'amfitrió el descarrega enviant diverses ordres d'identificació demanant fragments progressius del diccionari de dades. Un cop obtinguts tots els fragments, l'amfitrió els reunirà, descomprimirà les dades i analitzarà el contingut.

A més de la informació sobre el protocol de comunicació, el diccionari de dades també conté la versió del programari, les enumeracions (definides per DECL_ENUMERATION) i constants (tal com les defineix DECL_CONSTANT).

## Flux de missatges

Les ordres de missatge enviades des de l'amfitrió al microcontrolador estan pensades per estar lliures d'errors. El microcontrolador comprovarà el CRC i els números de seqüència de cada bloc de missatges per assegurar-se que les ordres són precises i en ordre. El microcontrolador sempre processa els blocs de missatges en ordre: si rep un bloc fora d'ordre, el descartarà i qualsevol altre bloc fora d'ordre fins que rebi blocs amb la seqüenciació correcta.

El codi amfitrió de baix nivell implementa un sistema de retransmissió automàtica per als blocs de missatges perduts i corruptes enviats al microcontrolador. Per facilitar-ho, el microcontrolador transmet un "bloc de missatge de confirmació" després de cada bloc de missatge rebut amb èxit. L'amfitrió programa un temps d'espera després d'enviar cada bloc i es tornarà a transmetre si el temps d'espera expira sense rebre un "ack" corresponent. A més, si el microcontrolador detecta un bloc corrupte o fora d'ordre, pot transmetre un "bloc de missatge nu" per facilitar la retransmissió ràpida.

Un "ack" és un bloc de missatges amb contingut buit (és a dir, un bloc de missatges de 5 bytes) i un número de seqüència més gran que l'últim número de seqüència d'amfitrió rebut. Un "nak" és un bloc de missatges amb contingut buit i un número de seqüència menor que l'últim número de seqüència de l'amfitrió rebut.

El protocol facilita un sistema de transmissió "finestra" perquè l'amfitrió pugui tenir molts blocs de missatges destacats en vol alhora. (Això s'afegeix a les moltes ordres que poden estar presents en un bloc de missatges determinat.) Això permet una utilització màxima de l'ample de banda fins i tot en cas de latència de transmissió. El temps d'espera, la retransmissió, la finestra i el mecanisme de confirmació estan inspirats en mecanismes similars a [TCP](https://ca.wikipedia.org/wiki/Transmission_Control_Protocoltocol).

En l'altra direcció, els blocs de missatges enviats des del microcontrolador a l'amfitrió estan dissenyats per estar lliures d'errors, però no tenen una transmissió assegurada. (Les respostes no haurien de ser corruptes, però poden desaparèixer.) Això es fa per mantenir la implementació al microcontrolador senzilla. No hi ha un sistema de retransmissió automàtica per a les respostes: s'espera que el codi d'alt nivell sigui capaç de gestionar una resposta que falti ocasionalment (normalment tornant a sol·licitar el contingut o establir un programa recurrent de transmissió de respostes). El camp del número de seqüència dels blocs de missatges enviats a l'amfitrió sempre és un més gran que el darrer nombre de seqüències rebuts de blocs de missatges rebuts de l'amfitrió. No s'utilitza per fer un seguiment de seqüències de blocs de missatges de resposta.
