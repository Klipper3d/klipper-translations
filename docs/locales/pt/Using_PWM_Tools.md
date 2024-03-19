# Utilização de ferramentas PWM

Este documento descreve como configurar um laser ou spindle controlado por PWM utilizando `output_pin` e algumas macros.

## Como funciona?

Ao reutilizar a saída pwm da ventoinha da cabeça de impressão, pode controlar lasers ou fusos. Isto é útil se utilizar cabeças de impressão comutáveis, por exemplo, o permutador de ferramentas E3D ou uma solução DIY. Normalmente, as ferramentas de cames como o LaserWeb podem ser configuradas para usar comandos `M3-M5`, que significam *velocidade do fuso CW* (`M3 S[0-255]`), *velocidade do fuso CCW* (`M4 S[0-255]`) e *paragem do fuso* (`M5`).

**Aviso:** Ao acionar um laser, tome todas as precauções de segurança de que se possa lembrar! Os lasers de díodo são normalmente invertidos. Isto significa que, quando a MCU reinicia, o laser estará *completamente ligado* durante o tempo que a MCU demora a arrancar novamente. Para uma boa medida, recomenda-se *sempre* usar óculos de proteção contra laser adequados com o comprimento de onda correto se o laser estiver ligado; e desligar o laser quando não for necessário. Além disso, deve configurar um tempo limite de segurança, para que, quando o anfitrião ou a MCU encontrar um erro, a ferramenta pare.

Para um exemplo de configuração, consulte [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg).

## Limitações atuais

Existe uma limitação quanto à frequência com que as actualizações PWM podem ocorrer. Embora seja muito precisa, uma atualização PWM só pode ocorrer a cada 0,1 segundos, o que a torna quase inútil para a gravação raster. No entanto, existe um [ramo experimental] (https://github.com/Cirromulus/klipper/tree/laser_tool) com as suas próprias desvantagens. A longo prazo, está planeado adicionar esta funcionalidade ao klipper de linha principal.

## Comandos

`M3/M4 S<value>` : Define o ciclo de trabalho PWM. Valores entre 0 e 255. M5` : Parar a saída PWM para o valor de paragem.

## Configuração Laserweb

Se utilizar o Laserweb, uma configuração funcional seria a seguinte:

    GCODE START:
        M5            ; Desativar laser
        G21           ; Definir unidades para mm
        G90           ; Posicionamento absoluto
        G0 Z0 F7000   ; Ajustar velocidade de não corte
    
    GCODE END:
        M5            ; Desativar o laser
        G91           ; relativo
        G0 Z+20 F4000 ;
        G90           ; absoluto
    
    GCODE HOMING:
        M5            ; Desativar laser
        G28           ; Colocar todos os eixos em posição inicial
    
    TOOL ON:
        M3 $INTENSITY
    
    TOOL OFF:
        M5            ; Desativar laser
    
    LASER INTENSITY:
        S
