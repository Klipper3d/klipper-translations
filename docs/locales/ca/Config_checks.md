# Verificació de la configuració

Aquest document conté una llista amb els passos per configurar el pin del fitxer Klipper printer.cfg. Es recomana executar-los un cop acabats els passos a [instal·lació documents](installation.md).

Al llarg d'aquesta guia pot ser necessari fer canvis al fitxer config Klipper. És important executar l'ordre RESTART després de cada canvi a l'arxiu esmentat per assegurar que els canvis han tingut efecte (escriviu "restart" a la pestanya del terminal Octoprint i premeu "Send"). Es recomana també utilitzar l'ordre STATUS després de cada RESTART per verificar que aquest fitxer s'ha carregat correctament.

## Verificar la temperatura

Comença verificant que la temperatura s'ha desat correctament. Navega a la pestanya de temperatura Octoprint.

![octoprint-temperature](img/octoprint-temperature.png)

Verificar que la temperatura del fusor i el llit (si és aplicable ) són presents i no estan augmentant. Si augmenten, desconnecteu la impressora. Si la temperatura no és exacta, reviseu els ajustaments del "sensor_type" i del "sensor_pin" per al fusor i/o llit.

## Verificar M112

Navegar a la pestanya terminal de l’Octoprint i executar l'ordre M112 al camp de la terminal. Aquesta ordre fa que Klipper s’apagui i que l’Octoprint es desconnecti - navegar a l'àrea de connexió i fer clic a "Connect" per tal que Octoprint es connecti de nou. Després d'això, navegar de nou a la pestanya de temperatura d'Octoprint i comprovar que la temperatura segueix actualitzant-se i no augmenta. Si la temperatura augmenta, desconnecteu la impressora.

L’ordre M112 provoca que Klipper entri en un estat d’apagada. Per arreglar-ho, escriu l’ordre FIRMWARE_RESTART al la pestanya de terminal d’Octoprint

## Verificar els calentadors

Navegar fins la pestanya de temperatura de l’Octoprint i al camp corresponent a l’eina posar 50 seguit de la tecla de retorn. La gràfica de temperatura del fusor ha de començar a incrementar (en uns 30 segons aproximadament). Després, de la llista desplegable corresponent a l’eina, seleccionar l’opció “OFF”. Passats uns minuts, la temperatura ha de començar a tornar a la temperatura ambient. En cas que la temperatura no incrementi, verificar el valor de “heater_pin” al fitxer de configuració

Si la impressora disposa de llit calent, executa l’anterior comprovació amb el llit calent tambè.

## Verificar el pin ENABLE del motor pas a pas

Verificar que tots els eixos de la impressora es poden bellugar lliurement a mà (els motors pas a pas estan desactivats). Si no és així, enviar el comandament M84 per desactivar-los. Si algun dels eixos encara no es pot bellugar lliurement, verificar la configuració del pin ENABLE per a aquest eix. A la majoria de controladors de motors pas a pas, el pin ENABLE s’ha de configurar com a “active low” i a la definició del pin hi ha d’anar el símbol “!” precedínt al pin (per exemple, “enable_pin: !ar38”).

## Verificar els finals de carrera

Belluga manualment tots els eixos de tal forma que no es premi cap dels sensors de final de carrera. Envia l’ordre QUERY_ENDSTOPS a la pestanya de la terminal d’Octoprint. La resposta a aquest comandament hauria de ser que tots els sensors estan “OBERT” (open). Envia de nou el comandament QUERY_ENDSTOPS mentre manualment actives el sensor. El comandament hauria de mostrar el sensor activat com a “TANCAT/ACTIVAT”(triggered).

Si el sensor es mostra invertit i es detecta “obert” quan s’activa i viceversa, afegir “!” davant del nom del pin al fitxer de configuració (per exemple “endstop_pin: ^!ar3") o bé treure’l si ja hi és present.

Si l’estat del sensor no canvia mai, normalment indica que el sensor donat s’ha connectat a un altre pin. Tant mateix , cal tenir present que moltes impressores fan servir una resistència “pullup” que implica que el valor de endstop_pin ha d’estar precedit pel caràcter ‘^' per canviar el valor d’aquest paràmetre.

## Verificar els motors pas a pas

Emprar el comandament STEPPER_BUZZ per verificar la connectivitat de cada motor pas a pas. Per començar, situar l’eix a verificar a la meitat de recorregut i enviar el comandament `STEPPER_BUZZ STEPPER=stepper_x`. El comandament farà moure el motor un mil·límetre en el sentit positiu de l’eix i retornarà a la posició inicial (si el sensor de final de carrera es defineix a position_endstop=0 aleshores el moviment es farà allunyant-se del sensor). Això es durà a terme 10 vegades.

Si el motor no es belluga res, verificar els valors de "enable_pin" i "step_pin" per a aquest motor. Si el motor es belluga però no retorna a la posició inicial, verificar el calor de "dir_pin". Si el motor oscil·la en una direcció incorrecta, generalment indicarà que el valor de "dir_pin" per a aquest axis està invertit. Per a això afegir "!" al valor de "dir_pin" o remoure'l en cas que hi sigui.

Si el motor no mostra cap activitat, verificar que la configuració de “enable_pin” i “step_pin” siguin els correctes per al motor. En cas que el motor es mogui però no retorni s la seva posició inicial, verificar la configuració del paràmetre “dir_pin”. Si el motor oscil·la en direccions incorrectes, indicarà que s’ha de canviar el valor de “dir_pin” per invertir el sentit de l’eix. Per això s’ha d’afegir, o suprimir en cas que hi sigui, el modificador “!” a l’inici del valor del pin. En el cas que el motor es mogui més d’1mm o menys mogui per excés o per defecte d’una forma significant, s’haurà de revisar el valor del paràmetre “rotation_distance”.

Despeés d’haver verificat el bon funcionament dels sensors de final de carrera i dels motors s’ha de verificar el mecanisme d’anada a l’inici (homing). Per això, enviar el comandament G28 per inicialitzar tots els eixos. En cas que la seqüència no s’inicïi correctament, desendollar el corrent de la impressora. Tornar a verificar els sensors de final de carrera i el moviment dels motors si és necessari.

## Verificar el motor de l’extrussor

Per poder. Edificat el motor de l’extrussor, el fusor s’ha de posar en temperatura d’impressió. Seleccionar una temperatura de la llista desplegable de temperatures o entrar el valor numèric directament a la pestanya temperatures d’Octoprint. Esperar a que la temperatura seleccionada s’estabilitzi i prémer el botó “Extrude” del panell se control de l’Octoprint. Edificat que el motor fira en el sentit correcte. Si no ho fa, consulta la secció de localització i reparació d’errors de la secció anterior per confirmar que els valors de “enable_pin", "step_pin", i "dir_pin" estan ben configurats per a l’extrussor.

## Calibrar les configuracions del PID

Klipper suporta [controladores PID](https://ca.wikipedia.org/wiki/Proporcional_integral_derivatiu) per al fusor i el llit calent. Per tal de poder fer servir aquest algoritme és necessari calibrar els valors PID de cada impressora (valors PID trobats a altres firmware o a les configuracions d'exemple solen donar resultats molt pobres).

Per calibrar el PID de l’extrussor s’ha d’enviar el comandament PID_CALIBRATE a la pestanya Terminal de l’Octoprint. Per exemple: `PID_CALIBRATE HEATER=extruder TARGET=170`

En acabar el procés de calibració envia el comandament `SAVE_CONFIG` per actualitzar el fitxer printer.cfg amb els nous valors de PID.

Si la impressora disposa de llit calent i permet ser governat mitjançant PWM (Modulació d'amplada de pulsos) aleshores es recomana fer servir el control PID per al llit calent. (Quan el llit calent s'acciona mitjançant l'algoritme PID pot ser que s'activi i desactivi el corrent 10 cops per segon, cosa. la qual no pot ser suportada per escalfadors connectats a un relé mecànic.) Un comandament típic per a fer el calibratge del llit calent sol ser: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Següents passos

La intenció d'aquesta guia és ajudar a verificar que la assignació de pins al fitxer de configuració del Klipper és correcte. S'ha de llegir també la guia [Nivellar el llit](Bed_Level.md). Llegir també la guia [Slicers](Slicers.md) per entendre com configurar el programa de llescat amb el Klipper.

Després de verificar que la impressió bàsica funciona correctament, és una bona idea el fet de considerar de calibrar [Previsió de pressió](Pressure_Advance.md).

Pot ser necessari haver de fer altres tipus de ajustaments més detallats - hi ha disponibles en línia una serie de guies per abordar aquests aspectes (com a exemple, cercar "calibrar impressora 3d"). Per exemple, si es presenta l'efecte 'ringing' (repetició) a les peces impreses, pots triar de seguir la guia [Compensació de ressonància](Resonance_Compensation.md) per ajustar els paràmetres necessaris.
