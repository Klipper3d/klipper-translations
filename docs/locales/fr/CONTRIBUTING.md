# Contribuer à Klipper

Merci de contribuer à Klipper ! Ce document décrit la procédure à suivre pour apporter des modifications à Klipper.

Veuillez consulter la [page de contact](Contact.md) pour obtenir des informations sur le signalement d'un problème ou pour obtenir des détails sur la manière de contacter les développeurs.

## Aperçu de la procédure de contribution

Les contributions à Klipper suivent généralement un processus de haut niveau :

1. Un soumissionnaire commence par créer une [GitHub Pull Request](https://github.com/Klipper3d/klipper/pulls) lorsqu'une soumission est prête à être déployée à grande échelle.
1. Lorsqu'un [relecteur](#reviewers) est disponible pour [réviser](#what-to-expect-in-a-review) la soumission, il s'attribuera la Pull Request sur GitHub. L'objectif de la révision est de rechercher les défauts et de vérifier que la soumission suit les directives documentées.
1. Après une révision réussie, le relecteur "approuve la révision" sur GitHub et un [mainteneur](#reviewers) commet la modification dans la branche principale de Klipper.

Lorsque vous travaillez sur des améliorations, pensez à lancer (ou à contribuer à) un sujet sur [Klipper Discourse](Contact.md). Une discussion continue sur le forum peut améliorer la visibilité du travail de développement et peut attirer d'autres personnes intéressées à tester le nouveau travail.

## A quoi s'attendre lors d'une révision

Les contributions à Klipper sont examinées avant d'être fusionnées. L'objectif principal du processus de révision est de vérifier l'absence de défauts et de s'assurer que la soumission respecte les directives spécifiées dans la documentation de Klipper.

Il est entendu qu'il existe de nombreuses façons d'accomplir une tâche ; l'objectif de la révision n'est pas de discuter de la "meilleure" mise en œuvre. Dans la mesure du possible, il est préférable que les discussions de la révision soient axées sur les faits et les mesures.

La majorité des soumissions donneront lieu à un retour d'information. Soyez prêt à obtenir un retour, à fournir des détails supplémentaires et à mettre à jour la soumission si nécessaire.

Ce que le relecteur recherche le plus souvent :


   1. La soumission est-elle exempte de défauts et est-elle prête à être déployée à grande échelle ?Les soumissionnaires sont censés tester leurs modifications avant de les soumettre. Les relecteurs recherchent les erreurs, mais ne testent pas, en général, les soumissions. Une soumission acceptée est souvent déployée sur des milliers d'imprimantes dans les quelques semaines qui suivent son acceptation. La qualité des soumissions est donc considérée comme une priorité.

   Le dépôt GitHub principal de [Klipper3d/klipper](https://github.com/Klipper3d/klipper) n'accepte pas les travaux expérimentaux. Les auteurs doivent effectuer les expérimentations, le débogage et les tests dans leurs propres dépôts. Le serveur [Klipper Discourse](Contact.md) est un bon endroit pour faire connaître les nouveaux travaux et trouver des utilisateurs désireux de fournir des commentaires concrets.

   Les soumissions doivent réussir tous les [tests de régression](Debugging.md).

   Lorsqu'ils corrigent un défaut dans le code, les soumissionnaires doivent avoir une compréhension générale de la cause fondamentale de ce défaut, et la correction doit cibler cette seule cause fondamentale.

   Les soumissions de code ne doivent pas contenir de code de débogage excessif, d'options de débogage, ni d'enregistrement de débogage à l'exécution.

   Les commentaires dans les soumissions de code doivent se concentrer sur l'amélioration de la maintenance du code. Les soumissions ne doivent pas contenir de "code commenté" ni de commentaires excessifs décrivant des implémentations passées. Il ne doit pas y avoir de commentaires excessifs de type "todo".

   Les mises à jour de la documentation ne doivent pas indiquer qu'il s'agit d'un "travail en cours".

   1. La demande apporte-t-elle un avantage "à fort impact" à des utilisateurs du monde réel effectuant des tâches du monde réel ?Les relecteurs doivent identifier, au moins dans leur propre esprit, à peu près "qui est le public cible", une échelle approximative de "la taille de ce public", le "bénéfice" qu'ils obtiendront, comment le "bénéfice est mesuré", et les "résultats de ces tests de mesure". Dans la plupart des cas, ces éléments sont évidents pour l'auteur et l'examinateur, et ne sont pas explicitement mentionnés lors d'un examen.

   Les soumissions à la branche principale de Klipper doivent avoir un public cible important. En règle générale, les soumissions doivent cibler une base d'au moins 100 utilisateurs du monde réel.

   Si un relecteur demande des détails sur les "avantages" d'une proposition, ne considérez pas cela comme une critique. Être capable de comprendre les avantages concrets d'un changement est une partie naturelle d'un examen.

   Lorsque l'on discute des avantages, il est préférable de parler de "faits et de mesures". En général, les évaluateurs ne cherchent pas des réponses du type "quelqu'un pourrait trouver l'option X utile", ni des réponses du type "cette soumission ajoute une fonctionnalité que le micrologiciel X met en œuvre". Au lieu de cela, il est généralement préférable de discuter des détails sur la façon dont l'amélioration de la qualité a été mesurée et quels étaient les résultats de ces mesures - par exemple, "les tests sur les imprimantes Acme X1000 montrent des coins améliorés comme on le voit sur l'image ...", ou par exemple "le temps d'impression de l'objet X du monde réel sur une imprimante Foomatic X900 est passé de 4 heures à 3,5 heures". Il est entendu que les tests de ce type peuvent prendre beaucoup de temps et d'efforts. Certaines des fonctionnalités les plus remarquables de Klipper ont nécessité des mois de discussion, de re-travail, de tests et de documentation avant d'être intégrées dans la branche principale.

   Tous les nouveaux modules, options de configuration, commandes, paramètres de commande et documents doivent avoir un "impact élevé". Nous ne voulons pas imposer aux utilisateurs des options qu'ils ne peuvent raisonnablement pas configurer, ni des options qui n'apportent aucun avantage notable.

   Un relecteur peut demander des éclaircissements sur la manière dont un utilisateur doit configurer une option - une réponse idéale contiendra des détails sur le processus - par exemple, "les utilisateurs du MegaX500 doivent régler l'option X sur 99,3 tandis que les utilisateurs du Elite100Y doivent calibrer l'option X en utilisant la procédure ...".

   Si le but d'une option est de rendre le code plus modulaire, il est préférable d'utiliser des constantes de code plutôt que des options de configuration pour l'utilisateur.

   Les nouveaux modules, les nouvelles options et les nouveaux paramètres ne doivent pas offrir des fonctionnalités similaires à celles des modules existants - si les différences sont arbitraires, il est préférable d'utiliser le système existant ou de remanier le code existant.

   1. Le droit d'auteur de la soumission est-il clair, non gracieux et compatible ?Les nouveaux fichiers C et Python doivent comporter une déclaration de copyright sans ambiguïté. Voir les fichiers existants pour le format préféré. Il est déconseillé de déclarer un droit d'auteur sur un fichier existant lorsque l'on apporte des modifications mineures à ce fichier.

   Le code provenant de sources tierces doit être compatible avec la licence Klipper (GNU GPLv3). Les ajouts importants de code tiers doivent être ajoutés au répertoire `lib/` (et suivre le format décrit dans [lib/README](../lib/README)).

   Les soumissionnaires doivent fournir une [ligne Signed-off-by](#format-of-commit-messages) en utilisant leur nom réel complet. Elle indique que le soumissionnaire est d'accord avec le [certificat d'origine du développeur](developer-certificate-of-origin).

   1. La soumission suit-elle les directives spécifiées dans la documentation de Klipper ?En particulier, le code doit suivre les directives de <Code_Overview.md> et les fichiers de configuration doivent suivre les directives de <Example_Configs.md>.

   1. La documentation de Klipper est-elle mise à jour pour refléter les nouveaux changements ?Au minimum, la documentation de référence doit être mise à jour avec les modifications correspondantes du code :

   * Toutes les commandes et tous les paramètres de commande doivent être documentés dans <G-Codes.md>.
   * Tous les modules destinés aux utilisateurs et leurs paramètres de configuration doivent être documentés dans <Config_Reference.md>.
   * Toutes les "variables d'état" exportées doivent être documentées dans <Status_Reference.md>.
   * Tous les nouveaux "webhooks" et leurs paramètres doivent être documentés dans <API_Server.md>.
   * Toute modification qui apporte un changement non rétrocompatible à une commande ou à un paramètre du fichier de configuration doit être documentée dans <Config_Changes.md>.

Les nouveaux documents doivent être ajoutés à <Overview.md> et être ajoutés à l'index du site web [docs/_klipper3d/mkdocs.yml](../docs/_klipper3d/mkdocs.yml).


   1. Les commits sont-ils bien formés, abordent-ils un seul sujet par commit, et sont-ils indépendants ?Les messages de validation doivent suivre le [format préféré](#format-of-commit-messages).

   Les commits ne doivent pas avoir de conflit de fusion. Les nouveaux ajouts à la branche maîtresse de Klipper sont toujours effectués via un "rebase" ou un "squash and rebase". Il n'est généralement pas nécessaire pour les soumissionnaires de fusionner à nouveau leur soumission à chaque mise à jour du dépôt maître de Klipper. Cependant, s'il y a un conflit de fusion, il est recommandé aux soumissionnaires d'utiliser `git rebase` pour résoudre le conflit.

   Chaque validation doit porter sur un seul changement de haut niveau. Les changements importants doivent être décomposés en plusieurs commits indépendants. Chaque livraison doit se suffire à elle-même pour que des outils comme `git bisect` et `git revert` fonctionnent de manière fiable.

   Les modifications des espaces blancs ne doivent pas être mélangées avec les modifications fonctionnelles. En général, les changements gratuits d'espace blanc ne sont pas acceptés, sauf s'ils proviennent du "propriétaire" établi du code en cours de modification.

Klipper ne met pas en œuvre un "guide de style de codage" strict, mais les modifications apportées au code existant doivent respecter le flux de code de haut niveau, le style d'indentation du code et le format de ce code existant. Les soumissions de nouveaux modules et systèmes bénéficient d'une plus grande souplesse en matière de style de codage, mais il est préférable que ce nouveau code suive un style cohérent en interne et respecte généralement les normes de codage en vigueur dans le secteur.

L'objectif d'une révision n'est pas de discuter de "meilleures mises en œuvre". Cependant, si un relecteur a du mal à comprendre l'implémentation d'une soumission, il peut demander des changements pour rendre l'implémentation plus transparente. En particulier, si les relecteurs ne peuvent pas se convaincre qu'une soumission est exempte de défauts, des changements peuvent être nécessaires.

Dans le cadre d'une révision, un réviseur peut créer une Pull Request alternative pour un sujet. Cela peut être fait pour éviter un "va-et-vient" excessif sur des éléments de procédure mineurs et ainsi rationaliser le processus de soumission. Cela peut également être fait parce que la discussion inspire un réviseur à construire une implémentation alternative. Ces deux situations sont le résultat normal d'une révision et ne doivent pas être considérées comme une critique de la soumission originale.

### Aider à la révision

Nous apprécions l'aide pour les évaluations ! Il n'est pas nécessaire d'être un [reviewer listé](#reviewers) pour effectuer une révision. Les auteurs de Pull Requests GitHub sont également encouragés à réviser leurs propres soumissions.

Pour faciliter la révision, suivez les étapes décrites dans [à quoi s'attendre lors d'une révision](#what-to-expect-in-a-review) pour vérifier la soumission. Une fois la révision terminée, ajoutez un commentaire à la Pull Request GitHub avec vos conclusions. Si la soumission passe la révision, veuillez l'indiquer explicitement dans le commentaire - par exemple quelque chose comme "J'ai revu cette modification selon les étapes du document CONTRIBUTING et tout me semble correct". Si vous n'avez pas pu effectuer certaines étapes de la révision, veuillez indiquer explicitement quelles étapes ont été révisées et quelles étapes ne l'ont pas été - par exemple quelque chose comme "Je n'ai pas vérifié les défauts du code, mais j'ai revu tout le reste dans le document CONTRIBUTING et tout semble bon".

Nous apprécions également les tests des soumissions. Si le code a été testé, veuillez ajouter un commentaire à la Pull Request GitHub avec les résultats de votre test - succès ou échec. Veuillez indiquer explicitement que le code a été testé et les résultats - par exemple quelque chose comme "J'ai testé ce code sur mon imprimante Acme900Z avec une impression de vase et les résultats étaient bons".

### Réviseurs

Les "réviseurs" de Klipper sont :

| Nom | Id GitHub | Domaines d'intérêt |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | Input shaping, test de résonance, cinématiques |
| Eric Callahan | @Arksine | Nivellement du lit, flashage du MCU |
| Kevin O'Connor | @KevinOConnor | Système de mouvement de base, code du microcontrôleur |
| Paul McGowan | @mental405 | Fichiers de configuration, documentation |

Veuillez ne pas envoyer de "ping" à l'un des évaluateurs et ne pas leur adresser de soumissions. Tous les évaluateurs surveillent les forums et les PR, et prennent en charge les évaluations quand ils en ont le temps.

Les "mainteneurs" de Klipper sont :

| Nom | Nom GitHub |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## Format des messages de commit

Chaque livraison doit avoir un message de livraison formaté de la manière suivante :

```
module : Résumé en majuscules, court (50 caractères ou moins)

Texte explicatif plus détaillé, si nécessaire.  Limitez-le à environ 75
caractères ou plus.  Dans certains contextes, la première ligne est considérée comme l'objet d'un courriel et le reste du texte comme le corps.
sujet d'un message électronique et le reste du texte comme le corps du message.  La ligne vierge
séparant le résumé du corps est essentielle (à moins que vous n'omettiez entièrement le corps).
le corps entièrement) ; des outils comme rebase peuvent être confondus si vous exécutez les
les deux ensemble.

Les autres paragraphes viennent après les lignes vides..

Signé par : Mon nom <myemail@example.org>
```

Dans l'exemple ci-dessus, `module` doit être le nom d'un fichier ou d'un répertoire dans le référentiel (sans extension de fichier). Par exemple, `clocksync : Corriger une faute de frappe dans l'appel pause() au moment de la connexion`. Le but de spécifier un nom de module dans le message de livraison est d'aider à fournir un contexte pour les commentaires de livraison.

Il est important d'avoir une ligne "Signed-off-by" sur chaque commit - elle certifie que vous acceptez le [certificat d'origine du développeur](developer-certificate-of-origin). Cette ligne doit contenir votre vrai nom (désolé, pas de pseudonymes ou de contributions anonymes) et une adresse électronique valide.

## Contribuer aux traductions de Klipper

[Projet de traduction de Klipper](https://github.com/Klipper3d/klipper-translations) est le projet dédié à la traduction de Klipper dans différentes langues. [Weblate](https://hosted.weblate.org/projects/klipper/) héberge toutes les chaînes Gettext pour la traduction et la révision. Les localisations peuvent être affichées sur [klipper3d.org](https://www.klipper3d.org) dès lors qu'elles satisfont aux exigences suivantes :

- [ ] 75% Couverture totale
- [ ] Tous les titres (H1) sont traduits
- [ ] Une PR (Pull Request) hiérarchisée de navigation mise à jour dans klipper-translations.

Afin de réduire la frustration liée à la traduction de termes spécifiques à un domaine et de prendre connaissance des traductions en cours, vous pouvez soumettre une PR modifiant le [Projet Klipper-translations](https://github.com/Klipper3d/klipper-translations) `readme.md`. Dès qu'une traduction est prête, la modification correspondante du projet Klipper peut être effectuée.

Si une traduction existe déjà dans le référentiel Klipper et ne répond plus à la liste de contrôle ci-dessus, elle sera marquée comme obsolète après un mois sans mise à jour.

Une fois que les conditions sont remplies, vous devez :

1. mettre à jour le fichier [active_translations](https://github.com/Klipper3d/klipper-translations/blob/translations/active_translations) du dépôt de klipper-tranlations
1. Facultatif : ajouter un fichier manual-index.md dans le dossier `docs\locals\<lang>` du dépôt klipper-translations pour remplacer l'index.md spécifique à la langue (l'index.md généré ne s'affiche pas correctement).

Problèmes connus :

1. Actuellement, il n'existe pas de méthode permettant de traduire correctement les images dans la documentation
1. Il est impossible de traduire les titres dans mkdocs.yml.
