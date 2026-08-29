# Verwendung von PWM-Tools

Dieses Dokument beschreibt, wie ein PWM-gesteuerter Laser oder eine PWM-gesteuerte Spindel mit `pwm_tool` und einigen Makros eingerichtet wird.

## Wie funktioniert das?

Durch die Umwidmung des PWM-Ausgangs für den Druckkopflüfter können Sie Laser oder Spindeln ansteuern. Das ist nützlich, wenn Sie wechselbare Druckköpfe verwenden, zum Beispiel den E3D Toolchanger oder eine Eigenbaulösung. Üblicherweise lassen sich CAM-Werkzeuge wie LaserWeb so konfigurieren, dass sie die Befehle `M3-M5` verwenden, die für *Spindeldrehzahl im Uhrzeigersinn* (`M3 S[0-255]`), *Spindeldrehzahl gegen den Uhrzeigersinn* (`M4 S[0-255]`) und *Spindelstopp* (`M5`) stehen.

**Warnung:** Beachten Sie beim Betrieb eines Lasers alle nur denkbaren Sicherheitsvorkehrungen! Diodenlaser sind üblicherweise invertiert. Das bedeutet, dass der Laser beim Neustart des MCU für die Dauer des Startvorgangs *voll eingeschaltet* ist. Es wird dringend empfohlen, bei eingeschaltetem Laser *immer* eine geeignete Laserschutzbrille für die passende Wellenlänge zu tragen und den Laser zu trennen, wenn er nicht benötigt wird. Außerdem sollten Sie eine Sicherheitszeitüberschreitung konfigurieren, damit das Werkzeug stoppt, wenn Host oder MCU einen Fehler feststellen.

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
