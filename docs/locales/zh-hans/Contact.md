本文档提供了关于 Klipper 的联系信息。

1. [社区论坛](#community-forum)
1. [Discord聊天](#discord-chat)
1. [我有一个关于 Klipper 的问题](#i-have-a-question-about-klipper)
1. [我有一个功能请求](#i-have-a-feature-request)
1. [我需要帮助！它炸了！](#help-it-doesnt-work)
1. [我在 Klipper 中发现了一个缺陷](#i-have-diagnosed-a-defect-in-the-klipper-software)
1. [我正在进行我想纳入 Klipper 的修改](#i-am-making-changes-that-id-like-to-include-in-klipper)

# 社区论坛

有一个用来讨论 Klipper 的 [Klipper 社区 Discourse 服务器](https://community.klipper3d.org)。

# Discord聊天

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>.

这个服务器是由 Klipper 爱好者社区运行的，致力于讨论Klipper。它允许进行用户间的实时聊天。

# 我有一个关于 Klipper 的问题

我们收到的许多问题在 [Klipper 文档](Overview.md)中已经有了答案。请务必阅读该文档并遵循其中提供的指示。

也可以在[ Klipper 社区论坛](#community-forum)中搜索类似的问题。

如果你有兴趣与其他Klipper用户分享你的知识和经验，那么你可以加入[ Klipper 社区论坛](#community-forum)或[ Klipper Discord 聊天室](#discord-chat)。这两个社区都是 Klipper 用户互相讨论Klipper 的地方。

我们经常收到许多并不针对 Klipper 的常规3D打印问题。如果你有常规的问题或遇到常规的打印问题，那么你可能会在一般的3D打印论坛或专门针对你的打印机硬件的论坛上得到更好的答案。

不要在 Klipper 的 Github 上创建议题来提问。

# 我有一个功能请求

所有的新功能都需要有人对该功能感兴趣并能够实现。如果你想帮助实现或测试一个新功能，你可以在[ Klipper 社区论坛](#community-forum)中搜索正在进行的开发。还有[Klipper Discord 聊天室](#discord-chat)供合作者之间讨论。

不要在 Klipper 的 Github 上创建议题来请求功能。

# 我需要帮助！它不起作用！

不幸的是，我们收到的帮助请求往往比我们能够回答的要多。我们发现大多数问题报告的根本原因都是：

1. 细微的硬件问题或
1. 未遵循 Klipper 文档中描述的所有步骤。

如果您遇到了问题，我们建议您仔细阅读 [Klipper 文档](Overview.md) 并再次检查是否遵循了所有步骤。

如果你遇到了打印问题，我们建议仔细检查打印机的硬件（所有接头、电线、螺丝等），确认没有任何异常。我们发现大多数打印问题都与 Klipper 软件无关。如果你确实发现了打印机硬件的问题，在一般的3D打印论坛或专门针对你的打印机硬件的论坛上搜索通常可以得到更好的答复。

也可以在[ Klipper 社区论坛](#community-forum)中查找类似的问题。

如果你有兴趣与其他Klipper用户分享你的知识和经验，那么你可以加入[ Klipper 社区论坛](#community-forum)或[ Klipper Discord 聊天室](#discord-chat)。这两个社区都是 Klipper 用户互相讨论Klipper 的地方。

不要在 Klipper 的 Github 上创建议题来求助。

# 我在 Klipper 软件中诊断出了一个缺陷

Klipper 是一个开源项目，我们诚挚的感谢贡献者们在软件中诊断出错误。

为了修复一个错误，一些重要的信息需要被提供。请遵循以下步骤：

1. 先要确定这个错误是在Klipper软件中。如果你在想 "我有一个问题，我无法找出原因，因此这是一个Klipper的错误"，那么**不要**创建一个Github议题。在这种情况下，有兴趣且有能力的人需要首先研究并诊断出问题的根源。如果你想分享你的研究结果或检查其他用户是否遇到类似的问题，那么你可以搜索[Klipper社区论坛](#community-forum)。
1. Make sure you are running unmodified code from <https://github.com/KevinOConnor/klipper>. If the code has been modified or is obtained from another source, then you will need to reproduce the problem on the unmodified code from <https://github.com/KevinOConnor/klipper> prior to reporting an issue.
1. 如果可能的话，在不期望的事件发生后，立即在 OctoPrint 终端窗口运行一个`M112`命令。这将使 Klipper 进入 "关闭状态"，并在日志文件中写入额外的调试信息。
1. 获取事件中的 Klipper 日志文件。该日志文件已被设计用来回答 Klipper 开发人员关于软件及其运行环境的常见问题（软件版本、硬件类型、配置、事件时间和数百个其他问题）。
   1. Klipper 日志文件位于 Klipper "主机"（树莓票）的`/tmp/klippy.log`文件中。
   1. 你需要用“scp”或“sftp”程序将此日志文件复制到您的计算机。 “scp”程序是 Linux 和 MacOS 系统的标准配置。其他系统也通常有可用的 scp 实用程序（例如 WinSCP）。如果使用图形界面的 scp 程序无法直接复制 `/tmp/klippy.log`，可以尝试重复点击 `..`或者`parent folder`（父文件夹）直到进入根目录，再点击`tmp`文件夹，然后选择`klippy.log`文件。
   1. 将日志文件复制到你的电脑，以便将其附到问题报告中。
   1. 不要以任何方式修改日志文件；不要只提供日志的片段。只有完整的未修改的日志文件才能够提供必要的信息。
   1. 如果日志文件非常大（例如，大于2MB），那么可能需要用 zip 或 gzip 来压缩日志。

   1. Open a new github issue at <https://github.com/KevinOConnor/klipper/issues> and provide a clear description of the problem. The Klipper developers need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The Klipper log file **must be attached** to that ticket:![问题附件](img/attach-issue.png)

# 我正在进行一些我想包含在 Klipper 中的改进

Klipper 是开源软件，我们非常感谢新的贡献。

新的贡献（包括代码和文档）需要通过Github Pull Requests提交。重要信息请参见[贡献文档](CONTRIBUTING.md)。

有几个[开发人员文档](Overview.md#developer-documentation)。如果你对代码有疑问，那么你也可以在[Klipper社区论坛](#community-forum)或[Klipper社区 Discord](#discord-chat)上提问。如果你想提供你目前的进展情况，那么你可以在 Github 上开一个问题，写上你的代码的位置，修改的概述，以及对其目前状态的描述。
