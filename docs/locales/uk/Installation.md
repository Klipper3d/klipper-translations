# Встановлення

These instructions assume the software will run on a Linux-based host running a Klipper-compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian-based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions, host relates to the Linux device and mcu relates to the printer board. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## Отримання файлу конфігурації кліппера

Більшість параметрів Klipper визначається «файлом конфігурації принтера» printer.cfg, який зберігатиметься на хості. Відповідний файл конфігурації часто можна знайти, переглянувши [каталог конфігурації](../config/) Klipper для файлу, який починається з префікса «printer-», який відповідає цільовому принтеру. Файл конфігурації Klipper містить технічну інформацію про принтер, яка знадобиться під час встановлення.

Якщо ви не є відповідним файлом конфігурації принтера в каталозі Klipper, то спробуйте шукати сайт виробника принтера, щоб побачити, якщо у них є відповідний файл конфігурації Klipper.

Якщо не вдається знайти файл конфігурації для принтера, але відомий тип плати керування принтером, знайдіть відповідний [файл конфігурації](../config/), який починається з префікса "generic-". Ці приклади файлів плати принтера повинні дозволити успішно завершити початкову інсталяцію, але потребують певних налаштувань для отримання повної функціональності принтера.

Також можна визначити нову конфігурацію принтера з нуля. Однак для цього потрібні значні технічні знання про принтер та його електроніку. Рекомендується, щоб більшість користувачів починали з відповідного файлу конфігурації. Якщо ви створюєте новий власний файл конфігурації принтера, почніть із найближчого прикладу [конфігураційного файлу](../config/) і скористайтеся Klipper [конфігураційним посиланням](Config_Reference.md) для отримання додаткової інформації.

## Інтерактивація з клиппером

Klipper - це прошивка принтера 3d, тому вона потребує певного способу взаємодії з ним.

В даний час кращі варіанти є передніми кінцями, які отримують інформацію через [Moonraker web API](https://moonraker.readthedocs.io/) і є також можливість використовувати [Octoprint](https://octoprint.org/) для управління Klipper.

Вибір є користувачем на те, що використовувати, але основний кліппер є однаковим у всіх випадках. Ми заохочуємо користувачів до дослідження варіантів, доступних і прийняття рішення.

## Отримання образу ОС для SBC

There are many ways to obtain an OS image for Klipper for SBC use, most depend on what front end you wish to use. Some manufacturers of these SBC boards also provide their own Klipper-centric images.

The two main Moonraker-based front ends are [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/), the latter of which has a premade install image ["MainsailOS"](https://docs-os.mainsail.xyz/), this has the option for Raspberry Pi and some OrangePi variants.

Фрідд можна встановити через KIAUH(Klipper Install І Update Helper), який пояснюється нижче і є 3-й вечірній інсталятор для всіх речей Klipper.

OctoPrint може бути встановлений за допомогою популярного OctoPi зображення або через KIAUH, цей процес пояснюється <OctoPrint.md>

## Встановлення через КІАУХ

Normally you would start with a base image for your SBC, RPiOS Lite for example, or in the case of an x86 Linux device, Ubuntu Server. Please note that Desktop variants are not recommended due to certain helper programs that can stop some Klipper functions from working and even mask access to some printer boards.

KIAUH can be used to install Klipper and its associated programs on a variety of Linux-based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

## Будівництво та миготливий мікроконтролер

Щоб компілювати код мікроконтролера, запустіть ці команди на пристрої хосту:

```
cd ~ / клиппер /
налаштування меню
```

У коментарях у верхній частині файлу конфігурації [printer](#obtain-a-klipper-configuration-file) слід описати налаштування, які необхідно встановити під час меню "makeconfig". Відкрийте файл у веб-браузері або текстовому редакторі та ознайомтеся з цими інструкціями у верхній частині файлу. Після того, як було налаштовано відповідні налаштування "menuconfig", натисніть кнопку "Q" для виходу, а потім "Y" для збереження. Далі запустіть:

```
зроби
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board, then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

В іншому випадку часто використовуються наступні дії для "flash" обробної дошки. Спочатку необхідно визначити послідовний порт, підключений до мікроконтролера. Запустити наступне:

```
ls /dev/serial/by-id/ ім'я *
```

Повідомляти щось схоже на наступне:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Це загальний для кожного принтера, щоб мати свою унікальну назву серійного порту. Це унікальне ім'я буде використовуватися при митті мікроконтролера. Можливо, є декілька рядків у вищевказаному виході - якщо так, виберіть рядок, що відповідає мікроконтролю. Якщо багато елементів вказані і вибір неоднозначні, розгорніть дошку і запустіть команду знову, відсутній пункт буде вашим друкованим дошкою (див. [FAQ](FAQ.md#wheres-my-serial-port) для отримання додаткової інформації).

For common micro-controllers with STM32 or clone chips, LPC chips and others, it is usual that these need an initial Klipper flash via SD card.

When flashing with this method, it is important to make sure that the print board is not connected with USB to the host, due to some boards being able to feed power back to the board and stopping a flash from occurring.

Для звичайних мікроконтролерів з використанням чіпсів Atmega, наприклад, 2560, код може бути спалахований чимось схожим на:

```
sudo обслуговування klipper стоп
зробити флеш FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo сервіс klipper старт
```

Будьте впевнені, що оновлення FLASH_DEVICE з унікальною серійною назвою принтера.

Для звичайних мікроконтролерів з використанням чіпсів RP2040, код може бути спалахований чимось схожим на:

```
sudo обслуговування klipper стоп
зробити флеш FLASH_DEVICE=перший
sudo сервіс klipper старт
```

Важливо відзначити, що чіпси RP2040 можуть знадобитися вводити в режим завантаження до цієї операції.

## Налаштування кліппера

Наступним кроком є копіювання файлу конфігурації [printer](#obtain-a-klipper-configuration-file) до хосту.

Arguably the easiest way to set the Klipper configuration file is using the built-in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Ще одним варіантом є використання настільного редактора, який підтримує редагування файлів за протоколами "шприц" та/або "шрифт". Доступні інструменти, які підтримують це (наприклад, Notepad++, WinSCP та Cyberduck). Завантажте файл конфігурації принтера в редакторі, а потім збережіть його як файл, названий "printer.cfg" в домашньому каталозі користувача pi (тобто /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via SSH. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
javascript licenses api веб-сайт go1.13.8 ~/принтер.cfg
javascript licenses api веб-сайт go1.13.8
```

Для кожного принтера необхідно мати власну унікальну назву мікроконтролера. Ім'я може змінитися після того, як миготливий кліппер, так що повторно виконайте ці кроки, навіть якщо вони вже робилися при флешці. Запуск:

```
ls /dev/serial/by-id/ ім'я *
```

Повідомляти щось схоже на наступне:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Потім оновити файл config з унікальною назвою. Наприклад, оновити розділ `[mcu]`, щоб подивитися щось схоже на:

```
[mcu]
Серія: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file, it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report that the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

Коли налаштовує файл налаштування принтера, це не рідкість для Klipper, щоб повідомити помилку конфігурації. Якщо виникає помилка, зробіть будь-які необхідні корективи до файлу налаштувань принтера і виписку «рештарт» до звіту «статус».

Klipper reports error messages via the command console and pop-ups in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located at `~/printer_data/logs/klippy.log`.

Після того, як Klipper повідомляє, що принтер готовий, приступайте до [config check документ](Config_checks.md) для виконання деяких базових перевірок на визначеннях у файлі конфігурації. Головна [Довідник](Overview.md) для іншої інформації.
