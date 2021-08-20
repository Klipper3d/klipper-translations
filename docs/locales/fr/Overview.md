# Overview

Bienvenue dans la documentation de Klipper. Si vous débutez avec Klipper, commencez par les sections [fonctionnalités](Features.md) et [installation](Installation.md).

## Informations générales

- [Fonctionnalités](Features.md) : Une liste avancée des fonctionnalités de Klipper.
- [FAQ](FAQ.md) : Foire aux questions.
- [Versions](Releases.md) : L'historique des versions de Klipper.
- [Modifications de configuration](Config_Changes.md) : Modifications récentes du logiciel qui peuvent nécessiter que les utilisateurs mettent à jour la configuration de leur imprimante.
- [Contact](Contact.md) : Informations sur les rapports d'anomalies et communication générale avec les développeurs de Klipper.

## Installation and Configuration

- [Installation](Installation.md) : Guide pour installer Klipper.
- [Référence de la configuration](Config_Reference.md): Description de tous les paramètres de configuration.
   - [Distance de rotation](Rotation_Distance.md) : Calcul du paramètre rotation_distance du stepper.
- [Vérifications de la configuration](Config_checks.md) : Vérifier les paramètres de base des broches dans le fichier de configuration.
- [Niveau du Bed](Bed_Level.md) : Informations sur le "nivellement du bed" dans Klipper.
   - [Calibration delta](Delta_Calibrate.md) : Calibration de la cinématique du delta.
   - [Calibrage de la sonde](Probe_Calibrate.md) : Calibration automatiques des sondes Z.
   - [BL-Touch](BLTouch.md) : Configurer une sonde Z "BL-Touch".
   - [Niveau manuel](Manual_Level.md) : Calibrage des butées Z (et similaires).
   - [Maillage du bed](Bed_Mesh.md) : Correction de la hauteur du bed basée sur les emplacements XY.
   - [Phase de fin de course](Endstop_Phase.md) : Positionnement de la fin de course Z assisté par le stepper.
- [Compensation de résonance](Resonance_Compensation.md) : Un outil permettant de réduire la résonance durant les impressions.
   - [Mesurer les résonances](Measuring_Resonances.md) : Informations sur l'utilisation du matériel accélérométrique adxl345 pour mesurer les résonances.
- [Pressure advance](Pressure_Advance.md) : Calibrer la pression de l'extrudeur.
- [Slicers](Slicers.md) : Configurer un logiciel "slicer" pour Klipper.
- [Modèles de commande](Command_Templates.md) : Macros G-Code et évaluation conditionnelle.
   - [Référence des états](Status_Reference.md) : Informations disponibles pour les macros (et similaires).
- [Pilotes TMC](TMC_Drivers.md) : Utilisation des pilotes de moteurs pas à pas Trinamic avec Klipper.
- [Correction de l'inclinaison](skew_correction.md) : Ajustements pour les axes qui ne sont pas parfaitement carrés.
- [Outils PWM](Using_PWM_Tools.md) : Guide sur l'utilisation des outils contrôlés par PWM tels que les lasers ou les broches.
- [G-Codes](G-Codes.md): Information on commands supported by Klipper.

## Developer Documentation

- [Code overview](Code_Overview.md): Developers should read this first.
- [Kinematics](Kinematics.md): Technical details on how Klipper implements motion.
- [Protocol](Protocol.md): Information on the low-level messaging protocol between host and micro-controller.
- [API Server](API_Server.md): Information on Klipper's command and control API.
- [MCU commands](MCU_Commands.md): A description of low-level commands implemented in the micro-controller software.
- [CAN bus protocol](CANBUS_protocol.md): Klipper CAN bus message format.
- [Debugging](Debugging.md): Information on how to test and debug Klipper.
- [Benchmarks](Benchmarks.md): Information on the Klipper benchmark method.
- [Contributing](CONTRIBUTING.md): Information on how to submit improvements to Klipper.
- [Packaging](Packaging.md): Information on building OS packages.

## Device Specific Documents

- [Example configs](Example_Configs.md): Information on adding an example config file to Klipper.
- [SDCard Updates](SDCard_Updates.md): Flash a micro-controller by copying a binary to an sdcard in the micro-controller.
- [Raspberry Pi as Micro-controller](RPi_microcontroller.md): Details for controlling devices wired to the GPIO pins of a Raspberry Pi.
- [Beaglebone](beaglebone.md): Details for running Klipper on the Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Developer information on micro-controller flashing.
- [CAN bus](CANBUS.md): Information on using CAN bus with Klipper.
- [TSL1401CL filament width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](HallFilamentWidthSensor.md)
