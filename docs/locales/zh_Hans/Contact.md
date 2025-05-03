# 联系方式

本文档提供了关于 Klipper 的联系信息。

1. [社区论坛](#community-forum)
1. [Discord 聊天](#discord-chat)
1. [我有一个关于 Klipper 的问题](#i-have-a-question-about-klipper)
1. [我有一个功能请求](#i-have-a-feature-request)
1. [我需要帮助！它炸了！](#help-it-doesnt-work)
1. [我在Klipper中发现了一个缺陷](#i-found-a-bug-in-the-klipper-software)
1. [我正在进行我想纳入 Klipper 的修改](#i-am-making-changes-that-id-like-to-include-in-klipper)
1. [Klipper GitHub](#klipper-github)

## 社区论坛

有一个用来讨论 Klipper 的 [Klipper 社区 Discourse 服务器](https://community.klipper3d.org)。

## Discord 聊天

我们有一个用来讨论Klipper的Discord服务器，它的邀请链接是<https://discord.klipper3d.org>。

这个服务器是由 Klipper 爱好者社区运行，致力于讨论 Klipper。它允许进行用户间的实时聊天。

## 我有一个关于 Klipper 的问题

我们收到的许多问题在 [Klipper 文档](Overview.md)中已经有了答案。请务必阅读该文档并遵循其中提供的指示。

也可以在[ Klipper 社区论坛](#community-forum)中搜索类似的问题。

如果你有兴趣与其他 Klipper 用户分享你的知识和经验，那么你可以加入[ Klipper 社区论坛](#community-forum)或[ Klipper Discord 聊天室](#discord-chat)。这两个社区都是 Klipper 用户间讨论 Klipper 的地方。

我们经常收到许多并不针对 Klipper 的常规3D打印疑问。如果你有常规的疑问或遇到了常规的打印问题，那么你可能会在一般的3D打印论坛或专门针对你的打印机硬件的论坛上得到更好的答案。

## 我有一个功能请求

所有的新功能都需要有感兴趣并能够实现这些功能的人。如果你想帮助实现或测试一个新功能，你可以在[ Klipper 社区论坛](#community-forum)中搜索正在进行的开发进程。还有[Klipper Discord 聊天室](#discord-chat)供合作者之间讨论。

## 我需要帮助！它炸了！

不幸的是，我们收到的帮助请求往往比我们能够回答的要多。我们发现大多数问题报告的根本原因都是：

1. 细微的硬件问题或
1. 未遵循 Klipper 文档中描述的所有步骤。

如果您遇到了问题，我们建议您仔细阅读 [Klipper 文档](Overview.md) 并再次检查是否遵循了所有步骤。

如果你遇到了打印问题，我们建议仔细检查打印机的硬件（所有接头、电线、螺丝等），确认没有任何异常。我们发现大多数打印问题都与 Klipper 软件无关。如果你确实发现了打印机硬件的问题，在一般的3D打印论坛或专门针对你的打印机硬件的论坛上搜索通常可以得到更好的答复。

也可以在[ Klipper 社区论坛](#community-forum)中查找类似的问题。

如果你有兴趣与其他 Klipper 用户分享你的知识和经验，那么你可以加入[ Klipper 社区论坛](#community-forum)或[ Klipper Discord 聊天室](#discord-chat)。这两个社区都是 Klipper 用户间讨论 Klipper 的地方。

## 我在Klipper中发现了一个缺陷

Klipper 是一个开源项目，我们诚挚的感谢贡献者们在软件中诊断出错误。

如果有问题，应在[Klipper社区论坛](#community-forum)上报告。

修复bug需要提供一些重要的信息。请遵循以下步骤：

1. 请确保您正在运行从 <https://github.com/Klipper3d/klipper > 获取的未修改代码。如果代码已被修改或从其他来源获得，则您需要在报告问题之前先在从 <https://github.com/Klipper3d/klipper > 获取的未修改的代码上重现问题。
1. 如果可能，在不良事件发生后立即运行`M112` 命令。这将导致Klipper进入 "关闭状态"，并会导致额外的调试信息被写入日志文件中。
1. 获取事件发送时的 Klipper 日志文件。该日志文件已被设计用来给 Klipper 开发人员提供关于软件及其运行环境的常见问题（软件版本、硬件类型、配置、事件时间和数百个其他问题）。
   1. Klipper 日志文件位于 Klipper "主机"（树莓派）的`/tmp/klippy.log`文件中。
   1. 你需要用“scp”或“sftp”程序将此日志文件复制到您的计算机。 “scp”程序是 Linux 和 MacOS 系统的标准配置。其他系统也通常有可用的 scp 实用程序（例如 WinSCP）。如果使用图形界面的 scp 程序无法直接复制 `/tmp/klippy.log`，可以尝试重复点击 `..`或者`parent folder`（父文件夹）直到进入根目录，再点击`tmp`文件夹，然后选择`klippy.log`文件。
   1. 将日志文件复制到你的电脑，以便将其上传到问题报告中。
   1. 不要以任何方式修改日志文件；不要只提供日志的片段。只有完整的未修改的日志文件才能够提供必要的信息。
   1. 最好使用 zip 或 gzip 压缩日志文件。
1. 在[Klipper社区论坛](#community-forum)上发起一个新话题，并对问题进行清晰的描述。其他Klipper贡献者需要了解你采取了哪些步骤，期望的结果是什么，以及实际发生的结果是什么。在话题中应当附上压缩的Klipper日志文件。

## 我正在进行一些我想添加到 Klipper 中的改进

Klipper 是开源软件，我们非常感谢新的贡献。

新的贡献（包括代码和文档）需要通过拉取请求(PR)提交。重要信息请参见[贡献文档](CONTRIBUTING.md)。

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
