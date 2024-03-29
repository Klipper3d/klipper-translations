# Установка

В этих инструкциях предполагается, что программное обеспечение будет работать на компьютере Raspberry Pi совместно с OctoPrint. В качестве хост-машины рекомендуется использовать компьютер Raspberry Pi 2, 3 или 4 (см. [Часто задаваемые вопросы](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) для других машин).

## Получение файла конфигурации Klipper

Большинство настроек Klipper определяется "файлом конфигурации принтера", который будет храниться на Raspberry Pi. Соответствующий файл конфигурации часто можно найти, заглянув в каталог Klipper [config](../config/) в поисках файла, начинающегося с префикса "printer-", который соответствует целевому принтеру. Конфигурационный файл Klipper содержит техническую информацию о принтере, которая понадобится в процессе установки.

Если в каталоге Klipper config нет соответствующего файла конфигурации принтера, попробуйте поискать на сайте производителя принтера, чтобы узнать, есть ли у него соответствующий файл конфигурации Klipper.

Если конфигурационный файл для принтера не найден, но известен тип платы управления принтером, то ищите соответствующий [config-файл](../config/), начинающийся с префикса "generic-". Приведенные примеры файлов платы управления принтером должны позволить успешно завершить начальную установку, но для получения полной функциональности принтера потребуется некоторая доработка.

Можно также задать новую конфигурацию принтера с нуля. Однако это требует значительных технических знаний о принтере и его электронике. Большинству пользователей рекомендуется начинать работу с соответствующего файла конфигурации. При создании нового файла конфигурации принтера следует начать с ближайшего примера [config file](../config/), а для получения дополнительной информации использовать справочник Klipper [config reference](Config_Reference.md).

## Подготовка образа операционной системы

Начните с установки [OctoPi](https://github.com/guysoft/OctoPi) на компьютер Raspberry Pi. Используйте OctoPi версии 0.17.0 или более поздней - информацию о релизах см. в разделе [OctoPi releases](https://github.com/guysoft/OctoPi/releases). Необходимо убедиться, что OctoPi загружается и веб-сервер OctoPrint работает. После подключения к веб-странице OctoPrint выполните запрос на обновление OctoPrint до версии 1.4.2 или более поздней.

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

Комментарии в верхней части файла [printer configuration file](#obtain-a-klipper-configuration-file) должны описывать настройки, которые необходимо задать при выполнении команды "make menuconfig". Откройте файл в браузере или текстовом редакторе и найдите эти инструкции в верхней части файла. После того как соответствующие настройки "menuconfig" будут заданы, нажмите "Q" для выхода, а затем "Y" для сохранения. Затем запустите программу:

```
make
```

Если в комментариях в верхней части файла [printer configuration file](#obtain-a-klipper-configuration-file) описаны пользовательские шаги по "прошивке" конечного изображения на плату управления принтером, то выполните эти шаги, а затем перейдите к [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

В противном случае для "прошивки" платы управления принтером часто используются следующие действия. Во-первых, необходимо определить последовательный порт, подключенный к микроконтроллеру. Для этого выполните следующее:

```
ls /dev/serial/by-id/*
```

Должно отобразиться что-то вроде:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Обычно каждый принтер имеет свое уникальное имя последовательного порта. Это уникальное имя будет использоваться при прошивке микроконтроллера. Возможно, в приведенном выше выводе будет несколько строк - в этом случае выберите строку, соответствующую микроконтроллеру (более подробную информацию см. в разделе [FAQ](FAQ.md#wheres-my-serial-port)).

Большинство контроллеров могут быть прошиты с помощью:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Не забудьте заменить значение FLASH_DEVICE на имя порта вашего принтера.

При первой прошивке убедитесь, что OctoPrint не подключен напрямую к принтеру (на веб-странице OctoPrint в разделе "Подключение" нажмите кнопку "Отключить").

## Конфигурация OctoPrint для работы с Klipper

Для связи с хост-программой Klipper необходимо настроить веб-сервер OctoPrint. Используя веб-браузер, войдите на веб-страницу OctoPrint, а затем настройте следующие элементы:

Перейдите на вкладку "Настройки" (значок гаечного ключа в верхней части страницы). В разделе "Последовательное соединение" в пункте "Дополнительные последовательные порты" добавьте "/tmp/printer". Затем нажмите кнопку "Сохранить".

Снова войдите на вкладку "Настройки" и в разделе "Последовательное соединение" измените значение параметра "Последовательный порт" на "/tmp/printer".

На вкладке "Настройки" перейдите на подвкладку "Поведение" и выберите опцию "Отменить все текущие отпечатки, но оставаться подключенным к принтеру". Нажмите кнопку "Сохранить".

На главной странице в разделе "Подключение" (в левой верхней части страницы) убедитесь, что для параметра "Последовательный порт" выбрано значение "/tmp/printer", и нажмите кнопку "Подключить". (Если "/tmp/printer" недоступен, попробуйте перезагрузить страницу.)

После подключения перейдите на вкладку "Терминал", введите в поле ввода команды "status" (без кавычек) и нажмите кнопку "Отправить". Скорее всего, в окне терминала появится сообщение об ошибке открытия файла конфигурации - это означает, что OctoPrint успешно взаимодействует с Klipper. Перейдите к следующему разделу.

## Настройка клиперов

На следующем этапе необходимо скопировать [файл конфигурации принтера](#obtain-a-klipper-configuration-file) на Raspberry Pi.

Пожалуй, самым простым способом настройки конфигурационного файла Klipper является использование настольного редактора, поддерживающего редактирование файлов по протоколам "scp" и/или "sftp". Существуют свободно распространяемые инструменты, поддерживающие эту функцию (например, Notepad++, WinSCP и Cyberduck). Загрузите файл конфигурации принтера в редактор и сохраните его в виде файла с именем "printer.cfg" в домашнем каталоге пользователя pi (т.е. /home/pi/printer.cfg).

В качестве альтернативы можно скопировать и отредактировать файл непосредственно на Raspberry Pi через ssh. Это может выглядеть следующим образом (не забудьте обновить команду, чтобы использовать соответствующее имя файла конфигурации принтера):

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

После создания и редактирования файла необходимо выполнить команду "restart" в веб-терминале OctoPrint для загрузки конфигурации. Команда "status" сообщит о готовности принтера, если файл конфигурации Klipper успешно прочитан, а микроконтроллер успешно найден и настроен.

При настройке файла конфигурации принтера нередко Klipper сообщает об ошибке конфигурации. При возникновении ошибки внесите необходимые исправления в файл конфигурации принтера и выполняйте команду "restart" до тех пор, пока "status" не сообщит о готовности принтера.

Klipper сообщает о сообщениях об ошибках на вкладке терминала OctoPrint. Для повторного вывода сообщений об ошибках можно использовать команду "status". Сценарий запуска Klipper по умолчанию также помещает журнал в **/tmp/klippy.log**, в котором содержится более подробная информация.

После того как Klipper сообщит, что принтер готов, перейдите к документу [Проверка конфигурации](Config_checks.md) для выполнения некоторых базовых проверок определений в файле конфигурации. Другую информацию см. в основной части [справочной документации](Overview.md).
