# Contact

Ce document fourni les informations de contact pour Klipper.

1. [Forum de la Communauté](#community-forum)
1. [Salon Discord](#discord-chat)
1. [J'ai une question au sujet de Klipper](#i-have-a-question-about-klipper)
1. [J'ai une demande d'ajout de fonctionnalité](#i-have-a-feature-request)
1. [A l'aide ! Ca ne fonctionne pas !](#help-it-doesnt-work)
1. [J'ai trouvé un bug dans le logiciel Klipper](#i-found-a-bug-in-the-klipper-software)
1. [J’apporte des modifications que j’aimerais inclure dans Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)
1. [Github Klipper](#klipper-github)

## Forum de la communauté

Il y a un [Serveur Communautaire Discourse Klipper](https://community.klipper3d.org) pour les discussions sur Klipper.

## Salon Discord

Un serveur Discord dédié à Klipper est là : <https://discord.klipper3d.org>.

Ce serveur, géré par une communauté de passionnés de Klipper, est dédié aux discussions sur Klipper. Il permet aux utilisateurs de discuter en temps réel.

## J'ai une question sur Klipper

La plupart des questions que nous recevons ont déjà une réponse dans la [documentation de Klipper](Overview.md). Assurez-vous de bien la lire et de suivre les instructions qui y sont fournies.

Il est également possible de rechercher des questions similaires sur le [Forum de la communauté Klipper](#community-forum).

Si vous souhaitez partager vos connaissances et votre expérience avec d'autres utilisateurs de Klipper, vous pouvez rejoindre le [Forum de la communauté Klipper](#community-forum) ou encore le [Salon Discord Klipper](#discord-chat). Il s'agit de deux communautés où les utilisateurs de Klipper peuvent discuter du logiciel avec d'autres.

De nombreuses questions que nous recevons sont relatives à l'impression 3D en général et ne sont pas spécifiques à Klipper. Si vous avez une question ou si vous rencontrez des problèmes d'impression en général, vous obtiendrez probablement une meilleure réponse en la posant sur un forum consacré à l'impression 3D dans la globalité ou bien sur un dédié au matériel de votre imprimante.

## J'ai une demande d'ajout de fonctionnalité

Toute nouvelle fonctionnalité nécessite d'avoir une personne intéressée et en capacité de la mettre en oeuvre. Si vous souhaitez aider à implémenter ou tester une fonctionnalité, nous pouvez consulter les développements en cours sur le [Forum de la Communauté Klipper](#community-forum). Le [Salon Discord Klipper](#discord-chat) est également là pour les discussions entre contributeurs.

## A l'aide ! Ca ne fonctionne pas !

Malheureusement, nous recevons beaucoup plus de demandes d'aide que nous ne pouvons en traiter. La majorité des rapports d'anomalie que nous recevons sont généralement liés à :

1. Des erreurs subtiles dans le matériel, ou
1. Ne pas avoir suivi toutes les étapes décrites dans la documentation de Klipper.

Si vous rencontrez des soucis, nous vous recommandons de lire attentivement la [documentation de Klipper](Overview.md) et de vérifier que toutes les étapes ont été suivies.

Si vous rencontrez des soucis d'impression, nous vous recommandons d'inspecter minutieusement votre imprimante pour voir s'il n'y a pas d'anomalies (joints, vis, fils, etc). Nous avons remarqué que la plupart des anomalies ne sont pas spécifiquement liées à Klipper. Si vous avez un problème avec votre imprimante, vous obtiendrez sûrement une meilleure réponse en recherchant sur un forum dédié à l'impression 3D en général ou bien sur un consacré au matériel de votre imprimante.

Il est également possible de rechercher des questions similaires sur le [Forum de la communauté Klipper](#community-forum).

Si vous souhaitez partager vos connaissances et votre expérience avec d'autres utilisateurs de Klipper, vous pouvez rejoindre le [Forum de la communauté Klipper](#community-forum) ou encore le [Salon Discord Klipper](#discord-chat). Il s'agit de deux communautés où les utilisateurs de Klipper peuvent discuter du logiciel avec d'autres.

## J'ai trouvé un bug dans le logiciel Klipper

Klipper est un projet open-source et nous apprécions quand des contributeurs diagnostiquent des erreurs dans le logiciel.

Les problèmes devraient être signalés dans le [Forum communautaire Klipper](#community-forum).

Il y a des informations importantes qui sont nécessaires pour pouvoir corriger un bug. Veuillez suivre ces étapes :

1. Assurez-vous que vous exécutez le code non modifié de <https://github.com/Klipper3d/klipper>. Si le code a été modifié ou provient d'une autre source, vous devez reproduire le problème sur le code non modifié de <https://github.com/Klipper3d/klipper> avant de le signaler.
1. Si possible, exécutez une commande `M112` immédiatement après que l'événement indésirable se soit produit. Klipper se met alors dans un "état d'arrêt" et des informations de débogage supplémentaires sont écrites dans le fichier journal.
1. Récupérez l'événement depuis le fichier journal Klipper. Ce journal a été conçu pour répondre aux questions courantes que les développeurs de Klipper se posent sur le logiciel et son environnement (version du logiciel, type de matériel, configuration, à quel moment l'anomalie eu lieu, et des centaines d'autres questions).
   1. Le fichier journal de Klipper est situé dans `/tmp/klippy.log` sur l'ordinateur "hôte" de Klipper (le Raspberry Pi).
   1. Un utilitaire comme "scp" ou "sftp" est nécessaire pour copier ce fichier journal sur votre ordinateur. L'utilitaire "scp" est fourni en standard avec les systèmes Linux et MacOS. Il existe des utilitaires scp disponibles gratuitement pour d'autres systèmes (par exemple, WinSCP). Si vous utilisez un utilitaire scp graphique qui ne peut pas copier directement `/tmp/klippy.log`, cliquez plusieurs fois sur `...` ou `dossier parent` jusqu'à ce que vous arriviez au répertoire racine, cliquez ensuite sur le dossier `tmp`, puis sélectionnez le fichier `klippy.log`.
   1. Copiez le fichier journal sur votre bureau afin de le joindre au rapport d'anomalie.
   1. Ne modifiez pas le fichier journal de quelque façon que ce soit ; ne fournissez pas un extrait non plus. Seul le fichier journal complet sans altération fournira les informations nécessaires.
   1. C'est une bonne idée de compresser le fichier journal avec zip ou gzip.
1. Ouvrez un nouveau sujet sur le [Forum communautaire Klipper](#community-forum) et fournissez une description claire du problème. Les autres contributeurs de Klipper devront comprendre quelles mesures ont été prises, quel était le résultat souhaité et quel résultat s'est effectivement produit. Le fichier journal Klipper compressé doit être joint à ce sujet.

## J’apporte des modifications que j’aimerais inclure dans Klipper

Klipper est un logiciel libre et nous apprécions les nouvelles contributions.

Les nouvelles contributions (que ce soit pour le code ou pour la documentation) sont soumises au moyen de Pull Requests Github. Référez-vous au document [CONTRIBUTIONS](CONTRIBUTION.md) pour connaître les informations importantes à ce sujet.

Il existe plusieurs [documents pour les développeurs](Overview.md#developer-documentation). Si vous avez des questions sur le code, vous pouvez également les poser sur le [Forum de la communauté Klipper](#community-forum) ou sur le [Discord de la communauté Klipper](#discord-chat).

## GitHub Klipper

Le GitHub de Klipper peut être utilisé par les contributeurs pour partager l'état de leur travail pour améliorer Klipper. On s'attend à ce que la personne qui ouvre un ticket github travaille activement sur la tâche donnée et soit celle qui effectue tout le travail nécessaire pour l'accomplir. Le GitHub de Klipper n'est pas utilisé pour les demandes, ni pour signaler des bogues, ni pour poser des questions. Utilisez plutôt le [Forum communautaire Klipper](#community-forum) ou le [Discord communautaire Klipper](#discord-chat).
