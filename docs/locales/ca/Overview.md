# Perspectiva general

Benvingut a la documentació de Klipper. Si comences amb Klipper, comença llegint els documents [funcionalitats](Features.md) and [instal·lació](Installation.md).

## Informació general

- [Funcionalitats](Features.md): Una llista detallada de les funcionalitats de Klipper.
- [Preguntes freqüents](FAQ.md): Preguntes freqüents.
- [Versions](Releases.md): L'historial de les versions de Klipper.
- [Canvis en la configuració](Config_Changes.md): Canvis recents en el programari que poden requerir que els usuaris hagin d'actualitzar els fitxers de configuració de la impressora.
- [Contacte](Contact.md): Informació sobre com s'ha de reportar els errors i comunicació general amb els desenvolupadors de Klipper.

## Instal·lació i configuració

- [Instal·lació](Installation.md): Guia per instal·lar el Klipper.
- [Referencies per a la configuració](Config_Reference.md): Descripció dels paràmetres de configuració.
   - [Distància de rotació](Rotation_Distance.md): Calculant el paràmetre rotation_distance del motor pas a pas.
- [Validació de la configuració](Config_checks.md): Verificar les configuracions bàsiques de pins en el fitxer de configuració.
- [Anivellat del llitl](Bed_Level.md): Informació sobre "anivellat del llit calent" en Klipper.
   - [Calibració delta](Delta_Calibrate.md): Calibratge de cinemàtiques tipus delta.
   - [Calibratge de la sonda](Probe_Calibrate.md): Calibratge de sondes Z automàtiques.
   - [BL-Touch](BLTouch.md): Configurar un "BL-Touch" com a Z probe.
   - [Anivellat manual](Manual_Level.md): Calibratge de finals de carrera Z (i similars).
   - [Mallat del llit](Bed_Mesh.md): Correcció de l'alçada del llit basat en localitzacions XY en forma de malla.
   - [Fase de final de carrera](Endstop_Phase.md): Posicionament precís al final de carrera Z assistit per el motor pas a pas.
- [Compensació de ressonància](Resonance_Compensation.md): Eina per a reduir els repics i ecos a les impressions.
   - [Mesurant ressonàncies](Measuring_Resonances.md): Informació de com emprar un accelerómetre adxl345 per mesurar les ressonàncies.
- [Previsió de pressió](Pressure_Advance.md): Calibratge de la pressió del filament del fusor.
- [G-Code](G-Codes.md): informació de les ordres suportades per Klipper.
- [Plantilla d'ordres](Command_Templates.md): Macros de G-code i evaluació condicional.
   - [Referència de l'estat](Status_Reference.md):Informació disponible de macros (i similars).
- [Controladors TMC](TMC_Drivers.md): Emprant els controladors pas a pas de Trinamic amb Klipper.
- [Inicialització del llit emprant varies MCU](Multi_MCU_Homing.md): Inicialització i compensació del llit emprant varies MCU.
- [Slicers](Slicers.md): Configurar el programa de llescat per a treballar amb Klipper.
- [Correcció del biaix](Skew_Correction.md): Ajustaments per a eixos que no son perfectament perpendiculars.
- [Eines PWM](Using_PWM_Tools.md): Guies per fer servir eines controlades per PWM com ara làsers i trepants.
- [Excloure objectest](Exclude_Object.md): Guia per implementar l'exclusió d'objectes.

## Documentació per a desenvolupadors

- [Perspectiva general del codi](Code_Overview.md): Els desenvolupadors han de llegir això abans que res.
- [Cinemàtiques](Kinematics.md): Detalls tècnics sobre com Klipper implementa el moviment.
- [Protocol](Protocol.md): Informació sobre el protocol de missatgeria emprat a baix nivell entre l'amfitrió i el microcontrolador.
- [Servidor API](API_Server.md): Informació relativa a la API de control i els comandaments de Klipper.
- [Ordres MCU](MCU_Commands.md): Descripció dels comandaments de baix nivell implementats en el software del micro controlador.
- [Protocol de bus CAN](CANBUS_protocol.md): Format dels missages de bus CAN de Klipper.
- [Depuració](Debugging.md): Informació de com comprovar i depurar Klipper.
- [Índexs de referencia](Benchmarks.md): Informació sobre els índexs de referència (BenchMarks) de Klipper.
- [Contribuir](CONTRIBUTING.md): Informació de com enviar i aportar millores a Klipper.
- [Compilació](Packaging.md): Informació sobre com compilar paquets de SO.

## Documents específics d'un dispositiu

- [Exemples de configuració](Example_Configs.md): informació de com afegir una configuració d'exemple a Klipper.
- [Actualitzacions de la targeta SD](SDCard_Updates.md): Programar un micro controlador copiant un binari a una targeta SD en el micro controlador.
- [Raspberry Pi com a micro controlador](RPi_microcontroller.md): Detalls per controlar dispositius connectats als ports GPIO d'una Raspberry Pi.
- [Beaglebone](Beaglebone.md): Detalls per executar Klipper en una Beaglebone.
- [Carregadors d'arrancada](Bootloaders.md): Informació per a desenvolupadors sobre programació del micro controlador.
- [Bus CAN](CANBUS.md): Infiormació sobre l'us del bus CAN a Klipper.
- [Sensor d'amplada del filament TSL1401CL](TSL1401CL_Filament_Width_Sensor.md)
- [Sensor d'efecte Hall d'amplada de filament](Hall_Filament_Width_Sensor.md)
