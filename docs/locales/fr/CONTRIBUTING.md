# Contribuer à Klipper

Merci de contribuer à Klipper ! Veuillez prendre un moment pour lire ce document.

## Créer une nouvelle issue

Veuillez consulter la [page de contact](Contact.md) pour savoir comment créer une issue.

## Soumettre une pull-request

Les contributions de code et de documentation sont gérées par le biais de demandes de pull-request github. Chaque commit doit avoir un message de commit formaté de la manière suivante :

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

Il est important d'avoir une ligne "Signed-off-by" sur chaque commit - elle certifie que vous acceptez le [certificat d'origine du développeur](developer-certificate-of-origin). Cette ligne doit contenir votre vrai nom (désolé, pas de pseudonymes ou de contributions anonymes) et une adresse électronique valide.

## Contributing to Klipper Translations

[Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) is a project dedicated to translating Klipper to different languages. [Weblate](https://hosted.weblate.org/projects/klipper/) hosts all the Gettext strings for translating and reviewing. Locales can merge into the Klipper project once they satisfy the following requirements:

- [ ] 75% Total coverage
- [ ] All titles (H1) are covered
- [ ] An updated navigation hierarchy PR in klipper-translations.

The navigation hierarchy is in `docs\_klipper3d\mkdocs.yml`.

To reduce the frustration of translating domain-specific terms and gain awareness of the ongoing translations, you can submit a PR modifying the [Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) `readme.md`. Once a translation is ready, the corresponding modification to the Klipper project can be made.

If a translation already exists in the Klipper repository and no longer meets the checklist above, it will be marked out-of-date after a month without updates.

Please follow the following format for `mkdocs.yml` navigation hierarchy:

```yml
nav:
  - existing hierachy
  - <language>:
    - locales/<language code>/md file
```

Note: Currently, there isn't a method for correctly translating pictures in the documentation.
