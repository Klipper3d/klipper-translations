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
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid_corexy, hybrid_corexz, generic_cartesian,
#   rotary_delta, delta, deltesian, polar, winch, or none.
#   This parameter must be specified.
max_velocity:
#   Maximum velocity (in mm/s) of the toolhead (relative to the
#   print). This parameter must be specified.
max_accel:
#   Maximum acceleration (in mm/s^2) of the toolhead (relative to the
#   print). Although this parameter is described as a "maximum"
#   acceleration, in practice most moves that accelerate or decelerate
#   will do so at the rate specified here. The value specified here
#   may be changed at runtime using the SET_VELOCITY_LIMIT command.
#   This parameter must be specified.
#minimum_cruise_ratio: 0.5
#   Most moves will accelerate to a cruising speed, travel at that
#   cruising speed, and then decelerate. However, some moves that
#   travel a short distance could nominally accelerate and then
#   immediately decelerate. This option reduces the top speed of these
#   moves to ensure there is always a minimum distance traveled at a
#   cruising speed. That is, it enforces a minimum distance traveled
#   at cruising speed relative to the total distance traveled. It is
#   intended to reduce the top speed of short zigzag moves (and thus
#   reduce printer vibration from these moves). For example, a
#   minimum_cruise_ratio of 0.5 would ensure that a standalone 1.5mm
#   move would have a minimum cruising distance of 0.75mm. Specify a
#   ratio of 0.0 to disable this feature (there would be no minimum
#   cruising distance enforced between acceleration and deceleration).
#   The value specified here may be changed at runtime using the
#   SET_VELOCITY_LIMIT command. The default is 0.5.
#square_corner_velocity: 5.0
#   The maximum velocity (in mm/s) that the toolhead may travel a 90
#   degree corner at. A non-zero value can reduce changes in extruder
#   flow rates by enabling instantaneous velocity changes of the
#   toolhead during cornering. This value configures the internal
#   centripetal velocity cornering algorithm; corners with angles
#   larger than 90 degrees will have a higher cornering velocity while
#   corners with angles less than 90 degrees will have a lower
#   cornering velocity. If this is set to zero then the toolhead will
#   decelerate to zero at each corner. The value specified here may be
#   changed at runtime using the SET_VELOCITY_LIMIT command. The
#   default is 5mm/s.
#max_accel_to_decel:
#   This parameter is deprecated and should no longer be used.
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

### Generic Cartesian Kinematics

See [example-generic-cartesian.cfg](../config/example-generic-caretesian.cfg) for an example generic Cartesian kinematics config file.

This printer kinematic class allows a user to define in a pretty flexible manner an arbitrary Cartesian-style kinematics. In principle, the regular cartesian, corexy, hybrid_corexy can be defined this way too. However, more importantly, various otherwise unsupported kinematics such as inverted hybrid_corexy or corexyuv can be defined using this kinematic.

Notably, the definition of a generic Cartesian kinematic deviates significantly from the other kinematic types. It follows the following convention: a user defines a set of carriages with certain range of motion that can move independently from each other (they should move over the Cartesian axes X, Y, and Z, hence the name of the kinematic) and corresponding endstops that allow the firmware to determine the position of carriages during homing, as well as a set of steppers that move those carriages. The `[printer]` section must specify the kinematic and other printer-level settings same as the regular Cartesian kinematic:

```
[printer]
kinematics: generic_cartesian
max_velocity:
max_accel:
#minimum_cruise_ratio:
#square_corner_velocity:
#max_accel_to_decel:
#max_z_velocity:
#max_z_accel:
```

Then a user must define the following three carriages: `[carriage x]`, `[carriage y]`, and `[carriage z]`, e.g.

```
[carriage x]
endstop_pin:
#   Endstop switch detection pin. If this endstop pin is on a
#   different mcu than the stepper motor(s) moving this carriage,
#   then it enables "multi-mcu homing". This parameter must be provided.
#position_min: 0
#   Minimum valid distance (in mm) the user may command the carriage to
#   move to.  The default is 0mm.
position_endstop:
#   Location of the endstop (in mm). This parameter must be provided.
position_max:
#   Maximum valid distance (in mm) the user may command the stepper to
#   move to. This parameter must be provided.
#homing_speed: 5.0
#   Maximum velocity (in mm/s) of the carriage when homing. The default
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
#   Velocity (in mm/s) of the carriage when performing the second home.
#   The default is homing_speed/2.
#homing_positive_dir:
#   If true, homing will cause the carriage to move in a positive
#   direction (away from zero); if false, home towards zero. It is
#   better to use the default than to specify this parameter. The
#   default is true if position_endstop is near position_max and false
#   if near position_min.
```

Afterwards, a user specifies the stepper motors that move these carriages, for instance

```
[stepper my_stepper]
carriages:
#   A string describing the carriages the stepper moves. All defined
#   carriages can be specified here, as well as their linear combinations,
#   e.g. x, x+y, y-0.5*z, x-z, etc. This parameter must be provided.
step_pin:
dir_pin:
enable_pin:
rotation_distance:
microsteps:
#full_steps_per_rotation: 200
#gear_ratio:
#step_pulse_duration:
```

See [stepper](#stepper) section for more information on the regular stepper parameters. The `carriages` parameter defines how the stepper affects the motion of the carriages. For example, `x+y` indicates that the motion of the stepper in the positive direction by the distance `d` moves the carriages `x` and `y` by the same distance `d` in the positive direction, while `x-0.5*y` means the motion of the stepper in the positive direction by the distance `d` moves the carriage `x` by the distance `d` in the positive direction, but the carriage `y` will travel distance `d/2` in the negative direction.

More than a single stepper motor can be defined to drive the same axis or belt. For example, on a CoreXY AWD setups two motors driving the same belt can be defined as

```
[carriage x]
endstop_pin: ...
...

[carriage y]
endstop_pin: ...
...

[stepper a0]
carriages: x-y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...

[stepper a1]
carriages: x-y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...
```

with `a0` and `a1` steppers having their own control pins, but sharing the same `carriages` and corresponding endstops.

There are situations when a user wants to have more than one endstop per axis. Examples of such configurations include Y axis driven by two independent stepper motors with belts attached to both ends of the X beam, with effectively two carriages on Y axis each having an independent endstop, and multi-stepper Z axis with each stepper having its own endstop (not to be confused with the configurations with multiple Z motors but only a single endstop). These configurations can be declared by specifying additional carriage(s) with their endstops:

```
[extra_carriage my_carriage]
primary_carriage:
#   The name of the primary carriage this carriage corresponds to.
#   It also effectively defines the axis the carriage moves over.
#   This parameter must be provided.
endstop_pin:
#   Endstop switch detection pin. This parameter must be provided.
```

and the corresponding stepper motors, for example:

```
[extra_carriage y1]
primary_carriage: y
endstop_pin: ...

[stepper sy1]
carriages: y1
...
```

Notably, an `[extra_carriage]` does not define parameters such as `position_min`, `position_max`, and `position_endstop`, but instead inherits them from the specified `primary_carriage`, thus sharing the same range of motion with the primary carriage.

For the references on how to configure IDEX setups, see the [dual carriage](#dual-carriage) section.

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
[bed_mesh]
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#mesh_radius:
#   Defines the radius of the mesh to probe for round beds. Note that
#   the radius is relative to the coordinate specified by the
#   mesh_origin option. This parameter must be provided for round beds
#   and omitted for rectangular beds.
#mesh_origin:
#   Defines the center X, Y coordinate of the mesh for round beds. This
#   coordinate is relative to the probe's location. It may be useful
#   to adjust the mesh_origin in an effort to maximize the size of the
#   mesh radius. Default is 0, 0. This parameter must be omitted for
#   rectangular beds.
#mesh_min:
#   Defines the minimum X, Y coordinate of the mesh for rectangular
#   beds. This coordinate is relative to the probe's location. This
#   will be the first point probed, nearest to the origin. This
#   parameter must be provided for rectangular beds.
#mesh_max:
#   Defines the maximum X, Y coordinate of the mesh for rectangular
#   beds. Adheres to the same principle as mesh_min, however this will
#   be the furthest point probed from the bed's origin. This parameter
#   must be provided for rectangular beds.
#probe_count: 3, 3
#   For rectangular beds, this is a comma separate pair of integer
#   values X, Y defining the number of points to probe along each
#   axis. A single value is also valid, in which case that value will
#   be applied to both axes. Default is 3, 3.
#round_probe_count: 5
#   For round beds, this integer value defines the maximum number of
#   points to probe along each axis. This value must be an odd number.
#   Default is 5.
#fade_start: 1.0
#   The gcode z position in which to start phasing out z-adjustment
#   when fade is enabled. Default is 1.0.
#fade_end: 0.0
#   The gcode z position in which phasing out completes. When set to a
#   value below fade_start, fade is disabled. It should be noted that
#   fade may add unwanted scaling along the z-axis of a print. If a
#   user wishes to enable fade, a value of 10.0 is recommended.
#   Default is 0.0, which disables fade.
#fade_target:
#   The z position in which fade should converge. When this value is
#   set to a non-zero value it must be within the range of z-values in
#   the mesh. Users that wish to converge to the z homing position
#   should set this to 0. Default is the average z value of the mesh.
#split_delta_z: .025
#   The amount of Z difference (in mm) along a move that will trigger
#   a split. Default is .025.
#move_check_distance: 5.0
#   The distance (in mm) along a move to check for split_delta_z.
#   This is also the minimum length that a move can be split. Default
#   is 5.0.
#mesh_pps: 2, 2
#   A comma separated pair of integers X, Y defining the number of
#   points per segment to interpolate in the mesh along each axis. A
#   "segment" can be defined as the space between each probed point.
#   The user may enter a single value which will be applied to both
#   axes. Default is 2, 2.
#algorithm: lagrange
#   The interpolation algorithm to use. May be either "lagrange" or
#   "bicubic". This option will not affect 3x3 grids, which are forced
#   to use lagrange sampling. Default is lagrange.
#bicubic_tension: .2
#   When using the bicubic algorithm the tension parameter above may
#   be applied to change the amount of slope interpolated. Larger
#   numbers will increase the amount of slope, which results in more
#   curvature in the mesh. Default is .2.
#zero_reference_position:
#   An optional X,Y coordinate that specifies the location on the bed
#   where Z = 0.  When this option is specified the mesh will be offset
#   so that zero Z adjustment occurs at this location.  The default is
#   no zero reference.
#faulty_region_1_min:
#faulty_region_1_max:
#   Optional points that define a faulty region.  See docs/Bed_Mesh.md
#   for details on faulty regions.  Up to 99 faulty regions may be added.
#   By default no faulty regions are set.
#adaptive_margin:
#   An optional margin (in mm) to be added around the bed area used by
#   the defined print objects when generating an adaptive mesh.
#scan_overshoot:
#  The maximum amount of travel (in mm) available outside of the mesh.
#  For rectangular beds this applies to travel on the X axis, and for round beds
#  it applies to the entire radius.  The tool must be able to travel the amount
#  specified outside of the mesh.  This value is used to optimize the travel
#  path when performing a "rapid scan".  The minimum value that may be specified
#  is 1.  The default is no overshoot.
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
#   See docs/Command_Templates.md for G-Code format. The default is to
#   run TURN_OFF_HEATERS.
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

### [icm20948]

Support for icm20948 accelerometers.

```
[icm20948]
#i2c_address:
#   Default is 104 (0x68). If AD0 is high, it would be 0x69 instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [lis2dw]

Support for LIS2DW accelerometers.

```
[lis2dw]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [lis3dh]

Support for LIS3DH accelerometers.

```
[lis3dh]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
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
#   A list of X, Y, Z coordinates of points (one point per line) to test
#   resonances at. At least one point is required. Make sure that all
#   points with some safety margin in XY plane (~a few centimeters)
#   are reachable by the toolhead.
#accel_chip:
#   A name of the accelerometer chip to use for measurements. If
#   adxl345 chip was defined without an explicit name, this parameter
#   can simply reference it as "accel_chip: adxl345", otherwise an
#   explicit name must be supplied as well, e.g. "accel_chip: adxl345
#   my_chip_name". Either this, or the next two parameters must be
#   set.
#accel_chip_x:
#accel_chip_y:
#   Names of the accelerometer chips to use for measurements for each
#   of the axis. Can be useful, for instance, on bed slinger printer,
#   if two separate accelerometers are mounted on the bed (for Y axis)
#   and on the toolhead (for X axis). These parameters have the same
#   format as 'accel_chip' parameter. Only 'accel_chip' or these two
#   parameters must be provided.
#max_smoothing:
#   Maximum input shaper smoothing to allow for each axis during shaper
#   auto-calibration (with 'SHAPER_CALIBRATE' command). By default no
#   maximum smoothing is specified. Refer to Measuring_Resonances guide
#   for more details on using this feature.
#move_speed: 50
#   The speed (in mm/s) to move the toolhead to and between test points
#   during the calibration. The default is 50.
#min_freq: 5
#   Minimum frequency to test for resonances. The default is 5 Hz.
#max_freq: 133.33
#   Maximum frequency to test for resonances. The default is 133.33 Hz.
#accel_per_hz: 60
#   This parameter is used to determine which acceleration to use to
#   test a specific frequency: accel = accel_per_hz * freq. Higher the
#   value, the higher is the energy of the oscillations. Can be set to
#   a lower than the default value if the resonances get too strong on
#   the printer. However, lower values make measurements of
#   high-frequency resonances less precise. The default value is 75
#   (mm/sec).
#hz_per_sec: 1
#   Determines the speed of the test. When testing all frequencies in
#   range [min_freq, max_freq], each second the frequency increases by
#   hz_per_sec. Small values make the test slow, and the large values
#   will decrease the precision of the test. The default value is 1.0
#   (Hz/sec == sec^-2).
#sweeping_accel: 400
#   An acceleration of slow sweeping moves. The default is 400 mm/sec^2.
#sweeping_period: 1.2
#   A period of slow sweeping moves. Setting this parameter to 0
#   disables slow sweeping moves. Avoid setting it to a too small
#   non-zero value in order to not poison the measurements.
#   The default is 1.2 sec which is a good all-round choice.
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

### [probe_eddy_current]

Support for eddy current inductive probes. One may define this section (instead of a probe section) to enable this probe. See the [command reference](G-Codes.md#probe_eddy_current) for further information.

```
[probe_eddy_current my_eddy_probe]
sensor_type: ldc1612
#   The sensor chip used to perform eddy current measurements. This
#   parameter must be provided and must be set to ldc1612.
#frequency:
#   The external crystal frequency (in Hz) of the LDC1612 chip.
#   The default is 12000000.
#intb_pin:
#   MCU gpio pin connected to the ldc1612 sensor's INTB pin (if
#   available). The default is to not use the INTB pin.
#z_offset:
#   The nominal distance (in mm) between the nozzle and bed that a
#   probing attempt should stop at. This parameter must be provided.
#i2c_address:
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   The i2c settings for the sensor chip. See the "common I2C
#   settings" section for a description of the above parameters.
#x_offset:
#y_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   See the "probe" section for information on these parameters.
```

### [axis_twist_compensation]

A tool to compensate for inaccurate probe readings due to twist in X or Y gantry. See the [Axis Twist Compensation Guide](Axis_Twist_Compensation.md) for more detailed information regarding symptoms, configuration and setup.

```
[axis_twist_compensation]
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
calibrate_start_x: 20
#   Defines the minimum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the starting
#   calibration position.
calibrate_end_x: 200
#   Defines the maximum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the ending
#   calibration position.
calibrate_y: 112.5
#   Defines the Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle during the
#   calibration process. This parameter is recommended to
#   be near the center of the bed

# For Y-axis twist compensation, specify the following parameters:
calibrate_start_y: ...
#   Defines the minimum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the starting
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_end_y: ...
#   Defines the maximum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the ending
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_x: ...
#   Defines the X coordinate of the calibration for Y axis twist compensation
#   This should be the X coordinate that positions the nozzle during the
#   calibration process for Y axis twist compensation. This parameter must be
#   provided and is recommended to be near the center of the bed.
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

Support for cartesian, generic_cartesian and hybrid_corexy/z printers with dual carriages on a single axis. The carriage mode can be set via the SET_DUAL_CARRIAGE extended g-code command. For example, "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation. Note that during G28 homing, typically the primary carriage is homed first followed by the carriage defined in the `[dual_carriage]` config section. However, the `[dual_carriage]` carriage will be homed first if both carriages home in a positive direction and the [dual_carriage] carriage has a `position_endstop` greater than the primary carriage, or if both carriages home in a negative direction and the `[dual_carriage]` carriage has a `position_endstop` less than the primary carriage.

Okrem toho je možné použiť príkazy „SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY“ alebo „SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR“ na aktiváciu režimu kopírovania alebo zrkadlenia dvojitého vozíka, pričom v takom prípade bude zodpovedajúcim spôsobom sledovať pohyb vozíka 0 . Tieto príkazy je možné použiť na tlač dvoch dielov súčasne – buď dvoch rovnakých dielov (v režime KOPÍROVANIE) alebo zrkadlených dielov (v režime MIRROR). Všimnite si, že režimy COPY a MIRROR tiež vyžadujú vhodnú konfiguráciu extrudéra na dvojitom vozíku, čo sa zvyčajne dá dosiahnuť pomocou príkazu "SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=<vytlačovací stroj s dvoma vozíkmi>" alebo podobným príkazom.

See [sample-idex.cfg](../config/sample-idex.cfg) for an example configuration with a regular Cartesian kinematic.

```
[dual_carriage]
axis:
#   The axis this extra carriage is on (either x or y). This parameter
#   must be provided.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carriages), the carriages proximity
#   checks will be disabled.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   See the "stepper" section for the definition of the above parameters.
```

For an example of dual carriage configuration with `generic_cartesian` kinematic, see the following configuration [sample](../config/example-generic-caretesian.cfg). Please note that in this case the `[dual_carriage]` configuration deviates from the configuration described above:

```
[dual_carriage my_dc_carriage]
primary_carriage:
#   Defines the matching primary carriage of this dual carriage and
#   the corresponding IDEX axis. Valid choices are x, y, z.
#   This parameter must be provided.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carriages), the carriages proximity
#   checks will be disabled.
endstop_pin:
#position_min:
position_endstop:
position_max:
#homing_speed:
#homing_retract_dist:
#homing_retract_speed:
#second_homing_speed:
#homing_positive_dir:
...
```

Refer to [generic cartesian](#generic-cartesian) section for more information on the regular `carriage` parameters.

Then a user must define one or more stepper motors moving the dual carriage (and other carriages as appropriate), for instance

```
[carriage x]
...

[carriage y]
...

[dual_carriage u]
primary_carriage: x
...

[stepper dc_stepper]
carriages: u-y
...
```

`[dual_carriage]` requires special configuration for the input shaper. In general, it is necessary to run input shaper calibration twice - for the `dual_carriage` and its `primary_carriage` for the axis they share. Then the input shaper can be configured as follows, assuming the example above:

```
[input_shaper]
# Intentionally empty

[delayed_gcode init_shaper]
initial_duration: 0.1
gcode:
  SET_DUAL_CARRIAGE CARRIAGE=u
  SET_INPUT_SHAPER SHAPER_TYPE_X=<dual_carriage_x_shaper> SHAPER_FREQ_X=<dual_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
  SET_DUAL_CARRIAGE CARRIAGE=x
  SET_INPUT_SHAPER SHAPER_TYPE_X=<primary_carriage_x_shaper> SHAPER_FREQ_X=<primary_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
```

Note that `SHAPER_TYPE_Y` and `SHAPER_FREQ_Y` must be the same in both commands in this case, since the same motors drive Y axis when either of the `x` and `u` carriages are active.

It is worth noting that `generic_cartesian` kinematic can support two dual carriages for X and Y axes. For reference, see for instance a [sample](../config/sample-corexyuv.cfg) of CoreXYUV configuration.

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
#microsteps:
#rotation_distance:
#   See the "stepper" section for a description of these parameters.
#velocity:
#   Set the default velocity (in mm/s) for the stepper. This value
#   will be used if a MANUAL_STEPPER command does not specify a SPEED
#   parameter. The default is 5mm/s.
#accel:
#   Set the default acceleration (in mm/s^2) for the stepper. An
#   acceleration of zero will result in no acceleration. This value
#   will be used if a MANUAL_STEPPER command does not specify an ACCEL
#   parameter. The default is zero.
#endstop_pin:
#   Endstop switch detection pin. If specified, then one may perform
#   "homing moves" by adding a STOP_ON_ENDSTOP parameter to
#   MANUAL_STEPPER movement commands.
#position_min:
#position_max:
#   The minimum and maximum position the stepper can be commanded to
#   move to. If specified then one may not command the stepper to move
#   past the given position. Note that these limits do not prevent
#   setting an arbitrary position with the `MANUAL_STEPPER
#   SET_POSITION=x` command. The default is to not enforce a limit.
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

### [temperature_probe]

Reports probe coil temperature. Includes optional thermal drift calibration for eddy current based probes. A `[temperature_probe]` section may be linked to a `[probe_eddy_current]` by using the same postfix for both sections.

```
[temperature_probe my_probe]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Temperature sensor configuration.
#   See the "extruder" section for the definition of the above
#   parameters.
#smooth_time:
#   A time value (in seconds) over which temperature measurements will
#   be smoothed to reduce the impact of measurement noise. The default
#   is 2.0 seconds.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
#speed:
#   The travel speed [mm/s] for xy moves during calibration.  Default
#   is the speed defined by the probe.
#horizontal_move_z:
#   The z distance [mm] from the bed at which xy moves will occur
#   during calibration. Default is 2mm.
#resting_z:
#   The z distance [mm] from the bed at which the tool will rest
#   to heat the probe coil during calibration.  Default is .4mm
#calibration_position:
#   The X, Y, Z position where the tool should be moved when
#   probe drift calibration initializes.  This is the location
#   where the first manual probe will occur.  If omitted, the
#   default behavior is not to move the tool prior to the first
#   manual probe.
#calibration_bed_temp:
#   The maximum safe bed temperature (in C) used to heat the probe
#   during probe drift calibration.  When set, the calibration
#   procedure will turn on the bed after the first sample is
#   taken.  When the calibration procedure is complete the bed
#   temperature will be set to zero.  When omitted the default
#   behavior is not to set the bed temperature.
#calibration_extruder_temp:
#   The extruder temperature (in C) set probe during drift calibration.
#   When this option is supplied the procedure will wait for until the
#   specified temperature is reached before requesting the first manual
#   probe.  When the calibration procedure is complete the extruder
#   temperature will be set to 0.  When omitted the default behavior is
#   not to set the extruder temperature.
#extruder_heating_z: 50.
#   The Z location where extruder heating will occur if the
#   "calibration_extruder_temp" option is set.  Its recommended to heat
#   the extruder some distance from the bed to minimize its impact on
#   the probe coil temperature.  The default is 50.
#max_validation_temp: 60.
#   The maximum temperature used to validate the calibration.  It is
#   recommended to set this to a value between 100 and 120 for enclosed
#   printers.  The default is 60.
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

### BMP180/BMP280/BME280/BMP388/BME680 temperature sensor

BMP180/BMP280/BME280/BMP388/BME680 two wire interface (I2C) environmental sensors. Note that these sensors are not intended for use with extruders and heater beds, but rather for monitoring ambient temperature (C), pressure (hPa), relative humidity and in case of the BME680 gas level. See [sample-macros.cfg](../config/sample-macros.cfg) for a gcode_macro that may be used to report pressure and humidity in addition to temperature.

```
sensor_type: BME280
#i2c_address:
#   Default is 118 (0x76). The BMP180, BMP388 and some BME280 sensors
#   have an address of 119 (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
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

### SHT3X sensor

SHT3X family two wire interface (I2C) environmental sensor. These sensors have a range of -55~125 C, so are usable for e.g. chamber temperature monitoring. They can also function as simple fan/heater controllers.

```
sensor_type: SHT3X
#i2c_address:
#   Default is 68 (0x44).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
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
pin:
#   The pin on which the button is connected. This parameter must be
#   provided.
#analog_range:
#   Two comma separated resistances (in Ohms) specifying the minimum
#   and maximum resistance range for the button. If analog_range is
#   provided then the pin must be an analog capable pin. The default
#   is to use digital gpio for the button.
#analog_pullup_resistor:
#   The pullup resistance (in Ohms) when analog_range is specified.
#   The default is 4700 ohms.
#press_gcode:
#   A list of G-Code commands to execute when the button is pressed.
#   G-Code templates are supported. This parameter must be provided.
#release_gcode:
#   A list of G-Code commands to execute when the button is released.
#   G-Code templates are supported. The default is to not run any
#   commands on a button release.
#debounce_delay:
#   A period of time in seconds to debounce events prior to running the
#   button gcode. If the button is pressed and released during this
#   delay, the entire button press is ignored. Default is 0.
```

### [output_pin]

Výstupné kolíky konfigurovateľné za chodu (je možné definovať ľubovoľný počet sekcií s predponou "output_pin"). Piny nakonfigurované tu budú nastavené ako výstupné piny a je možné ich upraviť za behu pomocou rozšíreného typu "SET_PIN PIN=my_pin VALUE=.1" [príkazy kódu g](G-Codes.md#output_pin).

```
[output_pin my_pin]
pin:
#   The pin to configure as an output. This parameter must be
#   provided.
#pwm: False
#   Set if the output pin should be capable of pulse-width-modulation.
#   If this is true, the value fields should be between 0 and 1; if it
#   is false the value fields should be either 0 or 1. The default is
#   False.
#value:
#   The value to initially set the pin to during MCU configuration.
#   The default is 0 (for low voltage).
#shutdown_value:
#   The value to set the pin to on an MCU shutdown event. The default
#   is 0 (for low voltage).
#cycle_time: 0.100
#   The amount of time (in seconds) per PWM cycle. It is recommended
#   this be 10 milliseconds or greater when using software based PWM.
#   The default is 0.100 seconds for pwm pins.
#hardware_pwm: False
#   Enable this to use hardware PWM instead of software PWM. When
#   using hardware PWM the actual cycle time is constrained by the
#   implementation and may be significantly different than the
#   requested cycle_time. The default is False.
#scale:
#   This parameter can be used to alter how the 'value' and
#   'shutdown_value' parameters are interpreted for pwm pins. If
#   provided, then the 'value' parameter should be between 0.0 and
#   'scale'. This may be useful when configuring a PWM pin that
#   controls a stepper voltage reference. The 'scale' can be set to
#   the equivalent stepper amperage if the PWM were fully enabled, and
#   then the 'value' parameter can be specified using the desired
#   amperage for the stepper. The default is to not scale the 'value'
#   parameter.
#maximum_mcu_duration:
#static_value:
#   These options are deprecated and should no longer be specified.
```

### [pwm_tool]

Pulse width modulation digital output pins capable of high speed updates (one may define any number of sections with an "output_pin" prefix). Pins configured here will be setup as output pins and one may modify them at run-time using "SET_PIN PIN=my_pin VALUE=.1" type extended [g-code commands](G-Codes.md#output_pin).

```
[pwm_tool my_tool]
pin:
#   The pin to configure as an output. This parameter must be provided.
#maximum_mcu_duration:
#   The maximum duration a non-shutdown value may be driven by the MCU
#   without an acknowledge from the host.
#   If host can not keep up with an update, the MCU will shutdown
#   and set all pins to their respective shutdown values.
#   Default: 0 (disabled)
#   Usual values are around 5 seconds.
#value:
#shutdown_value:
#cycle_time: 0.100
#hardware_pwm: False
#scale:
#   See the "output_pin" section for the definition of these parameters.
```

### [pwm_cycle_time]

Run-time configurable output pins with dynamic pwm cycle timing (one may define any number of sections with an "pwm_cycle_time" prefix). Pins configured here will be setup as output pins and one may modify them at run-time using "SET_PIN PIN=my_pin VALUE=.1 CYCLE_TIME=0.100" type extended [g-code commands](G-Codes.md#pwm_cycle_time).

```
[pwm_cycle_time my_pin]
pin:
#value:
#shutdown_value:
#cycle_time: 0.100
#scale:
#   See the "output_pin" section for information on these parameters.
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
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
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
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 4
#driver_PWM_AMPL: 128
#driver_FREEWHEEL: 0
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
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
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
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
#driver_FREEWHEEL: 0
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
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
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
#driver_FREEWHEEL: 0
#driver_SGTHRS: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
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
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
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
#driver_SLOPE_CONTROL: 0
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
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
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
[display]
lcd_type:
#   The type of LCD chip in use. This may be "hd44780", "hd44780_spi",
#   "aip31068_spi", "st7920", "emulated_st7920", "uc1701", "ssd1306", or
#   "sh1106".
#   See the display sections below for information on each type and
#   additional parameters they provide. This parameter must be
#   provided.
#display_group:
#   The name of the display_data group to show on the display. This
#   controls the content of the screen (see the "display_data" section
#   for more information). The default is _default_20x4 for hd44780 or
#   aip31068_spi displays and _default_16x4 for other displays.
#menu_timeout:
#   Timeout for menu. Being inactive this amount of seconds will
#   trigger menu exit or return to root menu when having autorun
#   enabled. The default is 0 seconds (disabled)
#menu_root:
#   Name of the main menu section to show when clicking the encoder
#   on the home screen. The defaults is __main, and this shows the
#   the default menus as defined in klippy/extras/display/menu.cfg
#menu_reverse_navigation:
#   When enabled it will reverse up and down directions for list
#   navigation. The default is False. This parameter is optional.
#encoder_pins:
#   The pins connected to encoder. 2 pins must be provided when using
#   encoder. This parameter must be provided when using menu.
#encoder_steps_per_detent:
#   How many steps the encoder emits per detent ("click"). If the
#   encoder takes two detents to move between entries or moves two
#   entries from one detent, try changing this. Allowed values are 2
#   (half-stepping) or 4 (full-stepping). The default is 4.
#click_pin:
#   The pin connected to 'enter' button or encoder 'click'. This
#   parameter must be provided when using menu. The presence of an
#   'analog_range_click_pin' config parameter turns this parameter
#   from digital to analog.
#back_pin:
#   The pin connected to 'back' button. This parameter is optional,
#   menu can be used without it. The presence of an
#   'analog_range_back_pin' config parameter turns this parameter from
#   digital to analog.
#up_pin:
#   The pin connected to 'up' button. This parameter must be provided
#   when using menu without encoder. The presence of an
#   'analog_range_up_pin' config parameter turns this parameter from
#   digital to analog.
#down_pin:
#   The pin connected to 'down' button. This parameter must be
#   provided when using menu without encoder. The presence of an
#   'analog_range_down_pin' config parameter turns this parameter from
#   digital to analog.
#kill_pin:
#   The pin connected to 'kill' button. This button will call
#   emergency stop. The presence of an 'analog_range_kill_pin' config
#   parameter turns this parameter from digital to analog.
#analog_pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the analog
#   button. The default is 4700 ohms.
#analog_range_click_pin:
#   The resistance range for a 'enter' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_back_pin:
#   The resistance range for a 'back' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_up_pin:
#   The resistance range for a 'up' button. Range minimum and maximum
#   comma-separated values must be provided when using analog button.
#analog_range_down_pin:
#   The resistance range for a 'down' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_kill_pin:
#   The resistance range for a 'kill' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
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

#### aip31068_spi displej

Information on configuring an aip31068_spi display - a very similar to hd44780_spi a 20x04 (20 symbols by 4 lines) display with slightly different internal protocol.

```
[display]
lcd_type: aip31068_spi
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   The pins connected to the shift register controlling the display.
#   The spi_software_miso_pin needs to be set to an unused pin of the
#   printer mainboard as the shift register does not have a MISO pin,
#   but the software spi implementation requires this pin to be
#   configured.
#line_length:
#   Set the number of characters per line for an hd44780 type lcd.
#   Possible values are 20 (default) and 16. The number of lines is
#   fixed to 4.
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
#pause_on_runout: True
#   When set to True, a PAUSE will execute immediately after a runout
#   is detected. Note that if pause_on_runout is False and the
#   runout_gcode is omitted then runout detection is disabled. Default
#   is True.
#runout_gcode:
#   A list of G-Code commands to execute after a filament runout is
#   detected. See docs/Command_Templates.md for G-Code format. If
#   pause_on_runout is set to True this G-Code will run after the
#   PAUSE is complete. The default is not to run any G-Code commands.
#insert_gcode:
#   A list of G-Code commands to execute after a filament insert is
#   detected. See docs/Command_Templates.md for G-Code format. The
#   default is not to run any G-Code commands, which disables insert
#   detection.
#event_delay: 3.0
#   The minimum amount of time in seconds to delay between events.
#   Events triggered during this time period will be silently
#   ignored. The default is 3 seconds.
#pause_delay: 0.5
#   The amount of time to delay, in seconds, between the pause command
#   dispatch and execution of the runout_gcode. It may be useful to
#   increase this delay if OctoPrint exhibits strange pause behavior.
#   Default is 0.5 seconds.
#debounce_delay:
#   A period of time in seconds to debounce events prior to running the
#   switch gcode. The switch must he held in a single state for at least
#   this long to activate. If the switch is toggled on/off during this delay,
#   the event is ignored. Default is 0.
#switch_pin:
#   The pin on which the switch is connected. This parameter must be
#   provided.
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

## Load Cells

### [load_cell]

Load Cell. Uses an ADC sensor attached to a load cell to create a digital scale.

```
[load_cell]
sensor_type:
#   This must be one of the supported sensor types, see below.
#counts_per_gram:
#   The floating point number of sensor counts that indicates 1 gram of force.
#   This value is calculated by the LOAD_CELL_CALIBRATE command.
#reference_tare_counts:
#   The integer tare value, in raw sensor counts, taken when LOAD_CELL_CALIBRATE
#   is run. This is the default tare value when klipper starts up.
#sensor_orientation:
#   Change the sensor's orientation. Can be either 'normal' or 'inverted'.
#   The default is 'normal'. Use 'inverted' if the sensor reports a
#   decreasing force value when placed under load.
```

#### HX711

This is a 24 bit low sample rate chip using "bit-bang" communications. It is suitable for filament scales.

```
[load_cell]
sensor_type: hx711
sclk_pin:
#   The pin connected to the HX711 clock line. This parameter must be provided.
dout_pin:
#   The pin connected to the HX711 data output line. This parameter must be
#   provided.
#gain: A-128
#   Valid values for gain are: A-128, A-64, B-32. The default is A-128.
#   'A' denotes the input channel and the number denotes the gain. Only the 3
#   listed combinations are supported by the chip. Note that changing the gain
#   setting also selects the channel being read.
#sample_rate: 80
#   Valid values for sample_rate are 80 or 10. The default value is 80.
#   This must match the wiring of the chip. The sample rate cannot be changed
#   in software.
```

#### HX717

This is the 4x higher sample rate version of the HX711, suitable for probing.

```
[load_cell]
sensor_type: hx717
sclk_pin:
#   The pin connected to the HX717 clock line. This parameter must be provided.
dout_pin:
#   The pin connected to the HX717 data output line. This parameter must be
#   provided.
#gain: A-128
#   Valid values for gain are A-128, B-64, A-64, B-8.
#   'A' denotes the input channel and the number denotes the gain setting.
#   Only the 4 listed combinations are supported by the chip. Note that
#   changing the gain setting also selects the channel being read.
#sample_rate: 320
#   Valid values for sample_rate are: 10, 20, 80, 320. The default is 320.
#   This must match the wiring of the chip. The sample rate cannot be changed
#   in software.
```

#### ADS1220

The ADS1220 is a 24 bit ADC supporting up to a 2Khz sample rate configurable in software.

```
[load_cell]
sensor_type: ads1220
cs_pin:
#   The pin connected to the ADS1220 chip select line. This parameter must
#   be provided.
#spi_speed: 512000
#   This chip supports 2 speeds: 256000 or 512000. The faster speed is only
#   enabled when one of the Turbo sample rates is used. The correct spi_speed
#   is selected based on the sample rate.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
data_ready_pin:
#   Pin connected to the ADS1220 data ready line. This parameter must be
#   provided.
#gain: 128
#   Valid gain values are 128, 64, 32, 16, 8, 4, 2, 1
#   The default is 128
#pga_bypass: False
#   Disable the internal Programmable Gain Amplifier. If
#   True the PGA will be disabled for gains 1, 2, and 4. The PGA is always
#   enabled for gain settings 8 to 128, regardless of the pga_bypass setting.
#   If AVSS is used as an input pga_bypass is forced to True.
#   The default is False.
#sample_rate: 660
#   This chip supports two ranges of sample rates, Normal and Turbo. In turbo
#   mode the chip's internal clock runs twice as fast and the SPI communication
#   speed is also doubled.
#   Normal sample rates: 20, 45, 90, 175, 330, 600, 1000
#   Turbo sample rates: 40, 90, 180, 350, 660, 1200, 2000
#   The default is 660
#input_mux:
#   Input multiplexer configuration, select a pair of pins to use. The first pin
#   is the positive, AINP, and the second pin is the negative, AINN. Valid
#   values are: 'AIN0_AIN1', 'AIN0_AIN2', 'AIN0_AIN3', 'AIN1_AIN2', 'AIN1_AIN3',
#   'AIN2_AIN3', 'AIN1_AIN0', 'AIN3_AIN2', 'AIN0_AVSS', 'AIN1_AVSS', 'AIN2_AVSS'
#   and 'AIN3_AVSS'. If AVSS is used the PGA is bypassed and the pga_bypass
#   setting will be forced to True.
#   The default is AIN0_AIN1.
#vref:
#   The selected voltage reference. Valid values are: 'internal', 'REF0', 'REF1'
#   and 'analog_supply'. Default is 'internal'.
```

### [load_cell_probe]

Load Cell Probe. This combines the functionality of a [probe] and a [load_cell].

```
[load_cell_probe]
sensor_type:
#   This must be one of the supported bulk ADC sensor types and support
#   load cell endstops on the mcu.
#counts_per_gram:
#reference_tare_counts:
#sensor_orientation:
#   These parameters must be configured before the probe will operate.
#   See the [load_cell] section for further details.
#force_safety_limit: 2000
#   The safe limit for probing force relative to the reference_tare_counts on
#   the load_cell. The default is +/-2Kg.
#trigger_force: 75.0
#   The force that the probe will trigger at. 75g is the default.
#drift_filter_cutoff_frequency: 0.8
#   Enable optional continuous taring while homing & probing to reject drift.
#   The value is a frequency, in Hz, below which drift will be ignored. This
#   option requires the SciPy library. Default: None
#drift_filter_delay: 2
#   The delay, or 'order', of the drift filter. This controls the number of
#   samples required to make a trigger detection. Can be 1 or 2, the default
#   is 2.
#buzz_filter_cutoff_frequency: 100.0
#   The value is a frequency, in Hz, above which high frequency noise in the
#   load cell will be igfiltered outnored. This option requires the SciPy
#   library. Default: None
#buzz_filter_delay: 2
#   The delay, or 'order', of the buzz filter. This controle the number of
#   samples required to make a trigger detection. Can be 1 or 2, the default
#   is 2.
#notch_filter_frequencies: 50, 60
#   1 or 2 frequencies, in Hz, to filter out of the load cell data. This is
#   intended to reject power line noise. This option requires the SciPy
#   library.  Default: None
#notch_filter_quality: 2.0
#   Controls how narrow the range of frequencies are that the notch filter
#   removes. Larger numbers produce a narrower filter. Minimum value is 0.5 and
#   maximum is 3.0. Default: 2.0
#tare_time:
#   The rime in seconds used for taring the load_cell before each probe. The
#   default value is: 4 / 60 = 0.066. This collects samples from 4 cycles of
#   60Hz mains power to cancel power line noise.
#z_offset:
#speed:
#samples:
#sample_retract_dist:
#lift_speed:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#   See the "[probe]" section for a description of the above parameters.
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

### [ads1x1x]

ADS1013, ADS1014, ADS1015, ADS1113, ADS1114 and ADS1115 are I2C based Analog to Digital Converters that can be used for temperature sensors. They provide 4 analog input pins either as single line or as differential input.

Note: Use caution if using this sensor to control heaters. The heater min_temp and max_temp are only verified in the host and only if the host is running and operating normally. (ADC inputs directly connected to the micro-controller verify min_temp and max_temp within the micro-controller and do not require a working connection to the host.)

```
[ads1x1x my_ads1x1x]
chip: ADS1115
#pga: 4.096V
#   Default value is 4.096V. The maximum voltage range used for the input. This
#   scales all values read from the ADC. Options are: 6.144V, 4.096V, 2.048V,
#   1.024V, 0.512V, 0.256V
#adc_voltage: 3.3
#   The suppy voltage for the device. This allows additional software scaling
#   for all values read from the ADC.
i2c_mcu: host
i2c_bus: i2c.1
#address_pin: GND
#   Default value is GND.  There can be up to four addressed devices depending
#   upon wiring of the device. Check the datasheet for details. The i2c_address
#   can be specified directly instead of using the address_pin.
```

The chip provides pins that can be used on other sensors.

```
sensor_type: ...
#   Can be any thermistor or adc_temperature.
sensor_pin: my_ads1x1x:AIN0
#   A combination of the name of the ads1x1x chip and the pin. Possible
#   pin values are AIN0, AIN1, AIN2 and AIN3 for single ended lines and
#   DIFF01, DIFF03, DIFF13 and DIFF23 for differential between their
#   correspoding lines. For example
#   DIFF03 measures the differential between line 0 and 3. Only specific
#   combinations for the differentials are allowed.
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

If you use Octoprint and stream gcode over the serial port instead of printing from virtual_sd, then remove **M1** and **M0** from *Pausing commands* in *Settings > Serial Connection > Firmware & protocol* will prevent the need to start print on the Palette 2 and unpausing in Octoprint for your print to begin.

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

Magnetic hall angle sensor support for reading stepper motor angle shaft measurements using a1333, as5047d, mt6816, mt6826s, or tle5012b SPI chips. The measurements are available via the [API Server](API_Server.md) and [motion analysis tool](Debugging.md#motion-analysis-and-data-logging). See the [G-Code reference](G-Codes.md#angle) for available commands.

```
[angle my_angle_sensor]
sensor_type:
#   The type of the magnetic hall sensor chip. Available choices are
#   "a1333", "as5047d", "mt6816", "mt6826s", and "tle5012b". This parameter must be
#   specified.
#sample_period: 0.000400
#   The query period (in seconds) to use during measurements. The
#   default is 0.000400 (which is 2500 samples per second).
#stepper:
#   The name of the stepper that the angle sensor is attached to (eg,
#   "stepper_x"). Setting this value enables an angle calibration
#   tool. To use this feature, the Python "numpy" package must be
#   installed. The default is to not enable angle calibration for the
#   angle sensor.
cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
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

Most Klipper micro-controller implementations only support an `i2c_speed` of 100000 (*standard mode*, 100kbit/s). The Klipper "Linux" micro-controller supports a 400000 speed (*fast mode*, 400kbit/s), but it must be [set in the operating system](RPi_microcontroller.md#optional-enabling-i2c) and the `i2c_speed` parameter is otherwise ignored. The Klipper "RP2040" micro-controller and ATmega AVR family and some STM32 (F0, G0, G4, L4, F7, H7) support a rate of 400000 via the `i2c_speed` parameter. All other Klipper micro-controllers use a 100000 rate and ignore the `i2c_speed` parameter.

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
