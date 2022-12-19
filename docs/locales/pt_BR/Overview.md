# Visão geral

Bem-vindo à documentação do Klipper. Se for novo no Klipper, comece com os documentos de [recursos](Features.md) e [Instalação](Installation.md).

## Informações gerais

- [Características](Features.md): Uma lista de características de alto nível no Klipper.
- [FAQ](FAQ.md): Perguntas frequentes.
- [Lançamentos](Releases.md): O histórico de lançamentos do Klipper.
- [Alterações de configurações](Config_Changes.md): Alterações recentes de software que podem exigir que os usuários atualizem seu arquivo de configuração da impressora.
- [Contato](Contact.md): Informação sobre como reportar erros ou comunicação em geral com os desenvolvedores do Klipper.

## Instalação e configuração

- [Instalação](Installation.md): Guia de instalação do Klipper.
- [Referências para Configuração](Config_Reference.md): Descrição dos parâmetros de configuração.
   - [Distância de Rotação](Rotation_Distance.md): Como calcular o parâmetro de distância de rotação passo a passo.
- [Verificação de Configuração](Config_checks.md): Verificar as configurações básicas do PIN no arquivo de configuração.
- [Nível da cama](Bed_Level.md): Informação da "nivelação da cama" no Klipper.
   - [Calibração delta](Delta_Calibrate.md): Calibração da cinemática delta.
   - [Calibração da sonda](Probe_Calibrate.md): Calibração das sondas automáticas Z.
   - [BL-Touch](BLTouch.md): Configure uma sonda Z "BL-Touch".
   - [Nível manual](Manual_Level.md): Calibração das paradas finais de Z (e similares).
   - [Cama de Malha](Bed_Mesh.md): Correção da altura da cama baseada em coordenadas XY.
   - [Fase de fim de curso](Endstop_Phase.md): Posicionado do fim de curso de Z assistido via motor de passo.
- [Compensação de ressonância](Resonance_Compensation.md): Uma ferramenta para reduzir irregularidades nas impressões.
   - [Ressonâncias de medida](Measuring_Resonances.md): Informação sobre o uso do acelerômetro adxl345 para medir a ressonância.
- [Avançar a pressão](Pressure_Advance.md): Calibrar a pressão da extrusor.
- [G-Codes](G-Codes.md): Informações sobre comandos suportados pelo Klipper.
- [Modelos de comandos](Command_Templates.md): Macros em G-Code e avaliação condicional.
   - [Referência de Status](Status_Reference.md): Informações disponíveis para macros (e similares).
- [Drivers TMC](TMC_Drivers.md): Usando drivers Trinamic para motores de passo com o Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Posicionamento e sondagem usando vários micro-controladores.
- [Fatiadores](Slicers.md): Configuração do programa "fatiador" para o Klipper.
- [Skew correction](Skew_Correction.md): Ajustes para eixos não perfeitamente quadrados.
- [Ferramentas PWM](Using_PWM_Tools.md): Guia de como usar ferramentas de controladas por PWM tais como lasers e fusos.
- [Exclude Object](Exclude_Object.md): O guia para a implementação Exclude Objects.

## Documentação de desenvolvedor

- [Visão geral do código](Code_Overview.md): Desenvolvedor devem ler isto primeiro.
- [Cinemática](Kinematics.md): Detalhes técnicos em como o Klipper implementa movimento.
- [Protocolo](Protocol.md): Informação sobre protocolo de troca de mensagem em baixo nível entre hospedeiro e microcontrolador.
- [Servidor API](API_Server.md): Informações sobre comando e controle API do Klipper.
- [Comandos MCU](MCU_Commands.md): Uma descrição dos comandos de baixo nível implementas no software do microcontrolador.
- [Protoloco de barramento CAN](CANBUS_protocol.md): Formato de mensagens do barramento CAN.
- [Depuração](Debugging.md): Informação sobre como testar e depurar o Klipper.
- [Benchmarks](Benchmarks.md): Informação do método de medição de performance no Klipper.
- [Contribuindo](CONTRIBUTING.md): Informação sobre como enviar melhorias para o Klipper.
- [Empacotamento](Packaging.md): Informação sobre a construção de pacotes de SO.

## Documentos de Dispositivos Específicos

- [Configurações de exemplo](Example_Configs.md): Informação de como adicionar um arquivo de configuração de exemplo no Klipper.
- [Atualizações por cartão SD](SDCard_Updates.md): Programar um micro controlador via cópia de binário para um cartão SD no microcontrolador.
- [Raspberry Pi como Micro-controlador](RPi_microcontroller.md): Detalhes para controlar dispositivos cabeados a pinos GPIO de um Raspberry Pi.
- [Beaglebone](Beaglebone.md): Detalhes para executar o Klipper no Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Informações do desenvolvedor sobre o flash do microcontrolador.
- [CAN bus](CANBUS.md): Informações sobre o uso do barramento CAN com Klipper.
- [Sensor de largura de filamento TSL1401CL](TSL1401CL_Filament_Width_Sensor.md)
- [Sensor de largura de filamento Hall](Hall_Filament_Width_Sensor.md)
