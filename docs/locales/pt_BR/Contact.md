# Contato

Este documento fornece informações de contato para o Klipper.

1. [Forum da Comunidade](#community-forum)
1. [Chat do Discord](#discord-chat)
1. [Eu tenho uma pergunta sobre o Klipper](#i-have-a-question-about-klipper)
1. [Eu tenho um pedido de recurso](#i-have-a-feature-request)
1. [Me ajude! Não funciona!](#help-it-doesnt-work)
1. [Eu encontrei um defeito no software Klipper](#i-have-diagnosed-a-defect-in-the-klipper-software)
1. [Estou fazendo alterações que gostaria de incluir no Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)

## Fórum da Comunidade

Existe um [servidor da Comunidade Klipper no Discourse](https://community.klipper3d.org) para discussões sobre o Klipper.

## Chat no Discord

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>.

Este servidor é administrado por uma comunidade de entusiastasdo Klipper dedicados a discussões sobre o Klipper. Ele permite que os usuários conversem com outros usuários em tempo real.

## Eu tenho uma pergunta sobre o Klipper

Muitas perguntas que recebemos já foram respondidas na [documentação do Klipper](Overview.md). Leia a documentação e siga as instruções fornecidas.

Também é possível pesquisar perguntas semelhantes no [Fórum da Comunidade Klipper](#community-forum).

Se você estiver interessado em compartilhar seu conhecimento e experiência com outros usuários do Klipper, então você pode se juntar ao [Fórum da Comunidade Klipper](#community-forum) ou ao [Chat no Discord Klipper](#discord-chat). Ambas são comunidades onde os usuários do Klipper podem discutir sobre o Klipper com outros usuários.

Muitas perguntas que recebemos são perguntas gerais sobre impressão em 3D que não são específicas do Klipper. Se você tiver uma pergunta geral ou estiver enfrentando problemas gerais de impressão, provavelmente obterá uma resposta melhor se perguntando em um fórum de impressão em 3D geral ou em um fórum dedicado ao hardware da sua impressora.

Não abra um chamado de problema do github do Klipper para fazer uma pergunta.

## Eu tenho um pedido de recurso

Todos os novos recursos exigem alguém interessado e capaz de implementar esse recurso. Se você estiver interessado em ajudar a implementar ou testar um novo recurso, você pode procurar pelos desenvolvimentos em andamento no [Fórum da Comunidade Klipper](#community-forum). Há também [Chat no Discord do Klipper](#discord-chat) para discussões entre os colaboradores.

Não abra um chamado de problema de github do Klipper para solicitar um recurso.

## Help! It doesn't work!

Unfortunately, we receive many more requests for help than we could possibly answer. Most problem reports we see are eventually tracked down to:

1. Subtle errors in the hardware, or
1. Not following all the steps described in the Klipper documentation.

If you are experiencing problems we recommend you carefully read the [Klipper documentation](Overview.md) and double check that all steps were followed.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then you will likely get a better response by searching in a general 3d-printing forum or in a forum dedicated to your printer hardware.

It is also possible to search for similar issues in the [Klipper Community Forum](#community-forum).

Se você estiver interessado em compartilhar seu conhecimento e experiência com outros usuários do Klipper, então você pode se juntar ao [Fórum da Comunidade Klipper](#community-forum) ou ao [Chat no Discord Klipper](#discord-chat). Ambas são comunidades onde os usuários do Klipper podem discutir sobre o Klipper com outros usuários.

Do not open a Klipper github issue to request help.

## I have diagnosed a defect in the Klipper software

Klipper is an open-source project and we appreciate when collaborators diagnose errors in the software.

There is important information that will be needed in order to fix a bug. Please follow these steps:

1. Be sure the bug is in the Klipper software. If you are thinking "there is a problem, I can't figure out why, and therefore it is a Klipper bug", then **do not** open a github issue. In that case, someone interested and able will need to first research and diagnose the root cause of the problem. If you would like to share the results of your research or check if other users are experiencing similar issues then you can search the [Klipper Community Forum](#community-forum).
1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you will need to reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting an issue.
1. If possible, run an `M112` command in the OctoPrint terminal window immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. Obtain the Klipper log file from the event. The log file has been engineered to answer common questions the Klipper developers have about the software and its environment (software version, hardware type, configuration, event timing, and hundreds of other questions).
   1. The Klipper log file is located in `/tmp/klippy.log` on the Klipper "host" computer (the Raspberry Pi).
   1. An "scp" or "sftp" utility is needed to copy this log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). If using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or `parent folder` until you get to the root directory, click on the `tmp` folder, and then select the `klippy.log` file.
   1. Copy the log file to your desktop so that it can be attached to an issue report.
   1. Do not modify the log file in any way; do not provide a snippet of the log. Only the full unmodified log file provides the necessary information.
   1. If the log file is very large (eg, greater than 2MB) then one may need to compress the log with zip or gzip.

   1. Open a new github issue at <https://github.com/Klipper3d/klipper/issues> and provide a clear description of the problem. The Klipper developers need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The Klipper log file **must be attached** to that ticket:![attach-issue](img/attach-issue.png)

## I am making changes that I'd like to include in Klipper

Klipper is open-source software and we appreciate new contributions.

New contributions (for both code and documentation) are submitted via Github Pull Requests. See the [CONTRIBUTING document](CONTRIBUTING.md) for important information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Community Forum](#community-forum) or on the [Klipper Community Discord](#discord-chat). If you would like to provide an update on your current progress then you can open a Github issue with the location of your code, an overview of the changes, and a description of its current status.
