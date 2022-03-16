# Végállás szakasz

Ez a dokumentum a Klipper léptetőfázis-beállított végütköző rendszerét írja le. Ez a funkció javíthatja a hagyományos végálláskapcsolók pontosságát. Ez a leghasznosabb olyan Trinamic léptetőmotor-illesztőprogram használatakor, amely futásidejű konfigurációval rendelkezik.

Egy tipikus végálláskapcsoló pontossága körülbelül 100 mikron. (A tengely minden egyes indításakor a kapcsoló valamivel korábban vagy valamivel később léphet működésbe). Bár ez viszonylag kis hiba, nem kívánt nyomtatványokat eredményezhet. Különösen a tárgy első rétegének nyomtatásakor lehet észrevehető ez a pozícióeltérés. Ezzel szemben a tipikus léptetőmotorokkal lényegesen nagyobb pontosság érhető el.

A lépcsős fázisú végállás mechanizmus a lépcsős motorok pontosságát használhatja a végálláskapcsolók pontosságának javítására. A léptetőmotor egy sor fázison keresztül ciklikusan mozog, amíg négy "teljes lépést" nem teljesít. Tehát egy 16 mikrolépést használó léptetőmotornak 64 fázisa lenne, és pozitív irányba történő mozgáskor a fázisok között ciklikusan haladna: 0, 1, 2, ... 61, 62, 63, 0, 1, 2, stb. Lényeges, hogy amikor a léptetőmotor egy adott pozícióban van a lineáris sínen, mindig ugyanabban a léptetőfázisban kell lennie. Így amikor egy kocsi a végálláskapcsolót aktiválja, az adott kocsit vezérlő léptetőnek mindig ugyanabban a léptetőmotor fázisban kell lennie. A Klipper'végállás fázis rendszere a végállás pontosságának javítása érdekében kombinálja a léptető fázist a végállás kioldójával.

Ahhoz, hogy ezt a funkciót használni lehessen, azonosítani kell a léptetőmotor fázisát. Ha a Trinamic TMC2130, TMC2208, TMC2224 vagy TMC2660 meghajtókat futásidejű konfigurációs módban használja (azaz nem önálló módban), akkor a Klipper le tudja kérdezni a léptetőmotor fázisát a meghajtóból. (Ez a rendszer hagyományos léptető meghajtókon is használható, ha megbízhatóan vissza lehet állítani a léptető meghajtókat - a részleteket lásd alább.)

## Végállási fázisok kalibrálása

Ha Trinamic léptetőmotor-meghajtókat használunk futásidejű konfigurációval, akkor az ENDSTOP_PHASE_CALIBRATE paranccsal kalibrálhatjuk a végállási fázisokat. Kezdje a következők hozzáadásával a konfigurációs fájlhoz:

```
[endstop_phase]
```

Ezután indítsa újra a nyomtatót, és futtasson egy `G28` parancsot, amelyet egy `ENDSTOP_PHASE_CALIBRATE` parancs követ. Ezután mozgassa a szerszámfejet egy új helyre, és futtassa újra a `G28` parancsot. Próbálja meg a szerszámfejet több különböző helyre mozgatni, és minden egyes pozícióból futtassa újra a `G28` parancsot. Futtasson legalább öt `G28` parancsot.

A fentiek elvégzése után a `ENDSTOP_PHASE_CALIBRATE` parancs gyakran ugyanazt (vagy közel ugyanazt) a fázist fogja jelenteni a léptető számára. Ezt a fázist el lehet menteni a konfigurációs fájlban, hogy a jövőben minden G28 parancs ezt a fázist használja. (Így a jövőbeni kezdőpont kérési műveletek során a Klipper ugyanazt a pozíciót fogja elérni, még akkor is, ha a végállás egy kicsit korábban vagy egy kicsit később lép működésbe.)

Egy adott léptetőmotor végállási fázisának elmentéséhez futtasson valami hasonlót, mint a következő:

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Futtassa a fenti lépéseket az összes menteni kívánt léptetőre. Általában ezt a stepper_z-nél használjuk cartesian és corexy-nyomtatókhoz, illetve stepper_a, stepper_b és stepper_c-hez delta nyomtatókhoz. Végül futtassa a következőt a konfigurációs fájl frissítéséhez az adatokkal:

```
SAVE_CONFIG
```

### További megjegyzések

* This feature is most useful on delta printers and on the Z endstop of cartesian/corexy printers. It is possible to use this feature on the XY endstops of cartesian printers, but that isn't particularly useful as a minor error in X/Y endstop position is unlikely to impact print quality. It is not valid to use this feature on the XY endstops of corexy printers (as the XY position is not determined by a single stepper on corexy kinematics). It is not valid to use this feature on a printer using a "probe:z_virtual_endstop" Z endstop (as the stepper phase is only stable if the endstop is at a static location on a rail).
* After calibrating the endstop phase, if the endstop is later moved or adjusted then it will be necessary to recalibrate the endstop. Remove the calibration data from the config file and rerun the steps above.
* In order to use this system the endstop must be accurate enough to identify the stepper position within two "full steps". So, for example, if a stepper is using 16 micro-steps with a step distance of 0.005mm then the endstop must have an accuracy of at least 0.160mm. If one gets "Endstop stepper_z incorrect phase" type error messages than in may be due to an endstop that is not sufficiently accurate. If recalibration does not help then disable endstop phase adjustments by removing them from the config file.
* If one is using a traditional stepper controlled Z axis (as on a cartesian or corexy printer) along with traditional bed leveling screws then it is also possible to use this system to arrange for each print layer to be performed on a "full step" boundary. To enable this feature be sure the G-Code slicer is configured with a layer height that is a multiple of a "full step", manually enable the endstop_align_zero option in the endstop_phase config section (see [config reference](Config_Reference.md#endstop_phase) for further details), and then re-level the bed screws.
* It is possible to use this system with traditional (non-Trinamic) stepper motor drivers. However, doing this requires making sure that the stepper motor drivers are reset every time the micro-controller is reset. (If the two are always reset together then Klipper can determine the stepper phase by tracking the total number of steps it has commanded the stepper to move.) Currently, the only way to do this reliably is if both the micro-controller and stepper motor drivers are powered solely from USB and that USB power is provided from a host running on a Raspberry Pi. In this situation one can specify an mcu config with "restart_method: rpi_usb" - that option will arrange for the micro-controller to always be reset via a USB power reset, which would arrange for both the micro-controller and stepper motor drivers to be reset together. If using this mechanism, one would then need to manually configure the "trigger_phase" config sections (see [config reference](Config_Reference.md#endstop_phase) for the details).
