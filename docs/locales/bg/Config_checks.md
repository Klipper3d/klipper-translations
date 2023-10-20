# Проверки на конфигурацията

Този документ съдържа списък със стъпки, които помагат да се потвърдят настройките на щифтовете във файла Klipper printer.cfg. Добре е да преминете през тези стъпки, след като сте изпълнили стъпките в [документа за инсталиране](Installation.md).

По време на това ръководство може да се наложи да се направят промени в конфигурационния файл на Klipper. Не забравяйте да издавате команда RESTART (рестартиране) след всяка промяна в конфигурационния файл, за да се уверите, че промяната влиза в сила (въведете "restart" (рестартиране) в терминалния раздел на Octoprint и след това щракнете върху "Send" (изпрати)). Добре е също така да издавате команда STATUS след всеки RESTART, за да проверите дали конфигурационният файл е зареден успешно.

## Проверка на температурата

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Проверка на M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Проверка на нагревателите

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Ако принтерът има отопляемо легло, извършете горния тест отново с леглото.

## Проверка на щифта за разрешаване на стъпковия двигател

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Проверка на крайните спирания

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Ако крайният ограничител изобщо не се променя, това обикновено означава, че крайният ограничител е свързан към друг щифт. Това обаче може да изисква и промяна на настройката за издърпване на извода (символът "^" в началото на името на endstop_pin - повечето принтери използват резистор за издърпване и символът "^" трябва да присъства).

## Проверка на стъпковите двигатели

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Ако стъпковият механизъм изобщо не се движи, проверете настройките "enable_pin" и "step_pin" за стъпковия механизъм. Ако стъпковият двигател се движи, но не се връща в първоначалното си положение, тогава проверете настройката "dir_pin". Ако стъпковият двигател се колебае в неправилна посока, то това обикновено показва, че "dir_pin" за оста трябва да се обърне. Това става чрез добавяне на символа "!" към "dir_pin" във файла за конфигуриране на принтера (или премахването му, ако вече има такъв). Ако двигателят се движи значително повече или значително по-малко от един милиметър, тогава проверете настройката "rotation_distance".

Изпълнете горния тест за всеки стъпков двигател, дефиниран в конфигурационния файл. (Задайте параметъра STEPPER на командата STEPPER_BUZZ на името на раздела от конфигурацията, който ще бъде тестван.) Ако в екструдера няма нишка, тогава може да се използва STEPPER_BUZZ, за да се провери свързаността на двигателя на екструдера (използвайте STEPPER=extruder). В противен случай е най-добре да се тества отделно двигателят на екструдера (вж. следващия раздел).

След проверка на всички крайни спирачки и проверка на всички стъпкови двигатели механизмът за насочване трябва да се тества. Изпълнете команда G28, за да настроите всички оси. Прекъснете захранването на принтера, ако той не се прибере правилно. Ако е необходимо, повторете стъпките за проверка на крайните ограничители и стъпковите двигатели.

## Проверете двигателя на екструдера

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Калибриране на PID настройките

Klipper поддържа [PID контрол](https://en.wikipedia.org/wiki/PID_controller) за екструдера и нагревателите на леглото. За да се използва този механизъм за управление, е необходимо да се калибрират PID настройките на всеки принтер (PID настройките, намерени в други фърмуери или в примерните конфигурационни файлове, често работят лошо).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

След приключване на теста за настройка стартирайте `SAVE_CONFIG`, за да актуализирате файла printer.cfg с новите настройки на PID.

Ако принтерът има отопляемо легло и той поддържа да се управлява от PWM (Модулация на ширината на импулса) тогава се препоръчва да се използва PID контрол за леглото. (Когато нагревателят за легло се управлява с помощта на алгоритъма PID той може да включва и изключва десет пъти в секунда, което може да не е подходящо за нагреватели с помощта на механичен превключвател.) Типична команда за калибриране на PID за легло е: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Следваща стъпка

Това ръководство има за цел да помогне при основната проверка на настройките на пиновете в конфигурационния файл на Klipper. Не забравяйте да прочетете ръководството [Изравняване на леглото](Bed_Level.md). Също така вижте документа [Slicers](Slicers.md) за информация относно конфигурирането на машина за рязане с Klipper.

След като сте се уверили, че основният печат работи, е добре да помислите за калибриране на [аванс на налягането](Pressure_Advance.md).

Възможно е да се наложи да извършите други видове подробна калибрация на принтера - в интернет има редица ръководства, които помагат за това (например, потърсете в интернет "3d printer calibration"). Като пример, ако изпитвате ефекта, наречен звънене, можете да опитате да следвате ръководството за настройка [Resonance compensation](Resonance_Compensation.md).
