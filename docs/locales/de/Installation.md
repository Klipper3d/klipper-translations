# Installation

These instructions assume the software will run on a Linux-based host running a Klipper-compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian-based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions, host relates to the Linux device and mcu relates to the printer board. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## Beziehen einer Klipper-Konfigurationsdatei

Most Klipper settings are determined by a "printer configuration file" printer.cfg, that will be stored on the host. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

Wenn es keine passende Druckerkonfigurationsdatei im Klipper-Konfigurationsverzeichnis gibt, versuchen Sie auf der Website des Druckerherstellers nach einer passenden Klipper-Konfigurationsdatei zu suchen.

Wenn keine Konfigurationsdatei für den Drucker gefunden werden kann, aber der Typ der Druckerplatine bekannt ist, dann suchen Sie nach einer entsprechenden [config-Datei](../config/), die mit einem "generic-"-Präfix beginnt. Mit diesen Beispieldateien für die Druckerkarte sollte die Erstinstallation erfolgreich abgeschlossen werden können, es sind jedoch einige Anpassungen erforderlich, um die volle Druckerfunktionalität zu erhalten.

Es ist auch möglich, eine neue Druckerkonfiguration von Grund auf zu definieren. Dies erfordert jedoch erhebliche technische Kenntnisse über den Drucker und seine Elektronik. Es wird empfohlen, dass die meisten Benutzer mit einer geeigneten Konfigurationsdatei beginnen. Wenn Sie eine neue benutzerdefinierte Druckerkonfigurationsdatei erstellen, beginnen Sie mit der nächstgelegenen Beispiel-[Konfigurationsdatei](../config/) und verwenden Sie die Klipper-[Konfigurationsreferenz](Config_Reference.md) für weitere Informationen.

## Interacting with Klipper

Klipper is a 3d printer firmware, so it needs some way for the user to interact with it.

Currently the best choices are front ends that retrieve information through the [Moonraker web API](https://moonraker.readthedocs.io/) and there is also the option to use [Octoprint](https://octoprint.org/) to control Klipper.

The choice is up to the user on what to use, but the underlying Klipper is the same in all cases. We encourage users to research the options available and make an informed decision.

## Obtaining an OS image for SBC's

There are many ways to obtain an OS image for Klipper for SBC use, most depend on what front end you wish to use. Some manufacturers of these SBC boards also provide their own Klipper-centric images.

The two main Moonraker-based front ends are [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/), the latter of which has a premade install image ["MainsailOS"](https://docs-os.mainsail.xyz/), this has the option for Raspberry Pi and some OrangePi variants.

Fluidd can be installed via KIAUH(Klipper Install And Update Helper), which is explained below and is a 3rd party installer for all things Klipper.

OctoPrint can be installed via the popular OctoPi image or via KIAUH, this process is explained in <OctoPrint.md>

## Installing via KIAUH

Normally you would start with a base image for your SBC, RPiOS Lite for example, or in the case of an x86 Linux device, Ubuntu Server. Please note that Desktop variants are not recommended due to certain helper programs that can stop some Klipper functions from working and even mask access to some printer boards.

KIAUH can be used to install Klipper and its associated programs on a variety of Linux-based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

## Kompilieren und Flashen des Mikrocontrollers

To compile the micro-controller code, start by running these commands on your host device:

```
cd ~/klipper/
make menuconfig
```

Die Kommentare am Anfang der [Druckerkonfigurationsdatei](#obtain-a-klipper-configuration-file) sollten die Einstellungen beschreiben, die während "make menuconfig" gesetzt werden müssen. Öffnen Sie die Datei in einem Webbrowser oder Texteditor und suchen Sie nach diesen Anweisungen am Anfang der Datei. Sobald Sie die entsprechenden "menuconfig"-Einstellungen vorgenommen haben, drücken Sie "Q" zum Beenden und dann "Y" zum Speichern. Führen Sie dann aus:

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board, then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Andernfalls werden die folgenden Schritte häufig zum "Flashen" der Druckersteuerplatine verwendet. Zunächst muss die an den Mikrocontroller angeschlossene serielle Schnittstelle ermittelt werden. Führen Sie die folgenden Schritte aus:

```
ls /dev/serial/by-id/*
```

Es sollte etwas ähnliches wie das Folgende gemeldet werden:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

It's common for each printer to have its own unique serial port name. This unique name will be used when flashing the micro-controller. It's possible there may be multiple lines in the above output - if so, choose the line corresponding to the micro-controller. If many items are listed and the choice is ambiguous, unplug the board and run the command again, the missing item will be your print board(see the [FAQ](FAQ.md#wheres-my-serial-port) for more information).

For common micro-controllers with STM32 or clone chips, LPC chips and others, it is usual that these need an initial Klipper flash via SD card.

When flashing with this method, it is important to make sure that the print board is not connected with USB to the host, due to some boards being able to feed power back to the board and stopping a flash from occurring.

Please note, that most print boards that use SD cards for flash will implement some kind of flash loop protection for when the sd card is left in place. There are two common methods:

Filename Change Required (usually "stock" print boards):

These boards require the firmware file to have a different name each time you flash (for example, firmware1.bin, firmware2.bin, etc.). If you reuse the same filename, the board may ignore it and not update.

Automatic File Renaming (usually aftermarket print boards:

Other boards allow using the same filename, commonly firmware.bin, but after flashing, the board renames the file to firmware.cur. This helps indicate the firmware was successfully flashed and prevents it from flashing again on the next startup.

Before flashing, make sure to check which behavior your board follows.

For common micro-controllers using Atmega chips, for example the 2560, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Stellen Sie sicher, dass Sie FLASH_DEVICE mit dem eindeutigen Namen des seriellen Anschlusses des Druckers aktualisieren.

For common micro-controllers using RP2040 chips, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

It is important to note that RP2040 chips may need to be put into Boot mode before this operation.

## Klipper einstellen

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the host.

Arguably the easiest way to set the Klipper configuration file is using the built-in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Another option is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via SSH. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Es ist üblich, dass jeder Drucker seinen eigenen, eindeutigen Namen für den Mikrocontroller hat. Der Name kann sich nach dem Flashen von Klipper ändern, also führen Sie diese Schritte erneut aus, auch wenn sie bereits beim Flashen durchgeführt wurden. Ausführen:

```
ls /dev/serial/by-id/*
```

Es sollte etwas ähnliches wie das Folgende gemeldet werden:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Dann aktualisieren Sie die Konfigurationsdatei mit dem eindeutigen Namen. Aktualisieren Sie zum Beispiel den Abschnitt `[mcu]` so, dass er in etwa so aussieht:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file, it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report that the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

Beim Anpassen der Druckerkonfigurationsdatei kommt es nicht selten vor, dass Klipper einen Konfigurationsfehler meldet. Wenn ein Fehler auftritt, nehmen Sie die erforderlichen Korrekturen an der Druckerkonfigurationsdatei vor und führen Sie einen Neustart durch, bis "Status" meldet, dass der Drucker bereit ist.

Klipper reports error messages via the command console and pop-ups in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located at `~/printer_data/logs/klippy.log`.

Nachdem Klipper meldet, dass der Drucker bereit ist, fahren Sie mit dem Dokument [config check document](Config_checks.md) fort, um einige grundlegende Prüfungen der Definitionen in der Konfigurationsdatei durchzuführen. Weitere Informationen finden Sie in der [Dokumentationsreferenz](Overview.md).
