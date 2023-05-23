# Klipper csomagolás

A Klipper egyfajta csomagolási anomália a python programok között, mivel nem használja a setuptools-t a szerkesztéshez és a telepítéshez. Néhány megjegyzés arra vonatkozóan, hogy hogyan lehet a legjobban csomagolni, a következő:

## C modulok

A Klipper egy C modult használ néhány kinematikai számítás gyorsabb elvégzésére. Ezt a modult a csomagolási időben kell lefordítani, hogy elkerüljük a fordítóprogramtól való futásidejű függőséget. A C modul lefordításához futtassuk a `python2 klippy/chelper/__init__.py` fájlt.

## Python-kód összeállítása

Sok disztribúciónak van egy olyan irányelve, hogy az indítási idő javítása érdekében minden python kódot lefordít a csomagolás előtt. Ezt a `python2 -m compileall klippy` futtatásával érheted el.

## Verziókezelés

Ha a Klipper csomagot git-ből építed, a szokásos gyakorlat szerint nem szállítasz .git könyvtárat, így a verziókezelést git nélkül kell megoldanod. Ehhez használd a `scripts/make_version.py` alatt szállított szkriptet, amelyet a következőképpen kell futtatni: `python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`.

## Minta csomagolási szkript

A klipper-git az Arch Linuxhoz van csomagolva, és a PKGBUILD (csomagkészítő szkript) elérhető az [Arch Felhasználói Adattár](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git) oldalon.
