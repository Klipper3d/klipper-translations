# Overview

به مستندات کلیپر خوش آمدید. اگر با کلیپر تازه آشنا شده‌اید، با مستندات [features](Features.md) و [installation](Installation.md) شروع کنید.

## اطلاعات اجمالی

- [Features](Features.md): فهرستی سطح بالا از ویژگی‌های Klipper.
- [FAQ](FAQ.md): سوالات متداول.
- [Releases](Releases.md): تاریخچه‌ی انتشارات Klipper.
- [Config changes](Config_Changes.md): تغییرات نرم‌افزاری اخیر که ممکن است کاربران را ملزم به به‌روزرسانی فایل پیکربندی چاپگر خود کند.
- [Contact](Contact.md): اطلاعات مربوط به گزارش اشکال و ارتباط کلی با توسعه‌دهندگان Klipper.

## نصب و پیکربندی

- [Installation](Installation.md): راهنمای نصب Klipper.
   - [Octoprint](OctoPrint.md): Guide to installing Octoprint with Klipper.
- [مرجع پیکربندی](Config_Reference.md): شرح پارامترهای پیکربندی.
   - [فاصله چرخش](Rotation_Distance.md): محاسبه پارامتر پله‌ای چرخش_فاصله.
- [بررسی‌های پیکربندی](Config_checks.md): تنظیمات پایه پین را در فایل پیکربندی بررسی کنید.
- [همسطح‌سازی](Bed_Level.md): اطلاعات مربوط به «همسطح‌سازی تخت» در کلیپر.
   - [Delta calibrate](Delta_Calibrate.md): کالیبراسیون سینماتیک دلتا.
   - [کالیبراسیون پروب](Probe_Calibrate.md): کالیبراسیون پروب‌های Z خودکار.
   - [BL-Touch](BLTouch.md): یک پروب Z از نوع "BL-Touch" پیکربندی کنید.
   - [سطح دستی](Manual_Level.md): کالیبراسیون نقاط انتهایی Z (و موارد مشابه).
   - [Bed Mesh](Bed_Mesh.md): اصلاح ارتفاع بستر بر اساس موقعیت‌های XY.
   - [Endstop phase](Endstop_Phase.md): Stepper assisted Z endstop positioning.
   - [Axis Twist Compensation](Axis_Twist_Compensation.md): A tool to compensate for inaccurate probe readings due to twist in X gantry.
- [Resonance compensation](Resonance_Compensation.md): A tool to reduce ringing in prints.
   - [Measuring resonances](Measuring_Resonances.md): Information on using adxl345 accelerometer hardware to measure resonance.
- [Pressure advance](Pressure_Advance.md): Calibrate extruder pressure.
- [G-Codes](G-Codes.md): Information on commands supported by Klipper.
- [Command Templates](Command_Templates.md): G-Code macros and conditional evaluation.
   - [Status Reference](Status_Reference.md): Information available to macros (and similar).
- [TMC Drivers](TMC_Drivers.md): Using Trinamic stepper motor drivers with Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing and probing using multiple micro-controllers.
- [Slicers](Slicers.md): Configure "slicer" software for Klipper.
- [Skew correction](Skew_Correction.md): Adjustments for axes not perfectly square.
- [PWM tools](Using_PWM_Tools.md): Guide on how to use PWM controlled tools such as lasers or spindles.
- [Exclude Object](Exclude_Object.md): The guide to the Exclude Objects implementation.

## مستندات توسعه‌دهنده

- [Code overview](Code_Overview.md): Developers should read this first.
- [Kinematics](Kinematics.md): Technical details on how Klipper implements motion.
- [Protocol](Protocol.md): Information on the low-level messaging protocol between host and micro-controller.
- [API Server](API_Server.md): Information on Klipper's command and control API.
- [MCU commands](MCU_Commands.md): A description of low-level commands implemented in the micro-controller software.
- [CAN bus protocol](CANBUS_protocol.md): Klipper CAN bus message format.
- [Debugging](Debugging.md): Information on how to test and debug Klipper.
- [Benchmarks](Benchmarks.md): Information on the Klipper benchmark method.
- [Contributing](CONTRIBUTING.md): Information on how to submit improvements to Klipper.
- [Packaging](Packaging.md): Information on building OS packages.

## اسناد خاص دستگاه

- [Example configs](Example_Configs.md): Information on adding an example config file to Klipper.
- [SDCard Updates](SDCard_Updates.md): Flash a micro-controller by copying a binary to an sdcard in the micro-controller.
- [Raspberry Pi as Micro-controller](RPi_microcontroller.md): Details for controlling devices wired to the GPIO pins of a Raspberry Pi.
- [Beaglebone](Beaglebone.md): Details for running Klipper on the Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Developer information on micro-controller flashing.
- [Bootloader Entry](Bootloader_Entry.md): Requesting the bootloader.
- [CAN bus](CANBUS.md): Information on using CAN bus with Klipper.
   - [CAN bus troubleshooting](CANBUS_Troubleshooting.md): Tips for troubleshooting CAN bus.
- [TSL1401CL filament width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](Hall_Filament_Width_Sensor.md)
- [Eddy Current Inductive probe](Eddy_Probe.md)
- [Load Cells](Load_Cell.md)
