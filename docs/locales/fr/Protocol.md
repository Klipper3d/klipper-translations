# Protocole

Le protocole de messagerie Klipper est utilisé pour la communication de bas niveau entre le logiciel hôte Klipper et le logiciel du microcontrôleur Klipper. À un niveau élevé, le protocole peut être considéré comme une série de chaînes de commandes et de réponses qui sont compressées, transmises, puis traitées du côté réception. Un exemple d'une séries de commandes dans un format non compressé lisible par l'homme pourrait ressembler à :

```
set_digital_out pin=PA3 value=1
set_digital_out pin=PA7 value=1
schedule_digital_out oid=8 clock=4000000 value=0
queue_step oid=7 interval=7458 count=10 add=331
queue_step oid=7 interval=11717 count=4 add=1281
```

Voir le document [commandes mcu](MCU_Commands.md) pour plus d'informations sur les commandes disponibles. Voir le document [deboguage](Debugging.md) pour plus d'informations sur la façon de traduire un fichier G-Code en commandes de microcontrôleur lisibles (par l'homme).

Cette page fournit une description de haut niveau du protocole de communication de Klipper. Elle décrit comment les messages sont déclarés, encodés au format binaire (le format de "compression") et transmis.

L'objectif du protocole est de permettre un canal de communication sans erreur entre l'hôte et le microcontrôleur avec une faible latence, une faible bande passante et une faible complexité pour le microcontrôleur.

## Interface du micro-contrôleur

Le protocole de transmission Klipper peut être considéré comme un mécanisme d' [Appel de procédure à distance](https://en.wikipedia.org/wiki/Remote_procedure_call) entre le microcontrôleur et l'hôte. Le logiciel du microcontrôleur déclare les commandes que l'hôte peut invoquer ainsi que les messages de réponse qu'il peut générer. L'hôte utilise ces informations pour ordonner au microcontrôleur d'effectuer des actions et d'interpréter les résultats.

### Déclaration des commandes

Le logiciel du microcontrôleur déclare une "commande" en utilisant la macro DECL_COMMAND() dans le code C. Par exemple :

```
DECL_COMMAND(command_update_digital_out, "update_digital_out oid=%c value=%c");
```

Ce qui précède déclare une commande nommée "update_digital_out". Cela permet à l'hôte "d'appeler" cette commande qui entraînerait l'exécution de la fonction C command_update_digital_out() dans le microcontrôleur. Ce qui précède indique également que la commande prend deux paramètres entiers. Lorsque le code C command_update_digital_out() est exécuté, un tableau contenant ces deux entiers lui sera transmis - le premier correspondant à 'oid' et le second correspondant à 'value'.

En général, les paramètres sont décrits avec une syntaxe de style printf() (par exemple, "%u"). Le formatage correspond directement à une vue "lisible" (par un Humain) des commandes (par exemple, "update_digital_out oid=7 value=1"). Dans l'exemple ci-dessus, "value=" est un nom de paramètre et "%c" indique que le paramètre est un entier. En interne, le nom du paramètre n'est utilisé que comme documentation. Dans cet exemple, le "%c" est également utilisé comme documentation pour indiquer que l'entier attendu a une taille de 1 octet (la taille déclarée de l'entier n'a pas d'impact sur l'analyse ou l'encodage).

La compilation du micrologiciel du microcontrôleur collectera toutes les commandes déclarées avec DECL_COMMAND(), déterminera leurs paramètres et s'arrangera pour qu'elles soient appelables.

### Déclaration des réponses

Pour envoyer des informations du microcontrôleur à l'hôte, des "réponses" sont générées. Celles-ci sont à la fois déclarées et transmises à l'aide de la macro C sendf(). Par example :

```
sendf("status clock=%u status=%c", sched_read_time(), sched_is_shutdown());
```

Ce qui précède transmet un message de réponse "status" qui contient deux paramètres entiers ("clock" et "status"). La construction du microcontrôleur trouve automatiquement tous les appels sendf() et génère des encodeurs pour eux. Le premier paramètre de la fonction sendf() décrit la réponse et il est dans le même format que les déclarations de commande.

L'hôte peut enregistrer une fonction de rappel pour chaque réponse. Ainsi, les commandes permettent à l'hôte d'invoquer des fonctions C dans le microcontrôleur et les réponses permettent au logiciel du microcontrôleur d'invoquer du code dans l'hôte.

La macro sendf() ne doit être appelée qu'à partir de commandes ou de gestionnaires de tâches, et elle ne doit pas être appelée à partir d'interruptions ou de timers. Le code n'a pas besoin d'émettre un sendf() en réponse à une commande reçue, le nombre d'appels à sendf() n'est pas limié, et il est possible d'appeler sendf() à tout moment à partir d'un gestionnaire de tâches.

#### Réponses de sortie

Pour simplifier le débogage, il existe également une fonction C output(). Par exemple :

```
output("La valeur de %u est %s avec une taille de %u.", x, buf, buf_len);
```

La fonction output() est similaire à printf() - elle est destinée à générer et formater des messages de débogage avec un affichage dans un format compréhensible (ndt : par un humain normalement constitué :-)).

### Déclarer des énumérations

Les énumérations permettent au code hôte d'utiliser des identificateurs de type chaîne pour des paramètres que le microcontrôleur gère comme des entiers. Ils sont déclarés dans le code du microcontrôleur - par exemple :

```
DECL_ENUMERATION("spi_bus", "spi", 0);

DECL_ENUMERATION_RANGE("pin", "PC0", 16, 8);
```

Dans le premier exemple, la macro DECL_ENUMERATION() définit une énumération pour les messages de commande/réponse avec un nom de paramètre "spi_bus" ou un nom de paramètre avec un suffixe "_spi_bus". Pour ces paramètres, la chaîne "spi" sera une valeur valide et elle sera transmise comme une valeur entière égale à zéro.

Il est également possible de déclarer une plage d'énumération. Dans le deuxième exemple, un paramètre "pin" (ou tout paramètre avec le suffixe "_pin") accepterait PC0, PC1, PC2, ..., PC7 comme valeurs valides. Les chaînes seront transmises comme des entiers 16, 17, 18, ..., 23.

### Déclaration de constantes

Les constantes peuvent être exportées. Par exemple, les éléments suivants :

```
DECL_CONSTANT("SERIAL_BAUD", 250000);
```

exporterait une constante nommée "SERIAL_BAUD" avec une valeur de 250000 du microcontrôleur vers l'hôte. Il est également possible de déclarer une constante de type chaîne - par exemple :

```
DECL_CONSTANT_STR("MCU", "pru");
```

## Encodage des message de bas niveau

Pour accomplir le mécanisme "RPC" ci-dessus, chaque commandes et réponses sont codées dans un format binaire pour la transmission. Cette section décrit le système de transmission.

### Blocs de message

Toutes les données envoyées de l'hôte au microcontrôleur et vice-versa sont contenues dans des "blocs de message". Un bloc de message a un en-tête de deux octets et une fin de trois octets. Le format d'un bloc de message est :

```
<1 byte length><1 byte sequence><n-byte content><2 byte crc><1 byte sync>
```

L'octet de longueur contient le nombre d'octets dans le bloc de message, y compris les octets d'en-tête et de fin (la longueur minimale du message est donc de 5 octets). La longueur maximale d'un bloc de message est de 64 octets. L'octet de séquence contient un numéro de séquence de 4 bits dans les bits de poids faible et les bits de poids fort contiennent toujours 0x10 (les bits de poids fort sont réservés pour une utilisation future). Les octets de contenu contiennent les données du message et leur format est décrit dans la section suivante. Les octets crc contiennent un [CCITT CRC 16 bits](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) du bloc de message incluant les octets d'en-tête mais excluant les octets de fin. L'octet de synchronisation est 0x7e.

Le format du bloc de message est inspiré des trames de message [HDLC](https://en.wikipedia.org/wiki/High-Level_Data_Link_Control). Comme dans HDLC, le bloc de message peut éventuellement contenir un caractère de synchronisation supplémentaire au début du bloc. Contrairement à HDLC, un caractère de synchronisation n'est pas propre au header et peut être présent dans le contenu du bloc de message.

### Contenu du bloc de message

Chaque bloc de message envoyé de l'hôte au microcontrôleur contient une série de zéro ou plusieurs commandes de message dans son contenu. Chaque commande commence par une [Quantité de longueur variable](#variable-length-quantities) (VLQ) encodé entier command-id suivi de zéro ou plusieurs paramètres VLQ pour la commande donnée.

Par exemple, les quatre commandes suivantes peuvent être placées dans un seul bloc de message :

```
update_digital_out oid=6 value=1
update_digital_out oid=5 value=0
get_config
get_clock
```

et codé dans les huit entiers VLQ suivants :

```
<id_update_digital_out><6><1><id_update_digital_out><5><0><id_get_config><id_get_clock>
```

Afin d'encoder et d'analyser le contenu du message, l'hôte et le microcontrôleur doivent s'accorder sur les identifiants de commande et le nombre de paramètres de chaque commande. Ainsi, dans l'exemple ci-dessus, l'hôte et le microcontrôleur savent que "id_update_digital_out" est toujours suivi de deux paramètres, et "id_get_config" et "id_get_clock" n'ont aucun paramètre. L'hôte et le microcontrôleur partagent un "dictionnaire de données" qui mappe les descriptions de commande (par exemple, "update_digital_out oid=%c value=%c") à leurs identifiants de commande "entiers". Lors du traitement des données, l'analyseur saura s'attendre à un nombre spécifique de paramètres codés VLQ après un identifiant de commande donné.

Le contenu des messages pour les blocs envoyés du microcontrôleur à l'hôte suit le même format. Les identifiants de ces messages sont des "identifiants de réponse", mais ils ont le même objectif et suivent les mêmes règles de codage. En pratique, les blocs de message envoyés du microcontrôleur à l'hôte ne contiennent jamais plus d'une réponse dans le contenu du bloc de message.

#### Quantités de longueur variable

Voir l'[article wikipedia sur les VLQ](https://en.wikipedia.org/wiki/Variable-length_quantity) pour plus d'informations sur le format général des entiers codés VLQ. Klipper utilise un schéma de codage qui prend en charge les entiers positifs et négatifs. Les entiers proches de zéro utilisent moins d'octets pour coder et les entiers positifs codés utilisent moins d'octets - en général - que les entiers négatifs. Le tableau suivant indique le nombre d'octets nécessaires à l'encodage de chaque entier :

| Integer | Taille encodée |
| --- | --- |
| -32 .. 95 | 1 |
| -4096 .. 12287 | 2 |
| -524288 .. 1572863 | 3 |
| -67108864 .. 201326591 | 4 |
| -2147483648 .. 4294967295 | 5 |

#### Chaînes de longueur variable

Une exception aux règles de codage ci-dessus, si le paramètre d'une commande ou d'une réponse est une chaîne dynamique, le paramètre n'est pas codé comme un simple entier VLQ. Au lieu de cela, il est codé en transmettant la longueur sous la forme d'un entier codé VLQ suivi du contenu de la chaîne lui-même :

```
<VLQ encoded length><n-byte contents>
```

Les descriptions de commande trouvées dans le dictionnaire de données permettent à la fois à l'hôte et au microcontrôleur de savoir quels paramètres de commande utilisent un codage VLQ simple et quels paramètres utilisent un codage de chaîne.

## Dictionnaire de données

Pour que des communications significatives soient établies entre le microcontrôleur et l'hôte, les deux parties doivent s'entendre sur un "dictionnaire de données". Ce dictionnaire de données contient les identificateurs entiers des commandes et des réponses ainsi que leurs descriptions.

La construction du micrologiciel du microcontrôleur utilise le contenu des macros DECL_COMMAND() et sendf() pour générer le dictionnaire de données. La construction attribue automatiquement des identifiants uniques à chaque commande et réponse. Ce système permet à la fois au code hôte et au code du microcontrôleur d'utiliser de manière transparente des noms descriptifs lisibles par l'homme tout en utilisant une bande passante minimale.

L'hôte interroge le dictionnaire de données lors de sa première connexion au microcontrôleur. Une fois que l'hôte a téléchargé le dictionnaire de données du microcontrôleur, il utilise ce dictionnaire de données pour coder toutes les commandes et analyser toutes les réponses du microcontrôleur. L'hôte doit donc gérer un dictionnaire de données dynamique. Cependant, pour garder le logiciel du microcontrôleur simple, le microcontrôleur utilise - lui - toujours son dictionnaire de données statique (compilé).

Le dictionnaire de données est demandé en envoyant des commandes "identify" au microcontrôleur. Le microcontrôleur répond à chaque commande d'identification par un message "identifier_response". Étant donné que ces deux commandes sont nécessaires avant d'obtenir le dictionnaire de données, leurs identifiants entiers et leurs types de paramètres sont codés en dur à la fois dans le microcontrôleur et dans l'hôte. L'identifiant de réponse "identifier_response" est 0, l'identifiant de commande "identify" est 1. En plus d'avoir des identifiants codés en dur, la commande d'identification et sa réponse sont déclarées et transmises de la même manière que les autres commandes et réponses. Aucune autre commande ou réponse n'est codée en dur.

Le format du dictionnaire de données transmis est une chaîne JSON compressée zlib. Le processus de construction du microcontrôleur génère la chaîne, la comprime et la stocke dans la section texte du flash du microcontrôleur. Le dictionnaire de données peut être beaucoup plus grand que la taille maximale du bloc de message - l'hôte le télécharge en envoyant plusieurs commandes d'identification demandant des blocs progressifs du dictionnaire de données. Une fois que tous les morceaux sont obtenus, l'hôte réassemble les morceaux, décompresse les données et analyse le contenu.

En plus des informations sur le protocole de communication, le dictionnaire de données contient également la version du logiciel, les énumérations (telles que définies par DECL_ENUMERATION) et les constantes (telles que définies par DECL_CONSTANT).

## Flux de messages

Les message de commande envoyées de l'hôte au microcontrôleur sont censées être sans erreur. Le microcontrôleur vérifiera le CRC et les numéros de séquence dans chaque bloc de message pour s'assurer que les commandes sont exactes et dans l'ordre. Le microcontrôleur traite toujours les blocs de message dans l'ordre - s'il reçoit un bloc dans le désordre, il le rejettera ainsi que tout autre bloc dans le désordre jusqu'à ce qu'il reçoive des blocs avec le bon séquencement.

Le code de bas niveau de l'hôte implémente un système de retransmission automatique des blocs de messages perdus ou corrompus envoyés au microcontrôleur. Pour faciliter cela, le microcontrôleur transmet un "bloc de message ack" après chaque bloc de message reçu avec succès. L'hôte planifie un délai après l'envoi de chaque bloc et il retransmettra si le délai expire sans recevoir de "ack" correspondant. De plus, si le microcontrôleur détecte un bloc corrompu ou dans le désordre, il peut transmettre un "bloc de message nak" pour faciliter une retransmission rapide.

Un "ack" est un bloc de message avec un contenu vide (c'est-à-dire un bloc de message de 5 octets) et un numéro de séquence supérieur au dernier numéro de séquence d'hôte reçu. Un "nak" est un bloc de message avec un contenu vide et un numéro de séquence inférieur au dernier numéro de séquence d'hôte reçu.

Le protocole facilite un système de transmission "fenêtré" : l'hôte peut avoir de nombreux blocs de messages en cours à la fois. (Ceci s'ajoute aux nombreuses commandes qui peuvent être présentes dans un bloc de message.) Cela permet une utilisation maximale de la bande passante même en cas de latence de transmission. Les mécanismes de temporisation, de retransmission, de fenêtrage et d'accusé de réception sont inspirés de mécanismes similaires de [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol).

Dans l'autre sens, les blocs de messages envoyés du microcontrôleur à l'hôte sont aussi conçus pour être sans erreur, mais ils n'ont pas de validation de transmission. (Les réponses ne doivent pas être corrompues, mais elles peuvent disparaître.) Cette conception a été choisie pour garder une mise en œuvre simple dans le microcontrôleur. Il n'y a pas de système de retransmission automatique des réponses - le code de haut niveau devrait être capable de gérer une réponse manquante occasionnelle (généralement en redemandant le contenu ou en établissant un calendrier récurrent de transmission des réponses). Le champ du numéro de séquence dans les blocs de message envoyés à l'hôte est toujours supérieur d'une unité au dernier numéro de séquence envoyé par l'hôte. Il n'est pas utilisé pour suivre les séquences de blocs de message de réponse.
