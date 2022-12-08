# Modèles de commandes

Ce document fournit des informations sur l'implémentation des séquences de commandes G-Code dans les sections de configuration gcode_macro (et similaires).

## Nommage des macros de G-code

La casse n'est pas importante pour le nom de la macro G-Code - MA_MACRO et ma_macro évalueront la même chose et peuvent être appelées en majuscules ou en minuscules. Si des nombres sont utilisés dans le nom de la macro, ils doivent tous se trouver à la fin du nom (par exemple, TEST_MACRO25 est valide, mais MACRO25_TEST3 ne l'est pas).

## Formatage du G-Code dans la config

L'indentation est importante lors de la définition d'une macro dans le fichier de configuration. Pour spécifier une séquence G-Code multiligne, il est important que chaque ligne ait une indentation appropriée. Par exemple :

```
[gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

L'option de configuration `gcode:` commence toujours au début de la ligne et les lignes suivantes de la macro G-Code ne commencent jamais au début.

## Ajouter une description à votre macro

Pour vous aider à identifier la fonctionnalité, une courte description peut être ajoutée. Ajoutez `description :` avec un texte court pour décrire la fonctionnalité. La valeur par défaut est "Macro G-Code". Par exemple :

```
[gcode_macro blink_led]
description: Blink my_led one time
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

Le terminal affichera la description lorsque vous utiliserez la commande `HELP` ou la fonction de saisie semi-automatique.

## Enregistrer/Restaurer l'état pour les déplacements G-Code

Le langage de commande G-Code peut être difficile à utiliser. Le mécanisme standard pour déplacer la tête d'outil se fait via la commande `G1` (la commande `G0` est un alias pour `G1` et elle peut être utilisée à la place de G1 et inversement). Cependant, cette commande repose sur la configuration "G-Code parsing state" définie par `M82`, `M83`, `G90`, `G91`, `G92` et les commandes précédentes `G1`. Lors de la création d'une macro G-Code, il est conseillé de toujours définir explicitement l'état d'analyse du G-Code avant d'émettre une commande `G1`. (Sinon, il y a un risque que la commande `G1` fasse une demande indésirable.)

Une façon courante d'y parvenir consiste à encapsuler les mouvements `G1` avec `SAVE_GCODE_STATE`, `G91` et `RESTORE_GCODE_STATE`. Par exemple :

```
[gcode_macro MOVE_UP]
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state
  G91
  G1 Z10 F300
  RESTORE_GCODE_STATE NAME=my_move_up_state
```

La commande `G91` place l'état d'analyse du G-Code en "mode de déplacement relatif" et la commande `RESTORE_GCODE_STATE` restaure l'état tel qu'il était avant d'entrer dans la macro. Veillez à spécifier une vitesse explicite (via le paramètre `F`) sur la première commande `G1`.

## Extension du modèle

La section de configuration gcode_macro `gcode:` est évaluée à l'aide du langage Jinja2. On peut évaluer des expressions au moment de l'exécution en les entourant des caractères `{ }` ou utiliser des instructions conditionnelles avec des commande entourées par `{% %}`. Voir la [documentation Jinja2](http://jinja.pocoo.org/docs/2.10/templates/) pour plus d'informations sur la syntaxe.

Un exemple de macro complexe :

```
[gcode_macro clean_nozzle]
gcode:
  {% set wipe_count = 8 %}
  SAVE_GCODE_STATE NAME=clean_nozzle_state
  G90
  G0 Z15 F300
  {% for wipe in range(wipe_count) %}
    {% for coordinate in [(275, 4),(235, 4)] %}
      G0 X{coordinate[0]} Y{coordinate[1] + 0.25 * wipe} Z9.7 F12000
    {% endfor %}
  {% endfor %}
  RESTORE_GCODE_STATE NAME=clean_nozzle_state
```

### Paramètres de macro

Il est souvent utile d'inspecter les paramètres passés à la macro lorsqu'elle est appelée. Ces paramètres sont disponibles via la pseudo-variable `params`. Par exemple, si la macro :

```
[gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
```

a été appelé avec `SET_PERCENT VALUE=.2`, il sera évalué à `M117 Maintenant à 20 %`. Les noms de paramètres sont toujours en majuscules lorsqu'ils sont évalués dans la macro et sont toujours transmis sous forme de chaînes. Si vous effectuez des calculs, ils doivent être explicitement convertis en nombres entiers ou flottants.

Il est courant d'utiliser la directive Jinja2 `set` pour affecter un paramètre à une variable locale. Par exemple :

```
[gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp}
```

### La variable "rawparams"

Les paramètres complets non analysés pour la macro en cours d'exécution sont accessibles via la pseudo-variable `rawparams`.

Notez que cela inclura tous les commentaires qui faisaient partie de la commande d'origine.

Voir le fichier [sample-macros.cfg](../config/sample-macros.cfg) pour un exemple montrant comment remplacer la commande `M117` à l'aide de `rawparams`.

### La variable "printer"

Il est possible d'inspecter (et de modifier) l'état actuel de l'imprimante via la pseudo-variable `printer`. Par exemple :

```
[gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
```

Les champs disponibles sont définis dans le document [Status Reference](Status_Reference.md).

Important ! Les macros sont d'abord évaluées dans leur intégralité et ce n'est qu'ensuite que les commandes résultantes sont exécutées. Si une macro émet une commande qui modifie l'état de l'imprimante, les résultats de ce changement d'état ne seront pas visibles lors de l'évaluation de la macro. Cela peut également entraîner un comportement subtil lorsqu'une macro génère des commandes qui appellent d'autres macros, car la macro appelée est évaluée lorsqu'elle est invoquée (c'est-à-dire après l'évaluation complète de la macro appelante).

Par convention, le nom suivant immédiatement `printer` est le nom d'une section de configuration. Ainsi, par exemple, `printer.fan` fait référence à l'objet ventilateur créé par la section de configuration `[fan]`. Il existe quelques exceptions à cette règle, notamment les objets `gcode_move` et `toolhead`. Si la section de configuration contient des espaces, on peut y accéder via l'accesseur `[ ]` - par exemple : `printer["generic_heater my_chamber_heater"].temperature`.

Notez que la directive Jinja2 `set` permet d'affecter un objet dans la hiérarchie `printer` à une variable locale. Cela peut rendre les macros plus lisibles et réduire la saisie. Par exemple :

```
[gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
```

## Actions

Certaines commandes disponibles peuvent modifier l'état de l'imprimante. Par exemple, `{ action_emergency_stop() }` entraînera l'arrêt de l'imprimante. Ces actions sont executées au moment où la macro est évaluée, ce qui peut prendre beaucoup de temps avant que les commandes g-code générées ne soient exécutées.

Commandes "action" disponibles :

- `action_respond_info(msg)` : affiche le `msg` donné dans le pseudo-terminal /tmp/printer. Chaque ligne de `msg` sera envoyée avec un préfixe "//".
- `action_raise_error(msg)` : termine la macro actuelle (et toutes les macros appelantes) et écrit le `msg` donné sur le pseudo-terminal /tmp/printer. La première ligne de `msg` sera envoyée avec un préfixe "!!" et les lignes suivantes auront un préfixe "//".
- `action_emergency_stop(msg)` : Arrête l'imprimante. Le paramètre `msg` est facultatif, il peut être utile de décrire la raison de l'arrêt.
- `action_call_remote_method(method_name)` : appelle une méthode enregistrée par un client distant. Si la méthode prend des paramètres, ils doivent être fournis via des arguments de mots-clés, c’est-à-dire : `action_call_remote_method(« print_stuff », my_arg="hello_world »)`

## Variables

La commande SET_GCODE_VARIABLE peut être utile pour enregistrer l'état entre les appels de macro. Les noms de variables ne doivent pas contenir de caractères majuscules. Par exemple :

```
[gcode_macro start_probe]
variable_bed_temp: 0
gcode:
  # Save target temperature to bed_temp variable
  SET_GCODE_VARIABLE MACRO=start_probe VARIABLE=bed_temp VALUE={printer.heater_bed.target}
  # Disable bed heater
  M140
  # Perform probe
  PROBE
  # Call finish_probe macro at completion of probe
  finish_probe

[gcode_macro finish_probe]
gcode:
  # Restore temperature
  M140 S{printer["gcode_macro start_probe"].bed_temp}
```

Assurez-vous de prendre en compte le moment de l'évaluation de la macro et de l'exécution de la commande lors de l'utilisation de SET_GCODE_VARIABLE.

## Gcodes retardés

L'option de configuration [delayed_gcode] peut être utilisée pour exécuter une séquence gcode retardée :

```
[delayed_gcode clear_display]
gcode:
  M117

[gcode_macro load_filament]
gcode:
 G91
 G1 E50
 G90
 M400
 M117 Load Complete!
 UPDATE_DELAYED_GCODE ID=clear_display DURATION=10
```

Lorsque la macro `load_filament` ci-dessus s'exécute, elle affiche un message "Load Complete!" une fois l'extrusion terminée. La dernière ligne de gcode active le delay_gcode "clear_display", configuré pour s'exécuter en 10 secondes.

L'option de configuration `initial_duration` peut être définie pour exécuter le delay_gcode au démarrage de l'imprimante. Le compte à rebours commence lorsque l'imprimante passe à l'état "prêt". Par exemple, le delay_gcode ci-dessous s'exécutera 5 secondes après que l'imprimante soit prête, initialisant l'affichage avec "Welcome!" :

```
[delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
```

Il est possible qu'un gcode retardé se répète en le mettant à jour dans l'option gcode :

```
[delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
```

Le delay_gcode ci-dessus enverra "// Extruder Temp : [ex0_temp]" à Octoprint toutes les 2 secondes. Cela peut être annulé avec le gcode suivant :

```
UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
```

## Modèles de menus

Si une [section display_config](Config_Reference.md#display) est activée, il est alors possible de personnaliser le menu avec les sections de configuration [menu](Config_Reference.md#menu).

Les attributs en lecture seule suivants sont disponibles dans les modèles de menu :

* `menu.width` - largeur de l’élément (nombre de colonnes d’affichage)
* `menu.ns` - espace de noms de l'élément
* `menu.event` - nom de l'événement qui a déclenché le script
* `menu.input` - valeur d'entrée, uniquement disponible dans le contexte du script d'entrée

Les actions suivantes sont disponibles dans les modèles de menu :

* `menu.back(force, update)` : exécutera la commande de retour du menu, paramètres booléens facultatifs `<force>` et `<update>`.
   * Lorsque `<force>` est défini sur True, l'édition s'arrête également. La valeur par défaut est False.
   * Lorsque `<update>` est défini sur False, les éléments de conteneur parent ne sont pas mis à jour. La valeur par défaut est True.
* `menu.exit(force)` - exécutera la commande de sortie du menu, paramètre booléen facultatif `<force>` valeur par défaut False.
   * Lorsque `<force>` est défini sur True, l'édition s'arrête également. La valeur par défaut est False.

## Enregistrer les variables sur le disque

Si une [section de configuration save_variables](Config_Reference.md#save_variables) a été activée, `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>` peut être utilisé pour enregistrer la variable sur le disque afin qu'elle puisse être utilisée à travers les redémarrages. Toutes les variables stockées sont chargées dans le dictionnaire `printer.save_variables.variables` au démarrage et peuvent être utilisées dans les macros gcode. pour éviter les lignes trop longues, vous pouvez ajouter ce qui suit en haut de la macro :

```
{% set svv = printer.save_variables.variables %}
```

Par exemple, il pourrait être utilisé pour enregistrer l'état d'un extrudeur cyclope lors du démarrage d'une impression, assurez-vous que l'extrudeuse active est utilisée, au lieu de T0 :

```
[gcode_macro T1]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder1
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder1"'

[gcode_macro T0]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder"'

[gcode_macro START_GCODE]
gcode:
  {% set svv = printer.save_variables.variables %}
  ACTIVATE_EXTRUDER extruder={svv.currentextruder}
```
