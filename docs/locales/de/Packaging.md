# Packaging Klipper

Klipper ist so etwas wie eine Paketierungsanomalie unter den Python-Programmen, da es setuptools nicht zum Bauen und Installieren verwendet. Einige Hinweise, wie man es am besten verpackt, sind wie folgt:

## C-Module

Klipper verwendet ein C-Modul, um einige Kinematikberechnungen schneller zu handhaben. Dieses Modul muss zur Vermeidung einer Laufzeitabhängigkeit zur Paketierungszeit kompiliert werden. Um das C-Modul zu kompilieren, führen Sie `python2 klippy/chelper/__init__.py` aus.

## Python Code kompilieren

Many distributions have a policy of compiling all python code before packaging to improve startup time. You can do this by running `python2 -m compileall klippy`.

## Versioning

If you are building a package of Klipper from git, it is usual practice not to ship a .git directory, so the versioning must be handled without git. To do this, use the script shipped in `scripts/make_version.py` which should be run as follows: `python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`.

## Sample packaging script

klipper-git is packaged for Arch Linux, and has a PKGBUILD (package build script) available at [Arch User Repository](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git).
