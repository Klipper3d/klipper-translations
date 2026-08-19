# Сензор за ширина на нишката на Хол

Този документ описва хост модула на сензора за ширина на нишката. Хардуерът, използван за разработването на този хост модул, се основава на два линейни сензора на Хол (например ss49e). Сензорите в тялото са разположени на противоположни страни. Принцип на работа: два сензора на Хол работят в диференциален режим, температурата се променя по един и същ начин за сензора. Не е необходима специална температурна компенсация.

Проектите можете да намерите в [Thingiverse](https://www.thingiverse.com/thing:4138933), а видеоклип за сглобяване е достъпен в [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4).

За да използвате сензора на Хол за широчина на влакното, прочетете [Config Reference](Config_Reference.md#hall_filament_width_sensor) и [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Как работи?

Сензорът генерира два аналогови изхода въз основа на изчислената ширина на нишката. Сумата на изходното напрежение винаги е равна на откритата ширина на нишката. Приемащият модул следи промените в напрежението и регулира множителя на екструдиране. Използвам конектора aux2 на платка, подобна на рампа, с изводите analog11 и analog12. Можете да използвате различни щифтове и различни платки.

## Шаблон за променливи в менюто

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## Процедура за калибриране

За да получите суровата стойност на сензора, можете да използвате елемент от менюто или командата **QUERY_RAW_FILAMENT_WIDTH** в терминала.

1. Поставете първата пръчка за калибриране (с размер 1,5 mm), за да получите първата необработена стойност на сензора
1. Поставете втора пръчка за калибриране (с размер 2,0 mm), за да получите втората необработена стойност на сензора
1. Записване на необработени стойности на сензорите в параметъра на конфигурацията `Raw_dia1` и `Raw_dia2`

## Как да активирате сензора

По подразбиране сензорът е деактивиран при включване на захранването.

За да активирате сензора, издайте командата **ENABLE_FILAMENT_WIDTH_SENSOR** или задайте параметъра `enable` на `true`.

## Use as a runout switch only

By default, the sensor measures filament diameter and adjusts the extrusion multiplier to compensate for variations.

If you want to use the sensor as a runout switch only, set the `enable_flow_compensation` config parameter to `false`. In this mode, the sensor will only trigger runout events when filament is not detected, it will not modify the extrusion multiplier.

This is useful for printers where the filament sensor is not accurate enough for flow compensation but can reliably detect filament runout, or when printing with flexible filaments which have unstable diameter characteristics.

Issue **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=1** to enable flow compensation or **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=0** to disable it.

Note that disabling filament width compensation automatically resets the extrusion multiplier to 100%.

**QUERY_FILAMENT_WIDTH** includes the current state of flow compensation in its output.

## Регистриране

По подразбиране регистрирането на диаметъра е деактивирано при включване на захранването.

Издайте командата **ENABLE_FILAMENT_WIDTH_LOG**, за да стартирате регистрирането, и издайте командата **DISABLE_FILAMENT_WIDTH_LOG**, за да спрете регистрирането. За да разрешите воденето на дневник при включване на захранването, задайте параметъра `logging` на `true`.

Диаметърът на нишката се записва на всеки интервал на измерване (10 mm по подразбиране).
