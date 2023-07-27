# Excluir Objetos

The `[exclude_object]` module allows Klipper to exclude objects while a print is in progress. To enable this feature include an [exclude_object config
section](Config_Reference.md#exclude_object) (also see the [command
reference](G-Codes.md#exclude-object) and [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.)

Diferente de outras opções de firmware de impressora 3D, uma impressora que executa o Klipper utiliza um conjunto de componentes e os usuários têm muitas opções para escolher. Portanto, para fornecer uma experiência de usuário consistente, o módulo `[exclude_object]` estabelecerá um contrato ou API de algum tipo. O contrato abrange o conteúdo do arquivo gcode, como o estado interno do módulo é controlado e como esse estado é fornecido aos clientes.

## Visão geral do fluxo de trabalho

Um fluxo de trabalho típico para imprimir um arquivo pode parecer com isso:

1. O fatiamento é concluído e o arquivo é carregado para impressão. Durante o carregamento, o arquivo é processado e os marcadores `[exclude_object]` são adicionados ao arquivo. Alternativamente, os fatiadores podem ser configurados para preparar os marcadores de exclusão de objeto nativamente, ou em seu próprio passo de pré-processamento.
1. Quando a impressão começa, o Klipper irá resetar o status do `[exclude_object]` [status](Status_Reference.md#exclude_object).
1. Quando o Klipper processa o bloco `EXCLUDE_OBJECT_DEFINE`, ele irá atualizar o status com os objetos conhecidos e passá-lo para os clientes.
1. O cliente pode usar essas informações para apresentar uma UI ao usuário para que o progresso possa ser rastreado. O Klipper irá atualizar o status para incluir o objeto que está sendo impresso no momento, que o cliente pode usar para fins de exibição.
1. Se o usuário solicitar que um objeto seja cancelado, o cliente emitirá um comando `EXCLUDE_OBJECT NAME=<nome>` para o Klipper.
1. Quando o Klipper processa o comando, ele adicionará o objeto à lista de objetos excluídos e atualizará o status para o cliente.
1. O cliente receberá o status atualizado do Klipper e poderá usar essas informações para refletir o status do objeto na UI (interface do usuário).
1. Quando a impressão terminar, o status do `[exclude_object]` continuará disponível até que outra ação o resete.

## O arquivo GCode

O processamento especializado de gcode necessário para suportar a exclusão de objetos não se enquadra nos objetivos centrais de design do Klipper. Portanto, este módulo requer que o arquivo seja processado antes de ser enviado para o Klipper para impressão. Usar um script de pós-processamento no fatiador ou ter um middleware processando o arquivo no upload são duas possibilidades para preparar o arquivo para o Klipper. Um script de pós-processamento de referência está disponível tanto como um executável quanto uma biblioteca python, veja [cancelobject-preprocessor](https://github.com/kageurufu/cancelobject-preprocessor).

### Definições de objetos

O comando `EXCLUDE_OBJECT_DEFINE` é usado para fornecer um resumo de cada objeto no arquivo gcode a ser impresso. Fornece um resumo de um objeto no arquivo. Objetos não precisam ser definidos para serem referenciados por outros comandos. O objetivo principal deste comando é fornecer informações para a UI sem a necessidade de analisar todo o arquivo gcode.

As definições de objeto são nomeadas, para permitir que os usuários selecionem facilmente um objeto para ser excluído, e metadados adicionais podem ser fornecidos para permitir exibições gráficas de cancelamento. Os metadados definidos atualmente incluem uma coordenada `CENTER` X,Y, e uma lista `POLYGON` de pontos X,Y representando um contorno mínimo do objeto. Isso pode ser uma simples caixa delimitadora, ou um casco complicado para mostrar visualizações mais detalhadas dos objetos impressos. Especialmente quando os arquivos gcode incluem várias partes com regiões delimitadoras sobrepostas, os pontos centrais se tornam difíceis de distinguir visualmente. `POLYGONS` deve ser um array compatível com json de pontos `[X,Y]` sem espaços em branco. Parâmetros adicionais serão salvos como strings na definição do objeto e fornecidos em atualizações de status.

`EXCLUDE_OBJECT_DEFINE NAME=calibration_pyramid CENTER=50,50 POLYGON=[[40,40],[50,60],[60,40]]`

All available G-Code commands are documented in the [G-Code
Reference](./G-Codes.md#excludeobject)

## Informações de status

The state of this module is provided to clients by the [exclude_object
status](Status_Reference.md#exclude_object).

O status é reiniciado quando:

- O firmware do Klipper é reiniciado.
- Há um reset do `[virtual_sdcard]`. Notavelmente, este é reiniciado pelo Klipper no início de uma impressão.
- Quando um comando `EXCLUDE_OBJECT_DEFINE RESET=1` é emitido.

A lista de objetos definidos é representada no campo de status `exclude_object.objects`. Em um arquivo gcode bem definido, isso será feito com comandos `EXCLUDE_OBJECT_DEFINE` no início do arquivo. Isso fornecerá aos clientes nomes de objetos e coordenadas para que a UI possa fornecer uma representação gráfica dos objetos, se desejado.

Conforme a impressão avança, o campo de status `exclude_object.current_object` será atualizado à medida que o Klipper processa os comandos `EXCLUDE_OBJECT_START` e `EXCLUDE_OBJECT_END`. O campo `current_object` será definido mesmo se o objeto tiver sido excluído. Objetos indefinidos marcados com um `EXCLUDE_OBJECT_START` serão adicionados aos objetos conhecidos para ajudar nas dicas da UI, sem nenhum metadado adicional.

Conforme os comandos `EXCLUDE_OBJECT` são emitidos, a lista de objetos excluídos é fornecida no array `exclude_object.excluded_objects`. Como o Klipper olha para frente para processar o gcode que está por vir, pode haver um atraso entre quando o comando é emitido e quando o status é atualizado.
