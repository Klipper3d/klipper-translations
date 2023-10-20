# Проверки конфигурации

В этом документе приведен список действий, которые помогут подтвердить настройки выводов (pin) в файле Klipper printer.cfg. Рекомендуется выполнить эти шаги после выполнения шагов, описанных в [документе по установке](Installation.md).

Во время работы с этим руководством может потребоваться внести изменения в конфигурационный файл Klipper. Обязательно выполняйте команду RESTART после каждого изменения в файле конфигурации, чтобы убедиться, что изменение вступило в силу (введите «restart» на вкладке терминала Octoprint, а затем нажмите «Отправить»). Также рекомендуется запускать команду STATUS после каждого RESTART, чтобы убедиться, что файл конфигурации успешно загружен.

## Проверьте температуру

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Проверьте M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Проверка нагревателей

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Если в принтере есть стол с подогревом, повторите вышеуказанный тест со столом.

## Проверьте пин включения шагового двигателя

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Проверьте концевые упоры

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Если концевой упор вообще не меняется, это обычно указывает на то, что концевой упор подключен к другому контакту. Однако может также потребоваться изменение настройки подтягивания вывода (символ «^» в начале имени endstop_pin — в большинстве принтеров используется подтягивающий резистор, и символ «^» должен присутствовать).

## Проверка шаговых двигателей

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Если шаговый двигатель вообще не двигается, проверьте настройки "enable_pin" и "step_pin" для шагового двигателя. Если шаговый двигатель перемещается, но не возвращается в исходное положение, проверьте настройку «dir_pin». Если шаговый двигатель колеблется в неправильном направлении, это обычно указывает на то, что «dir_pin» для оси необходимо инвертировать. Это делается путем добавления '!' в «dir_pin» в файле конфигурации принтера (или удалив его, если он уже есть). Если двигатель перемещается значительно больше или значительно меньше одного миллиметра, проверьте настройку «rotation_distance».

Запустите приведенный выше тест для каждого шагового двигателя, указанного в файле конфигурации. (Установите параметр STEPPER команды STEPPER_BUZZ на имя проверяемого раздела конфигурации.) Если в экструдере нет нити, можно использовать STEPPER_BUZZ для проверки подключения двигателя экструдера (используйте STEPPER=extruder). В противном случае лучше протестировать двигатель экструдера отдельно (см. следующий раздел).

После проверки всех концевых упоров и проверки всех шаговых двигателей следует проверить механизм возврата в исходное положение. Введите команду G28 для возврата всех осей в исходное положение. Отключите питание принтера, если он не возвращается в исходное положение должным образом. При необходимости повторите этапы проверки концевого упора и шагового двигателя.

## Проверка двигатель экструдера

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Калибровка настроек PID

Klipper поддерживает [ПИД-регуляцию](https://ru.wikipedia.org/wiki/ПИД-регулятор) для экструдера и нагревателей. Чтобы использовать этот механизм управления, необходимо откалибровать настройки ПИД на каждом принтере (настройки ПИД, найденные в других прошивках или в образцах файлов конфигурации, часто работают плохо).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

По завершении тестовой настройки запустите `SAVE_CONFIG`, чтобы обновить файл print.cfg с новыми настройками PID.

Если в принтере есть стол с подогревом и он поддерживает управление с помощью PWM (широтно-импульсной модуляции), то рекомендуется использовать ПИД-регулятор для стола. (Когда нагреватель стола управляется с помощью алгоритма PID, он может включаться и выключаться десять раз в секунду, что может не подходить для нагревателей с механическим переключателем.) Типичная команда калибровки PID стола: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Следующие шаги

Это руководство призвано помочь с базовой проверкой настроек контактов в файле конфигурации Klipper. Обязательно прочитайте руководство [bed leveling](Bed_Level.md). Также см. документ [Slicers](Slicers.md) для получения информации о настройке слайсера с помощью Klipper.

После того, как вы убедились, что основная печать работает, рекомендуется подумать о калибровке [повышения давления](Pressure_Advance.md).

Возможно, потребуется выполнить другие типы детальной калибровки принтера — чтобы помочь с этим, в Интернете доступен ряд руководств (например, выполните поиск в Интернете по запросу «калибровка 3D-принтера»). Например, если вы столкнулись с эффектом, называемый звоном, вы можете попробовать выполнить настройку по руководству [компенсации резонанса](Resonance_Compensation.md).
