# Verificações de Configuração

Esse documento fornece uma lista de passos para ajudar a confirmar as configurações de pinos no ficheiro printer.cfg do Klipper. É uma boa ideia executar esses passos após seguir o passo a passo de instalação conforme o [documento de instalação](Installation.md).

Durante este guia, talvez seja necessário fazer mudanças no ficheiro de configurações do Klipper. Certifique-se de emitir um comando de RESTART após cada mudança no ficheiro de configuração, garantindo que as mudanças tenham efeito (digite "restart" na aba do terminal do Octoprint e clique em "Send"). Também é uma boa ideia de emitir um comando STATUS depois de todas as reinicializações, para verificar se o ficheiro de configurações foi carregado corretamente.

## Verificar temperatura

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Verificar M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Verificar aquecedores

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Se a impressora tiver uma base aquecida, efetue o procedimento com descrito no teste acima com a base.

## Verifique o pino de ativação do motor de passo

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Verique os fins de curso

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Se o fim de curso não mudar, geralmente indica que o fim de curso está conectado a um pino diferente. No entanto, também pode exigir uma alteração na configuração de pullup do pino (o '^' no início do nome do endstop_pin - a maioria das impressoras usará um resistor de pullup e o '^' deve estar presente).

## Verifique motores de passo

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Se o motor de passo não se mover, verifique as configurações de "enable_pin" e "step_pin" para o motor de passo. Se o motor de passo se mover mas não retornar à sua posição original, verifique a configuração de "dir_pin". Se o motor de passo oscilar em uma direção incorreta, geralmente indica que o "dir_pin" para o eixo precisa ser invertido. Isso é feito adicionando um '!' ao "dir_pin" no arquivo de configuração da impressora (ou removendo-o se já houver um lá). Se o motor se mover significativamente mais ou significativamente menos que um milímetro, então verifique a configuração de "rotation_distance".

Execute o teste acima para cada motor de passo definido no arquivo de configuração. (Defina o parâmetro STEPPER do comando STEPPER_BUZZ para o nome da seção de configuração que será testada.) Se não houver filamento no extrusor, é possível usar o STEPPER_BUZZ para verificar a conectividade do motor do extrusor (use STEPPER=extruder). Caso contrário, é melhor testar o motor do extrusor separadamente (veja a próxima seção).

Após verificar todos os fins de curso e verificar todos os motores de passo, o mecanismo de referência deve ser testado. Emita um comando G28 para referenciar todos os eixos. Remova a energia da impressora se ela não se referenciar corretamente. Execute novamente os passos de verificação do fim de curso e do motor de passo, se necessário.

## Verificar motor de exclusão

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Calibrar configurações PID

O Klipper suporta o [controle PID](https://en.wikipedia.org/wiki/PID_controller) para os aquecedores do extrusor e da cama. Para utilizar este mecanismo de controle, é necessário calibrar as configurações PID em cada impressora (as configurações PID encontradas em outros firmwares ou nos arquivos de configuração de exemplo muitas vezes funcionam mal).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

Ao concluir o teste de calibração, execute `SAVE_CONFIG` para atualizar o arquivo printer.cfg com as novas configurações de PID.

Se a impressora possui uma cama aquecida e ela suporta ser controlada por PWM (Modulação por Largura de Pulso), então é recomendado usar o controle PID para a cama. (Quando o aquecedor da cama é controlado usando o algoritmo PID, ele pode ligar e desligar dez vezes por segundo, o que pode não ser adequado para aquecedores que usam uma chave mecânica.) Um comando típico de calibração PID da cama é: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Próximos passos

Este guia tem como objetivo ajudar na verificação básica das configurações de pinos no arquivo de configuração do Klipper. Certifique-se de ler o guia de [nivelamento da cama](Bed_Level.md). Veja também o documento [Fatiadores](Slicers.md) para informações sobre como configurar um fatiador com o Klipper.

Depois de verificar que a impressão básica funciona, é uma boa ideia considerar a calibração do [avanço de pressão](Pressure_Advance.md).

Pode ser necessário realizar outros tipos de calibração detalhada da impressora - existem vários guias disponíveis online para ajudar com isso (por exemplo, faça uma pesquisa na web por "calibração de impressora 3D"). Como exemplo, se você experimentar o efeito chamado 'ringing', você pode tentar seguir o guia de ajuste de [resonance compensation](Resonance_Compensation.md).
