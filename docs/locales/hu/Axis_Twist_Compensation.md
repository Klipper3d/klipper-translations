# Tengely fordulat kompenzáció

Ez a dokumentum leírja az [axis_twist_compensation] modult.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Ez a modul kézi méréseket használ a felhasználó számára, hogy korrigálja a szonda eredményeit. Vedd figyelembe, hogy ha a tengely jelentősen csavart, akkor határozottan ajánlott először mechanikai eszközöket használni a szoftveres korrekciók alkalmazása előtt.

**Figyelem**: Ez a modul még nem kompatibilis a dokkolható szondákkal, és a szonda csatlakoztatása nélkül próbáld meg megmérni az ágyat, mielőtt használod.

## A kompenzációs használat áttekintése

> **Tip:** Győződj meg róla, hogy az [ X és Y eltolás](Config_Reference.md#probe) megfelelően van beállítva, mivel nagymértékben befolyásolják a kalibrálást.

### Alapvető használat: X-Tengely kalibrálás

1. Az `[axis_twist_compensation]` modul beállítása után futtasd a következőt:

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

Ez a parancs alapértelmezés szerint az X-tengelyt kalibrálja. - A kalibrációs varázsló felszólít, hogy mérd meg a szonda Z eltolását az ágy mentén több ponton. - Alapértelmezés szerint a kalibrálás 3 pontot használ, de a `SAMPLE_COUNT=<value>` opcióval más számot is megadhatsz.

1. **Z-eltolás beállítása:** A kalibrálás befejezése után mindenképpen [állítsd be a Z-eltolást] (Probe_Calibrate.md#calibrating-probe-z-offset).
1. **Perform Bed Leveling Operations:** Használj szonda alapú műveleteket, például:

   - [Csavarok dőlésszög beállítása](G-Codes.md#screws_tilt_adjust)
   - [Z dőlésszög beállítása](G-Codes.md#z_tilt_adjust)

1. **A beállítás befejezése:**

   - Küldj kezdő pozícióba minden tengelyt, és hajtsd végre az [Ágy háló](Bed_Mesh.md) parancsot, ha szükséges.
   - Futtass egy próbanyomtatást, majd szükség esetén [finomhangolást](Axis_Twist_Compensation.md#fine-tuning).

### Y-Tengely kalibrálása

Az Y-tengely kalibrálási folyamata hasonló az X-tengelyéhez. Az Y-tengely kalibrálásához használd a következőt:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

Ez végigvezet Téged ugyanazon a mérési folyamaton, mint az X-tengely esetében.

### Automatikus kalibrálás mindkét tengelyhez

Az X és Y tengely automatikus kalibrálásához kézi beavatkozás nélkül használd a következőt:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AUTO=True
```

Ebben az üzemmódban a kalibrációs folyamat mindkét tengelyre automatikusan lefut.

> **Tipp:** Úgy tűnik, hogy az ágy hőmérséklete és a fúvóka hőmérséklete és mértéke nem befolyásolja a kalibrálási folyamatot.

## [axis_twist_compensation] beállítások és parancsok

Az [axis_twist_compensation] konfigurációs beállításai a [Konfigurációs referenciában](Config_Reference.md#axis_twist_compensation) találhatóak.

Az [axis_twist_compensation] parancsok megtalálhatók a [G-Kódok referencia](G-Codes.md#axis_twist_compensation) című dokumentumban
