# Vue d'Ensemble

Bienvenue dans la documentation de Klipper. Si vous débutez avec Klipper, commencez par les sections [fonctionnalités](Features.md) et [installation](Installation.md).

## Informations générales

- [Fonctionnalités](Features.md) : Une liste avancée des fonctionnalités de Klipper.
- [FAQ](FAQ.md) : Foire aux questions.
- [Versions](Releases.md) : L'historique des versions de Klipper.
- [Modifications de configuration](Config_Changes.md) : Modifications récentes du logiciel qui peuvent nécessiter que les utilisateurs mettent à jour la configuration de leur imprimante.
- [Contact](Contact.md) : Informations sur les rapports d'anomalies et communication générale avec les développeurs de Klipper.

## Installation et Configuration

- [Installation](Installation.md) : Guide pour installer Klipper.
- [Référence de la configuration](Config_Reference.md) : Description de tous les paramètres de configuration.
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
- [G-Codes](G-Codes.md) : Informations sur les instructions prises en charge par Klipper.
- [Modèles de commande](Command_Templates.md) : Macros G-Code et évaluation conditionnelle.
   - [Référence des états](Status_Reference.md) : Informations disponibles pour les macros (et similaires).
- [Pilotes TMC](TMC_Drivers.md) : Utilisation des pilotes de moteurs pas à pas Trinamic avec Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing and probing using multiple micro-controllers.
- [Slicers](Slicers.md) : Configurer un logiciel "slicer" pour Klipper.
- [Correction de l'inclinaison](skew_correction.md) : Ajustements pour les axes qui ne sont pas parfaitement carrés.
- [Outils PWM](Using_PWM_Tools.md) : Guide sur l'utilisation des outils contrôlés par PWM tels que les lasers ou les broches.

## Documentation pour les Développeurs

- [Vue d'ensemble du code](Code_Overview.md) : Les développeurs devraient lire ceci en premier.
- [Cinématiques](Kinematics.md) : Détails techniques sur la façon dont Klipper met en œuvre le mouvement.
- [Protocole](Protocol.md) : Informations sur le protocole de messagerie de bas niveau entre l'hôte et le microcontrôleur.
- [API du Serveur](API_Server.md) : Informations sur l'API de commande et de contrôle de Klipper.
- [Commandes MCU](MCU_Commands.md) : Une description des commandes de bas niveau implémentées dans le logiciel du micro-contrôleur.
- [Protocole du bus CAN](CANBUS_protocol.md) : Format de message du bus CAN de Klipper.
- [Débogage](Debugging.md) : Informations sur la façon de tester et de déboguer Klipper.
- [Tests de charge](Benchmarks.md) : Informations sur la méthode de tests de charge de Klipper.
- [Contribuer](CONTRIBUTING.md) : Informations sur comment proposer des améliorations pour Klipper.
- [Packaging](Packaging.md) : Informations sur la construction de paquets de système d'exploitation.

## Documents Spécifiques pour Certains Appareils

- [Configs d'exemple](Example_Configs.md) : Informations sur l'ajout d'un exemple de fichier de configuration à Klipper.
- [Mises à jour par SDCard](SDCard_Updates.md) : Flasher le micro-contrôleur en copiant un binaire sur une carte SD.
- [Raspberry Pi en tant que Microcontrôleur](RPi_microcontroller.md) : Détails pour contrôler les appareils connectés aux broches GPIO d'un Raspberry Pi.
- [Beaglebone](beaglebone.md) : Détails pour l'exécution de Klipper sur le PRU Beaglebone.
- [Bootloaders](Bootloaders.md) : Informations pour les développeurs sur le flashage des microcontrôleurs.
- [Bus CAN](CANBUS.md) : Informations sur l'utilisation du bus CAN avec Klipper.
- [Capteur de largeur de filament TSL1401CL](TSL1401CL_Filament_Width_Sensor.md)
- [Détecteur de largeur de filament à effet hall](HallFilamentWidthSensor.md)
