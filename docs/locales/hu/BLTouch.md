# BL-Touch

## BL-Touch csatlakoztatása

Egy **figyelmeztetés** mielőtt elkezdené: Kerülje a BL-Touch tűjének puszta ujjal való érintését, mivel meglehetősen érzékeny az zsírra. Ha pedig mégis hozzáér, legyen nagyon óvatos, hogy ne hajlítsa vagy nyomja meg a tüskét.

Csatlakoztassa a BL-Touch "servo" csatlakozót a `control_pin` csatlakozóhoz a BL-Touch dokumentáció vagy az MCU dokumentációja szerint. Az eredeti kábelezést használva a hármasból a sárga vezeték a `control_pin` és a vezetékpárból a fehér lesz a `sensor_pin`. Ezeket a pineket a kábelezésnek megfelelően kell konfigurálnia. A legtöbb BL-Touch pullup jelet igényel a pinbeállításnál (ezért a csatlakozás nevének előtagja "^"). Például:

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

If the BL-Touch will be used to home the Z axis then set `endstop_pin: probe:z_virtual_endstop` and remove `position_endstop` in the `[stepper_z]` config section, then add a `[safe_z_home]` config section to raise the z axis, home the xy axes, move to the center of the bed, and home the z axis. For example:

```
[safe_z_home]
home_xy_position: 100, 100 # Change coordinates to the center of your print bed
speed: 50
z_hop: 10                 # Move up 10mm
z_hop_speed: 5
```

Fontos, hogy a z_hop mozgás a safe_z_home-ban elég nagy legyen ahhoz, hogy a mérőcsúcs ne ütközzön semmibe, még akkor sem, ha a BL-Touch mérőtüskéje a legalacsonyabb állásban van.

## Kezdeti tesztek

Mielőtt továbblépne, ellenőrizze, hogy a BL-Touch a megfelelő magasságban van-e felszerelve. A mérőtüskének behúzott állapotban nagyjából 2 mm-rel a fúvóka fölött kell lennie

Amikor bekapcsolja a nyomtatót, a BL-Touch szondának önellenőrzést kell végeznie, és néhányszor fel-le kell mozgatnia a mérőtüskét. Az önellenőrzés befejezése után a mérőtüskének vissza kell húzódnia, és a szondán lévő piros LED-nek világítania kell. Ha bármilyen hibát észlel, például a szonda pirosan villog, vagy a mérőtüske lefelé van, nem pedig behúzva, kérjük kapcsolja ki a nyomtatót, és ellenőrizze a kábelezést és a konfigurációt.

Ha a fentiek rendben vannak, itt az ideje tesztelni, hogy a vezérlés megfelelően működik-e. Először futtassuk le a `BLTOUCH_DEBUG COMMAND=pin_down` parancsot a konzolban. Ellenőrizze, hogy a mérőtüske lefelé mozog-e, és hogy a BL-Touchon lévő piros LED kialszik-e. Ha nem, ellenőrizze újra a kábelezést és a konfigurációt. Ezután adjon ki egy `BLTOUCH_DEBUG COMMAND=pin_up` parancsot. Ellenőrizze, hogy a mérőtüske felfelé mozdul-e, és hogy a piros LED ismét világít-e. Ha villog, akkor valamilyen probléma van.

The next step is to confirm that the sensor pin is working correctly. Run `BLTOUCH_DEBUG COMMAND=pin_down`, verify that the pin moves down, run `BLTOUCH_DEBUG COMMAND=touch_mode`, run `QUERY_PROBE`, and verify that command reports "probe: open". Then while gently pushing the pin up slightly with the nail of your finger run `QUERY_PROBE` again. Verify the command reports "probe: TRIGGERED". If either query does not report the correct message then it usually indicates an incorrect wiring or configuration (though some [clones](#bl-touch-clones) may require special handling). At the completion of this test run `BLTOUCH_DEBUG COMMAND=pin_up` and verify that the pin moves up.

A BL-Touch vezérlő és érzékelőtüskék tesztelésének befejezése után itt az ideje a szintezés tesztelésének, de egy kis csavarral. Ahelyett, hogy a mérőtüske az ágyat érintené, a körmünkel fogjuk megérinteni. Helyezze a nyomtatófejet messze az ágytól, adjon ki egy `G28` (vagy `PROBE`, ha nem használja a probe:z_virtual_endstopot) parancsot, várjon míg a nyomtatófej elkezd lefelé mozogni, és állítsa meg a mozgást úgy, hogy nagyon óvatosan megérinti a mérőtüskét a körmével. Lehet, hogy ezt kétszer kell megtennie, mivel az alapértelmezett kezdőpont konfiguráció kétszer mér. Készüljön fel arra is, hogy kikapcsolja a nyomtatót, ha az nem áll meg, amikor megérinti a mérőtüskét.

Ha ez sikerült, kezdje újra `G28` (vagy `PROBE`) parancsal, de ezúttal hagyja, hogy a mérőtüske megérintse az ágyat.

## A BL-Touch elromlott

Amint a BL-Touch inkonzisztens állapotba kerül, pirosan villogni kezd. Az állapotból való kilépést a következő parancs kiadásával lehet kényszeríteni:

BLTOUCH_DEBUG COMMAND=reset

Ez akkor fordulhat elő, ha a kalibrálás megszakad, mert a mérőtüske nem jön ki a helyéről.

Előfordulhat azonban az is, hogy a BL-Touch már nem tudja magát kalibrálni. Ez akkor fordulhat elő, ha a tetején lévő csavar rossz helyzetben van, vagy ha a mérőtüskében lévő mágneses mag elmozdult. Ha úgy mozdult felfelé, hogy a csavarhoz tapad, előfordulhat, hogy már nem tudja leengedni a tüskét. Ilyen esetben ki kell venni a csavart, és a mérőtüskét óvatosan visszatolni a helyére. Helyezze vissza a tüskét a BL-Touch-ba úgy, hogy az a kihúzott helyzetbe essen. Óvatosan tegye vissza a hernyócsavart a helyére. Meg kell találnia a megfelelő pozíciót, hogy képes legyen leengedni és felemelni a tüskét, hogy a piros LED be és kikapcsoljon. Ehhez használja a `reset`, `pin_up` és `pin_down` parancsokat.

## BL-Touch "klónok"

Many BL-Touch "clone" devices work correctly with Klipper using the default configuration. However, some "clone" devices may not support the `QUERY_PROBE` command and some "clone" devices may require configuration of `pin_up_reports_not_triggered` or `pin_up_touch_mode_reports_triggered`.

Fontos! Ne állítsa a `pin_up_reports_not_triggered` vagy a `pin_up_touch_mode_reports_triggered` értékét False értékre anélkül, hogy előbb ne követné ezeket az utasításokat. Ne állítsa egyiket sem False értékre egy valódi BL-Touch esetében. Ezek helytelen beállítása hamis értékre növelheti a mérési időt, és növelheti a nyomtató károsodásának kockázatát.

Some "clone" devices do not support `touch_mode` and as a result the `QUERY_PROBE` command does not work. Despite this, it may still be possible to perform probing and homing with these devices. On these devices the `QUERY_PROBE` command during the [initial tests](#initial-tests) will not succeed, however the subsequent `G28` (or `PROBE`) test does succeed. It may be possible to use these "clone" devices with Klipper if one does not utilize the `QUERY_PROBE` command and one does not enable the `probe_with_touch_mode` feature.

Néhány "klón" eszköz nem képes elvégezni a Klipper belső érzékelő ellenőrző tesztjét. Ezeken az eszközökön a kezdőpont vagy a szonda próbálkozásai a Klipper "BLTouch failed to verify sensor state" hibát jelentenek. Ha ez bekövetkezik, akkor kézzel futtassa le a [kezdeti tesztek szakaszban](#initial-tests) leírt lépéseket az érzékelőtüske működésének megerősítésére. Ha a `QUERY_PROBE` parancsok ebben a tesztben mindig a várt eredményt adják, és a "BLTouch failed to verify sensor state" hiba továbbra is előfordul, akkor szükséges lehet a Klipper konfigurációs fájlban a `pin_up_touch_mode_reports_triggered` értékét False-ra állítani.

Néhány régi "klón" készülék nem képes jelenteni, ha sikeresen felemelte a szondát. Ezeken az eszközökön a Klipper minden egyes kezdőpont vagy mérési kísérlet után egy "BLTouch failed to raise probe" hibát jelent. Ezeket az eszközöket tesztelhetjük. Távolítsuk el a fejet az ágytól, futtassuk a `BLTOUCH_DEBUG COMMAND=pin_down` parancsot, ellenőrizzük, hogy a mérőtüske lefelé mozdult-e, futtassuk a `QUERY_PROBE` parancsot, ellenőrizzük, hogy a "probe: OPEN" értéket kapjuk, futtassuk a `BLTOUCH_DEBUG COMMAND=pin_up`, ellenőrizzük, hogy a mérőtüske felfelé mozdult-e, és futtassuk a `QUERY_PROBE`. Ha a mérőtüske továbbra is fent marad, az eszköz nem lép hibaállapotba, és az első lekérdezés a "probe: OPEN", míg a második lekérdezés a "probe: TRIGGERED", akkor ez azt jelzi, hogy a Klipper konfigurációs fájlban a `pin_up_reports_not_triggered` értékét False-ra kell állítani.

## BL-Touch v3

Egyes BL-Touch v3.0 és BL-Touch 3.1 eszközök esetében előfordulhat, hogy a nyomtató konfigurációs fájljában a `probe_with_touch_mode` beállítása szükséges.

If the BL-Touch v3.0 has its signal wire connected to an endstop pin (with a noise filtering capacitor), then the BL-Touch v3.0 may not be able to consistently send a signal during homing and probing. If the `QUERY_PROBE` commands in the [initial tests section](#initial-tests) always produce the expected results, but the toolhead does not always stop during G28/PROBE commands, then it is indicative of this issue. A workaround is to set `probe_with_touch_mode: True` in the config file.

The BL-Touch v3.1 may incorrectly enter an error state after a successful probe attempt. The symptoms are an occasional flashing light on the BL-Touch v3.1 that lasts for a couple of seconds after it successfully contacts the bed. Klipper should clear this error automatically and it is generally harmless. However, one may set `probe_with_touch_mode` in the config file to avoid this issue.

Important! Some "clone" devices and the BL-Touch v2.0 (and earlier) may have reduced accuracy when `probe_with_touch_mode` is set to True. Setting this to True also increases the time it takes to deploy the probe. If configuring this value on a "clone" or older BL-Touch device, be sure to test the probe accuracy before and after setting this value (use the `PROBE_ACCURACY` command to test).

## Multi-probing without stowing

By default, Klipper will deploy the probe at the start of each probe attempt and then stow the probe afterwards. This repetitive deploying and stowing of the probe may increase the total time of calibration sequences that involve many probe measurements. Klipper supports leaving the probe deployed between consecutive probes, which can reduce the total time of probing. This mode is enabled by configuring `stow_on_each_sample` to False in the config file.

Important! Setting `stow_on_each_sample` to False can lead to Klipper making horizontal toolhead movements while the probe is deployed. Be sure to verify all probing operations have sufficient Z clearance prior to setting this value to False. If there is insufficient clearance then a horizontal move may cause the pin to catch on an obstruction and result in damage to the printer.

Important! It is recommended to use `probe_with_touch_mode` configured to True when using `stow_on_each_sample` configured to False. Some "clone" devices may not detect a subsequent bed contact if `probe_with_touch_mode` is not set. On all devices, using the combination of these two settings simplifies the device signaling, which can improve overall stability.

Note, however, that some "clone" devices and the BL-Touch v2.0 (and earlier) may have reduced accuracy when `probe_with_touch_mode` is set to True. On these devices it is a good idea to test the probe accuracy before and after setting `probe_with_touch_mode` (use the `PROBE_ACCURACY` command to test).

## Calibrating the BL-Touch offsets

Follow the directions in the [Probe Calibrate](Probe_Calibrate.md) guide to set the x_offset, y_offset, and z_offset config parameters.

It's a good idea to verify that the Z offset is close to 1mm. If not, then you probably want to move the probe up or down to fix this. You want it to trigger well before the nozzle hits the bed, so that possible stuck filament or a warped bed doesn't affect any probing action. But at the same time, you want the retracted position to be as far above the nozzle as possible to avoid it touching printed parts. If an adjustment is made to the probe position, then rerun the probe calibration steps.

## BL-Touch output mode


   * A BL-Touch V3.0 supports setting a 5V or OPEN-DRAIN output mode, a BL-Touch V3.1 supports this too, but can also store this in its internal EEPROM. If your controller board needs the fixed 5V high logic level of the 5V mode you may set the 'set_output_mode' parameter in the [bltouch] section of the printer config file to "5V".*** Only use the 5V mode if your controller boards input line is 5V tolerant. This is why the default configuration of these BL-Touch versions is OPEN-DRAIN mode. You could potentially damage your controller boards CPU ***

   So therefore: If a controller board NEEDs 5V mode AND it is 5V tolerant on its input signal line AND if

   - you have a BL-Touch Smart V3.0, you need the use 'set_output_mode: 5V' parameter to ensure this setting at each startup, since the probe cannot remember the needed setting.
   - you have a BL-Touch Smart V3.1, you have the choice of using 'set_output_mode: 5V' or storing the mode once by use of a 'BLTOUCH_STORE MODE=5V' command manually and NOT using the parameter 'set_output_mode:'.
   - you have some other probe: Some probes have a trace on the circuit board to cut or a jumper to set in order to (permanently) set the output mode. In that case, omit the 'set_output_mode' parameter completely.
If you have a V3.1, do not automate or repeat storing the output mode to avoid wearing out the EEPROM of the probe.The BLTouch EEPROM is good for about 100.000 updates. 100 stores per day would add up to about 3 years of operation prior to wearing it out. Thus, storing the output mode in a V3.1 is designed by the vendor to be a complicated operation (the factory default being a safe OPEN DRAIN mode) and is not suited to be repeatedly issued by any slicer, macro or anything else, it is preferably only to be used when first integrating the probe into a printers electronics.
