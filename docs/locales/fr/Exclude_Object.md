# Exclure des objets

The `[exclude_object]` module allows Klipper to exclude objects while a print is in progress. To enable this feature include an [exclude_object config
section](Config_Reference.md#exclude_object) (also see the [command
reference](G-Codes.md#exclude-object) and [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.)

Contrairement à d'autres options de micrologiciel d'imprimante 3D, une imprimante exécutant Klipper utilise une suite de composants et les utilisateurs ont le choix de nombreuses options. Par conséquent, afin de fournir une expérience utilisateur cohérente, le module `[exclude_object]` établira un contrat ou une sorte d'API. Le contrat couvre le contenu du fichier gcode, la façon dont l'état interne du module est contrôlé, et la façon dont cet état est fourni aux clients.

## Aperçu du flux de travail

Le flux de travail typique de l'impression d'un fichier peut ressembler à ceci :

1. Le tranchage est terminé et le fichier a été téléchargé pour être imprimé. Pendant le téléchargement, le fichier est traité et des marqueurs `[exclude_object]` sont ajoutés au fichier. Alternativement, les trancheurs peuvent être configurés pour préparer les marqueurs d'exclusion d'objets de manière native ou dans leur propre étape de prétraitement.
1. Lorsque l'impression démarre, Klipper réinitialise l'[état](Status_Reference.md#exclude_object) de `[exclude_object]`.
1. Lorsque Klipper traite le bloc `EXCLUDE_OBJECT_DEFINE`, il met à jour l'état avec les objets connus et le transmet aux clients.
1. Le client peut utiliser ces informations pour présenter une interface à l'utilisateur afin de suivre la progression. Klipper mettra à jour l'état pour inclure l'objet en cours d'impression que le client peut utiliser à des fins d'affichage.
1. Si l'utilisateur demande l'annulation d'un objet, le client envoie une commande `EXCLUDE_OBJECT NAME=<name>` à Klipper.
1. Lorsque Klipper traite la commande, il ajoute l'objet à la liste des objets exclus et met à jour le statut du client.
1. Le client recevra l'état mis à jour de Klipper et pourra utiliser cette information pour refléter l'état de l'objet dans l'interface utilisateur.
1. Une fois l'impression terminée, l'état `[exclude_object]` continuera à être disponible jusqu'à ce qu'une autre action le réinitialise.

## Le fichier GCode

Le traitement particulier du gcode nécessaire à la prise en charge des objets exclus ne correspond pas aux caractéristiques de conception de départ de Klipper. Par conséquent, ce module exige que le fichier soit traité avant d'être envoyé à Klipper pour l'impression. L'utilisation d'un script de post-traitement dans le trancheur ou le traitement du fichier par un logiciel intermédiaire lors du téléchargement sont deux possibilités pour préparer le fichier pour Klipper. Un script de post-traitement de référence est disponible à la fois comme exécutable et comme bibliothèque python, voir [cancelobject-preprocessor](https://github.com/kageurufu/cancelobject-preprocessor).

### Définitions des objets

La commande `EXCLUDE_OBJECT_DEFINE` est utilisée pour fournir un résumé de chaque objet du fichier gcode à imprimer. Elle fournit le résumé d'un objet dans le fichier. Les objets n'ont pas besoin d'être définis pour être référencés par d'autres commandes. Le but principal de cette commande est de fournir des informations à l'interface utilisateur sans avoir à analyser le fichier gcode en entier.

Les définitions d'objets sont nommées, pour permettre aux utilisateurs de sélectionner facilement un objet à exclure, et des métadonnées supplémentaires peuvent être fournies pour permettre des affichages graphiques d'annulation. Les métadonnées actuellement définies comprennent une coordonnée X,Y `CENTER`, et une liste `POLYGON` de points X,Y représentant un contour minimal de l'objet. Il peut s'agir d'une simple boîte englobante ou d'une coque complexe permettant de visualiser les objets imprimés de manière plus détaillée. En particulier, lorsque les fichiers gcode comprennent plusieurs parties avec des régions limites qui se chevauchent, les points centraux deviennent difficiles à distinguer visuellement. `POLYGONS` doit être un tableau compatible json de points `[X,Y]`( tuples) sans espace. Les paramètres supplémentaires seront enregistrés sous forme de chaînes de caractères dans la définition de l'objet et fournis dans les mises à jour de l'état.

`EXCLUDE_OBJECT_DEFINE NAME=calibration_pyramid CENTER=50,50 POLYGON=[[40,40],[50,60],[60,40]]`

All available G-Code commands are documented in the [G-Code
Reference](./G-Codes.md#excludeobject)

## Informations sur le statut

The state of this module is provided to clients by the [exclude_object
status](Status_Reference.md#exclude_object).

L'état est réinitialisé lorsque :

- Le microprogramme Klipper est redémarré.
- Il y a une réinitialisation de la `[virtual_sdcard]`. Notamment, ceci est remis à zéro par Klipper au début d'une impression.
- Lorsqu'une commande `EXCLUDE_OBJECT_DEFINE RESET=1` est émise.

La liste des objets définis est représentée dans le champ d'état `exclude_object.objects`. Dans un fichier gcode bien défini, cela sera fait avec les commandes `EXCLUDE_OBJECT_DEFINE` au début du fichier. Cela fournira aux clients les noms et les coordonnées des objets afin que l'interface utilisateur puisse fournir une représentation graphique des objets si nécessaire.

Au fur et à mesure de l'impression, le champ d'état `exclude_object.current_object` sera mis à jour lorsque Klipper traitera les commandes `EXCLUDE_OBJECT_START` et `EXCLUDE_OBJECT_END`. Le champ `current_object` sera activé même si l'objet a été exclu. Les objets non définis marqués d'un `EXCLUDE_OBJECT_START` seront ajoutés aux objets connus pour aider à la mise en place de l'interface utilisateur, sans métadonnées supplémentaires.

Lorsque les commandes `EXCLUDE_OBJECT` sont émises, la liste des objets exclus est fournie dans le tableau `exclude_object.excluded_objects`. Comme Klipper anticipe le traitement du gcode à venir, il peut y avoir un délai entre le moment où la commande est émise et celui où le statut est mis à jour.
