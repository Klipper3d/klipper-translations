# Fáze Endstop

Tento dokument popisuje systém Klipperu pro nastavení fáze krokového motoru koncovým spínačem. Tato funkce může zlepšit přesnost tradičních koncových spínačů. Je nejvíce užitečná při použití krokového motoru Trinamic s konfigurací za běhu.

Typický koncový spínač má přesnost kolem 100 mikronů. (Při každém homingu osy může spínač spustit trochu dříve nebo trochu později.) I když se jedná o relativně malou chybu, může způsobit nechtěné artefakty. Tato odchylka v pozici může být zejména pozorovatelná při tisku první vrstvy objektu. Naopak, typické krokové motory mohou dosahovat výrazně vyšší přesnosti.

Mechanismus nastavení fáze krokového motoru koncovým spínačem může využít přesnost krokových motorů k zlepšení přesnosti koncových spínačů. Krokový motor se pohybuje tím, že projde řadou fází, dokud nedokončí čtyři "plné kroky". Takže krokový motor používající 16 mikrokroků bude mít 64 fází a při pohybu v kladném směru projde fázemi: 0, 1, 2, ... 61, 62, 63, 0, 1, 2, atd. Zásadní je, že když je krokový motor v určité pozici na lineárním kolejnici, měl by být vždy v téže fázi krokového motoru. Takže, když vozík spustí koncový spínač, krokový motor ovládající tento vozík by měl být vždy ve stejné fázi krokového motoru. Klipperův systém koncové fáze kombinuje fázi krokového motoru s trigerem koncového spínače k zlepšení přesnosti koncového spínače.

Pro použití této funkce je nezbytné být schopen identifikovat fázi krokového motoru. Pokud používáte řidiče Trinamic TMC2130, TMC2208, TMC2224 nebo TMC2660 v režimu konfigurace za běhu (tj. ne ve stand-alone režimu), pak Klipper může získat informaci o fázi krokového motoru od řidiče. (Je také možné použít tento systém s tradičními krokovými řidiči, pokud lze spolehlivě resetovat krokové řidiče - viz níže pro podrobnosti.)

## Kalibrace fází koncového spínače

Pokud používáte krokové motory Trinamic s konfigurací za běhu, můžete kalibrovat fáze koncového spínače pomocí příkazu ENDSTOP_PHASE_CALIBRATE. Začněte tím, že do konfiguračního souboru přidáte následující:

```
[endstop_phase]
```

Poté RESTARTUJTE tiskárnu a spusťte příkaz `G28`, následovaný příkazem `ENDSTOP_PHASE_CALIBRATE`. Poté přesuňte nástrojovou hlavu na nové místo a znovu spusťte příkaz `G28`. Zkuste nástrojovou hlavu přemístit na několik různých míst a znovu spusťte `G28` z každé pozice. Spusťte alespoň pět příkazů `G28`.

Po provedení výše uvedených kroků příkaz `ENDSTOP_PHASE_CALIBRATE` často hlásí stejnou (nebo téměř stejnou) fázi pro krokový motor. Tuto fázi lze uložit do konfiguračního souboru, takže všechny budoucí příkazy `G28` budou používat tuto fázi. (Takže v budoucích homingových operacích Klipper získá stejnou pozici, i když koncový spínač spustí trochu dříve nebo trochu později.)

Chcete-li uložit fázi koncového spínače pro konkrétní krokový motor, spusťte něco podobného následujícímu:

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Run the above for all the steppers one wishes to save. Typically, one would use this on stepper_z for cartesian and corexy printers, and for stepper_a, stepper_b, and stepper_c on delta printers. Finally, run the following to update the configuration file with the data:

```
SAVE_CONFIG
```

### Additional notes

* This feature is most useful on delta printers and on the Z endstop of cartesian/corexy printers. It is possible to use this feature on the XY endstops of cartesian printers, but that isn't particularly useful as a minor error in X/Y endstop position is unlikely to impact print quality. It is not valid to use this feature on the XY endstops of corexy printers (as the XY position is not determined by a single stepper on corexy kinematics). It is not valid to use this feature on a printer using a "probe:z_virtual_endstop" Z endstop (as the stepper phase is only stable if the endstop is at a static location on a rail).
* After calibrating the endstop phase, if the endstop is later moved or adjusted then it will be necessary to recalibrate the endstop. Remove the calibration data from the config file and rerun the steps above.
* In order to use this system the endstop must be accurate enough to identify the stepper position within two "full steps". So, for example, if a stepper is using 16 micro-steps with a step distance of 0.005mm then the endstop must have an accuracy of at least 0.160mm. If one gets "Endstop stepper_z incorrect phase" type error messages than in may be due to an endstop that is not sufficiently accurate. If recalibration does not help then disable endstop phase adjustments by removing them from the config file.
* If one is using a traditional stepper controlled Z axis (as on a cartesian or corexy printer) along with traditional bed leveling screws then it is also possible to use this system to arrange for each print layer to be performed on a "full step" boundary. To enable this feature be sure the G-Code slicer is configured with a layer height that is a multiple of a "full step", manually enable the endstop_align_zero option in the endstop_phase config section (see [config reference](Config_Reference.md#endstop_phase) for further details), and then re-level the bed screws.
* It is possible to use this system with traditional (non-Trinamic) stepper motor drivers. However, doing this requires making sure that the stepper motor drivers are reset every time the micro-controller is reset. (If the two are always reset together then Klipper can determine the stepper phase by tracking the total number of steps it has commanded the stepper to move.) Currently, the only way to do this reliably is if both the micro-controller and stepper motor drivers are powered solely from USB and that USB power is provided from a host running on a Raspberry Pi. In this situation one can specify an mcu config with "restart_method: rpi_usb" - that option will arrange for the micro-controller to always be reset via a USB power reset, which would arrange for both the micro-controller and stepper motor drivers to be reset together. If using this mechanism, one would then need to manually configure the "trigger_phase" config sections (see [config reference](Config_Reference.md#endstop_phase) for the details).
