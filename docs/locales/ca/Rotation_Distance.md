# Distància de rotació

Els controladors de motor pas a pas a Klipper requereixen el paràmetre `rotation_distance` (distància de rotació) a cada [Secció de configuració del motor](Config_Reference.md#stepper). La `rotation_distance` és la quantitat de distància que l'eix es mou amb una revolució completa del motor pas a pas. Aquest document descriu com s'ha de configurar aquest valor.

## Obtenint rotation_distance a partir del passos per mm (o passos per distància)

Els dissenyadors de la impressora originalment calculen els `passos per mil·límetre` a partir de la distància d'una rotació sencera.Si es coneixen els passos per mm (steps_per_mm) es possible emprar aquesta fórmula general per obtenir la distància de rotació:

```
rotation_distance = <passos_complets_per_rotació> * <microspassos> / <passos_per_mm>
```

D'altre banda, si es disposa d'una configuració antiga de Klipper i es coneix el valor del paràmetre `step_distance`, es pot emprar aquesta fórmula:

```
rotation_distance =<passos_complets_per_rotació> * <micropassos> * <distància_de_passos>
```

El valor `<full_steps_per_rotation>`(pasos per revolució) es determinat pel tipus de motor pas a pas. La majoria dels motors són del tipus "1.8 graus" i per tant necessiten 200 passos sencers per fer una revolució sencera (360 dividit entre 1.8 són 200 passos). Hi ha motors que son de "0.9 graus" i necessiten 400 passos per revolució. Altres opcions són menys freqüents. Si hi ha dubtes, no emprar cap valor per a full_steps_per_rotation en el fitxer de configuració i emprar 200 en la fómula donada.

La configuració "<microssteps>" la determina el controlador del motor pas a pas. La majoria dels controladors utilitzen 16 micropassos. Si no esteu segur, configureu "microspasos: 16" a la configuració i utilitzeu 16 a la fórmula anterior.

Gairebé totes les impressores haurien de tenir un nombre sencer per a 'rotation_distance' als eixos de tipus X, Y i Z. Si la fórmula anterior dóna com a resultat una distància de rotació que es troba a 0,01 d'un nombre sencer, arrodoneix el valor final a aquest nombre_sencer.

## Calibrant rotation_distance a les extrusores

En una extrusora, la 'rotation_distance' és la distància que recorre el filament durant una rotació completa del motor pas a pas. La millor manera d'obtenir un valor precís per a aquesta configuració és utilitzar un procediment de 'mesura i retalla'.

Primer comenceu amb una estimació inicial de la distància de rotació. Això es pot obtenir des de [steps_per_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance) o [inspeccionant el maquinari](#extruder).

A continuació, utilitzeu el procediment d'assaig i error com s'indica:

1. Assegureu-vos que l'extrusora tingui filament, que l'hotend s'escalfi a una temperatura adequada i que la impressora estigui llesta per extruir.
1. Utilitzeu un marcador per posar una marca al filament a uns 70 mm de l'entrada del cos de l'extrusora. A continuació, utilitzeu un calibrador digital per mesurar la distància real d'aquesta marca amb la màxima precisió possible. Tingueu en compte això com a `<marca_inicial>`.
1. Extrudiu 50 mm de filament amb la següent seqüència d'ordres: "G91" seguit de "G1 E50 F60". Tingueu en compte 50 mm com a "<distància_de_extrusió_sol·licitada>". Espereu que l'extrusora acabi el moviment (trigarà uns 50 segons). És important utilitzar la velocitat d'extrusió lenta per a aquesta prova, ja que una velocitat més ràpida pot provocar una pressió alta a l'extrusora que distorsionarà els resultats. (No utilitzeu el "botó d'extrusió" als front-ends gràfics per a aquesta prova, ja que s'extrueixen a un ritme ràpid.)
1. Utilitzeu les pinces digitals per mesurar la nova distància entre el cos de l'extrusora i la marca del filament. Tingueu en compte això com a `<marca_final>`. A continuació, calculeu: `actual_extrude_distance = <marca_inicial> - <marca_final>`
1. Calculeu rotation_distance com: `rotation_distance = <distancia_rotació_prèvia> * <distancia_actual_extrusio> / <longitut_ordre_extrussió>` Arrodoneix la nova rotation_distance a tres decimals.

Si la longitut_actual_extrusio difereix de la longitut_ordre_extrusió en més d'uns 2 mm, és una bona idea realitzar els passos anteriors una segona vegada.

Nota: *no* utilitzeu un mètode de tipus 'd'assaig i error' per calibrar eixos de tipus x, y o z. El mètode 'mesura i retalla' no és prou precís per a aquests eixos i probablement conduirà a una configuració pitjor. En canvi, si cal, aquests eixos es poden determinar [mesurant les corretges, les politges i els visos sens fi] (#obtaining-rotation_distance-by-inspecting-the-hardware).

## Obtenció de rotation_distance inspeccionant el maquinari

És possible calcular rotation_distance amb el coneixement dels motors pas a pas i la cinemàtica de la impressora. Això pot ser útil si no es coneix els passos_per_mm o si es dissenya una impressora nova.

### Eixos accionats per corretja

És fàcil calcular rotation_distance per a un eix lineal que utilitza una corretja i una politja.

Primer determineu el tipus de corretja. La majoria de les impressores utilitzen un pas de corretja de 2 mm (és a dir, cada dent de la corretja està separada de 2 mm). A continuació, compta el nombre de dents de la politja del motor pas a pas. Aleshores, la distància de rotació es calcula com:

```
rotation_distance = <pas_de_corretja> * <nombre_de_dents_a_politja>
```

Per exemple, si una impressora té una corretja de 2 mm i utilitza una politja amb 20 dents, la distància de rotació és de 40.

### Eixos amb vis sense fi

És fàcil calcular la distància de rotació per als cargols comuns mitjançant la fórmula següent:

```
rotation_distance = <pas_de_rosca> * <nombre_de_fils>
```

Per exemple, el "cargol T8" comú té una distància de rotació de 8 (té un pas de 2 mm i té 4 fils separats).

Les impressores més antigues amb "barres roscades" només tenen una "rosca" al cargol i, per tant, la distància de rotació és el pas del cargol. (El pas del cargol és la distància entre cada ranura del cargol.) Així, per exemple, una vareta mètrica M6 té una distància de rotació d'1 i una vareta M8 té una distància de rotació d'1,25.

### Extrusor

És possible obtenir una distància de rotació inicial per a les extrusores mesurant el diàmetre de la "secció mecanitzada" que empeny el filament i utilitzant la fórmula següent: `rotation_distance = <diametre> * 3,14`

Si l'extrusora utilitza engranatges, també caldrà [determinar i establir la relació_engranatges](#using-a-gear_ratio) per a l'extrusora.

La distància de rotació real d'una extrusora variarà d'una impressora a una altra, ja que l'adherència del "secció mecanitzada" que enganxa el filament pot variar. Fins i tot pot variar entre bobines de filament. Després d'obtenir una distància de rotació inicial, utilitzeu el [procediment d'assaig i error] (#calibrating-rotation_distance-on-extruders) per obtenir una configuració més precisa.

## Utilitzant una relació d'engranatges

Establir una `gear_ratio` pot facilitar la configuració de la `rotation_distance` als passos que tenen una caixa d'engranatges (o similar) connectada. La majoria dels steppers no tenen una caixa d'engranatges; si no esteu segurs, no configureu `gear_ratio` a la configuració.

Quan s'estableix 'gear_ratio', la 'rotation_distance' representa la distància que es mou l'eix amb una rotació completa de l'engranatge final a la caixa d'engranatges. Si, per exemple, s'està utilitzant una caixa d'engranatges amb una relació "5:1", es podria calcular la distància de rotació amb [coneixement del maquinari] (#obtaining-rotation_distance-by-inspecting-the-hardware) i després afegir ` gear_ratio: 5:1` a la configuració.

Per als engranatges implementats amb corretges i politges, és possible determinar la relació d'engranatges comptant les dents de les politges. Per exemple, si un pas a pas amb una politja de 16 dents acciona la següent politja amb 80 dents, s'utilitzaria `gear_ratio: 80:16`. De fet, es podria obrir una "caixa d'engranatges" comuna de la prestatgeria i comptar-hi les dents per confirmar la seva relació d'engranatges.

Tingueu en compte que de vegades una caixa d'engranatges tindrà una relació de transmissió lleugerament diferent de la que s'anuncia. Els engranatges comuns del motor de l'extrusora BMG són un exemple d'això: s'anuncien com a "3:1", però en realitat utilitzen engranatges "50:17". (L'ús de números de dents sense un denominador comú pot millorar el desgast general de l'engranatge, ja que les dents no sempre engranen de la mateixa manera amb cada revolució.) La "caixa d'engranatges planetaris 5.18:1" comuna es configura amb més precisió amb `gear_ratio: 57:11. `.

Si s'utilitzen diversos engranatges en un eix, és possible proporcionar una llista separada per comes a gear_ratio. Per exemple, una caixa d'engranatges "5:1" que condueix una politja de 16 dents a 80 dents podria utilitzar `gear_ratio: 5:1, 80:16`.

En la majoria dels casos, gear_ratio s'hauria de definir amb nombres enters, ja que els engranatges i politges comuns tenen un nombre sencer de dents. Tanmateix, en els casos en què una corretja acciona una politja utilitzant fricció en lloc de dents, pot tenir sentit utilitzar un nombre de coma flotant en la relació d'engranatges (p. ex., `gear_ratio: 107.237:16`).
