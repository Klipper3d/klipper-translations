# Contato

Este documento fornece informações de contato para o Klipper.

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Chat no Discord

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

Este servidor é administrado por uma comunidade de entusiastasdo Klipper dedicados a discussões sobre o Klipper. Ele permite que os usuários conversem com outros usuários em tempo real.

## Eu tenho uma pergunta sobre o Klipper

Muitas perguntas que recebemos já foram respondidas na [documentação do Klipper](Overview.md). Leia a documentação e siga as instruções fornecidas.

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## Eu tenho um pedido de recurso

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## Ajuda! Isso não funciona!

Se você está experienciando problemas, recomendamos que leia atentamente a [documentação do Klipper](Overview.md) e se certifique que todos os passos foram seguidos.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## Encontrei um bug no Klipper

Klipper é um projeto de código aberto e apreciamos quando colaboradores diagnosticam erros no software.

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

Tem informações importantes que serão necessárias para correção do bug. Por favor siga os seguintes passos:

1. Certifique-se de estar executando o código não modificado de <https://github.com/Klipper3d/klipper>. Se o código tiver sido modificado ou obtido de outra fonte, você deverá reproduzir o problema no código não modificado de <https://github.com/Klipper3d/klipper> antes de relatar.
1. Se possível, execute um comando `M112` imediatamente após a ocorrência do problema. Isso faz com que o Klipper entre em um "estado de desligamento" e fará com que informações adicionais de depuração sejam gravadas no arquivo log.
1. Obtenha o arquivo de registro do Klipper sobre o evento. O arquivo de registro foi projetado para responder a dúvidas comuns que os desenvolvedores do Klipper tenham a respeito do software e seu ambiente (versão de software, tipo de hardware, configuração, horário do evento, e outras centenas de questões).
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. Copie o arquivo log para seu computador para que ele possa ser anexado a um relatório de problemas.
   1. Não modifique o arquivo log de forma alguma; não forneça apenas um trecho do log. Somente o arquivo log completo e não modificado fornece as informações necessárias.
   1. É uma boa ideia compactar o arquivo de log com .zip ou .gzip.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## Estou fazendo modificações que gostaria de incluir no Klipper

Klipper é um software de código aberto e nós apreciamos novas contribuições.

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
