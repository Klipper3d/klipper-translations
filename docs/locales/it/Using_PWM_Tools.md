# Utilizzo dei strumenti PWM

This document describes how to setup a PWM-controlled laser or spindle using `pwm_tool` and some macros.

## Come funziona?

Riutilizzando l'output pwm della ventola della testina di stampa, è possibile controllare laser o mandrini. Ciò è utile se si utilizzano testine di stampa intercambiabili, ad esempio il cambio utensile E3D o una soluzione fai-da-te. Di solito, gli strumenti cam come LaserWeb possono essere configurati per utilizzare i comandi `M3-M5`, che stanno per *velocità mandrino CW* (`M3 S[0-255]`), *velocità mandrino CCW* (`M4 S[ 0-255]`) e *arresto mandrino* (`M5`).

**Attenzione:** Quando utilizzi un laser, mantieni tutte le precauzioni di sicurezza che ti vengono in mente! I laser a diodi sono generalmente invertiti. Ciò significa che quando l'MCU si riavvia, il laser sarà *completamente acceso* per il tempo necessario al riavvio dell'MCU. Per buona misura, si raccomanda di indossare *sempre* occhiali laser appropriati della giusta lunghezza d'onda se il laser è alimentato e per disconnettere il laser quando non è necessario. Inoltre, dovresti configurare un timeout di sicurezza, in modo che quando l'host o l'MCU riscontrano un errore, lo strumento si arresti.

Per un esempio di configurazione, vedere [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg).

## Comandi

`M3/M4 S<value>` : Imposta il duty-cycle PWM. Valori compresi tra 0 e 255. `M5` : Arresta l'uscita PWM al valore di spegnimento.

## Configurazione Laserweb

Se utilizzi Laserweb, una configurazione funzionante sarebbe:

    GCODE START:
        M5            ; Disabilita Laser
        G21           ; Set units to mm
        G90           ; Absolute positioning
        G0 Z0 F7000   ; Set Non-Cutting speed
    
    GCODE END:
        M5            ; Disabilita Laser
        G91           ; relative
        G0 Z+20 F4000 ;
        G90           ; absolute
    
    GCODE HOMING:
        M5            ; Disabilita Laser
        G28           ; Home all axis
    
    TOOL ON:
        M3 $INTENSITY
    
    TOOL OFF:
        M5            ; Disabilita Laser
    
    LASER INTENSITY:
        S
