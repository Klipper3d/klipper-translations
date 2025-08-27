# Používanie PWM nástrojov

Tento dokument popisuje, ako nastaviť laser alebo vreteno riadené PWM pomocou `output_pin` a niektorých makier.

## Ako to funguje?

Zmenou účelu výstupu PWM ventilátora tlačovej hlavy môžete ovládať lasery alebo vretená. Toto je užitočné, ak používate prepínateľné tlačové hlavy, napríklad menič nástrojov E3D alebo riešenie svojpomocne. Vačkové nástroje, ako napríklad LaserWeb, je možné zvyčajne nakonfigurovať na používanie príkazov `M3-M5`, čo znamená *rýchlosť vretena v smere hodinových ručičiek* (`M3 S[0-255]`), *rýchlosť vretena proti smeru hodinových ručičiek* (`M4 S[0-255]`) a *zastavenie vretena* (`M5`).

**Upozornenie:** Pri prevádzke lasera dodržujte všetky bezpečnostné opatrenia, ktoré vás napadnú! Diódové lasery sú zvyčajne invertované. To znamená, že po reštarte MCU bude laser *plne zapnutý* po dobu, ktorú MCU potrebuje na opätovné spustenie. Pre istotu sa odporúča *vždy* nosiť vhodné laserové okuliare so správnou vlnovou dĺžkou, ak je laser napájaný; a odpojiť laser, keď nie je potrebný. Taktiež by ste mali nakonfigurovať bezpečnostný časový limit, aby sa nástroj zastavil, keď váš hostiteľ alebo MCU narazí na chybu.

Príklad konfigurácie nájdete v súbore [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg).

## Súčasné obmedzenia

Existuje obmedzenie, ako často sa môžu vyskytovať aktualizácie PWM. Hoci je aktualizácia PWM veľmi presná, môže sa vyskytnúť iba každých 0,1 sekundy, čo ju robí takmer nepoužiteľnou pre rastrové gravírovanie. Existuje však [experimentálna vetva](https://github.com/Cirromulus/klipper/tree/laser_tool) s vlastnými kompromismi. V dlhodobom horizonte sa plánuje pridať túto funkciu do hlavnej rady klipperu.

## Príkazy

`M3/M4 S<hodnota>`: Nastavenie pracovného cyklu PWM. Hodnoty medzi 0 a 255. `M5`: Zastavenie výstupu PWM na hodnotu vypnutia.

## Konfigurácia Laserwebu

Ak používate Laserweb, funkčná konfigurácia by bola:

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
