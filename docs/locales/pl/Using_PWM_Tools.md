# Using PWM tools

Ten dokument opisuje jak skonfigurować laser lub wrzeciono sterowane PWM używając `output_pin` i kilku makr.

## Jak to działa?

Wykorzystując wyjście pwm wentylatora głowicy drukującej, można sterować laserami lub wrzecionami. Jest to przydatne, jeśli używasz przełączalnych głowic drukujących, na przykład E3D toolchanger lub rozwiązania DIY. Zazwyczaj, narzędzia krzywkowe takie jak LaserWeb mogą być skonfigurowane do używania komend `M3-M5`, które oznaczają *spindle speed CW* (`M3 S[0-255]`), *spindle speed CCW* (`M4 S[0-255]`) i *spindle stop* (`M5`).

**Warning:** When driving a laser, keep all security precautions that you can think of! Diode lasers are usually inverted. This means, that when the MCU restarts, the laser will be *fully on* for the time it takes the MCU to start up again. For good measure, it is recommended to *always* wear appropriate laser-goggles of the right wavelength if the laser is powered; and to disconnect the laser when it is not needed. Also, you should configure a safety timeout, so that when your host or MCU encounters an error, the tool will stop.

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
