# Слайсеры

В этом документе содержится несколько советов по настройке приложения "slicer" для использования с Klipper. Распространенными слайсерами, используемыми с Klipper, являются Slic3r, Cura, Simplify3Dи др.

## Установите для G-кода значение Marlin

Во многих слайсерах есть возможность настроить "предпочтение G-кода". По умолчанию часто используется "Marlin", и это хорошо работает с Klipper. Настройка "Smoothieware" также хорошо работает с Klipper.

## Klipper gcode_macro

Часто слайсеры позволяют настраивать последовательности "Start G-Code" и "End G-Code". Часто вместо этого удобно определить пользовательские макросы в конфигурационном файле Klipper - например: `[gcode_macro START_PRINT]` и `[gcode_macro END_PRINT]`. Тогда можно просто выполнить START_PRINT и END_PRINT в конфигурации слайсера. Определение этих действий в конфигурации клиппера может облегчить настройку начального и конечного шагов принтера, поскольку изменения не требуют повторной нарезки.

Примеры макросов START_PRINT и END_PRINT см. в [sample-macros.cfg](../config/sample-macros.cfg).

Подробнее об определении gcode_macro см. в [config reference](Config_Reference.md#gcode_macro).

## При больших настройках втягивания может потребоваться настройка клиппера

Максимальная скорость и ускорение движений втягивания контролируются в Klipper настройками конфигурации `max_extrude_only_velocity` и `max_extrude_only_accel`. Эти параметры имеют значение по умолчанию, которое должно хорошо работать на многих принтерах. Однако если в слайсере настроено большое втягивание (например, 5 мм или более), то можно обнаружить, что они ограничивают желаемую скорость втягивания.

Если используется большое втягивание, рассмотрите возможность настройки [опережения давления](Pressure_Advance.md) Клиппера вместо этого. В противном случае, если вы обнаружите, что головка инструмента как бы "приостанавливается" во время втягивания и заливки, то подумайте о явном определении `max_extrude_only_velocity` и `max_extrude_only_accel` в конфигурационном файле Klipper.

## Не включайте "движение накатом"

Функция "накатом", скорее всего, приведет к плохому качеству отпечатков с Klipper. Вместо этого используйте [pressure advance](Pressure_Advance.md) от Klipper.

В частности, если слайсер резко меняет скорость выдавливания между движениями, Klipper будет выполнять замедление и ускорение между движениями. Это, скорее всего, приведет к ухудшению, а не к улучшению качества.

В отличие от этого, можно (и часто полезно) использовать настройки "втягивание", "протирка" и/или "протирка при втягивании" ломтерезки.

## Не используйте "дополнительное расстояние перезапуска" в Simplify3d

Эта настройка может привести к резким изменениям скорости экструзии, что может вызвать срабатывание проверки максимального сечения экструзии Klipper. Вместо этого используйте [pressure advance](Pressure_Advance.md) или обычную настройку Simplify3d retract.

## Отключите "PreloadVE" в KISSlicer

Если используется программа для нарезки KISSlicer, установите "PreloadVE" на ноль. Вместо этого используйте [pressure advance](Pressure_Advance.md) программы Klipper.

## Отключите все настройки "расширенного давления экструдера"

Некоторые слайсеры рекламируют возможность "расширенного давления экструдера". При использовании Klipper рекомендуется отключать эти опции, так как они, скорее всего, приведут к плохому качеству отпечатков. Вместо этого используйте опцию Klipper [pressure advance](Pressure_Advance.md).

В частности, эти настройки слайсера могут предписывать микропрограмме вносить дикие изменения в скорость экструзии в надежде, что микропрограмма приблизительно выполнит эти запросы и принтер примерно получит желаемое давление в экструдере. Klipper, однако, использует точные кинематические расчеты и синхронизацию. Когда Klipper получает команду внести значительные изменения в скорость экструзии, он планирует соответствующие изменения скорости, ускорения и движения экструдера, что не входит в намерения слайсера. Слайсер может даже задать чрезмерную скорость экструзии до такой степени, что сработает проверка Klipper на максимальное сечение экструзии.

В отличие от этого, можно (и часто полезно) использовать настройки "втягивание", "протирка" и/или "протирка при втягивании" ломтерезки.

## START_PRINT macros

When using a START_PRINT macro or similar, it is useful to sometimes pass through parameters from the slicer variables to the macro.

In Cura, to pass through temperatures, the following start gcode would be used:

```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

In slic3r derivatives such as PrusaSlicer and SuperSlicer, the following would be used:

```
START_PRINT EXTRUDER_TEMP=[first_layer_temperature] BED_TEMP=[first_layer_bed_temperature]
```

Also note that these slicers will insert their own heating codes when certain conditions are not met. In Cura, the existence of the `{material_bed_temperature_layer_0}` and `{material_print_temperature_layer_0}` variables is enough to mitigate this. In slic3r derivatives, you would use:

```
M140 S0
M104 S0
```

before the macro call. Also note that SuperSlicer has a "custom gcode only" button option, which achieves the same outcome.

An example of a START_PRINT macro using these paramaters can be found in config/sample-macros.cfg
