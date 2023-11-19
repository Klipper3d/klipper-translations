# Manuálne vyrovnanie

Tento dokument popisuje nástroje na kalibráciu koncového dorazu Z a na vykonávanie úprav vyrovnávacích skrutiek lôžka.

## Kalibrácia koncového dorazu Z

Presná poloha koncového dorazu Z je rozhodujúca pre získanie vysokokvalitných výtlačkov.

Upozorňujeme však, že presnosť samotného koncového spínača Z môže byť limitujúcim faktorom. Ak používate ovládače krokových motorov Trinamic, zvážte aktiváciu detekcie [koncová fáza](Endstop_Phase.md), aby ste zlepšili presnosť spínača.

Ak chcete vykonať kalibráciu koncového dorazu Z, umiestnite tlačiareň do pôvodnej polohy, prikážte hlave, aby sa posunula do polohy Z, ktorá je aspoň päť milimetrov nad posteľou (ak ešte nie je), prikážte hlave, aby sa posunula do polohy XY blízko stredu lôžko, potom prejdite na kartu terminálu OctoPrint a spustite:

```
Z_ENDSTOP_CALIBRATE
```

Potom postupujte podľa krokov popísaných v ["the paper test"](Bed_Level.md#the-paper-test) aby ste určili skutočnú vzdialenosť medzi tryskou a lôžkom na danom mieste. Po dokončení týchto krokov môžete pozíciu `ACCEPT` a uložiť výsledky do konfiguračného súboru pomocou:

```
SAVE_CONFIG
```

Je vhodnejšie použiť koncový spínač Z na opačnom konci osi Z ako lôžko. (Nasmerovanie preč od postele je robustnejšie, pretože potom je vo všeobecnosti vždy bezpečné vrátiť Z.) Ak sa však človek musí vrátiť k posteli, odporúča sa nastaviť koncový doraz tak, aby spustil malú vzdialenosť (napr. 0,5 mm ) nad posteľou. Takmer všetky koncové spínače možno bezpečne stlačiť na malú vzdialenosť za ich spúšťací bod. Keď to urobíte, mali by ste zistiť, že príkaz `Z_ENDSTOP_CALIBRATE` hlási malú kladnú hodnotu (napr. 0,5 mm) pre Z position_endstop. Spustenie koncového dorazu, keď je ešte v určitej vzdialenosti od lôžka, znižuje riziko neúmyselného zrútenia lôžka.

Niektoré tlačiarne majú možnosť manuálne upraviť umiestnenie fyzického koncového spínača. Odporúča sa však vykonať polohovanie koncového dorazu Z v softvéri pomocou aplikácie Klipper – keď je fyzické umiestnenie koncového dorazu na vhodnom mieste, je možné vykonať ďalšie úpravy spustením Z_ENDSTOP_CALIBRATE alebo manuálnou aktualizáciou koncového dorazu Z v konfiguračnom súbore.

## Nastavovacie skrutky na vyrovnanie lôžka

Tajomstvom dosiahnutia dobrého vyrovnania lôžka pomocou skrutiek na vyrovnanie lôžka je využiť vysoko presný pohybový systém tlačiarne počas samotného procesu vyrovnávania lôžka. To sa vykonáva tak, že sa dýze prikáže do polohy v blízkosti každej skrutky lôžka a potom sa táto skrutka nastaví, kým lôžko nebude v nastavenej vzdialenosti od dýzy. Klipper má nástroj, ktorý vám s tým pomôže. Pre použitie nástroja je potrebné špecifikovať umiestnenie každej skrutky XY.

Urobíte to vytvorením konfiguračnej sekcie `[bed_screws]`. Môže to vyzerať napríklad takto:

```
[bed_screws]
screw1: 100, 50
screw2: 100, 150
screw3: 150, 100
```

Ak je skrutka lôžka pod lôžkom, zadajte polohu XY priamo nad skrutkou. Ak je skrutka mimo lôžka, špecifikujte polohu XY najbližšie k skrutke, ktorá je stále v dosahu lôžka.

Keď je konfiguračný súbor pripravený, spustite príkaz `RESTART`, aby ste načítali túto konfiguráciu a potom je možné spustiť nástroj spustením:

```
BED_SCREWS_ADJUST
```

Tento nástroj presunie dýzu tlačiarne na každé miesto skrutky XY a potom dýzu posunie do výšky Z=0. V tomto bode je možné použiť "test papiera" na nastavenie skrutky lôžka priamo pod tryskou. Pozrite si informácie opísané v ["test papiera"](Bed_Level.md#the-paper-test), ale namiesto prikazovania tryske do rôznych výšok nastavte skrutku lôžka. Upravte skrutku lôžka, až kým nedochádza k malému treniu pri posúvaní papiera tam a späť.

Keď je skrutka nastavená tak, že je cítiť malé trenie, spustite buď príkaz `ACCEPT` alebo `ADJUSTED`. Použite príkaz `ADJUSTED`, ak skrutka lôžka potrebovala nastavenie (zvyčajne niečo viac ako približne 1/8 otáčky skrutky). Ak nie sú potrebné žiadne významné úpravy, použite príkaz `ACCEPT`. Oba príkazy spôsobia, že nástroj prejde na ďalšiu skrutku. (Keď sa použije príkaz „ADJUSTED“, nástroj naplánuje ďalší cyklus nastavenia skrutky lôžka; nástroj sa úspešne dokončí, keď sa overí, že všetky skrutky lôžka nevyžadujú žiadne významné úpravy.) Na ukončenie môžete použiť príkaz „ABORT“ nástroj skoro.

Tento systém funguje najlepšie, keď má tlačiareň plochý tlačový povrch (napríklad sklo) a rovné koľajnice. Po úspešnom dokončení nástroja na vyrovnávanie lôžka by malo byť lôžko pripravené na tlač.

### Jemnozrnné nastavenie skrutiek lôžka

Ak tlačiareň používa tri skrutky lôžka a všetky tri skrutky sú pod lôžkom, môže byť možné vykonať druhý krok „vysoko presného“ vyrovnania lôžka. To sa vykonáva prikázaním trysky na miesta, kde sa lôžko pohybuje na väčšiu vzdialenosť pri každom nastavení skrutky lôžka.

Predstavte si napríklad posteľ so skrutkami na miestach A, B a C:

![bed_screws](img/bed_screws.svg.png)

Pri každom nastavení skrutky lôžka v mieste C sa lôžko bude otáčať pozdĺž kyvadla definovaného zvyšnými dvoma skrutkami lôžka (tu znázornené ako zelená čiara). V tejto situácii každé nastavenie skrutky lôžka v polohe C posunie lôžko v polohe D o viac ako priamo v polohe C. Je teda možné vykonať vylepšené nastavenie skrutky C, keď je dýza v polohe D.

Ak chcete povoliť túto funkciu, musíte určiť ďalšie súradnice trysky a pridať ich do konfiguračného súboru. Môže to vyzerať napríklad takto:

```
[bed_screws]
screw1: 100, 50
screw1_fine_adjust: 0, 0
screw2: 100, 150
screw2_fine_adjust: 300, 300
screw3: 150, 100
screw3_fine_adjust: 0, 100
```

Keď je táto funkcia povolená, nástroj `BED_SCREWS_ADJUST` najskôr vyzve na hrubé úpravy priamo nad každou pozíciou skrutky, a keď budú akceptované, vyzve vás na jemné úpravy na ďalších miestach. Pokračujte v používaní `ACCEPT` a `ADJUSTED` na každej pozícii.

## Nastavenie vyrovnávacích skrutiek lôžka pomocou sondy lôžka

Toto je ďalší spôsob kalibrácie úrovne lôžka pomocou lôžkovej sondy. Aby ste ho mohli použiť, musíte mať Z sondu (BL Touch, indukčný senzor atď.).

Ak chcete povoliť túto funkciu, je potrebné určiť súradnice trysky tak, aby bola sonda Z nad skrutkami, a potom ich pridať do konfiguračného súboru. Môže to vyzerať napríklad takto:

```
[screws_tilt_adjust]
screw1: -5, 30
screw1_name: front left screw
screw2: 155, 30
screw2_name: front right screw
screw3: 155, 190
screw3_name: rear right screw
screw4: -5, 190
screw4_name: rear left screw
horizontal_move_z: 10.
speed: 50.
screw_thread: CW-M3
```

Skrutka1 je vždy referenčným bodom pre ostatné, takže systém predpokladá, že skrutka1 je v správnej výške. Vždy najprv spustite `G28` a potom spustite `SCREWS_TILT_CALCULATE` – mal by produkovať výstup podobný ako:

```
Send: G28
Recv: ok
Send: SCREWS_TILT_CALCULATE
Recv: // 01:20 means 1 full turn and 20 minutes, CW=clockwise, CCW=counter-clockwise
Recv: // front left screw (base) : x=-5.0, y=30.0, z=2.48750
Recv: // front right screw : x=155.0, y=30.0, z=2.36000 : adjust CW 01:15
Recv: // rear right screw : y=155.0, y=190.0, z=2.71500 : adjust CCW 00:50
Recv: // read left screw : x=-5.0, y=190.0, z=2.47250 : adjust CW 00:02
Recv: ok
```

To znamená, že:

- ľavá predná skrutka je referenčným bodom, nesmiete ju meniť.
- predná pravá skrutka sa musí otočiť v smere hodinových ručičiek o 1 celú otáčku a o štvrť otáčky
- pravá zadná skrutka sa musí otáčať proti smeru hodinových ručičiek 50 minút
- zadná ľavá skrutka sa musí otáčať v smere hodinových ručičiek 2 minúty (netreba, je to v poriadku)

Všimnite si, že „minúty“ sa vzťahujú na „minúty ciferníka“. Takže napríklad 15 minút je štvrtina celej otáčky.

Opakujte postup niekoľkokrát, kým nedosiahnete dobrú rovnú posteľ - zvyčajne, keď sú všetky úpravy pod 6 minút.

Ak používate sondu, ktorá je namontovaná na boku hotendu (t. j. má posunutie X alebo Y), všimnite si, že úprava sklonu lôžka zruší platnosť akejkoľvek predchádzajúcej kalibrácie sondy, ktorá bola vykonaná s nakloneným lôžkom. Po nastavení skrutiek lôžka nezabudnite spustiť [probe calibration](Probe_Calibrate.md).

Parameter MAX_DEVIATION je užitočný, keď sa používa uložená sieťka lôžka, aby sa zabezpečilo, že sa úroveň lôžka príliš neposunula od miesta, kde bola pri vytváraní siete. Napríklad `SCREWS_TILT_CALCULATE MAX_DEVIATION=0,01` možno pridať do vlastného počiatočného gkódu filtra pred načítaním siete. Tlač preruší, ak sa prekročí nakonfigurovaný limit (v tomto príklade 0,01 mm), čo dáva používateľovi možnosť nastaviť skrutky a reštartovať tlač.

Parameter `DIRECTION` je užitočný, ak môžete nastavovacie skrutky postele otáčať iba jedným smerom. Môžete mať napríklad skrutky, ktoré sa začínajú uťahovať v najnižšej (alebo najvyššej) možnej polohe, ktorú možno otáčať iba v jednom smere, aby ste zdvihli (alebo znížili) posteľ. Ak môžete skrutky otáčať iba v smere hodinových ručičiek, spustite príkaz `SCREWS_TILT_CALCULATE DIRECTION=CW`. Ak ich môžete otáčať iba proti smeru hodinových ručičiek, spustite príkaz `SCREWS_TILT_CALCULATE DIRECTION=CCW`. Vhodný referenčný bod sa zvolí tak, aby bolo možné posteľ vyrovnať otočením všetkých skrutiek v danom smere.
