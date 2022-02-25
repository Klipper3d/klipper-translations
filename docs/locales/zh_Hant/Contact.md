# 聯繫方式

本文件提供了關於 Klipper 的聯繫資訊。

1. [社區論壇](#community-forum)
1. [Discord 聊天](#discord-chat)
1. [我有一個關於 Klipper 的問題](#i-have-a-question-about-klipper)
1. [我有一個功能請求](#i-have-a-feature-request)
1. [我需要幫助！它炸了！](#help-it-doesnt-work)
1. [我在 Klipper 中發現了一個缺陷](#i-have-diagnosed-a-defect-in-the-klipper-software)
1. [我正在進行我想納入 Klipper 的修改](#i-am-making-changes-that-id-like-to-include-in-klipper)

## 社區論壇

有一個用來討論 Klipper 的 [Klipper 社區 Discourse 伺服器](https://community.klipper3d.org)。

## Discord 聊天

我們有一個用來討論Klipper的Discord伺服器，它的邀請鏈接是 <https://discord.klipper3d.org>。

這個伺服器是由 Klipper 愛好者社區執行，致力於討論 Klipper。它允許進行使用者間的實時聊天。

## 我有一個關於 Klipper 的問題

我們收到的許多問題在 [Klipper 文件](Overview.md)中已經有了答案。請務必閱讀該文件並遵循其中提供的指示。

也可以在[ Klipper 社區論壇](#community-forum)中搜索類似的問題。

如果你有興趣與其他 Klipper 使用者分享你的知識和經驗，那麼你可以加入[ Klipper 社區論壇](#community-forum)或[ Klipper Discord 聊天室](#discord-chat)。這兩個社區都是 Klipper 使用者間討論 Klipper 的地方。

我們經常收到許多並不針對 Klipper 的常規3D列印疑問。如果你有常規的疑問或遇到了常規的列印問題，那麼你可能會在一般的3D列印論壇或專門針對你的印表機硬體的論壇上得到更好的答案。

不要在 Klipper 的 Github 上建立議題來提問。

## 我有一個功能請求

所有的新功能都需要有感興趣並能夠實現這些功能的人。如果你想幫助實現或測試一個新功能，你可以在[ Klipper 社區論壇](#community-forum)中搜索正在進行的開發程序。還有[Klipper Discord 聊天室](#discord-chat)供合作者之間討論。

不要在 Klipper 的 Github 上建立議題來請求功能。

## 我需要幫助！它炸了！

不幸的是，我們收到的幫助請求往往比我們能夠回答的要多。我們發現大多數問題報告的根本原因都是：

1. 細微的硬體問題或
1. 未遵循 Klipper 文件中描述的所有步驟。

如果您遇到了問題，我們建議您仔細閱讀 [Klipper 文件](Overview.md) 並再次檢查是否遵循了所有步驟。

如果你遇到了列印問題，我們建議仔細檢查印表機的硬體（所有接頭、電線、螺絲等），確認沒有任何異常。我們發現大多數列印問題都與 Klipper 軟體無關。如果你確實發現了印表機硬體的問題，在一般的3D列印論壇或專門針對你的印表機硬體的論壇上搜索通常可以得到更好的答覆。

也可以在[ Klipper 社區論壇](#community-forum)中查詢類似的問題。

如果你有興趣與其他 Klipper 使用者分享你的知識和經驗，那麼你可以加入[ Klipper 社區論壇](#community-forum)或[ Klipper Discord 聊天室](#discord-chat)。這兩個社區都是 Klipper 使用者間討論 Klipper 的地方。

不要在 Klipper 的 Github 上建立議題來求助。

## 我在 Klipper 軟體中診斷出了一個缺陷

Klipper 是一個開源專案，我們誠摯的感謝貢獻者們在軟體中診斷出錯誤。

修復bug需要提供一些重要的資訊。請遵循以下步驟：

1. 首先要確定這個錯誤是在 Klipper 軟體中。如果你在想 "我有一個問題，我無法找出原因，因此這是一個Klipper的錯誤"，那麼**不要**建立一個 Github 議題。在這種情況下，有興趣且有能力的人需要先找到問題的根源。如果你想分享你的研究結果或檢查其他使用者是否遇到類似的問題，那麼你可以搜索 [Klipper 社區論壇](#community-forum)。
1. 請確保您正在執行 <https://github.com/Klipper3d/klipper > 的未修改程式碼。如果程式碼已被修改或從其他來源獲得，則您需要在報告問題之前先在 <https://github.com/Klipper3d/klipper > 獲取的未修改的程式碼上重現問題。
1. 如果可能的話，在不期望的事件發生后，立即在 OctoPrint 終端視窗執行一個`M112`命令。這將使 Klipper 進入 "關閉"(shutdown)狀態，並在日誌檔案中寫入額外的除錯資訊。
1. 獲取事件發送時的 Klipper 日誌檔案。該日誌檔案已被設計用來給 Klipper 開發人員提供關於軟體及其執行環境的常見問題（軟體版本、硬體型別、配置、事件時間和數百個其他問題）。
   1. Klipper 日誌檔案位於 Klipper "主機"（樹莓派）的`/tmp/klippy.log`檔案中。
   1. 你需要用「scp」或「sftp」程式將此日誌檔案複製到您的計算機。 「scp」程式是 Linux 和 MacOS 系統的標準配置。其他系統也通常有可用的 scp 實用程式（例如 WinSCP）。如果使用圖形界面的 scp 程式無法直接複製 `/tmp/klippy.log`，可以嘗試重複點選 `..`或者`parent folder`（父資料夾）直到進入根目錄，再點選`tmp`資料夾，然後選擇`klippy.log`檔案。
   1. 將日誌檔案複製到你的電腦，以便將其上傳到問題報告中。
   1. 不要以任何方式修改日誌檔案；不要只提供日誌的片段。只有完整的未修改的日誌檔案才能夠提供必要的資訊。
   1. 如果日誌檔案非常大（例如，大於2MB），那麼可能需要用 zip 或 gzip 來壓縮日誌。

   1. 在 <https://github.com/Klipper3d/klipper/issues>開一個新的GitHub議題，並對問題進行清晰的描述。Klipper 開發者需要了解你採取了哪些步驟，期望的結果是什麼，以及實際發生了什麼結果。Klipper 的日誌檔案**必須被新增到議題附件**：![議題附件](img/attach-issue.png)

## 我正在進行一些我想新增到 Klipper 中的改進

Klipper 是開源軟體，我們非常感謝新的貢獻。

新的貢獻（包括程式碼和文件）需要通過拉取請求(PR)提交。重要資訊請參見[貢獻文件](CONTRIBUTING.md)。

有幾個[開發人員文件](Overview.md#developer-documentation)。如果你對程式碼有疑問，那麼你也可以在[Klipper社區論壇](#community-forum)或[Klipper社區 Discord](#discord-chat)上提問。如果你想提供你目前的進展情況，那麼你可以在 Github 上開一個問題，寫上你的程式碼的位置，修改的概述，以及對其目前狀態的描述。
