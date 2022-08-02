# 配置示例

本文件包含向 Klipper Github 倉庫（位於[config directory](../config/)）貢獻 Klipper 配置示例的指南。

請注意 [Klipper Community Discourse server](https://community.klipper3d.org) 也可以用來尋找和分享配置檔案。

## 準則

1. 選擇適當的配置文件名前綴：
   1. `printer`字首用於主流製造商出售的印表機。
   1. `generic`字首用於通用3D印表機主板。
   1. `kit`的字首用於按照公開規範組裝的3D印表機（例如Voron V2.4）。這些 "套件 "印表機通常與普通的印表機不同在它們通常不被製造商銷售。
   1. `sample`字首用於可以被複制到主配置檔案中的配置 "片段"。
   1. `example`字首是用來描述印表機運動學。這種型別的配置通常只與新型別的印表機運動學的程式碼一起新增。
1. 所有配置文件都必須以 `.cfg` 後綴結尾。 `printer` 配置文件必須以年份結尾，後跟 `.cfg`（例如，`-2019.cfg`）。在這種情況下，年份是給定打印機銷售的大致年份。
1. 不要在配置文件名中使用空格或特殊字符。文件名應僅包含字符`A-Z`、`a-z`、`0-9`、`-`和`.`。
1. `printer`, `generic`, 和 `kit` 示例配置檔案必須保證 Klipper 能夠正常啟動而不出錯。這些配置檔案應該被新增到 [test/klippy/printers.test](../test/klippy/printers.test) 迴歸測試用例中。將新的配置檔案新增到該測試用例的適當部分，並按該部分的字母順序排列。
1. 該配置示例應該是印表機的 "stock "配置。(在klipper的倉庫中有太多定製的配置。)同樣地，我們只為具有主流流行性的印表機、套件和板子新增配置檔案的例子（至少應該有100個正在使用中）。考慮使用[Klipper Community Discourse server](https://community.klipper3d.org)進行其他配置。
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. 不要在配置示例中指定`pressure_advance`，因為該值是針對耗材的，而不是印表機硬體。同樣，不要指定`max_extrude_only_velocity`或`max_extrude_only_accel`設定。
   1. 不要指定一個包含主機路徑或主機硬體的配置部分。例如，不要指定`[virtual_sdcard]`或`[temperature_host]`配置部分。
   1. 只為利用特定印表機功能，或特定印表機配置的切片軟體通常發出的G程式碼定義宏。
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. 不要將欄位文件複製到示例配置檔案中。（這樣做會造成維護方面的負擔，因為對文件的更新需要在很多地方進行修改。）
   1. 配置檔案的例子不應包含 "SAVE_CONFIG "部分。如果有必要，把SAVE_CONFIG部分的相關欄位複製到主配置區的適當部分。
   1. 使用`field: value`的語法，而不要使用`field=value`。
   1. 增加擠出機 `rotation_distance` 時，如果擠出機有傳動機構，最好指定 `gear_ratio`。我們希望示例配置中的 rotation_distance 與擠出機中滾齒的周長相關 - 它通常在 20 到 35mm 的範圍內。當指定 `gear_ratio` 時，最好指定機構上的實際齒輪（例如，更喜歡 `gear_ratio: 80:20` 而不是 `gear_ratio: 4:1`）。有關詳細信息，請參閱 [旋轉距離文檔]
   1. 避免定義那些被設定為預設值的欄位值。例如，不應該指定`min_extrude_temp: 170`，因為這已經是預設值。
   1. 在可能的情況下，行數不應超過80列。
   1. 避免在配置檔案中新增歸屬或修訂資訊。例如，避免新增類似 "此檔案由......建立 "的行。）將歸屬和修改歷史放在git提交資訊中。
1. 不要在示例配置文件中使用任何已棄用的功能。
1. 不要在示例配置檔案中禁用預設安全系統。例如，一個配置不應該指定一個自定義的 `max_extrude_cross_section`。不要啟用除錯功能。例如，不應該有一個 `force_move` 配置部分。
1. Klipper 支持的所有已知板都可以使用默認串行波特率 250000。不要在示例配置文件中推薦不同的波特率。

通過建立github "pull request "來提交配置檔案示例。也請遵循[contribution document](CONTRIBUTING.md)中的指示。
