# Protokol

Protokol správ Klipper sa používa na komunikáciu na nízkej úrovni medzi hostiteľským softvérom Klipper a softvérom mikrokontroléra Klipper. Na vysokej úrovni si protokol možno predstaviť ako sériu reťazcov príkazov a odpovedí, ktoré sú komprimované, prenášané a potom spracované na prijímacej strane. Príklad série príkazov v nekomprimovanom ľudsky čitateľnom formáte môže vyzerať takto:

```
set_digital_out pin=hodnota PA3=1
set_digital_out pin=hodnota PA7=1
schedule_digital_out oid=8 hodín=4000000 hodnota=0
queue_step oid=7 interval=7458 count=10 add=331
queue_step oid=7 interval=11717 count=4 add=1281
```

Informácie o dostupných príkazoch nájdete v dokumente [mcu commands](MCU_Commands.md). Pozrite si dokument [ladenie](Debugging.md), kde nájdete informácie o tom, ako preložiť súbor G-kódu do jeho zodpovedajúcich ľudsky čitateľných príkazov mikroovládača.

Táto stránka poskytuje popis na vysokej úrovni samotného protokolu správ Klipper. Popisuje, ako sa správy deklarujú, kódujú v binárnom formáte (schéma „kompresie“) a ako sa prenášajú.

Cieľom protokolu je umožniť bezchybný komunikačný kanál medzi hostiteľom a mikrokontrolérom, ktorý má nízku latenciu, malú šírku pásma a nízku zložitosť pre mikrokontrolér.

## Rozhranie mikrokontroléra

Prenosový protokol Klipper si možno predstaviť ako mechanizmus [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call) medzi mikroovládačom a hostiteľom. Softvér mikrokontroléra deklaruje príkazy, ktoré môže hostiteľ vyvolať, spolu so správami s odpoveďami, ktoré môže generovať. Hostiteľ používa tieto informácie na prikázanie mikrokontroléru, aby vykonal akcie a interpretoval výsledky.

### Vyhlasovanie príkazov

Softvér mikrokontroléra deklaruje "príkaz" pomocou makra DECL_COMMAND() v kóde C. Napríklad:

```
DECL_COMMAND(command_update_digital_out, "update_digital_out oid=%c hodnota=%c");
```

Vyššie uvedené deklaruje príkaz s názvom "update_digital_out". To umožňuje hostiteľovi "vyvolať" tento príkaz, ktorý spôsobí, že sa v mikrokontroléri vykoná funkcia command_update_digital_out() C. Vyššie uvedené tiež naznačuje, že príkaz má dva celočíselné parametre. Keď sa vykoná kód command_update_digital_out() C, odovzdá sa pole obsahujúce tieto dve celé čísla - prvé zodpovedá 'oid' a druhé odpovedá 'hodnote'.

Vo všeobecnosti sú parametre opísané syntaxou štýlu printf() (napr. "%u"). Formátovanie priamo zodpovedá ľudskému čitateľnému pohľadu na príkazy (napr. "update_digital_out oid=7 hodnota=1"). Vo vyššie uvedenom príklade je "value=" názov parametra a "%c" označuje, že parameter je celé číslo. Interne sa názov parametra používa iba ako dokumentácia. V tomto príklade sa "%c" používa aj ako dokumentácia na označenie očakávaného celého čísla s veľkosťou 1 bajtu (deklarovaná veľkosť celého čísla nemá vplyv na analýzu ani kódovanie).

Zostava mikrokontroléra zhromaždí všetky príkazy deklarované pomocou DECL_COMMAND(), určí ich parametre a zariadi, aby boli volateľné.

### Deklarovanie odpovedí

Na odoslanie informácií z mikroovládača hostiteľovi sa vygeneruje „odpoveď“. Tieto sú deklarované a prenášané pomocou makra sendf() C. Napríklad:

```
sendf("status clock=%u status=%c", sched_read_time(), sched_is_shutdown());
```

Vyššie uvedené odošle správu s odpoveďou "stav", ktorá obsahuje dva celočíselné parametre ("hodiny" a "stav"). Zostava mikrokontroléra automaticky nájde všetky volania sendf() a vygeneruje pre ne kódovače. Prvý parameter funkcie sendf() popisuje odpoveď a je v rovnakom formáte ako deklarácie príkazov.

Hostiteľ môže zariadiť registráciu funkcie spätného volania pre každú odpoveď. Takže v skutočnosti príkazy umožňujú hostiteľovi vyvolať funkcie C v mikrokontroléri a odpovede umožňujú softvéru mikrokontroléra vyvolať kód v hostiteľovi.

Makro sendf() by malo byť vyvolané iba z príkazov alebo obsluhovačov úloh a nemalo by byť vyvolané z prerušení alebo časovačov. Kód nemusí vydávať sendf() ako odpoveď na prijatý príkaz, nie je obmedzený na počet vyvolaní sendf() a môže kedykoľvek vyvolať sendf() z obsluhy úlohy.

#### Výstupné odpovede

Na zjednodušenie ladenia existuje aj funkcia output() C. Napríklad:

```
output("The value of %u is %s with size %u.", x, buf, buf_len);
```

Funkcia output() sa používa podobne ako printf() – je určená na generovanie a formátovanie ľubovoľných správ pre ľudskú spotrebu.

### Vyhlasovanie súpisov

Enumerácie umožňujú hostiteľskému kódu používať reťazcové identifikátory pre parametre, ktoré mikroovládač spracováva ako celé čísla. Sú deklarované v kóde mikrokontroléra - napríklad:

```
DECL_ENUMERATION("spi_bus", "spi", 0);

DECL_ENUMERATION_RANGE("pin", "PC0", 16, 8);
```

V prvom príklade makro DECL_ENUMERATION() definuje enumeráciu pre ľubovoľnú správu s príkazom/odpoveďou s názvom parametra "spi_bus" alebo názvom parametra s príponou "_spi_bus". Pre tieto parametre je reťazec "spi" platnou hodnotou a bude prenášaný s celočíselnou hodnotou nula.

Je tiež možné deklarovať rozsah enumerácie. V druhom príklade by parameter "pin" (alebo akýkoľvek parameter s príponou "_pin") akceptoval PC0, PC1, PC2, ..., PC7 ako platné hodnoty. Reťazce sa budú prenášať s celými číslami 16, 17, 18, ..., 23.

### Deklarovanie konštánt

Konštanty je možné aj exportovať. Napríklad nasledujúce:

```
DECL_CONSTANT("SERIAL_BAUD", 250000);
```

exportuje konštantu s názvom "SERIAL_BAUD" s hodnotou 250 000 z mikrokontroléra do hostiteľa. Je tiež možné deklarovať konštantu, ktorá je reťazcom - napríklad:

```
DECL_CONSTANT_STR("MCU", "pru");
```

## Nízkoúrovňové kódovanie správ

Aby sa dosiahol vyššie uvedený mechanizmus RPC, každý príkaz a odpoveď sú zakódované do binárneho formátu na prenos. Táto časť popisuje prenosový systém.

### Bloky správ

Všetky údaje odoslané z hostiteľa do mikrokontroléra a naopak sú obsiahnuté v „blokoch správ“. Blok správ má dvojbajtovú hlavičku a trojbajtovú upútavku. Formát bloku správ je:

```
<1 byte length><1 byte sequence><n-byte content><2 byte crc><1 byte sync>
```

Byte dĺžky obsahuje počet bajtov v bloku správy vrátane bajtov hlavičky a prívesku (minimálna dĺžka správy je teda 5 bajtov). Maximálna dĺžka bloku správ je momentálne 64 bajtov. Sekvenčný bajt obsahuje 4 bitové poradové číslo v bitoch nižšieho rádu a bity vyššieho rádu vždy obsahujú 0x10 (bity vyššieho rádu sú rezervované pre budúce použitie). Obsahové bajty obsahujú ľubovoľné údaje a ich formát je popísaný v nasledujúcej časti. Bajty crc obsahujú 16-bitový CCITT [CRC](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) bloku správ vrátane bajtov hlavičky, ale bez bajtov upútavky. Synchronizačný bajt je 0x7e.

Formát bloku správ je inšpirovaný rámcami správ [HDLC](https://en.wikipedia.org/wiki/High-Level_Data_Link_Control). Podobne ako v HDLC môže blok správ voliteľne obsahovať dodatočný synchronizačný znak na začiatku bloku. Na rozdiel od HDLC nie je synchronizačný znak exkluzívny pre rámovanie a môže byť prítomný v obsahu bloku správ.

### Obsah bloku správ

Každý blok správ odoslaný z hostiteľa do mikrokontroléra obsahuje vo svojom obsahu sériu nula alebo viacerých príkazov správ. Každý príkaz začína s [Variable Length Quantity](#variable-length-quantities) (VLQ) zakódovaným celým číslom príkazu-id, za ktorým nasleduje nula alebo viacero parametrov VLQ pre daný príkaz.

Napríklad nasledujúce štyri príkazy môžu byť umiestnené v jednom bloku správ:

```
update_digital_out oid=6 value=1
update_digital_out oid=5 value=0
get_config
get_clock
```

a zakódované do nasledujúcich ôsmich celých čísel VLQ:

```
<id_update_digital_out><6><1><id_update_digital_out><5><0><id_get_config><id_get_clock>
```

Aby bolo možné zakódovať a analyzovať obsah správy, hostiteľ aj mikrokontrolér sa musia dohodnúť na ID príkazov a počte parametrov, ktoré má každý príkaz. Takže vo vyššie uvedenom príklade by hostiteľ aj mikrokontrolér vedeli, že za „id_update_digital_out“ vždy nasledujú dva parametre a „id_get_config“ a „id_get_clock“ majú nulové parametre. Hostiteľ a mikrokontrolér zdieľajú "dátový slovník", ktorý mapuje popisy príkazov (napr. "update_digital_out oid=%c value=%c") na ich celočíselné ID príkazov. Pri spracovaní údajov bude syntaktický analyzátor vedieť, že má očakávať špecifický počet parametrov kódovaných VLQ po zadanom ID príkazu.

Obsah správy pre bloky odoslané z mikrokontroléra hostiteľovi má rovnaký formát. Identifikátory v týchto správach sú „identifikátory odpovedí“, ale slúžia na rovnaký účel a riadia sa rovnakými pravidlami kódovania. V praxi bloky správ odoslané z mikrokontroléra hostiteľovi nikdy neobsahujú viac ako jednu odpoveď v obsahu bloku správ.

#### Množstvo s premenlivou dĺžkou

Ďalšie informácie o všeobecnom formáte celých čísel kódovaných VLQ nájdete v [článku wikipedie](https://en.wikipedia.org/wiki/Variable-length_quantity). Klipper používa schému kódovania, ktorá podporuje kladné aj záporné celé čísla. Celé čísla blízke nule používajú na kódovanie menej bajtov a kladné celé čísla zvyčajne používajú menej bajtov ako záporné celé čísla. Nasledujúca tabuľka zobrazuje počet bajtov, ktoré každé celé číslo potrebuje na zakódovanie:

| Celé číslo | Kódovaná veľkosť |
| --- | --- |
| -32 .. 95 | 1 |
| -4096 .. 12287 | 2 |
| -524288 .. 1572863 | 3 |
| -67108864 .. 201326591 | 4 |
| -2147483648 .. 4294967295 | 5 |

#### Šnúrky s premenlivou dĺžkou

Ako výnimka z vyššie uvedených pravidiel kódovania, ak je parametrom príkazu alebo odpovede dynamický reťazec, potom parameter nie je zakódovaný ako jednoduché celé číslo VLQ. Namiesto toho sa kóduje prenosom dĺžky ako celého čísla zakódovaného VLQ, za ktorým nasleduje samotný obsah:

```
<VLQ encoded length><n-byte contents>
```

Opisy príkazov nájdené v dátovom slovníku umožňujú hostiteľovi aj mikrokontroléru vedieť, ktoré parametre príkazu používajú jednoduché kódovanie VLQ a ktoré parametre používajú kódovanie reťazcov.

## Dátový slovník

Aby sa medzi mikroovládačom a hostiteľom vytvorila zmysluplná komunikácia, obe strany sa musia dohodnúť na „slovníku údajov“. Tento dátový slovník obsahuje celočíselné identifikátory pre príkazy a odpovede spolu s ich popismi.

Zostava mikrokontroléra využíva obsah makier DECL_COMMAND() a sendf() na generovanie dátového slovníka. Zostava automaticky priraďuje jedinečné identifikátory každému príkazu a odpovedi. Tento systém umožňuje hostiteľskému kódu aj kódu mikrokontroléra bezproblémovo používať popisné mená čitateľné pre človeka pri použití minimálnej šírky pásma.

Hostiteľ sa pri prvom pripojení k mikrokontroléru spýta na dátový slovník. Keď hostiteľ stiahne dátový slovník z mikroovládača, použije tento dátový slovník na zakódovanie všetkých príkazov a na analýzu všetkých odpovedí z mikroovládača. Hostiteľ preto musí spracovať dynamický dátový slovník. Aby bol softvér mikrokontroléra jednoduchý, mikrokontrolér vždy používa svoj statický (skompilovaný) dátový slovník.

Dátový slovník sa dotazuje odoslaním príkazov „identifikovať“ mikrokontroléru. Mikroovládač odpovie na každý identifikačný príkaz správou "identify_response". Keďže tieto dva príkazy sú potrebné pred získaním údajového slovníka, ich celočíselné identifikátory a typy parametrov sú pevne zakódované v mikrokontroléri aj hostiteľovi. Identifikátor odpovede "identify_response" je 0, ID príkazu "identify" je 1. Okrem pevne zakódovaných identifikátorov sa príkaz identifikuje a jeho odpoveď deklaruje a prenáša rovnakým spôsobom ako ostatné príkazy a odpovede. Žiadny iný príkaz alebo odpoveď nie je pevne zakódovaná.

Formát samotného slovníka prenášaných údajov je komprimovaný reťazec JSON zlib. Proces zostavovania mikrokontroléra vygeneruje reťazec, skomprimuje ho a uloží do textovej časti blesku mikrokontroléra. Dátový slovník môže byť oveľa väčší ako maximálna veľkosť bloku správ – hostiteľ ho stiahne odoslaním viacerých identifikačných príkazov požadujúcich progresívne časti dátového slovníka. Po získaní všetkých častí hostiteľ zostaví časti, dekomprimuje údaje a analyzuje obsah.

Okrem informácií o komunikačnom protokole obsahuje dátový slovník aj verziu softvéru, enumerácie (definované v DECL_ENUMERATION) a konštanty (definované v DECL_CONSTANT).

## Tok správ

Príkazy správ odosielané z hostiteľa do mikrokontroléra majú byť bezchybné. Mikroovládač skontroluje CRC a poradové čísla v každom bloku správ, aby sa uistil, že príkazy sú presné a v poriadku. Mikrokontrolér vždy spracováva bloky správ v poradí - ak prijme blok mimo poradia, zahodí ho a všetky ostatné bloky mimo poradia, kým neprijme bloky so správnym poradím.

Nízkoúrovňový hostiteľský kód implementuje systém automatického opätovného prenosu stratených a poškodených blokov správ odoslaných do mikrokontroléra. Aby sa to uľahčilo, mikroovládač vysiela "blok správ na potvrdenie" po každom úspešne prijatom bloku správ. Hostiteľ naplánuje časový limit po odoslaní každého bloku a ak vyprší časový limit, odošle ho znova bez prijatia zodpovedajúceho "potvrdenia". Okrem toho, ak mikroovládač deteguje poškodený alebo nefunkčný blok, môže preniesť „blok správ“ na uľahčenie rýchleho opätovného prenosu.

"Potvrdenie" je blok správ s prázdnym obsahom (tj 5-bajtový blok správ) a poradovým číslom väčším ako posledné prijaté poradové číslo hostiteľa. "Nak" je blok správ s prázdnym obsahom a poradovým číslom menším ako posledné prijaté poradové číslo hostiteľa.

Protokol uľahčuje "okenný" prenosový systém, takže hostiteľ môže mať počas letu veľa nevyriešených blokov správ naraz. (Toto je doplnok k mnohým príkazom, ktoré môžu byť prítomné v danom bloku správ.) To umožňuje maximálne využitie šírky pásma aj v prípade oneskorenia prenosu. Mechanizmus časového limitu, opätovného prenosu, okna a potvrdenia sú inšpirované podobnými mechanizmami v [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol).

V opačnom smere sú bloky správ odosielané z mikrokontroléra hostiteľovi navrhnuté tak, aby boli bezchybné, ale nemajú zabezpečený prenos. (Odpovede by nemali byť poškodené, ale môžu sa stratiť.) Toto sa robí preto, aby bola implementácia v mikrokontroléri jednoduchá. Neexistuje žiadny systém automatického opakovaného prenosu odpovedí – očakáva sa, že kód vysokej úrovne bude schopný zvládnuť občasnú chýbajúcu odpoveď (zvyčajne opätovným vyžiadaním obsahu alebo nastavením opakujúceho sa plánu prenosu odpovedí). Pole poradového čísla v blokoch správ odoslaných hostiteľovi je vždy o jedno väčšie ako posledné prijaté poradové číslo blokov správ prijatých od hostiteľa. Nepoužíva sa na sledovanie sekvencií blokov správ odpovede.
