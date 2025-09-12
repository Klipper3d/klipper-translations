# 联系方式

本文档提供 Klipper 的联系方式。

## Discourse 论坛

有一个 [Klipper 社区 Discourse 服务器](https://community.klipper3d.org)，用于进行关于 Klipper 的“论坛”式讨论。请注意，Discourse 不是 Discord。

## Discord 聊天

有一个专门用于 Klipper 的 Discord 服务器：
[https://discord.klipper3d.org](https://discord.klipper3d.org)。请注意
Discord 不是 Discourse。

该服务器由一群致力于 Klipper 讨论的爱好者运营。它允许用户与其他用户实时聊天。

## 我有关于 Klipper 的问题

我们收到的许多问题已经在 [Klipper 文档](Overview.md) 中得到了解答。请务必阅读文档并遵循其中提供的说明。

您也可以在 [Klipper Discourse 论坛](#discourse-forum) 中搜索类似的问题。

如果您有兴趣与其他 Klipper 用户分享您的知识和经验，您可以加入 [Klipper Discourse 论坛](#discourse-forum) 或 [Klipper Discord 聊天](#discord-chat)。这两个都是 Klipper 用户可以与其他用户讨论 Klipper 的社区。

如果您有通用问题或遇到一般的打印问题，也可以考虑访问通用的 3D 打印论坛或专注于打印机硬件的论坛。

## 我有一个功能请求

所有新功能都需要有人感兴趣并有能力实现该功能。如果您有兴趣帮助实现或测试新功能，可以在 [Klipper Discourse 论坛](#discourse-forum) 中搜索正在进行的开发项目。也有 [Klipper Discord 聊天](#discord-chat) 供协作者之间进行讨论。

## 帮忙！它不工作了！

如果您遇到问题，我们建议您仔细阅读 [Klipper 文档](Overview.md)，并仔细检查是否遵循了所有步骤。

如果您遇到打印问题，我们建议您仔细检查打印机硬件（所有接头、电线、螺丝等），并确认一切正常。我们发现大多数打印问题与 Klipper 软件无关。如果确实发现打印机硬件有问题，请考虑搜索通用的 3D 打印论坛或专注于打印机硬件的论坛。

您也可以在 [Klipper Discourse 论坛](#discourse-forum) 中搜索类似的问题。

如果您有兴趣与其他 Klipper 用户分享您的知识和经验，您可以加入 [Klipper Discourse 论坛](#discourse-forum) 或 [Klipper Discord 聊天](#discord-chat)。这两个都是 Klipper 用户可以与其他用户讨论 Klipper 的社区。

## 我发现了 Klipper 软件中的一个错误

Klipper 是一个开源项目，我们非常感谢协作者能诊断软件中的错误。

问题应在 [Klipper Discourse 论坛](#discourse-forum) 中报告。

修复错误需要一些重要信息。请按照以下步骤操作：
1. 确保您运行的是来自 [https://github.com/Klipper3d/klipper](https://github.com/Klipper3d/klipper) 的未修改代码。如果代码已被修改或从其他来源获取，则应在报告之前，在来自 [https://github.com/Klipper3d/klipper](https://github.com/Klipper3d/klipper) 的未修改代码上重现问题。
2. 如果可能，在发生不良事件后立即运行 `M112` 命令。这会使 Klipper 进入“关闭状态”，并导致额外的调试信息被写入日志文件。
3. 获取该事件的 Klipper 日志文件。日志文件的设计旨在回答 Klipper 开发人员关于软件及其环境的常见问题（软件版本、硬件类型、配置、事件时间以及数百个其他问题）。
   1. 专用的 Klipper 网络界面可以直接获取 Klipper 日志文件。当使用这些界面时，这是获取日志的最简单方法。否则，需要使用“scp”或“sftp”工具将日志文件复制到您的桌面计算机。“scp”工具是 Linux 和 MacOS 桌面的标准工具。其他桌面有免费的 scp 工具（例如 WinSCP）。日志文件可能位于 `~/printer_data/logs/klippy.log` 文件中（如果使用图形 scp 工具，请查找“printer_data”文件夹，然后找到其下的“logs”文件夹，再找到 `klippy.log` 文件）。日志文件也可能位于 `/tmp/klippy.log` 文件中（如果使用的图形 scp 工具无法直接复制 `/tmp/klippy.log`，则反复点击 `..` 或 “父文件夹” 直到到达根目录，点击 `tmp` 文件夹，然后选择 `klippy.log` 文件）。
   2. 将日志文件复制到您的桌面，以便可以将其附加到问题报告中。
   3. 不要以任何方式修改日志文件；不要提供日志片段。只有完整的未修改日志文件才能提供必要的信息。
   4. 建议使用 zip 或 gzip 压缩日志文件。
4. 在 [Klipper Discourse 论坛](#discourse-forum) 上开启一个新主题，并提供对问题的清晰描述。其他 Klipper 贡献者需要了解采取了哪些步骤、期望的结果是什么以及实际发生的结果是什么。应将压缩后的 Klipper 日志文件附加到该主题中。

## 我正在做更改，希望将其包含在 Klipper 中

Klipper 是开源软件，我们非常欢迎新的贡献。

有关信息，请参阅 [CONTRIBUTING 文档](CONTRIBUTING.md)。

有几份 [面向开发者的文档](Overview.md#developer-documentation)。如果您对代码有疑问，也可以在 [Klipper Discourse 论坛](#discourse-forum) 或 [Klipper Discord 聊天](#discord-chat) 中提问。

## 专业服务

[](img/klipper-logo-small.png)

定制软件开发、软件支持和解决方案：
[https://ko-fi.com/koconnor](https://ko-fi.com/koconnor)