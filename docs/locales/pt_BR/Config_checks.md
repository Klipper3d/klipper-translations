# Verificações de configuração

Este documento fornece uma lista de etapas que ajudam a confirmar as configurações de pinos no arquivo printer.cfg do Klipper. É uma boa idéia executar essas etapas logo após seguir o passos do [documento de instalação](Installation.md).

Durante este guia, pode ser necessário fazer alterações no arquivo de configuração do Klipper. Certifique-se de enviar um comando RESTART após cada alteração no arquivo de configuração, para garantir que a alteração tenha efeito (digite "restart" na aba terminal do Octoprint e clique em "Enviar" ou "Send"). Também é uma boa ideia enviar um comando STATUS após cada RESTART para verificar se o arquivo de configuração foi carregado corretamente.

## Verifique a temperatura

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Verificar o M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Verifique os aquecedores

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Se a impressora tiver uma base aquecida, efetue o procedimento com descrito no teste acima com a base.

## Verifique o pino de ativação do motor de passo

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Verique os fins de curso

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Se o fim de curso não mudar de estado, pode indicar que a chave de fim de curso está conectada a um pino diferente. No entanto, também pode exigir uma alteração na configuração "pullup" do pino (o '^' no início do nome endstop_pin - a maioria das impressoras usará um resistor "pullup" e o '^' deve estar presente).

## Verifique os motores de passo

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Se o motor de passo não se mover, verifique as configurações "enable_pin" e "step_pin" do motor. Se o motor de passo se mover, mas não retornar à sua posição original, verifique a configuração de "dir_pin". Se o motor de passo oscilar em uma direção incorreta, geralmente indica que o "dir_pin" do eixo precisa ser invertido. Isso é feito adicionando um '!' ao "dir_pin" no arquivo de configuração da impressora (ou removendo-o se já houver um). Se o motor se mover significativamente mais ou significativamente menos do que um milímetro, verifique a configuração de "rotation_distance".

Execute o teste acima para cada um dos motores de passo definido no arquivo de configuração. (Defina o parâmetro STEPPER do comando STEPPER_BUZZ com o nome da seção de configuração que deve ser testada). Se não houver filamento na extrusora, poderá usar STEPPER_BUZZ para verificar a conectividade do motor da extrusora (use STEPPER=extruder). Caso contrário, é melhor testar o motor da extrusora separadamente (consulte a próxima seção).

Depois de verificar todos os finais de curso e verificar todos os motores de passo, o mecanismo de homing deverá ser testado. Execute o comando G28 para enviar todos os eixos para a posição inicial. Desligue energia da impressora se ela funcionar erraticamente. Se necessário, execute novamente as etapas de verificação de fim de curso e do motor de passo.

## Verifique o motor da extrusora

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Calibrar configurações de PID

Klipper suporta o [controlador PID](https://pt.wikipedia.org/wiki/Controlador_proporcional_integral_derivativo) para a extrusora e aquecedores de cama. Para usar este mecanismo de controle, é necessário calibrar as configurações PID em cada impressora (configurações PID encontradas em outros firmwares ou nos arquivos de configuração de exemplo muitas vezes funcionam mal).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

Ao concluir o teste de ajuste, execute `SAVE_CONFIG` para atualizar o arquivo printer.cfg com as novas configurações de PID.

Se a impressora tiver uma base aquecida e for compatível com o acionamento por PWM (Pulse Width Modulation, ou modulação por largura de pulso em português), é recomendável usar o controle PID para a base. (Quando o aquecedor da base é controlado usando o algoritmo PID, ele pode ligar e desligar dez vezes por segundo, o que pode não ser adequado para aquecedores que usam um interruptor mecânico). Na maioria dos casos o comando para calibração PID da base é: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Próximos passos

Este guia tem como objetivo ajudar na verificação básica das configurações dos pinos no arquivo de configuração do Klipper. Certifique-se de ler o guia [nivelamento da base](Bed_Level.md). Consulte também o documento [Fatiadores](Slicers.md) para obter informações sobre como configurar apropriadamente um fatiador (ou slicer, em inglês) com Klipper.

Depois de verificar se o básico da impressão funciona, é uma boa ideia considerar a calibração [avanço da pressão (pressure advance, em inglês)](Pressure_Advance.md).

Pode ser necessário realizar outros tipos de calibração detalhada da impressora - vários guias estão disponíveis online para ajudar lhe com isso (por exemplo, faça uma pesquisa na web por "calibração da impressora 3D" ou "3d printer calibration"). Por exemplo, se você perceber o efeito chamado "ringing" (também conhecido como “ghosting” ou “ripples”), você pode tentar seguir o guia de ajuste [compensação de ressonância (resonance compensation, em inglês)](Resonance_Compensation.md).
