# 安裝

These instructions assume the software will run on a Linux-based host running a Klipper-compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian-based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions, host relates to the Linux device and mcu relates to the printer board. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## 獲取 Klipper 配置文件

Most Klipper settings are determined by a "printer configuration file" printer.cfg, that will be stored on the host. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

如果 Klipper 配置目錄中沒有合適的打印機配置文件，請嘗試搜索打印機製造商的網站，看看他們是否有合適的 Klipper 配置文件。

如果找不到打印機的配置文件，但打印機控制板的類型已知，則查找以“generic-”前綴開頭的合適的 [config file](../config/)。這些示例打印機板文件應該允許您成功完成初始安裝，但需要進行一些自定義才能獲得完整的打印機功能。

也可以從頭開始定義新的打印機配置。但是，這需要有關打印機及其電子設備的大量技術知識。建議大多數用戶從適當的配置文件開始。如果創建新的自定義打印機配置文件，請從最接近的示例 [config file](../config/) 開始，並使用 Klipper [config reference](Config_Reference.md) 獲取更多信息。

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

## 構建和刷寫微控制器

To compile the micro-controller code, start by running these commands on your host device:

```
cd ~/klipper/
make menuconfig
```

[打印機配置文件](#obtain-a-klipper-configuration-file) 頂部的註釋應描述“make menuconfig”期間需要設置的設置。在網絡瀏覽器或文本編輯器中打開文件，然後在文件頂部附近查找這些說明。一旦配置了適當的“menuconfig”設置，按“Q”退出，然後按“Y”保存。然後運行：

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board, then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

否則，通常使用以下步驟來“刷新”打印機控制板。首先，需要確定連接到微控制器的串口。運行以下命令：

```
ls /dev/serial/by-id/*
```

它應該報告類似以下的內容：

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

請務必用印表機的唯一串列埠名稱來更新 FLASH_DEVICE 參數。

For common micro-controllers using RP2040 chips, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

It is important to note that RP2040 chips may need to be put into Boot mode before this operation.

## 配置 Klipper

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the host.

Arguably the easiest way to set the Klipper configuration file is using the built-in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Another option is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via SSH. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

每台打印機都有自己獨特的微控制器名稱是很常見的。刷新 Klipper 後名稱可能會更改，因此即使在刷新時已經完成這些步驟，也要重新運行這些步驟。執行：

```
ls /dev/serial/by-id/*
```

它應該報告類似以下的內容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

然後使用唯一名稱更新配置文件。例如，更新 `[mcu]` 部分，使其看起來類似於：

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file, it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report that the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

在自定義打印機配置文件時，Klipper 報告配置錯誤的情況並不少見。如果發生錯誤，請對打印機配置文件進行任何必要的更正並發出“restart”，直到“status”報告打印機已準備好。

Klipper reports error messages via the command console and pop-ups in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located at `~/printer_data/logs/klippy.log`.

在 Klipper 報告打印機準備就緒後，進入 [配置檢查文檔](Config_checks.md) 對配置文件中的定義進行一些基本檢查。有關其他信息，請參閱主要 [文檔參考](Overview.md)。
