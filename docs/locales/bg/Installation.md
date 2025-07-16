# Инсталация

These instructions assume the software will run on a Linux-based host running a Klipper-compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian-based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions, host relates to the Linux device and mcu relates to the printer board. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## Получаване на конфигурационен файл на Klipper

Повечето настройки на Klipper се определят от "файл за конфигурация на принтера" printer.cfg, който се съхранява на хоста. Подходящият конфигурационен файл често може да бъде намерен, като се потърси в Klipper [config directory](../config/) за файл, започващ с префикс "printer-", който съответства на целевия принтер. Конфигурационният файл на Klipper съдържа техническа информация за принтера, която ще бъде необходима по време на инсталацията.

Ако в директорията config на Klipper няма подходящ файл за конфигурация на принтера, опитайте се да потърсите на уебсайта на производителя на принтера, за да видите дали има подходящ файл за конфигурация на Klipper.

Ако не може да бъде намерен конфигурационен файл за принтера, но е известен типът на платката за управление на принтера, тогава потърсете подходящ [конфигурационен файл](../config/), започващ с префикс "generic-". Тези примерни файлове за платките на принтера би трябвало да позволят успешно завършване на първоначалната инсталация, но ще изискват някои настройки, за да се получи пълна функционалност на принтера.

Възможно е също така да дефинирате нова конфигурация на принтера от нулата. Това обаче изисква значителни технически познания за принтера и неговата електроника. Препоръчително е повечето потребители да започнат с подходящ конфигурационен файл. Ако създавате нов потребителски конфигурационен файл за принтер, започнете с най-близкия примерен [config file](../config/) и използвайте Klipper [config reference](Config_Reference.md) за допълнителна информация.

## Взаимодействие с Klipper

Klipper е фърмуер за 3D принтер, така че се нуждае от някакъв начин, по който потребителят да взаимодейства с него.

Понастоящем най-добрият избор са фронтовете, които извличат информация чрез [Moonraker web API](https://moonraker.readthedocs.io/), а също така има възможност да се използва [Octoprint](https://octoprint.org/) за управление на Klipper.

Потребителят може да избере какво да използва, но основният Klipper е един и същ във всички случаи. Препоръчваме на потребителите да проучат наличните възможности и да вземат информирано решение.

## Получаване на образ на операционната система за SBC

There are many ways to obtain an OS image for Klipper for SBC use, most depend on what front end you wish to use. Some manufacturers of these SBC boards also provide their own Klipper-centric images.

The two main Moonraker-based front ends are [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/), the latter of which has a premade install image ["MainsailOS"](https://docs-os.mainsail.xyz/), this has the option for Raspberry Pi and some OrangePi variants.

Fluidd може да се инсталира чрез KIAUH (Klipper Install And Update Helper), който е обяснен по-долу и представлява инсталатор от трета страна за всичко, свързано с Klipper.

OctoPrint може да бъде инсталиран чрез популярния образ OctoPi или чрез KIAUH, този процес е обяснен в <OctoPrint.md>

## Инсталиране чрез KIAUH

Normally you would start with a base image for your SBC, RPiOS Lite for example, or in the case of an x86 Linux device, Ubuntu Server. Please note that Desktop variants are not recommended due to certain helper programs that can stop some Klipper functions from working and even mask access to some printer boards.

KIAUH can be used to install Klipper and its associated programs on a variety of Linux-based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

## Изграждане и мигане на микроконтролера

За да компилирате кода на микроконтролера, започнете с изпълнението на тези команди на вашето хост устройство:

```
cd ~/klipper/
make menuconfig
```

Коментарите в горната част на файла [конфигурация на принтера](#obtain-a-klipper-configuration-file) трябва да описват настройките, които трябва да бъдат зададени по време на "make menuconfig". Отворете файла в уеб браузър или текстов редактор и потърсете тези инструкции близо до горната част на файла. След като конфигурирате съответните настройки на "menuconfig", натиснете "Q", за да излезете, и след това "Y", за да запазите. След това стартирайте:

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board, then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

В противен случай често се използват следните стъпки за "флашване" на контролната платка на принтера. Първо е необходимо да се определи серийният порт, свързан с микроконтролера. Изпълнете следното:

```
ls /dev/serial/by-id/*
```

Тя трябва да отчете нещо подобно на следното:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Обикновено всеки принтер има свое собствено уникално име на сериен порт. Това уникално име ще се използва при флашването на микроконтролера. Възможно е в горния изход да има няколко реда - ако е така, изберете реда, съответстващ на микроконтролера. Ако са изброени много елементи и изборът е двусмислен, изключете платката и изпълнете командата отново, като липсващият елемент ще бъде вашата печатна платка(за повече информация вижте [FAQ](FAQ.md#wheres-my-serial-port)).

For common micro-controllers with STM32 or clone chips, LPC chips and others, it is usual that these need an initial Klipper flash via SD card.

When flashing with this method, it is important to make sure that the print board is not connected with USB to the host, due to some boards being able to feed power back to the board and stopping a flash from occurring.

Please note, that most print boards that use SD cards for flash will implement some kind of flash loop protection for when the sd card is left in place. There are two common methods:

Filename Change Required (usually "stock" print boards):

These boards require the firmware file to have a different name each time you flash (for example, firmware1.bin, firmware2.bin, etc.). If you reuse the same filename, the board may ignore it and not update.

Automatic File Renaming (usually aftermarket print boards:

Other boards allow using the same filename, commonly firmware.bin, but after flashing, the board renames the file to firmware.cur. This helps indicate the firmware was successfully flashed and prevents it from flashing again on the next startup.

Before flashing, make sure to check which behavior your board follows.

За обикновените микроконтролери, използващи чипове Atmega, например 2560, кодът може да се флашне с нещо подобно:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Не забравяйте да актуализирате FLASH_DEVICE с уникалното име на серийния порт на принтера.

За обикновените микроконтролери, използващи чипове RP2040, кодът може да бъде променен с нещо подобно на:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

Важно е да се отбележи, че преди тази операция може да се наложи чиповете RP2040 да бъдат въведени в режим на зареждане.

## Конфигуриране на Klipper

Следващата стъпка е да копирате [конфигурационния файл на принтера](#obtain-a-klipper-configuration-file) на хоста.

Arguably the easiest way to set the Klipper configuration file is using the built-in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Друга възможност е да използвате настолен редактор, който поддържа редактиране на файлове чрез протоколите "scp" и/или "sftp". Съществуват свободно достъпни инструменти, които поддържат това (например Notepad++, WinSCP и Cyberduck). Заредете файла с конфигурацията на принтера в редактора и след това го запишете като файл с име "printer.cfg" в домашната директория на потребителя на pi (т.е. /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via SSH. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Обичайно е всеки принтер да има свое собствено уникално име за микроконтролера. Името може да се промени след флашването на Klipper, така че повторете тези стъпки отново, дори ако те вече са били извършени при флашването. Изпълнете:

```
ls /dev/serial/by-id/*
```

Тя трябва да отчете нещо подобно на следното:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

След това актуализирайте файла с конфигурацията с уникалното име. Например актуализирайте раздела `[mcu]`, за да изглежда по следния начин:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file, it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report that the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

При персонализиране на конфигурационния файл на принтера нерядко Klipper съобщава за грешка в конфигурацията. Ако възникне грешка, направете необходимите корекции в конфигурационния файл на принтера и издайте "restart", докато "status" отчете, че принтерът е готов.

Klipper reports error messages via the command console and pop-ups in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located at `~/printer_data/logs/klippy.log`.

След като Klipper съобщи, че принтерът е готов, преминете към документа [config check document](Config_checks.md), за да извършите някои основни проверки на дефинициите в конфигурационния файл. За друга информация вижте основния документ [documentation reference](Overview.md).
