# Exemplo de configurações

Esse documento contém diretrizes para contribuir com um exemplo de configuração do Klipper para o repositório github do Klipper (localizado no [diretório de configuração](../config/)).

Note que o [servidor de Discussão Comunitária do Klipper](https://community.klipper3d.org) também é uma fonte útil para achar e compartilhar arquivos de configuração.

## Diretrizes

1. Selecione o prefixo de nome de arquivo de configuração apropriado:
   1. O prefixo `printer` é usado para impressoras em sua configuração padrão, vendidas por um fabricante convencional.
   1. O prefixo `generic` é usado para uma placa controladora de impressora 3d que pode ser usada em vários tipos diferentes de impressoras.
   1. O prefixo `kit` é para impressoras 3d que são montadas de acordo especificações amplamente utilizadas. Essas impressoras de "kit" são geralmente diferentes de "impressoras" normais visto que não são vendidas por um fabricante.
   1. O prefixo `sample` é usado para "trechos" de configuração que são possíveis de serem copiados e colados no arquivo de configuração principal.
   1. O prefixo `example` é usado para descrever a cinemática da impressora. Esse tipo de configuração tipicamente é somente adicionado junto ao código para um novo tipo de cinemática de impressora.
1. Todos arquivos de configuração devem terminar com o sufixo `.cfg`. Os arquivos de configuração `printer` devem terminar com um ano, seguido por `.cfg` (p. ex. `-2019.cfg`). Nesse caso, o ano é o ano aproximado em que a impressora foi vendida.
1. Não utilize espaços ou caracteres especiais no nome do arquivo de configuração. O nome de arquivo deve conter somente os caracteres `A-Z`, `a-z`, `0-9`, `-` e `.`.
1. Klipper deve ser capaz de iniciar arquivos de exemplo de configuração `printer`, `generic` e `kit` sem erros. Esses arquivos de configuração devem ser adicionados a pasta de reversão de teste [test/klippy/printers.test](../test/klippy/printers.test). Adicione novos arquivos de configuração a essa pasta de teste, na parte apropriada, em ordem alfabética dentro da seção.
1. O exemplo de configuração deve ser para a configuração "padrão" da impressora. (Existem muitas configurações "customizadas" para acompanhar no repositório principal do Klipper.) Analogicamente, somente adicionamos arquivos de exemplo de configuração para impressoras, kits e placas que tenham popularidade com o público em geral (p. ex., devem ter ao menos 100 unidades dela em uso). Considere usar o [servidor de Discussão Comunitária do Klipper](https://community.klipper3d.org) para outras configurações.
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. Não especifique `pressure_advance` em um exemplo de configuração, visto que esse valor é específico ao filamento, não ao hardware da impressora. Da mesma forma, não especifique os ajustes `max_extrude_only_velocity` ou `max_extrude_only_accel`.
   1. Não especifique uma seção de configuração contendo um caminho ou hardware de hospedeiro. Por exemplo, não determine seções de configuração `[virtual_sdcard]` ou `[temperature_host]`.
   1. Somente defina macros que utilizem funcionalidade específica a uma impressora ou determine g-codes que são habitualmente emitidos por fatiadores configurados para a impressora em questão.
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. Não copie o campo documentação nos arquivos de exemplo de configuração. (Ao se fazer isso se cria uma obrigação de manutenção, visto que em uma atualização na documentação seria necessário modificá-la em vários lugares.)
   1. Arquivos de configuração de exemplo não devem conter uma seção "SAVE_CONFIG". Se necessário, copie os campos relevantes da seção SAVE_CONFIG para a parte apropriada na área da configuração principal.
   1. Use a sintaxe `field: value` ao invés de `field=value`.
   1. Quando adicionar uma `rotation_distance` para uma extrusora é preferível especificar uma `gear_ratio`, caso a extrusora tenha um mecanismo de engrenagens. É esperado que a rotation_distance nas configurações de exemplo esteja correlacionada com a circunferência da engrenagem fresada da extrusora - que é normalmente na faixa de 20 a 35mm. Quando se especifica uma `gear_ratio` é preferível que se informe o número de dentes das engrenagens que compõem o mecanismo (p. ex., prefira `gear_ratio: 80:20` a `gear_ratio: 4:1`). Veja o [documento Distância de Rotação](Rotation_Distance.md#using-a-gear_ratio) para mais informações.
   1. Evite definir valores de campo que estão configurados a seus valores padrão. Por exemplo, não se deve especificar `min_extrude_temp: 170` visto que esse já é o valor padrão.
   1. Onde possível, as linhas não devem ultrapassar 80 colunas.
   1. Evite adicionar mensagens de atribuição ou revisão nos arquivos de configuração. (Por exemplo, evite adicionar linhas como "Esse arquivo foi criado por ...".) Coloque a atribuição e o histórico de mudanças na mensagem de comprometimento do git.
1. Não use recursos obsoletos no arquivo de configuração de exemplo.
1. Não desabilite o sistema de segurança padrão de um arquivo de configuração de exemplo. Por exemplo, a definição não deve especificar uma `max_extrude_cross_section` customizada. Não desabilite os recursos de depuração. Por exemplo não deve se ter uma seção de configuração `force_move`.
1. Todas as placas suportadas pelo Klipper conseguem usar a taxa de transmissão serial padrão de 250000. Não recomende uma taxa de transmissão serial diferente no arquivo de exemplo de configuração.

Arquivos de configuração de exemplo são submetidos se criando um "pull request" no github. Por favor siga das instruções no [documento de contribuição](CONTRIBUTING.md).
