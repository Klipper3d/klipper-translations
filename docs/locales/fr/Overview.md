# Vue d'ensemble

Bienvenue dans la documentation de Klipper. Si vous débutez avec Klipper, commencez par les sections [fonctionnalités](Features.md) et [installation](Installation.md).

## Informations générales

- [Fonctionnalités](Features.md) : Une liste avancée des fonctionnalités de Klipper.
- [FAQ](FAQ.md) : Foire aux questions.
- [Versions](Releases.md) : L'historique des versions de Klipper.
- [Modifications de configuration](Config_Changes.md) : Modifications récentes du logiciel pouvant nécessiter que les utilisateurs mettent à jour la configuration de leur imprimante.
- [Contact](Contact.md) : Informations sur les rapports d'anomalies et communication générale avec les développeurs de Klipper.

## Installation et configuration

- [Installation](Installation.md) : Guide d'installation de Klipper.
- [Référence de la configuration](Config_Reference.md) : Description de tous les paramètres de configuration.
   - [Distance de rotation](Rotation_Distance.md) : Calcul du paramètre rotation_distance du moteur.
- [Vérifications de la configuration](Config_checks.md) : Vérification des paramètres de base des broches du fichier de configuration.
- [Nivelage du lit](Bed_Level.md) : Informations sur le "nivelage du lit" dans Klipper.
   - [Calibration delta](Delta_Calibrate.md) : Calibration de la cinématique Delta.
   - [Calibration de la sonde](Probe_Calibrate.md) : Calibration automatique des sondes Z.
   - [BL-Touch](BLTouch.md) : Configuration d'une sonde "BL-Touch".
   - [Nivelage manuel](Manual_Level.md) : Calibration des butées Z (et similaires).
   - [Maillage du lit](Bed_Mesh.md) : Correction de la hauteur du lit basée sur les emplacements XY.
   - [Phase de fin de course](Endstop_Phase.md) : Positionnement de la butée Z assisté par moteur.
- [Compensation de la résonance](Resonance_Compensation.md) : Un outil permettant de réduire la résonance durant les impressions.
   - [Mesure des résonances](Measuring_Resonances.md) : Informations sur l'utilisation d'un accéléromètre adxl345 pour mesurer les résonances.
- [Avance à la pression](Pressure_Advance.md) : Calibration de la pression dans l'extrudeur.
- [G-Codes](G-Codes.md) : Informations sur les instructions prises en charge par Klipper.
- [Modèles de commande](Command_Templates.md) : Macros G-Code et évaluation conditionnelle.
   - [Référence des états](Status_Reference.md) : Informations disponibles pour les macros (et similaires).
- [Pilotes TMC](TMC_Drivers.md) : Utilisation des pilotes de moteurs pas à pas Trinamic avec Klipper.
- [Prise origine multi-MCU](Multi_MCU_Homing.md): Mise à l'origine et palpage utilisant plusieurs micro-contrôleurs.
- [Trancheurs](Slicers.md) : Configuration d'un logiciel de "tranchage" pour Klipper.
- [Correction d'obliquité](Skew_Correction.md) : Ajustements des axes qui ne sont pas parfaitement d'équerre.
- [Outils PWM](Using_PWM_Tools.md) : Guide sur l'utilisation des outils contrôlés par PWM tels que les lasers ou les broches.
- [Exclusion d'objets](Exclude_Object.md) : Le guide de l'implémentation de l'exclusion d'objets.

## Documentation pour les développeurs

- [Aperçu du code](Code_Overview.md) : Les développeurs devraient lire ceci en premier.
- [Cinématiques](Kinematics.md) : Détails techniques sur la façon dont Klipper met en œuvre les mouvements.
- [Protocole](Protocol.md) : Informations sur le protocole de messagerie de bas niveau entre l'hôte et le microcontrôleur.
- [API du serveur](API_Server.md) : Informations sur l'API de commande et de contrôle de Klipper.
- [Commandes MCU](MCU_Commands.md) : Une description des commandes de bas niveau implémentées dans le logiciel du micro-contrôleur.
- [Protocole du bus CAN](CANBUS_protocol.md) : Format de messages du bus CAN de Klipper.
- [Débogage](Debugging.md) : Informations sur la façon de tester et déboguer Klipper.
- [Tests de charge](Benchmarks.md) : Informations sur la méthode de tests de charge de Klipper.
- [Contribuer](CONTRIBUTING.md) : Comment proposer des améliorations pour Klipper.
- [Packaging](Packaging.md) : Informations sur la construction de paquets de système d'exploitation.

## Documents spécifiques à certains appareils

- [Exemples de configurations](Example_Configs.md) : Informations sur l'ajout d'un exemple de fichier de configuration à Klipper.
- [Mises à jour par carte SD](SDCard_Updates.md) : Flasher le micro-contrôleur en copiant un binaire sur une carte SD.
- [Raspberry Pi en tant que micro-contrôleur](RPi_microcontroller.md) : Détails pour contrôler les appareils connectés aux broches GPIO d'un Raspberry Pi.
- [Beaglebone](Beaglebone.md) : Détails pour l'exécution de Klipper sur le SBC Beaglebone.
- [Bootloaders](Bootloaders.md) : Informations pour les développeurs sur le flashage des microcontrôleurs.
- [Bus CAN](CANBUS.md) : Informations sur l'utilisation du bus CAN avec Klipper.
- [Capteur de largeur de filament TSL1401CL](TSL1401CL_Filament_Width_Sensor.md)
- [Détecteur de largeur de filament à effet hall](Hall_Width_Sensor.md)
