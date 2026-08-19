# Датчик ширины филамента

В данном документе описывается хост-модуль Filament Width Sensor. Аппаратная часть, используемая для разработки данного хост-модуля, основана на двух линейных датчиках Холла (например, ss49e). Датчики в корпусе расположены на противоположных сторонах. Принцип работы: два датчика Холла работают в дифференциальном режиме, температурный дрейф датчиков одинаков. Специальная температурная компенсация не требуется.

Вы можете найти примеры на [Thingiverse](https://www.thingiverse.com/thing:4138933), также доступно видео на [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)

Для использования датчика ширины нити Холла необходимо ознакомиться с [Config Reference](Config_Reference.md#hall_filament_width_sensor) и [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Как это работает?

Датчик формирует два аналоговых выхода в зависимости от рассчитанной ширины нити накала. Сумма выходных напряжений всегда равна обнаруженной ширине нити. Хост-модуль отслеживает изменения напряжения и регулирует множитель экструзии. Я использую разъем aux2 на плате типа ramps с выводами analog11 и analog12. Можно использовать другие контакты и другие платы.

## Шаблон переменных меню

```
[menu __main __filament __width_current] /Меню главной толщины филамента
type: command /тип:команда
enable: {'hall_filament_width_sensor' in printer} /включить:
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}/Имя:
index: 0 /индекс:

[menu __main __filament __raw_width_current] /Меню главной толщины сырого филамента
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## Процедура калибровки

Для получения необработанного значения датчика можно воспользоваться пунктом меню или командой **QUERY_RAW_FILAMENT_WIDTH** в терминале.

1. Вставьте первый калибровочный стержень (размер 1,5 мм) и получите первое необработанное значение датчика
1. Вставьте второй калибровочный стержень (размер 2,0 мм) и получите второе необработанное значение датчика
1. Сохранять необработанные значения датчиков в параметре конфигурации `Raw_dia1` и `Raw_dia2`

## Как включить датчик

По умолчанию датчик выключен при включении.

Чтобы включить датчик, выполните команду **ENABLE_FILAMENT_WIDTH_SENSOR** или установите параметр `enable` в значение `true`.

## Use as a runout switch only

By default, the sensor measures filament diameter and adjusts the extrusion multiplier to compensate for variations.

If you want to use the sensor as a runout switch only, set the `enable_flow_compensation` config parameter to `false`. In this mode, the sensor will only trigger runout events when filament is not detected, it will not modify the extrusion multiplier.

This is useful for printers where the filament sensor is not accurate enough for flow compensation but can reliably detect filament runout, or when printing with flexible filaments which have unstable diameter characteristics.

Issue **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=1** to enable flow compensation or **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=0** to disable it.

Note that disabling filament width compensation automatically resets the extrusion multiplier to 100%.

**QUERY_FILAMENT_WIDTH** includes the current state of flow compensation in its output.

## Журнал

По умолчанию регистрация диаметра отключена при включении питания.

Для запуска протоколирования выполните команду **ENABLE_FILAMENT_WIDTH_LOG**, а для остановки протоколирования - команду **DISABLE_FILAMENT_WIDTH_LOG**. Чтобы включить ведение журнала при включении питания, установите параметр `logging` в значение `true`.

Диаметр филамента регистрируется на каждом интервале измерения (по умолчанию 10 мм).
