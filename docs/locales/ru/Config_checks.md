# Configuration checks

В этом документе приведен список действий, которые помогут подтвердить настройки выводов (pin) в файле Klipper printer.cfg. Рекомендуется выполнить эти шаги после выполнения шагов, описанных в [документе по установке](Installation.md).

Во время работы с этим руководством может потребоваться внести изменения в конфигурационный файл Klipper. Обязательно выполняйте команду RESTART после каждого изменения в файле конфигурации, чтобы убедиться, что изменение вступило в силу (введите «restart» на вкладке терминала Octoprint, а затем нажмите «Отправить»). Также рекомендуется запускать команду STATUS после каждого RESTART, чтобы убедиться, что файл конфигурации успешно загружен.

## Проверить температуру

Начните с проверки правильности регистрации температуры. Перейдите на вкладку температуры Octoprint.

![octoprint-temperature](img/octoprint-temperature.png)

Убедитесь, что температура сопла и стола (если применимо) присутствует и не повышается. Если он увеличивается, отключите питание принтера. Если температуры неточны, проверьте настройки «sensor_type» и «sensor_pin» для сопла и/или стола.

## Проверить M112

Перейдите на вкладку терминала Octoprint и введите команду M112 в терминале. Эта команда требует от Klipper перейти в состояние «выключения». Это приведет к отключению Octoprint от Klipper — перейдите в область «Подключение» и нажмите «Подключиться», чтобы вызвать повторное подключение Octoprint. Затем перейдите на вкладку температуры Octoprint и убедитесь, что температура продолжает обновляться и не повышается. Если температура повышается, отключите питание принтера.

Команда M112 переводит Klipper в состояние «отключения». Чтобы сбросить это состояние, введите команду FIRMWARE_RESTART на вкладке терминала Octoprint.

## Проверка нагревателей

Перейдите на вкладку температуры Octoprint и введите 50, а затем введите в поле температуры «Инструмент». Температура экструдера на графике должна начать увеличиваться (примерно через 30 секунд). Затем перейдите в раскрывающийся список температуры «Инструмент» и выберите «Выкл.». Через несколько минут температура должна начать возвращаться к исходному значению комнатной температуры. Если температура не увеличивается, проверьте настройку «heater_pin» в конфигурации.

Если в принтере есть стол с подогревом, повторите вышеуказанный тест со столом.

## Проверьте пин включения шагового двигателя

Убедитесь, что все оси принтера могут свободно перемещаться вручную (шаговые двигатели отключены). Если нет, введите команду M84, чтобы отключить двигатели. Если какая-либо из осей по-прежнему не может свободно двигаться, проверьте конфигурацию шагового двигателя «enable_pin» для данной оси. В большинстве стандартных драйверов шаговых двигателей вывод включения двигателя имеет значение «#active low», поэтому вывод включения должен иметь «!» перед выводом (например, "enable_pin: !ar38").

## Проверить концевики

Вручную переместите все оси принтера так, чтобы ни одна из них не касалась упора. Отправьте команду QUERY_ENDSTOPS через вкладку терминала Octoprint. Он должен ответить текущим состоянием всех настроенных оконечных устройств, и все они должны сообщать о состоянии «open». Для каждой из конечных остановок повторно запустите команду QUERY_ENDSTOPS, одновременно активируя конечную остановку. Команда QUERY_ENDSTOPS должна сообщать о конечной остановке как "TRIGGERED".

Если конечный упор отображается перевернутым (при срабатывании он сообщает «открыто» и наоборот), добавьте «!» к определению контакта (например, «endstop_pin: ^! ar3») или удалите «!», если он уже присутствует.

Если концевой упор вообще не меняется, это обычно указывает на то, что концевой упор подключен к другому контакту. Однако может также потребоваться изменение настройки подтягивания вывода (символ «^» в начале имени endstop_pin — в большинстве принтеров используется подтягивающий резистор, и символ «^» должен присутствовать).

## Проверка шаговых двигателей

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x`. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

If the stepper does not move at all, then verify the "enable_pin" and "step_pin" settings for the stepper. If the stepper motor moves but does not return to its original position then verify the "dir_pin" setting. If the stepper motor oscillates in an incorrect direction, then it generally indicates that the "dir_pin" for the axis needs to be inverted. This is done by adding a '!' to the "dir_pin" in the printer config file (or removing it if one is already there). If the motor moves significantly more or significantly less than one millimeter then verify the "rotation_distance" setting.

Run the above test for each stepper motor defined in the config file. (Set the STEPPER parameter of the STEPPER_BUZZ command to the name of the config section that is to be tested.) If there is no filament in the extruder then one can use STEPPER_BUZZ to verify the extruder motor connectivity (use STEPPER=extruder). Otherwise, it's best to test the extruder motor separately (see the next section).

After verifying all endstops and verifying all stepper motors the homing mechanism should be tested. Issue a G28 command to home all axes. Remove power from the printer if it does not home properly. Rerun the endstop and stepper motor verification steps if necessary.

## Verify extruder motor

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the Octoprint temperature tab and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the Octoprint control tab and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Calibrate PID settings

Klipper supports [PID control](https://en.wikipedia.org/wiki/PID_controller) for the extruder and bed heaters. In order to use this control mechanism, it is necessary to calibrate the PID settings on each printer (PID settings found in other firmwares or in the example configuration files often work poorly).

To calibrate the extruder, navigate to the OctoPrint terminal tab and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

At the completion of the tuning test run `SAVE_CONFIG` to update the printer.cfg file the new PID settings.

If the printer has a heated bed and it supports being driven by PWM (Pulse Width Modulation) then it is recommended to use PID control for the bed. (When the bed heater is controlled using the PID algorithm it may turn on and off ten times a second, which may not be suitable for heaters using a mechanical switch.) A typical bed PID calibration command is: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Next steps

This guide is intended to help with basic verification of pin settings in the Klipper configuration file. Be sure to read the [bed leveling](Bed_Level.md) guide. Also see the [Slicers](Slicers.md) document for information on configuring a slicer with Klipper.

After one has verified that basic printing works, it is a good idea to consider calibrating [pressure advance](Pressure_Advance.md).

It may be necessary to perform other types of detailed printer calibration - a number of guides are available online to help with this (for example, do a web search for "3d printer calibration"). As an example, if you experience the effect called ringing, you may try following [resonance compensation](Resonance_Compensation.md) tuning guide.
