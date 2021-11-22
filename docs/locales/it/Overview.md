# Panoramica

Benvenuto nella documentazione di Klipper. Se sei nuovo di Klipper, inizia con i documenti [features](Features.md) e [installation](Installation.md).

## Informazioni generali

- [Caratteristiche](Features.md): un elenco di funzionalità di alto livello in Klipper.
- [FAQ](FAQ.md): Domande frequenti.
- [Releases](Releases.md): La storia delle versioni di Klipper.
- [Modifiche alla configurazione](Config_Changes.md): recenti modifiche al software che potrebbero richiedere agli utenti di aggiornare il file di configurazione della stampante.
- [Contatto](Contact.md): Informazioni sulla segnalazione di bug e comunicazione generale con gli sviluppatori di Klipper.

## Installazione e configurazione

- [Installazione](Installation.md): Guida all'installazione di Klipper.
- [Riferimento di configurazione](Config_Reference.md): Descrizione dei parametri di configurazione.
   - [Distanza di rotazione](Rotation_Distance.md): Calcolo del parametro stepper rotation_distance.
- [Controlli di configurazione](Config_checks.md): verifica le impostazioni di base dei pin nel file di configurazione.
- [Livello del piatto](Bed_Level.md): Informazioni sul "livellamento del piatto" in Klipper.
   - [Calibrazione Delta](Delta_Calibrate.md): Calibrazione della cinematica delta.
   - [Calibrazione sonda](Probe_Calibrate.md): Calibrazione di sonde Z automatiche.
   - [BL-Touch](BLTouch.md): Configurare una sonda Z "BL-Touch".
   - [Livello manuale](Manual_Level.md): Calibrazione dei finecorsa Z (e simili).
   - [Maglia del letto](Bed_Mesh.md): Correzione dell'altezza del piatto basata sulle posizioni XY.
   - [Endstop phase](Endstop_Phase.md): Posizionamento finecorsa Z assistito da stepper.
- [Compensazione della risonanza](Resonance_Compensation.md): Uno strumento per ridurre le risonanze nelle stampe.
   - [Misurare le risonanze](Measuring_Resonances.md): Informazioni sull'uso dell'hardware dell'accelerometro adxl345 per misurare le risonanze.
- [Avanzamento pressione](Pressure_Advance.md): Calibra la pressione dell'estrusore.
- [Codici G](G-Codes.md): Informazioni sui comandi supportati da Klipper.
- [Modelli di comando](Command_Templates.md): Macro G-Code e valutazione condizionale.
   - [Riferimento stato](Status_Reference.md): informazioni disponibili per le macro (e simili).
- [Driver TMC](TMC_Drivers.md): Uso dei driver Trinamic per motori passo-passo con Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing e probing utilizzando più microcontrollori.
- [Slicers](Slicers.md): Configurare il software "slicer" per Klipper.
- [Correzione inclinazione](skew_correction.md): Regolazioni per assi non perfettamente squadrati.
- [Strumenti PWM](Using_PWM_Tools.md): Guida su come usare gli strumenti controllati da PWM come i laser o i mandrini.

## Documentazione per sviluppatori

- [Panoramica del codice](Code_Overview.md): Gli sviluppatori dovrebbero leggere prima questo.
- [Cinematica](Kinematics.md): Dettagli tecnici su come Klipper implementa il movimento.
- [Protocollo](Protocol.md): Informazioni sul protocollo di messaggistica di basso livello tra host e microcontrollore.
- [Server API](API_Server.md): Informazioni sulle API di comando e controllo di Klipper.
- [Comandi MCU](MCU_Commands.md): Una descrizione dei comandi di basso livello implementati nel software del microcontrollore.
- [Protocollo bus CAN](CANBUS_protocol.md): formato del messaggio Klipper CAN bus.
- [Debug](Debug.md): Informazioni su come testare e fare il debug di Klipper.
- [Benchmarks](Benchmarks.md): Informazioni sul metodo di benchmark Klipper.
- [Contribuire](CONTRIBUTING.md): Informazioni su come presentare miglioramenti a Klipper.
- [Packaging](Packaging.md): informazioni sulla creazione di pacchetti del sistema operativo.

## Documenti specifici del dispositivo

- [Configurazioni di esempio](Example_Configs.md): Informazioni su come aggiungere un file di configurazione di esempio a Klipper.
- [Aggiornamenti SDCard](SDCard_Updates.md): esegui il flashing di un microcontrollore copiando un file binario su una scheda SD nel microcontrollore.
- [Raspberry Pi come microcontrollore](RPi_microcontroller.md): Dettagli per controllare i dispositivi collegati ai pin GPIO di un Raspberry Pi.
- [Beaglebone](beaglebone.md): Dettagli per l'esecuzione di Klipper sulla PRU Beaglebone.
- [Bootloaders](Bootloaders.md): Informazioni per gli sviluppatori sul flashing del microcontrollore.
- [CAN bus](CANBUS.md): Informazioni sull'uso del CAN bus con Klipper.
- [Sensore larghezza filamento TSL1401CL](TSL1401CL_Filament_Width_Sensor.md)
- [Sensore di larghezza del filamento Hall](HallFilamentWidthSensor.md)
