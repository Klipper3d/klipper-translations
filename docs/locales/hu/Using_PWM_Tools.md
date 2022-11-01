# PWM eszközök használata

Ez a dokumentum leírja, hogyan állíthatsz be egy PWM-vezérelt lézert vagy orsót az `output_pin` és néhány makró segítségével.

## Hogyan működik?

A nyomtatófej ventilátor PWM kimenetének felhasználásával lézereket vagy orsókat vezérelhetsz. Ez akkor hasznos, ha kapcsolható nyomtatófejeket használsz, például az E3D szerszámváltó vagy egy barkácsmegoldás. Általában az olyan cam-tool, mint a LaserWeb, úgy konfigurálhatók, hogy `M3-M5` parancsokat használjanak, amelyek *spindle speed CW* (`M3 S[0-255]`), *spindle speed CCW* (`M4 S[0-255]`) és *spindle stop* (`M5`).

**Figyelmeztetés:** A lézer használatakor tarts be minden biztonsági óvintézkedést, amit csak lehet! A diódalézerek általában invertáltak. Ez azt jelenti, hogy amikor az MCU újraindul, a lézer *teljesen be lesz kapcsolva* arra az időre. A biztonság kedvéért ajánlott *mindig* megfelelő hullámhosszúságú lézerszemüveget viselni, ha a lézer be van kapcsolva, és a lézert le kell kapcsolni, ha nincs rá szükség. Emellett be kell állítani egy biztonsági időkorlátot, hogy ha a gazdagép vagy az MCU hibát észlel, a szerszám leálljon.

Egy példakonfigurációért lásd [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg).

## Jelenlegi korlátozások

Korlátozott, hogy milyen gyakoriak lehetnek a PWM-frissítések. Bár nagyon pontos, a PWM frissítés csak 0,1 másodpercenként fordulhat elő, így szinte használhatatlanná válik a rasztergravírozáshoz. Létezik azonban egy [kísérleti ág](https://github.com/Cirromulus/klipper/tree/laser_tool), amelynek saját kompromisszumai vannak. Hosszú távon azt tervezik, hogy ezt a funkciót hozzáadják a fővonali klipperhez.

## Parancsok

`M3/M4 S<value>` : PWM-üzemmód beállítása. Értékek 0 és 255 között. `M5` : PWM kimenet leállítása a kikapcsolási értékre.

## Laserweb konfiguráció

Ha a Laserwebet használod, akkor a következő konfiguráció működhet:

    GCODE START:
        M5            ; Lézer letiltása
        G21           ;Állítsd az egységeket mm-re
        G90           ; Abszolút pozicionálás
        G0 Z0 F7000   ;Állítsd be a nem vágási sebességet
    
    GCODE END:
        M5            ; Lézer letiltása
        G91           ; relatív
        G0 Z+20 F4000 ;
        G90           ; abszolút
    
    GCODE HOMING:
        M5            ; Lézer letiltása
        G28           ; Kezdőpontfelvétel minden tengelyen
    
    TOOL ON:
        M3 $INTENSITY
    
    TOOL OFF:
        M5            ; Lézer letiltása
    
    LASER INTENSITY:
        S
