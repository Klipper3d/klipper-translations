# Compensation de torsion de l'axe

Ce document décrit le module [axis_twist_compensation].

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

This module uses manual measurements by the user to correct the probe's results. Note that if your axis is significantly twisted it is strongly recommended to first use mechanical means to fix it prior to applying software corrections.

**Warning**: This module is not compatible with dockable probes yet and will try to probe the bed without attaching the probe if you use it.

## Overview of compensation usage

> **Tip:** Make sure the [probe X and Y offsets](Config_Reference.md#probe) are correctly set as they greatly influence calibration.

1. Après avoir configuré le module [axis_twist_compensation], effectuez `AXIS_TWIST_COMPENSATION_CALIBRATE`

* L'assistant de calibration vous invitera à calibrer la sonde de l'axe Z à quelques emplacements sur le plateau
* L'étalonnage est par défaut de 3 points mais vous pouvez utiliser l'option `SAMPLE_COUNT=` pour utiliser un nombre différent.

1. [Ajustez votre décalage de l'axe Z](Probe_Calibrate.md#calibrating-probe-z-offset)
1. Perform automatic/probe-based bed tramming operations, such as [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc
1. Home all axis, then perform a [Bed Mesh](Bed_Mesh.md) if required
1. Effectuez un test d'impression, suivi d'un [réglage de précision](Axis_Twist_Compensation.md#fine-tuning) comme vous le souhaitez

> **Conseil :** La température du plateau ainsi que la température et la taille de la buse ne semblent pas avoir d'influence sur le processus de calibration.

## [axis_twist_compensation] setup and commands

Configuration options for [axis_twist_compensation] can be found in the [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Commands for [axis_twist_compensation] can be found in the [G-Codes Reference](G-Codes.md#axis_twist_compensation)
