# Установка

These instructions assume the software will run on a Linux-based host running a Klipper-compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian-based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions, host relates to the Linux device and mcu relates to the printer board. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## Получение файла конфигурации Klipper

Большинство настроек Klipper определяется "файлом конфигурации принтера" printer.cfg, который будет храниться на хосте. Подходящий файл конфигурации часто можно найти, заглянув в каталог Klipper [config](../config/) для поиска файла, начинающегося с префикса "printer-", который соответствует целевому принтеру. Конфигурационный файл Klipper содержит техническую информацию о принтере, которая понадобится во время установки.

Если в каталоге Klipper config нет соответствующего файла конфигурации принтера, попробуйте поискать на сайте производителя принтера, чтобы узнать, есть ли у него соответствующий файл конфигурации Klipper.

Если конфигурационный файл для принтера не найден, но известен тип платы управления принтером, то ищите соответствующий [config-файл](../config/), начинающийся с префикса "generic-". Приведенные примеры файлов платы управления принтером должны позволить успешно завершить начальную установку, но для получения полной функциональности принтера потребуется некоторая доработка.

Можно также задать новую конфигурацию принтера с нуля. Однако это требует значительных технических знаний о принтере и его электронике. Большинству пользователей рекомендуется начинать работу с соответствующего файла конфигурации. При создании нового файла конфигурации принтера следует начать с ближайшего примера [config file](../config/), а для получения дополнительной информации использовать справочник Klipper [config reference](Config_Reference.md).

## Взаимодействие с Klipper

Klipper - это прошивка для 3d-принтера, поэтому пользователю нужно как-то взаимодействовать с ней.

В настоящее время лучшим выбором являются фронт-энды, получающие информацию через [Moonraker web API](https://moonraker.readthedocs.io/), также есть возможность использовать [Octoprint](https://octoprint.org/) для управления Klipper.

Выбор остается за пользователем, но основа Klipper во всех случаях одинакова. Мы рекомендуем пользователям изучить доступные варианты и принять взвешенное решение.

## Получение образа ОС для SBC

There are many ways to obtain an OS image for Klipper for SBC use, most depend on what front end you wish to use. Some manufacturers of these SBC boards also provide their own Klipper-centric images.

The two main Moonraker-based front ends are [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/), the latter of which has a premade install image ["MainsailOS"](https://docs-os.mainsail.xyz/), this has the option for Raspberry Pi and some OrangePi variants.

Fluidd можно установить с помощью KIAUH (Klipper Install And Update Helper), о котором рассказывается ниже, и который является сторонним инсталлятором для всех вещей Klipper.

OctoPrint может быть установлен через популярный образ OctoPi или через KIAUH, этот процесс описан в <OctoPrint.md>

## Установка через KIAUH

Normally you would start with a base image for your SBC, RPiOS Lite for example, or in the case of an x86 Linux device, Ubuntu Server. Please note that Desktop variants are not recommended due to certain helper programs that can stop some Klipper functions from working and even mask access to some printer boards.

KIAUH can be used to install Klipper and its associated programs on a variety of Linux-based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

## Компиляция и прошивка микроконтроллера

Чтобы скомпилировать код микроконтроллера, начните с выполнения этих команд на хост-устройстве:

```
cd ~/klipper/
make menuconfig
```

Комментарии в верхней части файла [printer configuration file](#obtain-a-klipper-configuration-file) должны описывать настройки, которые необходимо задать при выполнении команды "make menuconfig". Откройте файл в браузере или текстовом редакторе и найдите эти инструкции в верхней части файла. После того как соответствующие настройки "menuconfig" будут заданы, нажмите "Q" для выхода, а затем "Y" для сохранения. Затем запустите программу:

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board, then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

В противном случае для "прошивки" платы управления принтером часто используются следующие действия. Во-первых, необходимо определить последовательный порт, подключенный к микроконтроллеру. Для этого выполните следующее:

```
ls /dev/serial/by-id/*
```

Должно отобразиться что-то вроде:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Обычно каждый принтер имеет свое уникальное имя последовательного порта. Это уникальное имя будет использоваться при прошивке микроконтроллера. Возможно, в приведенном выше выводе будет несколько строк - если это так, выберите строку, соответствующую микроконтроллеру. Если в списке много элементов и выбор неоднозначен, отключите плату и запустите команду снова, недостающим элементом будет ваша печатная плата (см. дополнительную информацию в [FAQ](FAQ.md#wheres-my-serial-port)).

For common micro-controllers with STM32 or clone chips, LPC chips and others, it is usual that these need an initial Klipper flash via SD card.

When flashing with this method, it is important to make sure that the print board is not connected with USB to the host, due to some boards being able to feed power back to the board and stopping a flash from occurring.

Для распространенных микроконтроллеров, использующих микросхемы Atmega, например 2560, код можно прошить примерно так:

```
sudo service klipper stop

make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0

sudo service klipper start
```

Не забудьте заменить значение FLASH_DEVICE на имя порта вашего принтера.

Для распространенных микроконтроллеров, использующих микросхемы RP2040, код можно прошить примерно так:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

Важно отметить, что перед этой операцией микросхемы RP2040 могут быть переведены в режим загрузки.

## Настройка клиперов

Следующим шагом будет копирование [файла конфигурации принтера](#obtain-a-klipper-configuration-file) на хост.

Arguably the easiest way to set the Klipper configuration file is using the built-in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Другой вариант - использовать настольный редактор, поддерживающий редактирование файлов по протоколам "scp" и/или "sftp". Существуют свободно распространяемые инструменты, поддерживающие эту функцию (например, Notepad++, WinSCP и Cyberduck). Загрузите файл конфигурации принтера в редактор, а затем сохраните его в виде файла с именем "printer.cfg" в домашнем каталоге пользователя pi (например, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via SSH. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Обычно каждый принтер имеет свое собственное уникальное имя для микроконтроллера. После прошивки Klipper это имя может измениться, поэтому повторите эти шаги еще раз, даже если они уже были выполнены при прошивке. Выполнить:

```
ls /dev/serial/by-id/*
```

Должно отобразиться что-то вроде:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Затем обновите конфигурационный файл с уникальным именем. Например, обновите секцию `[mcu]`, чтобы она выглядела примерно так:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file, it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report that the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

При настройке файла конфигурации принтера нередко Klipper сообщает об ошибке конфигурации. При возникновении ошибки внесите необходимые исправления в файл конфигурации принтера и выполняйте команду "restart" до тех пор, пока "status" не сообщит о готовности принтера.

Klipper reports error messages via the command console and pop-ups in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located at `~/printer_data/logs/klippy.log`.

После того как Klipper сообщит, что принтер готов, перейдите к документу [Проверка конфигурации](Config_checks.md) для выполнения некоторых базовых проверок определений в файле конфигурации. Другую информацию см. в основной части [справочной документации](Overview.md).
