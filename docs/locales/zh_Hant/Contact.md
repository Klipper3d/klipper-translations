# 聯繫方式

本文件提供了關於 Klipper 的聯繫資訊。

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Discord 聊天

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

這個伺服器是由 Klipper 愛好者社區執行，致力於討論 Klipper。它允許進行使用者間的實時聊天。

## 我有一個關於 Klipper 的問題

我們收到的許多問題在 [Klipper 文件](Overview.md)中已經有了答案。請務必閱讀該文件並遵循其中提供的指示。

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## 我有一個功能請求

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## 我需要幫助！它炸了！

如果您遇到了問題，我們建議您仔細閱讀 [Klipper 文件](Overview.md) 並再次檢查是否遵循了所有步驟。

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## I found a bug in the Klipper software

Klipper 是一個開源專案，我們誠摯的感謝貢獻者們在軟體中診斷出錯誤。

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

修復bug需要提供一些重要的資訊。請遵循以下步驟：

1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you should reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting.
1. If possible, run an `M112` command immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. 獲取事件發送時的 Klipper 日誌檔案。該日誌檔案已被設計用來給 Klipper 開發人員提供關於軟體及其執行環境的常見問題（軟體版本、硬體型別、配置、事件時間和數百個其他問題）。
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. 將日誌檔案複製到你的電腦，以便將其上傳到問題報告中。
   1. 不要以任何方式修改日誌檔案；不要只提供日誌的片段。只有完整的未修改的日誌檔案才能夠提供必要的資訊。
   1. It is a good idea to compress the log file with zip or gzip.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## 我正在進行一些我想新增到 Klipper 中的改進

Klipper 是開源軟體，我們非常感謝新的貢獻。

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
