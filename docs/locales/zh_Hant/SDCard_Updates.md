# 通過SD卡更新

當今許多流行的控制器板都帶有能夠通過 SD 卡更新韌體的引導載入程式。 雖然這在很多情況下都很方便，但這些引導載入程式通常不提供其他方式來更新韌體。 如果您的電路板安裝在很難插入SD卡的位置或者您需要經常更新韌體，這可能會很麻煩。 在 Klipper 最初刷入控制器后，可以將新韌體通過網路傳輸到 SD 卡並通過 ssh 啟動刷寫過程。

## 典型的升級程式

使用 SD 卡更新 MCU 韌體的過程與其他方法類似。 不需要使用`make flash`，而是需要執行一個輔助指令碼`flash-sdcard.sh`。 更新 BigTreeTech SKR 1.3 可能如下所示：

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

由使用者決定裝置位置和電路板名稱。 如果使用者需要重新整理多個板，在重新啟動 Klipper 服務之前，應該為每個板執行 `flash-sdcard.sh`（或`make flash`，如果合適）。

可以使用以下命令列出支援的微控制器板：

```
./scripts/flash-sdcard.sh -l
```

如果您沒有看到您的電路板列出，則可能需要新增一個新的電路板定義[如下所述](#board-definitions)。

## 高級用法

上述命令假設您的 MCU 以預設波特率 250000 連線並且韌體位於`~/klipper/out/klipper.bin`。 `flash-sdcard.sh` 指令碼提供了更改這些預設值的選項。 所有選項都可以通過幫助畫面檢視：

```
./scripts/flash-sdcard.sh -h
Klipper SD卡更新工具

使用方法：flash_sdcard.sh [-h] [-l] [-b <baud>] [-f <firmware>]
                       <device> <board>

位置參數：
  <device>        裝置串列埠
  <board>         主板型別

可選參數：
  -h              顯示這條資訊
  -l              列出可用主板
  -b <baud>       串列埠波特率（預設為250000）
  -f <firmware>   klipper.bin檔案路徑
```

如果您的電路板使用以自定義波特率連線的韌體重新整理，則可以通過指定 `-b` 選項進行升級：

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

如果您希望快閃記憶體位於預設位置以外的其他位置的 Klipper 構建，可以通過指定 `-f` 選項來完成：

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

請注意，升級 MKS Robin E3 時，無需手動執行 `update_mks_robin.py` 並將產生的二進制檔案提供給 `flash-sdcard.sh`。 此過程在上傳過程中自動執行。

## 注意事項

- 如介紹中所述，此方法僅適用於升級韌體。 初始刷鞋程式必須按照適用於您的控制器板的說明手動完成。
- 雖然可以重新整理更改序列波特率或連線介面（即：從 USB 到 UART）的構建，但驗證終將失敗，因為指令碼將無法重新連線到 MCU 以驗證目前版本。
- 僅支援使用 SPI 進行 SD 卡通訊的板。 使用 SDIO 的板，例如 Flymaker Flyboard 和 MKS Robin Nano V1/V2，將無法工作。

## 電路板定義

大多數常見的電路板都應該可用，但如有必要，可以新增新的電路板定義。 板定義位於`~/klipper/scripts/spi_flash/board_defs.py`。 定義儲存在字典中，例如：

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<更多定義>
}
```

可以指定以下欄位：

- `mcu`：微控制器型別。這可以在使用`make menuconfig`配置構建配置后通過執行`cat .config | grep CONFIG_MCU`獲取。 此欄位是必需的。
- `spi_bus`：連線到 SD 卡的 SPI 匯流排。 這應該從電路板的原理圖中檢索。 此欄位是必需的。
- `cs_pin`：連線到 SD 卡的晶片選擇引腳。 這應該從電路板原理圖中檢索。 此欄位是必需的。
- `firmware_path`：SD 卡上韌體應傳輸的路徑。 預設是`firmware.bin`。
- `current_firmware_path` 成功重新整理後重命名的韌體檔案所在的 SD 卡上的路徑。 預設是`firmware.cur`。

如果需要軟體 SPI，`spi_bus` 欄位應設定為 `swspi`，並應指定以下附加欄位：

- `spi_pins`：這應該是 3 個逗號分隔的引腳，以 `miso,mosi,sclk` 的格式連線到 SD 卡。

軟體 SPI 是必要的應該是非常罕見的，通常只有設計錯誤的板才會需要它。 `btt-skr-pro` 板定義提供了一個示例。

在建立新板定義之前，應檢查現有板定義是否滿足新板所需的標準。 如果是這種情況，可以指定`BOARD_ALIAS`。 例如，可以新增以下別名來指定「my-new-board」作為「generic-lpc1768」的別名：

```python
BOARD_ALIASES = {
    ...<原先的別名>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

如果您需要一個新的電路板定義並且您對上述過程感到不舒服，建議您在 [Klipper Community Discord](Contact.md#discord) 中請求一個。
