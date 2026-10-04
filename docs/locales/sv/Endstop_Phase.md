# Ändstoppsfas

Det här dokumentet beskriver Klippers system för ändstopp med stegfasjustering. Funktionen kan förbättra precisionen hos traditionella ändstoppsbrytare. Den är mest användbar med en Trinamic-drivrutin för stegmotorer som har konfiguration under drift.

En typisk ändstoppsbrytare har en precision på omkring 100 mikrometer. (Varje gång en axel referenskörs kan brytaren aktiveras något tidigare eller senare.) Även om detta är ett relativt litet fel kan det ge oönskade artefakter. I synnerhet kan positionsavvikelsen märkas när ett objekts första lager skrivs ut. Typiska stegmotorer kan däremot ge betydligt högre precision.

Mekanismen för ändstopp med stegfasjustering kan använda stegmotorernas precision för att förbättra ändstoppsbrytarnas precision. En stegmotor rör sig genom att växla mellan en serie faser tills den har genomfört fyra ”fullsteg”. En stegmotor som använder 16 mikrosteg har alltså 64 faser och växlar, när den rör sig i positiv riktning, mellan faserna 0, 1, 2, ... 61, 62, 63, 0, 1, 2 och så vidare. Det avgörande är att när stegmotorn befinner sig på en viss position på en linjärskena bör den alltid befinna sig i samma stegfas. När en vagn aktiverar ändstoppsbrytaren bör därför stegmotorn som styr vagnen alltid vara i samma stegfas. Klippers system för ändstoppsfaser kombinerar stegfasen med ändstoppssignalen för att förbättra ändstoppets precision.

För att använda funktionen måste stegmotorns fas kunna identifieras. Om Trinamic-drivrutinerna TMC2130, TMC2208, TMC2224 eller TMC2660 används i konfigurationsläge under drift (alltså inte fristående läge) kan Klipper fråga drivrutinen om stegfasen. (Systemet kan även användas med traditionella stegmotordrivrutiner om de kan återställas tillförlitligt – se informationen nedan.)

## Kalibrera ändstoppsfaser

När Trinamic-drivrutiner för stegmotorer används med konfiguration under drift kan ändstoppsfaserna kalibreras med kommandot ENDSTOP_PHASE_CALIBRATE. Börja med att lägga till följande i konfigurationsfilen:

```
[endstop_phase]
```

Starta sedan om skrivaren med RESTART och kör kommandot `G28`, följt av `ENDSTOP_PHASE_CALIBRATE`. Flytta därefter verktygshuvudet till en ny position och kör `G28` igen. Försök att flytta verktygshuvudet till flera olika positioner och kör `G28` på nytt från varje position. Kör minst fem `G28`-kommandon.

Efter stegen ovan rapporterar kommandot `ENDSTOP_PHASE_CALIBRATE` ofta samma (eller nästan samma) fas för stegmotorn. Fasen kan sparas i konfigurationsfilen så att alla framtida G28-kommandon använder den fasen. (Vid framtida referenskörningar får Klipper då samma position även om ändstoppet aktiveras något tidigare eller senare.)

Spara ändstoppsfasen för en viss stegmotor genom att köra något i stil med följande:

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Kör ovanstående för alla stegmotorer vars värden ska sparas. Normalt används det för stepper_z på kartesiska skrivare och CoreXY-skrivare, samt för stepper_a, stepper_b och stepper_c på deltaskrivare. Kör slutligen följande för att uppdatera konfigurationsfilen med uppgifterna:

```
SAVE_CONFIG
```

### Ytterligare anmärkningar

* Funktionen är mest användbar på deltaskrivare och för Z-ändstoppet på kartesiska skrivare och CoreXY-skrivare. Den kan användas för XY-ändstopp på kartesiska skrivare, men är inte särskilt användbar där eftersom ett litet fel i X/Y-ändstoppets position sannolikt inte påverkar utskriftskvaliteten. Funktionen får inte användas för XY-ändstopp på CoreXY-skrivare (eftersom XY-positionen inte bestäms av en enda stegmotor med CoreXY-kinematik). Funktionen får inte användas på skrivare som använder Z-ändstoppet ”probe:z_virtual_endstop” (eftersom stegfasen bara är stabil om ändstoppet har en fast position på en skena).
* Om ändstoppet senare flyttas eller justeras efter att ändstoppsfasen har kalibrerats, måste ändstoppet kalibreras på nytt. Ta bort kalibreringsuppgifterna från konfigurationsfilen och kör stegen ovan igen.
* För att använda systemet måste ändstoppet vara tillräckligt exakt för att identifiera stegmotorns position inom två ”fullsteg”. Om en stegmotor till exempel använder 16 mikrosteg med ett stegavstånd på 0,005 mm måste ändstoppet ha en precision på minst 0,160 mm. Om felmeddelanden av typen ”Endstop stepper_z incorrect phase” visas kan det bero på att ändstoppet inte är tillräckligt exakt. Om omkalibrering inte hjälper ska ändstoppsfasjusteringarna inaktiveras genom att ta bort dem från konfigurationsfilen.
* Systemet kan också användas med en traditionellt styrd Z-axel med stegmotor (som på en kartesisk skrivare eller CoreXY-skrivare) och vanliga skruvar för bäddnivellering, så att varje utskriftslager utförs vid en ”fullstegsgräns”. Aktivera funktionen genom att säkerställa att G-kodskivaren är inställd på en lagerhöjd som är en multipel av ett ”fullsteg”, aktivera alternativet endstop_align_zero manuellt i konfigurationsavsnittet endstop_phase (se [konfigurationsreferensen](Config_Reference.md#endstop_phase) för mer information) och nivellera därefter bäddens skruvar igen.
* Systemet kan användas med traditionella stegmotordrivrutiner (som inte är Trinamic). Då måste stegmotordrivrutinerna dock återställas varje gång mikrokontrollern återställs. (Om båda alltid återställs tillsammans kan Klipper fastställa stegfasen genom att följa det totala antal steg som programmet har beordrat stegmotorn att röra sig.) För närvarande är det enda tillförlitliga sättet att göra detta att både mikrokontrollern och stegmotordrivrutinerna enbart drivs via USB, där USB-strömmen kommer från en värd som körs på en Raspberry Pi. I den situationen kan en MCU-konfiguration med ”restart_method: rpi_usb” anges. Alternativet gör att mikrokontrollern alltid återställs genom en USB-strömåterställning, så att både mikrokontrollern och stegmotordrivrutinerna återställs tillsammans. Med den mekanismen behöver konfigurationsavsnitten ”trigger_phase” sedan ställas in manuellt (se [konfigurationsreferensen](Config_Reference.md#endstop_phase) för detaljer).
