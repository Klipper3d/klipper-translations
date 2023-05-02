# Exemples de configurations

Ce document contient des directives pour contribuer à un exemple de configuration Klipper dans le dépôt github de Klipper (situé dans le [répertoire config](../config/)).

Notez que le [serveur discord communautaire de Klipper](https://community.klipper3d.org) est une ressource utile pour trouver et partager des fichiers de configuration.

## Lignes directives

1. Sélectionnez le préfixe de nom de fichier de configuration approprié :
   1. Le préfixe `printer` est utilisé pour les imprimantes de stock vendues par un fabricant grand public.
   1. Le préfixe `generic` est utilisé pour une carte mère d'imprimante 3d qui peut être utilisée sur de nombreux modèles d'imprimantes.
   1. Le préfixe `kit` est destiné aux imprimantes 3D assemblées selon une spécification largement utilisée. Ces imprimantes «kit» se distinguent des imprimantes "normales" par le fait qu'elles ne soient pas vendues par un constructeur.
   1. Le préfixe `sample` est utilisé pour des "extraits" de configuration que l'on peut copier-coller dans le fichier de configuration principal.
   1. Le préfixe `example` est utilisé pour décrire la cinématique de l’imprimante. Ce type de configuration n’est généralement ajouté qu’avec le code d’un nouveau type de cinématique d’imprimante.
1. Tous les fichiers de configuration doivent se terminer par un suffixe `.cfg`. Les fichiers de configuration `printer` doivent se terminer par une année suivie de `.cfg` (par exemple, `-2019.cfg`). Dans ce cas, l'année est une année approximative où l'imprimante donnée a été vendue.
1. N'utilisez pas d'espaces ou de caractères spéciaux dans le nom du fichier de configuration. Le nom du fichier doit contenir uniquement les caractères `A-Z`, `a-z`, `0-9`, `-`, et `.`.
1. Klipper doit être capable de démarrer les fichiers de configuration d'exemple `printer`, `generic`, et `kit` sans erreur. Ces fichiers de configuration doivent être ajoutés au scénario de test de non régression [test/klippy/printers.test](../test/klippy/printers.test). Ajoutez les nouveaux fichiers de configuration à ce scénario de test dans la section appropriée et par ordre alphabétique dans cette section.
1. L'exemple de configuration doit correspondre à la configuration "standard" de l'imprimante. (Il existe trop de configurations "personnalisées" pour être suivies dans le référentiel principal de Klipper). De même, nous n'ajoutons de fichiers de configuration d'exemple que pour les imprimantes, les kits et les cartes contrôleur qui ont une bonne popularité (par exemple, il devrait y en avoir au moins une centaine en utilisation active). Pensez à utiliser le [Serveur communautaire Discourse de Klipper](https://community.klipper3d.org) pour les autres configurations.
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. Ne spécifiez pas `pressure_advance` dans un exemple de configuration, car cette valeur est spécifique au filament, et non au matériel de l'imprimante. De même, ne spécifiez pas les paramètres `max_extrude_only_velocity` et `max_extrude_only_accel`.
   1. Ne spécifiez pas une section de configuration contenant un chemin d'accès à l'hôte ou un matériel hôte. Par exemple, ne spécifiez pas les sections de configuration `[virtual_sdcard]` et `[temperature_host]`.
   1. Ne définissez que les macros qui utilisent une fonctionnalité spécifique à l'imprimante donnée ou pour définir les codes g généralement émis par les trancheurs configurés pour l'imprimante donnée.
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. Ne copiez pas la documentation du champ dans les fichiers de configuration d'exemple. (Faire cela crée une charge de maintenance car une mise à jour de la documentation nécessiterait alors de la modifier à de nombreux endroits.)
   1. Les exemples de fichiers de configuration ne doivent pas contenir de section "SAVE_CONFIG". Si nécessaire, copiez les champs pertinents de la section SAVE_CONFIG dans la section appropriée de la zone de configuration principale.
   1. Utilisez la syntaxe `field: value` au lieu de `field=value`.
   1. Lorsque vous ajoutez une `rotation_distance` pour une extrudeuse, il est préférable de spécifier un `gear_ratio` si l'extrudeuse a un mécanisme d'engrenage. Nous nous attendons à ce que la distance de rotation dans les exemples de configuration corresponde à la circonférence de l'engrenage denté dans l'extrudeuse - elle est normalement comprise entre 20 et 35 mm. Lorsque vous spécifiez un `gear_ratio`, il est préférable de spécifier les engrenages réels du mécanisme (par exemple, préférez `gear_ratio : 80:20` à `gear_ratio : 4:1`). Voir le document sur [la distance de rotation](Rotation_Distance.md#using-a-gear_ratio) pour plus d'informations.
   1. Évitez de définir des valeurs de champ fixées à leur valeur par défaut. Par exemple, il est inutile de spécifier `min_extrude_temp : 170` car c'est déjà la valeur par défaut.
   1. Dans la mesure du possible, les lignes ne devraient pas dépasser 80 colonnes.
   1. Évitez d'ajouter des messages d'attribution ou de révision dans les fichiers de configuration. (Par exemple, évitez d'ajouter des lignes telles que "ce fichier a été créé par ...".) Placez l'attribution et l'historique des modifications dans le message git commit.
1. N'utilisez pas de fonctionnalités obsolètes dans le fichier de configuration d'exemple.
1. Ne pas désactiver un système de sécurité par défaut dans un fichier de configuration d'exemple. Par exemple, une configuration ne doit pas spécifier un `max_extrude_cross_section` personnalisé. N'activez pas les fonctions de débogage. Par exemple, il ne doit pas y avoir de section de configuration `force_move`.
1. Toutes les cartes connues que Klipper prend en charge peuvent utiliser la vitesse de transmission série par défaut de 250000. Ne recommandez pas un débit en bauds différent dans un fichier de configuration d'exemple.

Les exemples de fichiers de configuration sont soumis en créant une "pull request" sur github. Veuillez également suivre les instructions du [document de contribution](CONTRIBUTING.md).
