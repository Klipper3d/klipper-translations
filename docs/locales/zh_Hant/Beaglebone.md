# Beaglebone

本文件描述了在 Beaglebone 可程式設計實時單元上執行 Klipper 的過程。

## 構建一個操作系統映象

首先安裝[Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images)映象。可以從micro-SD卡或內建的eMMC中執行該映象。如果使用eMMC，現在需要按照上述鏈接的說明將其安裝到eMMC。

然後 ssh 進入 Beaglebone 機器（`ssh debian@beaglebone` -- 密碼是 `temppwd`），通過執行以下命令安裝 Klipper：

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-beaglebone.sh
```

## 安裝 Octoprint

然後可以安裝 Octoprint：

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

和設定 Octoprint 開始啟動：

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

在配置 Klipper 之前，需要先修改OctoPrint的 **/etc/default/octoprint** 配置檔案。把 `OCTOPRINT_USER` 使用者改為 `debian`，把 `NICELEVEL` 改為 `0` ，取消註釋 `BASEDIR`、`CONFIGFILE` 和 `DAEMON` 的設定，並把引用從`/home/pi/`改為`/home/debian/`：

```
sudo nano /etc/default/octoprint
```

然後啟動 Octoprint 服務：

```
sudo systemctl start octoprint
```

需要確定可以訪問 OctoPrint 網路伺服器 - 它應該可以通過這個鏈接訪問：<http://beaglebone:5000/>

## 構建微控制器程式碼

要編譯的 Klipper 微控制器程式碼，需要先將編譯配置設為「Beaglebone PRU」：

```
cd ~/klipper/
make menuconfig
```

要構建和安裝新的微控制器程式碼，請執行：

```
sudo service klipper stop
make flash
sudo service klipper start
```

還需要編譯和安裝用於 Linux 主機程序的微控制器程式碼。再次修改編譯配置為"Linux process"：

```
make menuconfig
```

然後也安裝這個微控制器程式碼：

```
sudo service klipper stop
make flash
sudo service klipper start
```

## 剩餘的配置

根據[安裝文件](Installation.md#configuring-klipper)配置 Klipper 和 Octoprint 以完成安裝。

## 在 Beaglebone 上列印

不幸的是，Beaglebone 處理器有時不能流暢地執行 OctoPrint。在複雜的列印中會出現列印停滯（印表機的移動速度可能比 OctoPrint 發送的移動命令快）是一個已知問題。如果發生這種情況，可以嘗試使用 "virtual_sdcard" 功能（詳見[配置參考](Config_Reference.md#virtual_sdcard)），直接從 Klipper 列印。
