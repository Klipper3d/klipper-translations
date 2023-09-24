# Klipper packaging

Klipper è in qualche modo un'anomalia tra i programmi Python per quanto riguarda impacchettamento, in quanto non usa setuptools per costruire e installare. Alcune note riguardanti il modo migliore per impacchettarlo sono le seguenti:

## Moduli C

Klipper utilizza un modulo C per gestire più rapidamente alcuni calcoli cinematici. Questo modulo deve essere compilato al momento per evitare di introdurre una dipendenza di runtime da un compilatore. Per compilare il modulo C, esegui `python2 klippy/chelper/__init__.py`.

## Compilazione di codice python

Molte distribuzioni hanno una politica di compilazione di tutto il codice Python prima del packaging per migliorare i tempi di avvio. Puoi farlo eseguendo `python2 -m compileall klippy`.

## Versione

Se stai compilando un pacchetto di Klipper da git, è normale non spedire una directory .git, quindi il controllo delle versioni deve essere gestito senza git. Per fare ciò, usa lo script fornito in `scripts/make_version.py` che dovrebbe essere eseguito come segue: `python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`.

## Esempio di script di packaging

klipper-git è pacchettizzato per Arch Linux e ha un PKGBUILD (script di creazione del pacchetto) disponibile su [Arch User Repository](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper- git).
