# Contato

Este documento fornece informações de contato para o Klipper.

1. [Forum da Comunidade](#community-forum)
1. [Chat do Discord](#discord-chat)
1. [Eu tenho uma pergunta sobre o Klipper](#i-have-a-question-about-klipper)
1. [Eu tenho um pedido de recurso](#i-have-a-feature-request)
1. [Me ajude! Não funciona!](#help-it-doesnt-work)
1. [I found a bug in the Klipper software](#i-found-a-bug-in-the-klipper-software)
1. [Estou fazendo alterações que gostaria de incluir no Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)
1. [Klipper github](#klipper-github)

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

## Eu tenho um pedido de recurso

Todos os novos recursos exigem alguém interessado e capaz de implementar esse recurso. Se você estiver interessado em ajudar a implementar ou testar um novo recurso, você pode procurar pelos desenvolvimentos em andamento no [Fórum da Comunidade Klipper](#community-forum). Há também [Chat no Discord do Klipper](#discord-chat) para discussões entre os colaboradores.

## Ajuda! Isso não funciona!

Infelizmente recebemos mais pedidos por ajuda do que podemos responder. A maioria dos relatórios de problemas que vemos eventualmente levam a:

1. Pequenos erros de hardware, ou
1. Não seguir a todos os passos descritos na documentação do Klipper.

Se você está experienciando problemas, recomendamos que leia atentamente a [documentação do Klipper](Overview.md) e se certifique que todos os passos foram seguidos.

Se você tem experienciado problemas com impressões, recomendamos que inspecione cuidadosamente o hardware de sua impressora (todas as juntas, fiação, parafusos, etc.) e veja se tem alguma coisa fora do normal. Na nossa experiência a maioria dos problemas com impressões não estão relacionados ao software do Klipper. Caso encontre algum problema com o hardware da impressora, é mais provável encontrar uma solução procurando em um fórum sobre impressão 3d em geral ou em um fórum dedicado ao hardware de sua impressora.

Também é possível procurar por problemas semelhantes no [Fórum Comunitário do Klipper](#community-forum).

Se você estiver interessado em compartilhar seu conhecimento e experiência com outros usuários do Klipper, então você pode se juntar ao [Fórum da Comunidade Klipper](#community-forum) ou ao [Chat no Discord Klipper](#discord-chat). Ambas são comunidades onde os usuários do Klipper podem discutir sobre o Klipper com outros usuários.

## I found a bug in the Klipper software

Klipper é um projeto de código aberto e apreciamos quando colaboradores diagnosticam erros no software.

Problems should be reported in the [Klipper Community Forum](#community-forum).

Tem informações importantes que serão necessárias para correção do bug. Por favor siga os seguintes passos:

1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you should reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting.
1. If possible, run an `M112` command immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. Obtenha o arquivo de registro do Klipper sobre o evento. O arquivo de registro foi projetado para responder a dúvidas comuns que os desenvolvedores do Klipper tenham a respeito do software e seu ambiente (versão de software, tipo de hardware, configuração, horário do evento, e outras centenas de questões).
   1. O arquivo de registro do Klipper está localizado em `/tmp/klippy.log`, no computador que hospeda o Klipper (o Raspberry Pi).
   1. An "scp" or "sftp" utility is needed to copy this log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). If using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or `parent folder` until you get to the root directory, click on the `tmp` folder, and then select the `klippy.log` file.
   1. Copy the log file to your desktop so that it can be attached to an issue report.
   1. Do not modify the log file in any way; do not provide a snippet of the log. Only the full unmodified log file provides the necessary information.
   1. It is a good idea to compress the log file with zip or gzip.
1. Open a new topic on the [Klipper Community Forum](#community-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## I am making changes that I'd like to include in Klipper

Klipper é um software de código aberto e nós apreciamos novas contribuições.

New contributions (for both code and documentation) are submitted via Github Pull Requests. See the [CONTRIBUTING document](CONTRIBUTING.md) for important information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Community Forum](#community-forum) or on the [Klipper Community Discord](#discord-chat).

## Klipper github

Klipper github may be used by contributors to share the status of their work to improve Klipper. It is expected that the person opening a github ticket is actively working on the given task and will be the one performing all the work necessary to accomplish it. The Klipper github is not used for requests, nor to report bugs, nor to ask questions. Use the [Klipper Community Forum](#community-forum) or the [Klipper Community Discord](#discord-chat) instead.
