# Verificació de la configuració

Aquest document conté una llista amb els passos per configurar l'us de pins al fitxer Klipper printer.cfg. Es recomana executar-los un cop acabats els passos a [instal·lació documents](installation.md).

Al llarg d'aquesta guia pot ser necessari fer canvis als fitxers de configuració de Klipper. És important executar l'ordre RESTART després de cada canvi a l'arxiu esmentat per assegurar que els canvis han tingut efecte (escriviu "restart" a la pestanya del terminal Octoprint i premeu "Send"). Es recomana també utilitzar l'ordre STATUS després de cada RESTART per verificar que aquest fitxer s'ha carregat correctament.

## Verificar la temperatura

Comenceu verificant que les temperatures s'estan informant correctament. Navegueu a la secció del gràfic de temperatura a la interfície d'usuari. Comproveu que la temperatura del broquet i del llit (si escau) estiguin presents i no augmenten. Si augmenta, desconnecteu l'alimentació de la impressora. Si les temperatures no són precises, reviseu els paràmetres "sensor_type" i "sensor_pin" per al broquet i/o el llit.

## Verificar M112

Navegueu a la consola d'ordres i emeteu una ordre M112 seguit d'ENTER. Aquesta ordre demana a Klipper que s'apagui. Això farà que es mostri un error, que es pot esborrar amb una ordre FIRMWARE_RESTART a la consola d'ordres. Octoprint també requerirà una nova connexió. A continuació, aneu a la secció del gràfic de temperatura i comproveu que les temperatures es continuïn actualitzant i que les temperatures no augmenten. Si les temperatures augmenten, apagueu l'alimentació de la impressora.

## Verificar els escalfadors

Dins la secció on hi ha el gràfic de temperatura escriviu 50 al quadre de temperatura de l'extrusora/eina. La gràfica hauria de mostrar un increment de temperatura (en uns 30 segons aproximadament). A continuació, aneu al quadre desplegable de temperatura de l'extrusora i seleccioneu "Desactivat". Després d'uns minuts, la temperatura hauria de començar a tornar al seu valor inicial de temperatura ambient. Si la temperatura no augmenta, comproveu la configuració "heater_pin" a la configuració.

Si la impressora disposa de llit calent, executa l’anterior comprovació amb el llit calent tambè.

## Verificar el pin ENABLE del motor pas a pas

eComproveu manualment que tots els eixos de la impressora es puguin moure lliurement (els motors pas a pas estan desactivats). Si no, emet una ordre M84 a la terminal d'ordres per desactivar els motors. Si algun dels eixos encara no es pot moure lliurement, comproveu la configuració "enable_pin" del pas a pas per a l'eix donat. A la majoria de motors pas a pas, el pin d'habilitació del motor és "active low" (actiu en estat baix) i, per tant, el pin d'habilitació hauria de tenir un "!" abans del pin (per exemple, "enable_pin: !PA1").

## Verificar els finals de carrera

Moure manualment tots els eixos de la impressora de manera que cap d'ells estigui en contacte amb un sensor de final. Envieu una ordre QUERY_ENDSTOPS mitjançant la consola d'ordres. Hauria de respondre amb l'estat actual de tots els extrems configurats i tots haurien d'informar d'un estat "obert". Per a cadascun dels sensors, torneu a executar l'ordre QUERY_ENDSTOPS mentre l'aactiveu manualment. L'ordre QUERY_ENDSTOPS hauria d'indicar que el sensor està "Activat" o tancat.

Si l'estat del sensor apareix invertit (informa "obert" quan s'activa i viceversa), afegiu un "!" a la definició del pin (per exemple, "endstop_pin: ^PA2"), o traieu el "!" si ja n'hi ha un present.

Si l’estat del sensor no canvia mai, normalment indica que el sensor donat s’ha connectat a un altre pin. Tant mateix , cal tenir present que moltes impressores fan servir una resistència “PullUp” que implica que el valor de endstop_pin ha d’estar precedit pel caràcter ‘^' per canviar el valor d’aquest paràmetre.

## Verificar els motors pas a pas

Utilitzeu l'ordre STEPPER_BUZZ per verificar la connectivitat de cada motor pas a pas. Comenceu col·locant manualment l'eix donat a un punt intermedi i, a continuació, executeu `STEPPER_BUZZ STEPPER=stepper_x` a la consola d'ordres. L'ordre STEPPER_BUZZ farà que el motor indicat es mogui un mil·límetre en una direcció positiva i després tornarà a la seva posició inicial. (Si el sensor de final de carrera es defineix a position_endstop=0, aleshores al començament de cada moviment serà en direcció contrària on està el sensor.) Realitzarà aquesta oscil·lació deu vegades.

Si el motor no es belluga res, verificar els valors de "enable_pin" i "step_pin" per a aquest motor. Si el motor es belluga però no retorna a la posició inicial, verificar el calor de "dir_pin". Si el motor oscil·la en una direcció incorrecta, generalment indicarà que el valor de "dir_pin" per a aquest axis està invertit. Per a això afegir "!" al valor de "dir_pin" o remoure'l en cas que hi sigui.

Si el motor no mostra cap activitat, verificar que la configuració de “enable_pin” i “step_pin” siguin els correctes per al motor. En cas que el motor es mogui però no retorni s la seva posició inicial, verificar la configuració del paràmetre “dir_pin”. Si el motor oscil·la en direccions incorrectes, indicarà que s’ha de canviar el valor de “dir_pin” per invertir el sentit de l’eix. Per això s’ha d’afegir, o suprimir en cas que hi sigui, el modificador “!” a l’inici del valor del pin. En el cas que el motor es mogui més d’1mm o menys mogui per excés o per defecte d’una forma significant, s’haurà de revisar el valor del paràmetre “rotation_distance”.

Després d’haver verificat el bon funcionament dels sensors de final de carrera i dels motors s’ha de verificar el mecanisme d’anada a l’inici (homing). Per això, enviar el comandament G28 per inicialitzar tots els eixos. En cas que la seqüència no s’inicïi correctament, desendollar el corrent de la impressora. Tornar a verificar els sensors de final de carrera i el moviment dels motors si és necessari.

## Verificar el motor de l'extrusor

Per provar el motor de l'extrusor serà necessari escalfar el bloc calefactor a temperatura d'impressió. Navegueu a la secció del gràfic de temperatura i seleccioneu una temperatura objectiu al quadre desplegable de temperatura (o introduïu manualment una temperatura adequada). Espereu que la impressora arribi a la temperatura desitjada. A continuació, aneu a la consola d'ordres i feu clic al botó "Extrusió". Comproveu que el motor de l'extrusora gira en la direcció correcta. Si no ho fa, consulteu els consells de resolució de problemes de la secció anterior per confirmar la configuració "enable_pin", "step_pin" i "dir_pin" per a l'extrusora.

## Calibrar els valors PID

Klipper suporta [controladores PID](https://ca.wikipedia.org/wiki/Proporcional_integral_derivatiu) per al fusor i el llit calent. Per tal de poder fer servir aquest algoritme és necessari calibrar els valors PID de cada impressora (valors PID trobats a altres firmware o a les configuracions d'exemple solen donar resultats molt pobres).

Per calibrar l'extrusora, aneu a la consola d'ordres i executeu l'ordre PID_CALIBRATE. Per exemple: `PID_CALIBRATE HEATER=extruder TARGET=170`

En acabar el procés de calibració envia el comandament `SAVE_CONFIG` per actualitzar el fitxer printer.cfg amb els nous valors de PID.

Si la impressora disposa de llit calent i permet ser governat mitjançant PWM (Modulació per ample de d'impulsos) aleshores es recomana fer servir el control PID per al llit calent. (Quan el llit calent s'acciona mitjançant l'algoritme PID pot ser que s'activi i desactivi el corrent 10 cops per segon, cosa. la qual no pot ser suportada per escalfadors connectats a un relé mecànic.) Un comandament típic per a fer el calibratge del llit calent sol ser: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Següents passos

La intenció d'aquesta guia és ajudar a verificar que la assignació de pins al fitxer de configuració del Klipper és correcte. S'ha de llegir també la guia [Nivellar el llit](Bed_Level.md). Llegir també la guia [Slicers](Slicers.md) per entendre com configurar el programa de laminat amb el Klipper.

Després de verificar que la impressió bàsica funciona correctament, és una bona idea el fet de considerar de calibrar [Previsió de pressió](Pressure_Advance.md).

Pot ser necessari haver de fer altres tipus de ajustaments més detallats - hi ha disponibles en línia una serie de guies per abordar aquests aspectes (com a exemple, cercar "calibrar impressora 3d"). Per exemple, si es presenta l'efecte 'ringing' (repetició) a les peces impreses, pots triar de seguir la guia [Compensació de ressonància](Resonance_Compensation.md) per ajustar els paràmetres necessaris.
