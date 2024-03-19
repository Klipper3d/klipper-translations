# Tengely fordulat kompenzáció

Ez a dokumentum leírja az [axis_twist_compensation] modult.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Ez a modul kézi méréseket használ a felhasználó számára, hogy korrigálja a szonda eredményeit. Vedd figyelembe, hogy ha a tengely jelentősen csavart, akkor határozottan ajánlott először mechanikai eszközöket használni a szoftveres korrekciók alkalmazása előtt.

**Figyelem**: Ez a modul még nem kompatibilis a dokkolható szondákkal, és a szonda csatlakoztatása nélkül próbáld meg megmérni az ágyat, mielőtt használod.

## A kompenzációs használat áttekintése

> **Tip:** Győződj meg róla, hogy az [ X és Y eltolás](Config_Reference.md#probe) megfelelően van beállítva, mivel nagymértékben befolyásolják a kalibrálást.

1. Az [axis_twist_compensation] modul beállítása után hajtsd végre az alábbi parancsot `AXIS_TWIST_COMPENSATION_CALIBRATE`

* A kalibrációs varázsló felszólít Téged, hogy mérd meg a szonda Z eltolását az ágy mentén néhány ponton
* A kalibrálás alapértelmezett értéke 3 pont, de a `SAMPLE_COUNT=` opcióval más számot is használhatsz.

1. [Z eltolás beállítása](Probe_Calibrate.md#calibrating-probe-z-offset)
1. Automatikus/szondás szintezési műveletek végrehajtása, például [Orsók dőlésbeállítása](G-Codes.md#screws_tilt_adjust), [Z dőlésbeállítása](G-Codes.md#z_tilt_adjust) stb
1. Kezdőpont minden tengelyen, majd szükség esetén végezzünk egy [ Ágyháló](Bed_Mesh.md) műveletet
1. Végezz el egy próbanyomtatást, majd a kívánt [finomhangolást](Axis_Twist_Compensation.md#fine-tuning)

> **Tipp:** Úgy tűnik, hogy az ágy hőmérséklete és a fúvóka hőmérséklete és mértéke nem befolyásolja a kalibrálási folyamatot.

## [axis_twist_compensation] beállítások és parancsok

Az [axis_twist_compensation] konfigurációs beállításai a [Konfigurációs referenciában](Config_Reference.md#axis_twist_compensation) találhatóak.

Az [axis_twist_compensation] parancsok megtalálhatók a [G-Kódok referencia](G-Codes.md#axis_twist_compensation) című dokumentumban
