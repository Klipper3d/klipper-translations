# Débogage

Ce document décrit certains des outils de débogage de Klipper.

## Exécution des tests de non-régression

Le référentiel principal Klipper GitHub utilise des "github actions" pour exécuter une série de tests de non-régression. Il peut être utile d'exécuter certains de ces tests localement.

La "vérification des espaces" dans le code source peut être exécutée avec :

```
./scripts/check_whitespace.sh
```

La suite de tests de non-régression Klippy nécessite les "dictionnaires de données" de nombreuses plates-formes. Le moyen le plus simple de les obtenir est de [les télécharger depuis github](https://github.com/Klipper3d/klipper/issues/1438). Une fois les dictionnaires de données téléchargés, utilisez les éléments suivants pour exécuter la suite de tests de non-régression :

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## Envoi manuel de commandes au microcontrôleur

Normalement, le processus hôte klippy.py est utilisé pour traduire les commandes gcode en commandes de microcontrôleur Klipper. Cependant, il est également possible d'envoyer manuellement ces commandes MCU (fonctions marquées avec la macro DECL_COMMAND() dans le code source de Klipper). Pour ce faire, exécutez :

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

Voir la commande "AIDE" dans l'outil pour plus d'informations sur sa fonctionnalité.

Certaines options en ligne de commande sont disponibles. Pour plus d'informations, exécutez : `~/klippy-env/bin/python ./klippy/console.py --help`

## Traduction des fichiers G-Code en commandes de microcontrôleur

Le code hôte Klippy peut être executé en mode batch pour produire les commandes bas niveau du microcontrôleur associées à un fichier gcode. L'inspection de ces commandes de bas niveau est utile pour essayer de comprendre les actions du matériel de bas niveau. Il peut également être utile de comparer la différence dans les commandes du microcontrôleur après un changement de code.

Pour exécuter Klippy dans ce mode batch, une seule étape est nécessaire pour générer le "dictionnaire de données" du microcontrôleur. Cela se fait en compilant le code du micro-contrôleur pour obtenir le fichier **out/klipper.dict** :

```
make menuconfig
make
```

Une fois que ce qui précède a été fait, il est possible d'exécuter Klipper en mode batch (voir [installation](Installation.md) pour les étapes nécessaires à la construction de l'environnement virtuel python et d'un fichier printer.cfg) :

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

L'opération ci-dessus produira un fichier **test.serial** avec la sortie série binaire. Cette sortie peut être traduite en texte lisible avec :

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

Le fichier résultant **test.txt** contient une liste lisible (par un humain) des commandes du microcontrôleur.

Le mode batch désactive certaines commandes de réponse / requête pour fonctionner. Par conséquent, il y aura des différences entre les commandes réelles et la sortie ci-dessus. Les données générées sont utiles pour les tests et l'inspection ; elles ne sont pas utiles en fonctionnement normal (vers un vrai microcontrôleur).

## Analyse de mouvements et enregistrement de données

Klipper prend en charge la journalisation de l'historique des mouvement, qui peut être analysé ultérieurement. Pour utiliser cette fonctionnalité, Klipper doit être démarré avec le [Serveur API](API_Server.md) activé.

L'enregistrement des données est activé avec l'outil `data_logger.py`. Par example :

```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog
```

Cette commande se connectera au serveur API de Klipper, s'abonnera aux informations d'état et de mouvement et consignera les résultats. Deux fichiers sont générés : un fichier de données compressées et un fichier d'index (par exemple, `mylog.json.gz` et `mylog.index.gz`). Après avoir démarré la journalisation, il est possible d'effectuer des impressions et d'autres actions - la journalisation se poursuivra en arrière-plan. Une fois la journalisation terminée, appuyez sur `ctrl-c` pour quitter l'outil `data_logger.py`.

Les fichiers résultants peuvent être lus et représentés graphiquement à l'aide de l'outil `motan_graph.py`. Pour générer des graphiques sur un Raspberry Pi, une seule étape est nécessaire pour installer le package "matplotlib" :

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Cependant, il peut être plus pratique de copier les fichiers de données sur une machine de bureau avec le code Python dans le répertoire `scripts/motan/`. Les scripts d'analyse de mouvement doivent s'exécuter sur n'importe quelle machine sur laquelle une version récente de [Python](https://python.org) et [Matplotlib](https://matplotlib.org/) est installée.

Les graphiques peuvent être générés avec une commande comme celle-ci :

```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

On peut utiliser l'option `-g` pour spécifier les jeux de données à représenter graphiquement (il faut un littéral Python contenant une liste de listes). Par exemple :

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

La liste des ensembles de données disponibles peut être trouvée en utilisant l'option `-l` - par exemple :

```
~/klipper/scripts/motan/motan_graph.py -l
```

Il est également possible de spécifier les options de tracé matplotlib pour chaque jeu de données :

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```

De nombreuses options matplotlib sont disponibles ; quelques exemples sont "color", "label", "alpha" et "linestyle".

L'outil `motan_graph.py` prend en charge plusieurs autres options de ligne de commande - utilisez l'option `--help` pour afficher une liste. Il peut également être pratique de visualiser/modifier le script [motan_graph.py](../scripts/motan/motan_graph.py) lui-même.

Les journaux de données brutes produits par l'outil `data_logger.py` suivent le format décrit dans [Serveur API](API_Server.md). Il peut être utile d'inspecter les données avec une commande Unix comme celle-ci : `gunzip < mylog.json.gz | tr '\03' '\n' | moins`

## Génération de graphiques de charge

Le fichier journal Klippy (/tmp/klippy.log) stocke des statistiques sur la bande passante utilisée, la charge du microcontrôleur et la charge du tampon hôte. Il peut être utile de représenter graphiquement ces statistiques après une impression.

Pour générer un graphique, une seule étape est nécessaire pour installer le package "matplotlib" :

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Ensuite, les graphiques peuvent être produits avec :

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

On peut alors visualiser le fichier **loadgraph.png** résultant.

Différents graphiques peuvent être produits. Pour plus d'informations, exécutez : `~/klipper/scripts/graphstats.py --help`

## Extraire des informations du fichier klippy.log

Le fichier journal Klippy (/tmp/klippy.log) contient également des informations de débogage. Il existe un script logextract.py qui peut être utile lors de l'analyse d'un arrêt de microcontrôleur ou d'un problème similaire. Il est généralement exécuté avec quelque chose comme :

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

Le script extrait le fichier de configuration de l'imprimante et extrait les informations d'arrêt du MCU. Les vidages d'informations d'un arrêt de MCU (le cas échéant) sont réorganisés par horodatage pour faciliter le diagnostic des scénarios de cause à effet.

## Tester avec simulavr

L'outil [simulavr](http://www.nongnu.org/simulavr/) permet de simuler un microcontrôleur Atmel ATmega. Cette section décrit comment exécuter des fichiers gcode de test via simulavr. Il est recommandé de l'exécuter sur une machine de bureau (pas un Raspberry Pi) car il nécessite un processeur puissant pour fonctionner efficacement.

Pour utiliser simulavr, téléchargez le package simulavr et compilez avec le support python. Notez que le système de construction peut nécessiter l'installation de certains packages (tels que swig) afin de construire le module python.

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```

Assurez-vous qu'un fichier **./build/pysimulavr/_pysimulavr.*.so** est présent après la compilation ci-dessus :

```
ls ./build/pysimulavr/_pysimulavr.*.so
```

Cette commande doit signaler un fichier spécifique (par exemple **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**) et non une erreur.

Si vous êtes sur un système basé sur Debian (Debian, Ubuntu, etc.), vous pouvez installer les packages suivants et générer des fichiers *.deb pour une installation de simulavr à l'échelle du système :

```
sudo apt update
sudo apt install g++ make cmake swig rst2pdf help2man texinfo
make cfgclean python debian
sudo dpkg -i build/debian/python3-simulavr*.deb
```

Pour compiler Klipper pour une utilisation dans simulavr, exécutez :

```
cd /path/to/klipper
make menuconfig
```

et compilez le logiciel du microcontrôleur pour un AVR atmega644p et sélectionnez le support d'émulation du logiciel SIMULAVR. Ensuite on peut compiler Klipper (lancer `make`) puis lancer la simulation avec :

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

Si vous avez installé python3-simulavr au niveau système, vous n'avez pas besoin de définir `PYTHONPATH`, et vous pouvez simplement exécuter le simulateur comme

```
./scripts/avrsim.py out/klipper.elf
```

Ensuite, avec simulavr en cours d’exécution dans une autre fenêtre, on peut exécuter ce qui suit pour lire le gcode d’un fichier (par exemple, « test.gcode »), le traiter avec Klippy, et l’envoyer à Klipper exécuté dans simulavr (voir [installation](Installation.md) pour les étapes nécessaires à la construction de l’environnement virtuel python) :

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### Utiliser simulavr avec gtkwave

Une fonctionnalité utile de simulavr est sa capacité à créer des fichiers de génération d'ondes avec la synchronisation exacte des événements. Pour ce faire, suivez les instructions ci-dessus, mais exécutez avrsim.py avec une ligne de commande comme celle-ci :

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

Ce qui précède créera un fichier **avrsim.vcd** avec des informations sur chaque modification des GPIO sur PORTA et PORTB. Ce fichier pourra ensuite être visualisé en utilisant gtkwave avec :

```
gtkwave avrsim.vcd
```
