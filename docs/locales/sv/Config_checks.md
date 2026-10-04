# Konfigurationskontroller

Detta dokument innehåller en lista med steg som hjälper dig att bekräfta PIN-inställningarna i Klipper-filen printer.cfg. Det är lämpligt att gå igenom dessa steg efter stegen i [installationsdokumentet](Installation.md).

Under den här guiden kan du behöva ändra Klipper-konfigurationsfilen. Kör alltid kommandot RESTART efter varje ändring så att den träder i kraft (skriv "restart" på OctoPrints terminalflik och klicka sedan på "Send"). Det är också bra att köra STATUS efter varje RESTART för att kontrollera att konfigurationsfilen har lästs in korrekt.

## Kontrollera temperaturen

Börja med att kontrollera att temperaturerna rapporteras korrekt. Gå till avsnittet med temperaturdiagram i användargränssnittet. Kontrollera att munstyckets och byggplattans temperaturer visas, om de används, och att de inte stiger. Bryt strömmen till skrivaren om temperaturerna stiger. Om temperaturerna inte är korrekta granskar du inställningarna "sensor_type" och "sensor_pin" för munstycket och/eller byggplattan.

## Kontrollera M112

Gå till kommandokonsolen och kör kommandot M112 i terminalfältet. Kommandot begär att Klipper ska övergå till tillståndet "shutdown". Ett fel visas och kan rensas med kommandot FIRMWARE_RESTART i kommandokonsolen. OctoPrint behöver också återanslutas. Gå sedan till avsnittet med temperaturdiagram och kontrollera att temperaturerna fortsätter att uppdateras och inte stiger. Bryt strömmen till skrivaren om temperaturerna stiger.

## Kontrollera värmarna

Gå till avsnittet med temperaturdiagram och skriv 50 följt av Retur i fältet för extruder-/verktygstemperatur. Extrudertemperaturen i diagrammet ska börja stiga inom ungefär 30 sekunder. Gå sedan till listrutan för extruder-temperatur och välj "Off". Efter några minuter ska temperaturen börja återgå till det ursprungliga rumstemperaturvärdet. Om temperaturen inte stiger kontrollerar du inställningen "heater_pin" i konfigurationen.

Om skrivaren har en uppvärmd byggplatta ska du utföra testet ovan igen med byggplattan.

## Kontrollera stegmotorns aktiverings-PIN

Kontrollera att skrivarens alla axlar kan flyttas fritt för hand (stegmotorerna är avaktiverade). Om inte kör du kommandot M84 för att avaktivera motorerna. Om någon axel fortfarande inte kan flyttas fritt kontrollerar du konfigurationen av stegmotorns "enable_pin" för den axeln. På de flesta vanliga stegmotordrivrutiner är motorns aktiverings-PIN "active low" och därför ska ett "!" stå före PIN:en (till exempel "enable_pin: !PA1").

## Kontrollera ändlägena

Flytta alla skrivaraxlar manuellt så att ingen av dem har kontakt med ett ändläge. Skicka kommandot QUERY_ENDSTOPS via kommandokonsolen. Svaret ska visa aktuellt tillstånd för alla konfigurerade ändlägen och samtliga ska rapportera tillståndet "open". Kör QUERY_ENDSTOPS igen för varje ändläge medan du manuellt aktiverar ändläget. QUERY_ENDSTOPS ska då rapportera ändläget som "TRIGGERED".

Om ändläget verkar vara inverterat (det rapporterar "open" när det aktiveras och tvärtom) lägger du till "!" i PIN-definitionen (till exempel "endstop_pin: ^!PA2"), eller tar bort "!" om det redan finns där.

Om ändläget inte ändras alls betyder det vanligen att ändläget är anslutet till en annan PIN. Det kan dock också krävas att pullup-inställningen för PIN:en ändras (tecknet '^' i början av endstop_pin-namnet – de flesta skrivare använder ett pullup-motstånd och '^' ska då finnas med).

## Kontrollera stegmotorerna

Använd kommandot STEPPER_BUZZ för att kontrollera anslutningen till varje stegmotor. Placera först den aktuella axeln manuellt ungefär mitt i dess rörelseområde och kör sedan `STEPPER_BUZZ STEPPER=stepper_x` i kommandokonsolen. STEPPER_BUZZ får stegmotorn att flytta en millimeter i positiv riktning och sedan återgå till startläget. (Om ändläget är definierat med position_endstop=0 flyttas stegmotorn bort från ändläget i början av varje rörelse.) Den upprepar denna rörelse tio gånger.

Om stegmotorn inte rör sig alls kontrollerar du inställningarna "enable_pin" och "step_pin" för den. Om stegmotorn rör sig men inte återgår till sitt ursprungliga läge kontrollerar du inställningen "dir_pin". Om stegmotorn oscillerar i fel riktning betyder det vanligen att axelns "dir_pin" måste inverteras. Det gör du genom att lägga till ett '!' i "dir_pin" i skrivarens konfigurationsfil (eller ta bort det om det redan finns där). Om motorn rör sig avsevärt mer eller mindre än en millimeter kontrollerar du inställningen "rotation_distance".

Kör testet ovan för varje stegmotor som anges i konfigurationsfilen. (Sätt parametern STEPPER för kommandot STEPPER_BUZZ till namnet på den konfigurationssektion som ska testas.) Om det inte finns något filament i extrudern kan du använda STEPPER_BUZZ för att kontrollera extrudermotorns anslutning (använd STEPPER=extruder). I annat fall är det bäst att testa extrudermotorn separat (se nästa avsnitt).

När alla ändlägen och stegmotorer har kontrollerats ska referenskörningen testas. Kör kommandot G28 för att referensköra alla axlar. Bryt strömmen till skrivaren om referenskörningen inte fungerar korrekt. Upprepa vid behov kontrollen av ändlägen och stegmotorer.

## Kontrollera extrudermotorn

För att testa extrudermotorn måste extrudern värmas till utskriftstemperatur. Gå till avsnittet med temperaturdiagram och välj en måltemperatur i listrutan för temperatur, eller ange en lämplig temperatur manuellt. Vänta tills skrivaren har nått önskad temperatur. Gå sedan till kommandokonsolen och klicka på knappen "Extrude". Kontrollera att extrudermotorn roterar åt rätt håll. Om den inte gör det läser du felsökningstipsen i föregående avsnitt och kontrollerar extruderns inställningar "enable_pin", "step_pin" och "dir_pin".

## Kalibrera PID-inställningarna

Klipper stöder [PID-styrning](https://en.wikipedia.org/wiki/PID_controller) för extruderns och byggplattans värmare. För att använda denna styrmetod måste PID-inställningarna kalibreras på varje skrivare (PID-inställningar från annan firmware eller från exempelkonfigurationsfiler fungerar ofta dåligt).

För att kalibrera extrudern går du till kommandokonsolen och kör kommandot PID_CALIBRATE. Till exempel: `PID_CALIBRATE HEATER=extruder TARGET=170`

Kör `SAVE_CONFIG` när inställningstestet är klart för att uppdatera printer.cfg-filen med de nya PID-inställningarna.

Om skrivaren har en uppvärmd byggplatta som kan styras med PWM (pulsbredds-modulering) rekommenderas PID-styrning för byggplattan. (När byggplattans värmare styrs med PID-algoritmen kan den slås på och av tio gånger per sekund, vilket kanske inte passar värmare med en mekanisk brytare.) Ett typiskt kommando för PID-kalibrering av byggplattan är: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Nästa steg

Den här guiden är avsedd att hjälpa till med grundläggande kontroll av PIN-inställningarna i Klippers konfigurationsfil. Läs även guiden för [bäddnivellering](Bed_Level.md). I dokumentet [Slicers](Slicers.md) finns information om hur du konfigurerar en slicer för Klipper.

När du har bekräftat att grundläggande utskrift fungerar är det lämpligt att överväga att kalibrera [tryckutjämning](Pressure_Advance.md).

Det kan vara nödvändigt att utföra andra typer av detaljerad skrivarkalibrering. Det finns flera guider på nätet som kan hjälpa till med detta (sök till exempel på "3d printer calibration"). Om du till exempel upplever ringing kan du följa guiden för justering av [resonanskompensering](Resonance_Compensation.md).
