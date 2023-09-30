# Плата BeagleBone

В этом документе описывается процесс запуска Klipper на Beaglebone PRU.

## Сборка образа ОС

Начните с установки [Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images ) изображение. Изображение можно запустить либо с карты micro-SD, либо со встроенного eMMC. Если вы используете eMMC, установите его в eMMC сейчас, следуя инструкциям по приведенной выше ссылке.

Затем подключитесь по ssh к машине Beaglebone (`ssh debian@beaglebone` -- пароль `temppwd`) и установите Klipper, выполнив следующие команды:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-beaglebone.sh
```

## Установите Octoprint

Затем можно установить Octoprint:

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

И настройте OctoPrint на запуск при загрузке:

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

Необходимо изменить файл конфигурации **/etc/default/octoprint** OctoPrint. Необходимо изменить пользователя OCTOPRINT_USER на debian, NICELEVEL на 0, раскомментировать настройки BASEDIR, CONFIGFILE и DAEMON и изменить ссылки с /home/pi/ на `/home/debian/`:

```
sudo nano /etc/default/octoprint
```

Затем запустите сервис Octoprint:

```
sudo systemctl start octoprint
```

Убедитесь, что веб-сервер OctoPrint доступен — он должен находиться по адресу: <http://beaglebone:5000/>

## Создание кода микроконтроллера

Чтобы скомпилировать код микроконтроллера Klipper, начните с настройки его для «Beaglebone PRU»:

```
cd ~/klipper/
make menuconfig
```

Чтобы собрать и установить новый код микроконтроллера, запустите:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Также необходимо скомпилировать и установить код микроконтроллера для хост-процесса Linux. Настройте его второй раз для «процесса Linux»:

```
make menuconfig
```

Затем установите также этот код микроконтроллера:

```
sudo service klipper stop
make flash
sudo service klipper start
```

## Оставшаяся конфигурация

Завершите установку, настроив Klipper и Octoprint, следуя инструкциям в основном документе [Установка](Installation.md#configuring-klipper).

## Печать на Beaglebone

К сожалению, процессор Beaglebone иногда может с трудом справляться с работой OctoPrint. Известно, что при сложных отпечатках случаются остановки печати (принтер может двигаться быстрее, чем OctoPrint может отправлять команды движения). В этом случае рассмотрите возможность использования функции «virtual_sdcard» (подробности см. в [Справочнике по конфигурации](Config_Reference.md#virtual_sdcard)) для печати непосредственно из Klipper.
