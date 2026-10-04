# Paketera Klipper

Klipper är något av en paketeringsavvikelse bland Python-program eftersom det inte använder setuptools för bygge och installation. Några anmärkningar om hur programmet bäst paketeras följer här:

## C-moduler

Klipper använder en C-modul för att snabbare utföra vissa kinematikberäkningar. Modulen måste kompileras vid paketeringen för att undvika ett körtidsberoende av en kompilator. Kör `python2 klippy/chelper/__init__.py` för att kompilera C-modulen.

## Kompilera Python-kod

Många distributioner har en policy att kompilera all Python-kod före paketering för att förbättra starttiden. Det gör du genom att köra `python2 -m compileall klippy`.

## Versionshantering

När du bygger ett Klipper-paket från git är det vanligt att inte leverera en .git-katalog. Versionshanteringen måste därför ske utan git. Använd skriptet `scripts/make_version.py`, som följer med, enligt följande: `python2 scripts/make_version.py DIN_DISTRIBUTION > klippy/.version`.

## Exempel på paketeringsskript

klipper-git är paketerat för Arch Linux och har en PKGBUILD-fil, ett paketeringsskript, i [Arch User Repository](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git).
