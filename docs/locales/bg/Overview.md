# Общ преглед

Добре дошли в документацията на Klipper. Ако сте нов потребител на Klipper, започнете с документите [features](Features.md) и [installation](Installation.md).

## Преглед на информацията

- [Характеристики](Features.md): Списък на високо ниво на функциите в Klipper.
- [ЧЗВ](FAQ.md): Често задавани въпроси.
- [Releases](Releases.md): Историята на изданията на Klipper.
- [Промени в конфигурацията](Config_Changes.md): Скорошни промени в софтуера, които може да изискват от потребителите да актуализират конфигурационния файл на принтера.
- [Контакт](Contact.md): Информация за докладване на грешки и обща комуникация с разработчиците на Klipper.

## Инсталиране и конфигуриране

- [Инсталация](Installation.md): Ръководство за инсталиране на Klipper.
- [Config Reference](Config_Reference.md): Описание на параметрите на конфигурацията.
   - [Разстояние на завъртане](Rotation_Distance.md): Изчисляване на стъпковия параметър Rotation_distance.
- [Проверки на конфигурацията](Config_checks.md): Проверете основните настройки на ПИН в конфигурационния файл.
- [Ниво на леглото](Bed_Level.md): Информация за "нивелиране на леглото" в Klipper.
   - [Delta calibrate](Delta_Calibrate.md): Калибриране на делта кинематиката.
   - [Probe calibrate](Probe_Calibrate.md): Калибриране на автоматичните Z-сонди.
   - [BL-Touch](BLTouch.md): Конфигуриране на Z-сонда "BL-Touch".
   - [Ръчно ниво](Manual_Level.md): Калибриране на крайните ограничители Z (и други подобни).
   - [Bed Mesh](Bed_Mesh.md): Корекция на височината на леглото въз основа на местоположението XY.
   - [Endstop phase](Endstop_Phase.md): Позициониране на крайния ограничител Z с помощта на стъпков механизъм.
   - [Axis Twist Compensation](Axis_Twist_Compensation.md): A tool to compensate for inaccurate probe readings due to twist in X gantry.
- [Резонансна компенсация](Resonance_Compensation.md): Инструмент за намаляване на звъненето в разпечатките.
   - [Измерване на резонанси](Measuring_Resonances.md): Информация за използването на хардуерния акселерометър adxl345 за измерване на резонанс.
- [Напредък на налягането](Pressure_Advance.md): Калибриране на налягането в екструдера.
- [G-Codes](G-Codes.md): Информация за командите, поддържани от Klipper.
- [Командни шаблони](Command_Templates.md): G-Code макроси и условна оценка.
   - [Справка за състоянието](Status_Reference.md): Налична информация за макроси (и подобни).
- [TMC Drivers](TMC_Drivers.md): Използване на драйвери за стъпкови двигатели Trinamic с Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Наместване и сондиране с помощта на няколко микроконтролера.
- [Slicers](Slicers.md): Конфигуриране на софтуера "slicer" за Klipper.
- [Корекция на наклона](Skew_Correction.md): Корекции за оси, които не са идеално квадратни.
- [PWM tools](Using_PWM_Tools.md): Ръководство за използване на инструменти, управлявани от ШИМ, като лазери или шпиндели.
- [Exclude Object](Exclude_Object.md): The guide to the Exclude Objects implementation.

## Документация за разработчици

- [Преглед на кода](Code_Overview.md): Разработчиците трябва да прочетат първо това.
- [Кинематика](Kinematics.md): Технически подробности за това как Klipper реализира движението.
- [Протокол](Protocol.md): Информация за протокола за обмен на съобщения на ниско ниво между хоста и микроконтролера.
- [Сървър на API](API_Server.md): Информация за API за командване и управление на Klipper.
- [MCU commands](MCU_Commands.md): Описание на командите от ниско ниво, реализирани в софтуера на микроконтролера.
- [Протокол на CAN шината](CANBUS_protocol.md): Формат на съобщение на CAN шината на Klipper.
- [Отстраняване на грешки](Debugging.md): Информация как да тествате и отстранявате грешки в Klipper.
- [Benchmarks](Benchmarks.md): Информация за метода за сравнение Klipper.
- [Принос](CONTRIBUTING.md): Информация за това как да изпращате подобрения в Klipper.
- [Packaging](Packaging.md): Информация за изграждането на пакети за операционни системи.

## Документи, специфични за устройството

- [Примерни конфигурации](Example_Configs.md): Информация за добавяне на примерен конфигурационен файл към Klipper.
- [SDCard Updates](SDCard_Updates.md): Флаш на микроконтролер чрез копиране на двоичен файл на SDcard в микроконтролера.
- [Raspberry Pi като микроконтролер](RPi_microcontroller.md): Подробности за управление на устройства, свързани към GPIO изводите на Raspberry Pi.
- [Beaglebone](Beaglebone.md): Подробности за работа с Klipper на Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Информация за разработчици относно флашването на микроконтролери.
- [Bootloader Entry](Bootloader_Entry.md): Requesting the bootloader.
- [CAN bus](CANBUS.md): Информация за използването на CAN шина с Klipper.
   - [CAN bus troubleshooting](CANBUS_Troubleshooting.md): Tips for troubleshooting CAN bus.
- [TSL1401CL сензор за широчина на нишката](TSL1401CL_Filament_Width_Sensor.md)
- [Сензор за ширина на нишката на Хол](Hall_Filament_Width_Sensor.md)
