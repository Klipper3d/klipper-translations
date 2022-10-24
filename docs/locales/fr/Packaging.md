# Packager Klipper

Klipper est en quelque sorte comme une anomalie de packaging au sein des programmes Python, car il ne requiert pas d'outils de configuration pour être construit et installé. Quelques notes en ce qui concerne comment package au mieux sont :

## Modules C

Klipper uses a C module to handle some kinematics calculations more quickly. This module needs to be compiled at packaging time to avoid introducing a runtime dependency on a compiler. To compile the C module, run `python2 klippy/chelper/__init__.py`.

## Compiler du code python

Many distributions have a policy of compiling all python code before packaging to improve startup time. You can do this by running `python2 -m compileall klippy`.

## Versionnage

If you are building a package of Klipper from git, it is usual practice not to ship a .git directory, so the versioning must be handled without git. To do this, use the script shipped in `scripts/make_version.py` which should be run as follows: `python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`.

## Sample packaging script

klipper-git is packaged for Arch Linux, and has a PKGBUILD (package build script) available at [Arch User Repositiory](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git).
