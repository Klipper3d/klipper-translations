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

Existe um servidor Discord dedicado ao Klipper: <https://discord.klipper3d.org>.

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

## Encontrei um bug no Klipper

Klipper é um projeto de código aberto e apreciamos quando colaboradores diagnosticam erros no software.

Os problemas devem ser relatados em [Klipper Community Forum](#community-forum).

Tem informações importantes que serão necessárias para correção do bug. Por favor siga os seguintes passos:

1. Certifique-se de estar executando o código não modificado de <https://github.com/Klipper3d/klipper>. Se o código tiver sido modificado ou obtido de outra fonte, você deverá reproduzir o problema no código não modificado de <https://github.com/Klipper3d/klipper> antes de relatar.
1. Se possível, execute um comando `M112` imediatamente após a ocorrência do problema. Isso faz com que o Klipper entre em um "estado de desligamento" e fará com que informações adicionais de depuração sejam gravadas no arquivo log.
1. Obtenha o arquivo de registro do Klipper sobre o evento. O arquivo de registro foi projetado para responder a dúvidas comuns que os desenvolvedores do Klipper tenham a respeito do software e seu ambiente (versão de software, tipo de hardware, configuração, horário do evento, e outras centenas de questões).
   1. O arquivo de registro do Klipper está localizado em `/tmp/klippy.log`, no computador que hospeda o Klipper (o Raspberry Pi).
   1. É necessário um utilitário “SCP” ou “SFTP” para copiar este arquivo log para o seu computador. O utilitário “SCP” vem como padrão nos desktops Linux e MacOS. Existem utilitários SCP disponíveis gratuitamente para outros sistemas (por exemplo, WinSCP). Se estiver usando um utilitário gráfico SCP que não pode copiar diretamente `/tmp/klippy.log`, clique repetidamente em `..` ou `parent folder` até chegar ao diretório raiz, clique na pasta `tmp` e então selecione o arquivo `klippy.log`.
   1. Copie o arquivo log para seu computador para que ele possa ser anexado a um relatório de problemas.
   1. Não modifique o arquivo log de forma alguma; não forneça apenas um trecho do log. Somente o arquivo log completo e não modificado fornece as informações necessárias.
   1. É uma boa ideia compactar o arquivo de log com .zip ou .gzip.
1. Abra um novo tópico no [Klipper Community Forum](#community-forum) e forneça uma descrição clara do problema. Outros colaboradores do Klipper precisarão entender quais etapas foram tomadas, qual foi o resultado desejado e qual resultado realmente ocorreu. O arquivo log compactado do Klipper deve ser anexado a esse tópico.

## Estou fazendo modificações que gostaria de incluir no Klipper

Klipper é um software de código aberto e nós apreciamos novas contribuições.

Novas contribuições (tanto para código quanto para documentação) são enviadas por meio de solicitações Pull do Github. Consulte o [CONTRIBUTING document](CONTRIBUTING.md) para obter informações importantes.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
