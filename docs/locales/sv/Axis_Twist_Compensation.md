# Kompensation för axelvridning

Detta dokument beskriver modulen `[axis_twist_compensation]`.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Modulen använder manuella mätningar från användaren för att korrigera sondens resultat. Observera att om axeln är kraftigt vriden rekommenderas det starkt att först åtgärda den mekaniskt innan programvarukorrigering används.

**Varning:** Modulen är ännu inte kompatibel med dockningsbara sonder och försöker sonda bädden utan att fästa sonden om den används.

## Översikt över användning av kompensering

> **Tips:** Kontrollera att [sondens X- och Y-förskjutningar](Config_Reference.md#probe) är korrekt inställda eftersom de påverkar kalibreringen mycket.

### Grundläggande användning: kalibrering av X-axeln

1. Kör följande efter att modulen `[axis_twist_compensation]` har ställts in:

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

Kommandot kalibrerar X-axeln som standard.

- Kalibreringsguiden ber dig mäta sondens Z-förskjutning vid flera punkter längs bädden.
- Kalibreringen använder som standard 3 punkter, men du kan ange ett annat antal med alternativet `SAMPLE_COUNT=<value>`.

1. **Justera Z-förskjutningen:** Justera [Z-förskjutningen](Probe_Calibrate.md#calibrating-probe-z-offset) när kalibreringen har slutförts.
1. **Utför bäddnivelleringsåtgärder:** Använd vid behov sondbaserade åtgärder, till exempel:

- [Justering av skruvars lutning](G-Codes.md#screws_tilt_adjust)
- [Justering av Z-lutning](G-Codes.md#z_tilt_adjust)

1. **Slutför inställningen:**

- Hemkör alla axlar och utför vid behov ett [bäddnät](Bed_Mesh.md).
- Kör en testutskrift och finjustera sedan vid behov enligt [finjusteringen](Axis_Twist_Compensation.md#fine-tuning).

### För kalibrering av Y-axeln

Kalibreringsprocessen för Y-axeln liknar den för X-axeln. Använd följande för att kalibrera Y-axeln:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

Detta leder dig genom samma mätprocess som för X-axeln.

> **Tips:** Bäddtemperaturen samt munstyckets temperatur och storlek tycks inte påverka kalibreringsprocessen.

## Inställning och kommandon för [axis_twist_compensation]

Konfigurationsalternativ för `[axis_twist_compensation]` finns i [konfigurationsreferensen](Config_Reference.md#axis_twist_compensation).

Kommandon för `[axis_twist_compensation]` finns i [referensen för G-koder](G-Codes.md#axis_twist_compensation).
