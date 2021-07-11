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

There is a Discord server dedicated to Klipper at:
<https://discord.klipper3d.org>.

这个服务器是由 Klipper 爱好者社区运行的，致力于讨论Klipper。它允许进行用户间的实时聊天。

# 我有一个关于 Klipper 的问题

我们收到的许多问题在 [Klipper 文档](Overview.md)中已经有了答案。请务必阅读该文档并遵循其中提供的指示。

也可以在[ Klipper 社区论坛](#community-forum)中搜索类似的问题。

如果你有兴趣与其他Klipper用户分享你的知识和经验，那么你可以加入[ Klipper 社区论坛](#community-forum)或[ Klipper
Discord 聊天室](#discord-chat)。这两个社区都是 Klipper 用户互相讨论Klipper 的地方。

我们经常收到许多并不针对 Klipper
的常规3D打印问题。如果你有常规的问题或遇到常规的打印问题，那么你可能会在一般的3D打印论坛或专门针对你的打印机硬件的论坛上得到更好的答案。

不要在 Klipper 的 Github 上创建议题来提问。

# 我有一个功能请求

所有的新功能都需要有人对该功能感兴趣并能够实现。如果你想帮助实现或测试一个新功能，你可以在[ Klipper
社区论坛](#community-forum)中搜索正在进行的开发。还有[Klipper Discord
聊天室](#discord-chat)供合作者之间讨论。

不要在 Klipper 的 Github 上创建议题来请求功能。

# 我需要帮助！它不起作用！

不幸的是，我们收到的帮助请求往往比我们能够回答的要多。我们发现大多数问题报告的根本原因都是：

1. 细微的硬件问题或
1. 未遵循 Klipper 文档中描述的所有步骤。

如果您遇到了问题，我们建议您仔细阅读 [Klipper 文档](Overview.md) 并再次检查是否遵循了所有步骤。

如果你遇到了打印问题，我们建议仔细检查打印机的硬件（所有接头、电线、螺丝等），确认没有任何异常。我们发现大多数打印问题都与 Klipper
软件无关。如果你确实发现了打印机硬件的问题，在一般的3D打印论坛或专门针对你的打印机硬件的论坛上搜索通常可以得到更好的答复。

也可以在[ Klipper 社区论坛](#community-forum)中查找类似的问题。

如果你有兴趣与其他Klipper用户分享你的知识和经验，那么你可以加入[ Klipper 社区论坛](#community-forum)或[ Klipper
Discord 聊天室](#discord-chat)。这两个社区都是 Klipper 用户互相讨论Klipper 的地方。

不要在 Klipper 的 Github 上创建议题来求助。

# 我在 Klipper 软件中诊断出了一个缺陷

Klipper 是一个开源项目，我们诚挚的感谢贡献者们在软件中诊断出错误。

为了修复一个错误，一些重要的信息需要被提供。请遵循以下步骤：

1. Be sure the bug is in the Klipper software. If you are thinking "there is a
problem, I can't figure out why, and therefore it is a Klipper bug", then **do
not** open a github issue. In that case, someone interested and able will need
to first research and diagnose the root cause of the problem. If you would like
to share the results of your research or check if other users are experiencing
similar issues then you can search the [Klipper Community Forum](#community-
forum).
1. Make sure you are running unmodified code from
<https://github.com/KevinOConnor/klipper>. If the code has been modified or is
obtained from another source, then you will need to reproduce the problem on the
unmodified code from <https://github.com/KevinOConnor/klipper> prior to
reporting an issue.
1. 如果可能的话，在不期望的事件发生后，立即在 OctoPrint 终端窗口运行一个`M112`命令。这将使 Klipper 进入
"关闭状态"，并在日志文件中写入额外的调试信息。
1. Obtain the Klipper log file from the event. The log file has been engineered
to answer common questions the Klipper developers have about the software and
its environment (software version, hardware type, configuration, event timing,
and hundreds of other questions).
   1. Klipper 日志文件位于 Klipper "主机"（树莓票）的`/tmp/klippy.log`文件中。
   1. An "scp" or "sftp" utility is needed to copy this log file to your desktop
computer. The "scp" utility comes standard with Linux and MacOS desktops. There
are freely available scp utilities for other desktops (eg, WinSCP). If using a
graphical scp utility that can not directly copy `/tmp/klippy.log` then
repeatedly click on `..` or `parent folder` until you get to the root directory,
click on the `tmp` folder, and then select the `klippy.log` file.
   1. 将日志文件复制到你的电脑，以便将其附到问题报告中。
   1. Do not modify the log file in any way; do not provide a snippet of the log.
Only the full unmodified log file provides the necessary information.
   1. If the log file is very large (eg, greater than 2MB) then one may need to
compress the log with zip or gzip.

   1. Open a new github issue at <https://github.com/KevinOConnor/klipper/issues>
and provide a clear description of the problem. The Klipper developers need to
understand what steps were taken, what the desired outcome was, and what outcome
actually occurred. The Klipper log file **must be attached** to that ticket:![attach-issue](img/attach-issue.png)

# I am making changes that I'd like to include in Klipper

Klipper is open-source software and we appreciate new contributions.

New contributions (for both code and documentation) are submitted via Github
Pull Requests. See the [CONTRIBUTING document](CONTRIBUTING.md) for important
information.

There are several [documents for
developers](Overview.md#developer-documentation). If you have questions on the
code then you can also ask in the [Klipper Community Forum](#community-forum) or
on the [Klipper Community Discord](#discord-chat). If you would like to provide
an update on your current progress then you can open a Github issue with the
location of your code, an overview of the changes, and a description of its
current status.
