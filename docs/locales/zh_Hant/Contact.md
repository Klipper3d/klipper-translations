# 聯繫方式

本文件提供了關於 Klipper 的聯繫資訊。

1. [社區論壇](#community-forum)
1. [Discord 聊天](#discord-chat)
1. [我有一個關於 Klipper 的問題](#i-have-a-question-about-klipper)
1. [我有一個功能請求](#i-have-a-feature-request)
1. [我需要幫助！它炸了！](#help-it-doesnt-work)
1. [I found a bug in the Klipper software](#i-found-a-bug-in-the-klipper-software)
1. [我正在進行我想納入 Klipper 的修改](#i-am-making-changes-that-id-like-to-include-in-klipper)
1. [Klipper github](#klipper-github)

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

## 我有一個功能請求

所有的新功能都需要有感興趣並能夠實現這些功能的人。如果你想幫助實現或測試一個新功能，你可以在[ Klipper 社區論壇](#community-forum)中搜索正在進行的開發程序。還有[Klipper Discord 聊天室](#discord-chat)供合作者之間討論。

## 我需要幫助！它炸了！

不幸的是，我們收到的幫助請求往往比我們能夠回答的要多。我們發現大多數問題報告的根本原因都是：

1. 細微的硬體問題或
1. 未遵循 Klipper 文件中描述的所有步驟。

如果您遇到了問題，我們建議您仔細閱讀 [Klipper 文件](Overview.md) 並再次檢查是否遵循了所有步驟。

如果你遇到了列印問題，我們建議仔細檢查印表機的硬體（所有接頭、電線、螺絲等），確認沒有任何異常。我們發現大多數列印問題都與 Klipper 軟體無關。如果你確實發現了印表機硬體的問題，在一般的3D列印論壇或專門針對你的印表機硬體的論壇上搜索通常可以得到更好的答覆。

也可以在[ Klipper 社區論壇](#community-forum)中查詢類似的問題。

如果你有興趣與其他 Klipper 使用者分享你的知識和經驗，那麼你可以加入[ Klipper 社區論壇](#community-forum)或[ Klipper Discord 聊天室](#discord-chat)。這兩個社區都是 Klipper 使用者間討論 Klipper 的地方。

## I found a bug in the Klipper software

Klipper 是一個開源專案，我們誠摯的感謝貢獻者們在軟體中診斷出錯誤。

Problems should be reported in the [Klipper Community Forum](#community-forum).

修復bug需要提供一些重要的資訊。請遵循以下步驟：

1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you should reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting.
1. If possible, run an `M112` command immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. 獲取事件發送時的 Klipper 日誌檔案。該日誌檔案已被設計用來給 Klipper 開發人員提供關於軟體及其執行環境的常見問題（軟體版本、硬體型別、配置、事件時間和數百個其他問題）。
   1. Klipper 日誌檔案位於 Klipper "主機"（樹莓派）的`/tmp/klippy.log`檔案中。
   1. 你需要用「scp」或「sftp」程式將此日誌檔案複製到您的計算機。 「scp」程式是 Linux 和 MacOS 系統的標準配置。其他系統也通常有可用的 scp 實用程式（例如 WinSCP）。如果使用圖形界面的 scp 程式無法直接複製 `/tmp/klippy.log`，可以嘗試重複點選 `..`或者`parent folder`（父資料夾）直到進入根目錄，再點選`tmp`資料夾，然後選擇`klippy.log`檔案。
   1. 將日誌檔案複製到你的電腦，以便將其上傳到問題報告中。
   1. 不要以任何方式修改日誌檔案；不要只提供日誌的片段。只有完整的未修改的日誌檔案才能夠提供必要的資訊。
   1. It is a good idea to compress the log file with zip or gzip.
1. Open a new topic on the [Klipper Community Forum](#community-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## 我正在進行一些我想新增到 Klipper 中的改進

Klipper 是開源軟體，我們非常感謝新的貢獻。

新的貢獻（包括程式碼和文件）需要通過拉取請求(PR)提交。重要資訊請參見[貢獻文件](CONTRIBUTING.md)。

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Community Forum](#community-forum) or on the [Klipper Community Discord](#discord-chat).

## Klipper github

Klipper github may be used by contributors to share the status of their work to improve Klipper. It is expected that the person opening a github ticket is actively working on the given task and will be the one performing all the work necessary to accomplish it. The Klipper github is not used for requests, nor to report bugs, nor to ask questions. Use the [Klipper Community Forum](#community-forum) or the [Klipper Community Discord](#discord-chat) instead.
