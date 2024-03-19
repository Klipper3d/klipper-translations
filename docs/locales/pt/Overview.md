# Visão geral

Bem- vindo a documentação do Klipper, comece com os documentos [features](Features.md) e [installation](Installation.md) .

## Visão geral

- [Funcionalidades](Features.md) Uma lista de alto nível das funcionalidades do Klipper.
- [FAQ](FAQ.md): Questões frequentes perguntadas.
- [Versões](Releases.md): Histórico de versões do Klipper.
- [Alterações de Configuração](Config_Changes.md): Atualizações recentes ao software que podem precisar que os utilizadores atualizem o ficheiro de configuração da sua impressora.
- [Contactos](Contact.md): Informação sobre denúncia de bugs e comunicação geral com os desenvolvedores do Klipper.

## Instalação e configuração

- [Instalação](Installation.md): Guia de instalação do Klipper.
- [Referência de configuração](Config_Reference.md): Descrição de parâmetros de configuração.
   - [Rotation Distance](Rotation_Distance.md): Calculando o parâmetro stepper rotation_distance.
- [Config checks](Config_checks.md): Verifique as configurações básicas dos pinos no arquivo de configuração.
- [Bed level](Bed_Level.md): Informações sobre "nivelamento da mesa" no Klipper.
   - [Delta calibrate](Delta_Calibrate.md): Calibração de cinemática delta.
   - [Calibração da sonda](Probe_Calibrate.md): Calibração de sondas automáticas Z.
   - [BL-Touch](BLTouch.md): Configure uma sonda Z "BL-Touch".
   - [Manual level](Manual_Level.md): Calibração de Z endstops (e similares). Endstops são os sensores de final de curso.
   - [Malha de cama](Bed_Mesh.md): Correção da altura da cama baseado em coordenadas XY.
   - [Endstop phase](Endstop_Phase.md): Posicionamento do fim de curso Z assistido por motor de passo.
   - [Compensação de torção do eixo](Axis_Twist_Compensation.md): Uma ferramenta para compensar leituras imprecisas da sonda devido à torção no pórtico X.
- [Resonance compensation](Resonance_Compensation.md): Uma ferramenta para reduzir o efeito "ringing" nas impressões.
   - [Measuring resonances](Measuring_Resonances.md): Informações fornecidas pelo acelerômetro adxl345 para medir ressonância.
- [Pressure advance](Pressure_Advance.md): Calibrar a pressão do extrusor.
- [G-Codes](G-Codes.md): Informação sobre os comandos suportados pelo Klipper.
- [Modelos de comando](Command_Templates.md): Macros G-Code e avaliação condicional.
   - [Referência de estado](Status_Reference.md): Informações disponíveis para macros (e similares).
- [Controladores TMC](TMC_Drivers.md): Utilização de controladores de motor passo a passo Trinamic com Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing e sondagem utilizando vários microcontroladores.
- [Slicers](Slicers.md): Configurar o software "slicer" para o Klipper.
- [Correção de inclinação](Skew_Correction.md): Ajustes para eixos não perfeitamente quadrados.
- [Ferramentas PWM](Using_PWM_Tools.md): Guia sobre como utilizar ferramentas controladas por PWM, tais como lasers ou spindles.
- [Excluir Objeto](Exclude_Object.md): O guia para a implementação do Exclude Objects.

## Documentação para programadores

- [Visão geral do código](Code_Overview.md): Os programadores devem ler isto primeiro.
- [Cinemática](Kinematics.md): Detalhes técnicos sobre como o Klipper implementa o movimento.
- [Protocolo](Protocol.md): Informações sobre o protocolo de mensagens de baixo nível entre o anfitrião e o microcontrolador.
- [Servidor API](API_Server.md): Informação sobre a API de comando e controlo do Klipper.
- [Comandos MCU](MCU_Commands.md): Uma descrição dos comandos de baixo nível implementados no software do microcontrolador.
- [Protocolo do bus CAN](CANBUS_protocol.md): Formato de mensagem do bus CAN da Klipper.
- [Depuração](Depuração.md): Informações sobre como testar e depurar o Klipper.
- [Benchmarks](Benchmarks.md): Informações sobre o método de benchmark Klipper.
- [Contribuir](CONTRIBUTING.md): Informação sobre como submeter melhorias ao Klipper.
- [Empacotamento](Packaging.md): Informação sobre como criar pacotes de SO.

## Documentos de dispositivos específicos

- [Configurações exemplo](Example_Configs.md): Informação sobre como adicionar um ficheiro de configuração exemplo ao Klipper.
- [Atualizações por Cartão SD](SDCard_Updates.md): Escrever para um micro-controlador copiando um ficheiro binário para um cartão SD no micro-controlador.
- [Raspberry Pi como um Micro-controlador](RPi_microcontroller.md): Detalhes sobre como controlar dispositivos ligados aos pinos GPIO de um Raspberry Pi.
- [Beaglebone](Beaglebone.md): Detalhes para executar o Klipper no Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Informação para programadores sobre flashes de microcontroladores.
- [Entrada do Bootloader](Bootloader_Entry.md): Requesting the bootloader.
- [CAN bus](CANBUS.md): Informações sobre a utilização do bus CAN com o Klipper.
   - [Resolução de problemas do bus CAN](CANBUS_Troubleshooting.md): Sugestões para a resolução de problemas do bus CAN.
- [Sensor de largura do filamento TSL1401CL](TSL1401CL_Filament_Width_Sensor.md)
- [Sensor de largura do filamento Hall](Hall_Filament_Width_Sensor.md)
