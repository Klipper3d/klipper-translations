# Verificações de Configuração

Esse documento fornece uma lista de passos para ajudar a confirmar as configurações de pinos no ficheiro printer.cfg do Klipper. É uma boa ideia executar esses passos após seguir o passo a passo de instalação conforme o [documento de instalação](Installation.md).

Durante este guia, talvez seja necessário fazer mudanças no ficheiro de configurações do Klipper. Certifique-se de emitir um comando de RESTART após cada mudança no ficheiro de configuração, garantindo que as mudanças tenham efeito (digite "restart" na aba do terminal do Octoprint e clique em "Send"). Também é uma boa ideia de emitir um comando STATUS depois de todas as reinicializações, para verificar se o ficheiro de configurações foi carregado corretamente.

## Verificar temperatura

Comece por verificar se as temperaturas estão a ser corretamente comunicadas. Navegue até à secção do gráfico de temperatura na interface do utilizador. Verifique se a temperatura do bocal e da base (se aplicável) está presente e não está a aumentar. Se estiver a aumentar, desligue a impressora. Se as temperaturas não forem exatas, reveja as definições "sensor_type" e "sensor_pin" do bocal e/ou da base.

## Verificar M112

Navegue para a consola de comando e emita um comando M112 na caixa de terminal. Este comando pede ao Klipper para entrar num estado de "encerramento". Isto provocará um erro que pode ser apagado com um comando FIRMWARE_RESTART na consola de comando. O Octoprint também requererá uma nova ligação. Depois navegue para a secção do gráfico de temperatura e verifique que as temperaturas continuam a ser atualizadas e não estão a aumentar. Se as temperaturas estão a aumentar, desligue a impressora.

## Verificar aquecedores

Navegue até à secção do gráfico de temperatura e escreva 50 seguido de enter na caixa de temperatura da extrusora/ferramenta. A temperatura da extrusora no gráfico deve começar a aumentar (em cerca de 30 segundos). Em seguida, vá para a caixa pendente da temperatura da extrusora e seleccione "Off". Após alguns minutos, a temperatura deve começar a regressar ao seu valor inicial de temperatura ambiente. Se a temperatura não aumentar, verifique a definição "heater_pin" na configuração.

Se a impressora tiver uma base aquecida, efetue o procedimento com descrito no teste acima com a base.

## Verifique o pino de ativação do motor de passo

Verificar se todos os eixos da impressora podem mover-se livremente (os motores de passo estão desativados). Caso contrário, emitir um comando M84 para desativar os motores. Se algum dos eixos continuar a não se poder mover livremente, verifique a configuração do "pino de ativação" do passo para o eixo em causa. Na maioria dos controladores de motores passo a passo, o pino de ativação do motor é "ativo baixo", pelo que o pino de ativação deve ter um "!" antes do pino (por exemplo, "enable_pin: !PA1").

## Verique os fins de curso

Deslocar manualmente todos os eixos da impressora de modo a que nenhum deles esteja em contacto com um fim de curso. Enviar um comando QUERY_ENDSTOPS através da consola de comando. Deve responder com o estado atual de todos os fins de curso configurados e todos eles devem reportar um estado de "aberto". Para cada uma das paragens finais, execute novamente o comando QUERY_ENDSTOPS enquanto acciona manualmente a paragem final. O comando QUERY_ENDSTOPS deve reportar o fim de curso como "TRIGGERED".

Se o fim de curso aparecer invertido (reporta "aberto" quando acionado e vice-versa), adicione um "!" à definição do pino (por exemplo, "endstop_pin: ^PA2"), ou remova o "!" se já existir um.

Se o fim de curso não mudar, geralmente indica que o fim de curso está conectado a um pino diferente. No entanto, também pode exigir uma alteração na configuração de pullup do pino (o '^' no início do nome do endstop_pin - a maioria das impressoras usará um resistor de pullup e o '^' deve estar presente).

## Verifique motores de passo

Utilize o comando STEPPER_BUZZ para verificar a conetividade de cada motor de passo. Comece por posicionar manualmente o eixo dado num ponto intermédio e depois execute `STEPPER_BUZZ STEPPER=stepper_x` na consola de comandos. O comando STEPPER_BUZZ fará com que o motor passo a passo dado se mova um milímetro numa direção positiva e depois voltará à sua posição inicial. (Se a paragem final for definida em posição_paragem_final=0, então no início de cada movimento o motor de passo irá afastar-se da paragem final). Esta oscilação será efetuada dez vezes.

Se o motor de passo não se mover, verifique as configurações de "enable_pin" e "step_pin" para o motor de passo. Se o motor de passo se mover mas não retornar à sua posição original, verifique a configuração de "dir_pin". Se o motor de passo oscilar em uma direção incorreta, geralmente indica que o "dir_pin" para o eixo precisa ser invertido. Isso é feito adicionando um '!' ao "dir_pin" no arquivo de configuração da impressora (ou removendo-o se já houver um lá). Se o motor se mover significativamente mais ou significativamente menos que um milímetro, então verifique a configuração de "rotation_distance".

Execute o teste acima para cada motor de passo definido no arquivo de configuração. (Defina o parâmetro STEPPER do comando STEPPER_BUZZ para o nome da seção de configuração que será testada.) Se não houver filamento no extrusor, é possível usar o STEPPER_BUZZ para verificar a conectividade do motor do extrusor (use STEPPER=extruder). Caso contrário, é melhor testar o motor do extrusor separadamente (veja a próxima seção).

Após verificar todos os fins de curso e verificar todos os motores de passo, o mecanismo de referência deve ser testado. Emita um comando G28 para referenciar todos os eixos. Remova a energia da impressora se ela não se referenciar corretamente. Execute novamente os passos de verificação do fim de curso e do motor de passo, se necessário.

## Verificar motor de exclusão

Para testar o motor da extrusora, será necessário aquecer a extrusora a uma temperatura de impressão. Navegue até à secção do gráfico de temperatura e selecione uma temperatura alvo na caixa pendente de temperatura (ou introduza manualmente uma temperatura adequada). Aguarde que a impressora atinja a temperatura pretendida. Em seguida, navegue até à consola de comandos e clique no botão "Extrude". Verifique se o motor da extrusora roda na direção correcta. Se isso não acontecer, consulte as sugestões de resolução de problemas na secção anterior para confirmar as definições "enable_pin", "step_pin" e "dir_pin" para a extrusora.

## Calibrar configurações PID

O Klipper suporta o [controle PID](https://en.wikipedia.org/wiki/PID_controller) para os aquecedores do extrusor e da cama. Para utilizar este mecanismo de controle, é necessário calibrar as configurações PID em cada impressora (as configurações PID encontradas em outros firmwares ou nos arquivos de configuração de exemplo muitas vezes funcionam mal).

Para calibrar a extrusora, navegar para a consola de comandos e executar o comando PID_CALIBRATE. Por exemplo: `PID_CALIBRATE HEATER=extruder TARGET=170`

Ao concluir o teste de calibração, execute `SAVE_CONFIG` para atualizar o arquivo printer.cfg com as novas configurações de PID.

Se a impressora possui uma cama aquecida e ela suporta ser controlada por PWM (Modulação por Largura de Pulso), então é recomendado usar o controle PID para a cama. (Quando o aquecedor da cama é controlado usando o algoritmo PID, ele pode ligar e desligar dez vezes por segundo, o que pode não ser adequado para aquecedores que usam uma chave mecânica.) Um comando típico de calibração PID da cama é: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Próximos passos

Este guia tem como objetivo ajudar na verificação básica das configurações de pinos no arquivo de configuração do Klipper. Certifique-se de ler o guia de [nivelamento da cama](Bed_Level.md). Veja também o documento [Fatiadores](Slicers.md) para informações sobre como configurar um fatiador com o Klipper.

Depois de verificar que a impressão básica funciona, é uma boa ideia considerar a calibração do [avanço de pressão](Pressure_Advance.md).

Pode ser necessário realizar outros tipos de calibração detalhada da impressora - existem vários guias disponíveis online para ajudar com isso (por exemplo, faça uma pesquisa na web por "calibração de impressora 3D"). Como exemplo, se você experimentar o efeito chamado 'ringing', você pode tentar seguir o guia de ajuste de [resonance compensation](Resonance_Compensation.md).
