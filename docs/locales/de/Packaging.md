# Klipper paketieren

Klipper ist so etwas wie eine Paketierungsanomalie unter den Python-Programmen, da es setuptools nicht zum Bauen und Installieren verwendet. Einige Hinweise, wie man es am besten verpackt, sind wie folgt:

## C-Module

Klipper verwendet ein C-Modul, um einige Kinematikberechnungen schneller zu handhaben. Dieses Modul muss zur Vermeidung einer Laufzeitabhängigkeit zur Paketierungszeit kompiliert werden. Um das C-Modul zu kompilieren, führen Sie `python2 klippy/chelper/__init__.py` aus.

## Python Code kompilieren

Viele Distributionen verfolgen die Richtlinie, den gesamten Python-Code vor dem Packaging zu kompilieren, um die Startzeit zu verbessern. Dies lässt sich mit dem Befehl `python2 -m compileall klippy` erreichen.

## Versionierung

Wenn Sie ein Paket von Klipper aus git erstellen, ist es übliche Praxis, kein .git-Verzeichnis auszuliefern - daher muss die Versionierung ohne git erfolgen. Verwenden Sie dazu das Skript `scripts/make_version.py`, das wie folgt ausgeführt werden sollte: `python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`.

## Beispiel-Packaging-Skript

klipper-git ist für Arch Linux paketiert und verfügt über ein PKGBUILD (Paket-Build-Skript), das im [Arch User Repository](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git) verfügbar ist.
