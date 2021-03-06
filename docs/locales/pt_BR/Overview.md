# Overview

Bem-vindo à documentação do Klipper. Se for novo no Klipper, comece com os documentos de [recursos] (Features.md) e [Instalação] (Installation.md).

## Informações gerais

- [Características](Features.md): Uma lista de características de alto nível no Klipper.
- [FAQ](FAQ.md): Perguntas frequentes.
- [Lançamentos](Releases.md): O histórico de lançamentos do Klipper.
- [Alterações de configurações](Config_Changes.md): Alterações recentes de software que podem exigir que os usuários atualizem seu arquivo de configuração da impressora.
- [Contato](Contact.md): Informação sobre como reportar erros ou comunicação em geral com os desenvolvedores do Klipper.

## Installation and Configuration

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
   - [Endstop phase](Endstop_Phase.md): Stepper assisted Z endstop positioning.
- [Compensação de ressonância](Resonance_Compensation.md): Uma ferramenta para reduzir irregularidades nas impressões.
   - [Ressonâncias de medida](Measuring_Resonances.md): Informação sobre o uso do acelerômetro adxl345 para medir a ressonância.
- [Avançar a pressão](Pressure_Advance.md): Calibrar a pressão da extrusor.
- [G-Codes](G-Codes.md): Information on commands supported by Klipper.
- [Command Templates](Command_Templates.md): G-Code macros and conditional evaluation.
   - [Status Reference](Status_Reference.md): Information available to macros (and similar).
- [TMC Drivers](TMC_Drivers.md): Using Trinamic stepper motor drivers with Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing and probing using multiple micro-controllers.
- [Slicers](Slicers.md): Configure "slicer" software for Klipper.
- [Skew correction](Skew_Correction.md): Adjustments for axes not perfectly square.
- [PWM tools](Using_PWM_Tools.md): Guide on how to use PWM controlled tools such as lasers or spindles.
- [Exclude Object](Exclude_Object.md): The guide to the Exclude Objecs implementation.

## Developer Documentation

- [Code overview](Code_Overview.md): Developers should read this first.
- [Kinematics](Kinematics.md): Technical details on how Klipper implements motion.
- [Protocol](Protocol.md): Information on the low-level messaging protocol between host and micro-controller.
- [API Server](API_Server.md): Information on Klipper's command and control API.
- [MCU commands](MCU_Commands.md): A description of low-level commands implemented in the micro-controller software.
- [CAN bus protocol](CANBUS_protocol.md): Klipper CAN bus message format.
- [Debugging](Debugging.md): Information on how to test and debug Klipper.
- [Benchmarks](Benchmarks.md): Information on the Klipper benchmark method.
- [Contributing](CONTRIBUTING.md): Information on how to submit improvements to Klipper.
- [Packaging](Packaging.md): Information on building OS packages.

## Device Specific Documents

- [Example configs](Example_Configs.md): Information on adding an example config file to Klipper.
- [SDCard Updates](SDCard_Updates.md): Flash a micro-controller by copying a binary to an sdcard in the micro-controller.
- [Raspberry Pi as Micro-controller](RPi_microcontroller.md): Details for controlling devices wired to the GPIO pins of a Raspberry Pi.
- [Beaglebone](Beaglebone.md): Details for running Klipper on the Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Developer information on micro-controller flashing.
- [CAN bus](CANBUS.md): Information on using CAN bus with Klipper.
- [TSL1401CL filament width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](Hall_Filament_Width_Sensor.md)
