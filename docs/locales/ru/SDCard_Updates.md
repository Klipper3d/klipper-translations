# Обновления SDCard

Многие из популярных на сегодняшний день плат контроллеров поставляются с загрузчиком, способным обновлять встроенное ПО с помощью SD-карты. Хотя это удобно во многих случаях, эти загрузчики обычно не предоставляют другого способа обновления встроенного программного обеспечения. Это может быть неприятно, если ваша плата установлена в труднодоступном месте или если вам необходимо часто обновлять встроенное ПО. После первоначальной прошивки Klipper на контроллер можно перенести новую прошивку на SD-карту и инициировать процедуру прошивки через ssh.

## Типовая процедура обновления

Процедура обновления микропрограммного обеспечения MCU с помощью SD-карты аналогична другим методам. Вместо использования `make flash` необходимо запустить вспомогательный скрипт, `flash-sdcard.sh `. Обновление BigTreeTech SKR 1.3 может выглядеть следующим образом:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-skr-v1.3
sudo service klipper start
```

Пользователь сам определяет местоположение устройства и название платы. Если пользователю необходимо прошить несколько плат, `flash-sdcard.sh ` (или `make flash`, если это уместно) следует запустить для каждой платы перед перезапуском службы Klipper.

Список поддерживаемых плат можно получить с помощью следующей команды:

```
./scripts/flash-sdcard.sh -l
```

Если вы не видите свою плату в списке, возможно, необходимо добавить новое определение платы, как [описано ниже](#board-definitions).

## Продвинутое использование

В приведенных выше командах предполагается, что MCU подключается со скоростью 250000 бод по умолчанию, а прошивка находится по адресу `~/klipper/out/klipper.bin`. Сценарий `flash-sdcard.sh` предоставляет опции для изменения этих значений по умолчанию. Все опции можно просмотреть с помощью экрана справки:

```
./scripts/flash-sdcard.sh -ч
Утилита загрузки SD-карт для Klipper

использование: flash_sdcard.sh [-h] [-l] [-c] [-b <бод>] [-f <прошивка>]
                       <устройство> <плата>

позиционные аргументы:
  <устройство> последовательный порт устройства
  <плата> тип платы

необязательные аргументы:
  -h показать это сообщение
  -l список доступных плат
  -c запускать только проверку flash/верификацию (пропустить загрузку)
  -b <скорость передачи данных в бодах> последовательная скорость передачи данных в бодах (по умолчанию - 250000)
  -f <прошивка> путь к klipper.bin
```

Если на плате прошита микропрограмма, которая подключается с пользовательской скоростью передачи данных, то ее можно обновить, указав опцию `-b`:

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

Если вы хотите прошить сборку Klipper, расположенную не в том месте, где она находится по умолчанию, это можно сделать, указав опцию `-f`:

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

Обратите внимание, что при обновлении MKS Robin E3 нет необходимости вручную запускать файл `update_mks_robin.py` и передавать полученный двоичный файл в файл `flash-sdcard.sh`. Эта процедура автоматизирована в процессе загрузки.

Опция `-c` используется для выполнения операции проверки или только для проверки корректности работы платы с указанной микропрограммой. Эта опция предназначена, в первую очередь, для случаев, когда для завершения процедуры прошивки требуется ручное отключение питания, например, для загрузчиков, использующих для доступа к SD картам режим SDIO вместо SPI. (См. раздел "Оговорки" ниже), но ее также можно использовать в любое время для проверки соответствия прошитого в плату кода версии, находящейся в папке сборки, на любой поддерживаемой плате.

## Оговорки

- Как уже говорилось во введении, этот метод применим только для обновления микропрограммного обеспечения. Процедура начальной прошивки должна выполняться вручную в соответствии с инструкциями, применимыми к плате контроллера.
- Хотя можно прошить сборку, изменяющую последовательный бод или интерфейс подключения (например, с USB на UART), верификация всегда будет неудачной, поскольку скрипт не сможет повторно подключиться к MCU для проверки текущей версии.
- Поддерживаются только платы, использующие SPI для связи с SD-картой. Платы, использующие SDIO, такие как Flymaker Flyboard и MKS Robin Nano V1/V2, не будут работать в режиме SDIO. Однако, как правило, такие платы можно прошить, используя режим Software SPI. Но если загрузчик платы использует режим SDIO только для доступа к SD-карте, то для завершения перепрошивки потребуется переключить питание платы и SD-карты, чтобы переключить режим с SPI обратно на SDIO. Такие платы должны быть определены с включенной опцией `skip_verify`, чтобы пропустить этап проверки сразу после прошивки. Затем, после ручного отключения питания, можно повторно выполнить точно такую же команду `./scripts/flash-sdcard.sh`, но добавить опцию `-c` для завершения операции проверки/верификации. Примеры смотрите в разделе [Прошивка плат, использующих SDIO](#flashing-boards-that-use-sdio).

## Определения платы

Большинство распространенных плат должны быть доступны, однако при необходимости можно добавить новое определение платы. Определения плат находятся в файле `~/klipper/scripts/spi_flash/board_defs.py`. Определения хранятся в словаре, например:

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<дальнейшие определения>
}
```

Могут быть указаны следующие поля:

- `mcu`: Тип mcu. Его можно получить после конфигурирования сборки с помощью `make menuconfig`, выполнив команду `cat .config | grep CONFIG_MCU`. Это поле является обязательным.
- `spi_bus`: Шина SPI, подключенная к SD-карте. Этот параметр должен быть получен из схемы платы. Это поле обязательно для заполнения.
- `cs_pin`: Вывод Chip Select, подключенный к SD-карте. Этот вывод должен быть получен из схемы платы. Это поле обязательно для заполнения.
- `firmware_path`: Путь на SD-карте, куда должна быть перенесена прошивка. По умолчанию используется `firmware.bin`.
- `current_firmware_path`: Путь на SD-карте, где находится переименованный файл прошивки после успешной прошивки. По умолчанию это `firmware.cur`.
- `skip_verify`: Определяет булево значение, которое указывает скриптам на необходимость пропускать этап проверки прошивки в процессе прошивки. По умолчанию используется значение `False`. Это значение может быть установлено в `True` для плат, которым для завершения прошивки требуется ручное отключение питания. Для последующей проверки микропрограммы запустите скрипт еще раз с опцией `-c`, чтобы выполнить этап проверки. [См. рекомендации по работе с платами SDIO](#caveats)

Если требуется программный SPI, то поле `spi_bus` должно быть установлено в значение `swspi`, а также должно быть указано следующее дополнительное поле:

- `spi_pins`: Это должны быть 3 контакта, разделенные запятыми, которые подключены к SD-карте в формате `miso,mosi,sclk`.

Необходимость в программном SPI возникает крайне редко, как правило, только в платах с ошибками проектирования или в платах, которые обычно поддерживают только режим SDIO для SD-карты. Примером первых может служить определение платы `btt-skr-pro`, а примером вторых - определение платы `btt-octopus-f446-v1`.

Перед созданием нового определения платы необходимо проверить, соответствует ли существующее определение платы критериям, необходимым для новой платы. Если это так, то можно указать псевдоним `BOARD_ALIAS`. Например, чтобы указать `my-new-board` в качестве псевдонима для `generic-lpc1768`, можно добавить следующий псевдоним:

```python
BOARD_ALIASES = {
    ...<предыдущие псевдонимы>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Если вам необходимо новое определение платы и вас не устраивает описанная выше процедура, рекомендуется запросить его в [Klipper Community Discord](Contact.md#discord).

## Прошивка плат, использующих SDIO

[Как указано в разделе Caveats](#caveats), платы, загрузчик которых использует режим SDIO для доступа к SD-карте, требуют отключения питания платы и, в частности, самой SD-карты, для перехода из режима SPI, используемого при записи файла на SD-карту, обратно в режим SDIO, чтобы загрузчик смог прошить ее в плату. В этих определениях плат будет использоваться флаг `skip_verify`, который указывает программе прошивки остановиться после записи прошивки на SD-карту, чтобы можно было вручную перевести плату в режим питания и отложить этап проверки до его завершения.

Существует два сценария - один, когда RPi Host работает от отдельного блока питания, и другой, когда RPi Host работает от того же блока питания, что и основная плата, которую прошивают. Разница заключается в том, нужно ли после завершения прошивки выключать RPi и снова подключаться по `ssh`, чтобы выполнить этап проверки, или же проверку можно выполнить сразу. Вот примеры двух сценариев:

### Программирование SDIO с RPi на отдельном источнике питания

Типичный сеанс работы с RPi на отдельном источнике питания выглядит следующим образом. Разумеется, необходимо использовать правильный путь к устройству и имя платы:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
[[[вручную выключите питание платы принтера здесь, когда это будет указано]]
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

### Программирование SDIO при использовании RPi от одного источника питания

Типичный сеанс работы с RPi на одном и том же источнике питания выглядит следующим образом. Разумеется, необходимо использовать правильный путь к устройству и имя платы:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
sudo shutdown -h now
[[[дождитесь выключения RPi, затем выключите питание и снова зайдите в RPi по ssh, когда она перезагрузится]].
sudo service klipper stop
cd ~/klipper
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

В данном случае, поскольку происходит перезапуск хоста RPi, что приведет к перезапуску службы `klipper`, необходимо снова остановить `klipper` перед выполнением шага проверки и перезапустить ее после завершения проверки.

### Сопоставление выводов SDIO и SPI

Если в схеме платы используется SDIO для SD карты, то для определения совместимых SPI контактов программного обеспечения, которые необходимо назначить в файле `board_defs.py`, можно сопоставить контакты, как описано на схеме ниже:

| Контакт SD-карты | Штырь для карты Micro SD | Имя контакта SDIO | Имя вывода SPI |
| :-: | :-: | :-: | :-: |
| 9 | 1 | ДАТА2 | Нет (ПУ)* |
| 1 | 2 | CD/DATA3 | CS |
| 2 | 3 | CMD | MOSI |
| 4 | 4 | +3,3 В (VDD) | +3,3 В (VDD) |
| 5 | 5 | CLK | SCLK |
| 3 | 6 | GND (VSS) | GND (VSS) |
| 7 | 7 | ДАТА0 | MISO |
| 8 | 8 | ДАТА1 | Нет (ПУ)* |
| Н/Д | 9 | Обнаружение карты (CD) | Обнаружение карты (CD) |
| 6 | 10 | GND | GND |

\* None (PU) указывает на неиспользуемый вывод с подтягивающим резистором
