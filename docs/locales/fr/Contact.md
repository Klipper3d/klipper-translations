# Contact

Ce document fourni les informations de contact pour Klipper.

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Salon Discord

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

Ce serveur, géré par une communauté de passionnés de Klipper, est dédié aux discussions sur Klipper. Il permet aux utilisateurs de discuter en temps réel.

## J'ai une question sur Klipper

La plupart des questions que nous recevons ont déjà une réponse dans la [documentation de Klipper](Overview.md). Assurez-vous de bien la lire et de suivre les instructions qui y sont fournies.

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## J'ai une demande d'ajout de fonctionnalité

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## A l'aide ! Ca ne fonctionne pas !

Si vous rencontrez des soucis, nous vous recommandons de lire attentivement la [documentation de Klipper](Overview.md) et de vérifier que toutes les étapes ont été suivies.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## J'ai trouvé un bug dans le logiciel Klipper

Klipper est un projet open-source et nous apprécions quand des contributeurs diagnostiquent des erreurs dans le logiciel.

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

Il y a des informations importantes qui sont nécessaires pour pouvoir corriger un bug. Veuillez suivre ces étapes :

1. Assurez-vous que vous exécutez le code non modifié de <https://github.com/Klipper3d/klipper>. Si le code a été modifié ou provient d'une autre source, vous devez reproduire le problème sur le code non modifié de <https://github.com/Klipper3d/klipper> avant de le signaler.
1. Si possible, exécutez une commande `M112` immédiatement après que l'événement indésirable se soit produit. Klipper se met alors dans un "état d'arrêt" et des informations de débogage supplémentaires sont écrites dans le fichier journal.
1. Récupérez l'événement depuis le fichier journal Klipper. Ce journal a été conçu pour répondre aux questions courantes que les développeurs de Klipper se posent sur le logiciel et son environnement (version du logiciel, type de matériel, configuration, à quel moment l'anomalie eu lieu, et des centaines d'autres questions).
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. Copiez le fichier journal sur votre bureau afin de le joindre au rapport d'anomalie.
   1. Ne modifiez pas le fichier journal de quelque façon que ce soit ; ne fournissez pas un extrait non plus. Seul le fichier journal complet sans altération fournira les informations nécessaires.
   1. C'est une bonne idée de compresser le fichier journal avec zip ou gzip.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## J’apporte des modifications que j’aimerais inclure dans Klipper

Klipper est un logiciel libre et nous apprécions les nouvelles contributions.

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
