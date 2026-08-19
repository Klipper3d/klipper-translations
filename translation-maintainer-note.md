The following note is important for all the translation repository maintainer who might perform commits and merges on this repository manually(not through Weblate).

1. All commits and pending edits from Weblate needs to be merged before you commit/merge anything else to the repo. Remember to lock Weblate repo to prevent conflicts
2. merge must be performed with `--no-commit` parameter or `git commit --amend` to modify the merge message
3. The merge from main repo looks like this `git merge second_origin/master --no-commit`
4. Remember to unlock the Weblate repository afterwards .

## Never squash or force-push the `translations` branch

The Weblate components are configured with `merge_style: rebase` against
`translations`. Weblate rebases its own pending commits onto whatever it
finds there, so rewriting history it has already seen leaves it with
commits it cannot replay.

On 2026-04-06 this is exactly what happened: all 57 components raised a
`MergeFailure` alert within minutes of a Weblate pull request landing on
`translations`, and Weblate auto-locked every one of them. Translations
stopped flowing for four months until the components were reset and
unlocked by hand.

So, when integrating a Weblate pull request:

- merge it, with a real merge commit - never "Squash and merge", never
  "Rebase and merge"
- never force-push `translations`
- if a component does get stuck, the recovery is
  Manage -> Repository maintenance -> Reset on each component (this
  discards Weblate's local state, so first confirm nothing has been
  translated since the breakage), then unlock it

## Keep the source tree identical to upstream

Only these paths are owned by this repository:

    README.md
    active_translations
    translation-maintainer-note.md
    docs/Navigation.md
    docs/locales/**
    scripts/update-md.py, scripts/update-md.sh
    scripts/update-po.py, scripts/update-po.sh
    scripts/check_whitespace.sh
    .github/workflows/klipper3d-deploy-test.yaml
    .github/workflows/update_md.yml
    .github/workflows/update_po.yml

Everything else - `klippy/`, `src/`, `config/`, `test/`, `lib/`, and the
English `docs/*.md` - belongs to upstream. When an upstream merge
conflicts in any of those, take upstream's side unconditionally. Earlier
merges were resolved in favour of the fork side and silently reverted
upstream code; the drift in `docs/*.md` was worse still, because the
`.pot` templates are generated from those files, so translators were
working against English text that no longer matched klipper3d.org.
