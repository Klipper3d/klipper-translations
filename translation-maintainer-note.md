The following note is important for all the translation repository maintainer who might perform commits and merges on this repository manually(not through Weblate).

1. All commits and pending edits from Weblate needs to be merged before you commit/merge anything else to the repo. Remember to lock Weblate repo to prevent conflicts
2. merge must be performed with `--no-commit` parameter or `git commit --amend` to modify the merge message
3. The merge from main repo looks like this `git merge second_origin/master --no-commit`
4. Remember to unlock the Weblate repository afterwards .