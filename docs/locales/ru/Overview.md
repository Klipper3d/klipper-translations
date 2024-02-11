# Обзор

Добро пожаловать в документацию Klipper. Если вы новичок в Klipper, начните с документации о [возможностях](Features.md) и [установке](Installation.md).

## Обзорная информация

- [Функции](Features.md): Общий список возможностей Klipper.
- [ЧАВО](FAQ.md): Часто задаваемые вопросы.
- [Releases](Releases.md): История релизов Klipper.
- [Изменения конфигурации](Config_Changes.md): Недавние изменения программного обеспечения, которые могут потребовать от пользователей обновления файла конфигурации принтера.
- [Связатся](Contact.md): Информация по сообщениям об ошибках и общению с разработчиками Klipper.

## Установка и настройка

- [Установка](Installation.md): Гайд по установке Klipper.
- [Справочник по конфигурации](Config_Reference.md): Описание параметров конфигурации.
   - [Дистанция поворота](Rotation_Distance.md): Расчет параметра дистанции попорота(Rotation_distance).
- [Проверки конфигурации](Config_checks.md): Проверка основных настроек контактов в файле конфигурации.
- [Bed level](Bed_Level.md): информация о "выравнивании стола" в Klipper.
   - [Delta calibrate](Delta_Calibrate.md): Калибровка дельта-киноматики.
   - [Probe calibrate](Probe_Calibrate.md): Калибровка автоматический Z-зондов.
   - [BL-Touch](BLTouch.md): Конфигурация Z-зондов "BL-Touch".
   - [Manual level](Manual_Level.md): Калибровка крайних точек Z ( и подобные).
   - [Bed Mesh](Bed_Mesh.md): корректировки высоты стола относительно  координат по  XY.
   - [Endstop phase](Endstop_Phase.md): Позиционирование концевого упора Z с помощью шарового двигателя.
   - [Axis Twist Compensation](Axis_Twist_Compensation.md): A tool to compensate for inaccurate probe readings due to twist in X gantry.
- [Resonance compensation](Resonance_Compensation.md): Инструмент для уменьшения звона при печати.
   - [Measuring resonances](Measuring_Resonances.md): информация по использованию adxl345 акселерометра для "железных" измерений резонанса.
- [Pressure advance](Pressure_Advance.md): калибровка давления экструдера, основанная на действиях кинематики в конкретный момент.
- [G-Codes](G-Codes.md): Информация о командах, поддерживаемых Klipper.
- Command Templates](Command_Templates.md): G-Code макросы и условный прогресс.
   - [Status Reference](Status_Reference.md): Информация, доступная макросам (и им подобным).
- [TMC Drivers](TMC_Drivers.md): Использование драйверов шаговых двигателей Trinamic с Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Наведение и зондирование с использованием нескольких микроконтроллеров.
- [Slicers](Slicers.md): Конфигурация программного комплекса "slicer" для Klipper.
- [Коррекция перекоса](Skew_Correction.md): Корректировка для осей, не являющихся идеально квадратными.
- [PWM tools](Using_PWM_Tools.md): Руководство по использованию инструментов с ШИМ-управлением, таких как лазеры или шпиндели.
- [Exclude Object](Exclude_Object.md): Руководство по реализации исключаемых объектов.

## Документация для разработчиков

- [Обзор кода](Code_Overview.md): Разработчики должны прочитать это в первую очередь.
- [Кинематика](Kinematics.md): Технические подробности о том, как Klipper реализует движение.
- [Protocol](Protocol.md): Информация о низкоуровневом протоколе обмена сообщениями между хостом и микроконтроллером.
- [API Server](API_Server.md): Информация о командно-контрольном API Klipper.
- [Команды MCU](MCU_Commands.md): Описание низкоуровневых команд, реализованных в программном обеспечении микроконтроллера.
- [Протокол шины CAN](CANBUS_protocol.md): Формат сообщений шины CAN от Klipper.
- [Debugging](Debugging.md): Информация о том, как тестировать и отлаживать Klipper.
- [Benchmarks](Benchmarks.md): Информация об эталонном методе Klipper.
- [Contributing](CONTRIBUTING.md): Информация о том, как вносить улучшения в Klipper.
- [Packaging](Packaging.md): Информация о сборке пакетов ОС.

## Документы по конкретным устройствам

- [Example configs](Example_Configs.md): Информация о добавлении примера конфигурационного файла в Klipper.
- [SDCard Updates](SDCard_Updates.md): Прошивка микроконтроллера путем копирования двоичного файла на sdcard в микроконтроллере.
- [Raspberry Pi как микроконтроллер](RPi_microcontroller.md): Детали для управления устройствами, подключенными к контактам GPIO Raspberry Pi.
- [Beaglebone](Beaglebone.md): Подробности для запуска Klipper на Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Информация для разработчиков о прошивке микроконтроллеров.
- [Bootloader Entry](Bootloader_Entry.md): Запрос загрузчика операционной системы.
- [CAN шина](CANBUS.md): Информация об использовании шины CAN с Klipper.
   - [CAN bus troubleshooting](CANBUS_Troubleshooting.md): Tips for troubleshooting CAN bus.
- [TSL1401CL датчик ширины нити](TSL1401CL_Filament_Width_Sensor.md)
- [Датчик ширины нити Холла](Hall_Filament_Width_Sensor.md)
