# Установка

В этих инструкциях предполагается, что программное обеспечение будет работать на компьютере Raspberry Pi совместно с OctoPrint. В качестве хост-машины рекомендуется использовать компьютер Raspberry Pi 2, 3 или 4 (см. [Часто задаваемые вопросы](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) для других машин).

## Obtain a Klipper Configuration File

Most Klipper settings are determined by a "printer configuration file" that will be stored on the Raspberry Pi. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

If there isn't an appropriate printer configuration file in the Klipper config directory then try searching the printer manufacturer's website to see if they have an appropriate Klipper configuration file.

If no configuration file for the printer can be found, but the type of printer control board is known, then look for an appropriate [config file](../config/) starting with a "generic-" prefix. These example printer board files should allow one to successfully complete the initial installation, but will require some customization to obtain full printer functionality.

It is also possible to define a new printer configuration from scratch. However, this requires significant technical knowledge about the printer and its electronics. It is recommended that most users start with an appropriate configuration file. If creating a new custom printer configuration file, then start with the closest example [config file](../config/) and use the Klipper [config reference](Config_Reference.md) for further information.

## Подготовка образа операционной системы

Start by installing [OctoPi](https://github.com/guysoft/OctoPi) on the Raspberry Pi computer. Use OctoPi v0.17.0 or later - see the [OctoPi releases](https://github.com/guysoft/OctoPi/releases) for release information. One should verify that OctoPi boots and that the OctoPrint web server works. After connecting to the OctoPrint web page, follow the prompt to upgrade OctoPrint to v1.4.2 or later.

После установки OctoPi и обновления OctoPrint необходимо будет подключиться к целевому компьютеру по ssh для выполнения нескольких системных команд. Если используется рабочий стол Linux или macOS, то утилита "ssh", скорее всего, уже установлена. Существуют бесплатные ssh-клиенты, доступные для других настольных компьютеров (например, [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Используйте утилиту ssh для подключения к Raspberry Pi (ssh pi@octopi -- пароль "raspberry") и выполните следующие команды:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

Вышеописанное позволит загрузить Klipper, установить некоторые системные зависимости, настроить Klipper для запуска при запуске системы и запустить программное обеспечение Klipper host. Для этого потребуется подключение к Интернету, и его выполнение может занять несколько минут.

## Компиляция и прошивка микроконтроллера

Чтобы начать компиляцию кода прошивки, введите следующие команды на Raspberry Pi:

```
cd ~/klipper/
make menuconfig
```

The comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) should describe the settings that need to be set during "make menuconfig". Open the file in a web browser or text editor and look for these instructions near the top of the file. Once the appropriate "menuconfig" settings have been configured, press "Q" to exit, and then "Y" to save. Then run:

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Otherwise, the following steps are often used to "flash" the printer control board. First, it is necessary to determine the serial port connected to the micro-controller. Run the following:

```
ls /dev/serial/by-id/*
```

Должно отобразиться что-то вроде:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Зачастую у каждого принтера есть своё уникальное имя последовательного порта. По этому имени мы и будем производить прошивку. Вышеуказанная команда также может вывести и несколько строк вместо одной – в таком случае вам нужно выбрать строку, соответствующую микроконтроллеру, который вы хотите прошить (см [ЧАВО](FAQ.md#wheres-my-serial-port)).

Большинство контроллеров могут быть прошиты с помощью:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Не забудьте заменить значение FLASH_DEVICE на имя порта вашего принтера.

При первой прошивке убедитесь, что OctoPrint не подключен напрямую к принтеру (на странице OctoPrint в разделе "Соединение" нажмите "Отключиться").

## Конфигурация OctoPrint для работы с Klipper

Чтобы веб-сервер OctoPrint мог взаимодействовать с Klipper, его нужно соответствующим образом настроить. Войдите в OctoPrint через браузер и установите следующие настройки:

Перейдите на вкладку "Настройки" (иконка ключа вверху страницы). В разделе "Соединение", в "Дополнительные последовательные порты" добавьте "/tmp/printer". Затем нажмите "Сохранить".

Снова зайдите на вкладку "Настройки" и в разделе "Соединение" замените "Последовательный порт" на "/tmp/printer".

На вкладке "Настройки", перейдите на под-вкладку "Поведение" и выберите "Отменить все неоконченные печати, но не прерывать соединение". Нажмите "Сохранить".

From the main page, under the "Connection" section (at the top left of the page) make sure the "Serial Port" is set to "/tmp/printer" and click "Connect". (If "/tmp/printer" is not an available selection then try reloading the page.)

Once connected, navigate to the "Terminal" tab and type "status" (without the quotes) into the command entry box and click "Send". The terminal window will likely report there is an error opening the config file - that means OctoPrint is successfully communicating with Klipper. Proceed to the next section.

## Configuring Klipper

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the Raspberry Pi.

Arguably the easiest way to set the Klipper configuration file is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the Raspberry Pi via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

It's common for each printer to have its own unique name for the micro-controller. The name may change after flashing Klipper, so rerun these steps again even if they were already done when flashing. Run:

```
ls /dev/serial/by-id/*
```

Должно отобразиться что-то вроде:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Then update the config file with the unique name. For example, update the `[mcu]` section to look something similar to:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the OctoPrint web terminal to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

When customizing the printer config file, it is not uncommon for Klipper to report a configuration error. If an error occurs, make any necessary corrections to the printer config file and issue "restart" until "status" reports the printer is ready.

Klipper reports error messages via the OctoPrint terminal tab. The "status" command can be used to re-report error messages. The default Klipper startup script also places a log in **/tmp/klippy.log** which provides more detailed information.

After Klipper reports that the printer is ready, proceed to the [config check document](Config_checks.md) to perform some basic checks on the definitions in the config file. See the main [documentation reference](Overview.md) for other information.
