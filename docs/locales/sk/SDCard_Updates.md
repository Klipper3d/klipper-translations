# Aktualizácie karty SD

Mnohé z dnešných populárnych riadiacich dosiek sa dodávajú s bootloaderom schopným aktualizovať firmvér cez SD kartu. Aj keď je to v mnohých prípadoch výhodné, tieto zavádzače zvyčajne neposkytujú žiadny iný spôsob aktualizácie firmvéru. To môže byť nepríjemné, ak je vaša doska namontovaná na ťažko prístupnom mieste alebo ak potrebujete často aktualizovať firmvér. Po počiatočnom flashovaní Klipperu do ovládača je možné preniesť nový firmvér na SD kartu a spustiť proces flashovania cez ssh.

## Typický postup aktualizácie

Postup aktualizácie firmvéru MCU pomocou SD karty je podobný ako pri iných metódach. Namiesto použitia `make flash` je potrebné spustiť pomocný skript `flash-sdcard.sh`. Aktualizácia BigTreeTech SKR 1.3 môže vyzerať takto:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-skr-v1.3
sudo service klipper start
```

Je na užívateľovi, aby určil umiestnenie zariadenia a názov dosky. Ak používateľ potrebuje flashovať viacero dosiek, pred reštartovaním služby Klipper by mal byť pre každú dosku spustený `flash-sdcard.sh` (alebo `make flash`, ak je to vhodné).

Podporované dosky je možné zobraziť pomocou nasledujúceho príkazu:

```
./scripts/flash-sdcard.sh -l
```

Ak nevidíte svoju tabuľu v zozname, možno bude potrebné pridať novú definíciu dosky, ako je [popísané nižšie](#definície dosky).

## Pokročilé použitie

Vyššie uvedené príkazy predpokladajú, že váš MCU sa pripája predvolenou prenosovou rýchlosťou 250 000 a firmvér sa nachádza na `~/klipper/out/klipper.bin`. Skript `flash-sdcard.sh` poskytuje možnosti na zmenu týchto predvolených hodnôt. Všetky možnosti je možné zobraziť na obrazovke pomocníka:

```
./scripts/flash-sdcard.sh -h
Nástroj na nahrávanie SD karty pre Klipper

usage: flash_sdcard.sh [-h] [-l] [-c] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -c              run flash check/verify only (skip upload)
  -b <baud>       serial baud rate (default is 250000)
  -f <firmware>   path to klipper.bin
```

Ak je vaša doska vybavená firmvérom, ktorý sa pripája vlastnou prenosovou rýchlosťou, je možné vykonať upgrade zadaním možnosti `-b`:

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

Ak chcete flashovať zostavu Klipper umiestnenú niekde inde, ako je predvolené umiestnenie, môžete to urobiť zadaním možnosti `-f`:

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

Upozorňujeme, že pri aktualizácii MKS Robin E3 nie je potrebné manuálne spúšťať `update_mks_robin.py` a dodávať výsledný binárny súbor do `flash-sdcard.sh`. Tento postup je automatizovaný počas procesu nahrávania.

Voľba `-c` sa používa na vykonanie operácie iba na kontrolu alebo overenie, aby sa otestovalo, či doska správne beží špecifikovaný firmvér. Táto možnosť je primárne určená pre prípady, keď je potrebné manuálne zapnutie a vypnutie na dokončenie postupu blikania, ako napríklad pri zavádzacích zariadeniach, ktoré na prístup k svojim kartám SD používajú režim SDIO namiesto SPI. (Pozrite si upozornenia nižšie) Dá sa však kedykoľvek použiť aj na overenie, či sa kód vložený do dosky zhoduje s verziou v priečinku zostavy na akejkoľvek podporovanej doske.

## Výstrahy

- Ako už bolo spomenuté v úvode, tento spôsob funguje len pri aktualizácii firmvéru. Počiatočný postup blikania sa musí vykonať manuálne podľa pokynov, ktoré sa vzťahujú na vašu riadiacu dosku.
- Aj keď je možné flashovať zostavu, ktorá mení sériový Baud alebo rozhranie pripojenia (tj: z USB na UART), overenie vždy zlyhá, pretože skript sa nebude môcť znova pripojiť k MCU, aby overil aktuálnu verziu.
- Podporované sú iba dosky, ktoré používajú SPI na komunikáciu s kartou SD. Dosky, ktoré používajú SDIO, ako napríklad Flymaker Flyboard a MKS Robin Nano V1/V2, nebudú fungovať v režime SDIO. Zvyčajne je však možné flashovať takéto dosky pomocou režimu Software SPI. Ak však bootloader dosky používa na prístup k SD karte iba režim SDIO, bude potrebný cyklus napájania dosky a SD karty, aby sa režim mohol prepnúť z SPI späť na SDIO a dokončiť preflashovanie. Takéto nástenky by mali byť definované s povoleným  `skip_verify`  aby sa preskočil krok overenia ihneď po blikaní. Potom po manuálnom vypnutí napájania môžete znova spustiť presne ten istý príkaz `./scripts/flash-sdcard.sh` command, but add the `-c` option to complete the check/verify operation. See [Flashing Boards that use SDIO](#flashing-boards-that-use-sdio) for examples.

## Definície dosky

Väčšina bežných dosiek by mala byť k dispozícii, v prípade potreby je však možné pridať novú definíciu dosky. Definície dosiek sa nachádzajú v ` ~/klipper/scripts/spi_flash/board_defs.py`. Definície sú uložené v slovníku, napr.

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<further definitions>
}
```

Môžu byť špecifikované nasledujúce polia:

- `mcu`: Typ mcu. Toto je možné získať po konfigurácii zostavy cez `make menuconfig` spustením `cat .config | grep CONFIG_MCU`. Toto pole je povinné.
- `spi_bus`: Zbernica SPI pripojená ku karte SD. Toto by sa malo získať zo schémy dosky. Toto pole je povinné.
- `cs_pin`: Čip Select Pin pripojený k SD karte. Toto by sa malo získať zo schémy dosky. Toto pole je povinné.
- `firmware_path`: Cesta na SD karte, kam sa má preniesť firmvér. Predvolená hodnota je `firmware.bin`.
- `current_firmware_path`: Cesta na SD karte, kde sa nachádza premenovaný súbor firmvéru po úspešnom flashnutí. Predvolená hodnota je `firmware.cur`.
- `skip_verify`: Toto definuje boolovskú hodnotu, ktorá povie skriptom, aby preskočili krok overenia firmvéru počas procesu blikania. Predvolená hodnota je „False“. Pre dosky, ktoré vyžadujú manuálny cyklus napájania na dokončenie blikania, možno nastaviť hodnotu „True“. Ak chcete firmvér následne overiť, znova spustite skript s voľbou `-c` a vykonajte krok overenia. [Pozrite si upozornenia týkajúce sa kariet SDIO](#caveats)

Ak sa vyžaduje softvérové rozhranie SPI, pole `spi_bus` by malo byť nastavené na  `swspi` a malo by sa zadať nasledujúce dodatočné pole:

- `spi_pins`: Mali by to byť 3 kolíky oddelené čiarkou, ktoré sú pripojené ku karte SD vo formáte  `miso,mosi,sclk`.

Malo by byť mimoriadne zriedkavé, že softvér SPI je potrebný, zvyčajne ho budú vyžadovať iba dosky s chybami v návrhu alebo dosky, ktoré normálne podporujú iba režim SDIO pre svoju kartu SD. Definícia dosky `btt-skr-pro` poskytuje príklad prvého a definícia dosky `btt-octopus-f446-v1` poskytuje príklad druhého.

Pred vytvorením novej definície dosky by ste mali skontrolovať, či existujúca definícia dosky spĺňa kritériá potrebné pre novú dosku. Ak ide o tento prípad, možno zadať `BOARD_ALIAS` Napríklad je možné pridať nasledujúci alias na špecifikáciu `my-new-board` ako alias pre „generic-lpc1768`:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Ak potrebujete novú definíciu dosky a nie je vám vyhovujúci postup načrtnutý vyššie, odporúča sa, aby ste si ju vyžiadali v [Klipper Community Discord](Contact.md#discord).

## Flashing dosky, ktoré používajú SDIO

[Ako je uvedené v upozorneniach](#caveats), dosky, ktorých bootloader používa režim SDIO na prístup k svojej karte SD, vyžadujú zapnutie a vypnutie dosky a konkrétne samotnej karty SD, aby sa prepli z režimu SPI používaného počas zápisu. súbor na SD kartu späť do režimu SDIO, aby ho bootloader flashol do dosky. Tieto definície dosky budú používať príznak `skip_verify`, ktorý oznamuje blikajúcemu nástroju, aby sa zastavil po zapísaní firmvéru na SD kartu, aby bolo možné dosku manuálne zapnúť a vypnúť a odložiť krok overenia, kým sa to nedokončí.

Existujú dva scenáre – jeden s RPi Host beží na samostatnom napájacom zdroji a druhý, keď RPi Host beží na rovnakom napájacom zdroji ako hlavná doska, ktorá je flashovaná. Rozdiel je v tom, či je alebo nie je potrebné vypnúť aj RPi a potom znova `ssh` po dokončení flashovania, aby sa vykonal krok overenia, alebo či je možné overenie vykonať okamžite. Tu sú príklady dvoch scenárov:

### Programovanie SDIO s RPi na samostatnom napájacom zdroji

Typická relácia s RPi na samostatnom napájacom zdroji vyzerá nasledovne. Samozrejme, budete musieť použiť správnu cestu k zariadeniu a názov dosky:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
[[[manually power-cycle the printer board here when instructed]]]
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

### SDIO programovanie s RPi na rovnakom napájacom zdroji

Typická relácia s RPi na rovnakom napájacom zdroji vyzerá nasledovne. Samozrejme, budete musieť použiť správnu cestu k zariadeniu a názov dosky:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
sudo shutdown -h now
[[[wait for the RPi to shutdown, then power-cycle and ssh again to the RPi when it restarts]]]
sudo service klipper stop
cd ~/klipper
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

V tomto prípade, keďže RPi Host sa reštartuje, čím sa reštartuje služba `klipper`, je potrebné `klipper` znova zastaviť pred vykonaním kroku overenia a reštartovať ho po dokončení overenia.

### Mapovanie pinov SDIO na SPI

Ak schéma vašej dosky používa SDIO pre svoju SD kartu, môžete namapovať kolíky podľa popisu v tabuľke nižšie, aby ste určili kompatibilné kolíky softvérového rozhrania SPI na priradenie v súbore `board_defs.py`:

| Pin karty SD | Pin karty Micro SD | SDIO Pin Meno | SPI Pin Meno |
| :-: | :-: | :-: | :-: |
| 9 | 1 | DATA2 | None (PU)* |
| 1 | 2 | CD/DATA3 | CS |
| 2 | 3 | CMD | MOSI |
| 4 | 4 | +3.3V (VDD) | +3.3V (VDD) |
| 5 | 5 | CLK | SCLK |
| 3 | 6 | GND (VSS) | GND (VSS) |
| 7 | 7 | DATA0 | MISO |
| 8 | 8 | DATA1 | None (PU)* |
| N/A | 9 | Detekcia karty (CD) | Detekcia karty (CD) |
| 6 | 10 | GND | GND |

\* Žiadne (PU) označuje nepoužitý pin s pull-up rezistorom
