# Konfigurációs hivatkozás

Ez a dokumentum a Klipper konfigurációs fájlban elérhető beállítások referenciája.

Az ebben a dokumentumban található leírások úgy vannak formázva, hogy kivághatóak és beilleszthetőek legyenek egy nyomtató konfigurációs fájljába. A Klipper beállításával és a kezdeti konfigurációs fájl kiválasztásával kapcsolatos információkért lásd a [telepítési dokumentumot](Installation.md).

## Mikrokontroller konfiguráció

### A mikrokontroller pin neveinek formátuma

Számos konfigurációs beállításhoz egy mikrokontroller-tű nevére van szükség. A Klipper a hardveres neveket használja ezekhez a csapokhoz - például `PA4`.

A pin nevek előtt `!` állhat, hogy jelezze ilyenkor fordított polaritást használ (pl. magas helyett alacsony értéken történő triggerelés).

A bemeneti tűk előtt `^` jelezheti, hogy a tűhöz hardveres pull-up ellenállást kell engedélyezni. Ha a mikrokontroller támogatja a pull-down ellenállásokat, akkor egy bemeneti tű előtt `~` állhat.

Megjegyzés: egyes konfigurációs szakaszok további tűket hozhatnak létre. Ahol ez előfordul, ott a tűket definiáló konfigurációs szekciót a konfigurációs fájlban az ezeket a tűket használó szekciók előtt kell felsorolni.

### [mcu]

Az elsődleges mikrokontroller konfigurálása.

```
[mcu]
serial:
# Az MCU-hoz csatlakoztatandó soros port. Ha bizonytalan (vagy a
# változtatásban), lásd a GYIK "Hol van a soros port?" részét.
# Ezt a paramétert soros port használata esetén meg kell adni.
#baud: 250000
# A használandó átviteli sebesség.
# Az alapértelmezett érték 250000.
#canbus_uuid:
# Ha CAN-buszra csatlakoztatott eszközt használunk, akkor ez állítja be az egyedi
# chip azonosítóját, amelyhez csatlakozni kell. Ezt az értéket meg kell adni, a
# CAN busz használata esetén.
#canbus_interface:
# Ha CAN-buszra csatlakoztatott eszközt használunk, akkor ez állítja be a CAN
# hálózati interfészt. 
# Az alapértelmezett érték 'can0'.
#restart_method:
# Ez szabályozza azt a mechanizmust, amelyet a hoszt használjon a
# mikrokontrollert újraindításához.
# A választható lehetőségek: 'arduino', 'cheetah', 'rpi_usb',
# és 'command'. Az 'arduino' módszer (DTR kapcsolása) a következő
# eszközökön gyakori. Arduino kártyák és klónok. A 'gepárd' módszer egy speciális
# módszer, amely néhány Fysetc Cheetah kártyához szükséges. Az 'rpi_usb' módszer
# hasznos a Raspberry Pi lapokon, amelyek mikrovezérlőkkel vannak ellátva.
# USB-n keresztül rövid időre kikapcsolja az összes USB port áramellátását, hogy
# a mikrokontroller újrainduljon. A 'command' módszer a következőket foglalja magában.
# Klipper parancsot küld a mikrokontrollernek, hogy az képes legyen
# újraindítani magát. Az alapértelmezett beállítás az 'arduino' ha a mikrokontroller
# soros porton keresztül kommunikál, egyébként 'command'.
```

### [mcu my_extra_mcu]

További mikrovezérlők (az "mcu" előtaggal tetszőleges számú szekciót lehet definiálni). A további mikrovezérlők további pineket vezetnek be, amelyek fűtőberendezésként, léptetőberendezésként, ventilátorként stb. konfigurálhatók. Például, ha egy "[mcu extra_mcu]" szekciót vezetünk be, akkor az olyan pinek, mint az "extra_mcu:ar9" a konfigurációban máshol is használhatók (ahol "ar9" az adott mcu hardveres pin neve vagy álneve).

```
[mcu my_extra_mcu]
# A konfigurációs paramétereket lásd az "mcu" szakaszban.
```

## Közös kinematikai beállítások

### [printer]

A nyomtató szakasz a nyomtató magas szintű beállításait vezérli.

```
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid_corexy, hybrid_corexz, rotary_delta, delta,
#   polar, winch, or none. This
#   parameter must be specified.
max_velocity:
#   Maximum velocity (in mm/s) of the toolhead (relative to the
#   print). This parameter must be specified.
max_accel:
#   Maximum acceleration (in mm/s^2) of the toolhead (relative to the
#   print). This parameter must be specified.
#max_accel_to_decel:
#   A pseudo acceleration (in mm/s^2) controlling how fast the
#   toolhead may go from acceleration to deceleration. It is used to
#   reduce the top speed of short zig-zag moves (and thus reduce
#   printer vibration from these moves). The default is half of
#   max_accel.
#square_corner_velocity: 5.0
#   The maximum velocity (in mm/s) that the toolhead may travel a 90
#   degree corner at. A non-zero value can reduce changes in extruder
#   flow rates by enabling instantaneous velocity changes of the
#   toolhead during cornering. This value configures the internal
#   centripetal velocity cornering algorithm; corners with angles
#   larger than 90 degrees will have a higher cornering velocity while
#   corners with angles less than 90 degrees will have a lower
#   cornering velocity. If this is set to zero then the toolhead will
#   decelerate to zero at each corner. The default is 5mm/s.
```

### [stepper]

Léptetőmotor meghatározások. A különböző nyomtatótípusok (a [printer] config szakasz "kinematika" opciója által meghatározottak szerint) eltérő neveket igényelnek a léptető számára (pl. `stepper_x` vs `stepper_a`). Az alábbiakban a stepperek általános definíciói következnek.

A `rotation_distance` paraméter kiszámításával kapcsolatos információkért lásd a [forgási távolság dokumentumot](Rotation_Distance.md). A több mikrovezérlővel történő kezdőpont felvétellel kapcsolatos információkért lásd a [Multi-MCU kezdőpont](Multi_MCU_Homing.md) dokumentumot.

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

### Cartesian Kinematika

Lásd [example-cartesian.cfg](../config/example-cartesian.cfg) egy példa cartesian kinematika konfigurációs fájlhoz.

Itt csak a cartesian nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd a [általános kinematikai beállítások](#common-kinematic-settings) pontban.

```
[printer]
kinematics: cartesian
max_z_velocity:
# Ez állítja be a Z irányú mozgás maximális sebességét (mm/mp-ben).
# Ez a beállítás használható a maximális sebesség korlátozására a
# a Z léptetőmotor esetében. Az alapértelmezés szerint a max_velocity a következő értékekre vonatkozik
# max_z_velocity.
max_z_accel:
# Ez állítja be a mozgás maximális gyorsulását (mm/mp^2-ben)
# a Z tengely mentén. Korlátozza a Z léptetőmotor gyorsulását. Az
# alapértelmezett a max_accel használata a max_z_accel esetében.

# A stepper_x szakasz a léptetőmotor vezérlésére szolgál.
# X tengely egy cartesian gépen.
[stepper_x]

# A stepper_y szakasz a léptetőmotor vezérlésére szolgál.
# Y tíngely egy cartesian gépen.
[stepper_y]

# A stepper_z szakasz a léptetőmotor vezérlésére szolgál.
# Z tengely egy cartesian gépen.
[stepper_z]
```

### Lineáris delta kinematika

Lásd az [example-delta.cfg](../config/example-delta.cfg) példát a lineáris delta kinematika konfigurációs fájljához. A kalibrálással kapcsolatos információkért lásd a [delta kalibrációs útmutató](Delta_Calibrate.md) dokumentumot.

Itt csak a lineáris delta nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

```
[printer]
kinematics: delta
max_z_velocity:
#   For delta printers this limits the maximum velocity (in mm/s) of
#   moves with z axis movement. This setting can be used to reduce the
#   maximum speed of up/down moves (which require a higher step rate
#   than other moves on a delta printer). The default is to use
#   max_velocity for max_z_velocity.
#max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. Setting this may be useful if the printer can reach higher
#   acceleration on XY moves than Z moves (eg, when using input shaper).
#   The default is to use max_accel for max_z_accel.
#minimum_z_position: 0
#   The minimum Z position that the user may command the head to move
#   to. The default is 0.
delta_radius:
#   Radius (in mm) of the horizontal circle formed by the three linear
#   axis towers. This parameter may also be calculated as:
#    delta_radius = smooth_rod_offset - effector_offset - carriage_offset
#   This parameter must be provided.
#print_radius:
#   The radius (in mm) of valid toolhead XY coordinates. One may use
#   this setting to customize the range checking of toolhead moves. If
#   a large value is specified here then it may be possible to command
#   the toolhead into a collision with a tower. The default is to use
#   delta_radius for print_radius (which would normally prevent a
#   tower collision).

# The stepper_a section describes the stepper controlling the front
# left tower (at 210 degrees). This section also controls the homing
# parameters (homing_speed, homing_retract_dist) for all towers.
[stepper_a]
position_endstop:
#   Distance (in mm) between the nozzle and the bed when the nozzle is
#   in the center of the build area and the endstop triggers. This
#   parameter must be provided for stepper_a; for stepper_b and
#   stepper_c this parameter defaults to the value specified for
#   stepper_a.
arm_length:
#   Length (in mm) of the diagonal rod that connects this tower to the
#   print head. This parameter must be provided for stepper_a; for
#   stepper_b and stepper_c this parameter defaults to the value
#   specified for stepper_a.
#angle:
#   This option specifies the angle (in degrees) that the tower is
#   at. The default is 210 for stepper_a, 330 for stepper_b, and 90
#   for stepper_c.

# The stepper_b section describes the stepper controlling the front
# right tower (at 330 degrees).
[stepper_b]

# The stepper_c section describes the stepper controlling the rear
# tower (at 90 degrees).
[stepper_c]

# The delta_calibrate section enables a DELTA_CALIBRATE extended
# g-code command that can calibrate the tower endstop positions and
# angles.
[delta_calibrate]
radius:
#   Radius (in mm) of the area that may be probed. This is the radius
#   of nozzle coordinates to be probed; if using an automatic probe
#   with an XY offset then choose a radius small enough so that the
#   probe always fits over the bed. This parameter must be provided.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### CoreXY Kinematika

Lásd [example-corexy.cfg](../config/example-corexy.cfg) egy példa corexy (és h-bot) kinematikai fájlt.

Itt csak a CoreXY nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

```
[printer]
kinematics: corexy
max_z_velocity:
#   Ez állítja be a Z irányú mozgás maximális sebességét (mm/mp-ben).
#   Ez a beállítás használható a Z léptetőmotor maximális sebességkorlátozására.
#   Az alapértelmezés szerint a max_velocity a következő értékekre vonatkozik
#   amely a max_z_velocity.
max_z_accel:
#   Ez állítja be a mozgás maximális gyorsulását (mm/mp^2 -ben)
#   a Z tengely mentén. Korlátozza a Z léptetőmotor gyorsulását.
#   Az alapértelmezett max_accel használata a max_z_accel paranccsal történik.

# A stepper_x szakasz az X tengely, valamint az X+Y mozgást vezérlő
# léptető leírására szolgál.
[stepper_x]

# A stepper_y szakasz az Y tengely, valamint az X+Y mozgást vezérlő
# léptető leírására szolgál.
[stepper_y]

# A stepper_z szakasz a Z tengely, mozgást vezérlő léptető leírására szolgál.
[stepper_z]
```

### CoreXZ Kinematika

Lásd [example-corexz.cfg](../config/example-corexz.cfg) egy példa CoreXZ kinematikai konfigurációs fájlhoz.

Itt csak a CoreXZ nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

```
[printer]
kinematics: corexz
max_z_velocity:
#   Ez állítja be a Z irányú mozgás maximális sebességét (mm/mp-ben).
#   Ez a beállítás használható a Z léptetőmotor maximális sebességkorlátozására.
#   Az alapértelmezés szerint a max_velocity a következő értékekre vonatkozik
#   amely a max_z_velocity.
max_z_accel:
#   Ez állítja be a mozgás maximális gyorsulását (mm/mp^2 -ben)
#   a Z tengely mentén. Korlátozza a Z léptetőmotor gyorsulását.
#   Az alapértelmezett max_accel használata a max_z_accel paranccsal történik.

# A stepper_x szakasz az X tengely, valamint az X+Z mozgást vezérlő
# léptető leírására szolgál.
[stepper_x]

# A stepper_y szakasz az Y tengely léptető vezérlő leírására szolgál.
[stepper_y]

# A stepper_z szakasz a Z tengely leírására szolgál, valamint a
# léptető, amely az X-Z mozgást vezérli.
[stepper_z]
```

### Hybrid-CoreXY Kinematika

Lásd az [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg) példát egy hibrid CoreXY kinematikai konfigurációs fájlhoz.

Ez a kinematika Markforged kinematikaként is ismert.

Itt csak a hibrid CoreXY nyomtatókra jellemző paramétereket írjuk le, a rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

```
[printer]
kinematics: hybrid_corexy
max_z_velocity:
#   Ez beállítja a Z tengely mentén történő mozgás maximális sebességét (mm/mp-ben).
#   Az alapértelmezett érték a max_velocity használata a max_z_velocity értékhez.
max_z_accel:
#   Ez beállítja a Z tengely mentén történő mozgás maximális gyorsulását (mm/mp^2-en).
#   Az alapértelmezett érték a max_accel használata a max_z_accel értékhez.

# A stepper_x szakasz az X tengely, valamint az X-Y mozgást vezérlő léptető leírására szolgál.
[lépcső_x]

# A stepper_y szakasz az Y tengelyt vezérlő léptető leírására szolgál.
[lépés_y]

# A stepper_z szakasz a Z tengelyt vezérlő léptető leírására szolgál.
[stepper_z]
```

### Hybrid-CoreXZ Kinematika

Lásd az [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg) példát egy hibrid CoreXZ kinematikai konfigurációs fájlhoz.

Ez a kinematika Markforged kinematikaként is ismert.

Itt csak a hibrid CoreXY nyomtatókra jellemző paramétereket írjuk le, a rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

```
[printer]
kinematics: hybrid_corexz
max_z_velocity:
#   Ez beállítja a Z tengely mentén történő mozgás maximális sebességét (mm/mp-ben).
#   Az alapértelmezett érték a max_velocity használata a max_z_velocity értékhez.
max_z_accel:
#   Ez beállítja a Z tengely mentén történő mozgás maximális gyorsulását (mm/mp^2-en).
#   Az alapértelmezett érték a max_accel használata a max_z_accel értékhez.

# A stepper_x szakasz az X tengely, valamint az X-Z mozgást vezérlő léptető leírására szolgál.
[lépcső_x]

# A stepper_y szakasz az Y tengelyt vezérlő léptető leírására szolgál.
[lépés_y]

# A stepper_z szakasz a Z tengelyt vezérlő léptető leírására szolgál.
[stepper_z]
```

### Polar Kinematika

Lásd az [example-polar.cfg](../config/example-polar.cfg) egy példa a Polar kinematika konfigurációs fájljához.

Itt csak a Polar nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

A POLÁRIS KINEMATIKA MÉG FOLYAMATBAN VAN. A 0, 0 pozíció körüli mozgásokról ismert, hogy nem működnek megfelelően.

```
[printer]
kinematics: polar
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. This setting can be used to restrict the maximum speed of
#   the z stepper motor. The default is to use max_velocity for
#   max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. It limits the acceleration of the z stepper motor. The
#   default is to use max_accel for max_z_accel.

# The stepper_bed section is used to describe the stepper controlling
# the bed.
[stepper_bed]
gear_ratio:
#   A gear_ratio must be specified and rotation_distance may not be
#   specified. For example, if the bed has an 80 toothed pulley driven
#   by a stepper with a 16 toothed pulley then one would specify a
#   gear ratio of "80:16". This parameter must be provided.

# The stepper_arm section is used to describe the stepper controlling
# the carriage on the arm.
[stepper_arm]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
[stepper_z]
```

### Forgó delta Kinematika

Lásd az [example-rotary-delta.cfg](../config/example-rotary-delta.cfg) egy példa a forgó delta kinematika konfigurációs fájljához.

Itt csak a forgó delta nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

A FORGÓ DELTA KINEMATIKA MÉG FOLYAMATBAN VAN. A célkövető mozgások időzítettek lehetnek, és néhány határellenőrzés nincs implementálva.

```
[printer]
kinematics: rotary_delta
max_z_velocity:
#   Delta nyomtatóknál ez korlátozza a Z tengely mozgásának maximális
#   sebességét (mm/mp-ben). Ezzel a beállítással csökkenthető a fel/le
#   mozgások maximális sebessége (amely nagyobb lépésszámot igényel,
#   mint a deltanyomtatók egyéb mozgásai). Az alapértelmezett érték a
#   max_velocity használata a max_z_velocity értékhez.
#minimum_z_position: 0
#   A minimális Z pozíció, amelybe a felhasználó utasíthatja a fejet, hogy
#   mozduljon el. Az alapértelmezett érték 0.
shoulder_radius:
#   A három gömbcsukló által alkotott vízszintes kör sugara (mm-ben),
#   mínusz az effektor csuklók által alkotott kör sugara. Ez a paraméter a
#   következőképpen is kiszámítható:
#   shoulder_radius = (delta_f - delta_e) / sqrt(12)
#   Ezt a paramétert meg kell adni.
shoulder_height:
#   A gömbcsuklók távolsága (mm-ben) az ágytól, mínusz az effektor
#   nyomtatófej magassága. Ezt a paramétert meg kell adni.

# A stepper_a szakasz a jobb hátsó kart vezérlő léptetőt írja le (30 fokban).
# Ez a szakasz szabályozza az összes karhoz tartozó kezdőpont felvételi
# paramétereket (homing_speed, homing_retract_dist).
[stepper_a]
gear_ratio:
#   Meg kell adni a gear_ratio értéket, és nem lehet megadni a rotation_distance
#   értéket. Például, ha a karban van egy 80 fogú kerék, amelyet egy 16 fogú
#   kerék hajt meg, és amely egy 60 fogú szíjtárcsával van összekötve, amelyet
#   egy 16 fogú fogaskerékkel ellátott léptetőmotor hajt meg, akkor a "80-as"
#   áttételi arányt kell megadni: 16, 60:16". Ezt a paramétert meg kell adni.
position_endstop:
#   Távolság (mm-ben) a fúvóka és az ágy között, ha a fúvóka az építési terület
#   közepén van, és a végálláskapcsoló kiold. Ezt a paramétert meg kell adni a
#   stepper_a; a stepper_b és stepper_c esetén ez a paraméter alapértelmezett
#   értéke a stepper_a paraméterben megadott érték.
upper_arm_length:
#   A „felső gömbcsuklót” az „alsó gömbcsuklóval” összekötő kar hossza (mm-ben).
#   Ezt a paramétert meg kell adni a stepper_a; a stepper_b és stepper_c esetén ez
#   a paraméter alapértelmezett értéke a stepper_a paraméterben megadott érték.
lower_arm_length:
#   A „felső gömbcsukló” az „effektív csuklóval” összekötő kar hossza (mm-ben).
#   Ezt a paramétert meg kell adni a stepper_a; a stepper_b és stepper_c esetén
#   ez a paraméter alapértelmezett értéke a stepper_a paraméterben megadott érték.
#angle:
#   Ez az opció azt a szöget adja meg (fokban), amelyben a kar áll.
#   Az alapértelmezett érték 30 a stepper_a, 150 a stepper_b és 270 a stepper_c.

# A stepper_b szakasz a bal hátsó kart vezérlő léptetőt írja le (150 fokban).
[stepper_b]

# A stepper_c szakasz az első kart vezérlő léptetőt írja le (270 fokban).
[stepper_c]

# A delta_calibrate szakasz lehetővé teszi a DELTA_CALIBRATE kiterjesztett G-Kód
# parancsot, amely képes kalibrálni a felső gömbcsuklók végállás pozícióit.
[delta_calibrate]
radius:
#   A vizsgálható terület sugara (mm-ben). Ez a vizsgálandó fúvókakoordináták
#   sugara; Ha X-Y eltolású automata szondát használ, akkor válasszon elég kicsi
#   sugarat, hogy a szonda mindig az ágy fölé férjen. Ezt a paramétert meg kell adni.
#speed: 50
#   A nem tapintó mozgás sebessége (mm/mp-ben) a kalibrálás során.
#   Az alapértelmezett 50.
#horizontal_move_z: 5
#   Az a magasság (mm-ben), ameddig a fejet utasítani kell, hogy mozduljon el
#   közvetlenül a mérőművelet megkezdése előtt. Az alapértelmezett érték 5.
```

### Kábelcsörlős Kinematika

Lásd az [example-winch.cfg](../config/example-winch.cfg) egy példát a kábelcsörlős kinematika konfigurációs fájljához.

Itt csak a kábelcsörlős nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

A KÁBELCSÖRLŐ TÁMOGATÁSA KÍSÉRLETI JELLEGŰ. A helymeghatározás nem valósul meg a kábelcsörlő kinematikáján. A nyomtató kezdőpont felvételéhez manuálisan küldjön mozgatási parancsokat, amíg a nyomtatófej a 0, 0, 0, 0 ponton van, majd adjon ki egy `G28` parancsot.

```
[printer]
kinematics: winch

# The stepper_a section describes the stepper connected to the first
# cable winch. A minimum of 3 and a maximum of 26 cable winches may be
# defined (stepper_a to stepper_z) though it is common to define 4.
[stepper_a]
rotation_distance:
#   The rotation_distance is the nominal distance (in mm) the toolhead
#   moves towards the cable winch for each full rotation of the
#   stepper motor. This parameter must be provided.
anchor_x:
anchor_y:
anchor_z:
#   The X, Y, and Z position of the cable winch in cartesian space.
#   These parameters must be provided.
```

### Nincs Kinematika

Lehetőség van egy speciális "none" kinematika definiálására a Klipper kinematikai támogatásának kikapcsolásához. Ez hasznos lehet olyan eszközök vezérléséhez, amelyek nem tipikus 3D-nyomtatók, vagy hibakeresési célok.

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
# A max_velocity és max_accel paramétereket meg kell határozni.
# Az értékeket nem használjuk a "none" kinematika esetén.
```

## Közös extruder és fűtött ágy támogatás

### [extruder]

Az extruder szakasz a fúvóka fűtőberendezés paramétereinek leírására szolgál, az extruder vezérlését végző léptetővel együtt. További információkért lásd a [parancs hivatkozás](G-Codes.md#extruder) című részt. A nyomásszabályozás hangolásával kapcsolatos információkért lásd a [nyomásszabályozási útmutatót](Pressure_Advance.md).

```
[extruder]
step_pin:
dir_pin:
enable_pin:
microsteps:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#   See the "stepper" section for a description of the above
#   parameters. If none of the above parameters are specified then no
#   stepper will be associated with the nozzle hotend (though a
#   SYNC_EXTRUDER_MOTION command may associate one at run-time).
nozzle_diameter:
#   Diameter of the nozzle orifice (in mm). This parameter must be
#   provided.
filament_diameter:
#   The nominal diameter of the raw filament (in mm) as it enters the
#   extruder. This parameter must be provided.
#max_extrude_cross_section:
#   Maximum area (in mm^2) of an extrusion cross section (eg,
#   extrusion width multiplied by layer height). This setting prevents
#   excessive amounts of extrusion during relatively small XY moves.
#   If a move requests an extrusion rate that would exceed this value
#   it will cause an error to be returned. The default is: 4.0 *
#   nozzle_diameter^2
#instantaneous_corner_velocity: 1.000
#   The maximum instantaneous velocity change (in mm/s) of the
#   extruder during the junction of two moves. The default is 1mm/s.
#max_extrude_only_distance: 50.0
#   Maximum length (in mm of raw filament) that a retraction or
#   extrude-only move may have. If a retraction or extrude-only move
#   requests a distance greater than this value it will cause an error
#   to be returned. The default is 50mm.
#max_extrude_only_velocity:
#max_extrude_only_accel:
#   Maximum velocity (in mm/s) and acceleration (in mm/s^2) of the
#   extruder motor for retractions and extrude-only moves. These
#   settings do not have any impact on normal printing moves. If not
#   specified then they are calculated to match the limit an XY
#   printing move with a cross section of 4.0*nozzle_diameter^2 would
#   have.
#pressure_advance: 0.0
#   The amount of raw filament to push into the extruder during
#   extruder acceleration. An equal amount of filament is retracted
#   during deceleration. It is measured in millimeters per
#   millimeter/second. The default is 0, which disables pressure
#   advance.
#pressure_advance_smooth_time: 0.040
#   A time range (in seconds) to use when calculating the average
#   extruder velocity for pressure advance. A larger value results in
#   smoother extruder movements. This parameter may not exceed 200ms.
#   This setting only applies if pressure_advance is non-zero. The
#   default is 0.040 (40 milliseconds).
#
# The remaining variables describe the extruder heater.
heater_pin:
#   PWM output pin controlling the heater. This parameter must be
#   provided.
#max_power: 1.0
#   The maximum power (expressed as a value from 0.0 to 1.0) that the
#   heater_pin may be set to. The value 1.0 allows the pin to be set
#   fully enabled for extended periods, while a value of 0.5 would
#   allow the pin to be enabled for no more than half the time. This
#   setting may be used to limit the total power output (over extended
#   periods) to the heater. The default is 1.0.
sensor_type:
#   Type of sensor - common thermistors are "EPCOS 100K B57560G104F",
#   "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Generic
#   3950","Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", and "TDK NTCG104LH104JT1". See the
#   "Temperature sensors" section for other sensors. This parameter
#   must be provided.
sensor_pin:
#   Analog input pin connected to the sensor. This parameter must be
#   provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the thermistor.
#   This parameter is only valid when the sensor is a thermistor. The
#   default is 4700 ohms.
#smooth_time: 1.0
#   A time value (in seconds) over which temperature measurements will
#   be smoothed to reduce the impact of measurement noise. The default
#   is 1 seconds.
control:
#   Control algorithm (either pid or watermark). This parameter must
#   be provided.
pid_Kp:
pid_Ki:
pid_Kd:
#   The proportional (pid_Kp), integral (pid_Ki), and derivative
#   (pid_Kd) settings for the PID feedback control system. Klipper
#   evaluates the PID settings with the following general formula:
#     heater_pwm = (Kp*error + Ki*integral(error) - Kd*derivative(error)) / 255
#   Where "error" is "requested_temperature - measured_temperature"
#   and "heater_pwm" is the requested heating rate with 0.0 being full
#   off and 1.0 being full on. Consider using the PID_CALIBRATE
#   command to obtain these parameters. The pid_Kp, pid_Ki, and pid_Kd
#   parameters must be provided for PID heaters.
#max_delta: 2.0
#   On 'watermark' controlled heaters this is the number of degrees in
#   Celsius above the target temperature before disabling the heater
#   as well as the number of degrees below the target before
#   re-enabling the heater. The default is 2 degrees Celsius.
#pwm_cycle_time: 0.100
#   Time in seconds for each software PWM cycle of the heater. It is
#   not recommended to set this unless there is an electrical
#   requirement to switch the heater faster than 10 times a second.
#   The default is 0.100 seconds.
#min_extrude_temp: 170
#   The minimum temperature (in Celsius) at which extruder move
#   commands may be issued. The default is 170 Celsius.
min_temp:
max_temp:
#   The maximum range of valid temperatures (in Celsius) that the
#   heater must remain within. This controls a safety feature
#   implemented in the micro-controller code - should the measured
#   temperature ever fall outside this range then the micro-controller
#   will go into a shutdown state. This check can help detect some
#   heater and sensor hardware failures. Set this range just wide
#   enough so that reasonable temperatures do not result in an error.
#   These parameters must be provided.
```

### [heater_bed]

A heater_bed szakasz egy fűtött ágyat ír le. Ugyanazokat a fűtési beállításokat használja, amelyeket az "extruder" szakaszban leírtunk.

```
[heater_bed]
heater_pin:
sensor_type:
sensor_pin:
control:
min_temp:
max_temp:
# A fenti paraméterek leírását lásd az "extruder" szakaszban.
```

## Ágyszint támogatás

### [bed_mesh]

Ágy Háló Kiegyenlítés. Definiálhatunk egy bed_mesh konfigurációs szakaszt, hogy engedélyezzük a Z tengelyt eltoló mozgatási transzformációkat a mért pontokból generált háló alapján. Ha szondát használunk a Z-tengely alaphelyzetbe állítására, ajánlott a printer.cfg fájlban egy safe_z_home szakaszt definiálni a nyomtatási terület közepére történő alaphelyzetbe állításhoz.

További információkért lásd az [ágyháló útmutató](Bed_Mesh.md) és a [parancsreferencia](G-Codes.md#bed_mesh) dokumentumokat.

Vizuális példák:

```
 téglalap alakú ágy, probe_count = 3, 3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 kerek ágy, round_probe_count = 5, bed_radius = r:
                 x (0, r) end
               /
             x---x---x
                       \
 (-r, 0) x---x---x---x---x (r, 0)
           \
             x---x---x
                   /
                 x  (0, -r) start
```

```
[bed_mesh]
#speed: 50
# A kalibrálás során a nem próbamozgások sebessége (mm/s-ban).
# Az alapértelmezett érték 50.
#horizontal_move_z: 5
# Az a magasság (mm-ben), amelyre a fejnek parancsot kell adni a mozgásra közvetlenül
# a szondaművelet megkezdése előtt. Az alapértelmezett érték 5.
#mesh_radius:
# Meghatározza a mérni kívánt háló sugarát a kerek ágyak esetében. Vegye figyelembe, hogy
# a sugár relatív a koordinátához képest, amelyet a
# mesh_origin opció által meghatározott koordináta ad. Ezt a paramétert kerek ágyak esetében meg kell adni.
# De elhagyható a téglalap alakú ágyak esetében.
#mesh_origin:
# Meghatározza a háló középpontjának X, Y koordinátáját kerek ágyak esetén. Ez a
# koordináta a szonda helyéhez képest relatív. Hasznos lehet a mesh_origin beállítása,
# hogy maximalizáljuk a háló méretét. Az alapértelmezett érték 0, 0.
# Ezt a paramétert el kell hagyni téglalap alakú ágyak esetén.
#mesh_min:
# Meghatározza a háló minimális X, Y koordinátáját téglalap alakú ágyak esetén.
# Ez a koordináta a szonda helyéhez képest relatív. Ez a lesz az első szondázott pont, amely a legközelebb van az origóhoz. Ezt a paramétert téglalap alakú ágyak esetén meg kell adni.
#mesh_max:
# Meghatározza a háló maximális X, Y koordinátáját téglalap alakú ágyak esetén.
# Ugyanazon az elven működik, mint a mesh_min, azonban ez a paraméter
# a legtávolabbi pont lesz, amelyet az ágy origójától vizsgálunk. Ezt a paramétert
# téglalap alakú ágyak esetén meg kell adni.
#probe_count: 3, 3
# Téglalap alakú ágyak esetén ez egy vesszővel elválasztott egész számpár.
# X, Y értékek, amelyek meghatározzák a mérni kívánt pontok számát az egyes tengelyek mentén.
# Egyetlen érték is érvényes, ebben az esetben ez az érték mindkét tengelyre vonatkozik.
# Az alapértelmezett érték 3, 3.
#round_probe_count: 5
# A kerek ágyak esetében ez az egész érték határozza meg a maximális számú
# pontok számát, amelyeket minden tengely mentén meg kell vizsgálni. Ennek az értéknek páratlan számnak kell lennie.
# Az alapértelmezett érték 5.
#fade_start: 1.0
# A G-kód Z pozíciója, ahol a Z-korrekció fokozatos megszüntetése elkezdődik
# amikor a fade engedélyezve van. Az alapértelmezett érték 1.0.
#fade_end: 0.0
# A G-kód Z pozíciója, amelyben a fading out befejeződik. Ha be van állítva egy
# fade_start alatti értékre a fade ki van kapcsolva. Meg kell jegyezni, hogy
# a fade nem kívánt skálázást adhat a nyomtatás Z tengelye mentén. Ha egy
# felhasználó engedélyezni kívánja a fade-et, a 10.0 érték ajánlott.
# Az alapértelmezett érték 0.0, amely kikapcsolja a fade-et.
#fade_target:
# A Z pozíció, amelyben a fade-nek konvergálnia kell. Ha ez az érték
# nem nulla értékre van beállítva, akkor annak a Z-értékek tartományán belül kell lennie a
# a hálóban. Azok a felhasználók, akik a Z kezdőponthoz kívánnak konvergálni,
# 0-ra kell állítaniuk. Az alapértelmezett érték a háló átlagos Z értéke.
#split_delta_z: .025
# A Z különbség mértéke (mm-ben) a mozgás mentén, amely kivált egy osztást.
# Az alapértelmezett érték .025.
#move_check_distance: 5.0
# A távolság (mm-ben) a mozgás mentén, amelynél a split_delta_z-t ellenőrizni kell.
# Ez egyben a minimális hossz, ameddig egy mozgást fel lehet osztani. Alapértelmezett
# 5.0.
#mesh_pps: 2, 2
# Egy vesszővel elválasztott egész számpár X, Y, amely meghatározza a következő pontok
# számát szegmensenként, amelyeket interpolálni kell a hálóban az egyes tengelyek mentén.
# A "szegmens" úgy definiálható, mint az egyes mért pontok közötti tér.
# A felhasználó egyetlen értéket adhat meg, amely mindkét tengelyre vonatkozik.
# Az alapértelmezett érték 2, 2.
#algoritmus: lagrange
# Az alkalmazandó interpolációs algoritmus. Lehet akár "lagrange" vagy
# "bicubic". Ez az opció nem érinti a 3x3-as rácsokat, amelyek kényszerített
# lagrange mintavételt használnak. Az alapértelmezett lagrange.
#bicubic_tension: .2
# A bikubik algoritmus használatakor a fenti feszültség paraméter alkalmazható az
# interpolált meredekség mértékének megváltoztatására. Nagyobb számok növelik
# a meredekség mértékét, ami nagyobb görbületet eredményez a hálóban. 
# Az alapértelmezett érték .2.
#relative_reference_index:
# Egy pontindex a hálóban, amelyre minden Z értéket hivatkozni kell. Az engedélyezése
# ennek a paraméternek a bekapcsolása a vizsgált Z pozícióhoz viszonyított hálót eredményez
# a megadott indexhez képest.
#faulty_region_1_min:
#faulty_region_1_max:
# A hibás régiót meghatározó opcionális pontok. Lásd docs/Bed_Mesh.md
# A hibás régiókkal kapcsolatos részletekért. Legfeljebb 99 hibás régió adható hozzá.
# Alapértelmezés szerint nincsenek hibás régiók beállítva.
```

### [bed_tilt]

Ágydőlés kompenzáció. Definiálhatunk egy bed_tilt config szekciót, hogy lehetővé tegyük a ferde ágyat figyelembe vevő mozgástranszformációkat. Vegye figyelembe, hogy a bed_mesh és a bed_tilt nem kompatibilisek. Mindkettő nem definiálható.

További információkért lásd a [parancsreferencia](G-Codes.md#bed_tilt) dokumentumot.

```
[bed_tilt]
#x_adjust: 0
#   The amount to add to each move's Z height for each mm on the X
#   axis. The default is 0.
#y_adjust: 0
#   The amount to add to each move's Z height for each mm on the Y
#   axis. The default is 0.
#z_adjust: 0
#   The amount to add to the Z height when the nozzle is nominally at
#   0, 0. The default is 0.
# The remaining parameters control a BED_TILT_CALIBRATE extended
# g-code command that may be used to calibrate appropriate x and y
# adjustment parameters.
#points:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) that should be probed during a BED_TILT_CALIBRATE
#   command. Specify coordinates of the nozzle and be sure the probe
#   is above the bed at the given nozzle coordinates. The default is
#   to not enable the command.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### [bed_screws]

Szerszám az ágy szintbeállító csavarok beállításához. Meghatározható egy [bed_screws] config szakasz a BED_SCREWS_ADJUST G-Kód parancs engedélyezéséhez.

További információkért lásd a [szintezési útmutató](Manual_Level.md#adjusting-bed-leveling-screws) és a [parancs hivatkozás](G-Codes.md#bed_screws) dokumentumot.

```
[bed_screws]
#screw1:
# Az első ágykiegyenlítő csavar X, Y koordinátája. Ez egy
# olyan pozíció, ahová a fúvókát kell irányítani, mely közvetlenül az ágy felett van
# (vagy a lehető legközelebb, de még mindig az ágy felett).
# Ezt a paramétert meg kell adni.
#screw1_name:
# Az adott csavar tetszőleges neve. Ez a név jelenik meg, amikor a segédszkript fut.
# Az alapértelmezés szerint a név alapja a csavar XY helye.
#screw1_fine_adjust:
# Egy X, Y koordináta, amelyre a fúvókát irányítani
# kell, hogy finomítani lehessen az ágy szintező csavart.
# Az alapértelmezés szerint a finombeállítás nem történik meg az ágy csavarján.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
# További ágyszintállító csavarok. Legalább három csavarnak kell lennie.
#horizontal_move_z: 5
# Az a magasság (mm-ben), ahová a fejnek parancsot kell adni a mozgásra amikor az egyik
# csavar helyéről a másikra mozog.
# Az alapértelmezett érték 5.
#probe_height: 0
# A szonda magassága (mm-ben) a hőfokszabályozás után.
# Az ágy és a fúvóka hőtágulása után. Az alapértelmezett érték nulla.
#speed: 50
# A kalibrálás során a nem mérési mozgások sebessége (mm/s-ban).
# Az alapértelmezett érték 50.
#probe_speed: 5
# A sebesség (mm/s-ban) a horizontális_move_z pozícióból történő mozgáskor.
# A probe_height pozíciója. Az alapértelmezett érték 5.
```

### [screws_tilt_adjust]

Eszköz az ágycsavarok dőlésszögének beállításához Z-szondával. Meghatározható egy screws_tilt_adjust konfigurációs szakasz a SCREWS_TILT_CALCULATE G-Kód parancsal.

További információkért lásd a [szintezési útmutató](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) és a [parancs hivatkozás](G-Codes.md#screws_tilt_adjust) dokumentumot.

```
[screws_tilt_adjust]
#screw1:
#   The (X, Y) coordinate of the first bed leveling screw. This is a
#   position to command the nozzle to that is directly above the bed
#   screw (or as close as possible while still being above the bed).
#   This is the base screw used in calculations. This parameter must
#   be provided.
#screw1_name:
#   An arbitrary name for the given screw. This name is displayed when
#   the helper script runs. The default is to use a name based upon
#   the screw XY location.
#screw2:
#screw2_name:
#...
#   Additional bed leveling screws. At least two screws must be
#   defined.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#screw_thread: CW-M3
#   The type of screw used for bed level, M3, M4 or M5 and the
#   direction of the knob used to level the bed, clockwise decrease
#   counter-clockwise decrease.
#   Accepted values: CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
#   Default value is CW-M3, most printers use an M3 screw and
#   turning the knob clockwise decrease distance.
```

### [z_tilt]

Többszörös Z léptető dőlésszög beállítása. Ez a funkció lehetővé teszi több Z léptető független beállítását (lásd a "stepper_z1" szakaszt) a dőlés beállításához. Ha ez a szakasz jelen van, akkor elérhetővé válik a Z_TILT_ADJUST kiterjesztett [G-Kód parancs](G-Codes.md#z_tilt).

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

Mozgó állvány szintezése 4 egymástól függetlenül vezérelt Z-motorral. Korrigálja a hiperbolikus parabola hatását (krumplichip) a mozgó portálon, amely rugalmasabb. FIGYELMEZTETÉS: Mozgó ágyon történő használata nemkívánatos eredményekhez vezethet. Ha ez a szakasz jelen van, akkor elérhetővé válik a QUAD_GANTRY_LEVEL kiterjesztett G-Kód parancs. Ez a rutin a következő Z motor konfigurációt feltételezi:

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

Ahol X az ágy 0, 0 pontja

```
[quad_gantry_level]
#gantry_corners:
#   A newline separated list of X, Y coordinates describing the two
#   opposing corners of the gantry. The first entry corresponds to Z,
#   the second to Z2. This parameter must be provided.
#points:
#   A newline separated list of four X, Y points that should be probed
#   during a QUAD_GANTRY_LEVEL command. Order of the locations is
#   important, and should correspond to Z, Z1, Z2, and Z3 location in
#   order. This parameter must be provided. For maximum accuracy,
#   ensure your probe offsets are configured.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#max_adjust: 4
#   Safety limit if an adjustment greater than this value is requested
#   quad_gantry_level will abort.
#retries: 0
#   Number of times to retry if the probed points aren't within
#   tolerance.
#retry_tolerance: 0
#   If retries are enabled then retry if largest and smallest probed
#   points differ more than retry_tolerance.
```

### [skew_correction]

Nyomtató ferdeségkorrekció. Lehetőség van a nyomtató ferdeségének szoftveres korrekciójára 3 síkban: XY, XZ, YZ. Ez úgy történik, hogy egy kalibrációs modellt nyomtatunk egy sík mentén, és három hosszúságot mérünk. A ferdeségkorrekció jellegéből adódóan ezeket a hosszokat G-Kóddal kell beállítani. Lásd a [Ferdeség korrekció](Skew_Correction.md) és a [Parancs hivatkozás](G-Codes.md#skew_correction) című fejezetekben található részleteket.

```
[skew_correction]
```

## Testreszabott kezdőpont felvétel

### [safe_z_home]

Biztonságos Z kezdőpont felvétel. Ezzel a mechanizmussal a Z tengelyt egy adott X, Y koordinátára lehet állítani. Ez akkor hasznos, ha például a nyomtatófejnek az ágy közepére kell mozognia, mielőtt a Z-tengelyt kezdőpontpba irányítaná.

```
[safe_z_home]
home_xy_position:
#   A X, Y coordinate (e.g. 100, 100) where the Z homing should be
#   performed. This parameter must be provided.
#speed: 50.0
#   Speed at which the toolhead is moved to the safe Z home
#   coordinate. The default is 50 mm/s
#z_hop:
#   Distance (in mm) to lift the Z axis prior to homing. This is
#   applied to any homing command, even if it doesn't home the Z axis.
#   If the Z axis is already homed and the current Z position is less
#   than z_hop, then this will lift the head to a height of z_hop. If
#   the Z axis is not already homed the head is lifted by z_hop.
#   The default is to not implement Z hop.
#z_hop_speed: 20.0
#   Speed (in mm/s) at which the Z axis is lifted prior to homing. The
#   default is 20mm/s.
#move_to_previous: False
#   When set to True, the X and Y axes are reset to their previous
#   positions after Z axis homing. The default is False.
```

### [homing_override]

Kezdőpont felvétel felülbírálása. Ezt a mechanizmust arra lehet használni, hogy a normál G-Kód bemenetben található G28 helyett egy sor G-Kód parancsot futtassunk. Ez olyan nyomtatóknál lehet hasznos, amelyeknél a gép beindításához speciális eljárásra van szükség.

```
[homing_override]
gcode:
#   A normál G-Kód bemenetben található G28 parancsok helyett
#   végrehajtandó G-Kód parancsok listája. Lásd a
#   docs/Command_Templates.md fájlt a G-Kód formátumokhoz.
#   Ha a parancsok listája G28-at tartalmaz, akkor az a nyomtatófej normál
#   elhelyezési eljárását indítja el. Az itt felsorolt parancsoknak minden
#   tengelyt kezdőponthoz kell irányítaniuk. Ezt a paramétert meg kell adni.
#axes: xyz
#   A felülírandó tengelyek. Például, ha ez "Z"-re van állítva, akkor a
#   felülírási parancsfájl csak akkor fut le, ha a Z tengely be van állítva
#   (pl. "G28" vagy "G28 Z0" paranccsal). Ne feledje, hogy a felülírási
#   szkriptnek továbbra is minden tengelyt kell tartalmaznia.
#   Az alapértelmezés az "xyz", ami azt eredményezi, hogy a felülbíráló
#   szkript fut minden G28 parancs helyett.
#set_position_x:
#set_position_y:
#set_position_z:
#   Ha meg van adva, a nyomtató feltételezi, hogy a tengely a megadott
#   pozícióban van a fenti G-Kód parancsok futtatása előtt. Ennek a
#   beállításával letiltja az adott tengelyre vonatkozó kezdőpont
#   ellenőrzéseket. Ez akkor lehet hasznos, ha a nyomtatófejnek el kell
#   mozdulnia, mielőtt a normál G28 parancsot meghívná egy tengelyre.
#   Az alapértelmezés az, hogy nem erőltetik a tengely pozícióját.
```

### [endstop_phase]

Léptető fázissal beállított végállások. A funkció használatához definiáljon egy konfigurációs részt egy "endstop_phase" előtaggal, amelyet a megfelelő stepper konfigurációs rész neve követ (például "[endstop_phase stepper_z]"). Ez a funkció javíthatja a végálláskapcsolók pontosságát. Adjon hozzá egy csupasz "[endstop_phase]" deklarációt az ENDSTOP_PHASE_CALIBRATE parancs engedélyezéséhez.

További információkért lásd a [végállási fázisok útmutató](Endstop_Phase.md) és a [Parancs hivatkozás](G-Codes.md#endstop_phase) dokumentumot.

```
[endstop_phase stepper_z]
#endstop_accuracy:
#   Beállítja a végálláskapcsoló várható pontosságát (mm-ben). Ez azt a
#   maximális hibatávolságot jelöli, amelyet a végállás kiválthat (pl. ha
#   egy végállás időnként 100 um korán vagy legfeljebb 100 um késéssel
#   válthat ki, akkor állítsa ezt 0,200-ra 200 um esetén). Az alapértelmezett
#   4*rotation_distance/full_steps_per_rotation.
#trigger_phase:
#   Ez határozza meg a léptetőmotor meghajtójának azt az áramot,
#   amelyre számítani kell, amikor megüti a végállást. Két számból áll,
#   amelyeket egy perjel választ el. Az áramból és áramok teljes számából
#   (pl. "7/64"). Csak akkor állítsa be ezt az értéket, ha biztos abban, hogy a
#   motorvezérlő minden alkalommal alaphelyzetbe áll az MCU
#   alaphelyzetbe állításakor. Ha ez nincs beállítva, akkor a léptető fázist a
#   rendszer az első kezdőpontban érzékeli, és ezt az áramot használja az
#   összes következő kezdőpontfelvételkor.
#endstop_align_zero: False
#   Ha igaz, akkor a tengely position_endstop értéke ténylegesen módosul,
#   így a tengely nulla pozíciója a léptetőmotor teljes lépésénél megjelenik.
#   (Ha a Z tengelyen használjuk, és a nyomtatási réteg magassága a teljes
#   lépéstávolság többszöröse, akkor minden réteg egy teljes lépésben
#   jelenik meg.) Az alapértelmezett érték False.
```

## G-Kód makrók és események

### [gcode_macro]

G-Kód makrók (a "gcode_macro" előtaggal tetszőleges számú szakasz definiálható). További információkért lásd a [parancssablonok útmutatóját](Command_Templates.md).

```
[gcode_macro my_cmd]
#gcode:
# A "my_cmd" helyett végrehajtandó G-kód parancsok listája. Lásd
# docs/Command_Templates.md a G-kód formátumhoz. Ezt a paramétert
# meg kell adni.
#variable_<name>:
# Megadhatunk tetszőleges számú opciót "variable_" előtaggal.
# A megadott változó névhez a megadott értéket kapja (elemzett
# Python literálként), és a makró bővítése során elérhető lesz.
# Például a "variable_fan_speed = 75" változóval rendelkező konfigurációnak a következő lehet a következő értéke
# gcode parancsok, amelyek tartalmazzák a "M106 S{ fan_speed * 255 }". Változók
# futás közben a SET_GCODE_VARIABLE paranccsal módosíthatók.
# (a részleteket lásd a docs/Command_Templates.md fájlban). A változók nevei lehetnek kisbetűk
# nem kötelező használni nagybetűket.
#rename_existing:
# Ezzel az opcióval a makró felülír egy meglévő G-kód
# parancsot, és a parancs korábbi definícióját adja át a
# itt megadott névvel. Ez arra használható, hogy felülírja a beépített G-kód
# parancsokat. A parancsok felülbírálásakor óvatosan kell eljárni, mivel ez
# bonyolult és váratlan eredményeket okozhat. Az alapértelmezés szerint nem
# meglévő G-Code parancsot nem írja felül.
#description: G-kód makró
# Ez egy rövid leírást ad hozzá, amelyet a HELP parancsnál vagy
# az automatikus kitöltés funkció használatakor. Alapértelmezett "G-kód makró"
```

### [delayed_gcode]

Egy G-Kód végrehajtása beállított késleltetéssel. További információkért lásd a [parancssablon útmutató](Command_Templates.md#delayed-gcodes) és a [Parancs hivatkozás](G-Codes.md#delayed_gcode) dokumentumot.

```
[delayed_gcode my_delayed_gcode]
gcode:
#   A késleltetési idő letelte után végrehajtandó G-Kód parancsok listája.
#   A G-Code sablonok támogatottak. Ezt a paramétert meg kell adni.
#initial_duration: 0.0
#   A kezdeti késleltetés időtartama (másodpercben). Ha nullától eltérő
#   értékre van állítva, a delayed_gcode a megadott számú másodpercet
#   hajtja végre, miután a nyomtató „kész” állapotba lép. Ez hasznos lehet
#   inicializálási eljárások vagy ismétlődő delayed_gcode esetén. Ha 0-ra
#   van állítva, a delayed_gcode nem fut le az indításkor.
#   Az alapértelmezett érték 0.
```

### [save_variables]

A változók lemezre mentésének támogatása, hogy azok az újraindítások során is megmaradjanak. További információkért lásd [Parancs hivatkozás](Command_Templates.md#save-variables-to-disk) és a [G-Kód hivatkozás](G-Codes.md#save_variables) dokumentumot.

```
[save_variables]
filename:
# Kötelező! Adjon meg egy fájlnevet, amelyet a változó lemezre
# mentéséhez használnak pl. ~/variables.cfg
```

### [idle_timeout]

Üresjárati időtúllépés. Az üresjárati időtúllépés automatikusan engedélyezve van. Az alapértelmezett beállítások módosításához adjon hozzá egy explicit idle_timeout konfigurációs szakaszt.

```
[idle_timeout]
#gcode:
#   Az üresjárati időtúllépéskor végrehajtandó G-Kód parancsok listája.
#   Lásd a docs/Command_Templates.md fájlt a G-Kód formátumhoz.
#   Az alapértelmezett a „TURN_OFF_HEATERS” és „M84” futtatása.
#timeout: 600
#   A fenti G-Kód parancsok futtatása előtti várakozási idő (másodpercben).
#   Az alapértelmezett érték a 600 másodperc.
```

## Választható G-Kód funkciók

### [virtual_sdcard]

A virtuális sdcard hasznos lehet, ha a gazdaszámítógép nem elég gyors az OctoPrint megfelelő futtatásához. Ez lehetővé teszi a Klipper gazdagép szoftver számára, hogy közvetlenül kinyomtassa a G-kód fájlokat, amelyeket a gazdagépen lévő könyvtárban tárolnak a szabványos sdcard G-kód parancsok (pl. M24) használatával.

```
[virtual_sdcard]
path:
#   A helyi könyvtár elérési útja a gazdagépen a G-Kód fájlok kereséséhez.
#   Ez egy csak olvasható könyvtár (az sdcard fájl írása nem támogatott).
#   Ezzel rámutathatunk az OctoPrint feltöltési könyvtárára
#   (általában ~/.octoprint/uploads/ ). Ezt a paramétert meg kell adni.
```

### [sdcard_loop]

Néhány szakaszok törlésével rendelkező nyomtató, például alkatrész-kidobó vagy szalagnyomtató, hasznát veheti az SD-kártya fájl hurkolt szakaszainak. (Például ugyanazon alkatrész újra és újra történő kinyomtatásához, vagy egy alkatrész egy szakaszának megismétléséhez egy lánc vagy más ismétlődő mintához).

A támogatott parancsokat lásd a [Parancs hivatkozásban](G-Codes.md#sdcard_loop). Vagy lásd a [sample-macros.cfg](../config/sample-macros.cfg) fájlt egy Marlin kompatibilis M808 G-Kód makróért.

```
[sdcard_loop]
```

### [force_move]

Támogatja a lépegetőmotorok kézi mozgatását diagnosztikai célokra. Figyelem, ennek a funkciónak a használata a nyomtatót érvénytelen állapotba hozhatja. A fontos részletekért lásd a [Parancs hivatkozás](G-Codes.md#force_move) dokumentumot.

```
[force_move]
#enable_force_move: False
# A FORCE_MOVE és a SET_KINEMATIC_POSITION engedélyezéséhez
# állítsuk True-ra a kiterjesztett G-kód parancsot.
# Az alapértelmezett érték False.
```

### [pause_resume]

Szüneteltetési/folytatási funkció a pozíció rögzítésének és visszaállításának támogatásával. További információért lásd a [Parancs hivatkozás](G-Codes.md#pause_resume) dokumentumot.

```
[pause_resume]
#recover_velocity: 50.
# Ha a rögzítés/visszaállítás engedélyezve van, akkor a megadott
# sebességgel, tér vissza a rögzített pozícióhoz (mm/mp-ben).
# Az alapértelmezett érték 50,0 mm/mp.
```

### [firmware_retraction]

Firmware szál visszahúzás. Ez lehetővé teszi a G10 (visszahúzás) és G11 (visszahúzás megszüntetése) G-Kód parancsokat, amelyeket sok szeletelő program használ. Az alábbi paraméterek az indítási alapértelmezett értékeket adják meg, bár az értékek a SET_RETRACTION [parancs](G-Codes.md#firmware_retraction)) segítségével módosíthatók, lehetővé téve a szálankénti beállításokat és a futásidejű hangolást.

```
[firmware_retraction]
#retract_length: 0
# A G10 aktiválásakor visszahúzandó szál hossza (mm-ben),
# és a G11 aktiválásakor visszahúzandó (de lásd: G11).
# unretract_extra_length alább). Az alapértelmezett érték 0 mm.
#retract_speed: 20
# A behúzás sebessége mm/s-ban. Az alapértelmezett érték 20 mm/s.
#unretract_extra_length: 0
# A *kiegészítő* szál hossza (mm-ben), amelyet hozzáadunk, ha
# visszahúzás feloldásakor.
#unretract_speed: 10
# A visszahúzás feloldásának sebessége mm/s-ban. Az alapértelmezett érték 10 mm/s.
```

### [gcode_arcs]

A G-Kód ív (G2/G3) parancsok támogatása.

```
[gcode_arcs]
#resolution: 1.0
#   Egy ív szegmensekre lesz felosztva. Minden szegmens hossza
#   megegyezik a fent beállított felbontással, mm-ben. Az alacsonyabb
#   értékek finomabb ívet eredményeznek, de több munkát is végeznek
#   a gépen. A beállított értéknél kisebb ívek egyenesekké válnak.
#   Az alapértelmezett érték 1 mm.
```

### [respond]

Engedélyezze az "M118" és "RESPOND" kiterjesztett [parancsokat](G-Codes.md#respond).

```
[respond]
#default_type: echo
#   Beállítja az "M118" és a "RESPOND" kimenet alapértelmezett előtagját
#   a következők egyikére:
#       echo: "echo: " (Ez az alapértelmezett)
#       command: "// "
#       error: "!! "
#default_prefix: echo:
#   Közvetlenül beállítja az alapértelmezett előtagot. Ha jelen van, ez az
#   érték felülírja a „default_type” értéket.
```

## Rezonancia kompenzáció

### [input_shaper]

Engedélyezi a [rezonancia kompenzációt](Resonance_Compensation.md). Lásd még a [parancsreferencia](G-Codes.md#input_shaper) dokumentumot.

```
[input_shaper]
#shaper_freq_x: 0
#   A bemeneti változó frekvenciája (Hz-ben) az X tengelyhez. Ez általában
#   az X tengely rezonanciafrekvenciája, amelyet a bemeneti változóknak
#   el kell nyomnia. Bonyolultabb változók, például 2- és 3-hullámos EI
#   bemeneti változók esetén ez a paraméter különböző szempontok
#   alapján állítható be. Az alapértelmezett érték 0, ami letiltja az X
#   tengely bemeneti változását.
#shaper_freq_y: 0
#   Az Y tengely bemeneti változójának frekvenciája (Hz-ben). Ez általában
#   az Y tengely rezonanciafrekvenciája, amelyet a bemeneti változóknak
#   el kell nyomnia. Bonyolultabb változók, például 2- és 3-hullámos EI
#   bemeneti változók esetén ez a paraméter különböző szempontok
#   alapján állítható be. Az alapértelmezett érték 0, ami letiltja az Y
#   tengely bemeneti változását.
#shaper_type: mzv
#   A bemeneti változók típusa az X és az Y tengelyekhez. A támogatott
#   változók a zv, mzv, zvd, ei, 2hump_ei és 3hump_ei. Az alapértelmezett
#   bemeneti változó az mzv.
#shaper_type_x:
#shaper_type_y:
#   Ha a shaper_type nincs beállítva, akkor ez a két paraméter használható
#   különböző bemeneti változók konfigurálására az X és Y tengelyekhez.
#   Ugyanazok az értékek támogatottak, mint a shaper_type paraméternél.
#damping_ratio_x: 0,1
#damping_ratio_y: 0,1
#   Az X és Y tengely rezgésének csillapítási arányai, amelyeket a bemeneti
#   változók használnak a rezgéselnyomás javítására. Az alapértelmezett
#   érték 0,1, ami a legtöbb nyomtató számára jó általános érték. A legtöbb
#   esetben ez a paraméter nem igényel hangolást, és nem szabad
#   megváltoztatni.
```

### [adxl345]

ADXL345 gyorsulásmérők támogatása. Ez a támogatás lehetővé teszi a gyorsulásmérő méréseinek lekérdezését az érzékelőtől. Ez lehetővé teszi az ACCELEROMETER_MEASURE parancsot (további információkért lásd a [G-Kódok](G-Codes.md#adxl345) dokumentumot). Az alapértelmezett chipnév "default", de megadhatunk egy explicit nevet (pl. [adxl345 my_chip_name]).

```
[adxl345]
cs_pin:
# Az érzékelő SPI engedélyező tűje. Ezt a paramétert meg kell adni.
#spi_speed: 5000000
# A chippel való kommunikáció során használandó SPI sebesség (hz-ben).
# Az alapértelmezett érték 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Lásd az "általános SPI-beállítások" című szakaszt a
# fenti paraméterek leírásához.
#axes_map: x, y, z
# A gyorsulásmérő a nyomtató X, Y és Z tengelyeihez kell.
# Ez akkor lehet hasznos, ha a gyorsulásmérő olyan
# orientációban van beszerelve, amely nem egyezik a nyomtatóéval. Ebben az esetében
# például beállíthatjuk ezt a "Y, X, Z" értékre, hogy felcseréljük az X és Y tengelyeket.
# Lehetőség van arra is, hogy negáljunk egy tengelyt, ha a gyorsulásmérő
# iránya fordított (pl. "X, Z, -Y"). Az alapértelmezett érték "X, Y, Z",.
#rate: 3200
# Kimeneti adatátviteli sebesség az ADXL345 esetében. Az ADXL345 a következő
# sebességeket támogatja
# sebességek: 3200, 1600, 800, 400, 200, 100, 50 és 25. Vegye figyelembe, hogy
# nem ajánlott megváltoztatni ezt a sebességet az alapértelmezett 3200-ról, és
# a 800 alatti sebességek jelentősen befolyásolják a rezonancia mérés
# eredményeinek minőségét.
```

### [resonance_tester]

A rezonancia tesztelés és az automatikus bemeneti alakító kalibráció támogatása. A modul legtöbb funkciójának használatához további szoftverfüggőségeket kell telepíteni; további információkért olvassa el a [Rezonanciák mérése](Measuring_Resonances.md) és a [parancs hivatkozás](G-Codes.md#resonance_tester) című dokumentumot. A rezonanciák mérése című útmutató [Max simítás](Measuring_Resonances.md#max-smoothing) szakaszában további információkat talál a `max_smoothing` paraméterről és annak használatáról.

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
#min_freq: 5
#   Minimum frequency to test for resonances. The default is 5 Hz.
#max_freq: 120
#   Maximum frequency to test for resonances. The default is 120 Hz.
#accel_per_hz: 75
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
```

## Konfigurációs fájl segédletek

### [board_pins]

Alaplap tű álnevek (tetszőleges számú szekciót definiálhatunk "board_pins" előtaggal). Ezzel definiálhat álneveket a mikrokontroller tűihez.

```
[board_pins my_aliases]
mcu: mcu
#   Az álneveket használó mikrovezérlők vesszővel elválasztott listája.
#   Az alapértelmezés szerint az álneveket a fő "mcu"-ra kell alkalmazni.
aliases:
aliases_<name>:
#   A "name=value" álnevek vesszővel elválasztott listája, amelyet az
#   adott mikrovezérlőhöz kell létrehozni. Például az "EXP1_1=PE6"
#   egy "EXP1_1" álnevet hoz létre a "PE6" tűhöz. Ha azonban a "value"
#   a "<>" közé van zárva, akkor a "name" lefoglalt tűként jön létre
#   (például az "EXP1_9=<GND>" az "EXP1_9"-et foglalná le). Bármilyen
#   számú "aliases_" karakterrel kezdődő opció megadható.
```

### [include]

Include fájl támogatás. A nyomtató fő konfigurációs fájljához további konfigurációs fájlokat lehet csatolni. Helyettesítő karakterek is használhatók (pl. "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

Ez az eszköz lehetővé teszi, hogy egyetlen mikrokontroller-tűt többször definiáljon egy konfigurációs fájlban a szokásos hibajelentés nélkül. Ez diagnosztikai és hibakeresési célokra szolgál. Erre a szakaszra nincs szükség ott, ahol a Klipper támogatja ugyanazon tű többszöri használatát, és ennek a felülbírálatnak a használata zavaros és váratlan eredményeket okozhat.

```
[duplicate_pin_override]
pins:
#   Azok a tűk vesszővel elválasztott listája, amelyek többször
#   használhatók egy konfigurációs fájlban normál hibajelentés
#   nélkül. Ezt a paramétert meg kell adni.
```

## Ágy szintető hardver

### [probe]

Z magasságmérő szonda. Ezt a szakaszt a Z magasságmérő hardver engedélyezéséhez lehet definiálni. Ha ez a szakasz engedélyezve van, a PROBE és a QUERY_PROBE kiterjesztett [G-Kód parancsok](G-Codes.md#probe) elérhetővé válnak. Lásd még a [szonda kalibrálási útmutatót](Probe_Calibrate.md). A szondaszekció létrehoz egy virtuális "probe:z_virtual_endstop" tűt is. A stepper_z endstop_pin-t erre a virtuális tűre állíthatjuk a cartesian stílusú nyomtatókon, amelyek a szondát használják a Z végállás helyett. Ha a "probe:z_virtual_endstop" típust használjuk, akkor ne definiáljunk position_endsto-pot a stepper_z konfigurációs szakaszban.

```
[probe]
pin:
#   Probe detection pin. If the pin is on a different microcontroller
#   than the Z steppers then it enables "multi-mcu homing". This
#   parameter must be provided.
#deactivate_on_each_sample: True
#   This determines if Klipper should execute deactivation gcode
#   between each probe attempt when performing a multiple probe
#   sequence. The default is True.
#x_offset: 0.0
#   The distance (in mm) between the probe and the nozzle along the
#   x-axis. The default is 0.
#y_offset: 0.0
#   The distance (in mm) between the probe and the nozzle along the
#   y-axis. The default is 0.
z_offset:
#   The distance (in mm) between the bed and the nozzle when the probe
#   triggers. This parameter must be provided.
#speed: 5.0
#   Speed (in mm/s) of the Z axis when probing. The default is 5mm/s.
#samples: 1
#   The number of times to probe each point. The probed z-values will
#   be averaged. The default is to probe 1 time.
#sample_retract_dist: 2.0
#   The distance (in mm) to lift the toolhead between each sample (if
#   sampling more than once). The default is 2mm.
#lift_speed:
#   Speed (in mm/s) of the Z axis when lifting the probe between
#   samples. The default is to use the same value as the 'speed'
#   parameter.
#samples_result: average
#   The calculation method when sampling more than once - either
#   "median" or "average". The default is average.
#samples_tolerance: 0.100
#   The maximum Z distance (in mm) that a sample may differ from other
#   samples. If this tolerance is exceeded then either an error is
#   reported or the attempt is restarted (see
#   samples_tolerance_retries). The default is 0.100mm.
#samples_tolerance_retries: 0
#   The number of times to retry if a sample is found that exceeds
#   samples_tolerance. On a retry, all current samples are discarded
#   and the probe attempt is restarted. If a valid set of samples are
#   not obtained in the given number of retries then an error is
#   reported. The default is zero which causes an error to be reported
#   on the first sample that exceeds samples_tolerance.
#activate_gcode:
#   A list of G-Code commands to execute prior to each probe attempt.
#   See docs/Command_Templates.md for G-Code format. This may be
#   useful if the probe needs to be activated in some way. Do not
#   issue any commands here that move the toolhead (eg, G1). The
#   default is to not run any special G-Code commands on activation.
#deactivate_gcode:
#   A list of G-Code commands to execute after each probe attempt
#   completes. See docs/Command_Templates.md for G-Code format. Do not
#   issue any commands here that move the toolhead. The default is to
#   not run any special G-Code commands on deactivation.
```

### [bltouch]

BLTouch szonda. Ezt a szakaszt (a szondaszakasz helyett) a BLTouch szonda engedélyezéséhez lehet definiálni. További információkért lásd a [BL-Touch útmutató](BLTouch.md) és a [parancsreferencia](G-Codes.md#bltouch) című dokumentumot. Egy virtuális "probe:z_virtual_endstop" tű is létrejön (a részleteket lásd a "probe" szakaszban).

```
[bltouch]
sensor_pin:
#   Pin connected to the BLTouch sensor pin. Most BLTouch devices
#   require a pullup on the sensor pin (prefix the pin name with "^").
#   This parameter must be provided.
control_pin:
#   Pin connected to the BLTouch control pin. This parameter must be
#   provided.
#pin_move_time: 0.680
#   The amount of time (in seconds) to wait for the BLTouch pin to
#   move up or down. The default is 0.680 seconds.
#stow_on_each_sample: True
#   This determines if Klipper should command the pin to move up
#   between each probe attempt when performing a multiple probe
#   sequence. Read the directions in docs/BLTouch.md before setting
#   this to False. The default is True.
#probe_with_touch_mode: False
#   If this is set to True then Klipper will probe with the device in
#   "touch_mode". The default is False (probing in "pin_down" mode).
#pin_up_reports_not_triggered: True
#   Set if the BLTouch consistently reports the probe in a "not
#   triggered" state after a successful "pin_up" command. This should
#   be True for all genuine BLTouch devices. Read the directions in
#   docs/BLTouch.md before setting this to False. The default is True.
#pin_up_touch_mode_reports_triggered: True
#   Set if the BLTouch consistently reports a "triggered" state after
#   the commands "pin_up" followed by "touch_mode". This should be
#   True for all genuine BLTouch devices. Read the directions in
#   docs/BLTouch.md before setting this to False. The default is True.
#set_output_mode:
#   Request a specific sensor pin output mode on the BLTouch V3.0 (and
#   later). This setting should not be used on other types of probes.
#   Set to "5V" to request a sensor pin output of 5 Volts (only use if
#   the controller board needs 5V mode and is 5V tolerant on its input
#   signal line). Set to "OD" to request the sensor pin output use
#   open drain mode. The default is to not request an output mode.
#x_offset:
#y_offset:
#z_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   See the "probe" section for information on these parameters.
```

## További léptetőmotorok és extruderek

### [stepper_z1]

Több léptetőmotoros tengelyek. Egy cartesian stílusú nyomtatónál az adott tengelyt vezérlő léptető további konfigurációs blokkokkal rendelkezhet, amelyek olyan léptetőket határoznak meg, amelyeket az elsődleges léptetővel együtt kell léptetni. Bármennyi szakasz definiálható 1-től kezdődő numerikus utótaggal (például "stepper_z1", "stepper_z2" stb.).

```
[stepper_z1]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   A fenti paraméterek meghatározásához lásd a "léptető" részt.
#endstop_pin:
#   Ha egy endstop_pin definiálva van a kiegészítő léptetőhöz, akkor
#   a léptető visszatér, amíg az végállás ki nem vált. Ellenkező esetben
#   a léptető mindaddig visszatér, amíg a tengely elsődleges
#   léptetőjének végálláskapcsolója ki nem vált.
```

### [extruder1]

Több extruderes nyomtató esetén minden további extruder után adjon hozzá egy új extruder szakaszt. A további extruder szakaszok neve legyen "extruder1", "extruder2", "extruder3", és így tovább. A rendelkezésre álló paraméterek leírását lásd az "extruder" szakaszban.

Lásd a [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg) példakonfigurációt.

```
[extruder1]
#step_pin:
#dir_pin:
#...
#   Tekintse meg az "extruder" részt az elérhető léptető és
#   fűtőparaméterekért.
#shared_heater:
#   Ez az opció elavult, és többé nem kell megadni.
```

### [dual_carriage]

Az egy tengelyen két kocsival rendelkező cartesian nyomtatók támogatása. Az aktív kocsit a SET_DUAL_CARRIAGE kiterjesztett G-Kód parancs segítségével állíthatjuk be. A "SET_DUAL_CARRIAGE CARRIAGE=1" parancs az ebben a szakaszban meghatározott kocsit aktiválja (a CARRIAGE=0 az elsődleges kocsi aktiválását állítja vissza). A kettős kocsitámogatást általában extra extruderekkel kombinálják. A SET_DUAL_CARRIAGE parancsot gyakran az ACTIVATE_EXTRUDER paranccsal egyidejűleg hívják meg. Ügyeljen arra, hogy a kocsikat a deaktiválás során parkoló állásba küldje.

Lásd a [sample-idex.cfg](../config/sample-idex.cfg) példakonfigurációt.

```
[dual_carriage]
axis:
#   Azon a tengelyen, amelyen ez az extra kocsi van (X vagy Y).
#   Ezt a paramétert meg kell adni.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   A fenti paraméterek meghatározásához lásd a "léptető" részt.
```

### [extruder_stepper]

Az extruder mozgásához szinkronizált további léptetők támogatása (tetszőleges számú szakasz definiálható "extruder_stepper" előtaggal).

További információkért lásd a [parancshivatkozás](G-Codes.md#extruder) dokumentumot.

```
[extruder_stepper my_extra_stepper]
extruder:
#   The extruder this stepper is synchronized to. If this is set to an
#   empty string then the stepper will not be synchronized to an
#   extruder. This parameter must be provided.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   See the "stepper" section for the definition of the above
#   parameters.
```

### [manual_stepper]

Kézi léptetők (tetszőleges számú szakasz definiálható "manual_stepper" előtaggal). Ezeket a léptetőket a MANUAL_STEPPER G-Kód parancs vezérli. Például: "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". A MANUAL_STEPPER parancs leírását lásd a [G-Kódok](G-Codes.md#manual_stepper) fájlban. A léptetők nem kapcsolódnak a nyomtató normál kinematikájához.

```
[manual_stepper my_stepper]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   A paraméterek leírását lásd a "léptető" részben.
#velocity:
#   Állítsa be a léptető alapértelmezett sebességét (mm/mp-ben).
#   Ezt az értéket használja a rendszer, ha a MANUAL_STEPPER parancs nem
#   ad meg SPEED paramétert. Az alapértelmezett érték 5 mm/mp.
#accel:
#   Állítsa be a léptető alapértelmezett gyorsulását (mm/mp^2-en). A nulla
#   gyorsulás nem eredményez gyorsulást. Ezt az értéket használja a rendszer,
#   ha a MANUAL_STEPPER parancs nem ad meg ACCEL paramétert.
#   Az alapértelmezett érték 0.
#endstop_pin:
#   Végálláskapcsoló csatlakozási tű. Ha meg van adva, akkor egy
#   STOP_ON_ENDSTOP paraméter hozzáadásával a MANUAL_STEPPER
#   mozgásparancsokhoz "kezdőpont felvételi mozgások" hajthatók végre.
```

## Egyedi fűtőtestek és érzékelők

### [verify_heater]

A fűtés és a hőmérséklet-érzékelő ellenőrzése. A fűtőelemek ellenőrzése automatikusan engedélyezve van minden olyan fűtőelemhez, amely a nyomtatón be van állítva. Az alapértelmezett beállítások módosításához használja a verify_heater szakaszokat.

```
[verify_heater heater_config_name]
#max_error: 120
#   A maximális „halmozott hőmérsékleti hiba” a hiba emelése előtt.
#   A kisebb értékek szigorúbb ellenőrzést eredményeznek, a nagyobb
#   értékek pedig több időt biztosítanak a hibajelentés előtt.
#   Pontosabban, a hőmérsékletet másodpercenként egyszer ellenőrzik,
#   és ha közel van a célhőmérséklethez, akkor a belső "hibaszámláló"
#   nullázódik. Ellenkező esetben, ha a hőmérséklet a céltartomány alatt
#   van, akkor a számlálót annyival növeljük, amennyivel a jelentett
#   hőmérséklet eltér ettől a tartománytól. Ha a számláló meghaladja ezt
#   a "max_error" értéket, hibaüzenet jelenik meg.
#   Az alapértelmezett érték 120.
#check_gain_time:
#   Ez szabályozza a fűtőelem ellenőrzését a kezdeti fűtés során.
#   A kisebb értékek szigorúbb ellenőrzést eredményeznek, a nagyobb
#   értékek pedig több időt biztosítanak a hibajelentés előtt.
#   Pontosabban, a kezdeti fűtés során, amíg a fűtőelem hőmérséklete
#   ezen időkereten belül (másodpercben van megadva) megemelkedik,
#   a belső "hibaszámláló" nullázódik. Az alapértelmezett érték 20
#   másodperc az extruder-eknél és 60 másodperc a heater_bed
#   esetében.
#hysteresis: 5
#   A maximális hőmérséklet-különbség (Celsius fokban) a
#   célhőmérséklethez képest, amely a cél tartományában van. Ez
#   szabályozza a max_error tartomány ellenőrzését. Ritka az érték
#   testreszabása. Az alapértelmezett érték 5.
#heating_gain: 2
#   Az a minimális hőmérséklet (Celsiusban), amellyel a fűtésnek
#   növelnie kell a check_gain_time ellenőrzés során.
#   Ritka az érték testreszabása. Az alapértelmezett érték 2.
```

### [homing_heaters]

Eszköz a fűtőberendezések letiltására, amikor egy tengely kezdőpont felvételt vagy szintezést csinál.

```
[homing_heaters]
#steppers:
#   A fűtőelemek vesszővel elválasztott listája, amelyek miatt le kell
#   tiltani a fűtést. Az alapértelmezés az, hogy letiltja a fűtőelemeket
#   minden indítási/mérési lépéshez.
#   Tipikus példa: stepper_z
#heaters:
#   A fűtőtestek vesszővel elválasztott listája, amelyet le kell tiltani
#   az elhelyezési/mérési lépések során. Az alapértelmezett az összes
#   fűtőelem letiltása. Tipikus példa: extruder, heater_bed
```

### [thermistor]

Egyéni termisztorok (tetszőleges számú szakasz definiálható "termisztor" előtaggal). Egyéni termisztor használható a fűtőberendezés konfigurációs szakaszának sensor_type mezőjében. (Ha például egy "[thermistor my_thermistor]" szekciót definiálunk, akkor a fűtőelem definiálásakor használhatjuk a "sensor_type: my_thermistor" mezőt.). Ügyeljen arra, hogy a termisztor szekciót a konfigurációs fájlban az első fűtőszekcióban való használata fölé helyezze.

```
[thermistor my_thermistor]
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#temperature3:
#resistance3:
#   Három ellenállásmérés (ohmban) adott hőmérsékleten (Celsiusban).
#   A három mérést a termisztor Steinhart-Hart együtthatóinak
#   kiszámításához használjuk fel. Ezeket a paramétereket meg kell adni,
#   ha Steinhart-Hartot használunk a termisztor meghatározásához.
#beta:
#   Alternatív megoldásként a temperature1, resistance1, és beta
#   megadható a termisztor paramétereinek meghatározásához. Ezt a
#   paramétert akkor kell megadni, ha "beta"-t használ a termisztor
#   meghatározásához.
```

### [adc_temperature]

Egyedi ADC hőmérséklet-érzékelők (tetszőleges számú szekciót lehet definiálni "adc_temperature" előtaggal). Ez lehetővé teszi egy olyan egyéni hőmérséklet-érzékelő definiálását, amely egy feszültséget mér egy analóg-digitális átalakító (ADC) tűn, és lineáris interpolációt használ a konfigurált hőmérséklet/feszültség (vagy hőmérséklet/ellenállás) mérések között a hőmérséklet meghatározásához. Az így kapott érzékelő sensor_type-ként használható egy fűtőszekcióban. (Ha például egy "[adc_temperature my_sensor]" szekciót definiálunk, akkor egy fűtőelem definiálásakor használhatjuk a "sensor_type: my_sensor" szekciót). Ügyeljen arra, hogy a szenzor szekciót a config fájlban az első felhasználása fölé helyezze a fűtőszekcióban.

```
[adc_temperature my_sensor]
#temperature1:
#voltage1:
#temperature2:
#voltage2:
#...
# A használandó hőmérsékletek (Celsiusban) és feszültségek (Voltban) halmaza
# referenciaként használjuk a hőmérséklet átváltásakor. Egy fűtőszekció, amely a
# ezt az érzékelőt használva adc_voltage és voltage_offset értékeket is megadhat.
# paramétereket az ADC-feszültség meghatározásához (lásd "Közönséges hőmérséklet
# erősítők" szakaszban a részletekért). Legalább két mérésnek kell lennie.
#temperature1:
#ellenállás1:
#hőmérséklet2:
#resistance2:
#...
# Alternatívaként megadhatunk egy sorban hőmérsékletet (Celsiusban) is
# és ellenállást (Ohmban), hogy referenciaként használhassuk, amikor átalakítunk egy
# hőmérsékletet. Ezt az érzékelőt használó fűtőszekcióban megadhatunk egy
# pullup_resistor paramétert (a részleteket lásd az "extruder" szakaszban).
# A címen legalább két mérést kell megadni.
```

### [heater_generic]

Általános fűtőtestek (tetszőleges számú szakasz definiálható a "heater_generic" előtaggal). Ezek a fűtőberendezések a standard fűtőberendezésekhez (extruderek, fűtött ágy) hasonlóan viselkednek. A SET_HEATER_TEMPERATURE paranccsal (lásd a [G-Kódok](G-Codes.md#heaters) dokumentumban) állíthatjuk be a célhőmérsékletet.

```
[heater_generic my_generic_heater]
#gcode_id:
#   A hőmérséklet jelentésénél az M105 parancsban
#   használandó azonosító.
#   Ezt a paramétert meg kell adni.
#heater_pin:
#max_power:
#sensor_type:
#sensor_pin:
#smooth_time:
#control:
#pid_Kp:
#pid_Ki:
#pid_Kd:
#pwm_cycle_time:
#min_temp:
#max_temp:
#   A fenti paraméterek meghatározásához
#   lásd az "extruder" részt.
```

### [temperature_sensor]

Általános hőmérséklet-érzékelők. Tetszőleges számú további hőmérséklet-érzékelőt lehet definiálni, amelyek az M105 parancson keresztül jelentenek.

```
[temperature_sensor my_sensor]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   A fenti paraméterek meghatározásához lásd az
#   "extruder" részt.
#gcode_id:
#   Lásd a "heater_generic" részt a paraméter
#   meghatározásához.
```

## Hőmérséklet-érzékelők

A Klipper számos típusú hőmérséklet-érzékelő definícióját tartalmazza. Ezek az érzékelők bármely olyan konfigurációs szakaszban használhatók, amely hőmérséklet-érzékelőt igényel (például egy `[extruder]` vagy `[heated_bed]` szakaszban).

### Közös termisztorok

Közönséges termisztorok. A következő paraméterek állnak rendelkezésre azokban a fűtőszakaszban, amelyek ezen érzékelők valamelyikét használják.

```
sensor_type:
#   One of "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
#   "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
#   "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", or "TDK NTCG104LH104JT1"
sensor_pin:
#   Analog input pin connected to the thermistor. This parameter must
#   be provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the thermistor.
#   The default is 4700 ohms.
#inline_resistor: 0
#   The resistance (in ohms) of an extra (not heat varying) resistor
#   that is placed inline with the thermistor. It is rare to set this.
#   The default is 0 ohms.
```

### Közös hőmérséklet erősítők

Közös hőmérsékletű erősítők. A következő paraméterek állnak rendelkezésre azokban a fűtőszakaszokban, amelyek ezen érzékelők valamelyikét használják.

```
sensor_type:
#   A „PT100 INA826”, „AD595”, „AD597”, „AD8494”, „AD8495”,
#   „AD8496” vagy „AD8497” közül az egyik.
sensor_pin:
#   Analóg bemeneti érintkező csatlakozik az érzékelőhöz.
#   Ezt a paramétert meg kell adni.
#adc_voltage: 5.0
#   Az ADC összehasonlító feszültsége (V-ban).
#   Az alapértelmezett érték 5.
#voltage_offset: 0
#   Az ADC feszültség eltolása (V-ban). Az alapértelmezett érték 0.
```

### Közvetlenül csatlakoztatott PT1000 érzékelő

Közvetlenül csatlakoztatott PT1000 érzékelő. A következő paraméterek állnak rendelkezésre azokban a fűtési szakaszokban, amelyek valamelyik érzékelőt használják.

```
sensor_type: PT1000
sensor_pin:
#   Analóg bemeneti érintkező csatlakozik az érzékelőhöz.
#   Ezt a paramétert meg kell adni.
#pullup_resistor: 4700
#   Az érzékelőhöz csatlakoztatott felhúzó ellenállás (ohmban).
#   Az alapértelmezett 4700 ohm.
```

### MAXxxxxx hőmérséklet-érzékelők

MAXxxxxx soros perifériás interfész (SPI) hőmérséklet-alapú érzékelők. A következő paraméterek állnak rendelkezésre azokban a fűtési szakaszokban, amelyek ezen érzékelőtípusok valamelyikét használják.

```
sensor_type:
#   A „MAX6675”, „MAX31855”, „MAX31856” vagy „MAX31865” egyike.
sensor_pin:
#   Az érzékelő chip kiválasztási sora. Ezt a paramétert meg kell adni.
#spi_speed: 4000000
#   A chippel való kommunikáció során használandó SPI-sebesség
#   (hz-ben). Az alapértelmezett érték 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   A fenti paraméterek leírását az "általános SPI-beállítások"
#   részben találja.
#tc_type: K
#tc_use_50Hz_filter: False
#tc_averaging_count: 1
#   A fenti paraméterek a MAX31856 chipek érzékelőparamétereit
#   szabályozzák. Az egyes paraméterek alapértelmezett értékei a
#   paraméter neve mellett találhatók a fenti listában.
#rtd_nominal_r: 100
#rtd_reference_r: 430
#rtd_num_of_wires: 2
#rtd_use_50Hz_filter: False
#   A fenti paraméterek a MAX31865 chipek érzékelőparamétereit
#   szabályozzák. Az egyes paraméterek alapértelmezett értékei a
#   paraméter neve mellett találhatók a fenti listában.
```

### BMP280/BME280/BME680 hőmérséklet-érzékelő

BMP280/BME280/BME680 kétvezetékes interfész (I2C) környezeti érzékelők. Vegye figyelembe, hogy ezeket az érzékelőket nem extruderekkel és fűtőágyakkal való használatra szánják, hanem a környezeti hőmérséklet (C), a nyomás (hPa), a relatív páratartalom és a BME680 esetében a gázszint ellenőrzésére. Lásd [sample-macros.cfg](../config/sample-macros.cfg) egy gcode_macro-t, amely a hőmérséklet mellett a nyomás és a páratartalom mérésére is használható.

```
sensor_type: BME280
#i2c_address:
# Alapértelmezett 118 (0x76). Néhány BME280-as érzékelő címe 119.
# (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
# Lásd az "általános I2C beállítások" című szakaszt a fenti paraméterek leírásáért.
```

### HTU21D érzékelő

HTU21D kétvezetékes interfész (I2C) környezeti érzékelő. Vegye figyelembe, hogy ezt az érzékelőt nem extruderekkel és fűtőágyakkal való használatra szánják, hanem a környezeti hőmérséklet (C) és a relatív páratartalom ellenőrzésére. Lásd [sample-macros.cfg](../config/sample-macros.cfg) egy gcode_macro-t, amely a hőmérséklet mellett a páratartalom jelentésére is használható.

```
sensor_type:
#   A következőnek kell lennie: "HTU21D", "SI7013", "SI7020",
#   "SI7021" vagy "SHT21"
#i2c_address:
#   Az alapértelmezett 64 (0x40).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   A fenti paraméterek leírását lásd az "általános I2C beállítások"
#   részben.
#htu21d_hold_master:
#   Ha az érzékelő képes megtartani az I2C buffot olvasás közben.
#   Ha igaz, az olvasás közben más buszkommunikáció nem
#   hajtható végre. Az alapértelmezett érték False.
#htu21d_resolution:
#   A hőmérséklet és a páratartalom leolvasásának felbontása.
#   Az érvényes értékek a következők:
#    'TEMP14_HUM12' -> 14 bit a hőmérséklethez és 12 bit a páratartalomhoz
#    'TEMP13_HUM10' -> 13 bit a hőmérséklethez és 10 bit a páratartalomhoz
#    'TEMP12_HUM08' -> 12 bit a hőmérséklethez és 08 bit a páratartalomhoz
#    'TEMP11_HUM11' -> 11 bit a hőmérséklethez és 11 bit a páratartalomhoz
#   Az alapértelmezett érték: "TEMP11_HUM11"
#htu21d_report_time:
#   A leolvasások közötti intervallum másodpercben.
#   Az alapértelmezett a 30
```

### LM75 hőmérséklet-érzékelő

LM75/LM75A kétvezetékes (I2C) csatlakozású hőmérséklet érzékelők. Ezek az érzékelők -55~125 C tartományban működnek, így pl. kamrahőmérséklet ellenőrzésre használhatók. Egyszerű ventilátor/fűtésvezérlőként is működhetnek.

```
sensor_type: LM75
#i2c_address:
#   Default is 72 (0x48). Normal range is 72-79 (0x48-0x4F) and the 3
#   low bits of the address are configured via pins on the chip
#   (usually with jumpers or hard wired).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#lm75_report_time:
#   Interval in seconds between readings. Default is 0.8, with minimum
#   0.5.
```

### Beépített mikrokontroller hőmérséklet-érzékelő

Az atsam, atsamd és stm32 mikrovezérlők belső hőmérséklet-érzékelőt tartalmaznak. A "temperature_mcu" parancsot használhatjuk e hőmérsékletek megjelenítésére.

```
sensor_type: temperature_mcu
#sensor_mcu: mcu
#   A mikrokontroller, amelyből olvasni lehet.
#   Az alapértelmezett érték az "mcu".
#sensor_temperature1:
#sensor_adc1:
#   Adja meg a fenti két paramétert (a hőmérsékletet Celsiusban és egy
#   ADC-értéket úszóként 0,0 és 1,0 között) a mikrovezérlő
#   hőmérsékletének kalibrálásához. Ez egyes chipeknél javíthatja a
#   jelentett hőmérsékleti pontosságot. A kalibrációs adatok
#   megszerzésének tipikus módja az, hogy néhány órára teljesen
#   áramtalanítja a nyomtatót (hogy megbizonyosodjon arról, hogy az
#   környezeti hőmérsékleten van), majd bekapcsolja, és a QUERY_ADC
#   paranccsal megkapja az ADC mérést. Használjon más hőmérséklet
#   érzékelőt a nyomtatón a megfelelő környezeti hőmérséklet
#   meghatározásához. Alapértelmezés szerint a mikrokontroller gyári
#   kalibrálási adatait (ha van) vagy a mikrovezérlő specifikációjából
#   származó névleges értékeket kell használni.
#sensor_temperature2:
#sensor_adc2:
#   Ha a sensor_temperature1/sensor_adc1 meg van adva, akkor
#   megadhatók a sensor_temperature2/sensor_adc2 kalibrációs adatai
#   is. Ezzel kalibrált "temperature slope" információt kaphat.
#   Alapértelmezés szerint a mikrokontroller gyári kalibrálási adatait
#   (ha van) vagy a mikrovezérlő specifikációjából származó névleges
#   értékeket kell használni.
```

### Gazdagép hőmérséklet érzékelő

Gazdagép hőmérséklet (pl. Raspberry Pi), amelyen a gazdaszoftver fut.

```
sensor_type: temperature_host
#sensor_path:
#   A hőmérsékleti rendszerfájl elérési útja. Az alapértelmezés
#   a "/sys/class/thermal/thermal_zone0/temp", amely a Raspberry Pi
#   számítógép hőmérsékleti rendszerfájlja.
```

### DS18B20 hőmérséklet érzékelő

A DS18B20 egy 1 vezetékes (w1) digitális hőmérséklet érzékelő. Vegye figyelembe, hogy ezt az érzékelőt nem extruderekkel és fűtött ágyakkal való használatra szánják, hanem inkább a környezeti hőmérséklet (C) ellenőrzésére. Ezek az érzékelők 125 C-ig terjedő tartományban működnek, így pl. kamrahőmérséklet ellenőrzésre használhatók. Egyszerű ventilátor/fűtőberendezés szabályozóként is működhetnek. A DS18B20 érzékelőket csak a "host mcu", pl. a Raspberry Pi támogatja. A w1-gpio Linux kernel modult kell telepíteni hozzá.

```
sensor_type: DS18B20
serial_no:
#   Minden 1 vezetékes eszköz egyedi sorozatszámmal rendelkezik, amely az
#   eszköz azonosítására szolgál, általában 28-031674b175ff formátumban.
#   Ezt a paramétert meg kell adni. A csatlakoztatott egyvezetékes eszközök a
#   következő Linux-paranccsal listázhatók:
#   ls /sys/bus/w1/devices/
#ds18_report_time:
#   A leolvasások közötti intervallum másodpercben.
#   Az alapértelmezett érték 3.0, a minimum 1.0
#sensor_mcu:
#   A mikrokontroller, amelyből olvasni lehet. A host_mcu legyen
```

## Hűtőventilátorok

### [fan]

Nyomtatás hűtőventilátor.

```
[ventilátor]
pin:
# A ventilátort vezérlő kimeneti pin. Ezt a paramétert meg kell adni.
#max_power: 1.0
# A maximális teljesítmény (0.0 és 1.0 közötti értékként kifejezve), amely a
# pinen beállítható. Az 1.0 érték lehetővé teszi, hogy a pin teljesen beállítható legyen.
# Hosszabb időre is engedélyezve legyen, míg a 0.5 érték lehetővé teszi, hogy a pin
# legfeljebb az idő felére legyen engedélyezve. Ez a beállítás
# használható a teljes kimeneti teljesítmény korlátozására a ventilátornál (hosszabb időszakok alatt).
# Ha ez az érték kisebb, mint 1.0, akkor a ventilátor fordulatszám kérése
# nulla és a max_power között lesz skálázva (például, ha
# max_power .9, és a ventilátor 80%-os sebességet kér, akkor a ventilátor
# teljesítménye 72%-ra lesz beállítva). Az alapértelmezett érték 1.0.
#shutdown_speed: 0
# A kívánt ventilátorsebesség (0,0 és 1,0 közötti értékként kifejezve) ha
# a mikrokontroller szoftver hibaállapotba kerül. Az alapértelmezett
# 0.
#cycle_time: 0.010
# Az az idő (másodpercben), amely alatt minden PWM ciklus kikerül a
# ventilátorhoz. Ajánlatos, hogy ez 10 milliszekundum vagy nagyobb legyen, a
# szoftveralapú PWM használata esetén. Az alapértelmezett érték 0,010 másodperc.
#hardware_pwm: False
# Engedélyezze ezt a hardveres PWM használatához a szoftveres PWM helyett. A legtöbb ventilátor
# nem működik jól a hardveres PWM-mel, ezért nem ajánlott annak
# engedélyezése, hacsak nincs elektromos követelmény, hogy a kapcsolás
# nagyon nagy sebességgel történjen. Hardveres PWM használatakor a tényleges ciklusidő
# a megvalósítást korlátozza, és jelentősen nagyobb mértékben
# eltérhet a kért ciklusidőtől. Az alapértelmezett érték False.
#kick_start_time: 0.100
# Az idő (másodpercben), amíg a ventilátor teljes fordulatszámra pörög, amikor először
# engedélyezi vagy 50%-nál nagyobb mértékre növeli (segít a ventilátor működésbe hozásában).
# Az alapértelmezett érték 0,100 másodperc.
#off_below: 0.0
# A minimális bemeneti sebesség, amely a ventilátort működtetni fogja (kifejezve egy
# 0.0 és 1.0 közötti értékben). Ha az off_below-nál alacsonyabb sebességet
# kért, a ventilátor inkább kikapcsol. Ez a beállítás lehet
# a ventilátor leállásának megakadályozására és a kick-indítás biztosítására használható.
# Az alapértelmezett érték 0.0.
#
# Ezt a beállítást mindig újra kell kalibrálni, amikor a max_power-t módosítjuk.
# A beállítás kalibrálásához kezdjük úgy, hogy az off_below értéke 0.0.
# Fokozatosan csökkentse a ventilátor fordulatszámát a legalacsonyabb érték meghatározásához.
# Válassza azt a bemeneti sebességet, amely megbízhatóan, leállás nélkül hajtja a ventilátort. Állítsa be a
# off_below-t az ennek az értéknek megfelelő munkaszünetre (a
# például 12% -> 0,12) vagy valamivel magasabb értéket.
#tachometer_pin:
# Tachométer bemeneti pin a ventilátor fordulatszámának ellenőrzésére. A pullup általában
# szükséges. Ez a paraméter opcionális.
#tachometer_ppr: 2
# Ha a tachometer_pin meg van adva, akkor ez az impulzusok száma per
# fordulatonként a tachométer jelének impulzusainak száma. Egy BLDC ventilátor esetében ez
# általában a pólusok számának fele. Az alapértelmezett érték 2.
#tachometer_poll_intervall: 0.0015
# Ha a tachometer_pin meg van adva, ez a lekérdezési periódus a
# tachometer pin, másodpercben. Az alapértelmezett érték 0.0015, ami gyors.
# elég gyors a 10000 RPM alatti ventilátorokhoz 2 PPR mellett. Ennek kisebbnek kell lennie, mint
# 30/(tachometer_ppr*rpm), némi mozgástérrel, ahol az rpm a fordulatszám.
# A ventilátor maximális fordulatszáma (fordulatszámban).
```

### [heater_fan]

Fejhűtő ventilátorok (a "heater_fan" előtaggal tetszőleges számú szakasz definiálható). A "fejhűtő ventilátor" egy olyan ventilátor, amely akkor lesz engedélyezve, amikor a hozzá tartozó fűtőberendezés aktív. Alapértelmezés szerint a heater_fan alapértelmezés szerint a shutdown_speed a max_power értékkel egyenlő.

```
[heater_fan my_nozzle_fan]
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
#   A fenti paraméterek leírását lásd a „ventilátor” részben.
#heater: extruder
#   A ventilátorhoz társított fűtést meghatározó konfigurációs szakasz
#   neve. Ha itt megadja a fűtőelemek vesszővel elválasztott nevét,
#   akkor a ventilátor engedélyezve lesz, ha valamelyik adott fűtőtest
#   engedélyezve van. Az alapértelmezett érték az "extruder".
#heater_temp: 50.0
#   Az a hőmérséklet (Celsiusban), amely alá a fűtőelemnek le kell
#   süllyednie, mielőtt a ventilátort letiltják.
#   Az alapértelmezett érték 50 Celsius.
#fan_speed: 1.0
#   A ventilátor sebessége (0,0 és 1,0 közötti értékként kifejezve),
#   amelyre a ventilátor be lesz állítva, amikor a hozzá tartozó
#   fűtőberendezés engedélyezve van. Az alapértelmezett érték 1.0
```

### [controller_fan]

Vezérlő hűtőventilátor (a "controller_fan" előtaggal tetszőleges számú szakasz definiálható). A "vezérlő hűtőventilátor" egy olyan ventilátor, amely akkor lesz engedélyezve, amikor a hozzá tartozó fűtőberendezés vagy a hozzá tartozó léptető meghajtó aktív. A ventilátor leáll, amikor elér egy idle_timeout értéket, hogy biztosítsa, hogy a felügyelt komponens kikapcsolása után ne következzen be túlmelegedés.

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
#   See the "fan" section for a description of the above parameters.
#fan_speed: 1.0
#   The fan speed (expressed as a value from 0.0 to 1.0) that the fan
#   will be set to when a heater or stepper driver is active.
#   The default is 1.0
#idle_timeout:
#   The amount of time (in seconds) after a stepper driver or heater
#   was active and the fan should be kept running. The default
#   is 30 seconds.
#idle_speed:
#   The fan speed (expressed as a value from 0.0 to 1.0) that the fan
#   will be set to when a heater or stepper driver was active and
#   before the idle_timeout is reached. The default is fan_speed.
#heater:
#stepper:
#   Name of the config section defining the heater/stepper that this fan
#   is associated with. If a comma separated list of heater/stepper names
#   is provided here, then the fan will be enabled when any of the given
#   heaters/steppers are enabled. The default heater is "extruder", the
#   default stepper is all of them.
```

### [temperature_fan]

Hőmérséklet vezérelt hűtőventilátorok (tetszőleges számú szekciót lehet definiálni a "temperature_fan" előtaggal). A "hőmérsékleti ventilátor" olyan ventilátor, amely akkor kapcsol be, amikor a hozzá tartozó érzékelő egy beállított hőmérséklet felett van. Alapértelmezés szerint a temperature_fan kikapcsolási sebessége egyenlő a max_power értékkel.

További információkért lásd a [parancs hivatkozást](G-Codes.md#temperature_fan).

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
#   A fenti paraméterek leírását lásd a „ventilátor” részben.
#sensor_type:
#sensor_pin:
#control:
#pid_Kp:
#pid_Ki:
#pid_Kd:
#pid_deriv_time:
#max_delta:
#min_temp:
#max_temp:
#   A fenti paraméterek leírását lásd az "extruder" részben.
#target_temp: 40.0
#   Egy hőmérséklet (Celsiusban), amely a célhőmérséklet lesz.
#   Az alapértelmezett érték 40 fok.
#max_speed: 1.0
#   A ventilátor sebessége (0,0 és 1,0 közötti értékként kifejezve), amelyre
#   a ventilátor be lesz állítva, ha az érzékelő hőmérséklete meghaladja a
#   beállított értéket. Az alapértelmezett érték 1.0.
#min_speed: 0.3
#   A ventilátor minimális sebessége (0,0 és 1,0 közötti értékként kifejezve)
#   Az alapértelmezett érték 0,3.
#gcode_id:
#   Ha be van állítva, a hőmérséklet az M105 lekérdezésekben lesz jelentve
#   a megadott azonosítóval. Az alapértelmezés szerint nem jelenti a
#   hőmérsékletet az M105-ön keresztül.
```

### [fan_generic]

Kézi vezérlésű ventilátor (a "fan_generic" előtaggal tetszőleges számú szekciót lehet definiálni). A kézi vezérlésű ventilátor fordulatszámát a SET_FAN_SPEED [G-Kód](G-Codes.md#fan_generic) paranccsal lehet beállítani.

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
#   A fenti paraméterek leírását lásd a „ventilátor” részben.
```

## LED-ek

### [led]

A mikrokontroller PWM tűin keresztül vezérelt LED-ek (és LED-csíkok) támogatása (a "led" előtaggal tetszőleges számú szekciót definiálhatunk). További információkért lásd a [parancs hivatkozást](G-Codes.md#led).

```
[led my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
#   The pin controlling the given LED color. At least one of the above
#   parameters must be provided.
#cycle_time: 0.010
#   The amount of time (in seconds) per PWM cycle. It is recommended
#   this be 10 milliseconds or greater when using software based PWM.
#   The default is 0.010 seconds.
#hardware_pwm: False
#   Enable this to use hardware PWM instead of software PWM. When
#   using hardware PWM the actual cycle time is constrained by the
#   implementation and may be significantly different than the
#   requested cycle_time. The default is False.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Sets the initial LED color. Each value should be between 0.0 and
#   1.0. The default for each color is 0.
```

### [neopixel]

Neopixel (más néven WS2812) LED támogatás (tetszőleges számú szekciót definiálhatunk "neopixel" előtaggal). További információkért lásd a [parancs hivatkozást](G-Codes.md#led).

Vegye figyelembe, hogy a [linux mcu](RPi_microcontroller.md) implementáció jelenleg nem támogatja a közvetlenül csatlakoztatott neopixeleket.

```
[neopixel my_neopixel]
pin:
#   The pin connected to the neopixel. This parameter must be
#   provided.
#chain_count:
#   The number of Neopixel chips that are "daisy chained" to the
#   provided pin. The default is 1 (which indicates only a single
#   Neopixel is connected to the pin).
#color_order: GRB
#   Set the pixel order required by the LED hardware (using a string
#   containing the letters R, G, B, W with W optional). The default is
#   GRB.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

### [dotstar]

Dotstar (más néven APA102) LED-támogatás (tetszőleges számú szekciót lehet definiálni "dotstar" előtaggal). További információkért lásd a [parancs hivatkozást](G-Codes.md#led).

```
[dotstar my_dotstar]
data_pin:
#   The pin connected to the data line of the dotstar. This parameter
#   must be provided.
clock_pin:
#   The pin connected to the clock line of the dotstar. This parameter
#   must be provided.
#chain_count:
#   See the "neopixel" section for information on this parameter.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#   See the "led" section for information on these parameters.
```

### [pca9533]

PCA9533 LED-támogatás. A PCA9533 a mightyboardon használatos.

```
[pca9533 my_pca9533]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. Use 98 for
#   the PCA9533/1, 99 for the PCA9533/2. The default is 98.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

### [pca9632]

PCA9632 LED támogatás. A PCA9632-t a FlashForge Dreamer-ben használják.

```
[pca9632 my_pca9632]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. This may be
#   96, 97, 98, or 99.  The default is 98.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#scl_pin:
#sda_pin:
#   Alternatively, if the pca9632 is not connected to a hardware I2C
#   bus, then one may specify the "clock" (scl_pin) and "data"
#   (sda_pin) pins. The default is to use hardware I2C.
#color_order: RGBW
#   Set the pixel order of the LED (using a string containing the
#   letters R, G, B, W). The default is RGBW.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

## További szervók, gombok és egyéb tűk

### [servo]

Szervók (a "servo" előtaggal tetszőleges számú szekciót lehet definiálni). A szervók a SET_SERVO [G-Kód parancs](G-Codes.md#servo) segítségével vezérelhetők. Például: SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
pin:
#   PWM kimeneti érintkező, amely a szervót vezérli.
#   Ezt a paramétert meg kell adni.
#maximum_servo_angle: 180
#   A maximális szög (fokban), amelyre ez a szervó beállítható.
#   Az alapértelmezett érték 180 fok.
#minimum_pulse_width: 0.001
#   A minimális impulzusszélesség ideje (másodpercben).
#   Ennek 0 fokos szögnek kell megfelelnie.
#   Az alapértelmezett érték 0,001 másodperc.
#maximum_pulse_width: 0.002
#   A maximális impulzusszélesség ideje (másodpercben).
#   Ennek meg kell felelnie a maximum_servo_angle szögnek.
#   Az alapértelmezett érték 0,002 másodperc.
#initial_angle:
#   Kezdeti szög (fokban) a szervó beállításához.
#   Az alapértelmezett az, hogy indításkor nem küld jelet.
#initial_pulse_width:
#   A kezdeti impulzusszélesség (másodpercben) a szervó beállításához.
#   (Ez csak akkor érvényes, ha a initial_angle nincs beállítva.)
#   Az alapértelmezés az, hogy indításkor nem küld jelet.
```

### [gcode_button]

A G-Kód végrehajtása, amikor egy gombot megnyomnak vagy elengednek (vagy amikor egy tű állapota megváltozik). A gomb állapotát a `QUERY_BUTTON button=my_gcode_button` segítségével ellenőrizhetjük.

```
[gcode_button my_gcode_button]
pin:
#   Az a tű, amelyre a gomb csatlakozik. Ezt a paramétert meg kell adni.
#analog_range:
#   Két vesszővel elválasztott ellenállás (ohmban), amely meghatározza
#   a gomb minimális és maximális ellenállási tartományát. Ha meg van
#   adva az analog_range, akkor a lábnak analóg-képes tűnek kell lennie.
#   Az alapértelmezett a digitális GPIO használata a gombhoz.
#analog_pullup_resistor:
#   A felhúzási ellenállás (ohmban), ha az analog_range meg van adva.
#   Az alapértelmezett érték 4700 ohm.
#press_gcode:
#   A gomb megnyomásakor végrehajtandó G-Kód parancsok listája.
#   A G-Kód sablonok támogatottak. Ezt a paramétert meg kell adni.
#release_gcode:
#   A gomb elengedésekor végrehajtandó G-Kód parancsok listája.
#   A G-Kód sablonok támogatottak. Az alapértelmezés szerint nem
#   futnak le parancsok a gombok felengedésekor.
```

### [output_pin]

Futtatási időben konfigurálható kimeneti tűk (tetszőleges számú szekciót lehet definiálni "output_pin" előtaggal). Az itt konfigurált tűk kimeneti tűkként lesznek beállítva, és futtatási időben a "SET_PIN PIN=my_pin VALUE=.1" típusú kiterjesztett [G-Kód parancsok](G-Codes.md#output_pin) segítségével módosíthatjuk őket.

```
[output_pin my_pin]
pin:
#   A kimenetként konfigurálandó tű. Ezt a paramétert meg kell adni.
#pwm: False
#   Állítsa be, hogy a kimeneti lábnak képesnek kell lennie
#   impulzusszélesség-modulációra. Ha ez igaz, az értékmezőknek 0 és 1
#   között kell lenniük. Ha hamis, az értékmezők értéke 0 vagy 1 legyen.
#   Az alapértelmezett érték False.
#static_value:
#   Ha ez be van állítva, akkor a tű ehhez az értékhez lesz rendelve indításkor,
#   és a tű nem módosítható működés közben. Egy statikus tű valamivel
#   kevesebb RAM-ot használ a mikrokontrollerben.
#   Az alapértelmezett a lábak futásidejű konfigurációja.
#value:
#   Az az érték, amelyre az MCU konfigurálása során először be kell állítani a tűt.
#   Az alapértelmezett érték 0 (alacsony feszültség esetén).
#shutdown_value:
#   Az az érték, amelyre a tűt be kell állítani egy MCU leállási eseménynél.
#   Az alapértelmezett érték 0 (alacsony feszültség esetén).
#maximum_mcu_duration:
#   A nem-leállítási érték maximális időtartama az MCU által a gazdagéptől
#   érkező nyugtázás nélkül hajtható végre. Ha a gazdagép nem tud lépést
#   tartani a frissítéssel, az MCU leáll, és az összes érintkezőt a megfelelő
#   leállítási értékre állítja. Az alapértelmezett érték: 0 (letiltva)
#   A szokásos értékek 5 másodperc körüliek.
#cycle_time: 0.100
#   Az idő (másodpercben) PWM ciklusonként. Szoftver alapú PWM használata
#   esetén ajánlott 10 ezredmásodperc vagy több.
#   Az alapértelmezett érték 0,100 másodperc a PWM lábak esetén.
#hardware_pwm: False
#   Engedélyezze ezt a hardveres PWM használatához a szoftveres PWM helyett.
#   Hardveres PWM használatakor a tényleges ciklusidőt a megvalósítás
#   korlátozza, és jelentősen eltérhet a kért ciklusidőtől.
#   Az alapértelmezett érték False.
#scale:
#   Ezzel a paraméterrel módosítható a 'value' és 'shutdown_value' paraméterek
#   értelmezése a PWM lábak esetében. Ha meg van adva, akkor az 'value'
#   paraméternek 0,0 és 'scale' között kell lennie. Ez hasznos lehet olyan PWM
#   láb konfigurálásakor, amely a léptető feszültség referenciaértékét vezérli.
#   A 'scale' beállítható az egyenértékű léptető áramerősségre, ha a PWM teljesen
#   engedélyezett volt, majd az 'value' paraméter megadható a léptető kívánt
#   áramerősségével.
#   Az alapértelmezés szerint nem skálázzuk a 'value' paramétert.
```

### [static_digital_output]

Statikusan konfigurált digitális kimeneti tűk (tetszőleges számú szakasz definiálható "static_digital_output" előtaggal). Az itt konfigurált tűk az MCU konfigurálása során GPIO kimenetként lesznek beállítva. Üzem közben nem módosíthatók.

```
[static_digital_output my_output_pins]
pins:
#   A GPIO kimeneti tűként beállítandó tűk vesszővel elválasztott
#   listája. A gomb tűje magas szintre lesz állítva, hacsak a tű neve
#   előtt nem szerepel "!". Ezt a paramétert meg kell adni.
```

### [multi_pin]

Több tűs kimenetek (a "multi_pin" előtaggal tetszőleges számú szakasz definiálható). A multi_pin kimenet egy belső tű álnevet hoz létre, amely több kimeneti tűt is módosíthat minden alkalommal, amikor az álnév tű be van állítva. Például definiálhatunk egy "[multi_pin my_fan]" objektumot, amely két tűt tartalmaz, majd beállíthatjuk a "pin=multi_pin:my_fan" értéket a "[fan]" szakaszban. Minden egyes ventilátorváltáskor mindkét kimeneti tű frissül. Ezek az álnevek nem használhatók léptetőmotoros tűkkel.

```
[multi_pin my_multi_pin]
pins:
#   Az ehhez az álnévhez társított tűk vesszővel elválasztott listája.
#   Ezt a paramétert meg kell adni.
```

## TMC motorvezérlő konfigurációja

Trinamic léptetőmotor meghajtók konfigurálása UART/SPI üzemmódban. További információk a [TMC Drivers útmutatóban](TMC_Drivers.md) és a [parancsreferenciában](G-Codes.md#tmcxxxxxx) is találhatóak.

### [tmc2130]

TMC2130 motorvezérlő konfigurálása SPI-buszon keresztül. A funkció használatához definiáljon egy konfigurációs szekciót "tmc2130" előtaggal, amelyet a megfelelő léptető konfigurációs szekció neve követ (például "[tmc2130 stepper_x]").

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

TMC2208 (vagy TMC2224) motorvezérlő konfigurálása egyvezetékes UART-on keresztül. A funkció használatához definiáljon egy konfigurációs részt "tmc2208" előtaggal, amelyet a megfelelő léptető konfigurációs rész neve követ (például "[tmc2208 stepper_x]").

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

TMC2209 motorvezérlő konfigurálása egyvezetékes UART-on keresztül. A funkció használatához definiáljon egy konfigurációs szekciót "tmc2209" előtaggal, amelyet a megfelelő léptető konfigurációs szekció neve követ (például "[tmc2209 stepper_x]").

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
#   A paraméterek meghatározásához lásd a "TMC2208" részt.
#uart_address:
#   A TMC2209 chip címe UART üzenetekhez (0 és 3 közötti egész szám).
#   Ezt általában akkor használják, ha több TMC2209 chip csatlakozik
#   ugyanahhoz az UART érintkezőhöz. Az alapértelmezett érték nulla.
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
#   Állítsa be a megadott regisztert a TMC2209 chip konfigurációja során.
#   Ez egyéni motorparaméterek beállítására használható.
#   Az egyes paraméterek alapértelmezett értékei a paraméter neve
#   mellett találhatók a fenti listában.
#diag_pin:
#   A TMC2209 chip DIAG tűjéhez csatlakoztatott mikrovezérlő tűje.
#   A tű előtagja általában "^"-vel történik, hogy lehetővé tegye a
#   felhúzást. Ennek beállítása egy
#   "tmc2209_stepper_x:virtual_endstop" virtuális tűt hoz létre,
#   amely a léptető endstop_pin-jeként használható. Ez lehetővé teszi a
#   "végálláskapcsoló nélküli kezdőpont felvételt". (Győződjön meg arról,
#   hogy a driver_SGTHRS-t is megfelelő érzékenységi értékre állítja be.)
#   Alapértelmezés szerint nincs engedélyezve a végálláskapcsoló nélküli
#   kezdőpont felvételt.
```

### [tmc2660]

TMC2660 motorvezérlő konfigurálása SPI-buszon keresztül. A funkció használatához definiáljon egy konfigurációs szekciót tmc2660 előtaggal, amelyet a megfelelő léptető konfigurációs szekció neve követ (például "[tmc2660 stepper_x]").

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

### [tmc5160]

TMC5160 motorvezérlő konfigurálása SPI-buszon keresztül. A funkció használatához definiáljon egy konfigurációs szekciót "tmc5160" előtaggal, amelyet a megfelelő léptető konfigurációs szekció neve követ (például "[tmc5160 stepper_x]").

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

## Futás-idejű léptetőmotor áram konfiguráció

### [ad5206]

Statikusan konfigurált AD5206 digipotok, amelyek SPI-buszon keresztül csatlakoznak (tetszőleges számú szekciót lehet definiálni "ad5206" előtaggal).

```
[ad5206 my_digipot]
enable_pin:
# Az AD5206 chip kiválasztási vonalának megfelelő pin. Ez a pin
# az SPI-üzenetek elején alacsonyra lesz állítva, és magasra emelkedik
# az üzenet befejezése után. Ezt a paramétert meg kell adni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Lásd az "általános SPI-beállítások" című leírást a
# fenti paraméterek megadásához.
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
# Az adott AD5206 csatorna statikus beállítására szolgáló érték. Ez
# általában 0,0 és 1,0 közötti számra van állítva, ahol az 1,0 a
# legnagyobb ellenállás és 0,0 a legkisebb ellenállás. Azonban,
# a tartomány megváltoztatható a 'scale' paraméterrel (lásd alább).
# Ha egy csatorna nincs megadva, akkor konfigurálatlanul marad.
#scale:
# Ezzel a paraméterrel módosítható a 'channel_x' paraméter
# értelmezése. Ha megadja, akkor a 'channel_x' paramétereknek
# 0,0 és 'scale' között kell lennie. Ez akkor lehet hasznos, ha az
# AD5206 a léptető feszültség referenciák beállítására szolgál. A „mérleg” tud
# egyenértékű léptető áramerősséget állítani, ha az AD5206 értéken lenne
# a legnagyobb ellenállása, majd a 'channel_x' paraméterek lehetnek
# megadva a léptető kívánt amperértékével. Az
# alapértelmezés szerint nem skálázza a 'channel_x' paramétereket.
```

### [mcp4451]

Statikusan konfigurált MCP4451 digipot, amely I2C buszon keresztül csatlakozik (tetszőleges számú szekciót lehet definiálni "mcp4451" előtaggal).

```
[mcp4451 my_digipot]
i2c_address:
#   Az I2C cím, amelyet a chip az I2C buszon használ.
#   Ezt a paramétert meg kell adni.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   A fenti paraméterek leírását lásd az "általános I2C beállítások"
#   részben.
#wiper_0:
#wiper_1:
#wiper_2:
#wiper_3:
#   Az az érték, amelyre az adott MCP4451 "wiper" statikusan beállítható.
#   Ez általában 0,0 és 1,0 közötti számra van beállítva, ahol az 1,0 a
#   legnagyobb ellenállás, a 0,0 pedig a legkisebb ellenállás.
#   A tartomány azonban módosítható a 'scale' paraméterrel (lásd alább).
#   Ha nincs megadva 'wiper', akkor az konfigurálatlanul marad.
#scale:
#   Ezzel a paraméterrel módosítható a 'wiper_x' paraméterek értelmezése.
#   Ha meg van adva, akkor a 'wiper_x' paraméternek 0,0 és 'scale' között
#   kell lennie. Ez akkor lehet hasznos, ha az MCP4451-et a léptető
#   feszültségreferenciák beállítására használják. A 'scale' beállítható az
#   egyenértékű léptető áramerősségre, ha az MCP4451 a legnagyobb
#   ellenálláson volt, majd a 'wiper_x' paraméterek megadhatók a
#   léptető kívánt áramerőssége segítségével.
#   Az alapértelmezés az, hogy a 'wiper_x' paramétereket nem skálázzuk.
```

### [mcp4728]

Statikusan konfigurált MCP4728 digitális-analóg átalakító, amely I2C buszon keresztül csatlakozik (az "mcp4728" előtaggal tetszőleges számú szekciót lehet definiálni).

```
[mcp4728 my_dac]
#i2c_address: 96
#   Az I2C cím, amelyet a chip az I2C buszon használ.
#   Az alapértelmezett érték 96.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   A fenti paraméterek leírását lásd az "általános I2C beállítások"
#   részben.
#channel_a:
#channel_b:
#channel_c:
#channel_d:
#   Az adott MCP4728 csatorna statikus beállítására szolgáló érték.
#   Ez általában 0,0 és 1,0 közötti számra van beállítva, ahol az 1,0 a
#   legmagasabb feszültség (2,048 V), a 0,0 pedig a legalacsonyabb
#   feszültség. A tartomány azonban módosítható a 'scale'
#   paraméterrel (lásd alább).
#   Ha egy csatorna nincs megadva, akkor az konfigurálatlanul marad.
#scale:
#   Ez a paraméter használható a 'channel_x' paraméterek
#   értelmezésének megváltoztatására. Ha meg van adva, akkor a
#   'channel_x' paraméternek 0,0 és 'scale' között kell lennie. Ez akkor
#   lehet hasznos, ha az MCP4728-at a léptető feszültségreferenciák
#   beállítására használják. A 'scale' beállítható az egyenértékű léptető
#   áramerősségére, ha az MCP4728 a legmagasabb feszültségen volt
#   (2,048 V), majd a 'channel_x' paraméterek megadhatók a léptető
#   kívánt amperértékével. Az alapértelmezett az, hogy nem
#   méretezi a 'channel_x' paramétereket.
```

### [mcp4018]

Statikusan konfigurált MCP4018 digipot, amely két GPIO "bit banging" tűn keresztül csatlakozik (tetszőleges számú szekciót lehet definiálni "mcp4018" előtaggal).

```
[mcp4018 my_digipot]
scl_pin:
#   Az SCL "óra" tűje. Ezt a paramétert meg kell adni.
sda_pin:
#   Az SDA "adat" tűje. Ezt a paramétert meg kell adni.
wiper:
#   Az az érték, amelyre az adott MCP4018 "wiper" statikusan beállítható.
#   Ez általában 0,0 és 1,0 közötti számra van beállítva, ahol az 1,0 a
#   legnagyobb ellenállás, a 0,0 pedig a legkisebb ellenállás.
#   A tartomány azonban módosítható a 'scale' paraméterrel (lásd alább).
#   Ezt a paramétert meg kell adni.
#scale:
#   Ezzel a paraméterrel módosítható a 'wiper' paraméter értelmezése.
#   Ha van, akkor az 'wiper' paraméternek 0,0 és 'scale' között kell lennie.
#   Ez akkor lehet hasznos, ha az MCP4018-at a léptető feszültségreferenciák
#   beállítására használják. A 'scale' beállítható az egyenértékű léptető
#   áramerősségére, ha az MCP4018 a legnagyobb ellenálláson van,
#   majd a 'wiper' paraméter megadható a léptető kívánt amperértékével.
#   Az alapértelmezett beállítás az, hogy nem skálázza a 'wiper' paramétert.
```

## Kijelzőtámogatás

### [display]

A mikrokontrollerhez csatlakoztatott kijelző támogatása.

```
[display]
lcd_type:
#   The type of LCD chip in use. This may be "hd44780", "hd44780_spi",
#   "st7920", "emulated_st7920", "uc1701", "ssd1306", or "sh1106".
#   See the display sections below for information on each type and
#   additional parameters they provide. This parameter must be
#   provided.
#display_group:
#   The name of the display_data group to show on the display. This
#   controls the content of the screen (see the "display_data" section
#   for more information). The default is _default_20x4 for hd44780
#   displays and _default_16x4 for other displays.
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

#### HD44780 kijelző

Információk a HD44780 kijelzők konfigurálásáról (amelyet a "RepRapDiscount 2004 Smart Controller" típusú kijelzőkben használnak).

```
[display]
lcd_type: hd44780
#   Állítsa "hd44780" értékre a hd44780 kijelzőkhöz.
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#   A tűk egy hd44780 típusú LCD-hez csatlakoznak.
#   Ezeket a paramétereket meg kell adni.
#hd44780_protocol_init: True
#   Végezzen 8 bites/4 bites protokoll inicializálást hd44780 kijelzőn.
#   Ez szükséges a valódi hd44780-as eszközökön. Előfordulhat
#   azonban, hogy ezt bizonyos "klónozó" eszközökön le kell tiltani.
#   Az alapértelmezett érték True.
#line_length:
#   Állítsa be a soronkénti karakterek számát egy hd44780 típusú
#   LCD-n. A lehetséges értékek: 20 (alapértelmezett) és 16.
#   A sorok száma 4-re van rögzítve.
...
```

#### HD44780_SPI kijelző

Információ a HD44780_spi kijelző konfigurálásáról egy 20x04-es kijelző, egy hardveres "shift register" (amelyet a mightyboard alapú nyomtatókban használnak).

```
[display]
lcd_type: hd44780_spi
#   Állítsa be a "hd44780_spi" értéket a hd44780_spi kijelzőkhöz.
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   A kijelzőt vezérlő műszakregiszterhez csatlakoztatott tűk.
#   Az spi_software_miso_pin-t a nyomtató alaplapjának használaton
#   kívüli tűjére kell állítani, mivel a shift regiszternek nincs MISO tűje,
#   de a szoftver SPI megvalósításához ezt a tűt be kell állítani.
#hd44780_protocol_init: True
#   Végezzen 8 bites/4 bites protokoll inicializálást hd44780 kijelzőn.
#   Ez szükséges a valódi hd44780-as eszközökön. Előfordulhat
#   azonban, hogy ezt bizonyos "klónozó" eszközökön le kell tiltani.
#   Az alapértelmezett érték True.
#line_length:
#   Állítsa be a soronkénti karakterek számát egy hd44780 típusú LCD-n.
#   A lehetséges értékek: 20 (alapértelmezett) és 16.
#   A sorok száma 4-re van rögzítve.
...
```

#### ST7920 kijelző

Információk az ST7920 kijelzők konfigurálásáról (amelyet a "RepRapDiscount 12864 Full Graphic Smart Controller" típusú kijelzőknél használnak).

```
[display]
lcd_type: st7920
#   Állítsa az "st7920"-ra az st7920-as kijelzőkhöz.
cs_pin:
sclk_pin:
sid_pin:
#   A tűk egy st7920 típusú LCD-hez csatlakoznak.
#   Ezeket a paramétereket meg kell adni.
...
```

#### emulated_st7920 kijelző

Információ az emulált ST7920 kijelző konfigurálásáról. Megtalálható néhány "2,4 hüvelykes érintőképernyős eszközben" és hasonlókban.

```
[display]
lcd_type: emulated_st7920
#   Állítsa az "emulated_st7920" értékre az emulated_st7920 kijelzőkhöz.
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   Az emulált_st7920 típusú LCD-hez csatlakoztatott érintkezők.
#   Az en_pin az st7920 típusú LCD cs_pin-jének, az spi_software_sclk_pin
#   az sclk_pin-nek, az spi_software_mosi_pin pedig a sid_pin-nek felel meg.
#   A spi_software_miso_pin-t a nyomtató alaplapjának egy használaton
#   kívüli tűjére kell beállítani, mint az st7920-at, mivel nincs MISO-tű, de a
#   szoftveres SPI-megvalósításhoz ezt a tűt kell konfigurálni.
...
```

#### UC1701 kijelző

Információk az UC1701 kijelzők konfigurálásáról (amelyet az "MKS Mini 12864" típusú kijelzőknél használnak).

```
[display]
lcd_type: uc1701
#   Állítsa "uc1701" értékre az uc1701 kijelzőkhöz.
cs_pin:
a0_pin:
#   Az uc1701 típusú LCD-hez csatlakoztatott tűk.
#   Ezeket a paramétereket meg kell adni.
#rst_pin:
#   Az LCD "első" érintkezőjéhez csatlakoztatott tű. Ha nincs megadva,
#   akkor a hardvernek rendelkeznie kell egy felhúzással a
#   megfelelő LCD soron.
#contrast:
#   A beállítandó kontraszt. Az érték 0 és 63 között változhat, az
#   alapértelmezett érték pedig 40.
...
```

#### SSD1306 és SH1106 kijelzők

Az SSD1306 és SH1106 kijelzők konfigurálásával kapcsolatos információk.

```
[display]
lcd_type:
#   Állítsa be az "ssd1306" vagy az "sh1106" értéket az adott
#   megjelenítési típushoz.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   Opcionális paraméterek állnak rendelkezésre az I2C buszon
#   keresztül csatlakoztatott kijelzőkhöz. A fenti paraméterek leírását
#   lásd az "általános I2C beállítások" részben.
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Az LCD-hez csatlakoztatott érintkezők „4 vezetékes” SPI módban.
#   Az „spi_” karakterrel kezdődő paraméterek leírását a „általános
#   SPI-beállítások” részben találja. Az alapértelmezett az I2C mód
#   használata a kijelzőhöz.
#reset_pin:
#   A kijelzőn megadható egy reset tű. Ha nincs megadva, akkor a
#   hardvernek rendelkeznie kell egy felhúzással a megfelelő LCD
#   soron.
#contrast:
#   A beállítandó kontraszt. Az érték 0 és 256 között változhat, és az
#   alapértelmezett a 239.
#vcomh: 0
#   Állítsa be a Vcomh értéket a kijelzőn. Ez az érték egyes
#   OLED-kijelzők "elkenődési" hatásával jár. Az érték 0 és 63 között
#   változhat. Az alapértelmezett érték 0.
#invert: False
#   A TRUE megfordítja a képpontokat bizonyos OLED-kijelzőkön.
#   Az alapértelmezett érték False.
#x_offset: 0
#   Állítsa be a vízszintes eltolás értékét az SH1106 kijelzőkön.
#   Az alapértelmezett érték 0.
...
```

### [display_data]

Egyéni adatok megjelenítésének támogatása LCD-kijelzőn. Tetszőleges számú megjelenítési csoportot és ezek alatt tetszőleges számú adatelemet lehet létrehozni. A kijelző egy adott csoport összes adatelemét megjeleníti, ha a [display] szakaszban a display_group opciót az adott csoport nevére állítjuk.

Az [alapértelmezett kijelzőcsoportok](../klippy/extras/display/display.cfg) automatikusan létrejönnek. Ezeket a display_data elemeket a printer.cfg konfigurációs fájlban lévő alapértelmezett értékek felülírásával lehet helyettesíteni vagy bővíteni.

```
[display_data my_group_name my_data_name]
position:
#   A megjelenítési pozíció vesszővel elválasztott sora és oszlopa, amelyet
#   az információ megjelenítéséhez kell használni.
#   Ezt a paramétert meg kell adni.
text:
#   Az adott helyen megjelenítendő szöveg. Ennek a mezőnek a
#   kiértékelése parancssablonok segítségével történik
#   (lásd: docs/Command_Templates.md). Ezt a paramétert meg kell adni.
```

### [display_template]

Megjelenített adatok szövege "makrók" (tetszőleges számú szakasz definiálható display_template előtaggal). A sablonok kiértékelésével kapcsolatos információkért lásd a [parancssablonok](Command_Templates.md) dokumentumot.

Ez a funkció lehetővé teszi az ismétlődő definíciók csökkentését a display_data szakaszokban. A sablon kiértékelésére a beépített `render()` függvényt használhatjuk a display_data szakaszokban. Ha például definiálnánk `[display_template my_template]`, akkor használhatnánk a `{ render('my_template') }` függvényt a display_data szakaszban.

Ez a funkció a [SET_LED_TEMPLATE](G-Codes.md#set_led_template) parancs segítségével folyamatos LED-frissítésre is használható.

```
[display_template my_template_name]
#param_<name>:
#   One may specify any number of options with a "param_" prefix. The
#   given name will be assigned the given value (parsed as a Python
#   literal) and will be available during macro expansion. If the
#   parameter is passed in the call to render() then that value will
#   be used during macro expansion. For example, a config with
#   "param_speed = 75" might have a caller with
#   "render('my_template_name', param_speed=80)". Parameter names may
#   not use upper case characters.
text:
#   The text to return when the this template is rendered. This field
#   is evaluated using command templates (see
#   docs/Command_Templates.md). This parameter must be provided.
```

### [display_glyph]

Egy egyéni írásjel megjelenítése az azt támogató kijelzőkön. A megadott névhez hozzárendeli a megadott megjelenítési adatokat, amelyekre aztán a megjelenítési sablonokban a két "tilde" szimbólummal körülvett nevükkel lehet hivatkozni, pl. `~my_display_glyph~`.

Lásd a [sample-glyphs.cfg](../config/sample-glyphs.cfg) néhány példáját.

```
[display_glyph my_display_glyph]
#data:
#   A megjelenítési adatok 16 sorként tárolva, amelyek 16 bitből állnak
#   (pixelenként 1), ahol a '.' egy üres pixel, a '*' pedig egy bekapcsolt
#   képpont (pl. "****************" folyamatos vízszintes vonal
#   megjelenítéséhez). Alternatív megoldásként használhatunk „0”-t
#   üres pixelekhez és „1”-et a bekapcsolt pixelekhez. Helyezzen minden
#   megjelenítési sort egy külön konfigurációs sorba. A karakterjelnek
#   pontosan 16, egyenként 16 bites sorból kell állnia.
#   Ez a paraméter nem kötelező.
#hd44780_data:
#   Glyph használható 20x4 hd44780 kijelzőkön. A karakterjelnek pontosan
#   8, egyenként 5 bites sorból kell állnia. Ez a paraméter nem kötelező.
#hd44780_slot:
#   A hd44780 hardver indexe (0..7) a karakterjel tárolására. Ha több
#   különálló kép használja ugyanazt a tárat, ügyeljen arra, hogy ezek
#   közül csak egyet használjon az adott képernyőn. Ez a paraméter akkor
#   szükséges, ha a hd44780_data meg van adva.
```

### [display my_extra_display]

Ha a printer.cfg fájlban a fentiek szerint egy elsődleges [display] szakasz került meghatározásra, akkor több kiegészítő kijelzőt is lehet definiálni. Vegye figyelembe, hogy a kiegészítő kijelzők jelenleg nem támogatják a menüfunkciókat, így nem támogatják a "menu" opciókat vagy a gombok konfigurálását.

```
[display my_extra_display]
# A rendelkezésre álló paramétereket lásd a "kijelző" szakaszban.
```

### [menu]

Testreszabható LCD kijelző menük.

Egy [alapértelmezett menükészlet](../klippy/extras/display/menu.cfg) automatikusan létrejön. A menüt a fő printer.cfg konfigurációs fájlban lévő alapértelmezett értékek felülbírálásával lehet helyettesíteni vagy bővíteni.

A sablonok renderelése során elérhető menüattribútumokról a [parancssablon dokumentumban](Command_Templates.md#menu-templates) található információ.

```
# Common parameters available for all menu config sections.
#[menu __some_list __some_name]
#type: disabled
#   Permanently disabled menu element, only required attribute is 'type'.
#   Allows you to easily disable/hide existing menu items.

#[menu some_name]
#type:
#   One of command, input, list, text:
#       command - basic menu element with various script triggers
#       input   - same like 'command' but has value changing capabilities.
#                 Press will start/stop edit mode.
#       list    - it allows for menu items to be grouped together in a
#                 scrollable list.  Add to the list by creating menu
#                 configurations using "some_list" as a prefix - for
#                 example: [menu some_list some_item_in_the_list]
#       vsdlist - same as 'list' but will append files from virtual sdcard
#                 (will be removed in the future)
#name:
#   Name of menu item - evaluated as a template.
#enable:
#   Template that evaluates to True or False.
#index:
#   Position where an item needs to be inserted in list. By default
#   the item is added at the end.

#[menu some_list]
#type: list
#name:
#enable:
#   See above for a description of these parameters.

#[menu some_list some_command]
#type: command
#name:
#enable:
#   See above for a description of these parameters.
#gcode:
#   Script to run on button click or long click. Evaluated as a
#   template.

#[menu some_list some_input]
#type: input
#name:
#enable:
#   See above for a description of these parameters.
#input:
#   Initial value to use when editing - evaluated as a template.
#   Result must be float.
#input_min:
#   Minimum value of range - evaluated as a template. Default -99999.
#input_max:
#   Maximum value of range - evaluated as a template. Default 99999.
#input_step:
#   Editing step - Must be a positive integer or float value. It has
#   internal fast rate step. When "(input_max - input_min) /
#   input_step > 100" then fast rate step is 10 * input_step else fast
#   rate step is same input_step.
#realtime:
#   This attribute accepts static boolean value. When enabled then
#   gcode script is run after each value change. The default is False.
#gcode:
#   Script to run on button click, long click or value change.
#   Evaluated as a template. The button click will trigger the edit
#   mode start or end.
```

## Nyomtatószál érzékelők

### [filament_switch_sensor]

Nyomtatószál érzékelő. Támogatás a nyomtatószál behelyezésének és kifutásának érzékelésére kapcsolóérzékelő, például végálláskapcsoló segítségével.

További információkért lásd a [parancs hivatkozást](G-Codes.md#filament_switch_sensor).

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
#switch_pin:
#   The pin on which the switch is connected. This parameter must be
#   provided.
```

### [filament_motion_sensor]

Nyomtatószál mozgásérzékelő. Támogatja a nyomtatószál behelyezésének és kifutásának érzékelését egy olyan kódoló segítségével, amely az érzékelőn keresztül történő mozgás közben váltogatja a kimeneti jelet.

További információkért lásd a [parancs hivatkozást](G-Codes.md#filament_switch_sensor).

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#   Az érzékelőn áthúzott nyomtatószál minimális hossza, amely
#   állapotváltozást vált ki a switch_pin tűn.
#   Az alapértelmezett érték 7mm.
extruder:
#   Az extruderrész neve, amelyhez ez az érzékelő kapcsolódik.
#   Ezt a paramétert meg kell adni.
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   A fenti paraméterek leírását a "filament_switch_sensor"
#   részben találja.
```

### [tsl1401cl_filament_width_sensor]

TSLl401CL alapú szálszélesség érzékelő. További információkért lásd az [útmutatót](TSL1401CL_Filament_Width_Sensor.md).

```
[tsl1401cl_filament_width_sensor]
#pin:
#default_nominal_filament_diameter: 1.75 # (mm)
#   A nyomtatószál átmérőjének megengedett legnagyobb
#   eltérése mm-ben.
#max_difference: 0.2
#   Az érzékelő és a fúvóka közötti távolság mm-ben.
#measurement_delay: 100
```

### [hall_filament_width_sensor]

Hall szálszélesség érzékelő (lásd [Hall szálszélesség érzékelő](Hall_Filament_Width_Sensor.md)).

```
[hall_filament_width_sensor]
adc1:
adc2:
#   Analog input pins connected to the sensor. These parameters must
#   be provided.
#cal_dia1: 1.50
#cal_dia2: 2.00
#   The calibration values (in mm) for the sensors. The default is
#   1.50 for cal_dia1 and 2.00 for cal_dia2.
#raw_dia1: 9500
#raw_dia2: 10500
#   The raw calibration values for the sensors. The default is 9500
#   for raw_dia1 and 10500 for raw_dia2.
#default_nominal_filament_diameter: 1.75
#   The nominal filament diameter. This parameter must be provided.
#max_difference: 0.200
#   Maximum allowed filament diameter difference in millimeters (mm).
#   If difference between nominal filament diameter and sensor output
#   is more than +- max_difference, extrusion multiplier is set back
#   to %100. The default is 0.200.
#measurement_delay: 70
#   The distance from sensor to the melting chamber/hot-end in
#   millimeters (mm). The filament between the sensor and the hot-end
#   will be treated as the default_nominal_filament_diameter. Host
#   module works with FIFO logic. It keeps each sensor value and
#   position in an array and POP them back in correct position. This
#   parameter must be provided.
#enable: False
#   Sensor enabled or disabled after power on. The default is to
#   disable.
#measurement_interval: 10
#   The approximate distance (in mm) between sensor readings. The
#   default is 10mm.
#logging: False
#   Out diameter to terminal and klipper.log can be turn on|of by
#   command.
#min_diameter: 1.0
#   Minimal diameter for trigger virtual filament_switch_sensor.
#use_current_dia_while_delay: False
#   Use the current diameter instead of the nominal diameter while
#   the measurement delay has not run through.
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   See the "filament_switch_sensor" section for a description of the
#   above parameters.
```

## Alaplap specifikus hardvertámogatás

### [sx1509]

Konfiguráljon egy SX1509 I2C-GPIO bővítőt. Az I2C-kommunikáció által okozott késleltetés miatt NEM szabad az SX1509 tűit motorvezérlő engedélyező, STEP vagy DIR tűként vagy bármilyen más olyan tűként használni, amely gyors bit-impulzust igényel. Legjobban statikus vagy G-Kód vezérelt digitális kimenetekként vagy hardveres PWM tűként használhatók pl. ventilátorokhoz. Bármennyi szekciót definiálhatunk "sx1509" előtaggal. Minden egyes bővítő egy 16 tűből álló készletet biztosít (sx1509_my_sx1509:PIN_0-tól sx1509_my_sx1509:PIN_15-ig), amelyek a nyomtató konfigurációjában használhatók.

Lásd a [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg) fájlt egy példáért.

```
[sx1509 my_sx1509]
i2c_address:
#   A bővítő által használt I2C cím. A hardveres jumperektől
#   függően ez a következő címek egyike: 62 63 112 113.
#   Ezt a paramétert meg kell adni.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   A fenti paraméterek leírását lásd az "általános I2C beállítások"
#   részben.
#i2c_bus:
#   Ha a mikrovezérlő I2C megvalósítása több I2C buszt is támogat,
#   itt megadhatja a busz nevét.
#   Az alapértelmezett a mikrovezérlő I2C busz használata.
```

### [samd_sercom]

SAMD SERCOM konfiguráció annak megadására, hogy mely tűket kell használni egy adott SERCOM-on. A "samd_sercom" előtaggal tetszőleges számú szekciót definiálhatunk. Minden SERCOM-ot konfigurálni kell, mielőtt SPI vagy I2C perifériaként használnánk. Helyezze ezt a konfigurációs szekciót minden más, SPI vagy I2C buszokat használó szekció fölé.

```
[samd_sercom my_sercom]
sercom:
#   The name of the sercom bus to configure in the micro-controller.
#   Available names are "sercom0", "sercom1", etc.. This parameter
#   must be provided.
tx_pin:
#   MOSI pin for SPI communication, or SDA (data) pin for I2C
#   communication. The pin must have a valid pinmux configuration
#   for the given SERCOM peripheral. This parameter must be provided.
#rx_pin:
#   MISO pin for SPI communication. This pin is not used for I2C
#   communication (I2C uses tx_pin for both sending and receiving).
#   The pin must have a valid pinmux configuration for the given
#   SERCOM peripheral. This parameter is optional.
clk_pin:
#   CLK pin for SPI communication, or SCL (clock) pin for I2C
#   communication. The pin must have a valid pinmux configuration
#   for the given SERCOM peripheral. This parameter must be provided.
```

### [adc_scaled]

Duet2 Maestro analóg skálázás vref és vssa leolvasások alapján. Az adc_scaled szakasz definiálása virtuális adc-tűként (például "my_name:PB0") tesz lehetővé, amelyeket automatikusan a kártya vref és vssa figyelőtűi állítanak be. Ügyeljen arra, hogy ezt a konfigurációs szakaszt minden olyan konfigurációs szakasz felett definiálja, amely ezeket a virtuális tűket használja.

Lásd a [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg) fájlt egy példáért.

```
[adc_scaled my_name]
vref_pin:
# A VREF monitorozásához használt ADC pin. Ezt a paramétert meg kell adni.
vssa_pin:
# A VSSA monitorozásához használandó ADC pin. Ezt a paramétert meg kell adni.
#smooth_time: 2.0
# Egy időérték (másodpercben), amely alatt a vref és a vssa
# mérések simításra kerülnek, hogy csökkentsék a mérés hatását
# zaj csökkentése érdekében. Az alapértelmezett érték 2 másodperc.
```

### [replicape]

Replicape támogatás. Lásd a [beaglebone útmutatót](Beaglebone.md) és a [generic-replicape.cfg](../config/generic-replicape.cfg) fájlt egy példáért.

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

## Egyéb egyedi modulok

### [palette2]

Palette 2 multimaterial támogatás szorosabb integrációt biztosít, amely támogatja a Palette 2 eszközöket csatlakoztatott módban.

Ez a modul a teljes funkcionalitáshoz a `[virtual_sdcard]` és `[pause_resume]` modulokat is igényli.

Ha ezt a modult használja, ne használja a Palette 2 plugint az Octoprinthez, mivel ezek ütközni fognak, és az egyik nem fog megfelelően inicializálódni, ami valószínűleg megszakítja a nyomtatást.

Ha az Octoprintet használja és a gcode-ot a soros porton keresztül streameli a virtual_sd-ről való nyomtatás helyett, akkor a **M1** és **M0** parancsok *Pausing parancsok* a *Settings >. alatt remo; Serial Connection > Firmware & protocol* megakadályozzák, hogy a nyomtatás megkezdéséhez a Paletta 2-n el kelljen indítani a nyomtatást, és az Octoprintben fel kelljen oldani a szünetet.

```
[paletta2]
serial:
# A soros port, amelyhez a Palette 2 csatlakozik.
#baud: 115200
# A használandó baud-ráta. Az alapértelmezett érték 115200.
#feedrate_splice: 0.8
# A toldáskor használandó feedrate, alapértelmezett 0.8.
#feedrate_normal: 1.0
# A toldás után használandó feedrate, alapértelmezett értéke 1.0.
#auto_load_speed: 2
# Extrudálási előtolási sebesség automatikus betöltéskor, alapértelmezett 2 (mm/s)
#auto_cancel_variation: 0.1
# Automatikusan törli a nyomtatást, ha a ping variáció meghaladja ezt a küszöbértéket.
```

### [angle]

Mágneses Hall-szögérzékelő támogatása A1333, AS5047D vagy TLE5012B SPI-chipek használatával a léptetőmotorok szögtengelyének méréseinek leolvasásához. A mérések az [API Szerver](API_Server.md) és a [mozgáselemző eszköz](Debugging.md#motion-analysis-and-data-logging) segítségével érhetők el. A rendelkezésre álló parancsokat lásd a [G-Kód hivatkozásban](G-Codes.md#angle).

```
[angle my_angle_sensor]
sensor_type:
# A mágneses hall chip típusa. A rendelkezésre álló lehetőségek a következők
# "a1333", "as5047d" és "tle5012b". Ennek a paraméternek a következőnek kell lennie
# meg kell adni.
#sample_period: 0.000400
# A mérések során használandó lekérdezési időszak (másodpercben). Az
# alapértelmezett értéke 0.000400 (ami 2500 mintát jelent másodpercenként).
#stepper:
# Annak a léptetőnek a neve, amelyhez a szögérzékelő csatlakozik (pl,
# "stepper_x"). Ennek az értéknek a beállítása lehetővé teszi a szögkalibrálást.
# A funkció használatához a Python "numpy" csomagot kell használni telepíteni.
# Az alapértelmezett beállítás szerint nem engedélyezi a szögkalibrációt.
cs_pin:
# Az érzékelő SPI engedélyező tűje. Ezt a paramétert meg kell adni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Lásd a "közös SPI beállítások" fejezetet a hiányzó paraméterek leírásával.
```

## Gyakori buszparaméterek

### Gyakori SPI beállítások

Az SPI-buszt használó eszközök esetében általában a következő paraméterek állnak rendelkezésre.

```
#spi_speed:
#   The SPI speed (in hz) to use when communicating with the device.
#   The default depends on the type of device.
#spi_bus:
#   If the micro-controller supports multiple SPI busses then one may
#   specify the micro-controller bus name here. The default depends on
#   the type of micro-controller.
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Specify the above parameters to use "software based SPI". This
#   mode does not require micro-controller hardware support (typically
#   any general purpose pins may be used). The default is to not use
#   "software spi".
```

### Gyakori I2C beállítások

A következő paraméterek általában az I2C-buszt használó eszközökhöz állnak rendelkezésre.

```
#i2c_address:
# Az eszköz I2C címe. Ezt decimális értékként kell megadni.
# számként kell megadni (nem hexa számként). Az alapértelmezett érték az eszköz típusától függ.
#i2c_mcu:
# Annak a mikrokontrollernek a neve, amelyhez a chip csatlakozik.
# Az alapértelmezett érték "mcu".
#i2c_bus:
# Ha a mikrokontroller több I2C-buszt is támogat, akkor az egyiket
# itt megadhatjuk a mikrokontroller buszának nevével. Az alapértelmezés függ a
# a mikrokontroller típusától.
#i2c_speed:
# Az eszközzel való kommunikáció során használandó I2C sebesség (Hz-ben).
# Egyes mikrovezérlőknél ennek az értéknek a megváltoztatása nincs hatással. Az
# alapértelmezett érték 100000.
```
