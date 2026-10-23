# Använda PWM-verktyg

Det här dokumentet beskriver hur du ställer in en PWM-styrd laser eller spindel med `pwm_tool` och några makron.

## Så fungerar den

Genom att återanvända skrivhuvudets PWM-utgång för fläkten kan du styra lasrar eller spindlar. Det är användbart med utbytbara skrivhuvuden, till exempel E3D ToolChanger eller en egen lösning. CAM-verktyg som LaserWeb kan vanligen konfigureras för att använda kommandona `M3-M5`, som betyder *spindelhastighet medurs* (`M3 S[0-255]`), *spindelhastighet moturs* (`M4 S[0-255]`) och *stoppa spindeln* (`M5`).

**Varning:** Vid drift av laser ska du vidta alla säkerhetsåtgärder du kan komma på. Diodlasrar är vanligen inverterade. Det innebär att lasern är *helt påslagen* under den tid som MCU:n behöver för att starta om. Använd alltid lämpliga laserskyddsglasögon för rätt våglängd när lasern är strömsatt och koppla från lasern när den inte behövs. Konfigurera också en säkerhetstimeout så att verktyget stannar om värden eller MCU:n får ett fel.

Exempel på konfiguration finns i [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg).

## Kommandon

`M3/M4 S<värde>`: Ange PWM-arbetscykel. Värden mellan 0 och 255. `M5`: Stoppa PWM-utgången till avstängningsvärdet.

## LaserWeb-konfiguration

Om du använder LaserWeb kan en fungerande konfiguration vara:

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
