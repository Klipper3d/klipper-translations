# Using PWM tools

This document describes how to setup a PWM-controlled laser or spindle using `pwm_tool` and some macros.

## Cómo funciona?

Al reutilizar la salida pwm del ventilador del cabezal de impresión, se pueden controlar láseres o husillos. Esto resulta útil si se utilizan cabezales de impresión intercambiables, por ejemplo, el cambiador de herramientas E3D o una solución DIY. Por lo general, las herramientas de levas como LaserWeb se pueden configurar para utilizar los comandos «M3-M5», que significan *velocidad del husillo CW* («M3 S[0-255]»), *velocidad del husillo CCW* («M4 S[0-255]») y *parada del husillo* («M5»).

**Advertencia:** Cuando utilice un láser, tome todas las precauciones de seguridad que se le ocurran. Los láseres de diodo suelen estar invertidos. Esto significa que, cuando la MCU se reinicie, el láser estará *totalmente encendido* durante el tiempo que tarde la MCU en volver a arrancar. Por precaución, se recomienda llevar *siempre* gafas protectoras adecuadas para la longitud de onda correcta cuando el láser esté encendido, y desconectarlo cuando no se necesite. Además, debe configurar un tiempo de espera de seguridad para que, cuando el host o la MCU detecten un error, la herramienta se detenga.

For an example configuration, see [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg).

## Comandos

`M3/M4 S<value>` : Set PWM duty-cycle. Values between 0 and 255. `M5` : Stop PWM output to shutdown value.

## Laserweb Configuration

If you use Laserweb, a working configuration would be:

    GCODE START:
        M5            ; Disable Laser
        G21           ; Set units to mm
        G90           ; Absolute positioning
        G0 Z0 F7000   ; Set Non-Cutting speed
    
    GCODE END:
        M5            ; Disable Laser
        G91           ; relative
        G0 Z+20 F4000 ;
        G90           ; absolute
    
    GCODE HOMING:
        M5            ; Disable Laser
        G28           ; Home all axis
    
    TOOL ON:
        M3 $INTENSITY
    
    TOOL OFF:
        M5            ; Disable Laser
    
    LASER INTENSITY:
        S
