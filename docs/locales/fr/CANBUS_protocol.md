# Protocole CANBUS

Ce document décrit le protocole qu'utilise Klipper pour communiquer sur la couche [CAN bus](https://en.wikipedia.org/wiki/CAN_bus). Voir <CANBUS.md> pour plus d'informations sur la configuration de canbus avec Klipper.

## Assignation de l'identifiant du micro-contrôleur

Klipper utilise uniquement les paquets CAN bus 2.0A de taille standard, limités à 8 octets de données et à un identificateur de bus CAN de 11 bits. Afin de permettre des communications efficaces, un identifiant (`canbus_nodeid`) de 1 octet est affecté à chaque microcontrôleur pour gérer les commandes et réponses Klipper. Les commandes Klipper émises du microcontrôleur vers l'hôte utilisent l'id du bus CAN `canbus_nodeid * 2 + 256`, tandis que les messages de retour du microcontrôleur vers l'hôte utilisent `canbus_nodeid' *2 + 256 + 1`.

Chaque microcontrôleur possède un identifiant unique attribué en usine qui est utilisé lors de l'attribution de l'id. Cet identifiant pout dépasser la taille d'un paquet CAN, un fonction de hash est utilisée pour génerer un id unique de 6 octets (`canbus_uuid`) à partir de l'id 'usine'.

## Messages 'Admin'

Les messages 'administratifs' sont utilisés pour l'attribution des id. Ces messages envoyés de l'hôte vers le microcontrôleur utilisent l'id `0x3f0̀` et les messages envoyés du microcontrôleur vers l'hôte utilisent l'id `0x3f1`. Tous les microcontrôleurs écoutent les messages en provenance de `0x3f0`. Cet id peut être considéré comme une adresse de multidiffusion.

### Message CMD_QUERY_UNASSIGNED

Cette commande interroge tous les microcontrôleurs pour lesquels aucun `canbus_nodeid`n'a été assigné. Ces microcontrôleurs non assignés, retournent un message RESP_NEED_NODEID.

Le format du message CMD_QUERY_UNASSIGNED est : `<1-octet pour le message_id = 0x00>`

### Message CMD_SET_KLIPPER_NODEID

Cette commande attribue un `canbus_nodeid` à partir du `canbus_uuid` du microcontrôleur.

Le format du message CMD_SET_KLIPPER_NODEID est : `<1 octet pour le message_id = 0x01><6 octets pour le canbus_uuid><1 octet pour le canbus_nodeid>`

### Message RESP_NEED_NODEID

Le format du message RESP_NODE_NODEID est : `<1 octet pour le message_id = 0x20><6 octets pour le canbus_uuid><1 octet pour le set_klipper_nodeid=0x01>`

## Paquets de données

Un microcontôleur ayant reçu un nodeid par la commande CMD_SET_KLIPPER_NODEID peut envoyer et recevoir des paquets de données.

Les données des paquets des messages utilisant l'identifiant de réception du bus CAN du nœud (`canbus_nodeid * 2 + 256`)' sont simplement ajoutés à la fin du tampon et lorsque un [mcu protocol message](Protocol.md) complet est trouvé son contenu est analysé et traité. Les données sont traitées comme un flux d'octets - il n'est pas nécessaire que le début d'un bloc de message Klipper soit aligné avec le début d'un paquet CAN bus.

De la même manière, les réponses sont renvoyées du micrcontrôleur à l'hôte en copiant les données du message dans un ou plusieurs paquets avec l'identifiant canbus (`canbus_nodeid * 2 + 256 + 1`).
