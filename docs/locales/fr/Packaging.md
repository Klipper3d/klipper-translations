# Packager Klipper

Klipper est en quelque sorte comme une anomalie de packaging au sein des programmes Python, car il ne requiert pas d'outils de configuration pour être construit et installé. Quelques notes en ce qui concerne comment package au mieux sont :

## Modules C

Klipper utilise un module en langage C pour gérer plus rapidement certains calculs cinématiques. Ce module doit être compilé au moment de l'empaquetage pour éviter d'introduire une dépendance d'exécution sur un compilateur. Pour compiler le module C, exécutez `python2 klippy/chelper/__init__.py`.

## Compiler du code python

De nombreuses distributions compilent tout le code python avant de l'empaqueter pour améliorer le temps de démarrage. Vous pouvez le faire en exécutant `python2 -m compileall klippy`.

## Versionnage

Si vous construisez un paquet de Klipper à partir de git, il est d'usage de ne pas envoyer de répertoire .git, donc la gestion des versions doit être gérée sans git. Pour ce faire, utilisez le script fourni dans `scripts/make_version.py` qui doit être exécuté comme suit : `python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`.

## Exemple de script de précompilation

klipper-git is packaged for Arch Linux, and has a PKGBUILD (package build script) available at [Arch User Repository](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git).
