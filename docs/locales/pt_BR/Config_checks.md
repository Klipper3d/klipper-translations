# Verificações de configuração

Este documento fornece uma lista de etapas que ajudam a confirmar as configurações de pinos no arquivo printer.cfg do Klipper. É uma boa idéia executar essas etapas logo após seguir o passos do [documento de instalação](Installation.md).

Durante este guia, pode ser necessário fazer alterações no arquivo de configuração do Klipper. Certifique-se de enviar um comando RESTART após cada alteração no arquivo de configuração, para garantir que a alteração tenha efeito (digite "restart" na aba terminal do Octoprint e clique em "Enviar" ou "Send"). Também é uma boa ideia enviar um comando STATUS após cada RESTART para verificar se o arquivo de configuração foi carregado corretamente.

## Verifique a temperatura

Comece verificando se as temperaturas estão sendo relatadas corretamente. Navegue até a aba temperatura do Octoprint.

![temperatura-no-octoprint](img/octoprint-temperature.png)

Verifique se a temperatura do bico e da base (se aplicável) estão presentes e se não estão aumentando. Se estiver aumentando, desligue a impressora. Se as temperaturas não forem precisas, revise as configurações de "sensor_type" e "sensor_pin" para o bico e/ou base.

## Verificar o M112

Navegue até a aba terminal do Octoprint e envie o comando M112 na caixa do terminal. Este comando irá solicitar ao Klipper para que entre em estado de "desligamento" e isso fará com que o Octoprint se desconecte do Klipper. Navegue até a área de conexão e clique em "Conectar" para que o Octoprint se reconecte. Em seguida, navegue até a aba temperatura do Octoprint e verifique se as temperaturas continuam sendo atualizadas e se não estão aumentando. Se as temperaturas estiverem aumentando, desligue a impressora.

O comando M112 faz com que o Klipper entre um estado de "desligamento". Para sair deste estado, execute o comando FIRMWARE_RESTART na aba terminal do Octoprint.

## Verifique os aquecedores

Navegue até a aba temperatura do Octoprint e na caixa de temperatura "Ferramenta", digite 50 e tecle em enter. No gráfico a temperatura da extrusora deverá começar a aumentar (aguarde por volta de 30 segundos ou mais). Em seguida, selecione "Desligar" ao lado da caixa suspensa de temperatura "Ferramenta". Após vários minutos, a temperatura deverá retornar ao seu valor inicial, na temperatura ambiente. Se a temperatura não aumentar, verifique a configuração "heater_pin".

Se a impressora tiver uma base aquecida, efetue o procedimento com descrito no teste acima com a base.

## Verifique o pino de ativação do motor de passo

Verifique se todos os eixos da impressora podem ser movido livremente com as mãos (os motores de passo precisam estar desabilitados). Se não estiverem, execute o comando M84 para desabilitá-los. Se algum eixo ainda não puder ser movido livremente, verifique a configuração de "enable_pin" do motor de passo do o eixo em questão. Na maioria dos drivers de motor de passo convencionais, o pino de ativação do motor tem "sinal invertido" (ou "active low"em inglês) e, portanto, o pino de ativação deve ter uma "!" antes do pino (por exemplo, "enable_pin: !ar38").

## Verique os fins de curso

Mova com as mãos todos os eixos da impressora para que nenhum deles entre em contato com a chave de fim de curso. Execute o comando QUERY_ENDSTOPS por meio do terminal do Octoprint. Ele deve responder com o estado atual de todos as chaves de fim de curso configuradas e todos eles devem constar como "OPEN". Para cada uma das chaves de fim de curso, acione-o manualmente e em seguida execute o comando QUERY_ENDSTOPS. O comando QUERY_ENDSTOPS deverá retornar "TRIGGERED".

Se a chave de fim de curso parecer invertido (retornar "OPEN" quando acionado e vice-versa), adicione um "!" à configuração de pino (por exemplo, "endstop_pin: ^!ar3") ou remova o "!" se já houver um na configuração.

Se o fim de curso não mudar de estado, pode indicar que a chave de fim de curso está conectada a um pino diferente. No entanto, também pode exigir uma alteração na configuração "pullup" do pino (o '^' no início do nome endstop_pin - a maioria das impressoras usará um resistor "pullup" e o '^' deve estar presente).

## Verifique os motores de passo

Use o comando STEPPER_BUZZ para verificar a conectividade de cada motor de passo. Comece posicionando manualmente o eixo dado em um ponto intermediário e então execute `STEPPER_BUZZ STEPPER = stepper_x` no terminal. O comando STEPPER_BUZZ fará com que o motor de passo solicitado se mova um milímetro em uma direção positiva e então ele retornará à sua posição inicial. (Se o fim de curso estiver definido em position_endstop=0, então, no início de cada movimento, o stepper se afastará do fim de curso). Essa oscilação será executada dez vezes.

Se o motor de passo não se mover, verifique as configurações "enable_pin" e "step_pin" do motor. Se o motor de passo se mover, mas não retornar à sua posição original, verifique a configuração de "dir_pin". Se o motor de passo oscilar em uma direção incorreta, geralmente indica que o "dir_pin" do eixo precisa ser invertido. Isso é feito adicionando um '!' ao "dir_pin" no arquivo de configuração da impressora (ou removendo-o se já houver um). Se o motor se mover significativamente mais ou significativamente menos do que um milímetro, verifique a configuração de "rotation_distance".

Execute o teste acima para cada um dos motores de passo definido no arquivo de configuração. (Defina o parâmetro STEPPER do comando STEPPER_BUZZ com o nome da seção de configuração que deve ser testada). Se não houver filamento na extrusora, poderá usar STEPPER_BUZZ para verificar a conectividade do motor da extrusora (use STEPPER=extruder). Caso contrário, é melhor testar o motor da extrusora separadamente (consulte a próxima seção).

Depois de verificar todos os finais de curso e verificar todos os motores de passo, o mecanismo de homing deverá ser testado. Execute o comando G28 para enviar todos os eixos para a posição inicial. Desligue energia da impressora se ela funcionar erraticamente. Se necessário, execute novamente as etapas de verificação de fim de curso e do motor de passo.

## Verifique o motor da extrusora

Para testar o motor da extrusora, será necessário aquecer o bico até a temperatura de impressão. Navegue até a guia de temperatura do Octoprint e selecione uma temperatura adequada para o filamento na caixa suspensa de temperatura (ou insira manualmente uma temperatura apropriada). Aguarde até que a impressora alcance a temperatura desejada. Em seguida, navegue até a guia de controle Octoprint e clique no botão "Extrudar". Verifique se o motor da extrusora gira na direção correta. Caso contrário, consulte as dicas de solução de problemas na seção anterior para confirmar as configurações de "enable_pin", "step_pin" e "dir_pin" para a extrusora.

## Calibrar configurações de PID

O Klipper suporta [controle de PID](https://en.wikipedia.org/wiki/PID_controller) para os aquecedores da extrusora e da base. Para usar este mecanismo de controle, é necessário calibrar as configurações de PID em cada impressora (as configurações de PID encontradas em outros firmwares ou nos arquivos de configuração de exemplo podem não funcionar adequadamente).

Para calibrar a extrusora, navegue até a aba de terminal do OctoPrint e execute o comando PID_CALIBRATE. Por exemplo: `PID_CALIBRATE HEATER=extrusor TARGET=170`

Ao concluir o teste de ajuste, execute `SAVE_CONFIG` para atualizar o arquivo printer.cfg com as novas configurações de PID.

Se a impressora tiver uma base aquecida e for compatível com o acionamento por PWM (Pulse Width Modulation, ou modulação por largura de pulso em português), é recomendável usar o controle PID para a base. (Quando o aquecedor da base é controlado usando o algoritmo PID, ele pode ligar e desligar dez vezes por segundo, o que pode não ser adequado para aquecedores que usam um interruptor mecânico). Na maioria dos casos o comando para calibração PID da base é: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Próximos passos

Este guia tem como objetivo ajudar na verificação básica das configurações dos pinos no arquivo de configuração do Klipper. Certifique-se de ler o guia [nivelamento da base](Bed_Level.md). Consulte também o documento [Fatiadores](Slicers.md) para obter informações sobre como configurar apropriadamente um fatiador (ou slicer, em inglês) com Klipper.

Depois de verificar se o básico da impressão funciona, é uma boa ideia considerar a calibração [avanço da pressão (pressure advance, em inglês)](Pressure_Advance.md).

Pode ser necessário realizar outros tipos de calibração detalhada da impressora - vários guias estão disponíveis online para ajudar lhe com isso (por exemplo, faça uma pesquisa na web por "calibração da impressora 3D" ou "3d printer calibration"). Por exemplo, se você perceber o efeito chamado "ringing" (também conhecido como “ghosting” ou “ripples”), você pode tentar seguir o guia de ajuste [compensação de ressonância (resonance compensation, em inglês)](Resonance_Compensation.md).
