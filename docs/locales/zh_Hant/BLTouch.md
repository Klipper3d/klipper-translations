# BL-Touch

## 連線到 BL-Touch

**警告！**：在你開始前請避免用你的手指接觸 BL-Touch 的探針，因為它對手指的油脂相當敏感。如果你真的觸控需要觸碰它，請儘可能小心，以避免彎曲或推動任何東西。

根據 BL-Touch 文件或你使用的 MCU 的文件，將 BL-TOUCH 的 "servo"引腳連線到 `control_pin`。使用原裝連線線，三根線中的黃線是`control_pin`，兩根線中的白線是`sensor_pin`。你需要根據你的接線來配置這些引腳。大多數 BL-Touch 裝置要求在感測器引腳上有一個上拉電阻（引腳名稱前加"^"）。例如：

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

如果 BL-Touch 將用於 Z 軸歸位，則設定 `endstop_pin:probe:z_virtual_endstop` 並刪除 `[stepper_z]` 配置分段中的 `position_endstop`，然後新增一個 `[safe_z_home]` 配置分段來先提升 z 軸，並歸位 xy 軸，再移動到床的中心，並歸位 z 軸。例如：

```
[safe_z_home]
home_xy_position: 100, 100 # 修改該座標為列印床中心
speed: 50
z_hop: 10                 # 向上移動 10mm
z_hop_speed: 5
```

重要的是，safe_z_home 中的 z_hop 運動需要足夠高以保證即使探針恰好處於最低狀態，也不會發生碰撞。

## 初始測試

在繼續前，請檢查 BL-Touch 是否安裝在正確的高度，探針在收起時應該在噴頭上大約2mm的位置

啟動印表機時，BL-Touch 探針會執行自檢並上下移動探針幾次。自檢完成後，探針會處於收回狀態，探頭上的紅色 LED 在此時應亮起。如果有錯誤，例如探頭呈紅色閃爍或者探針伸出而不是收回，請關閉印表機並檢查接線和配置。

如果以上都沒有問題，就可以測試 control 引腳是否正常工作了。首先在印表機終端中執行 `BLTOUCH_DEBUG COMMAND=pin_down`。確認探針伸出並且探頭上的紅色 LED 熄滅。如果沒有，請再次檢查印表機的接線和配置。接下來在印表機終端輸入 `BLTOUCH_DEBUG COMMAND=pin_up`，確認探針向上移動了，並且紅燈再次亮起。如果它閃爍，則說明存在問題。

下一步是確認感測器的探針是否正常工作。執行`BLTOUCH_DEBUG COMMAND=pin_down`，檢查探針是否向下移動。執行`BLTOUCH_DEBUG COMMAND=touch_mode`，再執行`QUERY_PROBE`，並驗證命令報告"probe: open"。然後，在用指甲輕輕推起針頭的同時，再次執行`QUERY_PROBE`。驗證命令是否報告"probe: TRIGGERED"。如果任何一個查詢都沒有報告正確的資訊，那麼它通常表明接線或配置不正確（儘管一些[盜版裝置](#bl-touch-clones)需要特殊處理）。在這個測試完成後，執行`BLTOUCH_DEBUG COMMAND=pin_up`並檢查引腳是否向上移動。

在完成 BL-TOUCH contro 引腳和 sensor 引腳的測試后，現在是測試探針的時候了，但有一個技巧。不要讓探針接觸列印床，而是讓它接觸你手指甲。將列印頭移動到離床面較遠的位置，發送`G28`（如果不使用probe:z_virtual_endstop，發送`PROBE`），等待工具頭開始向下移動，然後用手指甲輕輕地觸控針腳來停止移動。你可能要做兩次，因為預設的歸位配置會探測兩次。如果你觸控探針時它沒有停止，請立即關閉印表機電源。

如果成功了，再做一次`G28`（或`PROBE`），但是這次讓它觸碰到熱床。

## BL-Touch 壞了

當 BL-Touch 在不一致狀態時，它就會開始閃爍紅色。可以通過以下命令強制它離開此狀態：

BLTOUCH_DEBUG COMMAND=reset

這種情況可能會在校準中被阻止伸出的探針中斷時出現。

但是，BL-TOUCH 也有可能無法再進行自我校準。這種情況會在它上面的螺絲處於錯誤的位置，或者探針內的磁芯移動之後出現。如果它移動了，以至於卡在了螺絲上，它可能無法再降低其探針。這種情況需要你打開螺絲並用圓珠筆將其輕輕推回原位。將探針重新插入BL-TOUCH，使其落入原來的位置。小心地將無頭螺釘重新調整到位。你需要找到正確的位置，使其能夠降低和提高探針，並且紅燈打開和關閉。使用`reset`、`pin_up`和`pin_down`命令來實現。

## BL-Touch 的克隆（3D-Touch）

Klipper 預設配置支援大多數盜版 BL-Touch。但是，某些盜版裝置可能不支援 `QUERY_PROBE` 命令，並且一些裝置可能需要配置 `pin_up_reports_not_triggered` 或 `pin_up_touch_mode_reports_triggered`。

注意！在沒有遵循這些指示之前，不要把 `pin_up_reports_not_triggered` 或 `pin_up_touch_mode_reports_triggered` 配置為 False。不要在正版 BL-Touch 上把這兩個參數配置為False。錯誤地將這些設定為 "False"會增加探測時間和損壞印表機的風險。

一些盜版裝置不支援`touch_mode`，因此`QUERY_PROBE`命令不能正常執行。儘管如此，仍然有可能用這些裝置進行探測和歸位。這些裝置如果在[初始測試](#initial-tests)期間的`QUERY_PROBE`命令不成功，但在隨後的`G28`（或`PROBE`）測試確實成功，則可以在 Klipper 中不使用`QUERY_PROBE`命令和不啟用`probe_with_touch_mode`功能時使用這些盜版裝置。

一些克隆裝置無法執行 Klipper 的內部感測器驗證測試。在這些裝置上，嘗試歸位或探測會導致 Klipper 報告 "BLTouch failed to verify sensor state" 錯誤。如果發生這種情況，那麼請手動執行這些步驟以確認 sensor 引腳正確，如[初次除錯](#initial-tests)所述。如果該測試中的`QUERY_PROBE`命令總是產生符合預期的結果，而 "BLTouch failed to verify sensor state "錯誤仍然發生，那麼可能需要在Klipper配置檔案中把`pin_up_touch_mode_reports_triggered`設為False。

少數老版本克隆裝置無法報告它們何時成功地抬升了它們的探針。在這些裝置上，Klipper 會在每次歸位或探測嘗試后報告一個 "BLTouch failed to raise probe "的錯誤。可以對這些裝置進行測試--將探針從列印床移開，執行`BLTOUCH_DEBUG COMMAND=pin_down`，確認探針已經向下移動，執行`QUERY_PROBE`，確認命令報告 "probe:open"，執行`BLTOUCH_DEBUG COMMAND=pin_up`，確認探針已經抬升，並執行`QUERY_PROBE`。如果探針保持抬升，裝置沒有進入錯誤狀態，且第一個查詢報告 "probe: open"，而第二個查詢報告 "probe:TRIGGERED"，那麼它表明`pin_up_reports_not_triggered`應該在Klipper配置檔案中被設定為False。

## BL-Touch v3

一些 BL-Touch v3.0 和BL-Touch 3.1 裝置可能需要在印表機配置檔案中配置`probe_with_touch_mode`。

如果BL-TOUCH v3.0的訊號線連線到一個限位引腳（有一個噪音過濾電容），那麼BL-TOUCH v3.0可能無法在歸位和探測期間持續發送訊號。如果[初次除錯](#initial-tests)中的`QUERY_PROBE`命令總是產生預期的結果，但在G28/PROBE命令期間，工具頭並不總是停止，那麼就表明有這個問題。一個變通的辦法是在在配置檔案中設定`probe_with_touch_mode:True`。

BL-TOUCH v3.1 可能會在嘗試探測成功后錯誤地進入錯誤狀態。其癥狀是 BL-TOUCH v3.1 在成功接觸列印床后，偶爾會有燈光閃爍，持續幾秒鐘。Klipper 應該會自動清除這個錯誤，一般來說是沒有問題的。當然你可以在配置檔案中設定`probe_with_touch_mode`來避免這個問題。

注意！當 `probe_with_touch_mode` 被設定為 True 時，一些 克隆裝置和BL-Touch v2.0（及更早）可能會降低精度。將此設定為 True 也會增加部署探針的時間。如果在 克隆 或更早的BL-Touch裝置上配置這個值，一定要在設定這個值之前和之後測試探針的準確性（使用`PROBE_ACCURACY`命令進行測試）。

## 無收起多次探測

預設情況下，Klipper 會在每次探測嘗試開始時部署探針，然後在之後收起探針。這種重複部署和收起探針的做法可能會增加涉及許多探針測量的校準序列的總耗時。Klipper 支援在連續的探測之間不收起探針，這可以減少探測的總耗時。可以通過在配置檔案中把 `stow_on_each_sample` 配置為 False 來啟用這個模式。

注意！將 `Stow_on_each_sample` 設定為 False 可能導致 Klipper 在探針放下時進行水平的列印頭運動。在將此值設定為 "False"之前，請確保所有探測操作都有足夠的Z間隙。如果沒有足夠的間隙，那麼水平移動可能會導致探針卡在障礙物上並且導致印表機損壞。

注意！當配置`stow_on_each_sample`為False時，建議將`probe_with_touch_mode`配置為 True。如果沒有設定`probe_with_touch_mode`，一些克隆的裝置可能檢測不到後續和列印床的接觸。在所有的裝置上，使用這兩個設定的組合可以簡化裝置的訊號傳遞，從而提高整體穩定性。

但是請注意，當`probe_with_touch_mode`設定為True時，一些克隆裝置和BL-Touch v2.0（以及更早）可能會降低精度。在這些裝置上，最好在設定`probe_with_touch_mode`之前和之後測試探針的準確性（使用`PROBE_ACCURACY`命令來測試）。

## 校準 BL-Touch 的偏移

按照[探針校準](Probe_Calibrate.md)指南中的指示來設定x_offset、y_offset和z_offset配置參數。

最好確認 Z 軸偏移量接近 1 mm。如果不是，那麼你可能希望將探頭向上或向下移動來解決這個問題。你需要讓它在噴嘴碰到床面之前可以很好的觸發，這樣可能出現的殘留耗材或扭曲的床面就不會影響任何探測動作。但與此同時，收回的位置最好儘可能高於噴嘴，以避免它接觸到列印件。如果對探針位置進行了調整，需要在調整後重新執行探針校準步驟。

## BL-Touch 輸出模式


   * BL-Touch V3.0支援設定 5V 或 OPEN-DRAIN 輸出模式，BL-TOUCH V3.1也支援，但它也可以在其內部 EEPROM 中儲存這個設定。如果你的控制主板需要 5V 模式的固定 5V 高邏輯電平，你可以把印表機配置檔案[bltouch]部分的 'set_output_mode' 參數設定為 "5V"。*** 只在你的控制主板的輸入線路可以容忍5V時使用 5V 模式。這就是為什麼這些 BL-Touch 版本的預設配置是OPEN-DRAIN模式。你有可能損壞你的控制主板上的MCU ***

   因此。如果一個控制主板需要 5V 模式，並且它的輸入訊號線是 5V 的，並且如果

   - 你有一個 BL-TOUCH Smart V3.0，你需要使用 'set_output_mode:5V' 參數，以確保每次啟動時的應用這一設定，因為探針不能記住所需的設定。
   - 如果你有一個 BL-Touch Smart V3.1，你可以選擇使用 'set_output_mode:5V " 或者通過手動使用 "BLTOUCH_STORE MODE=5V "命令，而不是使用參數 "set_output_mode: "來儲存模式。
   - 如果你有一些其他的探針。有些探針在電路板上有一個需要切除的線路或者需要設定的一個跳線，以便（永久）設定輸出模式。在這種情況下，完全省略 "set_output_mode "參數。
如果你有一個 V3.1，不要自動或重複儲存輸出模式，以避免磨損探針的 EEPROM。BLTouch 的 EEPROM可用於約100.000次更新。每天儲存100次，在磨損之前，加起來大約可以執行3年。因此，在 V3.1 中儲存輸出模式被供應商設計成一個複雜的操作（出廠預設值是一個 safe OPEN DRAIN 模式），不適合由任何切片軟體、宏或其他東西重複發出，最好僅在首次將探針新增到到印表機電子裝置時使用。
