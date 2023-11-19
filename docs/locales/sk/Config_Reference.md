# Odkaz na konfiguráciu

This document is a reference for options available in the Klipper config file.

The descriptions in this document are formatted so that it is possible to cut-and-paste them into a printer config file. See the [installation document](Installation.md) for information on setting up Klipper and choosing an initial config file.

## Konfigurácia mikrokontroléra

### Format of micro-controller pin names

Mnoho možností konfigurácie vyžaduje názov kolíka mikroovládača. Klipper používa názvy hardvéru pre tieto piny - napríklad `PA4`.

Názvy pinov môžu byť označené znakom `!`, čo znamená, že by sa mala použiť opačná polarita (napr. spustenie pri nízkej namiesto vysokej).

Vstupným kolíkom môže predchádzať znak „^“, ktorý označuje, že pre kolík by mal byť povolený hardvérový pull-up rezistor. Ak mikroovládač podporuje sťahovacie odpory, potom pred vstupným kolíkom môže alternatívne predchádzať „~“.

Všimnite si, že niektoré konfiguračné sekcie môžu „vytvoriť“ ďalšie piny. Ak k tomu dôjde, konfiguračná sekcia definujúca piny musí byť uvedená v konfiguračnom súbore pred akýmikoľvek sekciami, ktoré tieto piny používajú.

### [mcu]

Konfigurácia primárneho mikrokontroléra.

```
[mcu]
seriál:
# Sériový port na pripojenie k MCU. Ak si nie ste istí (resp
# zmien) pozrite si "Kde je môj sériový port?" časti FAQ.
# Tento parameter je potrebné zadať pri použití sériového portu.
#baud: 250 000
# Použitá prenosová rýchlosť. Predvolená hodnota je 250 000.
#canbus_uuid:
# Ak používate zariadenie pripojené na zbernicu CAN, nastaví sa tým jedinečný
# identifikátor čipu na pripojenie. Táto hodnota musí byť uvedená pri použití
# CAN zbernica pre komunikáciu.
#canbus_interface:
# Ak používate zariadenie pripojené na zbernicu CAN, nastaví sa CAN
# sieťové rozhranie na použitie. Predvolená hodnota je 'can0'.
#restart_method:
# Toto riadi mechanizmus, ktorý hostiteľ použije na resetovanie
# mikroovládač. Možnosti sú 'arduino', 'gepard', 'rpi_usb',
# a 'príkaz'. Metóda 'arduino' (prepínanie DTR) je bežná
# Arduino dosky a klony. Metóda 'geparda' je špeciálna
# metóda potrebná pre niektoré dosky Fysetc Cheetah. Metóda 'rpi_usb'
# je užitočné na doskách Raspberry Pi s napájanými mikrokontrolérmi
# cez USB - nakrátko vypne napájanie všetkých portov USB
# vykonajte reset mikrokontroléra. Metóda „príkazu“ zahŕňa
# odoslanie príkazu Klipper do mikroovládača, aby mohol
# sa resetuje. Predvolená hodnota je „arduino“, ak ide o mikroovládač
# komunikuje cez sériový port, inak 'príkaz'.
```

### [mcu my_extra_mcu]

Dodatočné mikrokontroléry (je možné definovať ľubovoľný počet sekcií s predponou "mcu"). Dodatočné mikroovládače zavádzajú ďalšie kolíky, ktoré môžu byť nakonfigurované ako ohrievače, steppery, ventilátory atď. Napríklad, ak sa zavedie sekcia "[mcu extra_mcu]", potom kolíky ako "extra_mcu:ar9" možno použiť inde v konfigurácii (kde "ar9" je názov hardvérového pinu alebo alias na danom mcu).

```
[mcu my_extra_mcu]
# Konfiguračné parametre nájdete v časti "mcu".
```

## Bežné kinematické nastavenia

### [printer]

The printer section controls high level printer settings.

```
[tlačiareň]
kinematika:
# Typ používanej tlačiarne. Táto možnosť môže byť jedna z: karteziánskej,
# corexy, corexz, hybrid_corexy, hybrid_corexz, rotary_delta, delta,
# deltézsky, polárny, navijak alebo žiadny. Tento parameter musí byť špecifikovaný.
max_velocity:
# Maximálna rýchlosť (v mm/s) nástrojovej hlavy (vo vzťahu k
#tlač). Tento parameter musí byť špecifikovaný.
max_accel:
# Maximálne zrýchlenie (v mm/s^2) nástrojovej hlavy (vo vzťahu k
#tlač). Tento parameter musí byť špecifikovaný.
#max_accel_to_decel:
# Pseudo zrýchlenie (v mm/s^2), ktoré riadi rýchlosť
# nástrojová hlava môže prejsť zo zrýchlenia na spomalenie. Je zvyknutý
# znížiť maximálnu rýchlosť krátkych cik-cak pohybov (a tým znížiť
# vibrácie tlačiarne z týchto pohybov). Predvolená hodnota je polovica
# max_accel.
#square_corner_velocity: 5,0
# Maximálna rýchlosť (v mm/s), ktorou môže nástrojová hlava prejsť 90
# stupeň roh pri. Nenulová hodnota môže znížiť zmeny v extrudéri
# prietokov povolením okamžitých zmien rýchlosti
# nástrojová hlava počas zatáčania. Táto hodnota konfiguruje interné
# algoritmus dostredivej rýchlosti zatáčania; rohy s uhlami
# väčší ako 90 stupňov bude mať vyššiu rýchlosť v zákrute
# rohy s uhlami menšími ako 90 stupňov budú mať nižšie
# rýchlosť v zákrute. Ak je toto nastavené na nulu, nástrojová hlava bude
# spomalenie na nulu v každom rohu. Predvolená hodnota je 5 mm/s.
```

### [stepper]

Stepper motor definitions. Different printer types (as specified by the "kinematics" option in the [printer] config section) require different names for the stepper (eg, `stepper_x` vs `stepper_a`). Below are common stepper definitions.

Informácie o výpočte parametra `rotation_distance` nájdete v [dokumente o vzdialenosti rotácie](Rotation_Distance.md). Informácie o navádzaní pomocou viacerých mikroovládačov nájdete v dokumente [Multi-MCU_Homing.md].

```
[stepper_x]
step_pin:
#   Step GPIO pin (triggered high). This parameter must be provided.
dir_pin:
#   Direction GPIO pin (high indicates positive direction). This
#   parameter must be provided.
enable_pin:
#   Enable pin (default is enable high; use ! to indicate enable
#   low). If this parameter is not provided then the stepper motor
#   driver must always be enabled.
rotation_distance:
#   Distance (in mm) that the axis travels with one full rotation of
#   the stepper motor (or final gear if gear_ratio is specified).
#   This parameter must be provided.
microsteps:
#   The number of microsteps the stepper motor driver uses. This
#   parameter must be provided.
#full_steps_per_rotation: 200
#   The number of full steps for one rotation of the stepper motor.
#   Set this to 200 for a 1.8 degree stepper motor or set to 400 for a
#   0.9 degree motor. The default is 200.
#gear_ratio:
#   The gear ratio if the stepper motor is connected to the axis via a
#   gearbox. For example, one may specify "5:1" if a 5 to 1 gearbox is
#   in use. If the axis has multiple gearboxes one may specify a comma
#   separated list of gear ratios (for example, "57:11, 2:1"). If a
#   gear_ratio is specified then rotation_distance specifies the
#   distance the axis travels for one full rotation of the final gear.
#   The default is to not use a gear ratio.
#step_pulse_duration:
#   The minimum time between the step pulse signal edge and the
#   following "unstep" signal edge. This is also used to set the
#   minimum time between a step pulse and a direction change signal.
#   The default is 0.000000100 (100ns) for TMC steppers that are
#   configured in UART or SPI mode, and the default is 0.000002 (which
#   is 2us) for all other steppers.
endstop_pin:
#   Endstop switch detection pin. If this endstop pin is on a
#   different mcu than the stepper motor then it enables "multi-mcu
#   homing". This parameter must be provided for the X, Y, and Z
#   steppers on cartesian style printers.
#position_min: 0
#   Minimum valid distance (in mm) the user may command the stepper to
#   move to.  The default is 0mm.
position_endstop:
#   Location of the endstop (in mm). This parameter must be provided
#   for the X, Y, and Z steppers on cartesian style printers.
position_max:
#   Maximum valid distance (in mm) the user may command the stepper to
#   move to. This parameter must be provided for the X, Y, and Z
#   steppers on cartesian style printers.
#homing_speed: 5.0
#   Maximum velocity (in mm/s) of the stepper when homing. The default
#   is 5mm/s.
#homing_retract_dist: 5.0
#   Distance to backoff (in mm) before homing a second time during
#   homing. Set this to zero to disable the second home. The default
#   is 5mm.
#homing_retract_speed:
#   Speed to use on the retract move after homing in case this should
#   be different from the homing speed, which is the default for this
#   parameter
#second_homing_speed:
#   Velocity (in mm/s) of the stepper when performing the second home.
#   The default is homing_speed/2.
#homing_positive_dir:
#   If true, homing will cause the stepper to move in a positive
#   direction (away from zero); if false, home towards zero. It is
#   better to use the default than to specify this parameter. The
#   default is true if position_endstop is near position_max and false
#   if near position_min.
```

### Kartézska kinematika

Príklad konfiguračného súboru karteziánskej kinematiky nájdete v [example-cartesian.cfg](../config/example-cartesian.cfg).

Tu sú popísané iba parametre špecifické pre kartezánske tlačiarne – dostupné parametre nájdete v časti [bežné kinematické nastavenia](#common-kinematic-settings).

```
[tlačiareň]
kinematika: karteziánska
max_z_velocity:
# Toto nastavuje maximálnu rýchlosť (v mm/s) pohybu pozdĺž z
# os. Toto nastavenie možno použiť na obmedzenie maximálnej rýchlosti
# krokový motor z. Predvolené je použitie max_velocity pre
# max_z_velocity.
max_z_accel:
# Toto nastavuje maximálne zrýchlenie (v mm/s^2) pohybu pozdĺž
# os z. Obmedzuje zrýchlenie krokového motora z. The
# predvolené je použitie max_accel pre max_z_accel.

# Sekcia stepper_x sa používa na popis ovládania steppera
# os X v karteziánskom robote.
[stepper_x]

# Sekcia stepper_y sa používa na popis ovládania steppera
# os Y v karteziánskom robote.
[stepper_y]

# Časť stepper_z sa používa na popis ovládania steppera
# os Z v karteziánskom robote.
[stepper_z]
```

### Lineárna delta kinematika

Príklad konfiguračného súboru lineárnej delta kinematiky nájdete v [example-delta.cfg](../config/example-delta.cfg). Informácie o kalibrácii nájdete v [príručke delta kalibrácie] (Delta_Calibrate.md).

Tu sú popísané iba parametre špecifické pre lineárne delta tlačiarne – dostupné parametre nájdete v časti [bežné kinematické nastavenia](#common-kinematic-settings).

```
[tlačiareň]
kinematika: delta
max_z_velocity:
# Pre delta tlačiarne to obmedzuje maximálnu rýchlosť (v mm/s).
# sa pohybuje s pohybom osi z. Toto nastavenie možno použiť na zníženie
# maximálna rýchlosť pohybov nahor/nadol (ktoré vyžadujú vyššiu rýchlosť krokov
# než iné pohyby na delta tlačiarni). Predvolená hodnota je použiť
# max_velocity pre max_z_velocity.
#max_z_accel:
# Toto nastavuje maximálne zrýchlenie (v mm/s^2) pohybu pozdĺž
# os z. Nastavenie môže byť užitočné, ak tlačiareň dosiahne vyššie
# zrýchlenie pri XY pohyboch ako pri Z (napr. pri použití vstupného tvarovača).
# Predvolené je použitie max_accel pre max_z_accel.
#minimum_z_position: 0
# Minimálna poloha Z, ktorú môže používateľ prikázať pohybu hlavy
# až. Predvolená hodnota je 0.
delta_radius:
# Polomer (v mm) vodorovného kruhu tvoreného tromi lineárnymi
# osové veže. Tento parameter možno vypočítať aj takto:
# delta_radius = smooth_rod_offset - effector_offset - carg_offset
# Tento parameter musí byť zadaný.
#print_radius:
# Polomer (v mm) platných súradníc XY hlavy nástroja. Jeden môže použiť
# toto nastavenie na prispôsobenie kontroly rozsahu pohybov nástrojovej hlavy. Ak
# je tu zadaná veľká hodnota, potom je možné zadať príkaz
# nástrojová hlava do zrážky s vežou. Predvolená hodnota je použiť
# delta_radius pre print_radius (čo by normálne zabránilo a
# kolízia veže).

# Časť stepper_a popisuje stepper ovládajúci prednú časť
# ľavá veža (pri 210 stupňoch). Táto sekcia tiež riadi navádzanie
# parametrov (homing_speed, homing_retract_dist) pre všetky veže.
[stepper_a]
position_endstop:
# Vzdialenosť (v mm) medzi tryskou a lôžkom, keď je tryska zapnutá
# v strede stavebnej oblasti a spúšťa sa koncový doraz. Toto
# parameter musí byť poskytnutý pre stepper_a; pre stepper_b a
# stepper_c tento parameter má predvolenú hodnotu zadanú pre
# stepper_a.
dĺžka ruky:
# Dĺžka (v mm) diagonálnej tyče, ktorá spája túto vežu s
# tlačová hlava. Tento parameter musí byť poskytnutý pre stepper_a; pre
# stepper_b a stepper_c tento parameter má predvolenú hodnotu
# zadané pre stepper_a.
#uhol:
# Táto možnosť určuje uhol (v stupňoch), pod ktorým je veža
# o. Predvolená hodnota je 210 pre stepper_a, 330 pre stepper_b a 90
# pre stepper_c.

# Časť stepper_b popisuje stepper ovládajúci prednú časť
# pravá veža (pri 330 stupňoch).
[stepper_b]

# Časť stepper_c popisuje stepper ovládajúci zadnú časť
# veža (pri 90 stupňoch).
[stepper_c]

# Sekcia delta_calibrate umožňuje rozšírenie DELTA_CALIBRATE
# Príkaz g-kódu, ktorý dokáže kalibrovať polohy koncových dorazov veže a
# uhly.
[delta_calibrate]
polomer:
# Polomer (v mm) oblasti, ktorá môže byť snímaná. Toto je polomer
# súradníc trysky, ktoré sa majú snímať; ak používate automatickú sondu
# s posunom XY, potom zvoľte dostatočne malý polomer, aby
#sonda sa vždy zmestí nad posteľ. Tento parameter je potrebné zadať.
#rýchlosť: 50
# Rýchlosť (v mm/s) nesnímaných pohybov počas kalibrácie.
# Predvolená hodnota je 50.
#horizontal_move_z: 5
# Výška (v mm), do ktorej sa má hlava pohnúť
# tesne pred spustením operácie sondy. Predvolená hodnota je 5.
```

### Deltézska kinematika

Príklad konfiguračného súboru deltézskej kinematiky nájdete v [example-deltesian.cfg](../config/example-deltesian.cfg).

Tu sú popísané iba parametre špecifické pre deltézske tlačiarne – dostupné parametre nájdete v časti [bežné kinematické nastavenia](#common-kinematic-settings).

```
[tlačiareň]
kinematika: deltézska
max_z_velocity:
# Pre deltézske tlačiarne to obmedzuje maximálnu rýchlosť (v mm/s).
# sa pohybuje s pohybom osi z. Toto nastavenie možno použiť na zníženie
# maximálna rýchlosť pohybov nahor/nadol (ktoré vyžadujú vyššiu rýchlosť krokov
# než iné pohyby na deltézskej tlačiarni). Predvolená hodnota je použiť
# max_velocity pre max_z_velocity.
#max_z_accel:
# Toto nastavuje maximálne zrýchlenie (v mm/s^2) pohybu pozdĺž
# os z. Nastavenie môže byť užitočné, ak tlačiareň dosiahne vyššie
# zrýchlenie pri XY pohyboch ako pri Z (napr. pri použití vstupného tvarovača).
# Predvolené je použitie max_accel pre max_z_accel.
#minimum_z_position: 0
# Minimálna poloha Z, ktorú môže používateľ prikázať pohybu hlavy
# až. Predvolená hodnota je 0.
#min_uhol: 5
# Predstavuje minimálny uhol (v stupňoch) vzhľadom k horizontále
# ktoré deltézske ramená môžu dosiahnuť. Tento parameter je
# určený na to, aby zabránil úplnej horizontálnej polohe ramien,
# čím by hrozilo náhodné prevrátenie osi XZ. Predvolená hodnota je 5.
#print_width:
# Vzdialenosť (v mm) platných súradníc X hlavy nástroja. Jeden môže použiť
# toto nastavenie na prispôsobenie kontroly rozsahu pohybov nástrojovej hlavy. Ak
# je tu zadaná veľká hodnota, potom je možné zadať príkaz
# nástrojová hlava do zrážky s vežou. Toto nastavenie zvyčajne
# zodpovedá šírke lôžka (v mm).
#slow_ratio: 3
# Pomer používaný na obmedzenie rýchlosti a zrýchlenia pri pohyboch v blízkosti
# extrémy osi X. Ak je vertikálna vzdialenosť delená horizontálou
# vzdialenosť presahuje hodnotu slow_ratio, potom rýchlosť a
# zrýchlenie je obmedzené na polovicu nominálnych hodnôt. Ak vertikálne
# vzdialenosť delená horizontálnou vzdialenosťou presahuje dvojnásobok hodnoty
# pomalý_pomer, potom rýchlosť a zrýchlenie sú obmedzené na jednu
# štvrtina ich nominálnych hodnôt. Predvolená hodnota je 3.

# Časť stepper_left sa používa na popis ovládania steppera
#ľavá veža. Táto sekcia tiež riadi parametre navádzania
# (homing_speed, homing_retract_dist) pre všetky veže.
[stepper_left]
position_endstop:
# Vzdialenosť (v mm) medzi tryskou a lôžkom, keď je tryska zapnutá
# v strede stavebnej oblasti a spustia sa koncové zarážky. Toto
# parameter musí byť poskytnutý pre stepper_left; pre stepper_right toto
# parameter je predvolene nastavený na hodnotu zadanú pre stepper_left.
dĺžka ruky:
# Dĺžka (v mm) diagonálnej tyče, ktorá spája vozík veže s
# tlačová hlava. Tento parameter musí byť poskytnutý pre stepper_left; pre
# stepper_right, tento parameter má predvolenú hodnotu zadanú pre
# stepper_left.
rameno_x_dĺžka:
# Horizontálna vzdialenosť medzi tlačovou hlavou a vežou, keď je
# tlačiarní je doma. Tento parameter musí byť poskytnutý pre stepper_left;
# pre stepper_right, tento parameter má predvolenú hodnotu zadanú pre
# stepper_left.

# Sekcia stepper_right sa používa na popis steppera, ktorý ovláda
# pravá veža.
[stepper_right]

# Sekcia stepper_y sa používa na popis ovládania steppera
# os Y v deltézskom robote.
[stepper_y]
```

### Kinematika CoreXY

Pozrite si [example-corexy.cfg](../config/example-corexy.cfg), kde nájdete príklad súboru kinematiky corexy (a h-bot).

Tu sú popísané iba parametre špecifické pre tlačiarne Corexy – dostupné parametre nájdete v časti [bežné kinematické nastavenia](#common-kinematic-settings).

```
[tlačiareň]
kinematika: Corexy
max_z_velocity:
# Toto nastavuje maximálnu rýchlosť (v mm/s) pohybu pozdĺž z
# os. Toto nastavenie možno použiť na obmedzenie maximálnej rýchlosti
# krokový motor z. Predvolené je použitie max_velocity pre
# max_z_velocity.
max_z_accel:
# Toto nastavuje maximálne zrýchlenie (v mm/s^2) pohybu pozdĺž
# os z. Obmedzuje zrýchlenie krokového motora z. The
# predvolené je použitie max_accel pre max_z_accel.

# Časť stepper_x sa používa na opis osi X, ako aj osi X
# stepper ovládajúci pohyb X+Y.
[stepper_x]

# Sekcia stepper_y sa používa na opis osi Y, ako aj osi Y
# stepper ovládajúci pohyb X-Y.
[stepper_y]

# Časť stepper_z sa používa na popis ovládania steppera
# os Z.
[stepper_z]
```

### Kinematika CoreXZ

Príklad konfiguračného súboru kinematiky corexz nájdete v [example-corexz.cfg](../config/example-corexz.cfg).

Tu sú popísané iba parametre špecifické pre tlačiarne Corexz – dostupné parametre nájdete v časti [bežné kinematické nastavenia](#common-kinematic-settings).

```
[tlačiareň]
kinematika: corexz
max_z_velocity:
# Toto nastavuje maximálnu rýchlosť (v mm/s) pohybu pozdĺž z
# os. Predvolená hodnota je použitie max_velocity pre max_z_velocity.
max_z_accel:
# Toto nastavuje maximálne zrýchlenie (v mm/s^2) pohybu pozdĺž
# os z. Predvolené je použitie max_accel pre max_z_accel.

# Časť stepper_x sa používa na opis osi X, ako aj osi X
# stepper ovládajúci pohyb X+Z.
[stepper_x]

# Sekcia stepper_y sa používa na popis ovládania steppera
# os Y.
[stepper_y]

# Časť stepper_z sa používa na popis osi Z, ako aj osi Z
# stepper ovládajúci pohyb X-Z.
[stepper_z]
```

### Hybrid-CoreXY kinematika

Príklad konfiguračného súboru hybridnej kinematiky Corexy nájdete v [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg).

This kinematic is also known as Markforged kinematic.

Tu sú popísané iba parametre špecifické pre hybridné tlačiarne Corexy, kde nájdete dostupné parametre v časti [bežné kinematické nastavenia](#common-kinematic-settings).

```
[printer]
kinematics: hybrid_corexy
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. The default is to use max_velocity for max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. The default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the X axis as well as the
# stepper controlling the X-Y movement.
[stepper_x]

# The stepper_y section is used to describe the stepper controlling
# the Y axis.
[stepper_y]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
[stepper_z]
```

### Hybrid-CoreXZ kinematika

Príklad konfiguračného súboru hybridnej kinematiky corexz nájdete v [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg).

This kinematic is also known as Markforged kinematic.

Tu sú popísané iba parametre špecifické pre hybridné tlačiarne Corexy, kde nájdete dostupné parametre v časti [bežné kinematické nastavenia](#common-kinematic-settings).

```
[tlačiareň]
kinematika: hybrid_corexz
max_z_velocity:
# Toto nastavuje maximálnu rýchlosť (v mm/s) pohybu pozdĺž z
# os. Predvolená hodnota je použitie max_velocity pre max_z_velocity.
max_z_accel:
# Toto nastavuje maximálne zrýchlenie (v mm/s^2) pohybu pozdĺž
# os z. Predvolené je použitie max_accel pre max_z_accel.

# Časť stepper_x sa používa na opis osi X, ako aj osi X
# stepper ovládajúci pohyb X-Z.
[stepper_x]

# Sekcia stepper_y sa používa na popis ovládania steppera
# os Y.
[stepper_y]

# Časť stepper_z sa používa na popis ovládania steppera
# os Z.
[stepper_z]
```

### Polárna kinematika

Príklad konfiguračného súboru polárnej kinematiky nájdete v [example-polar.cfg](../config/example-polar.cfg).

Tu sú popísané iba parametre špecifické pre polárne tlačiarne – dostupné parametre nájdete v časti [bežné kinematické nastavenia](#common-kinematic-settings).

POLÁRNA KINEMATIKA PREBIEHA. Je známe, že pohyby okolo polohy 0, 0 nefungujú správne.

```
[tlačiareň]
kinematika: polárna
max_z_velocity:
# Toto nastavuje maximálnu rýchlosť (v mm/s) pohybu pozdĺž z
# os. Toto nastavenie možno použiť na obmedzenie maximálnej rýchlosti
# krokový motor z. Predvolené je použitie max_velocity pre
# max_z_velocity.
max_z_accel:
# Toto nastavuje maximálne zrýchlenie (v mm/s^2) pohybu pozdĺž
# os z. Obmedzuje zrýchlenie krokového motora z. The
# predvolené je použitie max_accel pre max_z_accel.

# Časť stepper_bed sa používa na popis ovládania steppera
# lôžko.
[stepper_bed]
prevodový pomer:
# Musí byť špecifikovaný gear_ratio a rotácia nesmie byť
# špecifikované. Napríklad, ak má posteľ poháňanú 80 ozubenú kladku
# stepperom so 16 ozubenou kladkou, potom by sa dalo špecifikovať a
# prevodový pomer "80:16". Tento parameter je potrebné zadať.

# Časť stepper_arm sa používa na popis ovládania steppera
# kočiar na ramene.
[stepper_arm]

# Časť stepper_z sa používa na popis ovládania steppera
# os Z.
[stepper_z]
```

### Rotačná delta kinematika

Príklad konfiguračného súboru rotačnej delta kinematiky nájdete v [example-rotary-delta.cfg](../config/example-rotary-delta.cfg).

Tu sú popísané iba parametre špecifické pre rotačné delta tlačiarne – dostupné parametre nájdete v [bežné kinematické nastavenia](#common-kinematic-settings).

OTOČNÁ DELTA KINEMATIKA SÚ PRÁCA. Pohyby navádzania môžu uplynúť časový limit a niektoré kontroly hraníc nie sú implementované.

```
[tlačiareň]
kinematika: rotačná_delta
max_z_velocity:
# Pre delta tlačiarne to obmedzuje maximálnu rýchlosť (v mm/s).
# sa pohybuje s pohybom osi z. Toto nastavenie možno použiť na zníženie
# maximálna rýchlosť pohybov nahor/nadol (ktoré vyžadujú vyššiu rýchlosť krokov
# než iné pohyby na delta tlačiarni). Predvolená hodnota je použiť
# max_velocity pre max_z_velocity.
#minimum_z_position: 0
# Minimálna poloha Z, ktorú môže používateľ prikázať pohybu hlavy
# až. Predvolená hodnota je 0.
polomer_ ramena:
# Polomer (v mm) vodorovného kruhu tvoreného tromi
# ramenných kĺbov mínus polomer kruhu tvoreného
# efektorové kĺby. Tento parameter možno vypočítať aj takto:
# ramenný_radius = (delta_f - delta_e) / sqrt(12)
# Tento parameter musí byť zadaný.
ramenná_výška:
# Vzdialenosť (v mm) ramenných kĺbov od lôžka mínus
# výška nástrojovej hlavy efektora. Tento parameter je potrebné zadať.

# Časť stepper_a popisuje stepper ovládajúci zadnú časť
# pravá ruka (pri 30 stupňoch). Táto sekcia tiež riadi navádzanie
# parametrov (homing_speed, homing_retract_dist) pre všetky ramená.
[stepper_a]
prevodový pomer:
# Musí byť špecifikovaný gear_ratio a rotácia nesmie byť
# špecifikované. Napríklad, ak má rameno poháňanú 80 ozubenú kladku
# pomocou kladky so 16 zubami, ktorá je zase pripojená k 60
# ozubená remenica poháňaná stepperom so 16 ozubenou remenicou, potom
# jeden by špecifikoval prevodový pomer "80:16, 60:16". Tento parameter
# musí byť poskytnuté.
position_endstop:
# Vzdialenosť (v mm) medzi tryskou a lôžkom, keď je tryska zapnutá
# v strede stavebnej oblasti a spúšťa sa koncový doraz. Toto
# parameter musí byť poskytnutý pre stepper_a; pre stepper_b a
# stepper_c tento parameter má predvolenú hodnotu zadanú pre
# stepper_a.
dĺžka_horného_ramene:
# Dĺžka (v mm) ramena spájajúceho "ramenný kĺb" s
# "lakťový kĺb". Tento parameter musí byť poskytnutý pre stepper_a; pre
# stepper_b a stepper_c tento parameter má predvolenú hodnotu
# zadané pre stepper_a.
Lower_arm_length:
# Dĺžka (v mm) ramena spájajúceho "lakťový kĺb" s
# "efektorový kĺb". Tento parameter musí byť poskytnutý pre stepper_a;
# pre stepper_b a stepper_c tento parameter má predvolenú hodnotu
# zadané pre stepper_a.
#uhol:
# Táto možnosť určuje uhol (v stupňoch), v ktorom je rameno.
# Predvolená hodnota je 30 pre stepper_a, 150 pre stepper_b a 270 pre
# stepper_c.

# Časť stepper_b popisuje stepper ovládajúci zadnú časť
# ľavá ruka (v uhle 150 stupňov).
[stepper_b]

# Časť stepper_c popisuje stepper ovládajúci prednú časť
# rameno (pri 270 stupňoch).
[stepper_c]

# Sekcia delta_calibrate umožňuje rozšírenie DELTA_CALIBRATE
# Príkaz g-kódu, ktorý dokáže kalibrovať polohy koncových dorazov ramien.
[delta_calibrate]
polomer:
# Polomer (v mm) oblasti, ktorá môže byť snímaná. Toto je polomer
# súradníc trysky, ktoré sa majú snímať; ak používate automatickú sondu
# s posunom XY, potom zvoľte dostatočne malý polomer, aby
#sonda sa vždy zmestí nad posteľ. Tento parameter je potrebné zadať.
#rýchlosť: 50
# Rýchlosť (v mm/s) nesnímaných pohybov počas kalibrácie.
# Predvolená hodnota je 50.
#horizontal_move_z: 5
# Výška (v mm), do ktorej sa má hlava pohnúť
# tesne pred spustením operácie sondy. Predvolená hodnota je 5.
```

### Navíjanie kábla Kinematika

Príklad konfiguračného súboru kinematiky káblového navijaka nájdete v [example-winch.cfg](../config/example-winch.cfg).

Tu sú popísané iba parametre špecifické pre tlačiarne káblových navijakov – dostupné parametre nájdete v časti [bežné kinematické nastavenia](#common-kinematic-settings).

PODPORA KÁBLOVÉHO NAVIJÁKA JE EXPERIMENTÁLNA. Navádzanie nie je implementované na kinematike lanového navijaka. Ak chcete tlačiareň vrátiť do pôvodného stavu, manuálne odošlite príkazy pohybu, kým nebude hlava nástroja na 0, 0, 0, a potom zadajte príkaz „G28“.

```
[tlačiareň]
kinematika: navijak

# Časť stepper_a popisuje stepper pripojený k prvému
# lanový navijak. Minimálne môžu byť 3 a maximálne 26 lanových navijakov
# definované (stepper_a až stepper_z), hoci je bežné definovať 4.
[stepper_a]
rotačná_vzdialenosť:
# Rotation_distance je nominálna vzdialenosť (v mm) od hlavy nástroja
# sa posunie smerom k lanovému navijaku pri každom plnom otočení
#   krokový motor. Tento parameter je potrebné zadať.
kotva_x:
kotva_y:
kotva_z:
# Poloha X, Y a Z lanového navijaka v karteziánskom priestore.
# Tieto parametre musia byť poskytnuté.
```

### Žiadna kinematika

Je možné definovať špeciálnu "žiadnu" kinematiku na vypnutie kinematickej podpory v Klipper. To môže byť užitočné pri ovládaní zariadení, ktoré nie sú typickými 3D tlačiarňami, alebo na účely ladenia.

```
[tlačiareň]
kinematika: žiadna
maximálna_rýchlosť: 1
max_accel: 1
# Parametre max_velocity a max_accel musia byť definované. The
# hodnoty sa nepoužívajú pre „žiadnu“ kinematiku.
```

## Spoločný extrudér a podpora vyhrievaného lôžka

### [extruder]

The extruder section is used to describe the heater parameters for the nozzle hotend along with the stepper controlling the extruder. See the [command reference](G-Codes.md#extruder) for additional information. See the [pressure advance guide](Pressure_Advance.md) for information on tuning pressure advance.

```
[extrudér]
step_pin:
dir_pin:
enable_pin:
mikrokroky:
rotačná_vzdialenosť:
#full_steps_per_rotation:
#gear_ratio:
# Popis vyššie uvedeného nájdete v časti „stepper“.
# parametrov. Ak nie je špecifikovaný žiadny z vyššie uvedených parametrov, potom nie
# stepper bude priradený k hotendu trysky (hoci a
# Príkaz SYNC_EXTRUDER_MOTION môže priradiť jeden za behu).
tryska_priemer:
# Priemer otvoru trysky (v mm). Tento parameter musí byť
# poskytnuté.
priemer_vlákna:
# Menovitý priemer surového vlákna (v mm) pri jeho vstupe do
# extrudér. Tento parameter je potrebné zadať.
#max_extrude_cross_section:
# Maximálna plocha (v mm^2) prierezu extrúzie (napr.
# šírka vytláčania vynásobená výškou vrstvy). Toto nastavenie zabraňuje
# nadmerné množstvo vytláčania počas relatívne malých pohybov XY.
# Ak pohyb vyžaduje rýchlosť vytláčania, ktorá by prekročila túto hodnotu
# spôsobí, že sa vráti chyba. Predvolená hodnota je: 4,0 *
# priemer_dýzy^2
#instantaneous_corner_velocity: 1 000
# Maximálna okamžitá zmena rýchlosti (v mm/s).
# extrudér počas spojenia dvoch ťahov. Predvolená hodnota je 1 mm/s.
#max_extrude_only_distance: 50,0
# Maximálna dĺžka (v mm surového filamentu), pri ktorej sa zatiahne resp
# presun iba na vysunutie môže mať. Ak je pohyb iba zatiahnutie alebo vysunutie
# požaduje vzdialenosť väčšiu ako je táto hodnota, spôsobí to chybu
# na vrátenie. Predvolená hodnota je 50 mm.
#max_extrude_only_velocity:
#max_extrude_only_accel:
# Maximálna rýchlosť (v mm/s) a zrýchlenie (v mm/s^2) stroja
# motor extrudéra pre zasúvanie a pohyby iba pri vytláčaní. Títo
# nastavenia nemajú žiadny vplyv na bežné tlačové pohyby. Ak nie
# potom sa vypočítajú tak, aby zodpovedali limitu XY
# tlačový pohyb s prierezom 4,0*priemer_dýzy^2 by
# mať.
#pressure_advance: 0,0
# Množstvo surového vlákna, ktoré sa má vtlačiť do extrudéra
# zrýchlenie extrudéra. Rovnaké množstvo vlákna sa zatiahne
# počas spomaľovania. Meria sa v milimetroch na
# milimeter/sekundu. Predvolená hodnota je 0, ktorá deaktivuje tlak
# záloha.
#pressure_advance_smooth_time: 0,040
# Časový rozsah (v sekundách), ktorý sa má použiť pri výpočte priemeru
# rýchlosť extrudéra pre posun tlaku. Výsledkom je väčšia hodnota
# hladšie pohyby extrudéra. Tento parameter nesmie presiahnuť 200 ms.
# Toto nastavenie sa použije iba vtedy, ak je tlak_predstihu nenulový. The
# predvolená hodnota je 0,040 (40 milisekúnd).
#
# Zostávajúce premenné popisujú ohrievač extrudéra.
ohrievač_pin:
# Výstupný kolík PWM ovládajúci ohrievač. Tento parameter musí byť
# poskytnuté.
#max_power: 1,0
# Maximálny výkon (vyjadrený ako hodnota od 0,0 do 1,0), ktorý
# heat_pin môže byť nastavený na. Hodnota 1,0 umožňuje nastavenie kolíka
# plne povolené na dlhšie obdobia, kým hodnota 0,5 by bola
# dovoľte, aby bol PIN povolený maximálne na polovicu času. Toto
Nastavenie # možno použiť na obmedzenie celkového výstupného výkonu (príliš rozšírené
# obdobia) do ohrievača. Predvolená hodnota je 1.0.
senzor_typ:
# Typ snímača - bežné termistory sú "EPCOS 100K B57560G104F",
# "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Všeobecné
# 3950","Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
# "SliceEngineering 450" a "TDK NTCG104LH104JT1". Pozrite si
# Časť "Snímače teploty" pre ostatné snímače. Tento parameter
# musí byť poskytnuté.
senzor_pin:
# Analógový vstupný kolík pripojený k senzoru. Tento parameter musí byť
# poskytnuté.
#pullup_rezistor: 4700
# Odpor (v ohmoch) pullupu pripojeného k termistoru.
# Tento parameter je platný len vtedy, keď je snímačom termistor. The
# predvolená hodnota je 4700 ohmov.
#smooth_time: 1,0
# Hodnota času (v sekundách), počas ktorej budú merania teploty
# byť vyhladený, aby sa znížil vplyv hluku merania. Predvolená hodnota
# je 1 sekunda.
ovládanie:
# Riadiaci algoritmus (buď pid alebo vodoznak). Tento parameter musí
#   byť poskytovaný.
pid_Kp:
pid_Ki:
pid_Kd:
# Proporcionálny (pid_Kp), integrál (pid_Ki) a derivácia
# (pid_Kd) nastavenia pre PID spätnoväzbový riadiaci systém. Klipper
# vyhodnotí nastavenia PID podľa nasledujúceho všeobecného vzorca:
# heat_pwm = (Kp*chyba + Ki*integrál (chyba) - Kd*derivácia (chyba)) / 255
# Kde "chyba" je "requested_temperature - meraná_teplota"
# a "heater_pwm" je požadovaná rýchlosť ohrevu, pričom 0,0 je plné
# vypnuté a 1.0 je plne zapnuté. Zvážte použitie PID_CALIBRATE
# príkaz na získanie týchto parametrov. Pid_Kp, pid_Ki a pid_Kd
Pre ohrievače PID musia byť poskytnuté # parametre.
#max_delta: 2,0
# Na ohrievačoch riadených 'vodoznakom' je to počet stupňov v
# Celzia nad cieľovou teplotou pred vypnutím ohrievača
# ako aj počet stupňov pod cieľom predtým
# opätovné zapnutie ohrievača. Predvolená hodnota je 2 stupne Celzia.
#pwm_cycle_time: 0,100
# Čas v sekundách pre každý softvérový cyklus PWM ohrievača. to je
# sa neodporúča nastavovať
pokiaľ tam nie je elektrina
# požiadavka spínať ohrievač rýchlejšie ako 10-krát za sekundu.
# Predvolená hodnota je 0,100 sekundy.
#min_extrude_temp: 170
# Minimálna teplota (v stupňoch Celzia), pri ktorej sa extrudér pohybuje
Môžu byť vydané # príkazy. Predvolená hodnota je 170 stupňov Celzia.
min_temp:
max_temp:
# Maximálny rozsah platných teplôt (v stupňoch Celzia), ktoré
Vnútri musí zostať # ohrievač. Toto ovláda bezpečnostný prvok
# implementovaný v kóde mikrokontroléra - mal by sa merať
# teplota nikdy neklesne mimo tento rozsah potom mikroovládač
# prejde do stavu vypnutia. Táto kontrola môže pomôcť odhaliť niektoré
# poruchy hardvéru ohrievača a snímača. Nastavte tento rozsah len široko
# dosť na to, aby rozumné teploty neviedli k chybe.
# Tieto parametre musia byť poskytnuté.
```

### [heater_bed]

The heater_bed section describes a heated bed. It uses the same heater settings described in the "extruder" section.

```
[heat_bed]
ohrievač_pin:
senzor_typ:
senzor_pin:
ovládanie:
min_temp:
max_temp:
# Popis vyššie uvedených parametrov nájdete v časti "extrudér".
```

## Podpora úrovne lôžka

### [bed_mesh]

Vyrovnávanie sieťového lôžka. Je možné definovať konfiguračnú sekciu bed_mesh na umožnenie transformácií pohybu, ktoré odsadzujú os z na základe siete vygenerovanej zo snímaných bodov. Pri použití sondy na umiestnenie osi z sa odporúča definovať sekciu safe_z_home v súbore printer.cfg smerom k stredu oblasti tlače.Vyrovnávanie sieťového lôžka. Je možné definovať konfiguračnú sekciu bed_mesh na umožnenie transformácií pohybu, ktoré odsadzujú os z na základe siete vygenerovanej zo snímaných bodov. Pri použití sondy na umiestnenie osi z sa odporúča definovať sekciu safe_z_home v súbore printer.cfg smerom k stredu oblasti tlače.

Ďalšie informácie nájdete v [sprievodcovi sieťkou postele] (Bed_Mesh.md) a [odkaz na príkaz] (G-Codes.md#bed_mesh).

Visual Examples:

```
 obdĺžnikové lôžko, počet sond = 3, 3:
              x---x---x (max_point)
              |
              x---x---x
                      |
  (min_bod) x---x---x

  okrúhla posteľ, round_probe_count = 5, bed_radius = r:
                  x (0, r) koniec
                /
              x---x---x
                        \
  (-r, 0) x---x---x---x---x (r, 0)
            \
              x---x---x
                    /
                  x (0, -r) zač
```

```
[sieťovina]
#rýchlosť: 50
#       Rýchlosť (v mm/s) nesnímaných pohybov počas kalibrácie.
#       Predvolená hodnota je 50.
#horizontal_move_z: 5
#       Výška (v mm), do ktorej sa má hlava pohnúť
#       tesne pred spustením operácie sondy. Predvolená hodnota je 5.
#mesh_radius:
#       Definuje polomer siete na snímanie pre okrúhle lôžka. Poznač si to
#       polomer je relatívny k súradniciam špecifikovaným v
#       možnosť mesh_origin. Tento parameter musí byť poskytnutý pre okrúhle lôžka
#       a vynechané pre obdĺžnikové postele.
#mesh_origin:
#       Definuje stredovú súradnicu X, Y siete pre okrúhle lôžka. Toto
#       súradnica je relatívna k polohe sondy. Môže to byť užitočné
#       upraviť mesh_origin v snahe maximalizovať veľkosť
#       polomer siete. Predvolená hodnota je 0, 0. Tento parameter musí byť vynechaný
#       obdĺžnikové postele.
#mesh_min:
#       Definuje minimálnu súradnicu X, Y siete pre obdĺžnikovú
#       postele. Táto súradnica je relatívna k umiestneniu sondy. Toto
#       bude prvý testovaný bod najbližšie k začiatku. Toto
Pre obdĺžnikové postele je potrebné zadať # parameter.
#mesh_max:
#       Definuje maximálnu súradnicu X, Y siete pre obdĺžnikovú
#       postele. Dodržiava rovnaký princíp ako mesh_min, ale bude to tak
#       byť najvzdialenejším bodom skúmaným od pôvodu postele. Tento parameter
#       musí byť poskytnuté pre obdĺžnikové postele.
#probe_count: 3, 3
#       V prípade obdĺžnikových postelí ide o pár celých čísel oddelených čiarkou
#       hodnoty X, Y definujúce počet bodov, ktoré sa majú nasnímať pozdĺž každého z nich
#       os. Platí aj jedna hodnota, v takom prípade bude táto hodnota
#       sa aplikuje na obe osi. Predvolená hodnota je 3, 3.
#round_probe_count: 5
#       Pre okrúhle postele táto celočíselná hodnota definuje maximálny počet
#       bodov na snímanie pozdĺž každej osi. Táto hodnota musí byť nepárne číslo.
#       Predvolená hodnota je 5.
#fade_start: 1.0
#       Pozícia z gcode, v ktorej sa má začať postupné odstraňovanie z-úpravy
#       keď je aktivované zoslabovanie. Predvolená hodnota je 1.0.
#fade_end: 0,0
#       Pozícia gcode z, v ktorej sa ukončuje postupné vyraďovanie. Pri nastavení na a
#       hodnota pod fade_start, fade je vypnutý. Treba poznamenať, že
#       Fade môže pridať nežiaduce škálovanie pozdĺž osi z tlače. Ak
#       používateľ si želá povoliť miznutie, odporúča sa hodnota 10,0.
#       Predvolená hodnota je 0,0, čo zakáže miznutie.
#fade_target:
#       Pozícia z, v ktorej by sa malo zoslabovanie zbiehať. Keď je táto hodnota
#       nastavený na nenulovú hodnotu, musí byť v rozsahu hodnôt z
#       sieťovina. Používatelia, ktorí chcú konvergovať do východiskovej pozície z
#       by to malo nastaviť na 0. Predvolená hodnota je priemerná hodnota z siete.
#split_delta_z: 0,025
#       Veľkosť rozdielu Z (v mm) pozdĺž pohybu, ktorý sa spustí
#       rozdelenie. Predvolená hodnota je 0,025.
#move_check_distance: 5,0
#       Vzdialenosť (v mm) pozdĺž pohybu na kontrolu split_delta_z.
#       Toto je tiež minimálna dĺžka, ktorú je možné rozdeliť. Predvolené
#       je 5,0.
#mesh_pps: 2, 2
#       Čiarkami oddelený pár celých čísel X, Y definujúcich počet
#       bodov na segment na interpoláciu v sieti pozdĺž každej osi. A
#       "segment" môže byť definovaný ako priestor medzi každým snímaným bodom.
#       Používateľ môže zadať jedinú hodnotu, ktorá sa použije na obe
#       osí. Predvolená hodnota je 2, 2.
#algoritmus: lagrange
#       Algoritmus interpolácie, ktorý sa má použiť. Môže byť buď "lagrange" alebo
#       „bikubický“. Táto možnosť neovplyvní mriežky 3x3, ktoré sú vynútené
#       použiť lagrangeov vzorkovanie. Predvolená hodnota je lagrange.
#bicubic_tension: .2
#       Pri použití bikubického algoritmu môže vyššie uvedený parameter napätia
#       sa použije na zmenu veľkosti interpolovaného sklonu. Väčšie
#       čísla zvýšia veľkosť sklonu, čo má za následok viac
#       zakrivenie v sieťke. Predvolená hodnota je .2.
#zero_reference_position:
#       Voliteľná súradnica X,Y, ktorá určuje umiestnenie na posteli
#       kde Z = 0. Keď je zadaná táto možnosť, sieť bude posunutá
#       tak, aby na tomto mieste došlo k nastaveniu nuly Z. Predvolená hodnota je
#       žiadna nulová referencia.
#relative_reference_index:
#       **UKONČENÉ, použite možnosť „nulová_referenčná_pozícia“**
#       Starú možnosť nahradenú „nulovou referenčnou pozíciou“.
#       Namiesto súradnice táto možnosť používa celé číslo "index".
#       označuje umiestnenie jedného z vygenerovaných bodov. Odporúča sa
#       použiť "nulovú_referenčnú_pozíciu" namiesto tejto možnosti pre nové
#       konfigurácií. Predvolená hodnota nie je relatívny referenčný index.
#faulty_region_1_min:
#faulty_region_1_max:
#       Voliteľné body, ktoré definujú chybnú oblasť. Pozrite si docs/Bed_Mesh.md
#       pre podrobnosti o chybných regiónoch. Je možné pridať až 99 chybných oblastí.
#       V predvolenom nastavení nie sú nastavené žiadne chybné oblasti.
```

### [bed_tilt]

Kompenzácia sklonu lôžka. Je možné definovať konfiguračnú sekciu bed_tilt, ktorá umožní transformácie pohybu, ktoré zodpovedajú naklonenej posteli. Všimnite si, že bed_mesh a bed_tilt sú nekompatibilné; oboje nemožno definovať.

Ďalšie informácie nájdete v [odkaz na príkaz](G-Codes.md#bed_tilt).

```
[bed_tilt]
#x_adjust: 0
# Množstvo, ktoré sa má pridať k výške Z každého pohybu pre každý mm na X
# os. Predvolená hodnota je 0.
#y_adjust: 0
# Množstvo, ktoré sa má pridať k výške Z každého pohybu pre každý mm na Y
# os. Predvolená hodnota je 0.
#z_adjust: 0
# Množstvo, ktoré sa má pridať k výške Z, keď je dýza v nominálnej polohe
# 0, 0. Predvolená hodnota je 0.
# Zostávajúce parametre ovládajú rozšírenú BED_TILT_CALIBRATE
# príkaz g-code, ktorý možno použiť na kalibráciu vhodných x a y
# parametre nastavenia.
#body:
# Zoznam súradníc X, Y (jedna na riadok; nasledujúce riadky
# odsadené), ktoré by mali byť testované počas BED_TILT_CALIBRATE
# príkaz. Zadajte súradnice dýzy a uistite sa, že ide o sondu
# je nad lôžkom na daných súradniciach trysky. Predvolená hodnota je
#, aby sa príkaz nepovolil.
#rýchlosť: 50
# Rýchlosť (v mm/s) nesnímaných pohybov počas kalibrácie.
# Predvolená hodnota je 50.
#horizontal_move_z: 5
# Výška (v mm), do ktorej sa má hlava pohnúť
# tesne pred spustením operácie sondy. Predvolená hodnota je 5.
```

### [bed_screws]

Tool to help adjust bed leveling screws. One may define a [bed_screws] config section to enable a BED_SCREWS_ADJUST g-code command.

Ďalšie informácie nájdete v [príručke na vyrovnávanie](Manual_Level.md#adjusting-bed-leveling-screws) a [referencia príkazu](G-Codes.md#bed_screws).

```
[posteľné_skrutky]
#skrutka1:
# Súradnice X, Y prvej vyrovnávacej skrutky lôžka. Toto je
# poloha na ovládanie trysky, ktorá je priamo nad posteľou
# skrutku (alebo čo najbližšie, kým je stále nad posteľou).
# Tento parameter musí byť zadaný.
#screw1_name:
# Ľubovoľný názov pre danú skrutku. Tento názov sa zobrazí, keď
# sa spustí pomocný skript. Predvolené je použiť názov založený na
# miesto skrutky XY.
#screw1_fine_adjust:
# Súradnica X, Y na prikázanie dýze, aby bolo možné jemné
# nalaďte vyrovnávaciu skrutku lôžka. Predvolená hodnota je nefungovať dobre
# úpravy na skrutke lôžka.
#skrutka2:
#screw2_name:
#screw2_fine_adjust:
#...
# Prídavné vyrovnávacie skrutky lôžka. Musia byť aspoň tri skrutky
# definované.
#horizontal_move_z: 5
# Výška (v mm), do ktorej sa má hlava pohnúť
# pri prechode z jedného miesta skrutky na ďalšie. Predvolená hodnota je 5.
#probe_height: 0
# Výška sondy (v mm) po úprave pre tepelnú teplotu
# rozšírenie lôžka a trysky. Predvolená hodnota je nula.
#rýchlosť: 50
# Rýchlosť (v mm/s) nesnímaných pohybov počas kalibrácie.
# Predvolená hodnota je 50.
#probe_speed: 5
# Rýchlosť (v mm/s) pri pohybe z polohy horizontal_move_z
# do polohy probe_height. Predvolená hodnota je 5.
```

### [screws_tilt_adjust]

Tool to help adjust bed screws tilt using Z probe. One may define a screws_tilt_adjust config section to enable a SCREWS_TILT_CALCULATE g-code command.

Ďalšie informácie nájdete v [príručke na vyrovnávanie](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) a [referencia príkazu](G-Codes.md#screws_tilt_adjust).

```
[screws_tilt_adjust]
#skrutka1:
# Súradnice (X, Y) prvej vyrovnávacej skrutky lôžka. Toto je
# poloha na prikázanie tryske, aby bola sonda priamo
# nad skrutkou lôžka (alebo čo najbližšie, kým ešte je
# nad posteľou). Toto je základná skrutka používaná pri výpočtoch. Toto
Musíte zadať # parameter.
#screw1_name:
# Ľubovoľný názov pre danú skrutku. Tento názov sa zobrazí, keď
# sa spustí pomocný skript. Predvolené je použiť názov založený na
# miesto skrutky XY.
#skrutka2:
#screw2_name:
#...
# Prídavné vyrovnávacie skrutky lôžka. Musia byť aspoň dve skrutky
# definované.
#rýchlosť: 50
# Rýchlosť (v mm/s) nesnímaných pohybov počas kalibrácie.
# Predvolená hodnota je 50.
#horizontal_move_z: 5
# Výška (v mm), do ktorej sa má hlava pohnúť
# tesne pred spustením operácie sondy. Predvolená hodnota je 5.
#screw_thread: CW-M3
# Typ skrutky používanej na vyrovnanie lôžka, M3, M4 alebo M5, a
# smer otáčania gombíka, ktorý sa používa na vyrovnanie lôžka.
# Akceptované hodnoty: CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
# Predvolená hodnota je CW-M3, ktorú používa väčšina tlačiarní. A v smere hodinových ručičiek
# otáčaním gombíka sa zmenšuje medzera medzi tryskou a tryskou
#   posteľ. Naopak, otáčanie proti smeru hodinových ručičiek zväčšuje medzeru.
```

### [z_tilt]

Viacnásobné nastavenie náklonu kroka Z. Táto funkcia umožňuje nezávislé nastavenie viacerých stepperov z (pozri časť „stepper_z1“) na nastavenie sklonu. Ak je táto sekcia prítomná, potom bude k dispozícii rozšírený [príkaz G-kódu] (G-Codes.md#z_tilt) Z_TILT_ADJUST.

```
[z_tilt]
#z_positions:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) describing the location of each bed "pivot point". The
#   "pivot point" is the point where the bed attaches to the given Z
#   stepper. It is described using nozzle coordinates (the X, Y position
#   of the nozzle if it could move directly above the point). The
#   first entry corresponds to stepper_z, the second to stepper_z1,
#   the third to stepper_z2, etc. This parameter must be provided.
#points:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) that should be probed during a Z_TILT_ADJUST command.
#   Specify coordinates of the nozzle and be sure the probe is above
#   the bed at the given nozzle coordinates. This parameter must be
#   provided.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#retries: 0
#   Number of times to retry if the probed points aren't within
#   tolerance.
#retry_tolerance: 0
#   If retries are enabled then retry if largest and smallest probed
#   points differ more than retry_tolerance. Note the smallest unit of
#   change here would be a single step. However if you are probing
#   more points than steppers then you will likely have a fixed
#   minimum value for the range of probed points which you can learn
#   by observing command output.
```

### [quad_gantry_level]

Nivelácia pohyblivého portálu pomocou 4 nezávisle riadených Z motorov. Opravuje efekty hyperbolickej paraboly (zemiakový čip) na pohyblivom portáli, ktorý je flexibilnejší. VAROVANIE: Použitie tohto na pohyblivom lôžku môže viesť k nežiaducim výsledkom. Ak je táto sekcia prítomná, sprístupní sa rozšírený príkaz G-kódu QUAD_GANTRY_LEVEL. Táto rutina predpokladá nasledujúcu konfiguráciu motora Z:

```
 ----------------
 |Z1          Z2|
 |  ---------   |
 |  |       |   |
 |  |       |   |
 |  x--------   |
 |Z           Z3|
 ----------------
```

Where x is the 0, 0 point on the bed

```
[quad_gantry_level]
#gantry_corners:
# Novým riadkom oddelený zoznam súradníc X, Y, ktoré ich opisujú
# protiľahlé rohy portálu. Prvý záznam zodpovedá Z,
# druhý do Z2. Tento parameter je potrebné zadať.
#body:
# Novým riadkom oddelený zoznam štyroch bodov X, Y, ktoré by sa mali testovať
# počas príkazu QUAD_GANTRY_LEVEL. Poradie miest je
# dôležité a malo by zodpovedať umiestneniu Z, Z1, Z2 a Z3
#   objednať. Tento parameter je potrebné zadať. Pre maximálnu presnosť,
# uistite sa, že sú nakonfigurované odchýlky sondy.
#rýchlosť: 50
# Rýchlosť (v mm/s) nesnímaných pohybov počas kalibrácie.
# Predvolená hodnota je 50.
#horizontal_move_z: 5
# Výška (v mm), do ktorej sa má hlava pohnúť
# tesne pred spustením operácie sondy. Predvolená hodnota je 5.
#max_adjust: 4
# Bezpečnostný limit, ak je požadovaná úprava väčšia ako táto hodnota
# quad_gantry_level sa preruší.
#opakovania: 0
# Počet opakovaní, ak sa snímané body nenachádzajú v rámci
# tolerancia.
#retry_tolerance: 0
# Ak sú povolené pokusy, skúste to znova, ak sa sníma najväčší a najmenší
# bodov sa líši viac ako retry_tolerance.
```

### [skew_correction]

Korekcia zošikmenia tlačiarne. Je možné použiť softvér na opravu zošikmenia tlačiarne cez 3 roviny, xy, xz, yz. Robí sa to vytlačením kalibračného modelu pozdĺž roviny a meraním troch dĺžok. Vzhľadom na povahu korekcie zošikmenia sa tieto dĺžky nastavujú pomocou gcode. Podrobnosti nájdete v [Korekcia zošikmenia](Skew_Correction.md) a [Referencia príkazov](G-Codes.md#skew_correction).

```
[skew_correction]
```

### [z_thermal_adjust]

Temperature-dependant toolhead Z position adjustment. Compensate for vertical toolhead movement caused by thermal expansion of the printer's frame in real-time using a temperature sensor (typically coupled to a vertical section of frame).

Pozri tiež: [rozšírené príkazy g-kódu](G-Codes.md#z_thermal_adjust).

```
[z_thermal_adjust]
#temp_coeff:
#   The temperature coefficient of expansion, in mm/degC. For example, a
#   temp_coeff of 0.01 mm/degC will move the Z axis downwards by 0.01 mm for
#   every degree Celsius that the temperature sensor increases. Defaults to
#   0.0 mm/degC, which applies no adjustment.
#smooth_time:
#   Smoothing window applied to the temperature sensor, in seconds. Can reduce
#   motor noise from excessive small corrections in response to sensor noise.
#   The default is 2.0 seconds.
#z_adjust_off_above:
#   Disables adjustments above this Z height [mm]. The last computed correction
#   will remain applied until the toolhead moves below the specified Z height
#   again. The default is 99999999.0 mm (always on).
#max_z_adjustment:
#   Maximum absolute adjustment that can be applied to the Z axis [mm]. The
#   default is 99999999.0 mm (unlimited).
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Temperature sensor configuration.
#   See the "extruder" section for the definition of the above
#   parameters.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
```

## Prispôsobené navádzanie

### [safe_z_home]

Bezpečné navádzanie Z. Tento mechanizmus možno použiť na umiestnenie osi Z na špecifickú súradnicu X, Y. To je užitočné, ak sa napríklad hlava nástroja musí presunúť do stredu lôžka predtým, ako sa Z môže vrátiť.

```
[safe_z_home]
home_xy_position:
# A X, Y súradnica (napr. 100, 100), kde by malo byť navádzanie Z
#   vykonané. Tento parameter je potrebné zadať.
#rýchlosť: 50,0
# Rýchlosť, ktorou sa hlava nástroja presunie do bezpečného Z domova
# súradnica. Predvolená hodnota je 50 mm/s
#z_hop:
# Vzdialenosť (v mm) na zdvihnutie osi Z pred navádzaním. Toto je
# sa použije na ľubovoľný príkaz navádzania, aj keď nevracia os Z.
# Ak je os Z už nastavená a aktuálna poloha Z je menšia
# než z_hop, potom to zdvihne hlavu do výšky z_hop. Ak
# os Z ešte nie je nasmerovaná, hlava je zdvihnutá pomocou z_hop.
# Predvolená hodnota je neimplementovať Z hop.
#z_hop_speed: 15.0
# Rýchlosť (v mm/s), ktorou sa zdvíha os Z pred navádzaním. The
# predvolená hodnota je 15 mm/s.
#move_to_previous: Nepravda
# Pri nastavení na hodnotu True sa osi X a Y obnovia na predchádzajúce
# pozícií po navádzaní osi Z. Predvolená hodnota je False.
```

### [homing_override]

Prepísanie navádzania. Tento mechanizmus možno použiť na spustenie série príkazov g-kódu namiesto G28, ktorý sa nachádza v normálnom vstupe g-kódu. To môže byť užitočné na tlačiarňach, ktoré vyžadujú špecifický postup na umiestnenie zariadenia.

```
[homing_override]
gcode:
# Zoznam príkazov kódu G, ktoré sa majú vykonať namiesto príkazov G28
# nájdené v bežnom vstupe g-kódu. Pozrite si docs/Command_Templates.md
# pre formát G-Code. Ak sa v tomto zozname príkazov nachádza G28
# potom vyvolá normálnu procedúru navádzania tlačiarne.
# Príkazy uvedené v tomto zozname musia uviesť všetky osi. Tento parameter musí
#   byť poskytovaný.
#axes: xyz
# Osi, ktoré sa majú prepísať. Napríklad, ak je toto nastavené na "z", potom
# skript override sa spustí iba vtedy, keď je os z nastavená (napr. cez
# príkaz "G28" alebo "G28 Z0"). Všimnite si, že by mal prepísať skript
# ešte doma všetky osi. Predvolená hodnota je "xyz", čo spôsobuje
# skript override, ktorý sa má spustiť namiesto všetkých príkazov G28.
#set_position_x:
#set_position_y:
#set_position_z:
# Ak je zadané, tlačiareň bude predpokladať, že os je v zadanej polohe
# pozíciu pred spustením vyššie uvedených príkazov g-kódu. Nastavenie tohto
# zakáže kontroly navádzania pre túto os. To môže byť užitočné, ak
# hlava sa musí pohnúť pred spustením normálneho mechanizmu G28
# os. Predvolená hodnota je nevynútená poloha pre os.
```

### [endstop_phase]

Stepper phase adjusted endstops. To use this feature, define a config section with an "endstop_phase" prefix followed by the name of the corresponding stepper config section (for example, "[endstop_phase stepper_z]"). This feature can improve the accuracy of endstop switches. Add a bare "[endstop_phase]" declaration to enable the ENDSTOP_PHASE_CALIBRATE command.

Ďalšie informácie nájdete v [príručke koncových fáz](Endstop_Phase.md) a [odkaz na príkaz](G-Codes.md#endstop_phase).

```
[endstop_phase stepper_z]
#endstop_accuracy:
# Nastavuje očakávanú presnosť (v mm) koncového dorazu. Toto predstavuje
# maximálna vzdialenosť chyby, ktorú môže koncový doraz spustiť (napr
# endstop môže príležitostne spustiť o 100 um skôr alebo až o 100 um neskoro
# potom to nastavte na 0,200 pre 200 um). Predvolená hodnota je
# 4*rotation_distance/full_steps_per_rotation.
#trigger_phase:
# Toto špecifikuje očakávanú fázu ovládača krokového motora
# pri náraze na koncovú zarážku. Skladá sa z dvoch oddelených čísel
# znakom lomky - fáza a celkový počet
# fáz (napr. "7/64"). Túto hodnotu nastavte iba vtedy, ak ste si istí
# ovládač krokového motora sa resetuje pri každom resete mcu. Ak toto
# nie je nastavené, potom sa kroková fáza zistí na prvej
# domov a táto fáza sa použije vo všetkých nasledujúcich domoch.
#endstop_align_zero: Nepravda
# Ak je pravda, potom bude koncová zarážka position_endstop osi efektívne
# upravené tak, aby nulová poloha pre os bola úplná
# nastúpte na krokový motor. (Ak sa použije na osi Z a výtlačok
# výška vrstvy je násobkom vzdialenosti celého kroku potom každá
# vrstva sa vyskytne na úplnom kroku.) Predvolená hodnota je False.
```

## Makrá a udalosti G-Code

### [gcode_macro]

Makrá G-Code (je možné definovať ľubovoľný počet sekcií s predponou „gcode_macro“). Ďalšie informácie nájdete v [príručke šablón príkazov](Command_Templates.md).

```
[gcode_macro my_cmd]
#gcode:
# Zoznam príkazov G-Code, ktoré sa majú vykonať namiesto "my_cmd". Pozri
# docs/Command_Templates.md pre formát G-Code. Tento parameter musí
#   byť poskytovaný.
#variable_<názov>:
# Môžete zadať ľubovoľný počet možností s predponou "variable_".
# Danému názvu premennej bude priradená daná hodnota (analyzovaná
# ako literál Pythonu) a bude k dispozícii počas rozšírenia makra.
# Napríklad konfigurácia s "variable_fan_speed = 75" môže mať
# príkazy gcode obsahujúce "M106 S{ fan_speed * 255 }". Premenné
# možno zmeniť za behu pomocou príkazu SET_GCODE_VARIABLE
# (podrobnosti nájdete v docs/Command_Templates.md). Názvy premenných môžu
# nepoužívajte veľké písmená.
#rename_existing:
# Táto možnosť spôsobí, že makro prepíše existujúci kód G
# a poskytnite predchádzajúcu definíciu príkazu cez
Tu je uvedené # meno. Toto možno použiť na prepísanie vstavaného kódu G-Code
# príkazov. Pri prepisovaní príkazov by ste mali byť opatrní
# spôsobiť zložité a neočakávané výsledky. Predvolená hodnota je nie
# prepíše existujúci príkaz G-kódu.
#description: Makro G-Code
# Toto pridá krátky popis použitý pri príkaze HELP alebo while
# pomocou funkcie automatického dokončovania. Predvolené „makro G-Code“
```

### [delayed_gcode]

Vykonajte gcode s nastaveným oneskorením. Ďalšie informácie nájdete v [sprievodcovi šablónami príkazov](Command_Templates.md#delayed-gcodes) a [referencia príkazov](G-Codes.md#delayed_gcode).

```
[delayed_gcode my_delayed_gcode]
gcode:
# Zoznam príkazov G-kódu, ktoré sa majú vykonať po uplynutí doby oneskorenia
# uplynulo. Šablóny G-Code sú podporované. Tento parameter musí byť
# poskytnuté.
#initial_duration: 0,0
# Trvanie počiatočného oneskorenia (v sekundách). Ak je nastavený na a
# nenulová hodnota delayed_gcode vykoná zadané číslo
# sekúnd po tom, čo tlačiareň prejde do stavu „pripravená“. Toto môže byť
# užitočné pre inicializačné procedúry alebo opakujúci sa delayed_gcode.
# Ak je nastavené na 0, delayed_gcode sa nespustí pri štarte.
# Predvolená hodnota je 0.
```

### [save_variables]

Support saving variables to disk so that they are retained across restarts. See [command templates](Command_Templates.md#save-variables-to-disk) and [G-Code reference](G-Codes.md#save_variables) for further information.

```
[save_variables]
názov súboru:
# Povinné - zadajte názov súboru, ktorý sa použije na uloženie súboru
# premenné na disk napr. ~/variables.cfg
```

### [idle_timeout]

Časový limit nečinnosti. Automaticky je povolený časový limit nečinnosti – pridajte explicitnú konfiguračnú sekciu idle_timeout, aby ste zmenili predvolené nastavenia.

```
[idle_timeout]
#gcode:
# Zoznam príkazov kódu G, ktoré sa majú vykonať v čase nečinnosti. Pozri
# docs/Command_Templates.md pre formát G-Code. Predvolené nastavenie je spustiť
# "TURN_OFF_HEATERS" a "M84".
#timeout: 600
# Čas nečinnosti (v sekundách) na čakanie pred spustením vyššie uvedeného G-kódu
# príkazov. Predvolená hodnota je 600 sekúnd.
```

## Voliteľné funkcie G-Code

### [virtual_sdcard]

Virtuálna karta sdcard môže byť užitočná, ak hostiteľský počítač nie je dostatočne rýchly na to, aby dobre spustil OctoPrint. Umožňuje hostiteľskému softvéru Klipper priamo tlačiť súbory gcode uložené v adresári na hostiteľovi pomocou štandardných príkazov sdcard G-Code (napr. M24).

```
[virtual_sdcard]
path:
#   The path of the local directory on the host machine to look for
#   g-code files. This is a read-only directory (sdcard file writes
#   are not supported). One may point this to OctoPrint's upload
#   directory (generally ~/.octoprint/uploads/ ). This parameter must
#   be provided.
#on_error_gcode:
#   A list of G-Code commands to execute when an error is reported.
```

### [sdcard_loop]

Niektoré tlačiarne s funkciami čistenia pódia, ako je vyhadzovač súčiastok alebo pásová tlačiareň, môžu nájsť využitie v slučkách sekcií súboru sdcard. (Napríklad na vytlačenie tej istej časti znova a znova alebo na opakovanie časti časti pre reťaz alebo iný opakujúci sa vzor).

Podporované príkazy nájdete v [odkaz na príkaz](G-Codes.md#sdcard_loop). Makro M808 G-Code kompatibilné s Marlin nájdete v súbore [sample-macros.cfg](../config/sample-macros.cfg).

```
[sdcard_loop]
```

### [force_move]

Support manually moving stepper motors for diagnostic purposes. Note, using this feature may place the printer in an invalid state - see the [command reference](G-Codes.md#force_move) for important details.

```
[force_move]
#enable_force_move: Nepravda
# Ak chcete povoliť FORCE_MOVE a SET_KINEMATIC_POSITION, nastavte na hodnotu true
# rozšírené príkazy G-Code. Predvolená hodnota je nepravda.
```

### [pause_resume]

Funkcia pozastavenia/obnovenia s podporou zachytenia a obnovenia polohy. Ďalšie informácie nájdete v [odkaz na príkaz](G-Codes.md#pause_resume).

```
[pause_resume]
#recover_velocity: 50.
# Keď je povolené zachytávanie/obnovenie, rýchlosť, na ktorú sa má vrátiť
# zachytená poloha (v mm/s). Predvolená hodnota je 50,0 mm/s.
```

### [firmware_retraction]

Zatiahnutie filamentu firmvéru. To umožňuje príkazy GCODE G10 (zatiahnutie) a G11 (odtiahnutie) vydávané mnohými rezačmi. Parametre uvedené nižšie poskytujú predvolené hodnoty spustenia, aj keď hodnoty možno upraviť pomocou príkazu SET_RETRACTION [príkaz](G-Codes.md#firmware_retraction)), čo umožňuje nastavenie jednotlivých vlákien a ladenie za chodu.

```
[firmware_retraction]
#retract_length: 0
# Dĺžka vlákna (v mm), ktorá sa má zatiahnuť pri aktivácii G10,
# a na odtiahnutie, keď je aktivovaná G11 (ale pozri
# unretract_extra_length nižšie). Predvolená hodnota je 0 mm.
#retract_speed: 20
# Rýchlosť sťahovania v mm/s. Predvolená hodnota je 20 mm/s.
#unretract_extra_length: 0
# Dĺžka (v mm) *ďalšieho* vlákna, ktoré sa má pridať
# odtiahnutie.
#unretract_speed: 10
# Rýchlosť roztiahnutia v mm/s. Predvolená hodnota je 10 mm/s.
```

### [gcode_arcs]

Support for gcode arc (G2/G3) commands.

```
[gcode_arcs]
#rozlíšenie: 1.0
# Oblúk bude rozdelený na segmenty. Dĺžka každého segmentu bude
# sa rovná vyššie nastavenému rozlíšeniu v mm. Nižšie hodnoty spôsobia a
# jemnejší oblúk, ale aj viac práce pre váš stroj. Oblúky menšie ako
# nakonfigurovaná hodnota sa zmení na rovné čiary. Predvolená hodnota je
# 1 mm.
```

### [respond]

Povoľte „M118“ a „RESPOND“ rozšírené [príkazy] (G-Codes.md#respond).

```
[odpovedať]
#default_type: echo
# Nastaví predvolenú predponu výstupu „M118“ a „RESPOND“ na jednu
#   z nasledujúcich:
# echo: "echo: " (Toto je predvolené nastavenie)
# príkaz: "// "
#       chyba: "!! "
#default_prefix: echo:
# Priamo nastaví predvolenú predponu. Ak je prítomná, táto hodnota bude
# prepíše "default_type".
```

### [exclude_object]

Umožňuje podporu na vylúčenie alebo zrušenie jednotlivých objektov počas procesu tlače.

Ďalšie informácie nájdete v [príručke k vylúčeniu objektov](Exclude_Object.md) a [referencia príkazu](G-Codes.md#excludeobject). Makro M486 G-Code kompatibilné s Marlin/RepRapFirmware nájdete v súbore [sample-macros.cfg](../config/sample-macros.cfg).

```
[exclude_object]
```

## Rezonančná kompenzácia

### [input_shaper]

Povolí [kompenzáciu rezonancie](Resonance_Compensation.md). Pozri tiež [odkaz na príkaz](G-Codes.md#input_shaper).

```
[input_shaper]
#shaper_freq_x: 0
# Frekvencia (v Hz) vstupného tvarovača pre os X. Toto je
# zvyčajne rezonančná frekvencia osi X, ktorá je vstupným tvarovačom
# by mal potlačiť. Pre zložitejšie tvarovače, ako sú 2- a 3-hrbové EI
# vstupné tvarovače, tento parameter je možné nastaviť z rôznych
# úvah. Predvolená hodnota je 0, čo deaktivuje vstup
# tvarovanie pre os X.
#shaper_freq_y: 0
# Frekvencia (v Hz) vstupného tvarovača pre os Y. Toto je
# zvyčajne rezonančná frekvencia osi Y, ktorá je vstupným tvarovačom
# by mal potlačiť. Pre zložitejšie tvarovače, ako sú 2- a 3-hrbové EI
# vstupné tvarovače, tento parameter je možné nastaviť z rôznych
# úvah. Predvolená hodnota je 0, čo deaktivuje vstup
# tvarovanie pre os Y.
#shaper_type: mzv
# Typ vstupného tvarovača, ktorý sa má použiť pre osi X aj Y. Podporované
# shapers sú zv, mzv, zvd, ei, 2hump_ei a 3hump_ei. Predvolená hodnota
# je tvarovač vstupu mzv.
#shaper_type_x:
#shaper_type_y:
# Ak nie je nastavený shaper_type, možno použiť tieto dva parametre
# nakonfigurujte rôzne vstupné tvarovače pre osi X a Y. Rovnaký
# hodnoty sú podporované ako pre parameter shaper_type.
#damping_ratio_x: 0,1
#damping_ratio_y: 0,1
# Pomery tlmenia vibrácií osí X a Y používané vstupnými tvarovačmi
# na zlepšenie potláčania vibrácií. Predvolená hodnota je 0,1, čo je a
# dobrá všestranná hodnota pre väčšinu tlačiarní. Vo väčšine prípadov toto
# parameter nevyžaduje žiadne ladenie a nemal by sa meniť.
```

### [adxl345]

Support for ADXL345 accelerometers. This support allows one to query accelerometer measurements from the sensor. This enables an ACCELEROMETER_MEASURE command (see [G-Codes](G-Codes.md#adxl345) for more information). The default chip name is "default", but one may specify an explicit name (eg, [adxl345 my_chip_name]).

```
[adxl345]
cs_pin:
#      Pin aktivácie SPI pre senzor. Tento parameter je potrebné zadať.
#spi_speed: 5000000
#      Rýchlosť SPI (v Hz), ktorá sa má použiť pri komunikácii s čipom.
#      Predvolená hodnota je 5 000 000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#      Popis nájdete v časti „spoločné nastavenia SPI“.
#      vyššie uvedené parametre.
#axes_map: x, y, z
#      Os akcelerometra pre každú z osí X, Y a Z tlačiarne.
#      To môže byť užitočné, ak je akcelerometer namontovaný v
#      orientácia, ktorá sa nezhoduje s orientáciou tlačiarne. Pre
#      príklad, dalo by sa to nastaviť na "y, x, z", aby sa vymenili osi X a Y.
#      Je tiež možné negovať os, ak je akcelerometer
#      smer je obrátený (napr. "x, z, -y"). Predvolená hodnota je „x, y, z“.
#sadzba: 3200
#      Výstupná dátová rýchlosť pre ADXL345. ADXL345 podporuje nasledujúce údaje
#      sadzby: 3200, 1600, 800, 400, 200, 100, 50 a 25. Upozorňujeme, že je
#      sa neodporúča meniť túto sadzbu z predvolenej hodnoty 3200 a
#      frekvencie pod 800 výrazne ovplyvnia kvalitu rezonancie
#      meraní.
```

### [lis2dw]

Support for LIS2DW accelerometers.

```
[lis2dw]
cs_pin:
# Pin aktivácie SPI pre senzor. Tento parameter je potrebné zadať.
#spi_speed: 5000000
# Rýchlosť SPI (v Hz), ktorá sa má použiť pri komunikácii s čipom.
# Predvolená hodnota je 5 000 000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Popis nájdete v časti „spoločné nastavenia SPI“.
# vyššie uvedené parametre.
#axes_map: x, y, z
# Informácie o tomto parametri nájdete v časti "adxl345".
```

### [mpu9250]

Support for MPU-9250, MPU-9255, MPU-6515, MPU-6050, and MPU-6500 accelerometers (one may define any number of sections with an "mpu9250" prefix).

```
[mpu9250 môj_akcelerometer]
#i2c_address:
# Predvolená hodnota je 104 (0x68). Ak je AD0 vysoké, bude to namiesto toho 0x69.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400 000
# Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre. Predvolená "i2c_speed" je 400 000.
#axes_map: x, y, z
# Informácie o tomto parametri nájdete v časti "adxl345".
```

### [resonance_tester]

Support for resonance testing and automatic input shaper calibration. In order to use most of the functionality of this module, additional software dependencies must be installed; refer to [Measuring Resonances](Measuring_Resonances.md) and the [command reference](G-Codes.md#resonance_tester) for more information. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) section of the measuring resonances guide for more information on `max_smoothing` parameter and its use.

```
[resonance_tester]
#probe_points:
# Zoznam súradníc X, Y, Z bodov (jeden bod na riadok) na testovanie
# rezonancie pri. Vyžaduje sa aspoň jeden bod. Uistite sa, že všetky
# bodov s určitou bezpečnostnou rezervou v rovine XY (~ niekoľko centimetrov)
# sú dosiahnuteľné z hlavy nástroja.
#accel_chip:
# Názov čipu akcelerometra, ktorý sa má použiť na meranie. Ak
# čip adxl345 bol definovaný bez explicitného názvu, tohto parametra
# ho môže jednoducho odkazovať ako "accel_chip: adxl345", inak an
# musí byť zadaný aj explicitný názov, napr. "accel_chip: adxl345
# my_chip_name". Musí to byť buď tento, alebo ďalšie dva parametre
# sada.
#accel_chip_x:
#accel_chip_y:
# Názvy čipov akcelerometra, ktoré sa majú použiť na meranie každého z nich
# osi. Môže byť užitočný napríklad na tlačiarni posteľnej pračky,
# ak sú na posteli namontované dva samostatné akcelerometre (pre os Y)
# a na hlave nástroja (pre os X). Tieto parametre majú rovnaké
# formát ako parameter 'accel_chip'. Iba „accel_chip“ alebo tieto dva
Je potrebné zadať # parametrov.
#max_smoothing:
# Maximálne vyhladenie vstupného tvarovača, ktoré umožňuje každú os počas tvarovania
# automatická kalibrácia (s príkazom 'SHAPER_CALIBRATE'). Štandardne nie
# je špecifikované maximálne vyhladenie. Pozrite si príručku Measuring_Resonances
# pre ďalšie podrobnosti o používaní tejto funkcie.
#min_freq: 5
# Minimálna frekvencia na testovanie rezonancií. Predvolená hodnota je 5 Hz.
#max_freq: 133,33
# Maximálna frekvencia na testovanie rezonancií. Predvolená hodnota je 133,33 Hz.
#accel_per_hz: 75
# Tento parameter sa používa na určenie, ktoré zrýchlenie sa má použiť
# otestujte konkrétnu frekvenciu: accel = accel_per_hz * frekv. Vyššie
# hodnota, tým vyššia je energia kmitov. Dá sa nastaviť na
# a nižšia ako predvolená hodnota, ak sú rezonancie príliš silné
# tlačiareň. Nižšie hodnoty však robia merania
# vysokofrekvenčné rezonancie sú menej presné. Predvolená hodnota je 75
# (mm/s).
#hz_per_sec: 1
# Určuje rýchlosť testu. Pri testovaní všetkých frekvencií v
# rozsah [min_freq, max_freq], každú sekundu sa frekvencia zvyšuje o
# hz_per_sec. Malé hodnoty spomaľujú test a veľké hodnoty
# zníži presnosť testu. Predvolená hodnota je 1,0
# (Hz/s == s^-2).
```

## Pomocníci konfiguračného súboru

### [board_pins]

Aliasy pinov na tabuli (možno definovať ľubovoľný počet sekcií s predponou "board_pins"). Použite toto na definovanie aliasov pre kolíky na mikroovládači.

```
[nástenné_piny my_aliases]
mcu: mcu
# Čiarkami oddelený zoznam mikroovládačov, ktoré môžu používať
# aliasov. Predvolene sa aliasy použijú na hlavnú „mcu“.
prezývky:
aliasy_<meno>:
# Čiarkami oddelený zoznam aliasov "name=value", ktoré sa majú vytvoriť pre
# daný mikroovládač. Napríklad „EXP1_1=PE6“ by vytvorilo
# Alias "EXP1_1" pre kolík "PE6". Ak je však priložená „hodnota“.
# v "<>", potom "name" sa vytvorí ako rezervovaný pin (napr.
# "EXP1_9=<GND>" by rezervovalo "EXP1_9"). Ľubovoľný počet možností
Môže byť špecifikované # začínajúce na "aliases_".
```

### [include]

Zahrňte podporu súborov. Jeden môže obsahovať ďalší konfiguračný súbor z hlavného konfiguračného súboru tlačiarne. Môžu sa použiť aj zástupné znaky (napr. "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

This tool allows a single micro-controller pin to be defined multiple times in a config file without normal error checking. This is intended for diagnostic and debugging purposes. This section is not needed where Klipper supports using the same pin multiple times, and using this override may cause confusing and unexpected results.

```
[duplicate_pin_override]
špendlíky:
# Čiarkami oddelený zoznam pinov, ktoré možno použiť viackrát
# konfiguračný súbor bez bežných kontrol chýb. Tento parameter musí byť
# poskytnuté.
```

## Hardvér na sondovanie postele

### [probe]

Z height probe. One may define this section to enable Z height probing hardware. When this section is enabled, PROBE and QUERY_PROBE extended [g-code commands](G-Codes.md#probe) become available. Also, see the [probe calibrate guide](Probe_Calibrate.md). The probe section also creates a virtual "probe:z_virtual_endstop" pin. One may set the stepper_z endstop_pin to this virtual pin on cartesian style printers that use the probe in place of a z endstop. If using "probe:z_virtual_endstop" then do not define a position_endstop in the stepper_z config section.

```
[sonda]
pripnúť:
# Detekčný kolík sondy. Ak je kolík na inom mikrokontroléri
# než steppery Z potom umožňuje "multi-mcu navádzanie". Toto
Musíte zadať # parameter.
#deactivate_on_each_sample: Pravda
# Toto určuje, či má Klipper vykonať deaktiváciu gcode
# medzi každým pokusom o sondu pri vykonávaní viacerých sond
# sekvencia. Predvolená hodnota je True.
#x_offset: 0,0
# Vzdialenosť (v mm) medzi sondou a tryskou pozdĺž
# os x. Predvolená hodnota je 0.
#y_offset: 0,0
# Vzdialenosť (v mm) medzi sondou a tryskou pozdĺž
# os y. Predvolená hodnota je 0.
z_offset:
# Vzdialenosť (v mm) medzi lôžkom a tryskou pri sonde
# spúšťačov. Tento parameter je potrebné zadať.
#rýchlosť: 5,0
# Rýchlosť (v mm/s) osi Z pri snímaní. Predvolená hodnota je 5 mm/s.
#vzorky: 1
# Počet testov každého bodu. Skúšané z-hodnoty budú
# byť spriemerovaný. Štandardne je sonda 1 krát.
#sample_retract_dist: 2.0
# Vzdialenosť (v mm) na zdvihnutie nástrojovej hlavy medzi každou vzorkou (ak
# odber vzoriek viac ako raz). Predvolená hodnota je 2 mm.
#lift_speed:
# Rýchlosť (v mm/s) osi Z pri zdvíhaní sondy medzi
# vzorky. Predvolená hodnota je použiť rovnakú hodnotu ako „rýchlosť“
# parameter.
#samples_result: priemer
# Metóda výpočtu pri odbere vzoriek viac ako raz - buď
# "medián" alebo "priemer". Predvolená hodnota je priemerná.
#tolerancia_vzorkov: 0,100
# Maximálna vzdialenosť Z (v mm), ktorou sa vzorka môže líšiť od ostatných
# vzorky. Ak je táto tolerancia prekročená, ide buď o chybu
# hlásené alebo sa pokus reštartuje (pozri
# sample_tolerance_retries). Predvolená hodnota je 0,100 mm.
#samples_tolerance_retries: 0
# Počet opakovaní, ak sa nájde vzorka, ktorá presahuje hodnotu
# vzorky_tolerancia. Pri opätovnom pokuse sa všetky aktuálne vzorky zahodia
# a pokus o sondu sa reštartuje. Ak je platný súbor vzoriek
# sa nedosiahne v danom počte opakovaní, potom je chyba
# nahlásených. Predvolená hodnota je nula, čo spôsobí hlásenie chyby
# na prvej vzorke, ktorá presahuje toleranciu vzoriek.
#activate_gcode:
# Zoznam príkazov G-kódu, ktoré sa majú vykonať pred každým pokusom o sondu.
# Formát G-kódu nájdete na stránke docs/Command_Templates.md. Toto môže byť
# užitočné, ak treba sondu nejakým spôsobom aktivovať. nie
# tu zadajte akékoľvek príkazy, ktoré pohybujú hlavou nástroja (napr. G1). The
# predvolené je nespúšťať žiadne špeciálne príkazy G-kódu pri aktivácii.
#deactivate_gcode:
# Zoznam príkazov G-kódu, ktoré sa majú vykonať po každom pokuse o sondu
# dokončení. Formát G-kódu nájdete na stránke docs/Command_Templates.md. nie
# tu zadajte akékoľvek príkazy, ktoré posunú hlavu nástroja. Predvolená hodnota je
# pri deaktivácii nespúšťajte žiadne špeciálne príkazy G-kódu.
```

### [bltouch]

BLDotyková sonda. Je možné definovať túto sekciu (namiesto sekcie sondy), aby sa umožnila sonda BLTouch. Ďalšie informácie nájdete v [BL-Touch sprievodca](BLTouch.md) a [príkazový odkaz](G-Codes.md#bltouch). Vytvorí sa aj virtuálny kolík „probe:z_virtual_endstop“ (podrobnosti nájdete v časti „sonda“).

```
[bltouch]
senzor_pin:
# Kolík pripojený ku kolíku snímača BLTouch. Väčšina zariadení BLTouch
# vyžadujú vytiahnutie kolíka snímača (pred názvom kolíka uveďte „^“).
# Tento parameter musí byť zadaný.
control_pin:
# Kolík pripojený k ovládaciemu kolíku BLTouch. Tento parameter musí byť
# poskytnuté.
#pin_move_time: 0,680
# Čas (v sekundách), ktorý sa má čakať, kým sa dotkne špendlík BLTouch
# pohyb nahor alebo nadol. Predvolená hodnota je 0,680 sekundy.
#stow_on_each_sample: Pravda
# Toto určuje, či má Klipper prikázať kolíku, aby sa posunul nahor
# medzi každým pokusom o sondu pri vykonávaní viacerých sond
# sekvencia. Pred nastavením si prečítajte pokyny v docs/BLtouch.md
# toto na False. Predvolená hodnota je True.
#probe_with_touch_mode: Nepravda
# Ak je toto nastavené na True, Klipper bude sondovať so zariadením
# "touch_mode". Predvolená hodnota je False (sondovanie v režime "pin_down").
#pin_up_reports_not_triggered: Pravda
# Nastavte, ak BLTouch neustále hlási sondu v „nie
# triggered" stav po úspešnom príkaze "pin_up". To by malo
# platí pre všetky originálne zariadenia BLTouch. Prečítajte si pokyny v
# docs/BLtouch.md pred nastavením na False. Predvolená hodnota je True.
#pin_up_touch_mode_reports_triggered: Pravda
# Nastavte, ak BLTouch neustále hlási „spustený“ stav po
# príkazy "pin_up" nasledované "touch_mode". Toto by malo byť
# Platí pre všetky originálne zariadenia BLTouch. Prečítajte si pokyny v
# docs/BLtouch.md pred nastavením na False. Predvolená hodnota je True.
#set_output_mode:
# Požiadajte o špecifický režim výstupu kolíkov snímača na BLTouch V3.0 (a
# neskôr). Toto nastavenie by sa nemalo používať na iných typoch sond.
# Nastavte na "5V", aby ste požadovali výstup na kolíku snímača 5 voltov (použite iba vtedy, ak
# riadiaca doska potrebuje 5V režim a na svojom vstupe je tolerantná 5V
# signálna linka). Nastavte na "OD", ak chcete požiadať o použitie výstupu kolíka snímača
# režim otvoreného odtoku. Predvolené nastavenie je nepožadovať výstupný režim.
#x_offset:
#y_offset:
#z_offset:
#rýchlosť:
#lift_speed:
#vzorky:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
# Informácie o týchto parametroch nájdete v časti „sonda“.
```

### [smart_effector]

The "Smart Effector" from Duet3d implements a Z probe using a force sensor. One may define this section instead of `[probe]` to enable the Smart Effector specific features. This also enables [runtime commands](G-Codes.md#smart_effector) to adjust the parameters of the Smart Effector at run time.

```
[smart_effector]
pripnúť:
# Kolík pripojený k výstupnému kolíku sondy Smart Effector Z (kolík 5). Poznač si to
# pullup rezistor na doske sa vo všeobecnosti nevyžaduje. Avšak, ak
# výstupný kolík je spojený s kolíkom dosky pullup rezistorom, že
# rezistor musí mať vysokú hodnotu (napr. 10 kOhm alebo viac). Niektoré dosky majú nízku
# hodnota pullup rezistora na vstupe sondy Z, čo pravdepodobne povedie k an
# stav vždy spustenej sondy. V tomto prípade pripojte Smart Effector k
# iný špendlík na nástenke. Tento parameter je povinný.
#control_pin:
# Kolík pripojený k riadiacemu vstupnému kolíku Smart Effector (kolík 7). Ak je poskytnuté,
# Sprístupnia sa príkazy na programovanie citlivosti Smart Effector.
#probe_accel:
# Ak je nastavené, obmedzuje zrýchlenie snímacích pohybov (v mm/s^2).
# Môže dôjsť k náhlemu veľkému zrýchleniu na začiatku snímacieho pohybu
# spôsobiť falošné spustenie sondy, najmä ak je hotend ťažký.
# Aby sa tomu zabránilo, môže byť potrebné znížiť zrýchlenie
# sonda sa pohybuje cez tento parameter.
#recovery_time: 0,4
# Oneskorenie medzi pohybmi pojazdu a pohybom snímania v sekundách. Pôst
# pohyb pohybu pred snímaním môže viesť k falošnému spusteniu sondy.
# Ak nedochádza k oneskoreniu, môže to spôsobiť chyby „sonda spustená pred pohybom“.
# je nastavené. Hodnota 0 deaktivuje oneskorenie obnovy.
# Predvolená hodnota je 0,4.
#x_offset:
#y_offset:
# Malo by byť ponechané nenastavené (alebo nastavené na 0).
z_offset:
# Výška spustenia sondy. Začnite s -0,1 (mm) a upravte neskôr
# príkaz `PROBE_CALIBRATE`. Tento parameter je potrebné zadať.
#rýchlosť:
# Rýchlosť (v mm/s) osi Z pri snímaní. Odporúča sa začať
# s rýchlosťou snímania 20 mm/s a podľa potreby ju upravte na zlepšenie
# presnosť a opakovateľnosť spúšťania sondy.
#vzorky:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#deactivate_on_each_sample:
# Ďalšie informácie o vyššie uvedených parametroch nájdete v časti „sonda“.
```

### [axis_twist_compensation]

Nástroj na kompenzáciu nepresných hodnôt sondy v dôsledku skrútenia X gantry. Podrobnejšie informácie týkajúce sa symptómov, konfigurácie a nastavenia nájdete v [Príručka kompenzácie skrútenia osi] (Axis_Twist_Compensation.md).

```
[axis_twist_compensation]
#rýchlosť: 50
#       Rýchlosť (v mm/s) nesnímaných pohybov počas kalibrácie.
#       Predvolená hodnota je 50.
#horizontal_move_z: 5
#       Výška (v mm), do ktorej sa má hlava pohnúť
#       tesne pred spustením operácie sondy. Predvolená hodnota je 5.
calibrate_start_x: 20
#       Definuje minimálnu X súradnicu kalibrácie
#       Toto by mala byť súradnica X, ktorá umiestni trysku na začiatok
#       kalibračná pozícia. Tento parameter je potrebné zadať.
calibrate_end_x: 200
#       Definuje maximálnu X súradnicu kalibrácie
#       Toto by mala byť súradnica X, ktorá umiestni trysku na koniec
#       kalibračná pozícia. Tento parameter je potrebné zadať.
calibrate_y: 112,5
#       Definuje súradnicu Y kalibrácie
#       Toto by mala byť súradnica Y, ktorá umiestňuje trysku počas
#       proces kalibrácie. Tento parameter musí byť zadaný a odporúča sa
#       byť blízko stredu postele
```

## Prídavné krokové motory a extrudéry

### [stepper_z1]

Viackrokové osi. Na tlačiarni karteziánskeho štýlu môže mať krokový ovládač ovládajúci danú os ďalšie konfiguračné bloky definujúce krokové kroky, ktoré by mali byť krokované v súlade s primárnym krokovým krokom. Je možné definovať ľubovoľný počet sekcií s číselnou príponou začínajúcou od 1 (napríklad „stepper_z1“, „stepper_z2“ atď.).

```
[stepper_z1]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   See the "stepper" section for the definition of the above parameters.
#endstop_pin:
#   If an endstop_pin is defined for the additional stepper then the
#   stepper will home until the endstop is triggered. Otherwise, the
#   stepper will home until the endstop on the primary stepper for the
#   axis is triggered.
```

### [extruder1]

V tlačiarni s viacerými extrudérmi pridajte ďalšiu sekciu extrudéra pre každý ďalší extrudér. Ďalšie sekcie extrudéra by mali byť pomenované "extruder1", "extruder2", "extruder3" atď. Popis dostupných parametrov nájdete v časti "extrudér".

Príklad konfigurácie nájdete v [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg).

```
[extrudér1]
#step_pin:
#dir_pin:
#...
# Dostupný stepper a ohrievač nájdete v časti "extrudér".
# parametrov.
#shared_heater:
# Táto možnosť je zastaraná a už by sa nemala špecifikovať.
```

### [dual_carriage]

Support for cartesian and hybrid_corexy/z printers with dual carriages on a single axis. The carriage mode can be set via the SET_DUAL_CARRIAGE extended g-code command. For example, "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation. Note that during G28 homing, typically the primary carriage is homed first followed by the carriage defined in the `[dual_carriage]` config section. However, the `[dual_carriage]` carriage will be homed first if both carriages home in a positive direction and the [dual_carriage] carriage has a `position_endstop` greater than the primary carriage, or if both carriages home in a negative direction and the `[dual_carriage]` carriage has a `position_endstop` less than the primary carriage.

Okrem toho je možné použiť príkazy „SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY“ alebo „SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR“ na aktiváciu režimu kopírovania alebo zrkadlenia dvojitého vozíka, pričom v takom prípade bude zodpovedajúcim spôsobom sledovať pohyb vozíka 0 . Tieto príkazy je možné použiť na tlač dvoch dielov súčasne – buď dvoch rovnakých dielov (v režime KOPÍROVANIE) alebo zrkadlených dielov (v režime MIRROR). Všimnite si, že režimy COPY a MIRROR tiež vyžadujú vhodnú konfiguráciu extrudéra na dvojitom vozíku, čo sa zvyčajne dá dosiahnuť pomocou príkazu "SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=<vytlačovací stroj s dvoma vozíkmi>" alebo podobným príkazom.

Príklad konfigurácie nájdete v [sample-idex.cfg](../config/sample-idex.cfg).

```
[dual_carriage]
os:
# Os je na tomto extra vozíku (buď x alebo y). Tento parameter
# musí byť poskytnuté.
#safe_distance:
# Minimálna vzdialenosť (v mm), ktorá sa má vynútiť medzi duálnou a primárnou jednotkou
# vozňov. Ak sa vykoná príkaz G-kódu, privedie sa vozíky
# bližšie ako zadaný limit, takýto príkaz bude odmietnutý s
#   chyba. Ak safe_distance nie je zadaná, bude odvodená z
# position_min a position_max pre dvojité a primárne vozíky. Ak je nastavený
# až 0 (alebo safe_distance nie je nastavená a position_min a position_max sú
# identické pre primárne a dvojité vozne), blízkosť vozňov
# kontroly budú deaktivované.
#step_pin:
#dir_pin:
#enable_pin:
#mikrokroky:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
# Definíciu vyššie uvedených parametrov nájdete v časti „stepper“.
```

### [extruder_stepper]

Support for additional steppers synchronized to the movement of an extruder (one may define any number of sections with an "extruder_stepper" prefix).

Ďalšie informácie nájdete v [odkaz na príkaz](G-Codes.md#extruder).

```
[extruder_stepper my_extra_stepper]
extrudér:
# Extrudér, s ktorým je tento krokový krok synchronizovaný. Ak je toto nastavené na an
# prázdny reťazec, potom sa stepper nebude synchronizovať s an
# extrudér. Tento parameter je potrebné zadať.
#step_pin:
#dir_pin:
#enable_pin:
#mikrokroky:
#rotation_distance:
# Definíciu vyššie uvedeného nájdete v časti „stepper“.
# parametrov.
```

### [manual_stepper]

Manuálne steppery (možno definovať ľubovoľný počet sekcií s predponou "manual_stepper"). Sú to steppery, ktoré sú ovládané príkazom MANUAL_STEPPER g-code. Napríklad: "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". Popis príkazu MANUAL_STEPPER nájdete v súbore [G-Codes](G-Codes.md#manual_stepper). Steppery nie sú pripojené k normálnej kinematike tlačiarne.

```
[manual_stepper my_stepper]
#step_pin:
#dir_pin:
#enable_pin:
#mikrokroky:
#rotation_distance:
# Popis týchto parametrov nájdete v časti „stepper“.
#rýchlosť:
# Nastavte predvolenú rýchlosť (v mm/s) pre stepper. Táto hodnota
# sa použije, ak príkaz MANUAL_STEPPER nešpecifikuje SPEED
# parameter. Predvolená hodnota je 5 mm/s.
#accel:
# Nastavte predvolené zrýchlenie (v mm/s^2) pre stepper. An
# nulové zrýchlenie nebude mať za následok žiadne zrýchlenie. Táto hodnota
# sa použije, ak príkaz MANUAL_STEPPER nešpecifikuje ACCEL
# parameter. Predvolená hodnota je nula.
#endstop_pin:
# Detekčný kolík koncového spínača. Ak je to špecifikované, môže sa vykonať
# "pohyby nasmerovania" pridaním parametra STOP_ON_ENDSTOP do
# príkazov pohybu MANUAL_STEPPER.
```

## Vlastné ohrievače a senzory

### [verify_heater]

Overenie ohrievača a snímača teploty. Overenie ohrievača je automaticky povolené pre každý ohrievač, ktorý je nakonfigurovaný na tlačiarni. Ak chcete zmeniť predvolené nastavenia, použite sekcie verifikačný ohrev.

```
[verify_heater heater_config_name]
#max_error: 120
#   The maximum "cumulative temperature error" before raising an
#   error. Smaller values result in stricter checking and larger
#   values allow for more time before an error is reported.
#   Specifically, the temperature is inspected once a second and if it
#   is close to the target temperature then an internal "error
#   counter" is reset; otherwise, if the temperature is below the
#   target range then the counter is increased by the amount the
#   reported temperature differs from that range. Should the counter
#   exceed this "max_error" then an error is raised. The default is
#   120.
#check_gain_time:
#   This controls heater verification during initial heating. Smaller
#   values result in stricter checking and larger values allow for
#   more time before an error is reported. Specifically, during
#   initial heating, as long as the heater increases in temperature
#   within this time frame (specified in seconds) then the internal
#   "error counter" is reset. The default is 20 seconds for extruders
#   and 60 seconds for heater_bed.
#hysteresis: 5
#   The maximum temperature difference (in Celsius) to a target
#   temperature that is considered in range of the target. This
#   controls the max_error range check. It is rare to customize this
#   value. The default is 5.
#heating_gain: 2
#   The minimum temperature (in Celsius) that the heater must increase
#   by during the check_gain_time check. It is rare to customize this
#   value. The default is 2.
```

### [homing_heaters]

Tool to disable heaters when homing or probing an axis.

```
[homing_heaters]
#steppers:
# Čiarkami oddelený zoznam stepperov, ktoré by mali spôsobiť, že ohrievače budú
# zakázané. Predvolené nastavenie je vypnutie ohrievačov pre akékoľvek navádzanie/sondovanie
# ťah.
# Typický príklad: stepper_z
#ohrievače:
# Čiarkami oddelený zoznam ohrievačov, ktoré sa majú vypnúť počas navádzania/sondovania
# ťahov. Predvolené nastavenie je vypnutie všetkých ohrievačov.
# Typický príklad: extruder, heat_bed
```

### [thermistor]

Vlastné termistory (možno definovať ľubovoľný počet sekcií s predponou "termistor"). Vlastný termistor možno použiť v poli sensor_type sekcie konfigurácie ohrievača. (Napríklad, ak definujete sekciu "[termistor my_thermistor]", potom môžete pri definovaní ohrievača použiť sekciu "sensor_type: my_thermistor".) Nezabudnite umiestniť sekciu termistora do konfiguračného súboru nad jej prvým použitím v sekcii ohrievača .

```
[thermistor my_thermistor]
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#temperature3:
#resistance3:
#   Three resistance measurements (in Ohms) at the given temperatures
#   (in Celsius). The three measurements will be used to calculate the
#   Steinhart-Hart coefficients for the thermistor. These parameters
#   must be provided when using Steinhart-Hart to define the
#   thermistor.
#beta:
#   Alternatively, one may define temperature1, resistance1, and beta
#   to define the thermistor parameters. This parameter must be
#   provided when using "beta" to define the thermistor.
```

### [adc_temperature]

Vlastné snímače teploty ADC (je možné definovať ľubovoľný počet sekcií s predponou "adc_temperature"). To umožňuje definovať vlastný teplotný senzor, ktorý meria napätie na kolíku analógovo-digitálneho prevodníka (ADC) a používa lineárnu interpoláciu medzi súborom nakonfigurovaných meraní teploty/napätia (alebo teploty/odporu) na určenie teploty. Výsledný snímač možno použiť ako typ snímača v sekcii ohrievača. (Ak napríklad definujete sekciu "[adc_temperature my_sensor]", potom môžete pri definovaní ohrievača použiť "sensor_type: my_sensor".) Nezabudnite umiestniť sekciu senzora do konfiguračného súboru nad jej prvé použitie v sekcii ohrievača .

```
[adc_temperature my_sensor]
#teplota1:
#napätie1:
#teplota2:
#napätie2:
#...
#       Súbor teplôt (v stupňoch Celzia) a napätia (vo voltoch), ktoré sa majú použiť
#       ako referencia pri prevode teploty. Použitie ohrievača
#       tento senzor môže tiež špecifikovať adc_voltage a voltage_offset
#       parametre na definovanie napätia ADC (pozri „Bežná teplota) Podrobnosti nájdete v sekcii
#       zosilňovače. Musia sa vykonať aspoň dve merania
#       byť poskytovaný.
#teplota1:
#odpor1:
#teplota2:
#odpor2:
#...
#       Alternatívne je možné špecifikovať súbor teplôt (v stupňoch Celzia)
#       a odpor (v ohmoch), ktoré sa majú použiť ako referenčné pri konverzii a
#       teplota. Ohrievacia sekcia využívajúca tento snímač môže tiež špecifikovať a
#       parameter pullup_resistor (podrobnosti nájdete v časti "extruder"). O
#       musia byť poskytnuté aspoň dve merania.
```

### [heater_generic]

Generické ohrievače (možno definovať ľubovoľný počet sekcií s predponou "heater_generic"). Tieto ohrievače sa správajú podobne ako štandardné ohrievače (extrudéry, vyhrievané lôžka). Použite príkaz SET_HEATER_TEMPERATURE (podrobnosti nájdete v [G-Codes](G-Codes.md#heaters)) na nastavenie cieľovej teploty.

```
[heater_generic my_generic_heater]
#gcode_id:
# ID, ktoré sa má použiť pri hlásení teploty v príkaze M105.
# Tento parameter musí byť zadaný.
#heater_pin:
#max_power:
#sensor_type:
#sensor_pin:
#smooth_time:
#ovládanie:
#pid_Kp:
#pid_Ki:
#pid_Kd:
#pwm_cycle_time:
#min_temp:
#max_temp:
# Definíciu vyššie uvedeného nájdete v časti „extruder“.
# parametrov.
```

### [temperature_sensor]

Generické snímače teploty. Je možné definovať ľubovoľný počet prídavných snímačov teploty, ktoré sú hlásené príkazom M105.

```
[temperature_sensor my_sensor]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   See the "extruder" section for the definition of the above
#   parameters.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
```

## Temperature sensors

Klipper obsahuje definície pre mnoho typov snímačov teploty. Tieto senzory je možné použiť v akejkoľvek konfiguračnej sekcii, ktorá vyžaduje teplotný senzor (ako je sekcia `[extruder]` alebo `[heater_bed]`).

### Bežné termistory

Bežné termistory. Nasledujúce parametre sú dostupné v sekciách ohrievača, ktoré používajú jeden z týchto snímačov.

```
senzor_typ:
# Jeden z "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
# "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
# "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
# "SliceEngineering 450" alebo "TDK NTCG104LH104JT1"
senzor_pin:
# Analógový vstupný kolík pripojený k termistoru. Tento parameter musí
#   byť poskytovaný.
#pullup_rezistor: 4700
# Odpor (v ohmoch) pullupu pripojeného k termistoru.
# Predvolená hodnota je 4700 ohmov.
#inline_rezistor: 0
# Odpor (v ohmoch) prídavného odporu (bez zmeny teploty).
#, ktorý je umiestnený v rade s termistorom. Toto je zriedkavé nastaviť.
# Predvolená hodnota je 0 ohmov.
```

### Bežné teplotné zosilňovače

Bežné teplotné zosilňovače. Nasledujúce parametre sú dostupné v sekciách ohrievača, ktoré používajú jeden z týchto snímačov.

```
senzor_typ:
# Jeden z "PT100 INA826", "AD595", "AD597", "AD8494", "AD8495",
# "AD8496" alebo "AD8497".
senzor_pin:
# Analógový vstupný kolík pripojený k senzoru. Tento parameter musí byť
# poskytnuté.
#adc_voltage: 5.0
# Porovnávacie napätie ADC (vo voltoch). Predvolená hodnota je 5 voltov.
#voltage_offset: 0
# Posun napätia ADC (vo voltoch). Predvolená hodnota je 0.
```

### Priamo pripojený snímač PT1000

Priamo pripojený snímač PT1000. Nasledujúce parametre sú dostupné v sekciách ohrievača, ktoré používajú jeden z týchto snímačov.

```
typ_senzora: PT1000
senzor_pin:
# Analógový vstupný kolík pripojený k senzoru. Tento parameter musí byť
# poskytnuté.
#pullup_rezistor: 4700
# Odpor (v ohmoch) pullupu pripojeného k senzoru. The
# predvolená hodnota je 4700 ohmov.
```

### MAXxxxxx teplotné senzory

Senzory teploty založené na sériovom periférnom rozhraní (SPI) MAXxxxxx. Nasledujúce parametre sú dostupné v sekciách ohrievača, ktoré používajú jeden z týchto typov snímačov.

```
senzor_typ:
# Jeden z "MAX6675", "MAX31855", "MAX31856" alebo "MAX31865".
senzor_pin:
# Riadok výberu čipu pre senzorový čip. Tento parameter musí byť
# poskytnuté.
#spi_speed: 4000000
# Rýchlosť SPI (v Hz), ktorá sa má použiť pri komunikácii s čipom.
# Predvolená hodnota je 4 000 000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Popis nájdete v časti „spoločné nastavenia SPI“.
# vyššie uvedené parametre.
#tc_type: K
#tc_use_50Hz_filter: Nepravda
#tc_averaging_count: 1
# Vyššie uvedené parametre riadia parametre snímača MAX31856
#   lupienky. Predvolené hodnoty pre každý parameter sú vedľa parametra
# meno vo vyššie uvedenom zozname.
#rtd_nominal_r: 100
#rtd_reference_r: 430
#rtd_num_of_wires: 2
#rtd_use_50Hz_filter: Nepravda
# Vyššie uvedené parametre riadia parametre snímača MAX31865
#   lupienky. Predvolené hodnoty pre každý parameter sú vedľa parametra
# meno vo vyššie uvedenom zozname.
```

### BMP280/BME280/BME680 teplotný sensor

BMP280/BME280/BME680 senzory prostredia s dvoma vodičmi rozhrania (I2C). Upozorňujeme, že tieto snímače nie sú určené na použitie s extrudérmi a ohrievačmi, ale skôr na monitorovanie okolitej teploty (C), tlaku (hPa), relatívnej vlhkosti a v prípade hladiny plynu BME680. Pozrite si [sample-macros.cfg](../config/sample-macros.cfg), kde nájdete gcode_macro, ktoré možno použiť na hlásenie tlaku a vlhkosti okrem teploty.

```
typ_senzora: BME280
#i2c_address:
# Predvolená hodnota je 118 (0x76). Niektoré snímače BME280 majú adresu 119
# (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
# Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre.
```

### AHT10/AHT20/AHT21 teplotný sensor

Senzory prostredia AHT10/AHT20/AHT21 s dvojvodičovým rozhraním (I2C). Upozorňujeme, že tieto snímače nie sú určené na použitie s extrudérmi a ohrievačmi, ale skôr na monitorovanie okolitej teploty (C) a relatívnej vlhkosti. Pozrite si [sample-macros.cfg](../config/sample-macros.cfg), kde nájdete gcode_macro, ktoré možno použiť na hlásenie vlhkosti okrem teploty.

```
typ_senzora: AHT10
# AHT10 používajte aj pre snímače AHT20 a AHT21.
#i2c_address:
# Predvolená hodnota je 56 (0x38). Niektoré snímače AHT10 poskytujú možnosť použitia
# 57 (0x39) pohybom odporu.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
# Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre.
#aht10_report_time:
# Interval v sekundách medzi odčítaniami. Predvolená hodnota je 30, minimum je 5
```

### HTU21D sensor

Senzor prostredia s dvojvodičovým rozhraním (I2C) rodiny HTU21D. Upozorňujeme, že tento snímač nie je určený na použitie s extrudérmi a ohrievačmi, ale skôr na monitorovanie okolitej teploty (C) a relatívnej vlhkosti. Pozrite si [sample-macros.cfg](../config/sample-macros.cfg), kde nájdete gcode_macro, ktoré možno použiť na hlásenie vlhkosti okrem teploty.

```
senzor_typ:
# Musí byť "HTU21D", "SI7013", "SI7020", "SI7021" alebo "SHT21"
#i2c_address:
# Predvolená hodnota je 64 (0x40).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
# Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre.
#htu21d_hold_master:
# Ak snímač dokáže udržať I2C buf počas čítania. Ak je pravda, žiadna iná
# zbernicová komunikácia môže prebiehať počas čítania.
# Predvolená hodnota je False.
#htu21d_resolution:
# Rozlíšenie čítania teploty a vlhkosti.
# Platné hodnoty sú:
# 'TEMP14_HUM12' -> 14 bitov pre teplotu a 12 bitov pre vlhkosť
# 'TEMP13_HUM10' -> 13 bitov pre teplotu a 10 bitov pre vlhkosť
# 'TEMP12_HUM08' -> 12 bitov pre teplotu a 08 bitov pre vlhkosť
# 'TEMP11_HUM11' -> 11 bit pre teplotu a 11 bit pre vlhkosť
# Predvolená hodnota je: "TEMP11_HUM11"
#htu21d_report_time:
# Interval v sekundách medzi odčítaniami. Predvolená hodnota je 30
```

### snímač teploty LM75

LM75/LM75A dvojvodičové (I2C) pripojené teplotné senzory. Tieto snímače majú rozsah -55~125 C, takže sú použiteľné napr. monitorovanie teploty v komore. Môžu tiež fungovať ako jednoduché ovládače ventilátora/vykurovania.

```
typ_senzora: LM75
#i2c_address:
# Predvolená hodnota je 72 (0x48). Normálny rozsah je 72-79 (0x48-0x4F) a 3
# nízke bity adresy sa konfigurujú pomocou kolíkov na čipe
# (zvyčajne s prepojkami alebo pevne zapojené).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
# Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre.
#lm75_report_time:
# Interval v sekundách medzi odčítaniami. Predvolená hodnota je 0,8 s minimom
# 0,5.
```

### Zabudovaný snímač teploty mikrokontroléra

The atsam, atsamd, and stm32 micro-controllers contain an internal temperature sensor. One can use the "temperature_mcu" sensor to monitor these temperatures.

```
typ_senzora: teplota_mcu
#sensor_mcu: mcu
# Mikroovládač na čítanie. Predvolená hodnota je "mcu".
#sensor_temperature1:
#sensor_adc1:
# Zadajte dva vyššie uvedené parametre (teplotu v stupňoch Celzia a an
# Hodnota ADC ako plávajúca medzi 0,0 a 1,0) na kalibráciu
# teplota mikroregulátora. To môže zlepšiť hlásené
# presnosť teploty na niektorých čipoch. Typický spôsob, ako to získať
# informácie o kalibrácii majú úplne odpojiť napájanie
# tlačiareň na niekoľko hodín (aby ste sa uistili, že je v okolitom prostredí
# teplota), potom ho zapnite a použite príkaz QUERY_ADC
# získajte meranie ADC. Použite iný snímač teploty
# tlačiareň, aby ste našli zodpovedajúcu okolitú teplotu. The
# predvolené je použitie údajov kalibrácie z výroby na
# mikroovládač (ak je k dispozícii) alebo nominálne hodnoty z
# Špecifikácia mikrokontroléra.
#sensor_temperature2:
#sensor_adc2:
# Ak je špecifikovaný senzor_teplota1/sensor_adc1, môžete tiež
# špecifikujte kalibračné údaje senzor_teplota2/sensor_adc2. Pritom
# môže poskytnúť kalibrované informácie o „teplotnom sklone“. The
# predvolené je použitie údajov kalibrácie z výroby na
# mikroovládač (ak je k dispozícii) alebo nominálne hodnoty z
# Špecifikácia mikrokontroléra.
```

### Snímač teploty hostiteľa

Temperature from the machine (eg Raspberry Pi) running the host software.

```
sensor_type: teplotný_hostiteľ
#sensor_path:
# Cesta k systémovému súboru teploty. Predvolená hodnota je
# "/sys/class/thermal/thermal_zone0/temp", čo je teplota
# systémový súbor na počítači Raspberry Pi.
```

### snímač teploty DS18B20

DS18B20 je 1-vodičový (w1) digitálny snímač teploty. Upozorňujeme, že tento snímač nie je určený na použitie s extrudérmi a ohrievačmi, ale skôr na monitorovanie okolitej teploty (C). Tieto snímače majú rozsah až 125 C, takže sú použiteľné napr. monitorovanie teploty v komore. Môžu tiež fungovať ako jednoduché ovládače ventilátora/vykurovania. Senzory DS18B20 sú podporované len na "host mcu", napr. Raspberry Pi. Musí byť nainštalovaný modul jadra w1-gpio Linux.

```
typ_senzora: DS18B20
sériové číslo:
# Každé 1-vodičové zariadenie má jedinečné sériové číslo používané na identifikáciu zariadenia,
# zvyčajne vo formáte 28-031674b175ff. Tento parameter je potrebné zadať.
# Pripojené 1-drôtové zariadenia je možné zobraziť pomocou nasledujúceho príkazu Linux:
# ls /sys/bus/w1/devices/
#ds18_report_time:
# Interval v sekundách medzi odčítaniami. Predvolená hodnota je 3.0 s minimom 1.0
#sensor_mcu:
# Mikroovládač na čítanie. Musí to byť host_mcu
```

### Kombinovaný snímač teploty

Kombinovaný snímač teploty je virtuálny snímač teploty založený na niekoľkých ďalších snímačoch. Tento snímač je možné použiť s extrudérmi, ohrievačmi a ohrievačmi.

```
senzor_typ: teplota_kombinovaný
#sensor_list:
# Musí byť poskytnuté. Zoznam senzorov, ktoré sa majú skombinovať do nového „virtuálneho“
# senzor.
# Napr. 'temperature_sensor sensor1,extruder,heater_bed'
#combination_method:
# Musí byť poskytnuté. Kombinovaná metóda použitá pre snímač.
# Dostupné možnosti sú 'max', 'min', 'mean'.
#maximálna_deviácia:
# Musí byť poskytnuté. Maximálna povolená odchýlka medzi snímačmi
# spojiť (napr. 5 stupňov). Ak ho chcete zakázať, použite veľkú hodnotu (napr. 999,9)
```

## Ventilátor

### [fan]

Chladiaci ventilátor tlače.

```
[ventilátor]
pripnúť:
# Výstupný kolík ovládajúci ventilátor. Tento parameter je potrebné zadať.
#max_power: 1,0
# Maximálny výkon (vyjadrený ako hodnota od 0,0 do 1,0), ktorý
# PIN môže byť nastavený na. Hodnota 1,0 umožňuje úplné nastavenie kolíka
# povolené na dlhšie obdobia, zatiaľ čo hodnota 0,5 by umožnila
# pin bude povolený maximálne na polovicu času. Toto nastavenie môže
# sa používa na obmedzenie celkového výkonu (po dlhší čas) na
#   ventilátor. Ak je táto hodnota menšia ako 1,0, požaduje sa rýchlosť ventilátora
# bude škálované medzi nulou a maximálnym_výkonom (napríklad ak
# max_power je 0,9 a vyžaduje sa rýchlosť ventilátora 80 %, potom ventilátor
# výkon bude nastavený na 72 %). Predvolená hodnota je 1.0.
#shutdown_speed: 0
# Požadovaná rýchlosť ventilátora (vyjadrená ako hodnota od 0,0 do 1,0), ak
# softvér mikrokontroléra prejde do chybového stavu. Predvolená hodnota
# je 0.
#cycle_time: 0,010
# Množstvo času (v sekundách) pre každý cyklus napájania PWM do
#   ventilátor. Odporúča sa, aby to bolo 10 milisekúnd alebo viac
# pomocou softvérového PWM. Predvolená hodnota je 0,010 sekundy.
#hardware_pwm: Nepravda
# Povoľte túto možnosť, ak chcete namiesto softvérového PWM použiť hardvérové PWM. Väčšina fanúšikov
# nefungujú dobre s hardvérovým PWM, preto sa neodporúča
# povoľte toto, pokiaľ neexistuje elektrická požiadavka na zapnutie
# veľmi vysoké rýchlosti. Pri použití hardvérového PWM je skutočný čas cyklu
# obmedzené implementáciou a môže byť výrazne
# iný ako požadovaný cycle_time. Predvolená hodnota je False.
#kick_start_time: 0,100
# Čas (v sekundách) na spustenie ventilátora pri plnej rýchlosti pri prvom spustení
# povolenie alebo zvýšenie o viac ako 50% (pomáha získať ventilátor
# točenie). Predvolená hodnota je 0,100 sekundy.
#off_below: 0,0
# Minimálna vstupná rýchlosť, ktorá poháňa ventilátor (vyjadrená ako a
# hodnota od 0,0 do 1,0). Keď je rýchlosť nižšia ako off_below
# požadovalo, aby sa ventilátor namiesto toho vypol. Toto nastavenie môže byť
# sa používa na zabránenie zastavenia ventilátora a na zabezpečenie štartovania
# efektívne. Predvolená hodnota je 0,0.
#
# Toto nastavenie by sa malo prekalibrovať vždy, keď sa upraví max_power.
# Na kalibráciu tohto nastavenia začnite s off_below nastaveným na 0.0 a
# roztočenie ventilátora. Postupne znižujte rýchlosť ventilátora, aby ste určili najnižšiu
# vstupná rýchlosť, ktorá spoľahlivo poháňa ventilátor bez zastavenia. Set
# off_below na pracovný cyklus zodpovedajúci tejto hodnote (napr
# príklad, 12 % -> 0,12) alebo mierne vyššie.
#tachometer_pin:
# Vstupný kolík tachometra na sledovanie otáčok ventilátora. Pulup je všeobecne
#   požadovaný. Tento parameter je voliteľný.
#tachometer_ppr: 2
# Keď je zadaný tachometer_pin, ide o počet impulzov na
# otáčky signálu tachometra. Pre fanúšika BLDC toto je
# normálne polovičný počet pólov. Predvolená hodnota je 2.
#tachometer_poll_interval: 0,0015
# Keď je zadaný tachometer_pin, ide o obdobie dotazovania
# kolík tachometra v sekundách. Predvolená hodnota je 0,0015, čo je rýchle
# dosť pre ventilátory pod 10 000 RPM pri 2 PPR. Toto musí byť menšie ako
# 30/(tachometer_ppr*rpm), s určitým okrajom, kde otáčky za minútu sú
# maximálna rýchlosť (v RPM) ventilátora.
#enable_pin:
# Voliteľný kolík na zapnutie napájania ventilátora. To môže byť užitočné pre fanúšikov
# s vyhradenými PWM vstupmi. Niektoré z týchto ventilátorov zostávajú zapnuté aj pri 0% PWM
# vstup. V takom prípade sa dá pin PWM normálne použiť a napr. a
# FET so zemným spínačom (štandardný kolík ventilátora) možno použiť na ovládanie napájania
#   ventilátor.
```

### [heater_fan]

Chladiace ventilátory ohrievača (je možné definovať ľubovoľný počet sekcií s predponou "heater_fan"). "Ventilátor ohrievača" je ventilátor, ktorý sa aktivuje vždy, keď je aktívny príslušný ohrievač. V predvolenom nastavení má ohrievačheat_fan rýchlosť vypnutia rovnajúcu sa max_power.

```
[heater_fan heatbreak_cooling_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
# Popis vyššie uvedených parametrov nájdete v časti „ventilátor“.
#ohrievač: extrudér
# Názov konfiguračnej sekcie definujúcej ohrievač, ktorým je tento ventilátor
#   Spojené s. Ak je zoznam názvov ohrievačov oddelený čiarkami
# tu, potom sa ventilátor povolí, keď niektorá z uvedených
Je povolených # ohrievačov. Predvolená hodnota je "extrudér".
#heater_temp: 50,0
# Teplota (v stupňoch Celzia), pod ktorú musí ohrievač klesnúť
# ventilátor je vypnutý. Predvolená hodnota je 50 stupňov Celzia.
#rýchlosť ventilátora: 1,0
# Rýchlosť ventilátora (vyjadrená ako hodnota od 0,0 do 1,0), ktorou ventilátor
# sa nastaví na, keď je aktivovaný príslušný ohrievač. Predvolená hodnota
# je 1,0
```

### [controller_fan]

Ventilátor chladenia regulátora (je možné definovať ľubovoľný počet sekcií s predponou "controller_fan"). "Ventilátor regulátora" je ventilátor, ktorý sa aktivuje vždy, keď je aktívny príslušný ohrievač alebo jeho priradený krokový ovládač. Ventilátor sa zastaví vždy, keď sa dosiahne idle_timeout, aby sa zabezpečilo, že po deaktivácii sledovaného komponentu nedôjde k prehriatiu.

```
[controller_fan my_controller_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
# Popis vyššie uvedených parametrov nájdete v časti „ventilátor“.
#fan_speed: 1.0
# Rýchlosť ventilátora (vyjadrená ako hodnota od 0,0 do 1,0), ktorou ventilátor
# sa nastaví na, keď je aktívny ohrievač alebo krokový ovládač.
# Predvolená hodnota je 1.0
#idle_timeout:
# Čas (v sekundách) po krokovom ovládači alebo ohrievači
# bol aktívny a ventilátor by mal zostať v chode. Predvolená hodnota
# je 30 sekúnd.
#idle_speed:
# Rýchlosť ventilátora (vyjadrená ako hodnota od 0,0 do 1,0), ktorou ventilátor
# sa nastaví na, keď bol aktívny ohrievač alebo krokový ovládač a
# pred dosiahnutím idle_timeout. Predvolená je rýchlosť ventilátora.
#ohrievač:
#stepper:
# Názov konfiguračnej sekcie definujúcej ohrievač/krokový ovládač tohto ventilátora
# je spojené s. Ak čiarkami oddelený zoznam názvov ohrievačov/krokov
Ak je tu uvedené #, potom sa ventilátor aktivuje, keď je niektorá z uvedených možností
Je povolených # ohrievačov/krokov. Predvolený ohrievač je "extruder".
# predvolený stepper sú všetky.
```

### [temperature_fan]

Temperature-triggered cooling fans (one may define any number of sections with a "temperature_fan" prefix). A "temperature fan" is a fan that will be enabled whenever its associated sensor is above a set temperature. By default, a temperature_fan has a shutdown_speed equal to max_power.

Ďalšie informácie nájdete v [odkaz na príkaz](G-Codes.md#temperature_fan).

```
[temperature_fan my_temp_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#   See the "fan" section for a description of the above parameters.
#sensor_type:
#sensor_pin:
#control:
#max_delta:
#min_temp:
#max_temp:
#   See the "extruder" section for a description of the above parameters.
#pid_Kp:
#pid_Ki:
#pid_Kd:
#   The proportional (pid_Kp), integral (pid_Ki), and derivative
#   (pid_Kd) settings for the PID feedback control system. Klipper
#   evaluates the PID settings with the following general formula:
#     fan_pwm = max_power - (Kp*e + Ki*integral(e) - Kd*derivative(e)) / 255
#   Where "e" is "target_temperature - measured_temperature" and
#   "fan_pwm" is the requested fan rate with 0.0 being full off and
#   1.0 being full on. The pid_Kp, pid_Ki, and pid_Kd parameters must
#   be provided when the PID control algorithm is enabled.
#pid_deriv_time: 2.0
#   A time value (in seconds) over which temperature measurements will
#   be smoothed when using the PID control algorithm. This may reduce
#   the impact of measurement noise. The default is 2 seconds.
#target_temp: 40.0
#   A temperature (in Celsius) that will be the target temperature.
#   The default is 40 degrees.
#max_speed: 1.0
#   The fan speed (expressed as a value from 0.0 to 1.0) that the fan
#   will be set to when the sensor temperature exceeds the set value.
#   The default is 1.0.
#min_speed: 0.3
#   The minimum fan speed (expressed as a value from 0.0 to 1.0) that
#   the fan will be set to for PID temperature fans.
#   The default is 0.3.
#gcode_id:
#   If set, the temperature will be reported in M105 queries using the
#   given id. The default is to not report the temperature via M105.
```

### [fan_generic]

Manuálne ovládaný ventilátor (je možné definovať ľubovoľný počet sekcií s predponou "fan_generic"). Rýchlosť manuálne ovládaného ventilátora sa nastavuje pomocou SET_FAN_SPEED [príkaz gcode](G-Codes.md#fan_generic).

```
[fan_generic extruder_partfan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
# Popis vyššie uvedených parametrov nájdete v časti „ventilátor“.
```

## LEDs

### [led]

Support for LEDs (and LED strips) controlled via micro-controller PWM pins (one may define any number of sections with an "led" prefix). See the [command reference](G-Codes.md#led) for more information.

```
[viedol my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
# Pin ovládajúci danú farbu LED. Aspoň jeden z vyššie uvedených
Je potrebné zadať # parametrov.
#cycle_time: 0,010
# Množstvo času (v sekundách) na cyklus PWM. Odporúča sa
# toto môže byť 10 milisekúnd alebo viac pri použití softvérového PWM.
# Predvolená hodnota je 0,010 sekundy.
#hardware_pwm: Nepravda
# Povoľte túto možnosť, ak chcete namiesto softvérového PWM použiť hardvérové PWM. Kedy
# pomocou hardvérového PWM je skutočný čas cyklu obmedzený
# implementácia a môže sa výrazne líšiť od
# požadovaný cycle_time. Predvolená hodnota je False.
#initial_RED: 0,0
#initial_GREEN: 0,0
#initial_BLUE: 0,0
#initial_WHITE: 0,0
# Nastaví počiatočnú farbu LED. Každá hodnota by mala byť medzi 0,0 a
# 1,0. Predvolená hodnota pre každú farbu je 0.
```

### [neopixel]

Neopixel (aka WS2812) podpora LED (je možné definovať ľubovoľný počet sekcií s predponou „neopixel“). Ďalšie informácie nájdete v [odkaz na príkaz](G-Codes.md#led).

Všimnite si, že implementácia [linux mcu](RPi_microcontroller.md) momentálne nepodporuje priamo pripojené neopixely. Súčasný dizajn využívajúci rozhranie linuxového jadra tento scenár neumožňuje, pretože rozhranie GPIO jadra nie je dostatočne rýchle na to, aby poskytovalo požadované pulzové frekvencie.

```
[neopixel my_neopixel]
pripnúť:
# Kolík pripojený k neopixelu. Tento parameter musí byť
# poskytnuté.
#chain_count:
# Počet čipov Neopixel, ktoré sú „daisy chained“ k
# poskytnutý pin. Predvolená hodnota je 1 (čo znamená iba jeden
# Neopixel je pripojený ku kolíku).
#color_order: GRB
# Nastavte poradie pixelov požadované hardvérom LED (pomocou reťazca
# obsahujúce písmená R, G, B, W s W voliteľné). prípadne
# toto môže byť čiarkami oddelený zoznam poradí pixelov – jeden pre každý
# LED v reťazci. Predvolená hodnota je GRB.
#initial_RED: 0,0
#initial_GREEN: 0,0
#initial_BLUE: 0,0
#initial_WHITE: 0,0
# Informácie o týchto parametroch nájdete v časti „LED“.
```

### [dotstar]

Dotstar (aka APA102) LED podpora (je možné definovať ľubovoľný počet sekcií s predponou "dotstar"). Ďalšie informácie nájdete v [odkaz na príkaz](G-Codes.md#led).

```
[dotstar my_dotstar]
data_pin:
# Kolík pripojený k dátovej linke dotstar. Tento parameter
# musí byť poskytnuté.
clock_pin:
# Kolík pripojený k hodinovej linke dotstar. Tento parameter
# musí byť poskytnuté.
#chain_count:
# Informácie o tomto parametri nájdete v časti „neopixel“.
#initial_RED: 0,0
#initial_GREEN: 0,0
#initial_BLUE: 0,0
# Informácie o týchto parametroch nájdete v časti „LED“.
```

### [pca9533]

Podpora LED PCA9533. PCA9533 sa používa na doske strongyboard.

```
[pca9533 my_pca9533]
#i2c_address: 98
# Adresa i2c, ktorú čip používa na zbernici i2c. Použite 98 pre
# PCA9533/1, 99 pre PCA9533/2. Predvolená hodnota je 98.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
# Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre.
#initial_RED: 0,0
#initial_GREEN: 0,0
#initial_BLUE: 0,0
#initial_WHITE: 0,0
# Informácie o týchto parametroch nájdete v časti „LED“.
```

### [pca9632]

Podpora LED PCA9632. PCA9632 sa používa na FlashForge Dreamer.

```
[pca9632 my_pca9632]
#i2c_address: 98
# Adresa i2c, ktorú čip používa na zbernici i2c. Toto môže byť
# 96, 97, 98 alebo 99. Predvolená hodnota je 98.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
# Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre.
#scl_pin:
#sda_pin:
# Prípadne, ak pca9632 nie je pripojený k hardvérovému I2C
# autobus, potom je možné zadať „hodiny“ (scl_pin) a „data“
# (sda_pin) pinov. Predvolené je použitie hardvérového I2C.
#color_order: RGBW
# Nastavte poradie pixelov LED (pomocou reťazca obsahujúceho
# písmen R, G, B, W). Predvolená hodnota je RGBW.
#initial_RED: 0,0
#initial_GREEN: 0,0
#initial_BLUE: 0,0
#initial_WHITE: 0,0
# Informácie o týchto parametroch nájdete v časti „LED“.
```

## Ďalšie servá, tlačidlá a ďalšie kolíky

### [servo]

Servo (možno definovať ľubovoľný počet sekcií s predponou „servo“). Servá môžu byť ovládané pomocou SET_SERVO [príkaz g-kódu](G-Codes.md#servo). Napríklad: SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
pripnúť:
# Výstupný kolík PWM ovládajúci servo. Tento parameter musí byť
# poskytnuté.
#maximum_servo_angle: 180
# Maximálny uhol (v stupňoch), na ktorý je možné nastaviť toto servo. The
# predvolená hodnota je 180 stupňov.
#minimum_pulse_width: 0,001
# Minimálny čas šírky impulzu (v sekundách). Toto by malo zodpovedať
# s uhlom 0 stupňov. Predvolená hodnota je 0,001 sekundy.
#maximum_pulse_width: 0,002
# Čas maximálnej šírky impulzu (v sekundách). Toto by malo zodpovedať
# s uhlom maximum_servo_angle. Predvolená hodnota je 0,002
# sekúnd.
#initial_angle:
# Počiatočný uhol (v stupňoch) na nastavenie serva. Predvolená hodnota je
# neposiela žiadny signál pri spustení.
#initial_pulse_width:
# Čas počiatočnej šírky impulzu (v sekundách), na ktorý sa má servo nastaviť. (Toto
# je platné iba vtedy, ak nie je nastavený počiatočný_uhol.) Predvolená hodnota je nie
# poslať akýkoľvek signál pri spustení.
```

### [gcode_button]

Vykonajte gcode, keď je stlačené alebo uvoľnené tlačidlo (alebo keď kolík zmení stav). Stav tlačidla môžete skontrolovať pomocou tlačidla „QUERY_BUTTON button=my_gcode_button“.

```
[gcode_button my_gcode_button]
pripnúť:
# Pin, na ktorom je tlačidlo pripojené. Tento parameter musí byť
# poskytnuté.
#analog_range:
# Dva čiarkami oddelené odpory (v ohmoch) určujúce minimum
# a maximálny rozsah odporu pre tlačidlo. Ak je analógový_rozsah
# za predpokladu, že kolík musí byť analógový. Predvolená hodnota
# je použitie digitálneho gpio pre tlačidlo.
#analog_pullup_resistor:
# Pullup odpor (v ohmoch), keď je špecifikovaný analog_range.
# Predvolená hodnota je 4700 ohmov.
#press_gcode:
# Zoznam príkazov G-kódu, ktoré sa majú vykonať po stlačení tlačidla.
# Šablóny G-Code sú podporované. Tento parameter je potrebné zadať.
#release_gcode:
# Zoznam príkazov G-kódu, ktoré sa majú vykonať po uvoľnení tlačidla.
# Šablóny G-Code sú podporované. Predvolená hodnota je nespúšťať žiadne
# príkazov pri uvoľnení tlačidla.
```

### [output_pin]

Výstupné kolíky konfigurovateľné za chodu (je možné definovať ľubovoľný počet sekcií s predponou "output_pin"). Piny nakonfigurované tu budú nastavené ako výstupné piny a je možné ich upraviť za behu pomocou rozšíreného typu "SET_PIN PIN=my_pin VALUE=.1" [príkazy kódu g](G-Codes.md#output_pin).

```
[output_pin my_pin]
pripnúť:
# Pin, ktorý sa má nakonfigurovať ako výstup. Tento parameter musí byť
# poskytnuté.
#pwm: Nepravda
# Nastavte, či má byť výstupný kolík schopný modulácie šírky impulzu.
# Ak je to pravda, polia hodnôt by mali byť medzi 0 a 1; Ak si to
# je nepravda, polia hodnôt by mali byť 0 alebo 1. Predvolená hodnota je
# Nepravdivé.
#static_value:
# Ak je toto nastavené, potom sa pri spustení priradí pin tejto hodnote
# a pin nie je možné zmeniť počas prevádzky. Používa sa statický kolík
# o niečo menej RAM v mikrokontroléri. Predvolená hodnota je použiť
# runtime konfigurácia pinov.
#value:
# Hodnota, na ktorú sa má pôvodne nastaviť kolík počas konfigurácie MCU.
# Predvolená hodnota je 0 (pre nízke napätie).
#shutdown_value:
# Hodnota, na ktorú sa má nastaviť kolík pri udalosti vypnutia MCU. Predvolená hodnota
# je 0 (pre nízke napätie).
#maximum_mcu_duration:
# Maximálne trvanie hodnoty bez vypnutia môže riadiť MCU
# bez potvrdenia od hostiteľa.
# Ak hostiteľ nemôže držať krok s aktualizáciou, MCU sa vypne
# a nastavte všetky kolíky na ich príslušné vypínacie hodnoty.
# Predvolené: 0 (zakázané)
# Bežné hodnoty sú okolo 5 sekúnd.
#cycle_time: 0,100
# Množstvo času (v sekundách) na cyklus PWM. Odporúča sa
# toto môže byť 10 milisekúnd alebo viac pri použití softvérového PWM.
# Predvolená hodnota je 0,100 sekundy pre kolíky pwm.
#hardware_pwm: Nepravda
# Povoľte túto možnosť, ak chcete namiesto softvérového PWM použiť hardvérové PWM. Kedy
# pomocou hardvérového PWM je skutočný čas cyklu obmedzený
# implementácia a môže sa výrazne líšiť od
# požadovaný cycle_time. Predvolená hodnota je False.
#mierka:
# Tento parameter možno použiť na zmenu spôsobu, akým sa 'hodnota' a
# Parametre 'shutdown_value' sú interpretované pre piny pwm. Ak
#, potom parameter 'value' by mal byť medzi 0,0 a
# 'mierka'. To môže byť užitočné pri konfigurácii pinu PWM, ktorý
# ovláda krokovú referenciu napätia. „Mierka“ sa dá nastaviť na
# ekvivalentná kroková prúdová sila, ak bola PWM plne aktivovaná a
# potom môže byť parameter 'value' špecifikovaný pomocou požadovaného
# prúd pre stepper. Predvolená hodnota je neškálovať „hodnotu“
# parameter.
```

### [static_digital_output]

Staticky nakonfigurované digitálne výstupné kolíky (je možné definovať ľubovoľný počet sekcií s predponou "static_digital_output"). Piny nakonfigurované tu budú nastavené ako výstup GPIO počas konfigurácie MCU. Nedajú sa zmeniť za behu.

```
[static_digital_output my_output_pins]
pins:
#   A comma separated list of pins to be set as GPIO output pins. The
#   pin will be set to a high level unless the pin name is prefaced
#   with "!". This parameter must be provided.
```

### [multi_pin]

Viacpinové výstupy (jeden môže definovať ľubovoľný počet sekcií s predponou "multi_pin"). Multi_pin výstup vytvára interný alias pinu, ktorý môže upravovať viacero výstupných pinov pri každom nastavení pinu aliasu. Napríklad je možné definovať objekt „[multi_pin my_fan]“ obsahujúci dva kolíky a potom nastaviť „pin=multi_pin:my_fan“ v sekcii „[fan]“ – pri každej výmene ventilátora by sa aktualizovali oba výstupné kolíky. Tieto aliasy sa nesmú používať s kolíkmi krokového motora.

```
[multi_pin my_multi_pin]
špendlíky:
# Čiarkami oddelený zoznam pinov spojených s týmto aliasom. Toto
Musíte zadať # parameter.
```

## TMC stepper driver configuration

Konfigurácia ovládačov krokového motora Trinamic v režime UART/SPI. Ďalšie informácie sú v [Sprievodca ovládačmi TMC](TMC_Drivers.md) a v [odkaz na príkaz](G-Codes.md#tmcxxxx).

### [tmc2130]

Nakonfigurujte ovládač krokového motora TMC2130 cez zbernicu SPI. Ak chcete použiť túto funkciu, definujte konfiguračnú sekciu s predponou "tmc2130", za ktorou bude nasledovať názov zodpovedajúcej konfiguračnej sekcie steppera (napríklad "[tmc2130 stepper_x]").

```
[tmc2130 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2130 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 0
#driver_TBL: 1
#driver_TOFF: 4
#driver_HEND: 7
#driver_HSTRT: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 4
#driver_PWM_AMPL: 128
#driver_SGT: 0
#   Set the given register during the configuration of the TMC2130
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2130 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2130_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2208]

Nakonfigurujte ovládač krokového motora TMC2208 (alebo TMC2224) cez jednožilový UART. Ak chcete použiť túto funkciu, definujte konfiguračnú sekciu s predponou "tmc2208", za ktorou bude nasledovať názov zodpovedajúcej konfiguračnej sekcie steppera (napríklad "[tmc2208 stepper_x]").

```
[tmc2208 stepper_x]
uart_pin:
#   The pin connected to the TMC2208 PDN_UART line. This parameter
#   must be provided.
#tx_pin:
#   If using separate receive and transmit lines to communicate with
#   the driver then set uart_pin to the receive pin and tx_pin to the
#   transmit pin. The default is to use uart_pin for both reading and
#   writing.
#select_pins:
#   A comma separated list of pins to set prior to accessing the
#   tmc2208 UART. This may be useful for configuring an analog mux for
#   UART communication. The default is to not configure any pins.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#   Set the given register during the configuration of the TMC2208
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
```

### [tmc2209]

Nakonfigurujte ovládač krokového motora TMC2209 cez jednožilový UART. Ak chcete použiť túto funkciu, definujte konfiguračnú sekciu s predponou "tmc2209", za ktorou bude nasledovať názov zodpovedajúcej konfiguračnej sekcie steppera (napríklad "[tmc2209 stepper_x]").

```
[tmc2209 stepper_x]
uart_pin:
#tx_pin:
#select_pins:
#interpolate: True
run_current:
#hold_current:
#sense_resistor: 0.110
#stealthchop_threshold: 0
#   See the "tmc2208" section for the definition of these parameters.
#uart_address:
#   The address of the TMC2209 chip for UART messages (an integer
#   between 0 and 3). This is typically used when multiple TMC2209
#   chips are connected to the same UART pin. The default is zero.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#driver_SGTHRS: 0
#   Set the given register during the configuration of the TMC2209
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag_pin:
#   The micro-controller pin attached to the DIAG line of the TMC2209
#   chip. The pin is normally prefaced with "^" to enable a pullup.
#   Setting this creates a "tmc2209_stepper_x:virtual_endstop" virtual
#   pin which may be used as the stepper's endstop_pin. Doing this
#   enables "sensorless homing". (Be sure to also set driver_SGTHRS to
#   an appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2660]

Nakonfigurujte ovládač krokového motora TMC2660 cez zbernicu SPI. Ak chcete použiť túto funkciu, definujte konfiguračnú sekciu s predponou tmc2660, za ktorou nasleduje názov zodpovedajúcej konfiguračnej sekcie steppera (napríklad "[tmc2660 stepper_x]").

```
[tmc2660 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2660 chip select line. This pin
#   will be set to low at the start of SPI messages and set to high
#   after the message transfer completes. This parameter must be
#   provided.
#spi_speed: 4000000
#   SPI bus frequency used to communicate with the TMC2660 stepper
#   driver. The default is 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This only works if microsteps
#   is set to 16. Interpolation does introduce a small systemic
#   positional deviation - see TMC_Drivers.md for details. The default
#   is True.
run_current:
#   The amount of current (in amps RMS) used by the driver during
#   stepper movement. This parameter must be provided.
#sense_resistor:
#   The resistance (in ohms) of the motor sense resistor. This
#   parameter must be provided.
#idle_current_percent: 100
#   The percentage of the run_current the stepper driver will be
#   lowered to when the idle timeout expires (you need to set up the
#   timeout using a [idle_timeout] config section). The current will
#   be raised again once the stepper has to move again. Make sure to
#   set this to a high enough value such that the steppers do not lose
#   their position. There is also small delay until the current is
#   raised again, so take this into account when commanding fast moves
#   while the stepper is idling. The default is 100 (no reduction).
#driver_TBL: 2
#driver_RNDTF: 0
#driver_HDEC: 0
#driver_CHM: 0
#driver_HEND: 3
#driver_HSTRT: 3
#driver_TOFF: 4
#driver_SEIMIN: 0
#driver_SEDN: 0
#driver_SEMAX: 0
#driver_SEUP: 0
#driver_SEMIN: 0
#driver_SFILT: 0
#driver_SGT: 0
#driver_SLPH: 0
#driver_SLPL: 0
#driver_DISS2G: 0
#driver_TS2G: 3
#   Set the given parameter during the configuration of the TMC2660
#   chip. This may be used to set custom driver parameters. The
#   defaults for each parameter are next to the parameter name in the
#   list above. See the TMC2660 datasheet about what each parameter
#   does and what the restrictions on parameter combinations are. Be
#   especially aware of the CHOPCONF register, where setting CHM to
#   either zero or one will lead to layout changes (the first bit of
#   HDEC) is interpreted as the MSB of HSTRT in this case).
```

### [tmc2240]

Nakonfigurujte ovládač krokového motora TMC2240 cez zbernicu SPI alebo UART. Ak chcete použiť túto funkciu, definujte konfiguračnú sekciu s predponou "tmc2240", za ktorou nasleduje názov zodpovedajúcej konfiguračnej sekcie steppera (napríklad "[tmc2240 stepper_x]").

```
[tmc2240 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2240 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#uart_pin:
#   The pin connected to the TMC2240 DIAG1/SW line. If this parameter
#   is provided UART communication is used rather then SPI.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#rref: 12000
#   The resistance (in ohms) of the resistor between IREF and GND. The
#   default is 12000.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#driver_OFFSET_SIN90: 0
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#   Additionally, this driver also has the OFFSET_SIN90 field which can be used
#   to tune a motor with unbalanced coils. See the `Sine Wave Lookup Table`
#   section in the datasheet for information about this field and how to tune
#   it.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_IRUNDELAY: 4
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 29
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_SG4_ANGLE_OFFSET: 1
#   Set the given register during the configuration of the TMC2240
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2240 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2240_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc5160]

Nakonfigurujte ovládač krokového motora TMC5160 cez zbernicu SPI. Ak chcete použiť túto funkciu, definujte konfiguračnú sekciu s predponou "tmc5160", za ktorou bude nasledovať názov zodpovedajúcej konfiguračnej sekcie steppera (napríklad "[tmc5160 stepper_x]").

```
[tmc5160 stepper_x]
cs_pin:
#   The pin corresponding to the TMC5160 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.075
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.075 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 30
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_DRVSTRENGTH: 0
#driver_BBMCLKS: 4
#driver_BBMTIME: 0
#driver_FILT_ISENSE: 0
#   Set the given register during the configuration of the TMC5160
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC5160 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc5160_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

## Konfigurácia prúdu krokového motora za chodu

### [ad5206]

Staticky nakonfigurované AD5206 digipoty pripojené cez SPI zbernicu (možno definovať ľubovoľný počet sekcií s prefixom "ad5206").

```
[ad5206 my_digipot]
enable_pin:
# Pin zodpovedajúci riadku výberu čipu AD5206. Tento špendlík
# sa nastaví na nízku hodnotu na začiatku správ SPI a zvýši na vysokú
# po dokončení správy. Tento parameter je potrebné zadať.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Popis nájdete v časti „spoločné nastavenia SPI“.
# vyššie uvedené parametre.
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
# Hodnota, na ktorú sa má staticky nastaviť daný kanál AD5206. Toto je
# sa zvyčajne nastavuje na číslo medzi 0,0 a 1,0, pričom 1,0 je
# najvyšší odpor a 0,0 je najnižší odpor. však
# rozsah je možné zmeniť pomocou parametra 'scale' (pozri nižšie).
# Ak kanál nie je špecifikovaný, zostane nenakonfigurovaný.
#mierka:
# Tento parameter možno použiť na zmenu parametrov 'channel_x'
# sú interpretované. Ak sú uvedené, potom parametre „channel_x“.
# by malo byť medzi 0,0 a 'scale'. To môže byť užitočné, keď
# AD5206 sa používa na nastavenie krokových referencií napätia. „Váha“ môže
# nastavte na ekvivalentnú krokovú intenzitu prúdu, ak by bol AD5206 na
# jeho najvyšší odpor a potom môžu byť parametre 'channel_x'
# špecifikované pomocou požadovanej hodnoty prúdu pre stepper. The
# predvolené je neškálovať parametre 'channel_x'.
```

### [mcp4451]

Staticky nakonfigurovaný digipot MCP4451 pripojený cez I2C zbernicu (možno definovať ľubovoľný počet sekcií s predponou „mcp4451“).

```
[mcp4451 my_digipot]
i2c_address:
# Adresa i2c, ktorú čip používa na zbernici i2c. Toto
Musíte zadať # parameter.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
# Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre.
#wiper_0:
#wiper_1:
#wiper_2:
#wiper_3:
# Hodnota, na ktorú sa má staticky nastaviť daný „stierač“ MCP4451. Toto je
# sa zvyčajne nastavuje na číslo medzi 0,0 a 1,0, pričom 1,0 je
# najvyšší odpor a 0,0 je najnižší odpor. však
# rozsah je možné zmeniť pomocou parametra 'scale' (pozri nižšie).
# Ak nie je špecifikovaný stierač, zostane nenakonfigurovaný.
#mierka:
# Tento parameter možno použiť na zmenu parametrov 'wiper_x'
# sú interpretované. Ak sú uvedené, mali by byť parametre 'wiper_x'
# byť medzi 0,0 a 'scale'. To môže byť užitočné, keď je MCP4451
# slúži na nastavenie krokových referencií napätia. „Mierka“ sa dá nastaviť na
# ekvivalentná kroková prúdová sila, ak by bola MCP4451 na najvyššej úrovni
# odpor a potom je možné zadať parametre 'wiper_x'
# pomocou požadovanej hodnoty prúdu pre stepper. Predvolená hodnota je
# na neškálovanie parametrov 'wiper_x'.
```

### [mcp4728]

Statically configured MCP4728 digital-to-analog converter connected via I2C bus (one may define any number of sections with an "mcp4728" prefix).

```
[mcp4728 my_dac]
#i2c_address: 96
# Adresa i2c, ktorú čip používa na zbernici i2c. Predvolená hodnota
# je 96.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
# Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre.
#channel_a:
#channel_b:
#channel_c:
#channel_d:
# Hodnota, na ktorú sa má staticky nastaviť daný kanál MCP4728. Toto je
# sa zvyčajne nastavuje na číslo medzi 0,0 a 1,0, pričom 1,0 je
# najvyššie napätie (2,048 V) a 0,0 je najnižšie napätie.
# Rozsah však možno zmeniť pomocou parametra „scale“ (pozri
# nižšie). Ak kanál nie je špecifikovaný, zostane ponechaný
# nenakonfigurované.
#mierka:
# Tento parameter možno použiť na zmenu parametrov 'channel_x'
# sú interpretované. Ak sú uvedené, potom parametre „channel_x“.
# by malo byť medzi 0,0 a 'scale'. To môže byť užitočné, keď
# MCP4728 sa používa na nastavenie krokových referencií napätia. „Váha“ môže
# nastaviť na ekvivalentnú krokovú intenzitu prúdu, ak by bol MCP4728 na
# jeho najvyššie napätie (2,048V) a potom parametre 'channel_x'
# môže byť špecifikované pomocou požadovanej hodnoty prúdu pre
# stepper. Štandardne sa neškálujú parametre 'channel_x'.
```

### [mcp4018]

Staticky nakonfigurovaný MCP4018 digipot pripojený cez dva gpio kolíky „bit banging“ (jeden môže definovať ľubovoľný počet sekcií s predponou „mcp4018“).

```
[mcp4018 my_digipot]
scl_pin:
# Pin "hodiny" SCL. Tento parameter je potrebné zadať.
sda_pin:
# Dátový kolík SDA. Tento parameter je potrebné zadať.
stierač:
# Hodnota, na ktorú sa má staticky nastaviť daný „stierač“ MCP4018. Toto je
# sa zvyčajne nastavuje na číslo medzi 0,0 a 1,0, pričom 1,0 je
# najvyšší odpor a 0,0 je najnižší odpor. však
# rozsah je možné zmeniť pomocou parametra 'scale' (pozri nižšie).
# Tento parameter musí byť zadaný.
#mierka:
# Tento parameter možno použiť na zmenu parametra „stierača“.
#   vykladané. Ak je k dispozícii, potom by mal byť parameter „stierač“.
# medzi 0,0 a 'scale'. To môže byť užitočné, keď je MCP4018
# slúži na nastavenie krokových referencií napätia. „Mierka“ sa dá nastaviť na
# ekvivalentná kroková intenzita prúdu, ak je MCP4018 na najvyššej úrovni
# odpor a potom je možné zadať parameter 'stierač' pomocou
# požadovaná hodnota prúdu pre stepper. Predvolená hodnota je nie
# škálovať parameter 'stierač'.
```

## Podpora displeja

### [display]

Support for a display attached to the micro-controller.

```
[zobraziť]
lcd_type:
# Typ používaného LCD čipu. Môže to byť "hd44780", "hd44780_spi",
# "st7920", "emulated_st7920", "uc1701", "ssd1306" alebo "sh1106".
# Informácie o jednotlivých typoch a typoch nájdete v častiach zobrazenia nižšie
# ďalšie parametre, ktoré poskytujú. Tento parameter musí byť
# poskytnuté.
#display_group:
# Názov skupiny display_data, ktorá sa má zobraziť na displeji. Toto
# riadi obsah obrazovky (pozrite si časť „display_data“.
#   Pre viac informácií). Predvolená hodnota je _default_20x4 pre hd44780
# displejov a _default_16x4 pre ostatné displeje.
#menu_timeout:
# Časový limit pre menu. Ak je toto množstvo sekúnd neaktívne, bude to tak
# spúšťacie menu ukončenie alebo návrat do koreňového menu pri automatickom spustení
# povolené. Predvolená hodnota je 0 sekúnd (zakázané)
#menu_root:
# Názov časti hlavnej ponuky, ktorá sa zobrazí po kliknutí na kódovač
# na domovskej obrazovke. Predvolená hodnota je __main a toto zobrazuje
# predvolené ponuky definované v klippy/extras/display/menu.cfg
#menu_reverse_navigation:
# Keď je povolená, bude sa pre zoznam obracať nahor a nadol
# navigácia. Predvolená hodnota je False. Tento parameter je voliteľný.
#encoder_pins:
# Kolíky pripojené ku kódovaču. Pri použití musia byť poskytnuté 2 kolíky
# kódovač. Tento parameter je potrebné zadať pri používaní ponuky.
#encoder_steps_per_detent:
# Koľko krokov vydá kódovač na zarážku ("kliknutie"). Ak
# kódovač má dve zarážky na pohyb medzi záznamami alebo pohybuje dvoma
# záznamov z jednej zarážky, skúste to zmeniť. Povolené hodnoty sú 2
# (polovičný krok) alebo 4 (úplný krok). Predvolená hodnota je 4.
#click_pin:
# Kolík pripojený k tlačidlu „enter“ alebo „kliknutiu“ kódovača. Toto
Pri používaní ponuky je potrebné zadať # parameter. Prítomnosť an
# 'analog_range_click_pin' konfiguračný parameter zmení tento parameter
# z digitálneho na analógový.
#back_pin:
# Kolík pripojený k tlačidlu „späť“. Tento parameter je voliteľný,
# menu je možné použiť aj bez neho. Prítomnosť an
# 'analog_range_back_pin' konfiguračný parameter zmení tento parameter z
# digitálne na analógové.
#up_pin:
# Kolík pripojený k tlačidlu „hore“. Tento parameter je potrebné zadať
# pri používaní ponuky bez kódovača. Prítomnosť an
# 'analog_range_up_pin' konfiguračný parameter zmení tento parameter z
# digitálne na analógové.
#down_pin:
# Kolík pripojený k tlačidlu „dole“. Tento parameter musí byť
# poskytnuté pri používaní ponuky bez kódovača. Prítomnosť an
# 'analog_range_down_pin' konfiguračný parameter zmení tento parameter
# digitálne na analógové.
#kill_pin:
# Kolík pripojený k tlačidlu „zabiť“. Toto tlačidlo zavolá
#   núdzová zastávka. Prítomnosť konfigurácie 'analog_range_kill_pin'
# parameter zmení tento parameter z digitálneho na analógový.
#analog_pullup_rezistor: 4700
# Odpor (v ohmoch) pullupu pripojeného k analógu
# tlačidlo. Predvolená hodnota je 4700 ohmov.
#analog_range_click_pin:
# Rozsah odporu pre tlačidlo „enter“. Minimálny dosah a
Pri použití analógového signálu je potrebné zadať maximálne hodnoty oddelené čiarkou
# tlačidlo.
#analog_range_back_pin:
# Rozsah odporu pre tlačidlo „späť“. Minimálny dosah a
Pri použití analógového signálu je potrebné zadať maximálne hodnoty oddelené čiarkou
# tlačidlo.
#analog_range_up_pin:
# Rozsah odporu pre tlačidlo „hore“. Minimálny a maximálny rozsah
Pri použití analógového tlačidla je potrebné zadať # hodnoty oddelené čiarkou.
#analog_range_down_pin:
# Rozsah odporu pre tlačidlo „dole“. Minimálny dosah a
Pri použití analógového signálu je potrebné zadať maximálne hodnoty oddelené čiarkou
# tlačidlo.
#analog_range_kill_pin:
# Rozsah odporu pre tlačidlo „zabiť“. Minimálny dosah a
Pri použití analógového signálu je potrebné zadať maximálne hodnoty oddelené čiarkou
# tlačidlo.
```

#### hd44780 display

Informácie o konfigurácii displejov hd44780 (ktoré sa používajú v displejoch typu „RepRapDiscount 2004 Smart Controller“).

```
[zobraziť]
lcd_type: hd44780
# Nastavte na "hd44780" pre displeje hd44780.
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
# Kolíky pripojené k lcd typu hd44780. Tieto parametre musia
#   byť poskytovaný.
#hd44780_protocol_init: Pravda
# Vykonajte inicializáciu 8-bitového/4-bitového protokolu na displeji hd44780.
# Toto je potrebné na skutočných zariadeniach hd44780. Jeden však môže potrebovať
#, aby ste to zakázali na niektorých „klonovacích“ zariadeniach. Predvolená hodnota je True.
#line_length:
# Nastavte počet znakov na riadok pre lcd typu hd44780.
# Možné hodnoty sú 20 (predvolené) a 16. Počet riadkov je
# opravené na 4.
...
```

#### hd44780_spi display

Informácie o konfigurácii displeja hd44780_spi - displej s rozmermi 20x04 ovládaný prostredníctvom hardvérového "posuvného registra" (ktorý sa používa v tlačiarňach na báze mayyboard).

```
[zobraziť]
lcd_type: hd44780_spi
# Nastavte na „hd44780_spi“ pre displeje hd44780_spi.
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
# Kolíky pripojené k posuvnému registru ovládajúcemu displej.
# Spi_software_miso_pin musí byť nastavený na nepoužitý pin
# základná doska tlačiarne, pretože posuvný register nemá kolík MISO,
# ale implementácia spi softvéru vyžaduje, aby tento pin bol
# nakonfigurované.
#hd44780_protocol_init: Pravda
# Vykonajte inicializáciu 8-bitového/4-bitového protokolu na displeji hd44780.
# Toto je potrebné na skutočných zariadeniach hd44780. Jeden však môže potrebovať
#, aby ste to zakázali na niektorých „klonovacích“ zariadeniach. Predvolená hodnota je True.
#line_length:
# Nastavte počet znakov na riadok pre lcd typu hd44780.
# Možné hodnoty sú 20 (predvolené) a 16. Počet riadkov je
# opravené na 4.
...
```

#### st7920 display

Informácie o konfigurácii displejov st7920 (ktoré sa používajú v displejoch typu "RepRapDiscount 12864 Full Graphic Smart Controller").

```
[zobraziť]
lcd_type: st7920
# Pre displeje st7920 nastavte na "st7920".
cs_pin:
sclk_pin:
sid_pin:
# Kolíky pripojené k lcd typu st7920. Tieto parametre musia byť
# poskytnuté.
...
```

#### emulated_st7920 display

Informácie o konfigurácii emulovaného displeja st7920 – nájdete v niektorých „2,4-palcových zariadeniach s dotykovou obrazovkou“ a podobne.

```
[zobraziť]
lcd_type: emulated_st7920
#      Nastavte na "emulated_st7920" pre obrazovky emulated_st7920.
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#       Kolíky pripojené k lcd typu emulated_st7920. En_pin
#       zodpovedá cs_pin lcd typu st7920,
#       spi_software_sclk_pin zodpovedá sclk_pin a
#       spi_software_mosi_pin zodpovedá sid_pin. The
#       spi_software_miso_pin musí byť nastavený na nepoužívaný pin
#       základná doska tlačiarne ako st7920 bez pinu MISO, ale so softvérom
#       spi implementácia vyžaduje, aby bol tento pin nakonfigurovaný.
...
```

#### uc1701 display

Informácie o konfigurácii displejov uc1701 (ktoré sa používajú v displejoch typu „MKS Mini 12864“).

```
[zobraziť]
lcd_type: uc1701
# Nastavte na "uc1701" pre uc1701 displeje.
cs_pin:
a0_pin:
# Kolíky pripojené k LCD typu uc1701. Tieto parametre musia byť
# poskytnuté.
#rst_pin:
# Kolík pripojený k „prvému“ kolíku na lcd. Ak nie je
# špecifikované, potom musí mať hardvér vyťahovací prvok
# zodpovedajúca lcd linka.
#kontrast:
# Kontrast, ktorý sa má nastaviť. Hodnota sa môže pohybovať od 0 do 63 a
# predvolená hodnota je 40.
...
```

#### Displeje ssd1306 a sh1106

Informácie o konfigurácii displejov ssd1306 a sh1106.

```
[zobraziť]
lcd_type:
# Pre daný typ zobrazenia nastavte buď "ssd1306" alebo "sh1106".
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
# Voliteľné parametre dostupné pre displeje pripojené cez i2c
# autobus. Popis nájdete v časti „bežné nastavenia I2C“.
# vyššie uvedené parametre.
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Kolíky pripojené k LCD v "4-drôtovom" režime spi. Pozrite si
# časť "spoločné nastavenia SPI" pre popis parametrov
# ktoré začínajú na "spi_". Predvolené je použitie režimu i2c pre
# displej.
#reset_pin:
# Na displeji môže byť špecifikovaný resetovací kolík. Ak nie je
# špecifikované, potom musí mať hardvér vyťahovací prvok
# zodpovedajúca lcd linka.
#kontrast:
# Kontrast, ktorý sa má nastaviť. Hodnota sa môže pohybovať od 0 do 256 a
# predvolená hodnota je 239.
#vcomh: 0
# Na displeji nastavte hodnotu Vcomh. Táto hodnota je spojená s
# efekt "rozmazania" na niektorých OLED displejoch. Hodnota sa môže pohybovať
# od 0 do 63. Predvolená hodnota je 0.
#invert: Nepravda
# TRUE invertuje pixely na určitých OLED displejoch. Predvolená hodnota je
# Nepravdivé.
#x_offset: 0
# Nastavte hodnotu horizontálneho posunu na displejoch SH1106. Predvolená hodnota je
# 0.
...
```

### [display_data]

Support for displaying custom data on an lcd screen. One may create any number of display groups and any number of data items under those groups. The display will show all the data items for a given group if the display_group option in the [display] section is set to the given group name.

Automaticky sa vytvorí [predvolená sada skupín displejov] (../klippy/extras/display/display.cfg). Tieto položky display_data je možné nahradiť alebo rozšíriť prepísaním predvolených nastavení v hlavnom konfiguračnom súbore printer.cfg.

```
[display_data my_group_name my_data_name]
pozícia:
#       Čiarkami oddelený riadok a stĺpec pozície zobrazenia, ktorý by mal
#       sa používa na zobrazenie informácií. Tento parameter musí byť
#       poskytnuté.
text:
#       Text, ktorý sa má zobraziť na danej pozícii. Toto pole sa vyhodnocuje
#       pomocou šablón príkazov (pozri docs/Command_Templates.md). Toto
Musíte zadať # parameter.
```

### [display_template]

Zobraziť dátový text "makrá" (možno definovať ľubovoľný počet sekcií s predponou display_template). Informácie o vyhodnocovaní šablón nájdete v dokumente [šablóny príkazov](Command_Templates.md).

This feature allows one to reduce repetitive definitions in display_data sections. One may use the builtin `render()` function in display_data sections to evaluate a template. For example, if one were to define `[display_template my_template]` then one could use `{ render('my_template') }` in a display_data section.

This feature can also be used for continuous LED updates using the [SET_LED_TEMPLATE](G-Codes.md#set_led_template) command.

```
[display_template my_template_name]
#param_<meno>:
# Môžete zadať ľubovoľný počet možností s predponou "param_". The
# krstnému názvu bude priradená daná hodnota (analyzovaná ako Python
# literal) a bude k dispozícii počas rozšírenia makra. Ak
Parameter # sa odovzdá vo volaní funkcie render(), potom bude táto hodnota
# sa používa počas rozšírenia makra. Napríklad konfigurácia s
# "param_speed = 75" môže mať volajúceho s
# "render('my_template_name', param_speed=80)". Názvy parametrov môžu
# nepoužívajte veľké písmená.
text:
# Text, ktorý sa má vrátiť po vykreslení tejto šablóny. Toto pole
# sa vyhodnocuje pomocou šablón príkazov (pozri
# docs/Command_Templates.md). Tento parameter je potrebné zadať.
```

### [display_glyph]

Zobrazte vlastný glyf na displejoch, ktoré ho podporujú. Danému názvu budú priradené dané údaje zobrazenia, na ktoré sa potom môžu odkazovať v šablónach zobrazenia ich názvom obklopeným dvoma symbolmi „vlnovky“, t. j. `~my_display_glyph~`

Niektoré príklady nájdete v [sample-glyphs.cfg](../config/sample-glyphs.cfg).

```
[display_glyph my_display_glyph]
#data:
# Údaje na displeji uložené ako 16 riadkov pozostávajúcich zo 16 bitov (1 na
# pixel), kde '.' je prázdny pixel a „*“ je zapnutý pixel (napr.
# "****************" na zobrazenie plnej vodorovnej čiary).
# Alternatívne je možné použiť „0“ pre prázdny pixel a „1“ pre zapnutie
# pixel. Vložte každý riadok zobrazenia do samostatného konfiguračného riadku. The
# glyf musí pozostávať z presne 16 riadkov so 16 bitmi. Toto
# parameter je voliteľný.
#hd44780_data:
# Glyf na použitie na displejoch 20x4 hd44780. Glyf musí pozostávať z
# presne 8 riadkov po 5 bitoch. Tento parameter je voliteľný.
#hd44780_slot:
# Hardvérový index hd44780 (0..7), na ktorý sa má glyf uložiť. Ak
# viaceré odlišné obrázky používajú rovnaký slot, potom sa uistite, že iba
# použite jeden z týchto obrázkov na ľubovoľnej obrazovke. Tento parameter je
# povinné, ak je zadaný hd44780_data.
```

### [display my_extra_display]

Ak bola v printer.cfg definovaná primárna sekcia [zobrazenie], ako je uvedené vyššie, je možné definovať viacero pomocných obrazoviek. Všimnite si, že pomocné displeje momentálne nepodporujú funkcie ponuky, teda nepodporujú možnosti „ponuky“ alebo konfiguráciu tlačidiel.

```
[display my_extra_display]
# Dostupné parametre nájdete v časti „zobrazenie“.
```

### [menu]

Prispôsobiteľné ponuky LCD displeja.

Automaticky sa vytvorí [predvolený súbor ponúk] (../klippy/extras/display/menu.cfg). Ponuku možno nahradiť alebo rozšíriť prepísaním predvolených nastavení v hlavnom konfiguračnom súbore printer.cfg.

Pozrite si [dokument šablóny príkazov](Command_Templates.md#menu-templates), kde nájdete informácie o atribútoch ponuky dostupných počas vykresľovania šablóny.

```
# Spoločné parametre dostupné pre všetky sekcie konfigurácie menu.
#[menu __some_list __some_name]
#type: zakázané
# Natrvalo zakázaný prvok ponuky, povinným atribútom je iba 'typ'.
# Umožňuje vám jednoducho zakázať/skryť existujúce položky ponuky.

#[menu some_name]
#typ:
# Jeden z príkazu, vstupu, zoznamu, textu:
# command - základný prvok menu s rôznymi spúšťačmi skriptov
# input – rovnaký ako „príkaz“, ale má schopnosť meniť hodnotu.
# Stlačením spustíte/zastavíte režim úprav.
# zoznam - umožňuje zoskupiť položky menu do a
# rolovateľný zoznam. Pridajte do zoznamu vytvorením ponuky
# konfigurácií s použitím "nejakého_zoznamu" ako predpony - pre
# príklad: [menu some_list some_item_in_the_list]
# vsdlist - to isté ako 'list', ale pripojí súbory z virtuálnej sdcard
# (bude odstránené v budúcnosti)
#názov:
# Názov položky menu - vyhodnotené ako šablóna.
#enable:
# Šablóna, ktorá sa vyhodnotí ako True alebo False.
#index:
# Pozícia, kde je potrebné vložiť položku do zoznamu. Predvolene
# položka sa pridá na koniec.

#[menu some_list]
#typ: zoznam
#názov:
#enable:
# Popis týchto parametrov nájdete vyššie.

#[menu some_list some_command]
#type: príkaz
#názov:
#enable:
# Popis týchto parametrov nájdete vyššie.
#gcode:
# Skript na spustenie kliknutím na tlačidlo alebo dlhým kliknutím. Vyhodnotené ako a
# šablóna.

#[menu some_list some_input]
#typ: vstup
#názov:
#enable:
# Popis týchto parametrov nájdete vyššie.
#input:
# Počiatočná hodnota, ktorá sa má použiť pri úpravách – vyhodnotená ako šablóna.
# Výsledok musí byť pohyblivý.
#input_min:
# Minimálna hodnota rozsahu - vyhodnotená ako šablóna. Predvolená hodnota -99999.
#input_max:
# Maximálna hodnota rozsahu - vyhodnotená ako šablóna. Predvolená hodnota 99999.
#input_step:
# Krok úpravy – Musí to byť kladné celé číslo alebo pohyblivá hodnota. Má
# interný krok rýchlej rýchlosti. Keď "(vstup_max - vstup_min) /
# input_step > 100" potom rýchly krok je 10 * input_step inak rýchly
# krok rýchlosti je rovnaký input_step.
#reálny čas:
# Tento atribút akceptuje statickú boolovskú hodnotu. Keď je aktivovaná
# skript gcode sa spustí po každej zmene hodnoty. Predvolená hodnota je False.
#gcode:
# Skript na spustenie po kliknutí na tlačidlo, dlhom kliknutí alebo zmene hodnoty.
# Vyhodnotené ako šablóna. Kliknutím na tlačidlo sa spustí úprava
# začiatok alebo koniec režimu.
```

## Filament sensors

### [filament_switch_sensor]

Senzor prepínača vlákna. Podpora pre detekciu vloženia vlákna a hádzania pomocou snímača spínača, ako je koncový spínač.

Ďalšie informácie nájdete v [odkaz na príkaz](G-Codes.md#filament_switch_sensor).

```
[filament_switch_sensor my_sensor]
#pause_on_runout: Pravda
# Keď je nastavené na True, PAUSE sa spustí ihneď po vyčerpaní
# je zistený. Všimnite si, že ak je pause_on_runout False a
# runout_gcode je vynechaný, potom je detekcia runout zakázaná. Predvolené
#   je pravda.
#runout_gcode:
# Zoznam príkazov kódu G, ktoré sa majú vykonať po vyčerpaní vlákna
# zistených. Formát G-kódu nájdete na stránke docs/Command_Templates.md. Ak
# pause_on_runout je nastavené na True tento G-kód sa spustí po
# PAUSE je dokončená. Štandardne sa nespúšťajú žiadne príkazy G-kódu.
#insert_gcode:
# Zoznam príkazov kódu G, ktoré sa majú vykonať po vložení vlákna
# zistených. Formát G-kódu nájdete na stránke docs/Command_Templates.md. The
# predvolené je nespúšťať žiadne príkazy G-kódu, čo zakazuje vkladanie
# detekcia.
#event_delay: 3.0
# Minimálny čas v sekundách na oneskorenie medzi udalosťami.
# Udalosti spustené počas tohto časového obdobia budú tiché
# ignorované. Predvolená hodnota je 3 sekundy.
#pause_delay: 0,5
# Čas oneskorenia v sekundách medzi príkazom pauzy
# odoslanie a vykonanie runout_gcode. Môže to byť užitočné
# zvýšte toto oneskorenie, ak OctoPrint vykazuje zvláštne správanie pri pozastavení.
# Predvolená hodnota je 0,5 sekundy.
#switch_pin:
# Pin, na ktorom je pripojený spínač. Tento parameter musí byť
# poskytnuté.
```

### [filament_motion_sensor]

Snímač pohybu vlákna. Podpora pre detekciu vloženia vlákna a hádzania pomocou kódovača, ktorý prepína výstupný kolík počas pohybu vlákna cez snímač.

Ďalšie informácie nájdete v [odkaz na príkaz](G-Codes.md#filament_switch_sensor).

```
[filament_motion_sensor my_sensor]
dĺžka_detekcie: 7,0
# Minimálna dĺžka vlákna pretiahnutého cez snímač na spustenie
# zmena stavu na prepínači
# Predvolená hodnota je 7 mm.
extrudér:
# Názov sekcie extrudéra, s ktorou je tento senzor spojený.
# Tento parameter musí byť zadaný.
prepínač:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
# Pozrite si časť "filament_switch_sensor" pre popis
# vyššie uvedené parametre.
```

### [tsl1401cl_filament_width_sensor]

TSLl401CL Based Filament Width Sensor. See the [guide](TSL1401CL_Filament_Width_Sensor.md) for more information.

```
[tsl1401cl_filament_width_sensor]
#pin:
#default_nominal_filament_diameter: 1.75 # (mm)
#   Maximum allowed filament diameter difference as mm.
#max_difference: 0.2
#   The distance from sensor to the melting chamber as mm.
#measurement_delay: 100
```

### [hall_filament_width_sensor]

Senzor šírky Hallovho vlákna (pozri [Senzor šírky Hallovho vlákna](Hall_Filament_Width_Sensor.md)).

```
[hall_filament_width_sensor]
adc1:
adc2:
# Analógové vstupné kolíky pripojené k senzoru. Tieto parametre musia
#   byť poskytovaný.
#cal_dia1: 1,50
#cal_dia2: 2,00
# Kalibračné hodnoty (v mm) pre snímače. Predvolená hodnota je
# 1,50 pre cal_dia1 a 2,00 pre cal_dia2.
#raw_dia1: 9500
#raw_dia2: 10500
# Hrubé kalibračné hodnoty pre senzory. Predvolená hodnota je 9500
# pre raw_dia1 a 10500 pre raw_dia2.
#default_nominal_filament_diameter: 1,75
# Menovitý priemer vlákna. Tento parameter je potrebné zadať.
#max_difference: 0,200
# Maximálny povolený rozdiel priemeru vlákna v milimetroch (mm).
# Ak je rozdiel medzi menovitým priemerom vlákna a výstupom snímača
# je viac ako +- max_difference, multiplikátor vytláčania je nastavený späť
# až %100. Predvolená hodnota je 0,200.
#measurement_delay: 70
# Vzdialenosť od snímača k taviacej komore/horúcej časti
# milimetrov (mm). Vlákno medzi snímačom a horúcim koncom
# sa bude považovať za default_nominal_filament_diameter. Hostiteľ
# modul pracuje s logikou FIFO. Zachováva hodnotu každého snímača a
# pozíciu v poli a POP ich späť na správnu pozíciu. Toto
Musíte zadať # parameter.
#enable: False
# Senzor aktivovaný alebo zakázaný po zapnutí. Predvolená hodnota je
# zakázať.
#interval_merania: 10
# Približná vzdialenosť (v mm) medzi hodnotami snímača. The
# predvolená hodnota je 10 mm.
#logging: Nepravda
# Výstupný priemer do terminálu a klipper.log je možné zapnúť|z
# príkaz.
#min_diameter: 1,0
# Minimálny priemer pre spúšťací virtuálny filament_switch_sensor.
#use_current_dia_while_delay: Nesprávne
# Použite aktuálny priemer namiesto menovitého priemeru
# oneskorenie merania neprebehlo.
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
# Pozrite si časť "filament_switch_sensor" pre popis
# vyššie uvedené parametre.
```

## Hardvérová podpora špecifická pre dosku

### [sx1509]

Nakonfigurujte expandér SX1509 I2C na GPIO. Kvôli oneskoreniu spôsobenému I2C komunikáciou by ste NEPOUŽÍVALI kolíky SX1509 na aktiváciu krokovania, krokové alebo dir kolíky alebo akékoľvek iné kolíky, ktoré vyžadujú rýchle bit-bangovanie. Najlepšie sa používajú ako statické alebo gcode riadené digitálne výstupy alebo hardvérovo-pwm piny pre napr. Fanúšikovia. Je možné definovať ľubovoľný počet sekcií s predponou „sx1509“. Každý expandér poskytuje sadu 16 pinov (sx1509_my_sx1509:PIN_0 až sx1509_my_sx1509:PIN_15), ktoré možno použiť v konfigurácii tlačiarne.

Príklad nájdete v súbore [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg).

```
[sx1509 my_sx1509]
i2c_address:
#   I2C address used by this expander. Depending on the hardware
#   jumpers this is one out of the following addresses: 62 63 112
#   113. This parameter must be provided.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### [samd_sercom]

Konfigurácia SAMD SERCOM na určenie, ktoré kolíky sa majú použiť na danom SERCOM. Je možné definovať ľubovoľný počet sekcií s predponou „samd_sercom“. Každý SERCOM musí byť pred použitím ako periférne zariadenie SPI alebo I2C nakonfigurovaný. Umiestnite túto konfiguračnú sekciu nad akúkoľvek inú sekciu, ktorá využíva zbernice SPI alebo I2C.

```
[samd_sercom my_sercom]
sercom:
# Názov sercom zbernice na konfiguráciu v mikrokontroléri.
# Dostupné názvy sú "sercom0", "sercom1" atď. Tento parameter
# musí byť poskytnuté.
tx_pin:
# MOSI pin pre SPI komunikáciu, alebo SDA (dátový) pin pre I2C
#komunikacia. Pin musí mať platnú konfiguráciu pinmux
# pre danú perifériu SERCOM. Tento parameter je potrebné zadať.
#rx_pin:
# MISO pin pre komunikáciu SPI. Tento kolík sa nepoužíva pre I2C
# komunikácia (I2C používa tx_pin na odosielanie aj prijímanie).
# Pin musí mať platnú konfiguráciu pinmux pre danú položku
# Periférne zariadenie SERCOM. Tento parameter je voliteľný.
clk_pin:
# CLK pin pre SPI komunikáciu alebo SCL (hodinový) pin pre I2C
#komunikacia. Pin musí mať platnú konfiguráciu pinmux
# pre danú perifériu SERCOM. Tento parameter je potrebné zadať.
```

### [adc_scaled]

Analógové škálovanie Duet2 Maestro podľa hodnôt vref a vssa. Definovanie sekcie adc_scaled umožňuje virtuálne adc piny (ako napríklad "my_name:PB0"), ktoré sú automaticky upravované monitorovacími pinmi vref a vssa dosky. Nezabudnite definovať túto konfiguračnú sekciu nad všetkými konfiguračnými sekciami, ktoré používajú jeden z týchto virtuálnych pinov.

Príklad nájdete v súbore [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg).

```
[adc_scaled my_name]
vref_pin:
#       Pin ADC, ktorý sa má použiť na monitorovanie VREF. Tento parameter musí byť
#       poskytnuté.
vssa_pin:
#       Pin ADC na použitie na monitorovanie VSSA. Tento parameter musí byť
#       poskytnuté.
#smooth_time: 2,0
#       Časová hodnota (v sekundách), nad ktorou sú hodnoty vref a vssa
#       meraní bude vyhladených, aby sa znížil vplyv merania
#       hluk. Predvolená hodnota je 2 sekundy.
```

### [replicape]

Podpora repliky – príklad nájdete v [príručke pre beaglebone](Beaglebone.md) a v súbore [generic-replicape.cfg](../config/generic-replicape.cfg).

```
# The "replicape" config section adds "replicape:stepper_x_enable"
# virtual stepper enable pins (for steppers X, Y, Z, E, and H) and
# "replicape:power_x" PWM output pins (for hotbed, e, h, fan0, fan1,
# fan2, and fan3) that may then be used elsewhere in the config file.
[replicape]
revision:
#   The replicape hardware revision. Currently only revision "B3" is
#   supported. This parameter must be provided.
#enable_pin: !gpio0_20
#   The replicape global enable pin. The default is !gpio0_20 (aka
#   P9_41).
host_mcu:
#   The name of the mcu config section that communicates with the
#   Klipper "linux process" mcu instance. This parameter must be
#   provided.
#standstill_power_down: False
#   This parameter controls the CFG6_ENN line on all stepper
#   motors. True sets the enable lines to "open". The default is
#   False.
#stepper_x_microstep_mode:
#stepper_y_microstep_mode:
#stepper_z_microstep_mode:
#stepper_e_microstep_mode:
#stepper_h_microstep_mode:
#   This parameter controls the CFG1 and CFG2 pins of the given
#   stepper motor driver. Available options are: disable, 1, 2,
#   spread2, 4, 16, spread4, spread16, stealth4, and stealth16. The
#   default is disable.
#stepper_x_current:
#stepper_y_current:
#stepper_z_current:
#stepper_e_current:
#stepper_h_current:
#   The configured maximum current (in Amps) of the stepper motor
#   driver. This parameter must be provided if the stepper is not in a
#   disable mode.
#stepper_x_chopper_off_time_high:
#stepper_y_chopper_off_time_high:
#stepper_z_chopper_off_time_high:
#stepper_e_chopper_off_time_high:
#stepper_h_chopper_off_time_high:
#   This parameter controls the CFG0 pin of the stepper motor driver
#   (True sets CFG0 high, False sets it low). The default is False.
#stepper_x_chopper_hysteresis_high:
#stepper_y_chopper_hysteresis_high:
#stepper_z_chopper_hysteresis_high:
#stepper_e_chopper_hysteresis_high:
#stepper_h_chopper_hysteresis_high:
#   This parameter controls the CFG4 pin of the stepper motor driver
#   (True sets CFG4 high, False sets it low). The default is False.
#stepper_x_chopper_blank_time_high:
#stepper_y_chopper_blank_time_high:
#stepper_z_chopper_blank_time_high:
#stepper_e_chopper_blank_time_high:
#stepper_h_chopper_blank_time_high:
#   This parameter controls the CFG5 pin of the stepper motor driver
#   (True sets CFG5 high, False sets it low). The default is True.
```

## Ďalšie vlastné moduly

### [palette2]

Multimateriálová podpora Palette 2 - poskytuje užšiu integráciu podporujúcu zariadenia Palette 2 v prepojenom režime.

This modules also requires `[virtual_sdcard]` and `[pause_resume]` for full functionality.

Ak použijete tento modul, nepoužívajte doplnok Palette 2 pre Octoprint, pretože budú v konflikte a modul 1 sa nepodarí správne inicializovať, čo pravdepodobne spôsobí prerušenie tlače.

Ak používate Octoprint a streamujete gcode cez sériový port namiesto tlače z virtual_sd, potom remo **M1** a **M0** z *Pozastavenie príkazov* v *Nastavenia > Sériové pripojenie > Firmvér a protokol* zabráni potrebe na spustenie tlače na Palete 2 a zrušenie pozastavenia v Octoprint, aby sa mohla začať tlač.

```
[palette2]
seriál:
# Sériový port na pripojenie k palete 2.
#baud: 115200
# Použitá prenosová rýchlosť. Predvolená hodnota je 115200.
#feedrate_splice: 0,8
# Rýchlosť posuvu, ktorá sa má použiť pri spájaní, predvolená hodnota je 0,8
#feedrate_normal: 1,0
# Rýchlosť posuvu, ktorá sa má použiť po spájaní, predvolená hodnota je 1,0
#auto_load_speed: 2
# Rýchlosť posuvu pri automatickom načítavaní, predvolená hodnota je 2 (mm/s)
#auto_cancel_variation: 0.1
# Automatické zrušenie tlače, keď je odchýlka pingu nad touto hranicou
```

### [angle]

Podpora magnetického hall uhlového snímača na čítanie meraní uhlového hriadeľa krokového motora pomocou čipov SPI a1333, as5047d alebo tle5012b. Merania sú dostupné cez [API Server](API_Server.md) a [nástroj na analýzu pohybu](Debugging.md#motion-analysis-and-data-logging). Dostupné príkazy nájdete v [Odkaz na kód G](G-Codes.md#uhol).

```
[uhol my_uhol_sensor]
senzor_typ:
#       Typ magnetického hallového senzorového čipu. Dostupné možnosti sú
#       "a1333", "as5047d" a "tle5012b". Tento parameter musí byť
#       špecifikované.
#sample_period: 0,000400
#       Obdobie dopytu (v sekundách), ktoré sa má použiť počas meraní. The
#       predvolená hodnota je 0,000400 (čo je 2500 vzoriek za sekundu).
#stepper:
#       Názov steppera, ku ktorému je pripojený snímač uhla (napr.
#       "stepper_x"). Nastavenie tejto hodnoty umožňuje kalibráciu uhla
#       nástroj. Na použitie tejto funkcie musí byť balík Python "numpy".
#       nainštalovaný. Predvolené nastavenie je nepovoliť kalibráciu uhla pre
#       snímač uhla.
cs_pin:
#       Pin aktivácie SPI pre senzor. Tento parameter je potrebné zadať.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#       Popis nájdete v časti „spoločné nastavenia SPI“.
#       vyššie uvedené parametre.
```

## Spoločné parametre zbernice

### Bežné nastavenia SPI

The following parameters are generally available for devices using an SPI bus.

```
#spi_speed:
# Rýchlosť SPI (v Hz), ktorá sa má použiť pri komunikácii so zariadením.
# Predvolené nastavenie závisí od typu zariadenia.
#spi_bus:
# Ak mikrokontrolér podporuje viacero zberníc SPI, potom jedna môže
# tu zadajte názov zbernice mikrokontroléra. Predvolená hodnota závisí od
# typ mikrokontroléra.
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Ak chcete použiť "softvérové SPI", zadajte vyššie uvedené parametre. Toto
Režim # nevyžaduje hardvérovú podporu mikrokontroléra (zvyčajne
# môžu sa použiť akékoľvek kolíky na všeobecné použitie). Predvolená hodnota je nepoužívať
# "softvér spi".
```

### Bežné nastavenia I2C

The following parameters are generally available for devices using an I2C bus.

Všimnite si, že súčasná podpora mikrokontroléra Klipper pre I2C vo všeobecnosti nie je tolerantná k šumu linky. Neočakávané chyby na I2C vodičoch môžu spôsobiť, že Klipper vyvolá chybu behu. Podpora Klipper pre obnovu chýb sa líši medzi jednotlivými typmi mikrokontroléra. Vo všeobecnosti sa odporúča používať iba I2C zariadenia, ktoré sú na rovnakej doske s plošnými spojmi ako mikrokontrolér.

Väčšina implementácií mikrokontroléra Klipper podporuje iba `i2c_speed` 100 000 (*štandardný režim*, 100 kbit/s). Mikrokontrolér Klipper "Linux" podporuje rýchlosť 400 000 (*rýchly režim*, 400 kbit/s), ale musí byť [nastavená v operačnom systéme] (RPi_microcontroller.md#optional-enabling-i2c) a `i2c_speed` parameter je inak ignorovaný. Mikrokontrolér Klipper "RP2040" a rodina ATmega AVR podporujú rýchlosť 400 000 prostredníctvom parametra "i2c_speed". Všetky ostatné mikrokontroléry Klipper používajú rýchlosť 100 000 a ignorujú parameter `i2c_speed`.

```
#i2c_address:
# Adresa i2c zariadenia. Toto musí byť uvedené ako desatinné číslo
# číslo (nie v hex). Predvolená hodnota závisí od typu zariadenia.
#i2c_mcu:
# Názov mikroovládača, ku ktorému je čip pripojený.
# Predvolená hodnota je "mcu".
#i2c_bus:
# Ak mikrokontrolér podporuje viacero zberníc I2C, potom jedna môže
# tu zadajte názov zbernice mikrokontroléra. Predvolená hodnota závisí od
# typ mikrokontroléra.
#i2c_software_scl_pin:
#i2c_software_sda_pin:
# Špecifikujte tieto parametre, ak chcete použiť softvér mikrokontroléra
# Podpora I2C „bit-banging“. Dva parametre by mali mať dva kolíky
# na mikroovládači na použitie pre vodiče scl a sda. The
# predvolené je použitie hardvérovej podpory I2C podľa špecifikácie
# parameter i2c_bus.
#i2c_speed:
# Rýchlosť I2C (v Hz), ktorá sa má použiť pri komunikácii so zariadením.
# Implementácia Klipper na väčšine mikrokontrolérov je pevne zakódovaná
# na 100 000 a zmena tejto hodnoty nemá žiadny vplyv. Predvolená hodnota je
# 100 000. Linux, RP2040 a ATmega podporujú 400 000.
```
