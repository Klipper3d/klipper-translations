# Verwendung von PWM-Tools

This document describes how to setup a PWM-controlled laser or spindle using `pwm_tool` and some macros.

## Wie funktioniert das?

With re-purposing the printhead's fan pwm output, you can control lasers or spindles. This is useful if you use switchable print heads, for example the E3D toolchanger or a DIY solution. Usually, cam-tools such as LaserWeb can be configured to use `M3-M5` commands, which stand for *spindle speed CW* (`M3 S[0-255]`), *spindle speed CCW* (`M4 S[0-255]`) and *spindle stop* (`M5`).

**Warning:** When driving a laser, keep all security precautions that you can think of! Diode lasers are usually inverted. This means, that when the MCU restarts, the laser will be *fully on* for the time it takes the MCU to start up again. For good measure, it is recommended to *always* wear appropriate laser-goggles of the right wavelength if the laser is powered; and to disconnect the laser when it is not needed. Also, you should configure a safety timeout, so that when your host or MCU encounters an error, the tool will stop.

Für eine Beispielkonfiguration siehe [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg).

## Befehle

`M3/M4 S<Wert>` : Einstellung des PWM-Tastverhältnisses. Werte zwischen 0 und 255. `M5`: PWM Ausgang auf Abschaltwert stoppen.

## Laserweb Konfiguration

Wenn Sie Laserweb verwenden, würde eine funktionierende Konfiguration wie folgt aussehen:

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
