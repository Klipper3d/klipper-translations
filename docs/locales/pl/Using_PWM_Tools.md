# Using PWM tools

Ten dokument opisuje jak skonfigurować laser lub wrzeciono sterowane PWM używając `output_pin` i kilku makr.

## Jak to działa?

Wykorzystując wyjście pwm wentylatora głowicy drukującej, można sterować laserami lub wrzecionami. Jest to przydatne, jeśli używasz przełączalnych głowic drukujących, na przykład E3D toolchanger lub rozwiązania DIY. Zazwyczaj, narzędzia krzywkowe takie jak LaserWeb mogą być skonfigurowane do używania komend `M3-M5`, które oznaczają *spindle speed CW* (`M3 S[0-255]`), *spindle speed CCW* (`M4 S[0-255]`) i *spindle stop* (`M5`).

**Uwaga:** Podczas używania lasera należy zachować wszelkie środki ostrożności, jakie tylko przychodzą na myśl! Lasery diodowe są zwykle odwrócone. Oznacza to, że po ponownym uruchomieniu MCU laser będzie *w pełni włączony* przez cały czas potrzebny do ponownego uruchomienia MCU. Dla pewności zaleca się *zawsze* noszenie odpowiednich okularów ochronnych dostosowanych do długości fal jeżeli laser jest uruchomiony, oraz do odłączania lasera, gdy nie jest on potrzebny. Powinieneś także skonfigurować limit czasu bezpieczeństwa, aby narzędzie zatrzymało się, gdy host lub MCU napotka błąd.

For an example configuration, see [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg).

## Current Limitations

There is a limitation of how frequent PWM updates may occur. While being very precise, a PWM update may only occur every 0.1 seconds, rendering it almost useless for raster engraving. However, there exists an [experimental branch](https://github.com/Cirromulus/klipper/tree/laser_tool) with its own tradeoffs. In long term, it is planned to add this functionality to main-line klipper.

## Commands

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
