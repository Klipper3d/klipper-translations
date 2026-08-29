# SD-Karten Aktualisierung

Viele der heute gängigen Controller-Karten werden mit einem Bootloader ausgeliefert, der die Aktualisierung der Firmware über eine SD-Karte ermöglicht. Obwohl dies in vielen Fällen praktisch ist, bieten diese Bootloader in der Regel keine andere Möglichkeit zur Aktualisierung der Firmware. Dies kann lästig sein, wenn Ihr Board an einem schwer zugänglichen Ort montiert ist oder wenn Sie die Firmware häufig aktualisieren müssen. Nachdem Klipper auf einen Controller geflasht wurde, ist es möglich, die neue Firmware auf die SD-Karte zu übertragen und den Flashapparat über ssh zu starten.

## Typische Upgrade-Prozedur

Das Verfahren zur Aktualisierung der MCU-Firmware über die SD-Karte ist ähnlich wie bei anderen Methoden. Anstatt `make flash` zu verwenden, muss ein Hilfsskript, `flash-sdcard.sh`, ausgeführt werden. Die Aktualisierung eines BigTreeTech SKR 1.3 könnte wie folgt aussehen:

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

Es liegt beim Benutzer, den Geräteort und den Platinennamen zu bestimmen. Wenn Sie mehrere Platinen flashen müssen, sollte `flash-sdcard.sh` (oder gegebenenfalls `make flash`) für jede Platine ausgeführt werden, bevor der Klipper-Dienst neu gestartet wird.

Unterstützte Platinen können mit dem folgenden Befehl aufgelistet werden:

```
./scripts/flash-sdcard.sh -l
```

Wenn Ihre Platine nicht aufgeführt ist, kann es notwendig sein, eine neue Platinendefinition hinzuzufügen, wie [nachfolgend beschrieben](#board-definitions).

## Erweiterte Nutzung

Die obigen Befehle setzen voraus, dass Ihr MCU sich mit der Standard-Baudrate von 250000 verbindet und sich die Firmware unter `~/klipper/out/klipper.bin` befindet. Das Skript `flash-sdcard.sh` bietet Optionen, um diese Standardwerte zu ändern. Alle Optionen können über die Hilfeanzeige eingesehen werden:

```
./scripts/flash-sdcard.sh -h
SD Card upload utility for Klipper

usage: flash_sdcard.sh [-h] [-l] [-c] [-s] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -c              run flash check/verify only (skip upload)
  -s              use fast SPI speed (4MHz)
  -b <baud>       serial baud rate (default is 250000)
  -f <firmware>   path to klipper.bin
```

Wenn Ihre Platine mit einer Firmware geflasht ist, die sich mit einer benutzerdefinierten Baudrate verbindet, ist ein Upgrade durch Angabe der Option `-b` möglich:

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

Wenn Sie einen Klipper-Build flashen möchten, der sich nicht am Standardort befindet, ist dies durch Angabe der Option `-f` möglich:

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

Beachten Sie, dass beim Upgrade eines MKS Robin E3 kein manueller Aufruf von `update_mks_robin.py` und keine Übergabe der resultierenden Binärdatei an `flash-sdcard.sh` nötig ist. Dieser Vorgang wird während des Uploads automatisiert.

Die Option `-c` dient dazu, eine reine Prüf- bzw. Verifizierungsoperation durchzuführen, um zu testen, ob die Platine die angegebene Firmware korrekt ausführt. Diese Option ist in erster Linie für Fälle gedacht, in denen ein manuelles Aus- und Einschalten erforderlich ist, um den Flash-Vorgang abzuschließen, etwa bei Bootloadern, die für den Zugriff auf ihre SD-Karten den SDIO-Modus statt SPI verwenden. (Siehe die Einschränkungen weiter unten.) Sie kann jedoch auch jederzeit verwendet werden, um auf jeder unterstützten Platine zu überprüfen, ob der auf die Platine geflashte Code mit der Version in Ihrem Build-Verzeichnis übereinstimmt.

## Initialisierung fehlgeschlagen

Manche SD-Karten lassen sich bei der Standard-SPI-Geschwindigkeit von 400 kHz nicht initialisieren. In diesem Fall kann `-s` verwendet werden, um die SPI-Peripherie mit 4 MHz anzusteuern. Zum Beispiel:

```
./scripts/flash-sdcard.sh -s /dev/ttyACM0 btt-skr-v1.3
```

Lässt sich das Gerät weiterhin nicht initialisieren, hängt die Ursache nicht mit der Geschwindigkeit zusammen und ist wahrscheinlich auf eine der folgenden Bedingungen zurückzuführen:

- Die SD-Karte ist nicht korrekt formatiert. Sie muss `fat` oder `fat32` sein.
- Es wird versucht, eine Karte über die SPI-Schnittstelle zu initialisieren, die bereits über SDIO initialisiert wurde.
- Die SD-Karte ist defekt oder beschädigt.

## Einschränkungen

- Wie in der Einleitung erwähnt, funktioniert diese Methode nur zum Aktualisieren der Firmware. Der anfängliche Flash-Vorgang muss manuell gemäß der für Ihre Steuerplatine geltenden Anleitung durchgeführt werden.
- Es ist zwar möglich, einen Build zu flashen, der die serielle Baudrate oder die Verbindungsschnittstelle ändert (z. B. von USB auf UART), die Überprüfung wird jedoch immer fehlschlagen, da das Skript sich nicht erneut mit dem Mikrocontroller verbinden kann, um die aktuelle Version zu verifizieren.
- Es werden nur Platinen unterstützt, die SPI für die Kommunikation mit der SD-Karte verwenden. Platinen, die SDIO verwenden, wie das Flymaker Flyboard und MKS Robin Nano V1/V2, funktionieren im SDIO-Modus nicht. Meist ist es jedoch möglich, solche Platinen stattdessen im Software-SPI-Modus zu flashen. Wenn der Bootloader der Platine für den Zugriff auf die SD-Karte allerdings ausschließlich den SDIO-Modus verwendet, ist ein Aus- und Einschalten von Platine und SD-Karte notwendig, damit der Modus von SPI zurück auf SDIO wechseln kann, um das erneute Flashen abzuschließen. Solche Platinen sollten mit aktiviertem `skip_verify` definiert werden, um den Verifizierungsschritt unmittelbar nach dem Flashen zu überspringen. Nach dem manuellen Aus- und Einschalten können Sie dann genau denselben Befehl `./scripts/flash-sdcard.sh` erneut ausführen, dabei jedoch die Option `-c` ergänzen, um die Prüf- bzw. Verifizierungsoperation abzuschließen. Beispiele finden Sie unter [Flashen von Platinen, die SDIO verwenden](#flashing-boards-that-use-sdio).

## Platinendefinitionen

Die gängigsten Platinen sollten verfügbar sein, bei Bedarf kann jedoch eine neue Platinendefinition hinzugefügt werden. Platinendefinitionen befinden sich in `~/klipper/scripts/spi_flash/board_defs.py`. Die Definitionen werden in einem Wörterbuch gespeichert, zum Beispiel:

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<further definitions>
}
```

Folgende Felder können angegeben werden:

- `mcu`: Der MCU-Typ. Dieser lässt sich nach der Konfiguration des Builds über `make menuconfig` mit dem Befehl `cat .config | grep CONFIG_MCU` ermitteln. Dieses Feld ist erforderlich.
- `spi_bus`: Der mit der SD-Karte verbundene SPI-Bus. Dieser sollte dem Schaltplan der Platine entnommen werden. Dieses Feld ist erforderlich.
- `cs_pin`: Der mit der SD-Karte verbundene Chip-Select-Pin. Dieser sollte dem Schaltplan der Platine entnommen werden. Dieses Feld ist erforderlich.
- `firmware_path`: Der Pfad auf der SD-Karte, an den die Firmware übertragen werden soll. Der Standardwert ist `firmware.bin`.
- `current_firmware_path`: Der Pfad auf der SD-Karte, an dem sich die umbenannte Firmware-Datei nach einem erfolgreichen Flash-Vorgang befindet. Der Standardwert ist `firmware.cur`.
- `skip_verify`: Dies definiert einen booleschen Wert, der den Skripten mitteilt, den Firmware-Verifizierungsschritt während des Flash-Vorgangs zu überspringen. Der Standardwert ist `False`. Er kann für Platinen auf `True` gesetzt werden, die zum Abschluss des Flash-Vorgangs ein manuelles Aus- und Einschalten erfordern. Um die Firmware anschließend zu verifizieren, führen Sie das Skript erneut mit der Option `-c` aus, um den Verifizierungsschritt durchzuführen. [Siehe die Einschränkungen bei SDIO-Karten](#caveats)

Wenn Software-SPI erforderlich ist, sollte das Feld `spi_bus` auf `swspi` gesetzt und das folgende zusätzliche Feld angegeben werden:

- `spi_pins`: Hier sollten 3 durch Komma getrennte Pins angegeben werden, die mit der SD-Karte verbunden sind, im Format `miso,mosi,sclk`.

Es dürfte äußerst selten vorkommen, dass Software-SPI notwendig ist; typischerweise benötigen dies nur Platinen mit Designfehlern oder Platinen, die für ihre SD-Karte normalerweise nur den SDIO-Modus unterstützen. Die Platinendefinition `btt-skr-pro` ist ein Beispiel für Ersteres, die Platinendefinition `btt-octopus-f446-v1` ein Beispiel für Letzteres.

Bevor Sie eine neue Platinendefinition erstellen, sollten Sie prüfen, ob eine vorhandene Platinendefinition die für die neue Platine notwendigen Kriterien erfüllt. Ist dies der Fall, kann ein `BOARD_ALIAS` angegeben werden. Zum Beispiel kann der folgende Alias hinzugefügt werden, um `my-new-board` als Alias für `generic-lpc1768` festzulegen:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Benötigen Sie eine neue Platinendefinition und fühlen sich mit dem oben beschriebenen Vorgehen nicht wohl, wird empfohlen, diese im [Klipper-Discord](Contact.md) anzufragen.

## Flashen von Boards, die SDIO verwenden

[Wie unter den Einschränkungen erwähnt](#caveats), erfordern Platinen, deren Bootloader für den Zugriff auf die SD-Karte den SDIO-Modus verwendet, ein Aus- und Einschalten der Platine und insbesondere der SD-Karte selbst, um vom SPI-Modus, der beim Schreiben der Datei auf die SD-Karte verwendet wird, zurück in den SDIO-Modus zu wechseln, damit der Bootloader sie auf die Platine flashen kann. Diese Platinendefinitionen verwenden das Flag `skip_verify`, das dem Flash-Werkzeug mitteilt, nach dem Schreiben der Firmware auf die SD-Karte anzuhalten, damit die Platine manuell aus- und eingeschaltet werden kann und der Verifizierungsschritt bis zu dessen Abschluss aufgeschoben wird.

Es gibt zwei Szenarien - eines, bei dem der RPi-Host über eine separate Stromversorgung läuft, und eines, bei dem der RPi-Host über dieselbe Stromversorgung wie das geflashte Hauptboard läuft. Der Unterschied besteht darin, ob es notwendig ist, den RPi ebenfalls herunterzufahren und nach Abschluss des Flashens erneut per `ssh` zu verbinden, um den Verifizierungsschritt durchzuführen, oder ob die Verifizierung sofort erfolgen kann. Hier Beispiele für beide Szenarien:

### SDIO Programmierung mit RPi auf separatem Netzteil

Eine typische Sitzung mit dem RPi an einer separaten Stromversorgung sieht etwa wie folgt aus. Sie müssen dabei natürlich Ihren tatsächlichen Gerätepfad und Platinennamen verwenden:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
[[[manually power-cycle the printer board here when instructed]]]
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

### SDIO-Programmierung mit RPi an derselben Stromversorgung

Eine typische Sitzung mit dem RPi an derselben Stromversorgung sieht etwa wie folgt aus. Sie müssen dabei natürlich Ihren tatsächlichen Gerätepfad und Platinennamen verwenden:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
sudo shutdown -h now
[[[wait for the RPi to shutdown, then power-cycle and ssh again to the RPi when it restarts]]]
sudo service klipper stop
cd ~/klipper
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

In diesem Fall, da der RPi-Host neu gestartet wird, wodurch auch der `klipper`-Dienst neu gestartet wird, ist es notwendig, `klipper` vor dem Verifizierungsschritt erneut zu stoppen und nach Abschluss der Verifizierung wieder zu starten.

### SDIO zu SPI Pin Belegung

Verwendet der Schaltplan Ihrer Platine SDIO für die SD-Karte, können Sie die Pins gemäß der folgenden Tabelle zuordnen, um die kompatiblen Software-SPI-Pins zu bestimmen, die in der Datei `board_defs.py` festgelegt werden:

| SD Karten Pin | Mikro SD Karten Pin | SDIO Pin Name | SPI Pin Name |
| :-: | :-: | :-: | :-: |
| 9 | 1 | DATA2 | None (PU)* |
| 1 | 2 | CD/DATA3 | CS |
| 2 | 3 | CMD | MOSI |
| 4 | 4 | +3.3V (VDD) | +3.3V (VDD) |
| 5 | 5 | CLK | SCLK |
| 3 | 6 | GND (VSS) | GND (VSS) |
| 7 | 7 | DATA0 | MISO |
| 8 | 8 | DATA1 | None (PU)* |
| N/A | 9 | Kartenerkennung (CD) | Kartenerkennung (CD) |
| 6 | 10 | GND | GND |

\* None (PU) kennzeichnet einen unbenutzten Pin mit Pull-up-Widerstand
