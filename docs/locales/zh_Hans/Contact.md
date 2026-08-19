# 联系方式

本文档提供了关于 Klipper 的联系信息。

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Discord 聊天

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

这个服务器是由 Klipper 爱好者社区运行，致力于讨论 Klipper。它允许进行用户间的实时聊天。

## 我有一个关于 Klipper 的问题

我们收到的许多问题在 [Klipper 文档](Overview.md)中已经有了答案。请务必阅读该文档并遵循其中提供的指示。

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## 我有一个功能请求

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## 我需要帮助！它炸了！

如果您遇到了问题，我们建议您仔细阅读 [Klipper 文档](Overview.md) 并再次检查是否遵循了所有步骤。

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## 我在Klipper中发现了一个缺陷

Klipper 是一个开源项目，我们诚挚的感谢贡献者们在软件中诊断出错误。

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

修复bug需要提供一些重要的信息。请遵循以下步骤：

1. 请确保您正在运行从 <https://github.com/Klipper3d/klipper > 获取的未修改代码。如果代码已被修改或从其他来源获得，则您需要在报告问题之前先在从 <https://github.com/Klipper3d/klipper > 获取的未修改的代码上重现问题。
1. 如果可能，在不良事件发生后立即运行`M112` 命令。这将导致Klipper进入 "关闭状态"，并会导致额外的调试信息被写入日志文件中。
1. 获取事件发送时的 Klipper 日志文件。该日志文件已被设计用来给 Klipper 开发人员提供关于软件及其运行环境的常见问题（软件版本、硬件类型、配置、事件时间和数百个其他问题）。
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. 将日志文件复制到你的电脑，以便将其上传到问题报告中。
   1. 不要以任何方式修改日志文件；不要只提供日志的片段。只有完整的未修改的日志文件才能够提供必要的信息。
   1. 最好使用 zip 或 gzip 压缩日志文件。
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## 我正在进行一些我想添加到 Klipper 中的改进

Klipper 是开源软件，我们非常感谢新的贡献。

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
