# Konfigurációs hivatkozás

Ez a dokumentum a Klipper konfigurációs fájlban elérhető beállítások referenciája.

Az ebben a dokumentumban található leírások úgy vannak formázva, hogy kivághatóak és beilleszthetőek legyenek egy nyomtató konfigurációs fájljába. A Klipper beállításával és a kezdeti konfigurációs fájl kiválasztásával kapcsolatos információkért lásd a [telepítési dokumentumot](Installation.md).

## Mikrokontroller konfiguráció

### A mikrokontroller tű neveinek formátuma

Számos konfigurációs beállításhoz egy mikrokontroller-tű nevére van szükség. A Klipper a hardveres neveket használja ezekhez a tűkhöz - például `PA4`.

A tű nevek előtt `!` állhat, hogy jelezze ilyenkor fordított polaritást használ (pl. magas helyett alacsony értéken történő trigger).

A bemeneti tűk előtt `^` jelezheti, hogy a tűhöz hardveres pull-up ellenállást kell engedélyezni. Ha a mikrokontroller támogatja a pull-down ellenállásokat, akkor egy bemeneti tű előtt `~` állhat.

Megjegyzés: egyes konfigurációs szakaszok további tűket hozhatnak létre. Ahol ez előfordul, ott a tűket definiáló konfigurációs szekciót a konfigurációs fájlban az ezeket a tűket használó szekciók előtt kell felsorolni.

### [mcu]

Az elsődleges mikrokontroller konfigurálása.

```
[mcu]
serial:
#   Az MCU-hoz csatlakoztatandó soros port. Ha bizonytalan (vagy a
#   változtatásban), lásd a GYIK "Hol van a soros port?" részét.
#   Ezt a paramétert soros port használata esetén meg kell adni.
#baud: 250000
#   A használandó átviteli sebesség.
#   Az alapértelmezett érték 250000.
#canbus_uuid:
#   Ha CAN-buszra csatlakoztatott eszközt használunk, akkor ez állítja
#   be az egyedi chip azonosítóját, amelyhez csatlakozni kell.
#   Ezt az értéket meg kell adni, a CAN busz használata esetén.
#canbus_interface:
#   Ha CAN-buszra csatlakoztatott eszközt használunk, akkor ez állítja
#   be a CAN hálózati interfészt. Az alapértelmezett érték 'can0'.
#restart_method:
#   Ez szabályozza azt a mechanizmust, amelyet a gazdagép használjon a
#   mikrokontroller újraindításához. A választható lehetőségek: 'arduino',
#   'cheetah', 'rpi_usb', és 'command'. Az 'arduino' módszer
#   (DTR kapcsolása) a következő eszközökön gyakori. Arduino kártyák
#   és klónok. A 'cheetah' módszer egy speciális módszer, amely néhány
#   Fysetc Cheetah kártyához szükséges. Az 'rpi_usb' módszer hasznos
#   a Raspberry Pi lapokon, amelyek mikrovezérlőkkel vannak ellátva.
#   USB-n keresztül rövid időre kikapcsolja az összes USB port
#   áramellátását, hogy a mikrokontroller újrainduljon. A 'command'
#   módszer a következőket foglalja magában. Klipper parancsot küld
#   a mikrokontrollernek, hogy az képes legyen újraindítani magát.
#   Az alapértelmezett beállítás az 'arduino' ha a mikrokontroller
#   soros porton keresztül kommunikál, egyébként 'command'.
```

### [mcu my_extra_mcu]

További mikrovezérlők (az "mcu" előtaggal tetszőleges számú szekciót lehet definiálni). A további mikrovezérlők további tűket vezetnek be, amelyek fűtőberendezésként, léptetőberendezésként, ventilátorként stb. konfigurálhatók. Például, ha egy "[mcu extra_mcu]" szekciót vezetünk be, akkor az olyan tűket, mint az "extra_mcu:ar9" a konfigurációban máshol is használhatók (ahol "ar9" az adott mcu hardveres tű neve vagy álneve).

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
#   A használt nyomtató típusa. Ez az opció a következők egyike lehet:
#   cartesian, corexy, corexz, hybrid_corexy, hybrid_corexz, rotary_delta,
#   delta, delta, polar, csörlő, vagy egyik sem.
#   Ezt a paramétert meg kell adni.
max_velocity:
#   A nyomtatófej maximális sebessége (mm/s-ban)
#   (a nyomathoz viszonyítva). Ezt a paramétert meg kell adni.
max_accel:
#   A nyomtatófej maximális gyorsulása (mm/s^2-ben)
#   (a nyomtatóhoz viszonyítva). Ezt a paramétert meg kell adni.
#max_accel_to_decel:
#   Álgyorsulás (mm/s^2-ben), amely azt szabályozza, hogy a nyomtatófej
#   milyen gyorsan haladjon gyorsulásról a lassításra. A rövid cikk-cakk
#   mozgások maximális sebességének csökkentésére szolgál
#   (és ezáltal csökkenti a nyomtató rezgését ezekből a lépésekből).
#   Az alapértelmezett érték a max_accel fele.
#square_corner_velocity: 5.0
#   Az a maximális sebesség (mm/s-ban), amellyel a nyomtatófej egy
#   90 fokos sarokban haladhat. A nullától eltérő érték csökkentheti az 
#   extruder áramlási sebességének változásait azáltal, hogy lehetővé teszi
#   a nyomtatófej azonnali sebességváltozását kanyarodás közben.
#   Ez az érték konfigurálja a belső centripetális sebesség
#   kanyarodási algoritmusát; a 90 foknál nagyobb szögű sarkok
#   kanyarodási sebessége nagyobb, míg a 90 foknál kisebb szögű sarkok
#   kanyarsebessége kisebb. Ha ez nullára van állítva, akkor a nyomtatófej
#   minden sarkánál nullára lassul. Az alapértelmezett érték 5 mm/s.
```

### [stepper]

Léptetőmotor meghatározások. A különböző nyomtatótípusok (a [printer] config szakasz "kinematika" opciója által meghatározottak szerint) eltérő neveket igényelnek a léptető számára (pl. `stepper_x` vs `stepper_a`). Az alábbiakban a stepper-ek általános definíciói következnek.

A `rotation_distance` paraméter kiszámításával kapcsolatos információkért lásd a [forgatási távolság dokumentumot](Rotation_Distance.md). A több mikrovezérlővel történő kezdőpont felvétellel kapcsolatos információkért lásd a [Multi-MCU kezdőpont](Multi_MCU_Homing.md) dokumentumot.

```
[stepper_x]
step_pin:
#   Lépés GPIO tű (magasan aktiválva). Ezt a paramétert meg kell adni.
dir_pin:
#   Irány GPIO tű (magas pozitív irányt jelez). Ezt a paramétert meg kell adni.
enable_pin:
#   Engedélyezett tű (az alapértelmezett engedélyezés magas; használd a
#   "!" jelet az engedélyezés alacsony szintjének jelzésére). Ha ez a
#   paraméter nincs megadva, akkor a léptetőmotor meghajtót mindig
#   engedélyezni kell.
rotation_distance:
#   Az a távolság (mm-ben), amelyet a tengely megtesz a léptetőmotor egy
#   teljes fordulatával (vagy végső sebességfokozattal, ha a gear_ratio meg
#   van adva). Ezt a paramétert meg kell adni.
microsteps:
#   A léptetőmotor-vezérlő által használt mikrolépések száma.
#   Ezt a paramétert meg kell adni.
#full_steps_per_rotation: 200
#   A léptetőmotor egy fordulatához tartozó teljes lépések száma. Állítsd ezt
#   200-ra 1,8 fokos léptetőmotor esetén, vagy 400-ra 0,9 fokos motor esetén.
#   Az alapértelmezett érték 200.
#gear_ratio:
#   Az áttétel, ha a léptetőmotor egy sebességváltón keresztül csatlakozik a
#   tengelyhez. Például megadhatod az "5:1" értéket, ha 5:1 sebességváltót
#   használnak. Ha a tengely több sebességváltóval rendelkezik, megadhat
#   egy vesszővel elválasztott áttételi listát (például "57:11, 2:1"). Ha a
#   gear_ratio meg van adva, akkor a rotation_distance azt a távolságot
#   határozza meg, amelyet a tengely megtesz a végső fogaskerék egy teljes
#   fordulatánál. Az alapértelmezés szerint nem használ áttételi arányt.
#step_pulse_duration:
#   A minimális idő a léptető impulzus jel éle és a következő "lépésköz" jel
#   éle között. Ez a lépés impulzus és az irányváltó jel közötti minimális idő
#   beállítására is használható. Az alapértelmezett érték 0,000000100 (100 ns)
#   az UART vagy SPI módban konfigurált TMC léptetők esetében, és az
#   alapértelmezett 0,000002 (ami 2us) az összes többi léptető esetében.
endstop_pin:
#   Végálláskapcsoló érzékelési tű. Ha ez a végütköző tű más MCU-n van,
#   mint a léptetőmotor, akkor engedélyezi a "multi-mcu homing"-ot.
#   Ezt a paramétert meg kell adni a derékszögű nyomtatók X, Y és Z
#   léptetőihez.
#position_min: 0
#   Minimális érvényes távolság (mm-ben), amelyre a felhasználó utasíthatja
#   a léptetőt, hogy mozogjon. Az alapértelmezett érték 0 mm.
position_endstop:
#   A végálláskapcsoló helye (mm-ben).
#   Ezt a paramétert meg kell adni a derékszögű nyomtatók X, Y és Z
#   léptetőihez.
position_max:
#   Maximális érvényes távolság (mm-ben), amelyre a felhasználó utasíthatja
#   a léptetőt, hogy mozogjon. Ezt a paramétert meg kell adni a derékszögű
#   nyomtatók X, Y és Z léptetőihez.
#homing_speed: 5.0
#   A léptető maximális sebessége (mm/sec-ben) kezdőpont felvételkor.
#   Az alapértelmezett érték 5 mm/sec.
#homing_retract_dist: 5.0
#   Távolság a visszalépésig (mm-ben), mielőtt másodszor is beállítaná.
#   Állítsd ezt nullára a második kezdőpont felvétel letiltásához.
#   Az alapértelmezett érték 5 mm.
#homing_retract_speed:
#   Sebesség, amelyet a visszahúzásnál kell használni a kezdőpont felvétel
#   után arra az esetre, ha ez eltérne a beállítási sebességtől, amely ehhez a
#   paraméterhez az alapértelmezett.
#second_homing_speed:
#   A léptető sebessége (mm/sec-ben) a második kezdőpont felvétel
#   végrehajtásakor. Az alapértelmezés a homing_speed/2.
#homing_positive_dir:
#   Ha ez True, a kezdőpont felvétel hatására a léptető pozitív irányba mozdul
#   el (el a nullától) ha False, akkor kezdőpontra a nulla felé. Jobb az
#   alapértelmezettet használni, mint ezt a paramétert megadni.
#   Az alapértelmezett érték True, ha a position_endstop a position_max
#   közelében van, és False, ha a position_min közelében van.
```

### Cartesian Kinematika

Lásd [example-cartesian.cfg](../config/example-cartesian.cfg) egy példa cartesian kinematika konfigurációs fájlhoz.

Itt csak a cartesian nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

```
[printer]
kinematics: cartesian
max_z_velocity:
#   Ez állítja be a Z irányú mozgás maximális sebességét (mm/sec-ben).
#   Ez a beállítás használható a maximális sebesség korlátozására a
#   a Z léptetőmotor esetében. Az alapértelmezés szerint a max_velocity a következő értékekre vonatkozik
# max_z_velocity.
max_z_accel:
#   Ez állítja be a mozgás maximális gyorsulását (mm/sec^2-ben)
#   a Z tengely mentén. Korlátozza a Z léptetőmotor gyorsulását. Az
#   alapértelmezett a max_accel használata a max_z_accel esetében.

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

Lásd az [example-delta.cfg](../config/example-delta.cfg) példát a lineáris delta kinematika konfigurációs fájljához. A kalibrálással kapcsolatos információkért lásd a [delta kalibrációs](Delta_Calibrate.md) dokumentumot.

Itt csak a lineáris delta nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

```
[printer]
kinematics: delta
max_z_velocity:
#   A delta nyomtatóknál ez korlátozza a Z tengely mozgásának maximális
#   sebességét (mm/sec-ben). Ezzel a beállítással csökkenthető a fel/le
#   mozgások maximális sebessége (amely nagyobb lépésszámot igényel,
#   mint a deltanyomtatók egyéb mozgásai). Az alapértelmezett érték a
#   max_velocity használata a max_z_velocity értékhez.
#max_z_accel:
#   Ez beállítja a Z tengely mentén történő mozgás maximális gyorsulását
#   (mm/sec^2-en). Ennek beállítása akkor lehet hasznos, ha a nyomtató
#   nagyobb gyorsulást tud elérni XY mozgásnál, mint Z mozgásnál (pl.
#   bemeneti alakformáló használatakor).
#   Az alapértelmezés szerinti értéke a max_accel a max_z_accel értékhez.
#minimum_z_position: 0
#   Az a minimális Z pozíció, amelybe a felhasználó utasíthatja a fejet,
#   hogy mozogjon. Az alapértelmezett érték 0.
delta_radius:
#   A három lineáris tengely torony által alkotott vízszintes kör sugara
#   (mm-ben). Ez a paraméter a következőképpen is kiszámítható:
#   delta_radius = smooth_rod_offset - effector_offset - carriage_offset.
#   Ezt a paramétert meg kell adni.
#print_radius:
#   Az érvényes XY nyomtatófej koordináták sugara (mm-ben). Ezzel a
#   beállítással testreszabható a nyomtatófej mozgások tartomány
#   ellenőrzése. Ha itt nagy értéket adunk meg, akkor lehetséges lehet
#   a nyomtatófejet toronnyal való ütközésre utasítani.
#   Az alapértelmezett a delta_radius a print_radius értékhez (ami
#   általában megakadályozza a torony ütközését).

# A stepper_a szakasz a bal első tornyot vezérlő léptetőt írja le
# (210 fokban). Ez a szakasz az összes toronyhoz tartozó kezdőpont
# paramétereket (homing_speed, homing_retract_dist) is szabályozza.
[stepper_a]
position_endstop:
#   Távolság (mm-ben) a fúvóka és a tárgyasztal között, ha a fúvóka az építési
#   terület közepén van, és a végütköző kiold. Ezt a paramétert meg kell
#   adni a stepper_a; a stepper_b és a stepper_c esetén ez a paraméter
#   alapértelmezett értéke a stepper_a paraméterben megadott érték.
arm_length:
#   A tornyot a nyomtatófejjel összekötő átlós rúd hossza (mm-ben).
#   Ezt a paramétert meg kell adni a stepper_a; a stepper_b és a stepper_c
#   esetén ez a paraméter alapértelmezett értéke a stepper_a
#   paraméterben megadott érték.
#angle:
#   Ez az opció azt a szöget adja meg (fokban), amelyben a torony áll.
#   Az alapértelmezett érték 210 a stepper_a, 330 a stepper_b és
#   90 a stepper_c.

# A stepper_b szakasz a jobb első tornyot vezérlő léptetőt írja le
# (330 fokban).
[stepper_b]

# A stepper_c szakasz a hátsó tornyot vezérlő léptetőt írja le (90 fokban).
[stepper_c]

# A delta_calibrate szakasz lehetővé teszi a DELTA_CALIBRATE
# kiterjesztett G-kód parancsot, amely képes kalibrálni a torony
# végállásának pozícióit és szögeit.
[delta_calibrate]
radius:
#   A vizsgálható terület sugara (mm-ben). Ez a vizsgálandó
#   fúvókakoordináták sugara; Ha XY eltolású automata szondát használ,
#   akkor válasszon elég kicsi sugarat, hogy a szonda mindig a tárgyasztal fölé
#   férjen. Ezt a paramétert meg kell adni.
#speed: 50
#   A nem szondázás sebessége (mm/sec-ben) mozog a kalibrálás során.
#   Az alapértelmezett érték 50.
#horizontal_move_z: 5
#   Az a magasság (mm-ben), ameddig a fejnek el kell mozdulnia
#   közvetlenül a szondaművelet megkezdése előtt.
#   Az alapértelmezett érték 5.
```

### Deltesian Kinematika

Lásd [example-deltesian.cfg](../config/example-deltesian.cfg) egy példa deltesian kinematika konfigurációs fájlhoz.

Itt csak a deltesian nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd a [általános kinematikai beállítások](#altalanos-kinematikai-beallitasok) pontban.

```
[printer]
kinematics: deltesian
max_z_velocity:
#   Deltesian nyomtatóknál ez korlátozza a Z tengely mozgásának maximális
#   sebességét (mm/s-ban). Ezzel a beállítással csökkenthető a fel/le
#   mozgások maximális sebessége (amelyek nagyobb lépésszámot
#   igényelnek, mint egy deltesian nyomtató egyéb lépései).
#   Az alapértelmezett a max_velocity a max_z_velocity értékhez.
#max_z_accel:
#   Ez beállítja a Z tengely mentén történő mozgás maximális gyorsulását
#   (mm/s^2-ben). Ennek beállítása akkor lehet hasznos, ha a nyomtató
#   nagyobb gyorsulást tud elérni XY mozgásnál, mint Z mozgásnál
#   (pl. bemeneti alakformáló használatakor).
#   Az alapértelmezett a max_accel a max_z_accel értékhez.
#minimális_z_pozíció: 0
#   Az a minimális Z pozíció, amelybe a felhasználó utasíthatja a fejet, hogy
#   mozogjon. Az alapértelmezett érték 0.
#min_angle: 5
#   Ez azt a minimális szöget (fokban) jelenti a vízszinteshez képest, amelyet
#   a deltesian karok elérhetnek. Ennek a paraméternek az a célja, hogy
#   megakadályozza, a karok teljesen vízszintesbe mozgatását, ami az XZ
#   tengely véletlen megfordulását kockáztatná. Az alapértelmezett érték 5.
#print_width:
#   Az érvényes nyomtatófej X koordináták távolsága (mm-ben). Ezzel a
#   beállítással testreszabható a nyomtatófej mozgások tartományellenőrzése.
#   Ha itt nagy értéket adunk meg, akkor előfordulhat, hogy a nyomtatófejet a
#   toronnyal való ütközésre utasíthatjuk.
#   Ez a beállítás általában a tárgyasztal szélességnek felel meg (mm-ben).
#slow_ratio: 3
#   Az az arány, amely korlátozza a sebességet és a gyorsulást az X tengely
#   szélső pontjaihoz közeli mozgásoknál. Ha a függőleges távolság osztva a
#   vízszintes távolsággal meghaladja a slow_ratio értékét, akkor a sebesség és
#   a gyorsulás a névleges értékük felére korlátozódik. Ha a függőleges távolság
#   osztva a vízszintes távolsággal meghaladja a slow_ratio értékének
#   kétszeresét, akkor a sebesség és a gyorsulás a névleges értékük
#   egynegyedére korlátozódik. Az alapértelmezett érték a 3.

#   A stepper_left szakasz a bal tornyot vezérlő léptető leírására szolgál.
#   Ez a szakasz az összes toronyhoz tartozó homing paramétereket
#   (homing_speed, homing_retract_dist) is szabályozza.
[stepper_left]
position_endstop:
#   Távolság (mm-ben) a fúvóka és a tárgyasztal között, ha a fúvóka az építési terület
#   közepén van, és a végütközők kioldódnak. Ezt a paramétert meg kell adni a
#   stepper_left; a stepper_right esetén ez a paraméter alapértelmezett értéke
#   a stepper_left paraméterben megadott érték.
arm_length:
#   A toronykocsit a nyomtatófejjel összekötő átlós rúd hossza (mm-ben).
#   Ezt a paramétert meg kell adni a stepper_left; a stepper_right esetén ez a
#   paraméter alapértelmezett értéke a stepper_left paraméter megadott értéke.
arm_x_length:
#   Vízszintes távolság a nyomtatófej és a torony között, ha minden
#   kezdőponton van. Ezt a paramétert meg kell adni a stepper_left; a
#   stepper_right esetén ez a paraméter alapértelmezett értéke a
#   stepper_left paraméterben megadott érték.

#   A stepper_right szekció a jobb oldali tornyot vezérlő léptető leírására szolgál.
[stepper_right]

#   A stepper_y szakasz az Y tengelyt vezérlő léptető leírására szolgál
#   egy deltesian gépen.
[stepper_y]
```

### CoreXY Kinematika

Lásd [example-corexy.cfg](../config/example-corexy.cfg) egy példa corexy (és h-bot) kinematikai fájlt.

Itt csak a CoreXY nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

```
[printer]
kinematics: corexy
max_z_velocity:
#   Ez állítja be a Z irányú mozgás maximális sebességét (mm/sec-ben).
#   Ez a beállítás használható a Z léptetőmotor maximális sebességkorlátozására.
#   Az alapértelmezés szerint a max_velocity a következő értékekre vonatkozik
#   amely a max_z_velocity.
max_z_accel:
#   Ez állítja be a mozgás maximális gyorsulását (mm/sec^2 -ben)
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
#   Ez állítja be a Z irányú mozgás maximális sebességét (mm/sec-ben).
#   Ez a beállítás használható a Z léptetőmotor maximális sebességkorlátozására.
#   Az alapértelmezés szerint a max_velocity a következő értékekre vonatkozik
#   amely a max_z_velocity.
max_z_accel:
#   Ez állítja be a mozgás maximális gyorsulását (mm/sec^2 -ben)
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
#   Ez beállítja a Z tengely mentén történő mozgás maximális sebességét (mm/sec-ben).
#   Az alapértelmezett érték a max_velocity használata a max_z_velocity értékhez.
max_z_accel:
#   Ez beállítja a Z tengely mentén történő mozgás maximális gyorsulását (mm/sec^2-en).
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
#   Ez beállítja a Z tengely mentén történő mozgás maximális sebességét (mm/sec-ben).
#   Az alapértelmezett érték a max_velocity használata a max_z_velocity értékhez.
max_z_accel:
#   Ez beállítja a Z tengely mentén történő mozgás maximális gyorsulását (mm/sec^2-en).
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
#   Ez beállítja a maximális mozgási sebességet (mm/sec-ben) a Z tengely
#   mentén. Ezzel a beállítással korlátozható a Z léptetőmotor maximális
#   sebessége. Az alapértelmezett érték a max_velocity használata a
#   max_z_velocity értékhez.
max_z_accel:
#   Ez beállítja a Z tengely mentén történő mozgás maximális gyorsulását
#   (mm/sec^2-en). Korlátozza a Z léptetőmotor gyorsulását.
#   Az alapértelmezés szerint a max_accel értéke a max_z_accel.

# A stepper_bed szakasz a tárgyasztalt vezérlő stepper leírására szolgál.
[stepper_bed]
gear_ratio:
#   Meg kell adni a gear_ratio értéket, és a rotation_distance nem adható
#   meg. Például, ha a tárgyasztal egy 80 fogas kerékkel rendelkezik, amelyet
#   egy léptetőmotor hajt meg egy 16 fogas kerékkel, akkor a „80:16”
#   áttételi arányt kell megadni. Ezt a paramétert meg kell adni.

# A stepper_arm szakasz a karon lévő kocsit vezérlő léptető
# leírására szolgál.
[stepper_arm]

# A stepper_z szakasz a Z tengelyt vezérlő léptető leírására szolgál.
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
#   sebességét (mm/sec-ben). Ezzel a beállítással csökkenthető a fel/le
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
#   A gömbcsuklók távolsága (mm-ben) a tárgyasztaltól, mínusz az effektor
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
#   Távolság (mm-ben) a fúvóka és a tárgyasztal között, ha a fúvóka az építési terület
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

# A delta_calibrate szakasz lehetővé teszi a DELTA_CALIBRATE kiterjesztett G-kód
# parancsot, amely képes kalibrálni a felső gömbcsuklók végállás pozícióit.
[delta_calibrate]
radius:
#   A vizsgálható terület sugara (mm-ben). Ez a vizsgálandó fúvókakoordináták
#   sugara; Ha X-Y eltolású automata szondát használ, akkor válasszon elég kicsi
#   sugarat, hogy a szonda mindig a tárgyasztal fölé férjen. Ezt a paramétert meg kell adni.
#speed: 50
#   A nem tapintó mozgás sebessége (mm/sec-ben) a kalibrálás során.
#   Az alapértelmezett 50.
#horizontal_move_z: 5
#   Az a magasság (mm-ben), ameddig a fejet utasítani kell, hogy mozduljon el
#   közvetlenül a mérőművelet megkezdése előtt. Az alapértelmezett érték 5.
```

### Kábelcsörlős Kinematika

Lásd az [example-winch.cfg](../config/example-winch.cfg) egy példát a kábelcsörlős kinematika konfigurációs fájljához.

Itt csak a kábelcsörlős nyomtatókra jellemző paraméterek kerülnek leírásra. A rendelkezésre álló paramétereket lásd az [általános kinematikai beállítások](#common-kinematic-settings) pontban.

A KÁBELCSÖRLŐ TÁMOGATÁSA KÍSÉRLETI JELLEGŰ. A helymeghatározás nem valósul meg a kábelcsörlő kinematikáján. A nyomtató kezdőpont felvételéhez manuálisan küldjön mozgatási parancsokat, amíg a nyomtatófej a 0, 0, 0, 0 ponton van, majd adj ki egy `G28` parancsot.

```
[printer]
kinematics: winch (csörlős)

# A stepper_a szakasz az első kábelcsörlőhöz csatlakoztatott léptetőt írja le.
# Legalább 3 és legfeljebb 26 kábelcsörlő definiálható (stepper_a-tól
# stepper_z-ig), bár általában 4-et definiálnak.
[stepper_a]
rotation_distance:
#   A rotation_distance az a névleges távolság (mm-ben), amellyel a
#   nyomtatófej elmozdul a kábelcsörlő felé a léptetőmotor minden egyes
#   teljes fordulatánál. Ezt a paramétert meg kell adni.
anchor_x:
anchor_y:
anchor_z:
#   A kábelcsörlő X, Y és Z helyzete derékszögű térben.
#   Ezeket a paramétereket meg kell adni.
```

### Nincs Kinematika

Lehetőség van egy speciális "none" kinematika definiálására a Klipper kinematikai támogatásának kikapcsolásához. Ez hasznos lehet olyan eszközök vezérléséhez, amelyek nem tipikus 3D nyomtatók, vagy hibakeresési célok.

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   A max_velocity és max_accel paramétereket meg kell határozni.
#   Az értékeket nem használjuk a "none" kinematika esetén.
```

## Közös extruder és fűtött tárgyasztal támogatás

### [extruder]

Az extruder szakasz a fúvóka fűtőberendezés paramétereinek leírására szolgál, az extruder vezérlését végző léptetővel együtt. További információkért lásd a [parancs hivatkozás](G-Codes.md#extruder) című részt. A nyomás előtolás hangolásával kapcsolatos információkért lásd a [nyomás előtolási útmutatót](Pressure_Advance.md).

```
[extruder]
step_pin:
dir_pin:
enable_pin:
microsteps:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#   A fenti paraméterek leírását lásd a "léptető" részben. Ha a fenti paraméterek
#   egyike sincs megadva, akkor nem lesz léptetőmotor társítva a nyomtatófejhez
#   (bár a SYNC_EXTRUDER_MOTION parancs futás közben társíthat egyet).
nozzle_diameter:
#   A fúvóka nyílásának átmérője (mm-ben). Ezt a paramétert meg kell adni.
filament_diameter:
#   A nyers szál névleges átmérője (mm-ben), amikor az extruderbe kerül.
#   Ezt a paramétert meg kell adni.
#max_extrude_cross_section:
#   Az extrudálási keresztmetszet maximális területe (mm^2-ben) (pl. az
#   extrudálási szélesség szorozva a réteg magasságával). Ez a beállítás
#   megakadályozza a túlzott mértékű extrudálást viszonylag kis XY mozgások
#   során. Ha egy áthelyezés olyan kihúzási sebességet kér, amely meghaladja
#   ezt az értéket, akkor hibaüzenet jelenik meg.
#   Az alapértelmezett érték: 4.0 * nozzle_diameter^2
#instantaneous_corner_velocity: 1.000
#   Az extruder maximális pillanatnyi sebességváltozása (mm/sec-ben)
#   két mozgás találkozásánál. Az alapértelmezett 1 mm/sec.
#max_extrude_only_distance: 50.0
#   Maximális hossza (a nyers nyomtatószálnak mm-ben), amely egy
#   visszahúzás vagy csak extrudálás esetén lehetséges. Ha egy visszahúzás
#   vagy csak extrudálási mozgás ennél az értéknél nagyobb távolságot kér,
#   hibaüzenetet ad vissza. Az alapértelmezett érték 50 mm.
#max_extrude_only_velocity:
#max_extrude_only_accel:
#   Az extrudermotor maximális sebessége (mm/sec-ben) és gyorsulása
#   (mm/sec^2-en) a visszahúzásokhoz és a csak extrudált mozgásokhoz.
#   Ezek a beállítások nincsenek hatással a normál nyomtatási sebességekre.
#   Ha nincs megadva, akkor a számítások megfelelnek a 4.0*nozzle_diameter^2
#   keresztmetszetű XY nyomtatási mozgás határának.
#pressure_advance: 0.0
#   Az extruder gyorsítása során a nyomtatófejbe nyomandó nyers szál
#   mennyisége. A lassítás során azonos mennyiségű izzószál húzódik vissza.
#   Mérete milliméter per milliméter/másodperc.
#   Az alapértelmezett érték 0, ami letiltja a nyomásnövelést.
#pressure_advance_smooth_time: 0.040
#   Időtartomány (másodpercben), amelyet az extruder átlagos sebességének
#   kiszámításához használnak a nyomás előtoláshoz. A nagyobb érték simább
#   extrudermozgásokat eredményez. Ez a paraméter nem haladhatja meg a
#   200 ezredmásodpercet. Ez a beállítás csak akkor érvényes, ha a
#   pressure_advance értéke nem nulla.
#   Az alapértelmezett érték 0,040 (40 ezredmásodperc).
#
# A fennmaradó változók az extruder fűtését írják le.
heater_pin:
#   PWM kimeneti érintkező, amely a fűtést vezérli.
#   Ezt a paramétert meg kell adni.
#max_power: 1.0
#   Az a maximális teljesítmény (0,0 és 1,0 közötti értékben kifejezve), amelyre a
#   heater_pin beállítható. Az 1,0 érték lehetővé teszi, hogy a tűt hosszabb ideig
#   teljesen engedélyezettre lehessen állítani, míg a 0,5 érték legfeljebb a fele
#   ideig engedélyezi a tűt. Ezzel a beállítással korlátozható a fűtőkészülék teljes
#   kimenő teljesítménye (hosszabb ideig). Az alapértelmezett érték 1.0.
sensor_type:
#   Érzékelő típusa. Általános termisztorok: „EPCOS 100K B57560G104F”,
#   „ATC Semitec 104GT-2”, „ATC Semitec 104NT-4-R025H42G”, „Generic 3950”,
#   „Honeywell 100K 135-JGBC10K135-1010LAG18 -104F39050L32",
#   "SliceEngineering 450" és "TDK NTCG104LH104JT1". További érzékelőkért
#   lásd a "Hőmérséklet-érzékelők" részt. Ezt a paramétert meg kell adni.
sensor_pin:
#   Analóg bemeneti érintkező csatlakozik az érzékelőhöz.
#   Ezt a paramétert meg kell adni.
#pullup_resistor: 4700
#   A termisztorhoz csatlakoztatott felhúzó ellenállása (ohmban).
#   Ez a paraméter csak akkor érvényes, ha az érzékelő termisztor.
#   Az alapértelmezett érték 4700 ohm.
#smooth_time: 1.0
#   Egy időérték (másodpercben), amely alatt a hőmérsékletmérés simításra kerül
#   a mérési zaj hatásának csökkentése érdekében.
#   Az alapértelmezett érték 1 másodperc.
control:
#   Vezérlési algoritmus (pid vagy watermark). Ezt a paramétert meg kell adni.
pid_Kp:
pid_Ki:
pid_Kd:
#   Az arányos (pid_Kp), az integrál (pid_Ki) és a derivált (pid_Kd) beállításai a PID
#   visszacsatolás vezérlő rendszerhez. A Klipper a PID beállításokat a következő
#   általános képlettel értékeli ki: heater_pwm = (Kp*error+ Ki*integral(error) vagy
#   Kd*derivative(error)) / 255 Ahol az „error” a „requested_temperature és
#   measured_temperature” és a „heater_pwm” a kért fűtési sebesség 0,0 teljes
#   kikapcsolt és 1,0 teljes bekapcsolva. Fontold meg a PID_CALIBRATE parancs
#   használatát a paraméterek lekéréséhez. A pid_Kp, pid_Ki és pid_Kd
#   paramétereket meg kell adni a PID fűtőberendezésekhez.
#max_delta: 2.0
#   A „watermark” vezérlésű fűtőberendezéseken ez a fűtőelem kikapcsolása
#   előtti célhőmérséklet feletti Celsius-fokkal, valamint a fűtőelem újbóli
#   bekapcsolása előtti célhőmérséklet alatti fokok száma.
#   Az alapértelmezett érték 2 Celsius-fok.
#pwm_cycle_time: 0.100
#   Idő másodpercben a fűtőelem minden szoftveres PWM-ciklusához.
#   Nem ajánlott ezt beállítani, hacsak nincs elektromos követelmény
#   a fűtőelem másodpercenkénti 10-nél gyorsabb kapcsolására.
#   Az alapértelmezett érték 0,100 másodperc.
#min_extrude_temp: 170
#   Az a minimális hőmérséklet (Celsiusban), amelyen az extruder mozgatási
#   parancsai kiadhatók. Az alapértelmezett érték 170 Celsius.
min_temp:
max_temp:
#   Az érvényes hőmérsékletek maximális tartománya (Celsiusban), amelyen
#   belül a fűtőelemnek maradnia kell. Ez egy, a mikrovezérlő kódjában
#   beépített biztonsági funkciót vezérel. Ha a mért hőmérséklet ezen a
#   tartományon kívül esik, akkor a mikrovezérlő leállási állapotba kerül.
#   Ez az ellenőrzés segíthet bizonyos fűtő és érzékelő hardverhibák észlelésében.
#   Állítsd be ezt a tartományt elég szélesre, hogy a normális hőmérséklet ne
#   okozzon hibát. Ezeket a paramétereket meg kell adni.
```

### [heater_bed]

A heater_bed szakasz egy fűtött tárgyasztalt ír le. Ugyanazokat a fűtési beállításokat használja, amelyeket az "extruder" szakaszban leírtunk.

```
[heater_bed]
heater_pin:
sensor_type:
sensor_pin:
control:
min_temp:
max_temp:
#   A fenti paraméterek leírását lásd az "extruder" szakaszban.
```

## Tárgyasztal szint támogatás

### [bed_mesh]

Tárgyasztal Háló Kiegyenlítés. Definiálhatunk egy bed_mesh konfigurációs szakaszt, hogy engedélyezzük a Z tengelyt eltoló mozgatási transzformációkat a mért pontokból generált háló alapján. Ha szondát használunk a Z-tengely alaphelyzetbe állítására, ajánlott a printer.cfg fájlban egy safe_z_home szakaszt definiálni a nyomtatási terület közepére történő alaphelyzetbe állításhoz.

További információkért lásd az [tárgyasztal háló útmutató](Bed_Mesh.md) és a [parancsreferencia](G-Codes.md#bed_mesh) dokumentumokat.

Vizuális példák:

```
 téglalap alakú tárgyasztal, probe_count = 3, 3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 kerek tárgyasztal, round_probe_count = 5, bed_radius = r:
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
#   A kalibrálás során a nem próbamozgások sebessége (mm/sec-ben).
#   Az alapértelmezett érték 50.
#horizontal_move_z: 5
#   Az a magasság (mm-ben), amelyre a fejnek parancsot kell adni a
#   mozgásra közvetlenül a szondaművelet megkezdése előtt.
#   Az alapértelmezett érték 5.
#mesh_radius:
#   Meghatározza a háló sugarát a kerek tárgyasztalokhoz. Ne feledd, hogy a
#   sugár a mesh_origin paraméter által megadott koordinátához
#   viszonyított. Ezt a paramétert a kerek tárgyasztaloknál meg kell adni,
#   a téglalap alakú tárgyasztaloknál pedig ki kell hagyni.
# mesh_origin
#   Az opció által meghatározott koordináta.
#   Ezt a paramétert kerek tárgyasztalok esetében meg kell adni.
#   De elhagyható a téglalap alakú tárgyasztalok esetében.
#mesh_origin:
#   Meghatározza a háló középpontjának X, Y koordinátáját kerek tárgyasztalok
#   esetén. Ez a koordináta a szonda helyéhez képest relatív. Hasznos
#   lehet a mesh_origin beállítása, hogy maximalizáljuk a háló méretét.
#   Az alapértelmezett érték 0, 0. Ezt a paramétert el kell hagyni
#   téglalap alakú tárgyasztalok esetén.
#mesh_min:
#   Meghatározza a háló minimális X, Y koordinátáját téglalap alakú
#   tárgyasztalok esetén. Ez a koordináta a szonda helyéhez képest relatív.
#   Ez lesz az első szondázott pont, amely a legközelebb van az origóhoz.
#   Ezt a paramétert téglalap alakú tárgyasztalok esetén meg kell adni.
#mesh_max:
#   Meghatározza a háló maximális X, Y koordinátáját téglalap alakú
#   tárgyasztalok esetén. Ugyanazon az elven működik, mint a mesh_min,
#   azonban ez a paraméter a legtávolabbi pont lesz, amelyet a tárgyasztal
#   origójától vizsgálunk. Ezt a paramétert téglalap alakú tárgyasztalok
#   esetén meg kell adni.
#probe_count: 3, 3
#   Téglalap alakú tárgyasztalok esetén ez egy vesszővel elválasztott egész
#   számpár. X, Y értékek, amelyek meghatározzák a mérni kívánt
#   pontok számát az egyes tengelyek mentén. Egyetlen érték is
#   érvényes, ebben az esetben ez az érték mindkét tengelyre vonatkozik.
#   Az alapértelmezett érték 3, 3.
#round_probe_count: 5
#   A kerek tárgyasztalok esetében ez az egész érték határozza meg a
#   maximális számú pontok számát, amelyeket minden tengely mentén
#   meg kell vizsgálni. Ennek az értéknek páratlan számnak kell lennie.
#   Az alapértelmezett érték 5.
#fade_start: 1.0
#   A G-kód Z pozíciója, ahol a Z-korrekció fokozatos megszüntetése
#   elkezdődik amikor a fade engedélyezve van.
#   Az alapértelmezett érték 1.0.
#fade_end: 0.0
#   A G-kód Z pozíciója, amelyben a fading out befejeződik. Ha be van
#   állítva egy fade_start alatti értékre a fade ki van kapcsolva.
#   Meg kell jegyezni, hogy a fade nem kívánt skálázást adhat a
#   nyomtatás Z tengelye mentén. Ha egy felhasználó engedélyezni
#   kívánja a fade-et, a 10.0 érték ajánlott.
#   Az alapértelmezett érték 0.0, amely kikapcsolja a fade-et.
#fade_target:
#   A Z pozíció, amelyben a fade-nek konvergálnia kell. Ha ez az érték
#   nem nulla értékre van beállítva, akkor annak a Z-értékek tartományán
#   belül kell lennie a hálóban. Azok a felhasználók, akik a Z kezdőponthoz
#   kívánnak konvergálni, 0-ra kell állítaniuk.
#   Az alapértelmezett érték a háló átlagos Z értéke.
#split_delta_z: .025
#   A Z különbség mértéke (mm-ben) a mozgás mentén, amely kivált
#   egy osztást. Az alapértelmezett érték .025.
#move_check_distance: 5.0
#   A távolság (mm-ben) a mozgás mentén, amelynél a split_delta_z-t
#   ellenőrizni kell. Ez egyben a minimális hossz, ameddig egy mozgást
#   fel lehet osztani. Alapértelmezett érték 5.0.
#mesh_pps: 2, 2
#   Egy vesszővel elválasztott egész számpár X, Y, amely meghatározza a
#   következő pontok számát szegmensenként, amelyeket interpolálni kell
#   a hálóban az egyes tengelyek mentén. A "szegmens" úgy definiálható,
#   mint az egyes mért pontok közötti tér. A felhasználó egyetlen értéket
#   adhat meg, amely mindkét tengelyre vonatkozik.
#   Az alapértelmezett érték 2, 2.
#algoritmus: lagrange
#   Az alkalmazandó interpolációs algoritmus. Lehet akár "lagrange" vagy
#   "bicubic". Ez az opció nem érinti a 3x3-as rácsokat, amelyek kényszerített
#   lagrange mintavételt használnak. Az alapértelmezett lagrange.
#bicubic_tension: .2
#   A bikubik algoritmus használatakor a fenti feszültség paraméter
#   alkalmazható az interpolált meredekség mértékének megváltoztatására.
#   Nagyobb számok növelik a meredekség mértékét, ami nagyobb
#   görbületet eredményez a hálóban. Az alapértelmezett érték .2.
#relative_reference_index:
#   Egy pontindex a hálóban, amelyre minden Z értéket hivatkozni kell.
#   Az engedélyezése ennek a paraméternek a bekapcsolása a vizsgált
#   Z pozícióhoz viszonyított hálót eredményez a megadott indexhez képest.
#faulty_region_1_min:
#faulty_region_1_max:
#   A hibás régiót meghatározó opcionális pontok. Lásd docs/Bed_Mesh.md
#   A hibás régiókkal kapcsolatos részletekért. Legfeljebb 99 hibás régió
#   adható hozzá. Alapértelmezés szerint nincsenek hibás régiók beállítva.
```

### [bed_tilt]

Tárgyasztal dőlés kompenzáció. Definiálhatunk egy bed_tilt config szekciót, hogy lehetővé tegyük a ferde tárgyasztalt figyelembe vevő mozgástranszformációkat. Vedd figyelembe, hogy a bed_mesh és a bed_tilt nem kompatibilisek. Mindkettő nem definiálható.

További információkért lásd a [parancsreferencia](G-Codes.md#bed_tilt) dokumentumot.

```
[bed_tilt]
#x_adjust: 0
#   Az az érték, amit hozzá kell adni az egyes mozgások Z
#   magasságához az X tengely minden mm-én.
#   Az alapértelmezett érték 0.
#y_adjust: 0
#   Az az érték, amit hozzá kell adni az egyes mozgások Z
#   magasságához az Y tengely minden mm-én.
#   Az alapértelmezett érték 0.
#z_adjust: 0
#   A Z magassághoz hozzáadandó érték, amikor a fúvóka névlegesen 0, 0.
#   Az alapértelmezett érték 0.
# A többi paraméter egy BED_TILT_CALIBRATE kiterjesztett G-kód
# parancsot vezérel, amely a megfelelő X és Y beállítási paraméterek
# kalibrálására használható.
#points:
#   Az X, Y koordináták listája (soronként egy a következő sorokat behúzva),
#   amelyeket a BED_TILT_CALIBRATE parancs során meg kell vizsgálni.
#   Add meg a fúvóka koordinátáit, és győződj meg arról, hogy a szonda
#   a tárgyasztal felett van a megadott fúvókakoordinátákon.
#   Az alapértelmezett az, hogy nem engedélyezi a parancsot.
#speed: 50
#   A nem szondázás sebessége (mm/sec-ben) mozog a kalibrálás során.
#   Az alapértelmezett érték 50.
#horizontal_move_z: 5
#   Az a magasság (mm-ben), ameddig a fejnek el kell mozdulnia
#   közvetlenül a szondaművelet megkezdése előtt.
#   Az alapértelmezett érték 5.
```

### [bed_screws]

Szerszám a tárgyasztal szintbeállító csavarok beállításához. Meghatározható egy [bed_screws] config szakasz a BED_SCREWS_ADJUST G-kód parancs engedélyezéséhez.

További információkért lásd a [szintezési útmutató](Manual_Level.md#adjusting-bed-leveling-screws) és a [parancs hivatkozás](G-Codes.md#bed_screws) dokumentumot.

```
[bed_screws]
#screw1:
#   Az első tárgyasztal kiegyenlítő csavar X, Y koordinátája. Ez egy
#   olyan pozíció, ahová a fúvókát kell irányítani, mely közvetlenül a tárgyasztal felett van
#   (vagy a lehető legközelebb, de még mindig a tárgyasztal felett).
#   Ezt a paramétert meg kell adni.
#screw1_name:
#   Az adott csavar tetszőleges neve. Ez a név jelenik meg, amikor a segédszkript fut.
#   Az alapértelmezés szerint a név alapja a csavar XY helye.
#screw1_fine_adjust:
#   Egy X, Y koordináta, amelyre a fúvókát irányítani
#   kell, hogy finomítani lehessen a tárgyasztal szintező csavart.
#   Az alapértelmezés szerint a finombeállítás nem történik meg a tárgyasztal csavarján.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#   További tárgyasztal szintállító csavarok. Legalább három csavarnak kell lennie.
#horizontal_move_z: 5
#   Az a magasság (mm-ben), ahová a fejnek parancsot kell adni a mozgásra amikor az egyik
#   csavar helyéről a másikra mozog.
#   Az alapértelmezett érték 5.
#probe_height: 0
#   A szonda magassága (mm-ben) a hőfokszabályozás után.
#   A tárgyasztal és a fúvóka hőtágulása után. Az alapértelmezett érték nulla.
#speed: 50
#   A kalibrálás során a nem mérési mozgások sebessége (mm/sec-ben).
#   Az alapértelmezett érték 50.
#probe_speed: 5
#   A sebesség (mm/sec-ben) a horizontális_move_z pozícióból történő mozgáskor.
#   A probe_height pozíciója. Az alapértelmezett érték 5.
```

### [screws_tilt_adjust]

Eszköz a tárgyasztal csavarok dőlésszögének beállításához Z-szondával. Meghatározható egy screws_tilt_adjust konfigurációs szakasz a SCREWS_TILT_CALCULATE G-kód paranccsal.

További információkért lásd a [szintezési útmutató](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) és a [parancs hivatkozás](G-Codes.md#screws_tilt_adjust) dokumentumot.

```
[screws_tilt_adjust]
#screw1:
#   Az első tárgyasztal kiegyenlítő csavar (X, Y) koordinátája. Ez a helyzet a fúvóka
#   utasításához úgy, hogy a szonda közvetlenül a tárgyasztal csavar felett
#   legyen (vagy a lehető legközelebb, miközben továbbra is a tárgyasztal felett
#   van). Ez a számításoknál használt alapcsavar.
#   Ezt a paramétert meg kell adni.
#screw1_name:
#   Az adott csavar tetszőleges neve. Ez a név jelenik meg a segédszkript
#   futtatásakor. Az alapértelmezés szerint a név a a csavar X-Y
#   helyére épül.
#screw2:
#screw2_name:
#...
#   További tárgyasztal kiegyenlítő csavarok.
#   Legalább két csavart kell meghatározott.
#speed: 50
#   A kalibrálás során a nem mérő mozgások sebessége (mm/sec-ben).
#   Az alapértelmezett érték 50.
#horizontal_move_z: 5
#   A magasság (mm-ben), ahová a fejnek el kell mozdulnia.
#   Közvetlenül a szondaművelet megkezdése előtt.
#   Az alapértelmezett érték 5.
#screw_thread: CW-M3
#   A tárgyasztal szintjéhez használt csavar típusa, M3, M4 vagy M5, valamint a
#   tárgyasztal szintbeállításához használt gomb iránya, az óramutató járásával
#   megegyező irányú csökkenés az óramutató járásával ellentétes irányú
#   csökkenés. Elfogadott értékek: CW-M3, CCW-M3, CW-M4, CCW-M4,
#   CW-M5, CCW-M5. Az alapértelmezett érték CW-M3, a legtöbb nyomtató
#   M3-as csavart és a gombot az óramutató járásával megegyező irányba
#   forgatva csökken a távolság.
```

### [z_tilt]

Többszörös Z léptető dőlésszög beállítása. Ez a funkció lehetővé teszi több Z léptető független beállítását (lásd a "stepper_z1" szakaszt) a dőlés beállításához. Ha ez a szakasz jelen van, akkor elérhetővé válik a Z_TILT_ADJUST kiterjesztett [G-kód parancs](G-Codes.md#z_tilt).

```
[z_tilt]
#z_positions:
#   Az X, Y koordináták listája (soronként egy a következő sorokat behúzva),
#   amelyek leírják az egyes tárgyasztalok "forgáspontjainak" helyét.
#   A "forgáspont" az a pont, ahol a tárgyasztal az adott Z léptetőhöz
#   kapcsolódik. Ezt a fúvóka koordinátáival írják le (a fúvóka X, Y
#   pozíciója, ha közvetlenül a pont felett mozoghat). Az első bejegyzés a
#   stepper_z, a második a stepper_z1, a harmadik a stepper_z2 stb.
#   értéknek felel meg. Ezt a paramétert meg kell adni.
#points:
#   Az X, Y koordináták listája (soronként egy a következő sorokat behúzva),
#   amelyeket a Z_TILT_ADJUST parancs során meg kell vizsgálni. Add meg
#   a fúvóka koordinátáit, és győződj meg arról, hogy a szonda a tárgyasztal
#   felett van a megadott fúvókakoordinátákon.
#   Ezt a paramétert meg kell adni.
#speed: 50
#   A nem mérési mozgás sebessége (mm/sec-ben) mozog a kalibráláskor.
#   Az alapértelmezett érték 50.
#horizontal_move_z: 5
#   Az a magasság (mm-ben), ameddig a fejnek el kell mozdulnia
#   közvetlenül a mérések megkezdése előtt. Az alapértelmezett érték 5.
#retries: 0
#   Az újrapróbálkozások száma, ha a vizsgált pontok nincsenek a
#   tűréshatáron belül.
#retry_tolerance: 0
#   Ha az újrapróbálkozás engedélyezve van, próbálkozzon újra, ha a
#   legnagyobb és a legkisebb vizsgált pont jobban eltér, mint a
#   retry_tolerance. Vedd figyelembe, hogy a változás legkisebb egysége
#   itt egyetlen lépés lenne. Ha azonban több pontot vizsgál, mint léptetőt,
#   akkor valószínűleg lesz egy rögzített minimális értéke a vizsgált pontok
#   tartományához, amelyet a parancs kimenetének megfigyelésével
#   tanulhat meg.
```

### [quad_gantry_level]

Mozgó állvány szintezése 4 egymástól függetlenül vezérelt Z-motorral. Korrigálja a hiperbolikus parabola hatását (krumplichip) a mozgó portálon, amely rugalmasabb. FIGYELMEZTETÉS: Mozgó tárgyasztalon történő használata nemkívánatos eredményekhez vezethet. Ha ez a szakasz jelen van, akkor elérhetővé válik a QUAD_GANTRY_LEVEL kiterjesztett G-kód parancs. Ez a rutin a következő Z motor konfigurációt feltételezi:

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

Ahol X a tárgyasztal 0, 0 pontja

```
[quad_gantry_level]
#gantry_corners:
#   Az X, Y koordináták új sorral elválasztott listája, amely leírja a portál
#   két ellentétes sarkát. Az első bejegyzés a Z-nek, a második a Z2-nek
#   felel meg. Ezt a paramétert meg kell adni.
#points:
#   Egy új sorral elválasztott lista négy X, Y pontból, amelyeket meg kell
#   vizsgálni a QUAD_GANTRY_LEVEL parancs során. A helyek sorrendje
#   fontos, és sorrendben meg kell egyeznie a Z, Z1, Z2 és Z3 helyekkel.
#   Ezt a paramétert meg kell adni. A maximális pontosság érdekében
#   győződj meg arról, hogy a szonda eltolása be van állítva.
#speed: 50
#   A nem mérési mozgások sebessége (mm/sec-ben) mozog a kalibráláskor.
#   Az alapértelmezett érték 50.
#horizontal_move_z: 5
#   Az a magasság (mm-ben), ameddig a fejnek el kell mozdulnia közvetlenül
#   a mérés megkezdése előtt. Az alapértelmezett érték 5.
#max_adjust: 4
#   Biztonsági korlát, ha ennél az értéknél nagyobb korrekciót kérnek,
#   a quad_gantry_level megszakad.
#retries: 0
#   Az újrapróbálkozások száma, ha a vizsgált pontok nincsenek a
#   tűréshatáron belül.
#retry_tolerance: 0
#   Ha az újrapróbálkozás engedélyezve van, próbálkozzon újra, ha a
#   legnagyobb és a legkisebb vizsgált pont jobban eltér,
#   mint a retry_tolerance értéke.
```

### [skew_correction]

Nyomtató ferdeségkorrekció. Lehetőség van a nyomtató ferdeségének szoftveres korrekciójára 3 síkban: XY, XZ, YZ. Ez úgy történik, hogy egy kalibrációs modellt nyomtatunk egy sík mentén, és három hosszúságot mérünk. A ferdeségkorrekció jellegéből adódóan ezeket a hosszokat G-kódal kell beállítani. Lásd a [Ferdeség korrekció](Skew_Correction.md) és a [Parancs hivatkozás](G-Codes.md#skew_correction) című fejezetekben található részleteket.

```
[skew_correction]
```

### [z_thermal_adjust]

Hőmérsékletfüggő nyomtatófej Z pozíció beállítása. Kompenzálja a nyomtató keretének hőtágulása által okozott függőleges nyomtatófej elmozdulást valós időben egy hőmérséklet-érzékelő segítségével (jellemzően a keret függőleges szakaszához csatlakoztatva).

Lásd még: [bővített G-kód parancsok](G-Codes.md#z_thermal_adjust).

```
[z_thermal_adjust]
#temp_coeff:
#   A hőmérsékleti tágulási együttható, mm/°C-ban. Például a 0,01 mm/°C
#   temp_coeff a Z tengelyt 0,01 mm-rel lefelé mozgatja minden Celsius-fok
#   után, amelyet a hőmérséklet-érzékelő növel.
#   Az alapértelmezett érték 0,0 mm/°C, amely nem alkalmaz beállítást.
#smooth_time:
#   Simítási ablak a hőmérséklet-érzékelőre, másodpercek alatt.
#   Csökkentheti a motorzajt a túlzottan kis korrekciókból
#   az érzékelő zajára reagálva.
#   Az alapértelmezett 2,0 másodperc.
#z_adjust_off_above:
#   Letiltja a Z magasság [mm] feletti beállításokat.
#   Az utoljára számított korrekció mindaddig érvényes marad, amíg a
#   nyomtatófej ismét a megadott Z magasság alá nem kerül.
#   Az alapértelmezett érték 99999999,0 mm (mindig bekapcsolva).
#max_z_adjustment:
#   A Z tengelyre alkalmazható maximális abszolút beállítás [mm].
#   Az alapértelmezett érték 99999999,0 mm (korlátlan).
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Hőmérséklet-érzékelő konfigurációja.
#   A fenti paraméterek meghatározásához lásd az "extruder" részt.
#gcode_id:
#   Lásd a "heater_generic" részt a paraméter meghatározásához.
```

## Testreszabott kezdőpont felvétel

### [safe_z_home]

Biztonságos Z kezdőpont felvétel. Ezzel a mechanizmussal a Z tengelyt egy adott X, Y koordinátára lehet állítani. Ez akkor hasznos, ha például a nyomtatófejnek a tárgyasztal közepére kell mozognia, mielőtt a Z-tengelyt kezdőpontpba irányítaná.

```
[safe_z_home]
home_xy_position:
#   Egy X, Y koordináta (pl. 100, 100), ahol a Z homingot végre kell hajtani.
#   Ezt a paramétert meg kell adni.
#speed: 50.0
#   Az a sebesség, amellyel a nyomtatófej a biztonságos Z
#   kezdőkoordinátára kerül. Az alapértelmezett érték 50 mm/sec
#z_hop:
#   Távolság (mm-ben) a Z tengely felemeléséhez a beállítás előtt.
#   Ez minden irányadó parancsra vonatkozik, még akkor is, ha nem
#   a Z tengelyre irányul.
#   Ha a Z tengely már be van állítva, és az aktuális Z pozíció kisebb,
#   mint z_hop, akkor ez a fejet z_hop magasságba emeli.
#   Ha a Z tengely még nincs behelyezve, a fejet a z_hop felemeli.
#   Az alapértelmezett az, hogy nem valósítja meg a Z ugrást.
#z_hop_speed: 15.0
#   Sebesség (mm/sec-ben), amellyel a Z tengely megemelkedik
#   a homing előtt. Az alapértelmezett érték 15mm/sec.
#move_to_previous: False
#   Ha True értékre van állítva, az X és Y tengelyek visszaállnak
#   az előző pozíciójukra a Z tengely kezdőpont felvétele után.
#   Az alapértelmezett érték False.
```

### [homing_override]

Kezdőpont felvétel felülbírálása. Ezt a mechanizmust arra lehet használni, hogy a normál G-kód bemenetben található G28 helyett egy sor G-kód parancsot futtassunk. Ez olyan nyomtatóknál lehet hasznos, amelyeknél a gép beindításához speciális eljárásra van szükség.

```
[homing_override]
gcode:
#   A normál G-kód bemenetben található G28 parancsok helyett
#   végrehajtandó G-kód parancsok listája. Lásd a
#   docs/Command_Templates.md fájlt a G-kód formátumokhoz.
#   Ha a parancsok listája G28-at tartalmaz, akkor az a nyomtatófej normál
#   elhelyezési eljárását indítja el. Az itt felsorolt parancsoknak minden
#   tengelyt kezdőponthoz kell irányítaniuk. Ezt a paramétert meg kell adni.
#axes: xyz
#   A felülírandó tengelyek. Például, ha ez "Z"-re van állítva, akkor a
#   felülírási parancsfájl csak akkor fut le, ha a Z tengely be van állítva
#   (pl. "G28" vagy "G28 Z0" paranccsal). Ne feledd, hogy a felülírási
#   szkriptnek továbbra is minden tengelyt kell tartalmaznia.
#   Az alapértelmezés az "xyz", ami azt eredményezi, hogy a felülbíráló
#   szkript fut minden G28 parancs helyett.
#set_position_x:
#set_position_y:
#set_position_z:
#   Ha meg van adva, a nyomtató feltételezi, hogy a tengely a megadott
#   pozícióban van a fenti G-kód parancsok futtatása előtt. Ennek a
#   beállításával letiltja az adott tengelyre vonatkozó kezdőpont
#   ellenőrzéseket. Ez akkor lehet hasznos, ha a nyomtatófejnek el kell
#   mozdulnia, mielőtt a normál G28 parancsot meghívná egy tengelyre.
#   Az alapértelmezés az, hogy nem erőltetik a tengely pozícióját.
```

### [endstop_phase]

Léptető fázissal beállított végállások. A funkció használatához definiálj egy konfigurációs részt egy "endstop_phase" előtaggal, amelyet a megfelelő stepper konfigurációs rész neve követ (például "[endstop_phase stepper_z]"). Ez a funkció javíthatja a végálláskapcsolók pontosságát. Adj hozzá egy csupasz "[endstop_phase]" deklarációt az ENDSTOP_PHASE_CALIBRATE parancs engedélyezéséhez.

További információkért lásd a [végállási fázisok útmutató](Endstop_Phase.md) és a [Parancs hivatkozás](G-Codes.md#endstop_phase) dokumentumot.

```
[endstop_phase stepper_z]
#endstop_accuracy:
#   Beállítja a végálláskapcsoló várható pontosságát (mm-ben). Ez azt a
#   maximális hibatávolságot jelöli, amelyet a végállás kiválthat (pl. ha
#   egy végállás időnként 100 um korán vagy legfeljebb 100 um késéssel
#   válthat ki, akkor állítsd ezt 0,200-ra 200 um esetén). Az alapértelmezett
#   4*rotation_distance/full_steps_per_rotation.
#trigger_phase:
#   Ez határozza meg a léptetőmotor meghajtójának azt az áramot,
#   amelyre számítani kell, amikor megüti a végállást. Két számból áll,
#   amelyeket egy perjel választ el. Az áramból és áramok teljes számából
#   (pl. "7/64"). Csak akkor állítsd be ezt az értéket, ha biztos abban, hogy a
#   motorvezérlő minden alkalommal alaphelyzetbe áll az MCU
#   alaphelyzetbe állításakor. Ha ez nincs beállítva, akkor a léptető fázist a
#   rendszer az első kezdőpontban érzékeli, és ezt az áramot használja az
#   összes következő kezdőpontfelvételkor.
#endstop_align_zero: False
#   Ha True, akkor a tengely position_endstop értéke ténylegesen módosul,
#   így a tengely nulla pozíciója a léptetőmotor teljes lépésénél megjelenik.
#   (Ha a Z tengelyen használjuk, és a nyomtatási réteg magassága a teljes
#   lépéstávolság többszöröse, akkor minden réteg egy teljes lépésben
#   jelenik meg.) Az alapértelmezett érték False.
```

## G-kód makrók és események

### [gcode_macro]

G-kód makrók (a "gcode_macro" előtaggal tetszőleges számú szakasz definiálható). További információkért lásd a [parancssablonok útmutatóját](Command_Templates.md).

```
[gcode_macro my_cmd]
#gcode:
#   A "my_cmd" helyett végrehajtandó G-kód-parancsok listája. Lásd a
#   docs/Command_Templates.md fájlt a G-kód formátumhoz.
#   Ezt a paramétert meg kell adni.
#variable_<name>:
#   Bármilyen számú beállítás megadható a "változó_" előtaggal.
#   Az adott változónévhez a rendszer hozzárendeli az adott értéket
#   (Python literálként értelmezi), és elérhető lesz a makróbővítés
#   során. Például egy "variable_fan_speed = 75" konfigurációjú G-kód
#   parancsok tartalmazhatják az "M106 S{ fan_speed * 255 }" értéket.
#   A változók futás közben módosíthatók a SET_GCODE_VARIABLE
#   paranccsal (a részletekért lásd a docs/Command_Templates.md fájlt).
#   A változónevek nem tartalmazhatnak nagybetűket.
#rename_existing:
#   Ezzel az opcióval a makró felülír egy meglévő G-kód parancsot, és
#   megadja a parancs korábbi definícióját az itt megadott néven. Ez
#   használható a beépített G-kód parancsok felülbírálására. Óvatosan
#   kell eljárni a parancsok felülbírálásakor, mivel az összetett és váratlan
#   eredményeket okozhat. Az alapértelmezés szerint nem írnak felül
#   meglévő G-kód parancsot.
#description: G-Code macro
#   Ez hozzáad egy rövid leírást, amelyet a HELP parancsnál vagy az
#   automatikus kiegészítés funkció használatakor használnak.
#   Alapértelmezett a "G-Code macro"
```

### [delayed_gcode]

Egy G-kód végrehajtása beállított késleltetéssel. További információkért lásd a [parancssablon útmutató](Command_Templates.md#delayed-gcodes) és a [Parancs hivatkozás](G-Codes.md#delayed_gcode) dokumentumot.

```
[delayed_gcode my_delayed_gcode]
gcode:
#   A késleltetési idő letelte után végrehajtandó G-kód parancsok listája.
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

A változók lemezre mentésének támogatása, hogy azok az újraindítások során is megmaradjanak. További információkért lásd [Parancs hivatkozás](Command_Templates.md#save-variables-to-disk) és a [G-kód hivatkozás](G-Codes.md#save_variables) dokumentumot.

```
[save_variables]
filename:
#   Kötelező - adj meg egy fájlnevet, amelyet a változók
#   lemezre mentéséhez használna, pl. ~/variables.cfg
```

### [idle_timeout]

Üresjárati időtúllépés. Az üresjárati időtúllépés automatikusan engedélyezve van. Az alapértelmezett beállítások módosításához adj hozzá egy explicit idle_timeout konfigurációs szakaszt.

```
[idle_timeout]
#gcode:
#   Az üresjárati időtúllépéskor végrehajtandó G-kód parancsok listája.
#   Lásd a docs/Command_Templates.md fájlt a G-kód formátumhoz.
#   Az alapértelmezett a „TURN_OFF_HEATERS” és „M84” futtatása.
#timeout: 600
#   A fenti G-kód parancsok futtatása előtti várakozási idő (másodpercben).
#   Az alapértelmezett érték a 600 másodperc.
```

## Választható G-kód funkciók

### [virtual_sdcard]

A virtuális sdcard hasznos lehet, ha a gazdaszámítógép nem elég gyors az OctoPrint megfelelő futtatásához. Ez lehetővé teszi a Klipper gazdagép szoftver számára, hogy közvetlenül kinyomtasd a G-kód fájlokat, amelyeket a gazdagépen lévő könyvtárban tárolnak a szabványos sdcard G-kód parancsok (pl. M24) használatával.

```
[virtual_sdcard]
path:
#   A gazdagép helyi könyvtárának elérési útja a G-kód fájlok kereséséhez.
#   Ez egy csak olvasható könyvtár (az sdcard fájl írása nem támogatott).
#   Ezt rámutathatjuk az OctoPrint feltöltési könyvtárára
#   (általában ~/.octoprint/uploads/ ). Ezt a paramétert meg kell adni.
#on_error_gcode:
#   A hibajelentéskor végrehajtandó G-kód parancsok listája.
```

### [sdcard_loop]

Néhány szakaszok törlésével rendelkező nyomtató, például alkatrész-kidobó vagy szalagnyomtató, hasznát veheti az SD-kártya fájl hurkolt szakaszainak. (Például ugyanazon alkatrész újra és újra történő kinyomtatásához, vagy egy alkatrész egy szakaszának megismétléséhez egy lánc vagy más ismétlődő mintához).

A támogatott parancsokat lásd a [Parancs hivatkozásban](G-Codes.md#sdcard_loop). Vagy lásd a [sample-macros.cfg](../config/sample-macros.cfg) fájlt egy Marlin kompatibilis M808 G-kód makróért.

```
[sdcard_loop]
```

### [force_move]

Támogatja a lépegetőmotorok kézi mozgatását diagnosztikai célokra. Figyelem, ennek a funkciónak a használata a nyomtatót érvénytelen állapotba hozhatja. A fontos részletekért lásd a [Parancs hivatkozás](G-Codes.md#force_move) dokumentumot.

```
[force_move]
#enable_force_move: False
#   A FORCE_MOVE és a SET_KINEMATIC_POSITION engedélyezéséhez
#   állítsuk True-ra a kiterjesztett G-kód parancsot.
#   Az alapértelmezett érték False.
```

### [pause_resume]

Szüneteltetési/folytatási funkció a pozíció rögzítésének és visszaállításának támogatásával. További információért lásd a [Parancs hivatkozás](G-Codes.md#pause_resume) dokumentumot.

```
[pause_resume]
#recover_velocity: 50.
#   Ha a rögzítés/visszaállítás engedélyezve van, akkor a megadott
#   sebességgel, tér vissza a rögzített pozícióhoz (mm/sec-ben).
#   Az alapértelmezett érték 50,0 mm/sec.
```

### [firmware_retraction]

Firmware szál visszahúzás. Ez lehetővé teszi a G10 (visszahúzás) és G11 (visszahúzás megszüntetése) G-kód parancsokat, amelyeket sok szeletelő program használ. Az alábbi paraméterek az indítási alapértelmezett értékeket adják meg, bár az értékek a SET_RETRACTION [parancs](G-Codes.md#firmware_retraction)) segítségével módosíthatók, lehetővé téve a szálankénti beállításokat és a futásidejű hangolást.

```
[firmware_retraction]
#retract_length: 0
#   A G10 aktiválásakor visszahúzandó szál hossza (mm-ben),
#   és a G11 aktiválásakor visszahúzandó (de lásd: G11).
#   unretract_extra_length alább). Az alapértelmezett érték 0 mm.
#retract_speed: 20
#   A behúzás sebessége mm/sec-ben.
#   Az alapértelmezett érték 20 mm/sec.
#unretract_extra_length: 0
#   Az *additional* szál hossza (mm-ben), amelyet hozzáadunk,
#   a visszahúzás feloldásakor.
#unretract_speed: 10
#   A visszahúzás feloldásának sebessége mm/sec-ben.
#   Az alapértelmezett érték 10 mm/sec.
```

### [gcode_arcs]

A G-kód ív (G2/G3) parancsok támogatása.

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

Engedélyezd az "M118" és "RESPOND" kiterjesztett [parancsokat](G-Codes.md#respond).

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

### [exclude_object]

Lehetővé teszi az egyes objektumok kizárásának vagy törlésének támogatását a nyomtatási folyamat során.

További információkért lásd a [kizárandó objektumok útmutatót](Exclude_Object.md) és a [parancsreferenciát](G-Codes.md#excludeobject). Lásd a [sample-macros.cfg](../config/sample-macros.cfg) fájlt egy Marlin/RepRapFirmware kompatibilis M486 G-kód makróhoz.

```
[exclude_object]
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

ADXL345 gyorsulásmérők támogatása. Ez a támogatás lehetővé teszi a gyorsulásmérő méréseinek lekérdezését az érzékelőtől. Ez lehetővé teszi az ACCELEROMETER_MEASURE parancsot (további információkért lásd a [G-kódok](G-Codes.md#adxl345) dokumentumot). Az alapértelmezett chipnév "default", de megadhatunk egy explicit nevet (pl. [adxl345 my_chip_name]).

```
[adxl345]
cs_pin:
#   Az érzékelő SPI engedélyező tűje. Ezt a paramétert meg kell adni.
#spi_speed: 5000000
#   A chippel való kommunikáció során használandó SPI sebesség (hz-ben).
#   Az alapértelmezett érték 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Lásd az "általános SPI-beállítások" című szakaszt a
#   fenti paraméterek leírásához.
#axes_map: x, y, z
#   A gyorsulásmérő a nyomtató X, Y és Z tengelyeihez kell.
#   Ez akkor lehet hasznos, ha a gyorsulásmérő olyan
#   orientációban van beszerelve, amely nem egyezik a nyomtatóéval.
#   Ebben az esetében például beállíthatjuk ezt az "Y, X, Z" értékre,
#   hogy felcseréljük az X és Y tengelyeket. Lehetőség van arra is, hogy
#   negáljunk egy tengelyt, ha a gyorsulásmérő iránya fordított
#   (pl. "X, Z, -Y"). Az alapértelmezett érték "X, Y, Z",.
#rate: 3200
#   Kimeneti adatátviteli sebesség az ADXL345 esetében. Az ADXL345
#   a következő sebességeket támogatja: 3200, 1600, 800, 400, 200,
#   100, 50 és 25. Vedd figyelembe, hogy nem ajánlott megváltoztatni
#   ezt a sebességet az alapértelmezett 3200-ról, és a 800 alatti
#   sebességek jelentősen befolyásolják a rezonancia mérés
#   eredményeinek minőségét.
```

### [mpu9250]

Az mpu9250 és mpu6050 gyorsulásmérők támogatása (tetszőleges számú szekciót lehet definiálni "mpu9250" előtaggal).

```
[mpu9250 my_accelerometer]
#i2c_address:
#   Az alapértelmezett 104 (0x68).
#i2c_mcu:
#i2c_bus:
#i2c_speed: 400000
#   A fenti paraméterek leírását lásd az
#   "általános I2C beállítások" részben.
#   Az alapértelmezett "i2c_speed" 400000.
#axes_map: x, y, z
#   Erről a paraméterről az "adxl345" szakaszban olvashat bővebben.
```

### [resonance_tester]

A rezonancia tesztelés és az automatikus bemeneti alakító kalibráció támogatása. A modul legtöbb funkciójának használatához további szoftverfüggőségeket kell telepíteni; további információkért olvasd el a [Rezonanciák mérése](Measuring_Resonances.md) és a [parancs hivatkozás](G-Codes.md#resonance_tester) című dokumentumot. A rezonanciák mérése című útmutató [Max simítás](Measuring_Resonances.md#max-smoothing) szakaszában további információkat talál a `max_smoothing` paraméterről és annak használatáról.

```
[resonance_tester]
#probe_points:
#   A rezonanciák teszteléséhez szükséges pontok X, Y, Z koordinátáinak
#   listája (soronként egy pont). Legalább egy pont szükséges.
#   Győződj meg róla, hogy minden pont az X-Y síkban némi
#   biztonsági tartalékkal rendelkezik és (~ néhány centiméter)
#   elérhetőek a nyomtatófejjel.
#accel_chip:
#   A mérésekhez használt gyorsulásmérő chip neve. Ha adxl345 chipet
#   explicit név nélkül definiálták, ez a paraméter egyszerűen
#   hivatkozhat rá "accel_chip: adxl345"-ként, ellenkező esetben egy
#   "accel_chip: adxl345" paramétert kell megadni. Explicit nevet is meg
#   kell adni, pl. "accel_chip: adxl345" my_chip_név".
#   Vagy ezt, vagy a következő két paramétert kell beállítani.
#accel_chip_x:
#accel_chip_y:
#   Az egyes tengelyek méréséhez használandó gyorsulásmérő chipek
#   neve. Hasznos lehet például a tárgyasztal csúsztatós nyomtatónál, ha két
#   külön gyorsulásmérő van felszerelve a tárgyasztalra (az Y tengelyhez) és a
#   nyomtatófejre (az X tengelyhez). Ezek a paraméterek ugyanolyan
#   formátumúak, mint az "accel_chip" paraméter. Csak az 'accel_chip'
#   vagy ez a két paramétert kell megadni.
#max_smoothing:
#   Az egyes tengelyek maximális bemeneti alakító simítása az alakító
#   automatikus kalibrálása során (a 'SHAPER_CALIBRATE' paranccsal).
#   Alapértelmezés szerint nincs megadva maximális simítás.
#   Lásd a Measuring_Resonances útmutatót. a funkció használatának
#   további részleteiért.
#min_freq: 5
#   Minimális frekvencia a rezonancia vizsgálatához.
#   Az alapértelmezett érték 5 Hz.
#max_freq: 133.33
#   Maximális frekvencia a rezonancia vizsgálatához.
#   Az alapértelmezett érték 133,33 Hz.
#accel_per_hz: 75
#   Ez a paraméter annak meghatározására szolgál, hogy egy adott
#   frekvencia teszteléséhez milyen gyorsulást használjunk:
#   accel = accel_per_hz * freq. Minél nagyobb az érték, annál nagyobb
#   a rezgések energiája. Az alapértelmezett értéknél alacsonyabbra is
#   beállítható, ha a rezonanciák túl erősek lesznek a nyomtatón.
#   Az alacsonyabb értékek azonban a nagyfrekvenciás rezonanciák
#   mérését pontatlanabbá teszik.
#   Az alapértelmezett érték 75 (mm/sec).
#hz_per_sec: 1
#   Meghatározza a teszt sebességét. A [min_freq, max_freq]
#   tartományban lévő összes frekvencia tesztelésekor a frekvencia
#   minden másodpercben hz_per_sec értékkel nő. A kis értékek
#   lassúvá teszik a tesztet, a nagy értékek pedig csökkentik a teszt
#   pontosságát. Az alapértelmezett érték 1.0 (Hz/sec == sec^-2).
```

## Konfigurációs fájl segédletek

### [board_pins]

Alaplap tű álnevek (tetszőleges számú szekciót definiálhatunk "board_pins" előtaggal). Ezzel definiálhatsz álneveket a mikrokontroller tűihez.

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

## Tárgyasztal szintező hardver

### [probe]

Z magasságmérő szonda. Ezt a szakaszt a Z magasságmérő hardver engedélyezéséhez lehet definiálni. Ha ez a szakasz engedélyezve van, a PROBE és a QUERY_PROBE kiterjesztett [G-kód parancsok](G-Codes.md#probe) elérhetővé válnak. Lásd még a [szonda kalibrálási útmutatót](Probe_Calibrate.md). A szondaszekció létrehoz egy virtuális "probe:z_virtual_endstop" tűt is. A stepper_z endstop_pin-t erre a virtuális tűre állíthatjuk a cartesian stílusú nyomtatókon, amelyek a szondát használják a Z végállás helyett. Ha a "probe:z_virtual_endstop" típust használjuk, akkor ne definiáljunk position_endstop-ot a stepper_z konfigurációs szakaszban.

```
[probe]
pin:
#   Szonda érzékelési tű. Ha a tű más mikrokontrolleren van, mint a Z
#   léptetőkön, akkor engedélyezi a "multi-mcu homing"-ot.
#   Ezt a paramétert meg kell adni.
#deactivate_on_each_sample: True
#   Ez határozza meg, hogy a Klippernek végre kell-e hajtania a deaktiváló
#   G-kódot minden egyes vizsgálati kísérlet között, amikor több vizsgálati
#   sorozatot hajt végre. Az alapértelmezett érték True.
#x_offset: 0.0
#   A távolság (mm-ben) a szonda és a fúvóka között az X tengely mentén.
#   Az alapértelmezett érték 0.
#y_offset: 0.0
#   A szonda és a fúvóka közötti távolság (mm-ben) az Y tengely mentén.
#   Az alapértelmezett érték 0.
z_offset:
#   A tárgyasztal és a fúvóka közötti távolság (mm-ben), amikor a szonda kiold.
#   Ezt a paramétert meg kell adni.
#speed: 5.0
#   A Z tengely sebessége (mm/sec-ben) tapintáskor.
#   Az alapértelmezett 5 mm/sec.
#samples: 1
#   Az egyes pontok mérésének száma.
#   A vizsgált Z-értékek átlagolásra kerülnek.
#   Az alapértelmezett az 1-szeri mérés.
#sample_retract_dist: 2.0
#   A nyomtatófej felemelésének távolsága (mm-ben) az egyes mérések
#   között (egynél többszöri mérés esetén).
#   Az alapértelmezett érték 2 mm.
#lift_speed:
#   A Z tengely sebessége (mm/sec-ben) a szonda felemelésekor a mérések
#   között. Az alapértelmezett érték ugyanaz, mint a „speed” paraméternél.
#samples_result: average
#   A számítási módszer többszöri mérés esetén „median” vagy „average”.
#   Az alapértelmezett az average.
#samples_tolerance: 0.100
#   Az a maximális Z távolság (mm-ben), amellyel egy minta eltérhet más
#   mintáktól. Ha ezt a tűréshatárt túllépik, akkor vagy hibát jelez, vagy a
#   kísérlet újraindul (lásd: samples_tolerance_retries).
#   Az alapértelmezett érték a 0,100 mm.
#samples_tolerance_retries: 0
#   Az újrapróbálkozások száma, ha olyan mérést csinál, amely meghaladja a
#   samples_tolerance értéket. Újrapróbálkozáskor az összes jelenlegi mérést
#   eldobja, és a mérési kísérlet újraindul. Ha a megadott számú
#   újrapróbálkozás során nem érkezik érvényes méréskészlet, akkor
#   hibaüzenet jelenik meg. Az alapértelmezett nulla, ami hibát okoz az első
#   mérésen, amely meghaladja a samples_tolerance értéket.
#activate_gcode:
#   Az egyes mérési kísérletek előtt végrehajtandó G-kód parancsok listája.
#   Lásd a docs/Command_Templates.md fájlt a G-kód formátumhoz. Ez
#   akkor lehet hasznos, ha a szondát valamilyen módon aktiválni kell. Ne
#   adj ki itt olyan parancsot, amely mozgatja a nyomtatófejet (pl. G1).
#   Az alapértelmezés szerint nem fut semmilyen speciális G-kód parancs
#   aktiváláskor.
#deactivate_gcode:
#   Az egyes mérési kísérletek befejezése után végrehajtandó G-kód
#   parancsok listája. Lásd a docs/Command_Templates.md fájlt a G-kód
#   formátumhoz. Ne adj ki itt olyan parancsot, amely mozgatja a
#   nyomtatófejet. Az alapértelmezés az, hogy deaktiváláskor ne futtassunk
#   semmilyen speciális G-kód parancsot.
```

### [bltouch]

BLTouch szonda. Ezt a szakaszt (a szondaszakasz helyett) a BLTouch szonda engedélyezéséhez lehet definiálni. További információkért lásd a [BL-Touch útmutató](BLTouch.md) és a [parancsreferencia](G-Codes.md#bltouch) című dokumentumot. Egy virtuális "probe:z_virtual_endstop" tű is létrejön (a részleteket lásd a "probe" szakaszban).

```
[bltouch]
sensor_pin:
#   A BLTouch érzékelő érintkezőjéhez csatlakoztatott tű. A legtöbb
#   BLTouch eszköz megköveteli az érzékelő érintkezőjének felhúzását
#   (a tűnév elé illessze be a "^" karaktert).
#   Ezt a paramétert meg kell adni.
control_pin:
#   A BLTouch vezérlőtűjéhez csatlakoztatott tű.
#   Ezt a paramétert meg kell adni.
#pin_move_time: 0.680
#   Az az idő (másodpercben), ameddig várni kell, amíg a BLTouch tű
#   felfelé vagy lefelé mozog. Az alapértelmezett 0,680 másodperc.
#stow_on_each_sample: True
#   Ez határozza meg, hogy a Klippernek utasítania kell-e a tűt, hogy
#   mozogjon felfelé az egyes mérési kísérletek között, amikor több
#   mérési sorozatot hajt végre. Mielőtt False értékre állítaná, olvasd
#   el a docs/BLTouch.md utasításait. Az alapértelmezett érték True.
#probe_with_touch_mode: False
#   Ha ez True értékre van állítva, akkor a Klipper "touch_mode"
#   módban vizsgálja az eszközt. Az alapértelmezett érték False
#   (tapintás "pin_down" módban).
#pin_up_reports_not_triggered: True
#   Állítsd be, hogy a BLTouch következetesen „not triggered”
#   állapotban jelentse-e a mérést a sikeres „pin_up” parancs után.
#   Ennek True-nak kell lennie minden eredeti BLTouch eszköznél.
#   Mielőtt False értékre állítaná, olvasd el a docs/BLTouch.md
#   utasításait. Az alapértelmezett érték True.
#pin_up_touch_mode_reports_triggered: True
#   Állítsd be, hogy a BLTouch következetesen "triggered" állapotot
#   jelentse-e a "pin_up" parancs kövesse a "touch_mode" parancsot.
#   Ennek True-nak kell lennie minden eredeti BLTouch eszköznél.
#   Mielőtt False értékre állítaná, olvasd el a docs/BLTouch.md
#   utasításait. Az alapértelmezett érték True.
#set_output_mode:
#   Kérj egy adott érzékelőtűs kimeneti módot a BLTouch V3.0
#   (és újabb) készüléken. Ezt a beállítást nem szabad más típusú
#   szondákon használni. Állítsd "5V"-ra, ha 5 V-os érzékelőtűs
#   kimenetet kíván kérni (csak akkor használd, ha a vezérlőkártyának
#   5 V-os üzemmódra van szüksége, és 5 V-ot tolerál a bemeneti
#   jelvezetékén). Állítsd „OD” értékre, hogy az érzékelő érintkezőjének
#   kimenete nyitott leeresztési módot használjon.
#   Az alapértelmezett az, hogy nem kér kimeneti módot.
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
#   A paraméterekkel kapcsolatos információkért lásd a "szonda" részt.
```

### [smart_effector]

A "Smart Effector" a Duet3d-től egy Z-szondát valósít meg egy erőérzékelő segítségével. Ezt a részt a `[probe]` helyett definiálhatjuk a Smart Effector specifikus funkcióinak engedélyezéséhez. Ez lehetővé teszi a [futásidejű parancsok](G-Codes.md#smart_effector) használatát is a Smart Effector paramétereinek futásidejű beállításához.

```
[smart_effector]
pin:
#   A Smart Effector Z Probe kimeneti tűjéhez (5. csap) csatlakoztatott tű. Vedd
#   figyelembe, hogy a lapon lévő pullup ellenállás általában nem szükséges.
#   Ha azonban a kimeneti tűn pullup ellenállással csatlakoztatják a lapon
#   lévő tűhöz, akkor ennek az ellenállásnak nagy értékűnek kell lennie
#   (pl. 10K Ohm vagy több). Néhány lapon alacsony értékű pullup ellenállás
#   van a Z szonda bemenetén, ami valószínűleg egy mindig kioldott szonda
#   állapotot fog eredményezni. Ebben az esetben csatlakoztassa a
#   Smart Effector-t a következőhöz a kártya egy másik tűjéhez.
#   Ez a paraméter szükséges.
#control_pin:
#   A Smart Effector vezérlő bemeneti pinjéhez (7-es pin) csatlakoztatott pin.
#   Ha van, a Smart Effector érzékenység programozási parancsai válnak
#   elérhetővé.
#probe_accel:
#   Ha be van állítva, korlátozza a tapogató mozgások gyorsulását
#   (mm/sec^2-ben). A hirtelen nagy gyorsulás a tapogató mozgás kezdetén
#   téves tapintásindítást okozhat, különösen, ha a hotend nehéz. Ennek
#   megakadályozására szükség lehet a gyorsulás csökkentésére a
#   szondázó mozgások gyorsulásával ezzel a paraméterrel.
#recovery_time: 0.4
#   Az utazási mozgások és a tapogató mozgások közötti késleltetés
#   másodpercben. A szondázás előtti gyors mozgatás téves
#   szondakapcsolást eredményezhet. Ez "A szonda a mozgást megelőzően
#   kioldott" hibát okozhat, ha nincs késleltetés beállítva.
#   A 0 érték kikapcsolja a helyreállítási késleltetést.
#   Az alapértelmezett érték 0,4.
#x_offset:
#y_offset:
#   Nem kell beállítani (vagy 0-ra kell állítani).
z_offset:
#   A szonda kioldási magassága. Kezd -0,1 (mm) értékkel, és később
#   állítsd be a következővel `PROBE_CALIBRATE` paranccsal.
#   Ezt a paramétert meg kell adni.
#speed:
#   A Z tengely sebessége (mm/sec-ben) tapogatáskor. Javasoljuk, hogy a
#   tapintási sebességet 20 mm/sec sebességgel kezdjük, és szükség
#   szerint állítsuk be, hogy javítsuk a a tapintás kioldásának pontosságát
#   és megismételhetőségét.
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#deactivate_on_each_sample:
#   A fenti paraméterekkel kapcsolatos további információkért
#   lásd a "szonda" részt.
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

Több extruderes nyomtató esetén minden további extruder után adj hozzá egy új extruder szakaszt. A további extruder szakaszok neve legyen "extruder1", "extruder2", "extruder3", és így tovább. A rendelkezésre álló paraméterek leírását lásd az "extruder" szakaszban.

Lásd a [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg) példakonfigurációt.

```
[extruder1]
#step_pin:
#dir_pin:
#...
#   Tekintsd meg az "extruder" részt az elérhető léptető és
#   fűtőparaméterekért.
#shared_heater:
#   Ez az opció elavult, és többé nem kell megadni.
```

### [dual_carriage]

Az egy tengelyen két kocsival rendelkező cartesian nyomtatók támogatása. Az aktív kocsit a SET_DUAL_CARRIAGE kiterjesztett G-kód parancs segítségével állíthatjuk be. A "SET_DUAL_CARRIAGE CARRIAGE=1" parancs az ebben a szakaszban meghatározott kocsit aktiválja (a CARRIAGE=0 az elsődleges kocsi aktiválását állítja vissza). A kettős kocsitámogatást általában extra extruderekkel kombinálják. A SET_DUAL_CARRIAGE parancsot gyakran az ACTIVATE_EXTRUDER paranccsal egyidejűleg hívják meg. Ügyelj arra, hogy a kocsikat a deaktiválás során parkoló állásba küld.

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
#   Az extruder, amelyhez ez a léptető szinkronizálva van. Ha ez
#   üres karakterláncra van állítva, akkor a léptető nem lesz
#   szinkronizálva az extruderrel. Ezt a paramétert meg kell adni.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   A fenti paraméterek meghatározásához lásd a "léptető" részt.
```

### [manual_stepper]

Kézi léptetők (tetszőleges számú szakasz definiálható "manual_stepper" előtaggal). Ezeket a léptetőket a MANUAL_STEPPER G-kód parancs vezérli. Például: "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". A MANUAL_STEPPER parancs leírását lásd a [G-kódok](G-Codes.md#manual_stepper) fájlban. A léptetők nem kapcsolódnak a nyomtató normál kinematikájához.

```
[manual_stepper my_stepper]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   A paraméterek leírását lásd a "léptető" részben.
#velocity:
#   Állítsd be a léptető alapértelmezett sebességét (mm/sec-ben).
#   Ezt az értéket használja a rendszer, ha a MANUAL_STEPPER parancs nem
#   ad meg SPEED paramétert. Az alapértelmezett érték 5 mm/sec.
#accel:
#   Állítsd be a léptető alapértelmezett gyorsulását (mm/sec^2-en). A nulla
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

A fűtés és a hőmérséklet-érzékelő ellenőrzése. A fűtőelemek ellenőrzése automatikusan engedélyezve van minden olyan fűtőelemhez, amely a nyomtatón be van állítva. Az alapértelmezett beállítások módosításához használd a verify_heater szakaszokat.

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

Egyéni termisztorok (tetszőleges számú szakasz definiálható "termisztor" előtaggal). Egyéni termisztor használható a fűtőberendezés konfigurációs szakaszának sensor_type mezőjében. (Ha például egy "[thermistor my_thermistor]" szekciót definiálunk, akkor a fűtőelem definiálásakor használhatjuk a "sensor_type: my_thermistor" mezőt.) Ügyelj arra, hogy a termisztor szekciót a konfigurációs fájlban az első fűtőszekcióban való használata fölé helyezd.

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

Egyedi ADC hőmérséklet-érzékelők (tetszőleges számú szekciót lehet definiálni "adc_temperature" előtaggal). Ez lehetővé teszi egy olyan egyéni hőmérséklet-érzékelő definiálását, amely egy feszültséget mér egy analóg-digitális átalakító (ADC) tűn, és lineáris interpolációt használ a konfigurált hőmérséklet/feszültség (vagy hőmérséklet/ellenállás) mérések között a hőmérséklet meghatározásához. Az így kapott érzékelő sensor_type-ként használható egy fűtőszekcióban. (Ha például egy "[adc_temperature my_sensor]" szekciót definiálunk, akkor egy fűtőelem definiálásakor használhatjuk a "sensor_type: my_sensor" szekciót). Ügyelj arra, hogy a szenzor szekciót a config fájlban az első felhasználása fölé helyezd a fűtőszekcióban.

```
[adc_temperature my_sensor]
#temperature1:
#voltage1:
#temperature2:
#voltage2:
#...
#   Hőmérsékletek (Celsiusban) és feszültségek (V-ban) készlete referenciaként
#   a hőmérséklet konvertálásakor. Az érzékelőt használó fűtőrész az adc_voltage
#   és a voltage_offset paramétereket is megadhatja az ADC feszültség meghatározásához
#   (a részletekért lásd a "Általános hőmérsékleterősítők" részt).
#   Legalább két mérést kell megadni.
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#...
#   Alternatívaként megadhatunk egy sorban hőmérsékletet (Celsiusban) is
#   és ellenállást (Ohmban), hogy referenciaként használhassuk, amikor átalakítunk egy
#   hőmérsékletet. Ezt az érzékelőt használó fűtőszekcióban megadhatunk egy
#   pullup_resistor paramétert (a részleteket lásd az "extruder" szakaszban).
#   A címen legalább két mérést kell megadni.
```

### [heater_generic]

Általános fűtőtestek (tetszőleges számú szakasz definiálható a "heater_generic" előtaggal). Ezek a fűtőberendezések a standard fűtőberendezésekhez (extruderek, fűtött tárgyasztal) hasonlóan viselkednek. A SET_HEATER_TEMPERATURE paranccsal (lásd a [G-kódok](G-Codes.md#heaters) dokumentumban) állíthatjuk be a célhőmérsékletet.

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

A Klipper számos típusú hőmérséklet-érzékelő definícióját tartalmazza. Ezek az érzékelők bármely olyan konfigurációs szakaszban használhatók, amely hőmérséklet-érzékelőt igényel (például az `[extruder]` vagy a `[heater_bed]` szakaszban).

### Közös termisztorok

Közönséges termisztorok. A következő paraméterek állnak rendelkezésre azokban a fűtőszakaszban, amelyek ezen érzékelők valamelyikét használják.

```
sensor_type:
#   Az egyik "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
#   "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
#   "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", vagy "TDK NTCG104LH104JT1"
sensor_pin:
#   Analóg bemeneti érintkező csatlakozik a termisztorhoz.
#   Ezt a paramétert meg kell adni.
#pullup_resistor: 4700
#   A termisztorhoz csatlakoztatott felhúzó ellenállása (ohmban).
#   Az alapértelmezett érték 4700 ohm.
#inline_resistor: 0
#   A termisztorral egy vonalban elhelyezett extra (nem hőváltozó)
#   ellenállás ellenállása (ohmban). Ritka az ilyen beállítás.
#   Az alapértelmezett érték 0 ohm.
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

BMP280/BME280/BME680 kétvezetékes interfész (I2C) környezeti érzékelők. Vedd figyelembe, hogy ezeket az érzékelőket nem extruderekkel és fűtött tárgyasztalokkal való használatra szánják, hanem a környezeti hőmérséklet (C), a nyomás (hPa), a relatív páratartalom és a BME680 esetében a gázszint ellenőrzésére. Lásd [sample-macros.cfg](../config/sample-macros.cfg) egy gcode_macro-t, amely a hőmérséklet mellett a nyomás és a páratartalom mérésére is használható.

```
sensor_type: BME280
#i2c_address:
#   Az alapértelmezett 118 (0x76). Egyes BME280 érzékelők címe 119
# (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   A fenti paraméterek leírását lásd az "általános I2C beállítások"
#   részben.
```

### HTU21D érzékelő

HTU21D kétvezetékes interfész (I2C) környezeti érzékelő. Vedd figyelembe, hogy ezt az érzékelőt nem extruderekkel és fűtött tárgyasztalokkal való használatra szánják, hanem a környezeti hőmérséklet (C) és a relatív páratartalom ellenőrzésére. Lásd [sample-macros.cfg](../config/sample-macros.cfg) egy gcode_macro-t, amely a hőmérséklet mellett a páratartalom jelentésére is használható.

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
#   Ha True, az olvasás közben más buszkommunikáció nem
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
#   Az alapértelmezett 72 (0x48). A normál tartomány 72-79 (0x48-0x4F),
#   és a cím 3 alacsony bitje a chipen található érintkezőkön keresztül
#   van konfigurálva (általában jumperekkel vagy áthidaló vezetékekkel).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   A fenti paraméterek leírását lásd az "általános I2C beállítások"
#   részben.
#lm75_report_time:
#   A leolvasások közötti intervallum másodpercben.
#   Az alapértelmezett érték 0,8 de a minimum érték 0,5.
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
#   Add meg a fenti két paramétert (a hőmérsékletet Celsiusban és egy
#   ADC-értéket úszóként 0,0 és 1,0 között) a mikrovezérlő
#   hőmérsékletének kalibrálásához. Ez egyes chipeknél javíthatja a
#   jelentett hőmérsékleti pontosságot. A kalibrációs adatok
#   megszerzésének tipikus módja az, hogy néhány órára teljesen
#   áramtalanítja a nyomtatót (hogy megbizonyosodj arról, hogy az
#   környezeti hőmérsékleten van), majd bekapcsolja, és a QUERY_ADC
#   paranccsal megkapja az ADC mérést. Használj más hőmérséklet
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

A DS18B20 egy 1 vezetékes (w1) digitális hőmérséklet érzékelő. Vedd figyelembe, hogy ezt az érzékelőt nem extruderekkel és fűtött tárgyasztalokkal való használatra szánják, hanem inkább a környezeti hőmérséklet (C) ellenőrzésére. Ezek az érzékelők 125 C-ig terjedő tartományban működnek, így pl. kamrahőmérséklet ellenőrzésre használhatók. Egyszerű ventilátor/fűtőberendezés szabályozóként is működhetnek. A DS18B20 érzékelőket csak a "host mcu", pl. a Raspberry Pi támogatja. A w1-gpio Linux kernel modult kell telepíteni hozzá.

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
[fan]
pin:
#   A ventilátort vezérlő kimeneti érintkező. Ezt a paramétert meg kell adni.
#max_power: 1.0
#   Az a maximális teljesítmény (0,0 és 1,0 közötti értékben kifejezve),
#   amelyre a tű beállítható. Az 1,0 érték lehetővé teszi, hogy a tűt hosszabb
#   ideig teljesen engedélyezettre lehessen állítani, míg a 0,5 érték legfeljebb
#   a fele ideig engedélyezi a tűt. Ez a beállítás használható a ventilátor
#   teljes kimeneti teljesítményének korlátozására (hosszabb ideig). Ha ez az
#   érték kisebb, mint 1,0, akkor a ventilátorsebesség-kérelmek nulla és
#   max_power között lesznek skálázva (például ha a max_power értéke 0,9,
#   és 80%-os ventilátorsebességre van szükség, akkor a ventilátor
#   teljesítménye 72%-ra lesz állítva). Az alapértelmezett érték 1.0.
#shutdown_speed: 0
#   A kívánt ventilátorsebesség (0,0 és 1,0 közötti értékben kifejezve), ha a
#   mikrovezérlő szoftvere hibaállapotba kerül. Az alapértelmezett érték 0.
#cycle_time: 0,010
#   Az idő (másodpercben) minden egyes PWM tápciklushoz a ventilátornak.
#   Szoftver alapú PWM használatakor ajánlott 10 ezredmásodperc vagy több.
#   Az alapértelmezett érték 0,010 másodperc.
#hardware_pwm: False
#   Engedélyezd ezt hardveres PWM használatához a szoftveres PWM helyett.
#   A legtöbb ventilátor nem működik jól a hardveres PWM-mel, ezért nem
#   ajánlott ezt engedélyezni, hacsak nincs elektromos követelmény a nagyon
#   nagy sebességű kapcsoláshoz. Hardveres PWM használatakor a tényleges
#   ciklusidőt a megvalósítás korlátozza, és jelentősen eltérhet a kért ciklusidőtől.
#   Az alapértelmezett érték False.
#kick_start_time: 0,100
#   Az idő (másodpercben), hogy a ventilátor teljes fordulatszámon működjön,
#   amikor először engedélyezi, vagy 50%-nál nagyobb mértékben növeli
#   (segíti a ventilátor pörgését). Az alapértelmezett érték 0,100 másodperc.
#off_below: 0,0
#   A minimális bemeneti sebesség, amely a ventilátort táplálja
#   (0,0 és 1,0 közötti értékben kifejezve). Ha az off_below-nál alacsonyabb
#   sebességet kérnek, a ventilátor ehelyett kikapcsol. Ez a beállítás használható
#   a ventilátor leállásának megelőzésére és annak biztosítására, hogy az indítások
#   hatékonyak legyenek. Az alapértelmezett érték 0.0.
#
#   Ezt a beállítást újra kell kalibrálni a max_power beállításakor. A beállítás
#   kalibrálásához kezd az off_below értékét 0,0-ra állítva, és a ventilátor forog.
#   Fokozatosan csökkentse a ventilátor fordulatszámát, hogy meghatározza a
#   legalacsonyabb bemeneti sebességet, amely megbízhatóan hajtja a ventilátort
#   leállás nélkül. Állítsd az off_below-ot az ennek az értéknek megfelelő
#   (például 12% -> 0,12) vagy valamivel magasabb munkaciklusra.
#tachometer_pin:
#   Fordulatszámmérő bemeneti érintkezője a ventilátor fordulatszámának
#   figyeléséhez. Általában felhúzásra van szükség. Ez a paraméter nem kötelező.
#tachometer_ppr: 2
#   Ha a tachometer_pin meg van adva, ez a fordulatszámmérő jelének
#   fordulatonkénti impulzusainak száma. Egy BLDC ventilátor esetében ez általában
#   fele a pólusok számának. Az alapértelmezett érték a 2.
#tachometer_poll_interval: 0,0015
#   Ha a tachometer_pin meg van adva, ez a fordulatszámmérő tűjének lekérdezési
#   periódusa, másodpercben. Az alapértelmezett 0,0015, ami elég gyors a
#   10000 RPM alatti ventilátorok számára 2 PPR mellett. Ennek kisebbnek kell lennie,
#   mint 30/(tachometer_ppr*rpm), némi ráhagyással, ahol az rpm a ventilátor
#   maximális fordulatszáma (rpm-ben).
#enable_pin:
#   Opcionális tű a ventilátor tápellátásának biztosításához. Ez hasznos lehet a
#   dedikált PWM bemenettel rendelkező ventilátorok számára. Néhány ilyen
#   ventilátor még 0%-os PWM bemenetnél is bekapcsolva marad. Ilyenkor a PWM tű
#   normálisan használható, és pl. földkapcsolt FET (normál ventilátorcsap)
#   használható a ventilátor tápellátásának szabályozására.
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
#enable_pin:
#   A fenti paraméterek leírását lásd a "ventilátor" szakaszban.
#heater: extruder
#   A ventilátorhoz társított fűtést meghatározó konfigurációs szakasz neve.
#   Ha itt megadod a fűtőelemek vesszővel elválasztott nevét,
#   akkor a ventilátor engedélyezve lesz, ha valamelyik adott fűtőtest engedélyezve van.
#   Az alapértelmezett az "extruder".
#heater_temp: 50.0
#   A hőmérséklet (Celsiusban), amely alá a fűtőelemnek csökkennie kell, mielőtt
#   a ventilátor kikapcsolna. Az alapértelmezett érték 50 Celsius fok.
#fan_speed: 1.0
#   A ventilátor sebessége (0.0 és 1.0 közötti értékben kifejezve), amelyet a ventilátor
#   alkalmaz, amikor a hozzá tartozó fűtőelem be van kapcsolva.
#   Az alapértelmezett érték 1.0
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
#enable_pin:
#   A fenti paraméterek leírását lásd a "ventilátor" szakaszban.
#fan_speed: 1.0
#   A ventilátor fordulatszáma (0.0 és 1.0 közötti értékben kifejezve),
#   amelyre a ventilátor lesz beállítva, amikor egy fűtőelem vagy
#   léptető vezérlő aktív. Az alapértelmezett érték 1.0
#idle_timeout:
#   Az az idő (másodpercben), miután a léptető-meghajtó vagy a fűtőelem
#   aktív volt, és a ventilátort működtetni kell még.
#   Az alapértelmezett 30 másodperc.
#idle_speed:
#   A ventilátor sebessége (0,0 és 1,0 közötti értékben kifejezve),
#   amelyre a ventilátor be lesz állítva, amikor egy fűtőelem vagy
#   léptető-meghajtó aktív volt, az idle_timeout elérése előtt.
#   Alapértelmezett a fan_speed.
#heater:
#stepper:
#   A ventilátorhoz társított fűtést/léptetőt meghatározó konfigurációs
#   szakasz neve. Ha itt megadod a fűtőelemek/léptetők vesszővel
#   elválasztott nevét, akkor a ventilátor engedélyezve lesz, ha az adott
#   fűtőtestek/léptetők bármelyike engedélyezett. Az alapértelmezett fűtőelem
#   az "extruder", az alapértelmezett léptető pedig mindegyik.
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
#enable_pin:
#   A fenti paraméterek leírását lásd a "ventilátor" részben.
#sensor_type:
#sensor_pin:
#control:
#max_delta:
#min_temp:
#max_temp:
#   A fenti paraméterek leírását lásd az "extruder" részben.
#pid_Kp:
#pid_Ki:
#pid_Kd:
#   Az arányos (pid_Kp), az integrál (pid_Ki) és a derivált (pid_Kd) beállításai
#   a PID visszacsatolásvezérlő rendszerhez. A Klipper a PID beállításokat a
#   következő általános képlettel értékeli ki: ventilátor_pwm = max_power
#   - (Kp*e + Ki*integrál(e) - Kd*derivált(e)) / 255 ahol "e" a
#   "target_temperature - measured_temperature" és "fan_pwm" a kért
#   ventilátorsebesség, ahol a 0.0 tele van, az 1.0 pedig teljesen be van
#   kapcsolva. A pid_Kp, pid_Ki és pid_Kd paramétereket akkor kell megadni,
#   ha a PID vezérlő algoritmus engedélyezve van.
#pid_deriv_time: 2.0
#   Az az időérték (másodpercben), amelyen keresztül a hőmérsékletmérés
#   simításra kerül a PID szabályozási algoritmus használatakor.
#   Ez csökkentheti a mérési zaj hatását. Az alapértelmezett a 2 másodperc.
#target_temp: 40.0
#   Egy hőmérséklet (Celsiusban), amely a célhőmérséklet lesz.
#   Az alapértelmezett a 40 fok.
#max_speed: 1.0
#   A ventilátor sebessége (0,0 és 1,0 közötti értékben kifejezve), amelyre a
#   ventilátor be lesz állítva, ha az érzékelő hőmérséklete meghaladja a
#   beállított értéket. Az alapértelmezett érték 1.0.
#min_speed: 0,3
#   Az a minimális ventilátor fordulatszám (0,0 és 1,0 közötti értékben
#   kifejezve), amelyre a ventilátor be lesz állítva a PID hőmérsékletű
#   ventilátorokhoz. Az alapértelmezett érték 0.3.
#gcode_id:
#   Ha be van állítva, a hőmérsékletet az M105 lekérdezésekben jelenti a
#   megadott azonosítóval. Az alapértelmezés szerint nem jelenti a
#   hőmérsékletet az M105-ön keresztül.
```

### [fan_generic]

Kézi vezérlésű ventilátor (a "fan_generic" előtaggal tetszőleges számú szekciót lehet definiálni). A kézi vezérlésű ventilátor fordulatszámát a SET_FAN_SPEED [G-kód](G-Codes.md#fan_generic) paranccsal lehet beállítani.

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
#   A fenti paraméterek leírását lásd a "ventilátor" részben.
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
#   Az adott LED színt vezérlő tű. A fenti paraméterek közül legalább
#   egyet meg kell adni.
#cycle_time: 0.010
#   Az idő (másodpercben) PWM ciklusonként. Szoftver alapú PWM
#   használata esetén ajánlott ez 10 ezredmásodperc vagy több.
#   Az alapértelmezett érték 0,010 másodperc.
#hardware_pwm: False
#   Engedélyezd ezt a hardveres PWM használatához a szoftveres
#   PWM helyett. Hardveres PWM használatakor a tényleges ciklusidőt
#   a megvalósítás korlátozza, és jelentősen eltérhet a kért ciklusidőtől.
#   Az alapértelmezett érték False.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Beállítja a LED kezdeti színét. Mindegyik értéknek 0,0 és 1,0 között
#   kell lennie. Minden szín alapértelmezett értéke 0.
```

### [neopixel]

Neopixel (más néven WS2812) LED támogatás (tetszőleges számú szekciót definiálhatunk "neopixel" előtaggal). További információkért lásd a [parancs hivatkozást](G-Codes.md#led).

Vedd figyelembe, hogy a [linux mcu](RPi_microcontroller.md) implementáció jelenleg nem támogatja a közvetlenül csatlakoztatott neopixeleket. A Linux kernel interfészt használó jelenlegi tervezet nem teszi lehetővé ezt a forgatókönyvet, mivel a kernel GPIO interfésze nem elég gyors a szükséges impulzusszámok biztosításához.

```
[neopixel my_neopixel]
pin:
#   A neopixelhez csatlakoztatott tű.
#   Ennek a paraméternek a következőnek kell lennie.
#chain_count:
#   A megadott tűhöz "láncolt" Neopixel chipek száma.
#   Az alapértelmezett érték 1 (ami azt jelenti, hogy csak egy
#   Neopixel csatlakozik a tűhöz).
#color_order: GRB
#   Állítsd be a LED hardver által megkövetelt pixelsorrendjét
#   (az R, G, B, W betűket tartalmazó karakterláncot használva, a
#   W opcionális). Alternatívaként ez lehet a pixelsorrendek vesszővel
#   elválasztott listája is - egy minden egyes pixelhez LED-hez a láncban.
#   Az alapértelmezett érték GRB.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Ezekről a paraméterekről lásd a "LED" részt.
```

### [dotstar]

Dotstar (más néven APA102) LED-támogatás (tetszőleges számú szekciót lehet definiálni "dotstar" előtaggal). További információkért lásd a [parancs hivatkozást](G-Codes.md#led).

```
[dotstar my_dotstar]
data_pin:
#   A pont a dotstar adatvonalához csatlakozik.
#   Ezt a paramétert meg kell adni.
clock_pin:
#   A dotstar időjel vonalához csatlakoztatott tű.
#   Ezt a paramétert meg kell adni.
#chain_count:
#   A paraméterrel kapcsolatos információkért lásd a "neopixel" részt.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#   Ezen paraméterek leírásáról nézd meg a "LED" részt.
```

### [pca9533]

PCA9533 LED-támogatás. A PCA9533 a mightyboardon használatos.

```
[pca9533 my_pca9533]
#i2c_address: 98
#   Az I2C cím, amelyet a chip az I2C buszon használ.
#   Használd a 98-at a PCA9533/1-hez, a 99-et a PCA9533/2-hez.
#   Az alapértelmezett érték 98.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   A fenti paraméterek leírását lásd az "általános I2C beállítások"
#   részben.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Ezen paraméterek leírásáról nézd meg a "LED" részt.
```

### [pca9632]

PCA9632 LED támogatás. A PCA9632-t a FlashForge Dreamer-ben használják.

```
[pca9632 my_pca9632]
#i2c_address: 98
#   Az I2C cím, amelyet a chip az I2C buszon használ.
#   Ez lehet 96, 97, 98 vagy 99. Az alapértelmezett érték 98.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   A fenti paraméterek leírását lásd az "általános I2C beállítások"
#   részben.
#scl_pin:
#sda_pin:
#   Alternatív megoldásként, ha a pca9632 nincs hardveres I2C
#   buszhoz csatlakoztatva, akkor megadhatod az "óra" (scl_pin)
#   és "data" (sda_pin) érintkezőket.
#   Az alapértelmezés a hardveres I2C használata.
#color_order: RGBW
#   Állítsd be a LED pixelsorrendjét (egy R, G, B, W betűket
#   tartalmazó sztring segítségével). Az alapértelmezett az RGBW.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Ezen paraméterek leírásáról nézd meg a "LED" részt.
```

## További szervók, gombok és egyéb tűk

### [servo]

Szervók (a "servo" előtaggal tetszőleges számú szekciót lehet definiálni). A szervók a SET_SERVO [G-kód parancs](G-Codes.md#servo) segítségével vezérelhetők. Például: SET_SERVO SERVO=my_servo ANGLE=180

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

A G-kód végrehajtása, amikor egy gombot megnyomnak vagy elengednek (vagy amikor egy tű állapota megváltozik). A gomb állapotát a `QUERY_BUTTON button=my_gcode_button` segítségével ellenőrizhetjük.

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
#   A gomb megnyomásakor végrehajtandó G-kód parancsok listája.
#   A G-kód sablonok támogatottak. Ezt a paramétert meg kell adni.
#release_gcode:
#   A gomb elengedésekor végrehajtandó G-kód parancsok listája.
#   A G-kód sablonok támogatottak. Az alapértelmezés szerint nem
#   futnak le parancsok a gombok felengedésekor.
```

### [output_pin]

Futtatási időben konfigurálható kimeneti tűk (tetszőleges számú szekciót lehet definiálni "output_pin" előtaggal). Az itt konfigurált tűk kimeneti tűkként lesznek beállítva, és futtatási időben a "SET_PIN PIN=my_pin VALUE=.1" típusú kiterjesztett [G-kód parancsok](G-Codes.md#output_pin) segítségével módosíthatjuk őket.

```
[output_pin my_pin]
pin:
#   A kimenetként konfigurálandó tű. Ezt a paramétert meg kell adni.
#pwm: False
#   Állítsd be, hogy a kimeneti lábnak képesnek kell lennie
#   impulzusszélesség-modulációra. Ha ez True, az értékmezőknek 0 és 1
#   között kell lenniük. Ha False, az értékmezők értéke 0 vagy 1 legyen.
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
#   Engedélyezd ezt a hardveres PWM használatához a szoftveres PWM helyett.
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
#   A TMC2130 chip kiválasztási vonalának megfelelő tű. Ez a tű alacsony
#   értékre lesz állítva az SPI-üzenetek elején, és az üzenet befejezése
#   után magasra lesz húzva. Ezt a paramétert meg kell adni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   A fenti paraméterek leírását az „általános SPI-beállítások” részben
#   találja.
#chain_position:
#chain_length:
#   Ezek a paraméterek egy SPI-láncot konfigurálnak. A két paraméter
#   határozza meg a léptető pozícióját a láncban és a teljes lánchosszt.
#   Az 1. pozíció a MOSI jelhez csatlakozó léptetőnek felel meg.
#   Az alapértelmezés szerint nem használ SPI-láncot.
#interpolate: True
#   Ha True, engedélyezd a lépésinterpolációt (az illesztőprogram
#   belsőleg 256 mikrolépéses sebességgel léptet). Ez az interpoláció egy
#   kis szisztémás pozícióeltérést vezet be. A részletekért lásd:
#   TMC_Drivers.md. Az alapértelmezett érték True.
run_current:
#   Az áramerősség (amper RMS-ben) a motorvezérlő konfigurálásához a
#   léptetőmotor mozgása során. Ezt a paramétert meg kell adni.
#hold_current:
#   Az az áramerősség (amper RMS-ben), amelyet a motorvezérlőnek akkor
#   kell leadni, amikor a léptetőmotor nem mozog. A hold_current beállítása
#   nem ajánlott (a részletekért lásd: TMC_Drivers.md). Az alapértelmezett
#   az, hogy nem csökkenti az áramerősséget.
#sense_resistor: 0.110
#   A motor érzékelő ellenállásának ellenállása (ohmban).
#   Az alapértelmezett érték 0,110 ohm.
#stealthchop_threshold: 0
#   A „StealthChop” küszöbérték beállításához szükséges sebesség
#   (mm/sec-ben). Ha be van állítva, a "StealthChop" mód engedélyezve
#   lesz, ha a léptetőmotor sebessége ez alatt az érték alatt van.
#   Az alapértelmezett érték 0, ami letiltja a "StealthChop" módot.
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
#   Állítsd be a megadott regisztert a TMC2130 chip konfigurációja során.
#   Ez egyéni motorparaméterek beállítására használható.
#   Az egyes paraméterek alapértelmezett értékei a paraméter neve mellett
#   találhatók a fenti listában.
#diag0_pin:
#diag1_pin:
#   A mikrovezérlő tűje a TMC2130 chip egyik DIAG tűjéhez csatlakozik.
#   Csak egyetlen DIAG tűt kell megadni. A tű "active low", ezért
#   általában "^!" előtagja van. Ennek beállítása egy
#   „tmc2130_stepper_x:virtual_endstop” virtuális tűt hoz létre, amely a
#   léptető endstop_pin-jeként használható. Ez lehetővé teszi az
#   „érzékelő nélküli kezdőpont felvétel” funkciót. (Győződj meg arról,
#   hogy a driver_SGT-t is megfelelő érzékenységi értékre állítja be.)
#   Az alapértelmezés az, hogy nem engedélyezi az érzékelő nélküli
#   kezdőpont felvételt.
```

### [tmc2208]

TMC2208 (vagy TMC2224) motorvezérlő konfigurálása egyvezetékes UART-on keresztül. A funkció használatához definiáljon egy konfigurációs részt "tmc2208" előtaggal, amelyet a megfelelő léptető konfigurációs rész neve követ (például "[tmc2208 stepper_x]").

```
[tmc2208 stepper_x]
uart_pin:
#   A TMC2208 PDN_UART vonalhoz csatlakoztatott tű.
#   Ezt a paramétert meg kell adni.
#tx_pin:
#   Ha külön vételi és adási vonalat használ a meghajtóval való
#   kommunikációhoz, akkor állítsd be az uart_pin paramétert a vételi
#   lábra, és a tx_pin értéket az átviteli lábra. Az alapértelmezett az
#   uart_pin használata mind olvasáshoz, mind íráshoz.
#select_pins:
#   A tmc2208 UART elérése előtt beállítandó tűk vesszővel elválasztott
#   listája. Ez hasznos lehet egy analóg mux konfigurálásakor az UART
#   kommunikációhoz. Az alapértelmezett az, hogy nem konfigurál
#   semmilyen érintkezőt.
#interpolate: True
#   Ha True, engedélyezd a lépésinterpolációt (a motorvezérlő belsőleg
#   256 mikrolépéses sebességgel léptet). Ez az interpoláció egy kis
#   szisztémás pozícióeltérést vezet be. A részletekért lásd:
#   TMC_Drivers.md. Az alapértelmezett érték True.
run_current:
#   Az áramerősség (amper RMS-ben) a meghajtó konfigurálásához a
#   léptetőmotor mozgása során. Ezt a paramétert meg kell adni.
#hold_current:
#   Az az áramerősség (amper RMS-ben), amelyet a motorvezérlő akkor
#   ad le, amikor a léptető nem mozog. A hold_current beállítása nem
#   ajánlott (a részletekért lásd: TMC_Drivers.md).
#   Az alapértelmezett az, hogy nem csökkenti az áramerősséget.
#sense_resistor: 0.110
#   A motor érzékelő ellenállásának ellenállása (ohmban).
#   Az alapértelmezett érték 0,110 ohm.
#stealthchop_threshold: 0
#   A „StealthChop” küszöbérték beállításához szükséges sebesség
#   (mm/sec-ben). Ha be van állítva, a "StealthChop" mód engedélyezve
#   lesz, ha a léptetőmotor sebessége ez alatt az érték alatt van.
#   Az alapértelmezett érték 0, ami letiltja a "StealthChop" módot.
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
#   Állítsd be a megadott regisztert a TMC2208 chip konfigurációja során.
#   Ez egyéni motorparaméterek beállítására használható. Az egyes
#   paraméterek alapértelmezett értékei a paraméter neve mellett
#   találhatók a fenti listában.
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
#   Állítsd be a megadott regisztert a TMC2209 chip konfigurációja során.
#   Ez egyéni motorparaméterek beállítására használható.
#   Az egyes paraméterek alapértelmezett értékei a paraméter neve
#   mellett találhatók a fenti listában.
#diag_pin:
#   A TMC2209 chip DIAG tűjéhez csatlakoztatott mikrovezérlő tűje.
#   A tű előtagja általában "^"-vel történik, hogy lehetővé tegye a
#   felhúzást. Ennek beállítása egy
#   "tmc2209_stepper_x:virtual_endstop" virtuális tűt hoz létre,
#   amely a léptető endstop_pin-jeként használható. Ez lehetővé teszi a
#   "végálláskapcsoló nélküli kezdőpont felvételt". (Győződj meg arról,
#   hogy a driver_SGTHRS-t is megfelelő érzékenységi értékre állítja be.)
#   Alapértelmezés szerint nincs engedélyezve a végálláskapcsoló nélküli
#   kezdőpont felvételt.
```

### [tmc2660]

TMC2660 motorvezérlő konfigurálása SPI-buszon keresztül. A funkció használatához definiáljon egy konfigurációs szekciót tmc2660 előtaggal, amelyet a megfelelő léptető konfigurációs szekció neve követ (például "[tmc2660 stepper_x]").

```
[tmc2660 stepper_x]
cs_pin:
#   A TMC2660 chip kiválasztási vonalának megfelelő tű. Ez a tű
#   alacsonyra lesz állítva az SPI-üzenetek elején, és magasra az
#   üzenetátvitel befejezése után. Ezt a paramétert meg kell adni.
#spi_speed: 4000000
#   A TMC2660 léptető meghajtóval való kommunikációhoz használt
#   SPI-busz-frekvencia. Az alapértelmezett érték 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   A fenti paraméterek leírását a „általános SPI-beállítások”
#   részben találja.
#interpolate: True
#   Ha True, engedélyezd a lépésinterpolációt (az illesztőprogram
#   belsőleg 256 mikrolépéses sebességgel léptet). Ez csak akkor
#   működik, ha a mikrolépések 16-ra vannak állítva. Az interpoláció
#   egy kis szisztémás pozícióeltérést vezet be. A részletekért lásd a
#   TMC_Drivers.md fájlt. Az alapértelmezett érték True.
run_current:
#   A motorvezérlő által a léptető mozgása során leadott áram erőssége
#   (amper RMS-ben). Ezt a paramétert meg kell adni.
#sense_resistor:
#   A motor érzékelő ellenállásának ellenállása (ohmban).
#   Ezt a paramétert meg kell adni.
#idle_current_percent: 100
#   A motorvezérlő run_current százalékos aránya lecsökken, amikor az
#   üresjárati időtúllépés lejár (az időtúllépést az [idle_timeout]
#   konfigurációs szakaszban kell beállítani). Az áramerősség ismét
#   megemelkedik, ha a léptetőnek ismét mozognia kell. Ügyelj arra,
#   hogy ezt elég magas értékre állítsd be, hogy a léptetők ne veszítsék el
#   pozíciójukat. Van egy kis késleltetés is, amíg az áram ismét
#   megemelkedik, ezért ezt vedd figyelembe, amikor a léptető
#   alapjárata közben gyors mozdulatokat ad parancsba.
#   Az alapértelmezett érték 100 (nincs csökkentés).
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
#   Állítsd be a megadott paramétert a TMC2660 chip konfigurációja során.
#   Ez egyéni motorvezérlő paraméterek beállítására használható.
#   Az egyes paraméterek alapértelmezett értékei a paraméter neve
#   mellett találhatók a fenti listában. Tekintsd meg a TMC2660 adatlapját
#   az egyes paraméterek működéséről és a paraméter kombinációk
#   korlátozásairól. Különös figyelmet kell fordítani a CHOPCONF
#   regiszterre, ahol a CHM nullára vagy egyesre állítása
#   elrendezésmódosításokhoz vezet (a HDEC első bitje) ebben az esetben
#   a HSTRT MSB-jeként értelmeződik).
```

### [tmc5160]

TMC5160 motorvezérlő konfigurálása SPI-buszon keresztül. A funkció használatához definiáljon egy konfigurációs szekciót "tmc5160" előtaggal, amelyet a megfelelő léptető konfigurációs szekció neve követ (például "[tmc5160 stepper_x]").

```
[tmc5160 stepper_x]
cs_pin:
#   A TMC5160 chip kiválasztási vonalának megfelelő tű. Ez a tű alacsony
#   értékre lesz állítva az SPI-üzenetek elején, és az üzenet befejezése után
#   magasra változik. Ezt a paramétert meg kell adni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   A fenti paraméterek leírását az „általános SPI-beállítások”
#   részben találja.
#chain_position:
#chain_length:
#   Ezek a paraméterek egy SPI-láncot konfigurálnak. A két paraméter
#   határozza meg a léptető pozícióját a láncban és a teljes lánchosszt.
#   Az 1. pozíció a MOSI jelhez csatlakozó léptetőnek felel meg.
#   Az alapértelmezés szerint nem használ SPI-láncot.
#interpolate: True
#   Ha True, engedélyezd a lépésinterpolációt (a motorvezérlő belsőleg
#   256 mikrolépéses sebességgel léptet). Az alapértelmezett érték True.
run_current:
#   Az áramerősség (amper RMS-ben) a meghajtó konfigurálásához a
#   léptető mozgása során. Ezt a paramétert meg kell adni.
#hold_current:
#   Az az áramerősség (amper RMS-ben), amelyet a motorvezérlő akkor
#   ad le, amikor a léptető nem mozog. A hold_current beállítása nem
#   ajánlott (a részletekért lásd: TMC_Drivers.md).
#   Az alapértelmezett az, hogy nem csökkenti az áramerősséget.
#sense_resistor: 0.075
#   A motor érzékelő ellenállásának ellenállása (ohmban).
#   Az alapértelmezett érték 0,075 ohm.
#stealthchop_threshold: 0
#   A „StealthChop” küszöbérték beállításához szükséges sebesség
#   (mm/sec-ben). Ha be van állítva, a "StealthChop" mód engedélyezve
#   lesz, ha a léptetőmotor sebessége ez alatt az érték alatt van.
#   Az alapértelmezett érték 0, ami letiltja a "StealthChop" módot.
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
#   Állítsd be a megadott regisztert a TMC5160 chip konfigurációja során.
#   Ez egyéni motorparaméterek beállítására használható. Az egyes
#   paraméterek alapértelmezett értékei a paraméter neve mellett
#   találhatók a fenti listában.
#diag0_pin:
#diag1_pin:
#   A mikrovezérlő tűje a TMC5160 chip egyik DIAG vonalához csatlakozik.
#   Csak egyetlen DIAG tűt kell megadni. A tű "active low", ezért általában
#   "^!" előtagja van. Ennek beállítása egy
#   „tmc5160_stepper_x:virtual_endstop” virtuális tűt hoz létre, amely a
#   léptető endstop_pin-jeként használható. Ez lehetővé teszi az „érzékelő
#   nélküli kezdőpont felvétel” funkciót. (Győződj meg arról, hogy a
#   driver_SGT-t is megfelelő érzékenységi értékre állítja be.)
#   Az alapértelmezés az, hogy nem engedélyezi az érzékelő nélküli
#   kezdőpont felvételt.
```

## Futás-idejű léptetőmotor áram konfiguráció

### [ad5206]

Statikusan konfigurált AD5206 digipotok, amelyek SPI-buszon keresztül csatlakoznak (tetszőleges számú szekciót lehet definiálni "ad5206" előtaggal).

```
[ad5206 my_digipot]
enable_pin:
#   Az AD5206 chip kiválasztási vonalának megfelelő pin. Ez a pin
#   az SPI-üzenetek elején alacsonyra lesz állítva, és magasra emelkedik
#   az üzenet befejezése után. Ezt a paramétert meg kell adni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Lásd az "általános SPI-beállítások" című leírást a
#   fenti paraméterek megadásához.
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
#   Az adott AD5206 csatorna statikus beállítására szolgáló érték. Ez
#   általában 0,0 és 1,0 közötti számra van állítva, ahol az 1,0 a
#   legnagyobb ellenállás és 0,0 a legkisebb ellenállás. Azonban,
#   a tartomány megváltoztatható a 'scale' paraméterrel (lásd alább).
#   Ha egy csatorna nincs megadva, akkor konfigurálatlanul marad.
#scale:
#   Ezzel a paraméterrel módosítható a 'channel_x' paraméter
#   értelmezése. Ha megadod, akkor a 'channel_x' paramétereknek
#   0,0 és 'scale' között kell lennie. Ez akkor lehet hasznos, ha az
#   AD5206 a léptető feszültség referenciák beállítására szolgál. A „mérleg” tud
#   egyenértékű léptető áramerősséget állítani, ha az AD5206 értéken lenne
#   a legnagyobb ellenállása, majd a 'channel_x' paraméterek lehetnek
#   megadva a léptető kívánt amperértékével. Az
#   alapértelmezés szerint nem skálázza a 'channel_x' paramétereket.
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
#   A használt LCD chip típusa. Ez lehet "hd44780", "hd44780_spi", "st7920",
#   "emulated_st7920", "uc1701", "ssd1306" vagy "sh1106". Az egyes
#   típusokról és az általuk biztosított további paraméterekről az alábbi
#   képernyőszakaszokban talál információkat.
#   Ezt a paramétert meg kell adni.
#display_group:
#   A kijelzőn megjelenítendő display_data csoport neve. Ez szabályozza a
#   képernyő tartalmát (további információért lásd a „display_data” részt).
#   Az alapértelmezett _default_20x4 a hd44780-as kijelzőknél és a
#   _default_16x4 a többi képernyőnél.
#menu_timeout:
#   Időkorlát a menühöz. Ha ennyi másodpercig inaktív, az automatikusan
#   kilép a menüből, vagy visszatér a főmenübe, ha az automatikus indítás
#   engedélyezve van. Az alapértelmezett 0 másodperc (letiltva)
#menu_root:
#   A főmenü rész neve, amely akkor jelenik meg, amikor a kódolóra kattint
#   a kezdőképernyőn. Az alapértelmezett érték a __main, és ez a
#   klippy/extras/display/menu.cfg fájlban meghatározott alapértelmezett
#   menüket mutatja.
#menu_reverse_navigation:
#   Ha engedélyezve van, a listában történő navigáció fel és lefelé irányát
#   váltja. Az alapértelmezett érték False. Ez a paraméter nem kötelező.
#encoder_pins:
#   A kódolóhoz csatlakoztatott érintkezők. A kódoló használatakor 2
#   érintkezőt kell biztosítani. Ezt a paramétert a menü használatakor kell
#   megadni.
#encoder_steps_per_detent:
#   Hány lépést ad ki a kódoló reteszelésenként ("kattintás"). Ha a
#   kódolónak két reteszre van szüksége a bejegyzések közötti mozgáshoz,
#   vagy két bejegyzést mozgat meg egy rögzítésből, próbáld meg ezt
#   megváltoztatni. A megengedett értékek 2 (féllépcsős) vagy
#   4 (teljes lépés). Az alapértelmezett érték a 4.
#click_pin:
#   Az „Enter” gombhoz vagy a kódoló „kattintásához” csatlakoztatott tű.
#   Ezt a paramétert a menü használatakor kell megadni.
#   Az „analog_range_click_pin” konfigurációs paraméter jelenléte ezt a
#   paramétert digitálisról analógra változtatja.
#back_pin:
#   A „vissza” gombhoz csatlakoztatott tű. Ez a paraméter nem kötelező,
#   a menü enélkül is használható. Az „analog_range_back_pin”
#   konfigurációs paraméter jelenléte ezt a paramétert digitálisról
#   analógra változtatja.
#up_pin:
#   A tű a „fel” gombhoz csatlakozik. Ezt a paramétert kódoló nélküli menü
#   használatakor kell megadni. Az „analog_range_up_pin” konfigurációs
#   paraméter jelenléte ezt a paramétert digitálisról analógra változtatja.
#down_pin:
#   A tű a „le” gombhoz csatlakozik. Ezt a paramétert kódoló nélküli menü
#   használatakor kell megadni. Az „analog_range_down_pin” konfigurációs
#   paraméter jelenléte ezt a paramétert digitálisról analógra változtatja.
#kill_pin:
#   A tű a „kill” gombhoz csatlakozik. Ez a gomb vészleállítást hív.
#   Az „analog_range_kill_pin” konfigurációs paraméter jelenléte ezt a
#   paramétert digitálisról analógra változtatja.
#analog_pullup_resistor: 4700
#   Az analóg gombhoz csatlakoztatott felhúzó ellenállása (ohmban).
#   Az alapértelmezett érték 4700 ohm.
#analog_range_click_pin:
#   Az „Enter” gomb ellenállási tartománya.
#   Analóg gomb használata esetén a tartomány minimális és
#   maximális értékeit vesszővel elválasztva kell megadni.
#analog_range_back_pin:
#   A „vissza” gomb ellenállási tartománya.
#   Analóg gomb használata esetén a tartomány minimális és
#   maximális értékeit vesszővel elválasztva kell megadni.
#analog_range_up_pin:
#   A „fel” gomb ellenállási tartománya.
#   Analóg gomb használata esetén a tartomány minimális és
#   maximális értékeit vesszővel elválasztva kell megadni.
#analog_range_down_pin:
#   A „le” gomb ellenállási tartománya.
#   Analóg gomb használata esetén a tartomány minimális és
#   maximális értékeit vesszővel elválasztva kell megadni.
#analog_range_kill_pin:
#   A „kill” gomb ellenállási tartománya.
#   Analóg gomb használata esetén a tartomány minimális és
#   maximális értékeit vesszővel elválasztva kell megadni.
```

#### hd44780 kijelző

Információk a HD44780 kijelzők konfigurálásáról (amelyet a "RepRapDiscount 2004 Smart Controller" típusú kijelzőkben használnak).

```
[display]
lcd_type: hd44780
#   Állítsd "hd44780" értékre a hd44780 kijelzőkhöz.
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#   A tűk egy hd44780 típusú LCD-hez csatlakoznak.
#   Ezeket a paramétereket meg kell adni.
#hd44780_protocol_init: True
#   Végezz 8 bites/4 bites protokoll inicializálást hd44780 kijelzőn.
#   Ez szükséges a valódi hd44780-as eszközökön. Előfordulhat
#   azonban, hogy ezt bizonyos "klónozó" eszközökön le kell tiltani.
#   Az alapértelmezett érték True.
#line_length:
#   Állítsd be a soronkénti karakterek számát egy hd44780 típusú
#   LCD-n. A lehetséges értékek: 20 (alapértelmezett) és 16.
#   A sorok száma 4-re van rögzítve.
...
```

#### hd44780_spi kijelző

Információ a HD44780_spi kijelző konfigurálásáról egy 20x04-es kijelző, egy hardveres "shift register" (amelyet a mightyboard alapú nyomtatókban használnak).

```
[display]
lcd_type: hd44780_spi
#   Állítsd be a "hd44780_spi" értéket a hd44780_spi kijelzőkhöz.
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   A kijelzőt vezérlő műszakregiszterhez csatlakoztatott tűk.
#   Az spi_software_miso_pin-t a nyomtató alaplapjának használaton
#   kívüli tűjére kell állítani, mivel a shift regiszternek nincs MISO tűje,
#   de a szoftver SPI megvalósításához ezt a tűt be kell állítani.
#hd44780_protocol_init: True
#   Végezz 8 bites/4 bites protokoll inicializálást hd44780 kijelzőn.
#   Ez szükséges a valódi hd44780-as eszközökön. Előfordulhat
#   azonban, hogy ezt bizonyos "klónozó" eszközökön le kell tiltani.
#   Az alapértelmezett érték True.
#line_length:
#   Állítsd be a soronkénti karakterek számát egy hd44780 típusú LCD-n.
#   A lehetséges értékek: 20 (alapértelmezett) és 16.
#   A sorok száma 4-re van rögzítve.
...
```

#### st7920 kijelző

Információk az ST7920 kijelzők konfigurálásáról (amelyet a "RepRapDiscount 12864 Full Graphic Smart Controller" típusú kijelzőknél használnak).

```
[display]
lcd_type: st7920
#   Állítsd az "st7920"-ra az st7920-as kijelzőkhöz.
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
#   Állítsd az "emulated_st7920" értékre az emulated_st7920 kijelzőkhöz.
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

#### uc1701 kijelző

Információk az UC1701 kijelzők konfigurálásáról (amelyet az "MKS Mini 12864" típusú kijelzőknél használnak).

```
[display]
lcd_type: uc1701
#   Állítsd "uc1701" értékre az uc1701 kijelzőkhöz.
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

#### ssd1306 és sh1106 kijelzők

Az SSD1306 és SH1106 kijelzők konfigurálásával kapcsolatos információk.

```
[display]
lcd_type:
#   Állítsd be az "ssd1306" vagy az "sh1106" értéket az adott
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
#   Állítsd be a Vcomh értéket a kijelzőn. Ez az érték egyes
#   OLED-kijelzők "elkenődési" hatásával jár. Az érték 0 és 63 között
#   változhat. Az alapértelmezett érték 0.
#invert: False
#   A TRUE megfordítja a képpontokat bizonyos OLED-kijelzőkön.
#   Az alapértelmezett érték False.
#x_offset: 0
#   Állítsd be a vízszintes eltolás értékét az SH1106 kijelzőkön.
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
#   A "param_" előtaggal tetszőleges számú beállítás megadható. A megadott
#   névhez a rendszer hozzárendeli a megadott értéket (Python literálként
#   elemzi), és a makróbővítés során elérhető lesz. Ha a paraméter átadásra
#   kerül a render() hívásban, akkor ez az érték lesz felhasználva a
#   makróbővítés során. Például egy "param_speed = 75" konfigurációban
#   előfordulhat, hogy a hívó "render('my_template_name', param_speed=80)".
#   A paraméternevek nem tartalmazhatnak nagybetűket.
text:
#   A sablon megjelenítésekor visszaadandó szöveg. Ennek a mezőnek a
#   kiértékelése parancssablonok segítségével történik (lásd:
#   docs/Command_Templates.md). Ezt a paramétert meg kell adni.
```

### [display_glyph]

Egy egyéni írásjel megjelenítése az azt támogató kijelzőkön. A megadott névhez hozzárendeli a megadott megjelenítési adatokat, amelyekre aztán a megjelenítési sablonokban a két "tilde" szimbólummal körülvett nevükkel lehet hivatkozni, pl. `~my_display_glyph~`

Lásd a [sample-glyphs.cfg](../config/sample-glyphs.cfg) néhány példáját.

```
[display_glyph my_display_glyph]
#data:
#   A megjelenítési adatok 16 sorként tárolva, amelyek 16 bitből állnak
#   (pixelenként 1), ahol a '.' egy üres pixel, a '*' pedig egy bekapcsolt
#   képpont (pl. "****************" folyamatos vízszintes vonal
#   megjelenítéséhez). Alternatív megoldásként használhatunk „0”-t
#   üres pixelekhez és „1”-et a bekapcsolt pixelekhez. Helyezz minden
#   megjelenítési sort egy külön konfigurációs sorba. A karakterjelnek
#   pontosan 16, egyenként 16 bites sorból kell állnia.
#   Ez a paraméter nem kötelező.
#hd44780_data:
#   Glyph használható 20x4 hd44780 kijelzőkön. A karakterjelnek pontosan
#   8, egyenként 5 bites sorból kell állnia. Ez a paraméter nem kötelező.
#hd44780_slot:
#   A hd44780 hardver indexe (0..7) a karakterjel tárolására. Ha több
#   különálló kép használja ugyanazt a tárat, ügyelj arra, hogy ezek
#   közül csak egyet használj az adott képernyőn. Ez a paraméter akkor
#   szükséges, ha a hd44780_data meg van adva.
```

### [display my_extra_display]

Ha a printer.cfg fájlban a fentiek szerint egy elsődleges [display] szakasz került meghatározásra, akkor több kiegészítő kijelzőt is lehet definiálni. Vedd figyelembe, hogy a kiegészítő kijelzők jelenleg nem támogatják a menüfunkciókat, így nem támogatják a "menu" opciókat vagy a gombok konfigurálását.

```
[display my_extra_display]
# A rendelkezésre álló paramétereket lásd a "kijelző" szakaszban.
```

### [menu]

Testreszabható LCD kijelző menük.

Egy [alapértelmezett menükészlet](../klippy/extras/display/menu.cfg) automatikusan létrejön. A menüt a fő printer.cfg konfigurációs fájlban lévő alapértelmezett értékek felülbírálásával lehet helyettesíteni vagy bővíteni.

A sablonok renderelése során elérhető menüattribútumokról a [parancssablon dokumentumban](Command_Templates.md#menu-templates) található információ.

```
# Az összes menü konfigurációs szakaszhoz elérhető közös paraméterek.
#[menu __some_list __some_name]
#type: disabled
#   A menüelem végleg letiltva, csak a kötelező attribútum a 'type'.
#   Lehetővé teszi a meglévő menüpontok egyszerű letiltását/elrejtését.

#[menu some_name]
#type:
#   Az egyik parancs, input, list, text:
#       command - alapvető menüelem különféle script triggerekkel
#       input   - ugyanaz, mint a „command”, de értékváltoztató
#       képességekkel rendelkezik.
#                 Nyomja meg a szerkesztési mód
#                 elindításához/leállításához.
#       list    - lehetővé teszi a menüelemek egy görgethető listába
#                 történő csoportosítását.
#                 Adj hozzá a listához menükonfigurációk létrehozásával
#                 a „some_list” előtagként – 
#                 például: [menu some_list some_item_in_the_list]
#       vsdlist - ugyanaz, mint a "list", de hozzáfűzi a virtuális
#                 sdcard fájlokat (a jövőben eltávolítjuk)
#name:
#   A menüpont neve - sablonként értékelve.
#enable:
#   Sablon, amely igazra vagy hamisra értékeli.
#index:
#   Pozíció, ahol egy elemet be kell illeszteni a listába. Alapértelmezés
#   szerint az elem a végére kerül hozzáadásra.

#[menu some_list]
#type: list
#name:
#enable:
#   A fenti paraméterek leírását lásd fent.

#[menu some_list some_command]
#type: command
#name:
#enable:
#   A fenti paraméterek leírását lásd fent.
#gcode:
#   Gombkattintással vagy hosszú kattintással futtatható szkript.
#   Sablonként értékelve.

#[menu some_list some_input]
#type: input
#name:
#enable:
#   A fenti paraméterek leírását lásd fent.
#input:
#   Szerkesztéskor használandó kezdeti érték – sablonként értékelve.
#   Az eredménynek lebegőértéknek kell lennie.
#input_min:
#   Tartomány minimális értéke – sablonként értékelve.
#   Alapértelmezett -99999.
#input_max:
#   Tartomány maximális értéke – sablonként értékelve.
#   Alapértelmezett 99999.
#input_step:
#   Szerkesztési lépés – pozitív egész számnak vagy lebegőértéknek
#   kell lennie. Belső gyorslépéssel rendelkezik.
#   Ha "(input_max - input_min) / input_step > 100", akkor a gyors
#   sebesség lépése 10 * input_step, különben a gyors ütem ugyanaz
#   a bemeneti_lépés.
#realtime:
#   Ez az attribútum statikus logikai értéket fogad el. Ha engedélyezve
#   van, akkor a G-kód szkript minden értékváltozás után lefut.
#   Az alapértelmezett érték False.
#gcode:
#   Gombkattintással, hosszú kattintással vagy értékmódosítással
#   futtatható szkript. Sablonként értékelve. A gomb kattintása elindítja
#   a szerkesztési mód kezdetét vagy befejezését.
```

## Nyomtatószál érzékelők

### [filament_switch_sensor]

Nyomtatószál érzékelő. Támogatás a nyomtatószál behelyezésének és kifutásának érzékelésére kapcsolóérzékelő, például végálláskapcsoló segítségével.

További információkért lásd a [parancs hivatkozást](G-Codes.md#filament_switch_sensor).

```
[filament_switch_sensor my_sensor]
#pause_on_runout: True
#   Ha True értékre van állítva, a PAUSE azonnal végrehajtódik, miután a
#   rendszer szálkifutást észlel. Ne feledd, hogy ha a pause_on_runout
#   értéke False, és a runout_gcode kimarad, akkor a kifutás észlelése le
#   van tiltva. Az alapértelmezett érték True.
#runout_gcode:
#   A nyomtatószál kifutását követően végrehajtandó G-kód parancsok listája.
#   Lásd a docs/Command_Templates.md fájlt a G-kód formátumhoz. Ha a
#   pause_on_runout értéke True, ez a G-kód a PAUSE befejezése után fog
#   futni. Az alapértelmezés szerint nem fut semmilyen G-kód parancs.
#insert_gcode:
#   A nyomtatószál-beillesztés észlelése után végrehajtandó G-kód parancsok
#   listája. Lásd a docs/Command_Templates.md fájlt a G-kód formátumhoz.
#   Az alapértelmezés szerint nem fut semmilyen G-kód parancs, ami letiltja
#   a beszúrás észlelését.
#event_delay: 3.0
#   Az események közötti késleltetés minimális időtartama másodpercben.
#   Az ebben az időszakban elindított eseményeket a rendszer csendben
#   figyelmen kívül hagyja. Az alapértelmezett érték 3 másodperc.
#pause_delay: 0.5
#   A szüneteltetési parancs kiküldése és a runout_gcode végrehajtása
#   között eltelt idő másodpercben. Hasznos lehet növelni ezt a késleltetést,
#   ha az OctoPrint furcsa szüneteltetést mutat.
#   Az alapértelmezett érték 0,5 másodperc.
#switch_pin:
#   Az a tű, amelyre a kapcsoló csatlakoztatva van.
#   Ezt a paramétert meg kell adni.
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
#   Az érzékelőhöz csatlakoztatott analóg bemeneti érintkezők. Ezeket a
#   paramétereket meg kell adni.
#cal_dia1: 1.50
#cal_dia2: 2.00
#   Az érzékelők kalibrációs értékei (mm-ben). Az alapértelmezett érték
#   1,50 a cal_dia1 és 2,00 a cal_dia2 esetén.
#raw_dia1: 9500
#raw_dia2: 10500
#   Az érzékelők nyers kalibrációs értékei. Az alapértelmezett érték
#   9500 a raw_dia1 és 10500 a raw_dia2 esetén.
#default_nominal_filament_diameter: 1.75
#   A nyomtatószál névleges átmérője. Ezt a paramétert meg kell adni.
#max_difference: 0.200
#   Az izzószál átmérőjének megengedett legnagyobb eltérése
#   milliméterben (mm).
#   Ha az izzószál névleges átmérője és az érzékelő kimenete közötti
#   különbség nagyobb, mint +- max_difference, az extrudálási szorzó
#   visszaáll %100-ra. Az alapértelmezett érték 0,200.
#measurement_delay: 70
#   Az érzékelő és a nyomtatófej/forró vége (nozzle) közötti távolság
#   milliméterben (mm). Az érzékelő és a nyomtatófej közötti
#   nyomtatószál default_nominal_filament_diameter-ként lesz kezelve.
#   A gazdagép modul FIFO logikával működik. Minden szenzorértéket
#   és pozíciót egy tömbben tart, és visszaállítja őket a megfelelő pozícióba.
#   Ezt a paramétert meg kell adni.
#enable: False
#   Az érzékelő engedélyezve vagy letiltva a bekapcsolás után.
#   Az alapértelmezett a letiltása.
#measurement_interval: 10
#   Hozzávetőleges távolság (mm-ben) az érzékelő leolvasásai között.
#   Az alapértelmezett 10 mm.
#logging: False
#   Kimeneti átmérő a terminálhoz és a klipper.log-hoz küld, amit ki
#   lehet kapcsolni.
#min_diameter: 1.0
#   A virtuális trigger minimális átmérője filament_switch_sensor.
#use_current_dia_while_delay: False
#   Használd az aktuális átmérőt a névleges átmérő helyett, amíg a
#   mérési késleltetés nem futott át.
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   A fenti paraméterek leírását lásd a "filament_switch_sensor" részben.
```

## Alaplap specifikus hardvertámogatás

### [sx1509]

Konfiguráljon egy SX1509 I2C-GPIO bővítőt. Az I2C-kommunikáció által okozott késleltetés miatt NEM szabad az SX1509 tűit motorvezérlő engedélyező, STEP vagy DIR tűként vagy bármilyen más olyan tűként használni, amely gyors bit-impulzust igényel. Legjobban statikus vagy G-kód vezérelt digitális kimenetekként vagy hardveres PWM tűként használhatók pl. ventilátorokhoz. Bármennyi szekciót definiálhatunk "sx1509" előtaggal. Minden egyes bővítő egy 16 tűből álló készletet biztosít (sx1509_my_sx1509:PIN_0-tól sx1509_my_sx1509:PIN_15-ig), amelyek a nyomtató konfigurációjában használhatók.

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
#   itt megadhatod a busz nevét.
#   Az alapértelmezett a mikrovezérlő I2C busz használata.
```

### [samd_sercom]

SAMD SERCOM konfiguráció annak megadására, hogy mely tűket kell használni egy adott SERCOM-on. A "samd_sercom" előtaggal tetszőleges számú szekciót definiálhatunk. Minden SERCOM-ot konfigurálni kell, mielőtt SPI vagy I2C perifériaként használnánk. Helyezd ezt a konfigurációs szekciót minden más, SPI vagy I2C buszokat használó szekció fölé.

```
[samd_sercom my_sercom]
sercom:
#   A mikrovezérlőben konfigurálandó sercom busz neve.
#   A rendelkezésre álló nevek "sercom0", "sercom1" stb.
#   Ezt a paramétert meg kell adni.
tx_pin:
#   MOSI érintkező SPI kommunikációhoz, vagy SDA (adat) érintkező
#   I2C kommunikációhoz. A lábnak érvényes pinmux konfigurációval
#   kell rendelkeznie az adott SERCOM perifériához.
#   Ezt a paramétert meg kell adni.
#rx_pin:
#   MISO tű az SPI kommunikációhoz. Ezt a tűt nem használják I2C
#   kommunikációhoz (az I2C a tx_pin kódot használja mind a
#   küldéshez, mind a fogadáshoz). A lábnak érvényes pinmux
#   konfigurációval kell rendelkeznie az adott SERCOM perifériához.
#   Ez a paraméter nem kötelező.
clk_pin:
#   CLK érintkező az SPI kommunikációhoz, vagy SCL (óra) érintkező
#   az I2C kommunikációhoz. A lábnak érvényes pinmux
#   konfigurációval kell rendelkeznie az adott SERCOM perifériához.
#   Ezt a paramétert meg kell adni.
```

### [adc_scaled]

Duet2 Maestro analóg skálázás vref és vssa leolvasások alapján. Az adc_scaled szakasz definiálása virtuális adc-tűként (például "my_name:PB0") tesz lehetővé, amelyeket automatikusan a kártya vref és vssa figyelőtűi állítanak be. Ügyelj arra, hogy ezt a konfigurációs szakaszt minden olyan konfigurációs szakasz felett definiáld, amely ezeket a virtuális tűket használja.

Lásd a [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg) fájlt egy példáért.

```
[adc_scaled my_name]
vref_pin:
#   A VREF monitorozásához használt ADC tű. Ezt a paramétert meg kell adni.
vssa_pin:
#   A VSSA monitorozásához használandó ADC tű. Ezt a paramétert meg kell adni.
#smooth_time: 2.0
#   Egy időérték (másodpercben), amely alatt a vref és a vssa
#   mérések simításra kerülnek, hogy csökkentsék a mérés hatását
#   zaj csökkentése érdekében. Az alapértelmezett érték 2 másodperc.
```

### [replicape]

Replicape támogatás. Lásd a [beaglebone útmutatót](Beaglebone.md) és a [generic-replicape.cfg](../config/generic-replicape.cfg) fájlt egy példáért.

```
# A "replicape" konfigurációs rész hozzáadja a
# "replicape:stepper_x_enable" virtuális léptetőt engedélyező tűket
# (X, Y, Z, E és H léptetőkhöz) és a "replicape:power_x" PWM kimeneti
# tűket (hotbed, e, h, fan0, fan1 számára , fan2 és fan3), a
# konfigurációs fájlhoz amelyet ezután máshol is használhatunk.
[replicape]
revision:
#   A replikált hardververzió. Jelenleg csak a "B3" verzió támogatott.
#   Ezt a paramétert meg kell adni.
#enable_pin: !gpio0_20
#   A globális engedélyezési PIN replikája.
#   Az alapértelmezett !gpio0_20 (más néven P9_41).
host_mcu:
#   Az MCU konfigurációs szakasz neve, amely kommunikál a Klipper
#   "linux folyamat" MCU példányával. Ezt a paramétert meg kell adni.
#standstill_power_down: False
#   Ez a paraméter vezérli a CFG6_ENN vonalat az összes
#   léptetőmotoron. A True az engedélyezési sorokat "nyitásra" állítja.
#   Az alapértelmezett érték False.
#stepper_x_microstep_mode:
#stepper_y_microstep_mode:
#stepper_z_microstep_mode:
#stepper_e_microstep_mode:
#stepper_h_microstep_mode:
#   Ez a paraméter az adott léptetőmotor meghajtó CFG1 és CFG2
#   érintkezőit vezérli. A választható lehetőségek a következők:
#   disable, 1, 2, spread2, 4, 16, spread4, spread16, stealth4 és
#   stealth16. Az alapértelmezett érték a disable.
#stepper_x_current:
#stepper_y_current:
#stepper_z_current:
#stepper_e_current:
#stepper_h_current:
#   A léptetőmotor meghajtójának konfigurált maximális árama
#   (amperben). Ezt a paramétert akkor kell megadni, ha a léptető
#   nincs letiltási módban.
#stepper_x_chopper_off_time_high:
#stepper_y_chopper_off_time_high:
#stepper_z_chopper_off_time_high:
#stepper_e_chopper_off_time_high:
#stepper_h_chopper_off_time_high:
#   Ez a paraméter a léptetőmotor meghajtó CFG0 lábát vezérli
#   (a True a CFG0 értéket magasra, a False pedig alacsonyra állítja).
#   Az alapértelmezett érték False.
#stepper_x_chopper_hysteresis_high:
#stepper_y_chopper_hysteresis_high:
#stepper_z_chopper_hysteresis_high:
#stepper_e_chopper_hysteresis_high:
#stepper_h_chopper_hysteresis_high:
#   Ez a paraméter a léptetőmotor meghajtó CFG4 lábát vezérli
#   (a True a CFG4 értéket magasra, a False pedig alacsonyra állítja).
#   Az alapértelmezett érték False.
#stepper_x_chopper_blank_time_high:
#stepper_y_chopper_blank_time_high:
#stepper_z_chopper_blank_time_high:
#stepper_e_chopper_blank_time_high:
#stepper_h_chopper_blank_time_high:
#   Ez a paraméter a léptetőmotor meghajtó CFG5 lábát vezérli
#   (a True a CFG5 értéket magasra, a False pedig alacsonyra állítja).
#   Az alapértelmezett érték True.
```

## Egyéb egyedi modulok

### [palette2]

Palette 2 multimaterial támogatás szorosabb integrációt biztosít, amely támogatja a Palette 2 eszközöket csatlakoztatott módban.

Ez a modul a teljes funkcionalitáshoz a `[virtual_sdcard]` és `[pause_resume]` modulokat is igényli.

Ha ezt a modult használod, ne használd a Palette 2 plugint az Octoprinthez, mivel ezek ütközni fognak, és az egyik nem fog megfelelően inicializálódni, ami valószínűleg megszakítja a nyomtatást.

Ha az Octoprintet használod és a G-kódot a soros porton keresztül streameli a virtual_sd-ről való nyomtatás helyett, akkor a **M1** és **M0** parancsok *Pausing parancsok* a *Settings >. alatt remo; Serial Connection > Firmware & protocol* megakadályozzák, hogy a nyomtatás megkezdéséhez a Paletta 2-n el kelljen indítani a nyomtatást, és az Octoprintben fel kelljen oldani a szünetet.

```
[paletta2]
serial:
#   A soros port, amelyhez a Palette 2 csatlakozik.
#baud: 115200
#   A használandó baud-ráta. Az alapértelmezett érték 115200.
#feedrate_splice: 0.8
#   A toldáskor használandó feedrate, alapértelmezett 0.8.
#feedrate_normal: 1.0
#   A toldás után használandó feedrate, alapértelmezett értéke 1.0.
#auto_load_speed: 2
#   Extrudálási előtolási sebesség automatikus betöltéskor, alapértelmezett 2 (mm/sec)
#auto_cancel_variation: 0.1
#   Automatikusan törli a nyomtatást, ha a ping meghaladja ezt a küszöbértéket.
```

### [angle]

Mágneses Hall-szögérzékelő támogatása A1333, AS5047D vagy TLE5012B SPI-chipek használatával a léptetőmotorok szögtengelyének méréseinek leolvasásához. A mérések az [API Szerver](API_Server.md) és a [mozgáselemző eszköz](Debugging.md#motion-analysis-and-data-logging) segítségével érhetők el. A rendelkezésre álló parancsokat lásd a [G-kód hivatkozásban](G-Codes.md#angle).

```
[angle my_angle_sensor]
sensor_type:
#   A mágneses Hall érzékelő chip típusa. A választható lehetőségek:
#   „a1333”, „as5047d” és „tle5012b”. Ezt a paramétert meg kell adni.
#sample_period: 0.000400
#   A mérések során használandó lekérdezési időszak (másodpercben).
#   Az alapértelmezett érték 0,000400 (ami másodpercenként
#   2500 minta).
#stepper:
#   Annak a léptetőnek a neve, amelyhez a szögérzékelő csatlakoztatva
#   van (pl. "stepper_x"). Ennek az értéknek a beállítása engedélyezi a
#   szögkalibráló eszközt. A funkció használatához telepíteni kell a
#   Python "numpy" csomagot. Az alapértelmezett beállítás nem
#   engedélyezi a szögérzékelő szögkalibrálását.
cs_pin:
#   Az érzékelő SPI engedélyező tűje. Ezt a paramétert meg kell adni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   A fenti paraméterek leírását az „általános SPI-beállítások”
#   részben találja.
```

## Gyakori buszparaméterek

### Gyakori SPI beállítások

Az SPI-buszt használó eszközök esetében általában a következő paraméterek állnak rendelkezésre.

```
#spi_speed:
#   Az eszközzel való kommunikáció során használandó
#   SPI-sebesség (hz-ben).
#   Az alapértelmezett érték az eszköz típusától függ.
#spi_bus:
#   Ha a mikrovezérlő több SPI buszt támogat, akkor itt megadhatod a
#   mikrovezérlő busz nevét. Az alapértelmezett érték a mikrovezérlő
#   típusától függ.
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Add meg a fenti paramétereket a "szoftver alapú SPI" használatához.
#   Ez a mód nem igényel mikrovezérlő hardver támogatást (általában
#   bármilyen általános célú érintkező használható). Az alapértelmezés
#   szerint nem használja a "software SPI"-t.
```

### Gyakori I2C beállítások

A következő paraméterek általában az I2C-buszt használó eszközökhöz állnak rendelkezésre.

Vedd figyelembe, hogy a Klipper jelenlegi mikrokontrollerek i2c támogatása nem tolerálja a hálózati zajt. Az i2c vezetékek nem várt hibái a Klipper futásidejű hibaüzenetét eredményezhetik. A Klipper hibaelhárítás támogatása az egyes mikrokontroller-típusok között változik. Általában csak olyan i2c eszközök használata ajánlott, amelyek ugyanazon a nyomtatott áramköri lapon vannak, mint a mikrokontroller.

A legtöbb Klipper mikrokontroller implementáció csak 100000 `i2c_speed` értéket támogat. A Klipper "linux" mikrokontroller támogatja a 400000-es sebességet, de ezt [az operációs rendszerben kell beállítani](RPi_microcontroller.md#optional-enabling-i2c), és az `i2c_speed` paramétert egyébként figyelmen kívül hagyja. A Klipper "rp2040" mikrokontroller az `i2c_speed` paraméteren keresztül 400000-es sebességet támogat. Az összes többi Klipper mikrovezérlő 100000-es sebességet használ, és figyelmen kívül hagyja az `i2c_speed` paramétert.

```
#i2c_address:
#   Az eszköz i2c címe. Ezt decimális számként kell megadni
#   (nem hexadecimális formában).
#   Az alapértelmezett érték az eszköz típusától függ.
#i2c_mcu:
#   Annak a mikrovezérlőnek a neve, amelyhez a chip csatlakozik.
#   Az alapértelmezett az "mcu".
#i2c_bus:
#   Ha a mikrovezérlő több I2C buszt támogat, akkor itt megadhatod a
#   mikrovezérlő busz nevét.
#   Az alapértelmezett érték a mikrovezérlő típusától függ.
#i2c_speed:
#   Az eszközzel való kommunikáció során használandó I2C sebesség
#   (Hz-ben). A Klipper implementációja a legtöbb mikrovezérlőn kódolt
#   értéke 100000, és ennek az értéknek nincs hatása.
#   Az alapértelmezett érték 100 000.
```
