# Contribuer à Klipper

Merci de contribuer à Klipper ! Ce document décrit la procédure à suivre pour apporter des modifications à Klipper.

Veuillez consulter la [page de contact](Contact.md) pour obtenir des informations sur le signalement d'un problème ou pour obtenir des détails sur la manière de contacter les développeurs.

## Aperçu de la procédure de contribution

Les contributions à Klipper suivent généralement un processus de haut niveau :

1. Un soumissionnaire commence par créer une [GitHub Pull Request] (https://github.com/Klipper3d/klipper/pulls) lorsqu'une soumission est prête à être déployée à grande échelle.
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

   When fixing a defect in the code, submitters should have a general understanding of the root cause of that defect, and the fix should target that root cause.

   Les soumissions de code ne doivent pas contenir de code de débogage excessif, d'options de débogage, ni d'enregistrement de débogage à l'exécution.

   Les commentaires dans les soumissions de code doivent se concentrer sur l'amélioration de la maintenance du code. Les soumissions ne doivent pas contenir de "code commenté" ni de commentaires excessifs décrivant des implémentations passées. Il ne doit pas y avoir de commentaires excessifs de type "todo".

   Les mises à jour de la documentation ne doivent pas indiquer qu'il s'agit d'un "travail en cours".

   1. La demande apporte-t-elle un avantage "à fort impact" à des utilisateurs du monde réel effectuant des tâches du monde réel ?Les relecteurs doivent identifier, au moins dans leur propre esprit, à peu près "qui est le public cible", une échelle approximative de "la taille de ce public", le "bénéfice" qu'ils obtiendront, comment le "bénéfice est mesuré", et les "résultats de ces tests de mesure". Dans la plupart des cas, ces éléments sont évidents pour l'auteur et l'examinateur, et ne sont pas explicitement mentionnés lors d'un examen.

   Les soumissions à la branche principale de Klipper doivent avoir un public cible important. En règle générale, les soumissions doivent cibler une base d'au moins 100 utilisateurs du monde réel.

   Si un relecteur demande des détails sur les "avantages" d'une proposition, ne considérez pas cela comme une critique. Être capable de comprendre les avantages concrets d'un changement est une partie naturelle d'un examen.

   When discussing benefits it is preferable to discuss "facts and measurements". In general, reviewers are not looking for responses of the form "someone may find option X useful", nor are they looking for responses of the form "this submission adds a feature that firmware X implements". Instead, it is generally preferable to discuss details on how the quality improvement was measured and what were the results of those measurements - for example, "tests on Acme X1000 printers show improved corners as seen in picture ...", or for example "print time of real-world object X on a Foomatic X900 printer went from 4 hours to 3.5 hours". It is understood that testing of this type can take significant time and effort. Some of Klipper's most notable features took months of discussion, rework, testing, and documentation prior to being merged into the master branch.

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

As part of a review, a reviewer may create an alternate Pull Request for a topic. This may be done to avoid excessive "back and forth" on minor procedural items and thus streamline the submission process. It may also be done because the discussion inspires a reviewer to build an alternative implementation. Both situations are a normal result of a review and should not be considered criticism of the original submission.

### Helping with reviews

We appreciate help with reviews! It is not necessary to be a [listed reviewer](#reviewers) to perform a review. Submitters of GitHub Pull Requests are also encouraged to review their own submissions.

To help with a review, follow the steps outlined in [what to expect in a review](#what-to-expect-in-a-review) to verify the submission. After completing the review, add a comment to the GitHub Pull Request with your findings. If the submission passes the review then please state that explicitly in the comment - for example something like "I reviewed this change according to the steps in the CONTRIBUTING document and everything looks good to me". If unable to complete some steps in the review then please explicitly state which steps were reviewed and which steps were not reviewed - for example something like "I didn't check the code for defects, but I reviewed everything else in the CONTRIBUTING document and it looks good".

We also appreciate testing of submissions. If the code was tested then please add a comment to the GitHub Pull Request with the results of your test - success or failure. Please explicitly state that the code was tested and the results - for example something like "I tested this code on my Acme900Z printer with a vase print and the results were good".

### Reviewers

The Klipper "reviewers" are:

| Name | GitHub Id | Areas of interest |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | Input shaping, resonance testing, kinematics |
| Eric Callahan | @Arksine | Bed leveling, MCU flashing |
| Kevin O'Connor | @KevinOConnor | Core motion system, Micro-controller code |
| Paul McGowan | @mental405 | Configuration files, documentation |

Please do not "ping" any of the reviewers and please do not direct submissions at them. All of the reviewers monitor the forums and PRs, and will take on reviews when they have time to.

The Klipper "maintainers" are:

| Name | GitHub name |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## Format of commit messages

Each commit should have a commit message formatted similar to the following:

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

In the above example, `module` should be the name of a file or directory in the repository (without a file extension). For example, `clocksync: Fix typo in pause() call at connect time`. The purpose of specifying a module name in the commit message is to help provide context for the commit comments.

Il est important d'avoir une ligne "Signed-off-by" sur chaque commit - elle certifie que vous acceptez le [certificat d'origine du développeur](developer-certificate-of-origin). Cette ligne doit contenir votre vrai nom (désolé, pas de pseudonymes ou de contributions anonymes) et une adresse électronique valide.

## Contribuer aux traductions de Klipper

[Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) is a project dedicated to translating Klipper to different languages. [Weblate](https://hosted.weblate.org/projects/klipper/) hosts all the Gettext strings for translating and reviewing. Locales can be displayed on [klipper3d.org](https://www.klipper3d.org) once they satisfy the following requirements:

- [ ] 75% Couverture totale
- [ ] All titles (H1) are translated
- [ ] Une hiérarchie de navigation mise à jour PR dans klipper-translations.

Afin de réduire la frustration liée à la traduction de termes spécifiques à un domaine et de prendre connaissance des traductions en cours, vous pouvez soumettre un PR modifiant le [Projet Klipper-translations](https://github.com/Klipper3d/klipper-translations) `readme.md`. Dès qu'une traduction est prête, la modification correspondante du projet Klipper peut être effectuée.

Si une traduction existe déjà dans le référentiel Klipper et ne répond plus à la liste de contrôle ci-dessus, elle sera marquée comme obsolète après un mois sans mise à jour.

Once the requirements are met, you need to:

1. update klipper-tranlations repository [active_translations](https://github.com/Klipper3d/klipper-translations/blob/translations/active_translations)
1. Optional: add a manual-index.md file in klipper-translations repository's `docs\locals\<lang>` folder to replace the language specific index.md (generated index.md does not render correctly).

Known Issues:

1. Currently, there isn't a method for correctly translating pictures in the documentation
1. It is impossible to translate titles in mkdocs.yml.
