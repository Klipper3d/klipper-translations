# Contact

Ce document fourni les informations de contact pour Klipper.

1. [Forum de la Communauté](#community-forum)
1. [Salon Discord](#discord-chat)
1. [J'ai une question au sujet de Klipper](#i-have-a-question-about-klipper)
1. [J'ai une demande d'ajout de fonctionnalité](#i-have-a-feature-request)
1. [A l'aide ! Ca ne fonctionne pas !](#help-it-doesnt-work)
1. [J'ai identifié un problème dans le logiciel Klipper](#i-have-diagnosed-a-defect-in-the-klipper-software)
1. [J’apporte des modifications que j’aimerais inclure dans Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)

## Forum de la communauté

Il y a un [Serveur Communautaire Discourse Klipper](https://community.klipper3d.org) pour les discussions sur Klipper.

## Salon Discord

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>.

Ce serveur, géré par une communauté de passionnés de Klipper, est dédié aux discussions sur Klipper. Il permet aux utilisateurs de discuter en temps réel.

## J'ai une question sur Klipper

La plupart des questions que nous recevons ont déjà une réponse dans la [documentation de Klipper](Overview.md). Assurez-vous de bien la lire et de suivre les instructions qui y sont fournies.

Il est également possible de rechercher des questions similaires sur le [Forum de la communauté Klipper](#community-forum).

Si vous souhaitez partager vos connaissances et votre expérience avec d'autres utilisateurs de Klipper, vous pouvez rejoindre le [Forum de la communauté Klipper](#community-forum) ou encore le [Salon Discord Klipper](#discord-chat). Il s'agit de deux communautés où les utilisateurs de Klipper peuvent discuter du logiciel avec d'autres.

De nombreuses questions que nous recevons sont relatives à l'impression 3D en général et ne sont pas spécifiques à Klipper. Si vous avez une question ou si vous rencontrez des problèmes d'impression en général, vous obtiendrez probablement une meilleure réponse en la posant sur un forum consacré à l'impression 3D dans la globalité ou bien sur un dédié au matériel de votre imprimante.

N'ouvrez pas d'Issue sur le dépôt GitHub de Klipper pour poser une question.

## J'ai une demande d'ajout de fonctionnalité

Toute nouvelle fonctionnalité nécessite d'avoir une personne intéressée et en capacité de la mettre en oeuvre. Si vous souhaitez aider à implémenter ou tester une fonctionnalité, nous pouvez consulter les développements en cours sur le [Forum de la Communauté Klipper](#community-forum). Le [Salon Discord Klipper](#discord-chat) est également là pour les discussions entre contributeurs.

N'ouvrez pas d'issue GitHub pour demander une fonctionnalité.

## A l'aide ! Ca ne fonctionne pas !

Malheureusement, nous recevons beaucoup plus de demandes d'aide que nous ne pouvons en traiter. La majorité des rapports d'anomalie que nous recevons sont généralement liés à :

1. Des erreurs subtiles dans le matériel, ou
1. Ne pas avoir suivi toutes les étapes décrites dans la documentation de Klipper.

Si vous rencontrez des soucis, nous vous recommandons de lire attentivement la [documentation de Klipper](Overview.md) et de vérifier que toutes les étapes ont été suivies.

Si vous rencontrez des soucis d'impression, nous vous recommandons d'inspecter minutieusement votre imprimante pour voir s'il n'y a pas d'anomalies (joints, vis, fils, etc). Nous avons remarqué que la plupart des anomalies ne sont pas spécifiquement liées à Klipper. Si vous avez un problème avec votre imprimante, vous obtiendrez sûrement une meilleure réponse en recherchant sur un forum dédié à l'impression 3D en général ou bien sur un consacré au matériel de votre imprimante.

Il est également possible de rechercher des questions similaires sur le [Forum de la communauté Klipper](#community-forum).

Si vous souhaitez partager vos connaissances et votre expérience avec d'autres utilisateurs de Klipper, vous pouvez rejoindre le [Forum de la communauté Klipper](#community-forum) ou encore le [Salon Discord Klipper](#discord-chat). Il s'agit de deux communautés où les utilisateurs de Klipper peuvent discuter du logiciel avec d'autres.

N'ouvrez pas d'Issue sur le dépôt GitHub de Klipper pour demander de l'aide.

## J'ai identifié un problème dans le logiciel Klipper

Klipper est un projet open-source et nous apprécions quand des contributeurs diagnostiquent des erreurs dans le logiciel.

Il y a des informations importantes qui sont nécessaires pour pouvoir corriger un bug. Veuillez suivre ces étapes :

1. Assurez-vous que le bug se trouve bien dans le logiciel Klipper. Si vous pensez "il y a un problème, ne j'arrive pas à comprendre pourquoi, c'est donc un bug dans Klipper", alors veuillez **ne pas** ouvrir d'issue GitHub. Dans ce cas, une personne intéressée et capable devra d'abord rechercher et diagnostiquer la cause racine de l'anomalie. Si vous souhaitez partager les résultats de vos recherches ou vérifier si d'autres utilisateurs rencontrent des problèmes similaires, vous pouvez consulter le [Forum de la Communauté Klipper](#community-forum).
1. Make sure you are running unmodified code from <https://github.com/KevinOConnor/klipper>. If the code has been modified or is obtained from another source, then you will need to reproduce the problem on the unmodified code from <https://github.com/KevinOConnor/klipper> prior to reporting an issue.
1. Si possible, exécutez une commande `M112` dans la fenêtre du terminal OctoPrint immédiatement que l'anomalie s'est produite. Cela bascule Klipper dans un "état d'arrêt" et entraîne l'écriture d'informations de débogage supplémentaires dans le fichier journal.
1. Récupérez l'événement depuis le fichier journal Klipper. Ce journal a été conçu pour répondre aux questions courantes que les développeurs de Klipper se posent sur le logiciel et son environnement (version du logiciel, type de matériel, configuration, à quel moment l'anomalie eu lieu, et des centaines d'autres questions).
   1. Le fichier journal de Klipper est situé dans `/tmp/klippy.log` sur l'ordinateur "hôte" de Klipper (le Raspberry Pi).
   1. Un utilitaire comme "scp" ou "sftp" est nécessaire pour copier ce fichier journal sur votre ordinateur. L'utilitaire "scp" est fourni en standard avec les systèmes Linux et MacOS. Il existe des utilitaires scp disponibles gratuitement pour d'autres systèmes (par exemple, WinSCP). Si vous utilisez un utilitaire scp graphique qui ne peut pas copier directement `/tmp/klippy.log`, cliquez plusieurs fois sur `...` ou `dossier parent` jusqu'à ce que vous arriviez au répertoire racine, cliquez ensuite sur le dossier `tmp`, puis sélectionnez le fichier `klippy.log`.
   1. Copiez le fichier journal sur votre bureau afin de le joindre au rapport d'anomalie.
   1. Ne modifiez pas le fichier journal de quelque façon que ce soit ; ne fournissez pas un extrait non plus. Seul le fichier journal complet sans altération fournira les informations nécessaires.
   1. Si le fichier journal est très volumineux (par exemple, plus de 2 Mo), il peut être nécessaire de le compresser avec zip ou gzip.

   1. Open a new github issue at <https://github.com/KevinOConnor/klipper/issues> and provide a clear description of the problem. The Klipper developers need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The Klipper log file **must be attached** to that ticket:![attach-issue](img/attach-issue.png)

## J’apporte des modifications que j’aimerais inclure dans Klipper

Klipper est un logiciel libre et nous apprécions les nouvelles contributions.

Les nouvelles contributions (que ce soit pour le code ou pour la documentation) sont soumises au moyen de Pull Requests Github. Référez-vous au document [CONTRIBUTION](CONTRIBUTION.md) pour connaître les informations importantes à ce sujet.

Il y a plusieurs [documentations pour les développeurs](Overview.md#developer-documentation). Si vous avez des questions sur le code, vous pouvez également les poser sur le [Forum de la communauté Klipper](#community-forum) ou sur le [Discord de la communauté Klipper](#discord-chat). Si vous souhaitez partager un état d'avancement, vous pouvez ouvrir une issue Github avec l'emplacement de votre code, un aperçu des modifications et une description de son état actuel.
