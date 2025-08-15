# Rezačka obalov

Klipper je medzi programami v jazyku Python trochu anomáliou v oblasti balenia, pretože na zostavenie a inštaláciu nepoužíva setuptools. Niekoľko poznámok k tomu, ako ho najlepšie zabaliť, je nasledovné:

## C moduly

Klipper používa modul jazyka C na rýchlejšie spracovanie niektorých kinematických výpočtov. Tento modul je potrebné skompilovať počas balenia, aby sa predišlo závislosti od kompilátora počas behu. Na kompiláciu modulu jazyka C spustite príkaz `python2 klippy/chelper/__init__.py`.

## Kompilácia kódu v jazyku Python

Mnohé distribúcie majú zásadu kompilácie všetkého kódu Pythonu pred zabalením, aby sa skrátil čas spustenia. Môžete to urobiť spustením príkazu `python2 -m compileall klippy`.

## Tvorba verzií

Ak zostavujete balík Klipperu z gitu, je bežnou praxou neposielať adresár .git, takže verzovanie musí byť riešené bez gitu. Na to použite skript dodávaný v súbore `scripts/make_version.py`, ktorý by sa mal spustiť nasledovne: `python2 scripts/make_version.py NÁZOV VAŠEJ DISPOZÍCIE > klippy/.version`.

## Ukážkový skript balenia

klipper-git je zabalený pre Arch Linux a má PKGBUILD (skript na zostavenie balíčka) dostupný v [Arch User Repository](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git).
