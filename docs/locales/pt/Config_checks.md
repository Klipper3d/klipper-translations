# Verificações de Configuração

Esse documento fornece uma lista de passos para ajudar a confirmar as configurações de pinos no ficheiro printer.cfg do Klipper. É uma boa ideia executar esses passos após seguir o passo a passo de instalação conforme o [documento de instalação](Installation.md).

Durante este guia, talvez seja necessário fazer mudanças no ficheiro de configurações do Klipper. Certifique-se de emitir um comando de RESTART após cada mudança no ficheiro de configuração, garantindo que as mudanças tenham efeito (digite "restart" na aba do terminal do Octoprint e clique em "Send"). Também é uma boa ideia de emitir um comando STATUS depois de todas as reinicializações, para verificar se o ficheiro de configurações foi carregado corretamente.

## Verificar temperatura

Comece verificando se a temperatura começou a ser reportada corretamente. Navegue até a aba de temperatura Octoprint.

![temperatura-no-octoprint](img/octoprint-temperature.png)

Verificar se a temperatura do bocal e da base(se aplicável) estão presentes e não subindo. Se estiver subindo, remover a energia da impressora. Se a temperatura não estiver exata, reveja as configurações de "sensor_tipo" e "sensor_pino" do bocal e/ou da base.

## Verificar M112

Navegue até a aba do terminal do Octoprint e emita um comando M112 na caixa do terminal. Este comando solicita que o Klipper entre em um estado de "desligamento", fazendo com que o Octoprint desconecte do Klipper - navegue ate a área "Connection" e clique em "Connect" para reconectar o Octoprint. Então navegue até a aba de temperatura do Octoprint e verifique se a temperatura continua a atualizar e não esta subindo. Se a temperatura estiver subindo, remova a impressora da tomada.

O comando M112 fará com que o Klipper entre em modo de "desligamento". Para desfazer, emita um comando FIRMWARE_RESTART na aba do terminal do Octoprint.

## Verificar aquecedores

Navegue até a aba temperatura do Octoprint e na caixa de temperatura "Ferramenta", digite 50 e tecle em Enter. No gráfico a temperatura da extrusora deverá começar a aumentar (dentro de cerca de 30 segundos ou mais). Em seguida, selecione "Desligar" na caixa suspensa de temperatura em "Ferramenta". Após vários minutos, a temperatura deverá retornar ao seu valor inicial, na temperatura ambiente. Se a temperatura não aumentar, verifique a configuração "heater_pin".

Se a impressora tiver uma base aquecida, efetue o procedimento com descrito no teste acima com a base.

## Verifique o pino de ativação do motor de passo

Verifique se todos os eixos da impressora podem se mover livremente com a mão (os motores de passo estão desativados). Se não, emita um comando M84 para desativar os motores. Se algum dos eixos ainda não puder se mover livremente, verifique a configuração do "enable_pin" do motor de passo para o eixo em questão. Na maioria dos drivers de motor de passo comuns, o pino de habilitação do motor é "ativo baixo" e, portanto, o pino de habilitação deve ter um "!" antes do pino (por exemplo, "enable_pin: !ar38").

## Verique os fins de curso

Mova manualmente todos os eixos da impressora para que nenhum deles esteja em contato com um fim de curso. Envie um comando QUERY_ENDSTOPS através da aba do terminal Octoprint. Ele deve responder com o estado atual de todos os fins de curso configurados e todos devem relatar um estado de "aberto". Para cada um dos fins de curso, execute novamente o comando QUERY_ENDSTOPS enquanto aciona manualmente o fim de curso. O comando QUERY_ENDSTOPS deve relatar o fim de curso como "ACIONADO".

Se o fim de curso parecer invertido (ele relata "aberto" quando acionado e vice-versa), então adicione um "!" à definição do pino (por exemplo, "endstop_pin: ^!ar3"), ou remova o "!" se já houver um presente.

Se o fim de curso não mudar, geralmente indica que o fim de curso está conectado a um pino diferente. No entanto, também pode exigir uma alteração na configuração de pullup do pino (o '^' no início do nome do endstop_pin - a maioria das impressoras usará um resistor de pullup e o '^' deve estar presente).

## Verifique motores de passo

Use o comando STEPPER_BUZZ para verificar a conectividade de cada motor de passo. Comece posicionando manualmente o eixo desejado a um ponto intermediário e então execute `STEPPER_BUZZ STEPPER=stepper_x`. O comando STEPPER_BUZZ fará com que o motor de passo se mova um milímetro em uma direção positiva e então ele retornará à sua posição inicial. (Se o fim de curso for definido em position_endstop=0, então no início de cada movimento o motor de passo se afastará do fim de curso.) Ele realizará essa oscilação dez vezes.

Se o motor de passo não se mover, verifique as configurações de "enable_pin" e "step_pin" para o motor de passo. Se o motor de passo se mover mas não retornar à sua posição original, verifique a configuração de "dir_pin". Se o motor de passo oscilar em uma direção incorreta, geralmente indica que o "dir_pin" para o eixo precisa ser invertido. Isso é feito adicionando um '!' ao "dir_pin" no arquivo de configuração da impressora (ou removendo-o se já houver um lá). Se o motor se mover significativamente mais ou significativamente menos que um milímetro, então verifique a configuração de "rotation_distance".

Execute o teste acima para cada motor de passo definido no arquivo de configuração. (Defina o parâmetro STEPPER do comando STEPPER_BUZZ para o nome da seção de configuração que será testada.) Se não houver filamento no extrusor, é possível usar o STEPPER_BUZZ para verificar a conectividade do motor do extrusor (use STEPPER=extruder). Caso contrário, é melhor testar o motor do extrusor separadamente (veja a próxima seção).

Após verificar todos os fins de curso e verificar todos os motores de passo, o mecanismo de referência deve ser testado. Emita um comando G28 para referenciar todos os eixos. Remova a energia da impressora se ela não se referenciar corretamente. Execute novamente os passos de verificação do fim de curso e do motor de passo, se necessário.

## Verificar motor de exclusão

Para testar o motor do extrusor, será necessário aquecer o extrusor até a temperatura de impressão. Navegue até a aba de temperatura do Octoprint e selecione uma temperatura alvo na caixa de seleção de temperatura (ou insira manualmente uma temperatura apropriada). Aguarde a impressora atingir a temperatura desejada. Em seguida, navegue até a aba de controle do Octoprint e clique no botão "Extrude". Verifique se o motor do extrusor gira na direção correta. Se não girar, consulte as dicas de solução de problemas na seção anterior para confirmar as configurações de "enable_pin", "step_pin" e "dir_pin" para o extrusor.

## Calibrar configurações PID

O Klipper suporta o [controle PID](https://en.wikipedia.org/wiki/PID_controller) para os aquecedores do extrusor e da cama. Para utilizar este mecanismo de controle, é necessário calibrar as configurações PID em cada impressora (as configurações PID encontradas em outros firmwares ou nos arquivos de configuração de exemplo muitas vezes funcionam mal).

Para calibrar o extrusor, navegue até a aba de terminal do OctoPrint e execute o comando PID_CALIBRATE. Por exemplo: `PID_CALIBRATE HEATER=extruder TARGET=170`

Ao concluir o teste de calibração, execute `SAVE_CONFIG` para atualizar o arquivo printer.cfg com as novas configurações de PID.

Se a impressora possui uma cama aquecida e ela suporta ser controlada por PWM (Modulação por Largura de Pulso), então é recomendado usar o controle PID para a cama. (Quando o aquecedor da cama é controlado usando o algoritmo PID, ele pode ligar e desligar dez vezes por segundo, o que pode não ser adequado para aquecedores que usam uma chave mecânica.) Um comando típico de calibração PID da cama é: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Próximos passos

Este guia tem como objetivo ajudar na verificação básica das configurações de pinos no arquivo de configuração do Klipper. Certifique-se de ler o guia de [nivelamento da cama](Bed_Level.md). Veja também o documento [Fatiadores](Slicers.md) para informações sobre como configurar um fatiador com o Klipper.

Depois de verificar que a impressão básica funciona, é uma boa ideia considerar a calibração do [avanço de pressão](Pressure_Advance.md).

Pode ser necessário realizar outros tipos de calibração detalhada da impressora - existem vários guias disponíveis online para ajudar com isso (por exemplo, faça uma pesquisa na web por "calibração de impressora 3D"). Como exemplo, se você experimentar o efeito chamado 'ringing', você pode tentar seguir o guia de ajuste de [resonance compensation](Resonance_Compensation.md).
