# PWM eszközök használata

Ez a dokumentum leírja, hogyan állíthat be egy PWM-vezérelt lézert vagy orsót az `output_pin` és néhány makró segítségével.

## Hogyan működik?

A nyomtatófej ventilátor pwm kimenetének felhasználásával lézereket vagy orsókat vezérelhet. Ez akkor hasznos, ha kapcsolható nyomtatófejeket használ, például az E3D toolchanger vagy egy barkácsmegoldás. Általában az olyan cam-toolok, mint a LaserWeb, úgy konfigurálhatók, hogy `M3-M5` parancsokat használjanak, amelyek *spindle speed CW* (`M3 S[0-255]`), *orsó fordulatszám * (`M4 S[0-255]`) és *orsóstop* (`M5`).

**Figyelmeztetés:** A lézer vezetésekor tartson be minden biztonsági óvintézkedést, ami csak eszébe jut! A diódalézerek általában invertáltak. Ez azt jelenti, hogy amikor az MCU újraindul, a lézer *teljesen be lesz kapcsolva* arra az időre, amíg az MCU újraindul. A biztonság kedvéért ajánlott *mindig* megfelelő hullámhosszúságú lézerszemüveget viselni, ha a lézer be van kapcsolva; és a lézert le kell kapcsolni, ha nincs rá szükség. Emellett be kell állítania egy biztonsági időkorlátot, hogy ha a gazdagép vagy az MCU hibát észlel, a szerszám leálljon.

Egy példakonfigurációért lásd [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg).

## Jelenlegi korlátozások

Korlátozott, hogy milyen gyakoriak lehetnek a PWM-frissítések. Bár nagyon pontos, a PWM frissítés csak 0,1 másodpercenként fordulhat elő, így szinte használhatatlanná válik a rasztergravírozáshoz. Létezik azonban egy [kísérleti ág](https://github.com/Cirromulus/klipper/tree/laser_tool), amelynek saját kompromisszumai vannak. Hosszú távon azt tervezik, hogy ezt a funkciót hozzáadják a fővonali klipperhez.

## Parancsok

`M3/M4 S<value>` : PWM-üzemmód beállítása. Értékek 0 és 255 között. `M5` : PWM kimenet leállítása a kikapcsolási értékre.

## Laserweb konfiguráció

Ha a Laserwebet használja, akkor a következő konfiguráció működhet:

    GCODE START:
        M5 ; Lézer kikapcsolása
        G21 ; Egységek beállítása mm-re
        G90 ; Abszolút pozicionálás
        G0 Z0 F7000 ; Nem vágási sebesség beállítása
    
    GCODE END:
        M5 ; Lézer kikapcsolása
        G91 ; relatív
        G0 Z+20 F4000 ;
        G90 ; abszolút
    
    GCODE HOMING:
        M5 ; Lézer kikapcsolása
        G28 ; Minden tengely alaphelyzetbe állítása
    
    TOOL ON:
        M3 $INTENSITY
    
    TOOL OFF:
        M5 ; Lézer kikapcsolása
    
    LASER INTENSITY:
        S
