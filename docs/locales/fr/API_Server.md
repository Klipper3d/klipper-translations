# Serveur API

Ce document décrit l'Interface de Programmation d'Applications (API) de Klipper. Cette interface permet à des applications externes d'interroger et de contrôler Klipper.

## Activer le socket API

Pour pouvoir utiliser les Serveur API, le logiciel hôte klippy.py doit être démarré avec le paramètre `-a`. Par exemple :

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

Cela force le logiciel hôte à créer un socket de domaine Unix. Un client peut alors ouvrir une connexion sur ce socket et envoyer des commandes à Klipper.

Voir le projet [Moonraker](https://github.com/Arksine/moonraker) pour un outil populaire qui peut transférer les requêtes HTTP vers le socket du serveur d'API de Klipper.

## Format de la demande

Les messages envoyés et reçus sur le socket sont des chaînes au format JSON et terminées par le caractère ASCII 0x03 :

```
<json_object_1><0x03><json_object_2><0x03>...
```

Klipper contiens un outil `scripts/whconsole.py` qui peut effectuer la mise en forme du message ci-dessus. Par exemple :

```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

Cet outil peut lire une série de commandes JSON à partir de l'entrée standard stdin, les envoyer à Klipper et afficher les résultats. Cet outil s'attend à avoir une commande JSON par ligne et il ajoute automatiquement le terminateur 0x03 avant d'envoyer les requêtes. (Le serveur d'API de Klipper ne attend pas un saut de ligne.)

## Protocole de l'API

Le protocole de commande utilisé sur le socket de communications est inspiré par [json-rpc](https://www.jsonrpc.org/).

Une requête pourrait ressembler à ça :

`{"id": 123, "method": "info", "params": {}}`

et une réponse pourrait ressembler à ça :

`{"id": 123, "result": {"state_message": "Printer is ready", "klipper_path": "/home/pi/klipper", "config_file": "/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6", "hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4 (v7l)", "state": "ready", "python_path": "/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}`

Toutes les requêtes doivent être un dictionnaire JSON. (Ce document utilise le terme Python 'dictionary' pour décrire un objet JSON - une affectation de paires Clé/Valeur comprises en deux parenthèses `{}`.)

le dictionnaire de requête doit contenir un paramètre "méthode" disponible dans les "points de terminaison" de Klipper.

Le dictionnaire de requête peut contenir un paramètre "params" qui doit être de type dictionnaire. Les "params" fournissent des informations de paramètre supplémentaires au "endpoint" Klipper qui traite la demande. Son contenu est spécifique au "endpoint".

Le dictionnaire de requête peut contenir un paramètre "id" qui peut être de n'importe quel type JSON. Si "id" est présent, alors Klipper répondra à la demande avec une réponse contenant cet "id". Si "id" est omis (ou défini sur une valeur JSON "null"), Klipper ne fournira aucune réponse à la requête. Un message de réponse est un dictionnaire JSON contenant "id" et "result". Le "résultat" est toujours un dictionnaire - son contenu est spécifique au "endpoint" traitant la demande.

Si le traitement d'un requête est en erreur, le message de réponse contiendra un champ "error" au lieu de "result". Par exemple, la requête : `{"id": 123, "method": "gcode/script", "params": {"script": "G1 X200"}}` pourrait retourner une erreur telle que :: `{"id": 123, "error": {"message": "Must home axis first: 200.000 0.000 0.000 [0.000]", "error": "WebRequestError"}}`

Klipper traite toujours les demandes dans l'ordre de leur réception. Cependant, certaines requêtes peuvent ne pas se terminer immédiatement, ce qui peut entraîner l'envoi de la réponse associée dans le désordre par rapport aux réponses d'autres requêtes. Une requête JSON ne suspend jamais le traitement des requêtes JSON suivantes.

## Abonnements

Certains "endpoint" de Klipper autorisent un "abonnement" pour de futurs messages asynchrone de mise à jour.

Par exemple :

`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{"key": 345}}}`

Peut répondre dans un premier temps :

`{"id": 123, "result": {}}`

et faire en sorte que Klipper envoie de futurs messages similaires à :

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

Une demande d'abonnement accepte un dictionnaire "response_template" dans le champ "params" de la demande. Ce dictionnaire "response_template" est utilisé comme modèle pour les futurs messages asynchrones - il peut contenir des paires clé/valeur arbitraires. Lors de l'envoi de ces futurs messages asynchrones, Klipper ajoutera un champ "params" contenant un dictionnaire avec un contenu spécifique "endpoint" au modèle de réponse, puis enverra ce modèle. Si un champ "response_template" n'est pas fourni, il s'agit par défaut d'un dictionnaire vide (`{}`).

## "endpoints" disponibles

Par convention, les "endpoints" de Klipper sont de la forme `<module_name>/<some_name>`. Lors d'une demande à un "endpoint", le nom complet doit être défini dans le paramètre "method" du dictionnaire de requête (par exemple, `{"method"="gcode/restart"}`).

### Info

Le point de terminaison "info" est utilisé pour obtenir des informations sur le système et la version de Klipper. Il est également utilisé pour fournir les informations de version du client à Klipper. Par exemple : `{"id": 123, "method": "info", "params": { "client_info": { "version": "v1"}}}`

S'il est présent, le paramètre "client_info" doit être un dictionnaire, mais ce dictionnaire peut avoir un contenu arbitraire. Les clients sont encouragés à fournir le nom du client et sa version logicielle lors de la première connexion au serveur API Klipper.

### arrêt d'urgence

Le point de terminaison "emergency_stop" est utilisé pour demander à Klipper de passer à un état "shutdown". Il se comporte de la même manière que la commande G-Code `M112`. Par exemple : `{"id": 123, "method": "emergency_stop"}`

### register_remote_method

Ce point de terminaison permet aux clients d'enregistrer des méthodes pouvant être appelées depuis klipper. Il renverra un objet vide en cas de succès.

Par exemple : `{"id": 123, "method": "register_remote_method", "params": {"response_template": {"action": "run_paneldue_beep"}, "remote_method": "paneldue_beep"}} renverra : `{"id": 123, "result": {}}`

La méthode distante `paneldue_beep` peut désormais être appelée depuis Klipper. Notez que si la méthode prend des paramètres, ils doivent être fournis en tant qu'arguments de mots clés. Voici un exemple de la façon dont il peut être appelé à partir d'un gcode_macro :

```
[gcode_macro PANELDUE_BEEP]
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

Lorsque la macro gcode PANELDUE_BEEP est exécutée, Klipper enverra ce qui suit sur le socket : `{"action": "run_paneldue_beep", "params": {"frequency": 300, "duration": 1.0}}`

### objects/list

Ce point de terminaison remonte la liste des "objets" disponibles de l'imprimante que l'on peut interroger (via le point de terminaison "objects/query"). Par exemple : `{"id": 123, "method": "objects/list"}` peut renvoyer : `{"id": 123, "result": {"objects": [" webhooks", "configfile", "heaters", "gcode_move", "query_endstops", "idle_timeout", "toolhead", "extruder"]}}`

### objects/query

Ce point de terminaison permet de retrouver des informations à partir d'objets de l'imprimante. Par exemple : `{"id": 123, "method": "objects/query", "params": {"objects": {"toolhead": ["position"], "webhooks": null}} }` peut renvoyer : `{"id": 123, "result": {"status": {"webhooks": {"state": "ready", "state_message": "L'imprimante est prête"} , "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3051555.377933684}}`

Le paramètre "objects" dans la requête doit être un dictionnaire contenant des objets de l'imprimante à interroger - la clé contient le nom de l'objet imprimante et la valeur est soit "null" (pour interroger tous les champs) soit une liste de noms de champs.

Le message de réponse contiendra un champ "statut" contenant un dictionnaire avec les informations demandées - la clé contient le nom de l'objet imprimante et la valeur est un dictionnaire contenant ses champs. Le message de réponse contiendra également un champ "eventtime" contenant l'horodatage à partir duquel la requête a été prise.

Les champs disponibles sont documentés dans le document [Référence des états](Status_Reference.md).

### objects/subscribe

Ce point de terminaison permet d'interroger puis de s'abonner à des informations provenant d'objets de l'imprimante. La demande et la réponse du point de terminaison sont identiques au point de terminaison "objects/query". Par exemple : `{"id": 123, "method": "objects/subscribe", "params": {"objects":{"toolhead": ["position"], "webhooks": ["state "]}, "response_template":{}}}` peut renvoyer : `{"id": 123, "result": {"status": {"webhooks": {"state": "prêt" }, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3052153.382083195}}` et entraîner des messages asynchrones ultérieurs tels que : `{"params": {"status": {"webhooks": {"state": "shutdown"}}, "eventtime": 3052165.418815847}}`

### gcode/help

Ce point de terminaison permet de retrouver les commandes G-Code disponibles qui ont une chaîne d'aide définie. Par exemple : `{"id": 123, "method": "gcode/help"}` peut renvoyer : `{"id": 123, "result": {"RESTORE_GCODE_STATE": "Restaurer un état G-Code précédemment enregistré", "PID_CALIBRATE": "Exécuter le test d'étalonnage PID", "QUERY_ADC": "Rapport de la dernière valeur d'une broche analogique", ...}}`

### gcode/script

Ce point de terminaison permet d'exécuter une série de commandes G-Code. Par exemple : `{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}`

Si le script G-Code fourni génère une erreur, une réponse d'erreur est générée. Cependant, si la commande G-Code produit une sortie vers le terminal, cette sortie n'est pas remontée dans la réponse. (Utilisez le point de terminaison "gcode/subscribe_output" pour obtenir la remontée des sortie du terminal G-Code.)

Si une commande G-Code est en cours de traitement lorsque cette demande est reçue, le script reçu sera mis en file d'attente. Ce délai peut être important (par exemple, si une commande d'attente de température de code G est en cours). Le message de réponse JSON est envoyé lorsque le traitement du script est entièrement terminé.

### gcode/restart

Ce point de terminaison permet de demander un redémarrage - il est similaire à l'exécution de la commande G-Code "RESTART". Par exemple : `{"id": 123, "method": "gcode/restart"}`

Comme pour le point de terminaison "gcode/script", ce point de terminaison ne se termine qu'après la fin de toutes les commandes G-Code en attente.

### gcode/firmware_restart

Ceci est similaire au point de terminaison "gcode/restart" - il implémente la commande G-Code "FIRMWARE_RESTART". Par exemple : `{"id": 123, "method": "gcode/firmware_restart"}`

Comme pour le point de terminaison "gcode/script", ce point de terminaison ne se termine qu'après la fin de toutes les commandes G-Code en attente.

### gcode/subscribe_output

Ce point de terminaison est utilisé pour s'abonner aux messages du terminal G-Code de Klipper. Par exemple : `{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{}}}` peut ultérieurement produire des messages asynchrones tels que : ` {"params": {"response": "// État de Klipper : Arrêt"}}`

Ce point de terminaison est destiné à prendre en charge l'interaction humaine via une interface "fenêtre de terminal". L'analyse du contenu de la sortie du terminal G-Code est déconseillée. Utilisez le point de terminaison "objects/subscribe" pour obtenir des mises à jour sur l'état de Klipper.

### motion_report/dump_stepper

Ce point de terminaison est utilisé pour s'abonner au flux de commandes interne stepper queue_step de Klipper pour un stepper. L'obtention de ces mises à jour de mouvement de bas niveau peut être utile à des fins de diagnostic et de débogage. L'utilisation de ce point de terminaison peut augmenter la charge système de Klipper.

Une requête peut ressembler à : `{"id": 123, "method":"motion_report/dump_stepper", "params": {"name": "stepper_x", "response_template": {}}}` et peut renvoyer : `{"id": 123, "result": {"header": ["interval", "count", "add"]}}` et peut produire ultérieurement des messages asynchrones tels que : `{"params": {"first_clock": 179601081, "first_time": 8.98, "first_position": 0, "last_clock": 219686097, "last_time": 10.984, "data": [[179601081, 1, 0 ], [29573, 2, -8685], [16230, 4, -1525], [10559, 6, -160], [10000, 976, 0], [10000, 1000, 0], [10000, 1000, 0], [10000, 1000, 0], [9855, 5, 187], [11632, 4, 1534], [20756, 2, 9442]]}}`

Le champ "en-tête" dans la réponse initiale à la requête est utilisé pour décrire les champs présents dans les réponses "données" ultérieures.

### motion_report/dump_trapq

Ce point de terminaison est utilisé pour s'abonner à la "file d'attente de mouvements trapézoïdaux" interne de Klipper. L'obtention de ces mises à jour de mouvement de bas niveau peut être utile à des fins de diagnostic et de débogage. L'utilisation de ce point de terminaison peut augmenter la charge système de Klipper.

Une requête peut ressembler à : `{"id": 123, "method": "motion_report/dump_trapq", "params": {"name": "toolhead", "response_template":{}}}` et peut renvoyer : `{"id": 1, "result": {"header": ["time", "duration", "start_velocity", "acceleration", "start_position", "direction"]}} ` et peut produire ultérieurement des messages asynchrones tels que : `{"params": {"data": [[4.05, 1.0, 0.0, 0.0, [300.0, 0.0, 0.0], [0.0, 0.0, 0.0] ], [5.054, 0.001, 0.0, 3000.0, [300.0, 0.0, 0.0], [-1.0, 0.0, 0.0]]]}}`

Le champ "en-tête" dans la réponse initiale à la requête est utilisé pour décrire les champs présents dans les réponses "données" ultérieures.

### adxl345/dump_adxl345

Ce point de terminaison est utilisé pour s'abonner aux données de l'accéléromètre ADXL345. L'obtention de ces mises à jour de mouvement de bas niveau peut être utile à des fins de diagnostic et de débogage. L'utilisation de ce point de terminaison peut augmenter la charge système de Klipper.

Une requête peut ressembler à : `{"id": 123, "method":"adxl345/dump_adxl345", "params": {"sensor": "adxl345", "response_template": {}}}` et pourrait renvoyer : `{"id": 123,"result":{"header":["time","x_acceleration","y_acceleration", "z_acceleration"]}}` et pourrait plus tard produire des messages asynchrones messages tels que : `{"params":{"overflows":0,"data":[[3292.432935,-535.44309,-1529.8374,9561.4], [3292.433256,-382.45935,-1606.32927,9561.48375]]}} `

Le champ "en-tête" dans la réponse initiale à la requête est utilisé pour décrire les champs présents dans les réponses "données" ultérieures.

### angle/dump_angle

Ce point de terminaison est utilisé pour s'abonner aux [données du capteur d'angle](Config_Reference.md#angle). L'obtention de ces mises à jour de mouvement de bas niveau peut être utile à des fins de diagnostic et de débogage. L'utilisation de ce point de terminaison peut augmenter la charge système de Klipper.

Une requête peut ressembler à : `{"id": 123, "method":"angle/dump_angle", "params": {"sensor": "my_angle_sensor", "response_template": {}}}` et peut renvoyer : `{"id": 123,"result":{"header":["time","angle"]}}` et peut produire ultérieurement des messages asynchrones tels que : `{ "params":{"position_offset":3.151562,"errors":0, "data":[[1290.951905,-5063],[1290.952321,-5065]]}}`

Le champ "en-tête" dans la réponse initiale à la requête est utilisé pour décrire les champs présents dans les réponses "données" ultérieures.

### pause_resume/cancel

Ce point final est similaire à l'exécution de la commande G-Code "PRINT_CANCEL". Par exemple : `{"id": 123, "method": "pause_resume/cancel"}`

Comme pour le point de terminaison "gcode/script", ce point de terminaison ne se termine qu'après la fin de toutes les commandes G-Code en attente.

### pause_resume/pause

Ce point d'entrée est similaire à l'exécution de la commande G-Code "PAUSE". Par exemple : `{"id": 123, "method": "pause_resume/pause"}`

Comme pour le point de terminaison "gcode/script", ce point de terminaison ne se termine qu'après la fin de toutes les commandes G-Code en attente.

### pause_resume/resume

Ce point de terminaison est similaire à l'exécution de la commande G-Code "RESUME". Par exemple : `{"id": 123, "method": "pause_resume/resume"}`

Comme pour le point de terminaison "gcode/script", ce point de terminaison ne se termine qu'après la fin de toutes les commandes G-Code en attente.

### query_endstops/status

Ce point de terminaison interrogera les fins de course actifs et renverra leur état. Par exemple : `{"id": 123, "method": "query_endstops/status"}` peut renvoyer : `{"id": 123, "result": {"y": "open ", "x": "open", "z": "TRIGGERED"}}`

Comme pour le point de terminaison "gcode/script", ce point de terminaison ne se termine qu'après la fin de toutes les commandes G-Code en attente.
