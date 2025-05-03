# Tengely fordulat kompenzáció

This document describes the `[axis_twist_compensation]` module.

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

This command will calibrate the X-axis by default.

- The calibration wizard will prompt you to measure the probe Z offset at several points along the bed.
- By default, the calibration uses 3 points, but you can specify a different number with the option: `SAMPLE_COUNT=<value>`

1. **Adjust Your Z Offset:** After completing the calibration, be sure to [adjust your Z offset](Probe_Calibrate.md#calibrating-probe-z-offset).
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

> **Tipp:** Úgy tűnik, hogy az ágy hőmérséklete és a fúvóka hőmérséklete és mértéke nem befolyásolja a kalibrálási folyamatot.

## [axis_twist_compensation] beállítások és parancsok

Configuration options for `[axis_twist_compensation]` can be found in the [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Commands for `[axis_twist_compensation]` can be found in the [G-Codes Reference](G-Codes.md#axis_twist_compensation)
