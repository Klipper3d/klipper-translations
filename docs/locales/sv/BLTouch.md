# BLTouch

## Ansluta BL-Touch

En **varning** innan du börjar: Undvik att röra BL-Touch-stiftet med bara fingrar, eftersom det är känsligt för fett från fingrarna. Om du ändå rör det ska du vara mycket försiktig så att inget böjs eller trycks in.

Anslut BL-Touch-enhetens "servo"-kontakt till en `control_pin` enligt BL-Touch- eller MCU-dokumentationen. Med originalkopplingen är den gula ledaren i trion `control_pin` och den vita ledaren i paret `sensor_pin`. Konfigurera stiften enligt din kabeldragning. De flesta BL-Touch-enheter kräver pullup på sensorns stift (lägg till "^" före stiftnamnet). Till exempel:

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

Om BL-Touch ska användas för att referensköra Z-axeln anger du `endstop_pin: probe:z_virtual_endstop`, tar bort `position_endstop` i konfigurationssektionen `[stepper_z]` och lägger till en `[safe_z_home]`-sektion för att höja Z-axeln, referensköra XY-axlarna, flytta till bäddens mitt och referensköra Z-axeln. Till exempel:

```
[safe_z_home]
home_xy_position: 100, 100 # Change coordinates to the center of your print bed
speed: 50
z_hop: 10                 # Move up 10mm
z_hop_speed: 5
```

Det är viktigt att z_hop-rörelsen i safe_z_home är tillräckligt hög för att sonden inte ska träffa något, även om sondstiftet råkar vara i sitt lägsta läge.

## Inledande tester

Innan du fortsätter kontrollerar du att BL-Touch-enheten är monterad på rätt höjd: stiftet ska vara ungefär 2 mm över munstycket när det är indraget.

När skrivaren startas ska BL-Touch-sonden utföra ett självtest och flytta stiftet upp och ned några gånger. När självtestet är klart ska stiftet vara indraget och sondens röda lysdiod lysa. Om det finns fel, exempelvis att sonden blinkar rött eller att stiftet är nedfällt i stället för uppfällt, stänger du av skrivaren och kontrollerar kabeldragningen och konfigurationen.

Om detta ser bra ut är det dags att testa att styrstiftet fungerar. Kör först `BLTOUCH_DEBUG COMMAND=pin_down` i skrivarens terminal. Kontrollera att stiftet fälls ned och att sondens röda lysdiod slocknar. Om inte, kontrollera kabeldragningen och konfigurationen igen. Kör sedan `BLTOUCH_DEBUG COMMAND=pin_up`, kontrollera att stiftet fälls upp och att den röda lampan tänds igen. Om den blinkar finns ett problem.

Nästa steg är att bekräfta att sensorstiftet fungerar. Kör `BLTOUCH_DEBUG COMMAND=pin_down`, kontrollera att stiftet fälls ned, kör `BLTOUCH_DEBUG COMMAND=touch_mode`, kör `QUERY_PROBE` och kontrollera att kommandot rapporterar "probe: open". Medan du försiktigt trycker stiftet något uppåt med en fingernagel kör du `QUERY_PROBE` igen. Kontrollera att kommandot rapporterar "probe: TRIGGERED". Om någon fråga inte ger rätt meddelande tyder det vanligen på fel kabeldragning eller konfiguration (även om vissa [kloner](#bl-touch-clones) kan kräva särskild hantering). När testet är klart kör du `BLTOUCH_DEBUG COMMAND=pin_up` och kontrollerar att stiftet fälls upp.

När testerna av BL-Touch-enhetens styr- och sensorstift är klara är det dags att testa sondering, men med en viktig skillnad. Låt sondstiftet träffa nageln på ditt finger i stället för utskriftsbädden. Placera verktygshuvudet långt från bädden, kör `G28` (eller `PROBE` om probe:z_virtual_endstop inte används), vänta tills verktygshuvudet börjar röra sig nedåt och stoppa rörelsen genom att mycket försiktigt röra stiftet med nageln. Du kan behöva göra det två gånger eftersom standardkonfigurationen för referenskörning sonderar två gånger. Var beredd att stänga av skrivaren om den inte stannar när du rör stiftet.

Om det lyckades kör du `G28` (eller `PROBE`) igen, men låter nu stiftet röra bädden som det ska.

## När BL-Touch slutar fungera

När BL-Touch-enheten hamnar i ett inkonsekvent tillstånd börjar den blinka rött. Du kan tvinga den att lämna tillståndet genom att köra:

BLTOUCH_DEBUG COMMAND=reset

Detta kan hända om kalibreringen avbryts genom att sondstiftet hindras från att fällas ut.

BL-Touch-enheten kan också sluta kunna kalibrera sig själv. Det händer om skruven ovanpå sitter fel eller om den magnetiska kärnan inuti sondstiftet har flyttat sig. Om den har flyttats upp så att den fastnar mot skruven kan stiftet inte längre fällas ned. Då måste du lossa skruven och försiktigt trycka tillbaka kärnan på plats med en kulspetspenna. Sätt tillbaka stiftet i BL-Touch-enheten så att det faller till utfällt läge. Justera försiktigt den skruv utan huvud som håller den på plats. Du måste hitta rätt läge så att stiftet kan fällas ned och upp och den röda lampan tänds och släcks. Använd kommandona `reset`, `pin_up` och `pin_down` för detta.

## BL-Touch-"kloner"

Många BL-Touch-"klon"-enheter fungerar korrekt med Klipper med standardkonfigurationen. Vissa "klon"-enheter kanske dock inte stöder `QUERY_PROBE`, och vissa kan kräva konfiguration av `pin_up_reports_not_triggered` eller `pin_up_touch_mode_reports_triggered`.

Viktigt! Konfigurera inte `pin_up_reports_not_triggered` eller `pin_up_touch_mode_reports_triggered` till False utan att först följa dessa anvisningar. Konfigurera inte någon av dem till False för en äkta BL-Touch. Felaktiga False-värden kan öka sonderingstiden och risken för skador på skrivaren.

Vissa "klon"-enheter stöder inte `touch_mode`, vilket gör att `QUERY_PROBE` inte fungerar. Trots det kan sondering och referenskörning fungera med dessa enheter. `QUERY_PROBE` i [inledande tester](#initial-tests) kommer då inte att lyckas, medan det efterföljande testet med `G28` (eller `PROBE`) lyckas. Sådana "klon"-enheter kan fungera med Klipper om `QUERY_PROBE` inte används och funktionen `probe_with_touch_mode` inte aktiveras.

Vissa "klon"-enheter kan inte utföra Klippers interna test av sensorn. Då kan försök att referensköra eller sondera ge felet "BLTouch failed to verify sensor state". Om det inträffar kör du manuellt stegen i [avsnittet om inledande tester](#initial-tests) för att bekräfta att sensorstiftet fungerar. Om `QUERY_PROBE` i testet alltid ger förväntat resultat men felet "BLTouch failed to verify sensor state" ändå uppstår kan `pin_up_touch_mode_reports_triggered` behöva anges till False i Klippers konfigurationsfil.

Ett fåtal äldre "klon"-enheter kan inte rapportera när de har fällt upp sonden. För sådana enheter rapporterar Klipper "BLTouch failed to raise probe" efter varje försök att referensköra eller sondera. Testa genom att flytta huvudet långt från bädden, köra `BLTOUCH_DEBUG COMMAND=pin_down`, kontrollera att stiftet har fällts ned, köra `QUERY_PROBE` och kontrollera att resultatet är "probe: open". Kör sedan `BLTOUCH_DEBUG COMMAND=pin_up`, kontrollera att stiftet har fällts upp och kör `QUERY_PROBE`. Om stiftet förblir uppfällt, enheten inte går till feltillstånd, den första frågan rapporterar "probe: open" och den andra "probe: TRIGGERED", bör `pin_up_reports_not_triggered` anges till False i Klippers konfigurationsfil.

## BL-Touch v3

Vissa BL-Touch v3.0- och BL-Touch 3.1-enheter kan kräva att `probe_with_touch_mode` konfigureras i skrivarens konfigurationsfil.

Om BL-Touch v3.0 har sin signalkabel ansluten till ett ändstoppsstift (med en kondensator för brusfiltrering) kan BL-Touch v3.0 misslyckas med att konsekvent sända signal under referenskörning och sondering. Om `QUERY_PROBE` i [avsnittet om inledande tester](#initial-tests) alltid ger förväntat resultat men verktygshuvudet inte alltid stannar under G28/PROBE-kommandon tyder det på detta problem. En lösning är att ange `probe_with_touch_mode: True` i konfigurationsfilen.

BL-Touch v3.1 kan felaktigt gå till feltillstånd efter lyckad sondering. Symptomet är att lampan på BL-Touch v3.1 ibland blinkar i några sekunder efter att sonden har berört bädden. Klipper bör rensa felet automatiskt och det är i regel ofarligt. Du kan dock ange `probe_with_touch_mode` i konfigurationsfilen för att undvika problemet.

Viktigt! Vissa "klon"-enheter och BL-Touch v2.0 (och äldre) kan få sämre precision när `probe_with_touch_mode` anges till True. True ökar även tiden det tar att fälla ut sonden. Om värdet konfigureras för en "klon" eller äldre BL-Touch-enhet måste du testa sondens precision före och efter ändringen (använd `PROBE_ACCURACY`).

## Flera sonderingar utan att fälla in sonden

Som standard fäller Klipper ut sonden vid början av varje sondering och fäller sedan in den. Att upprepa utfällning och infällning kan öka den totala tiden för kalibreringssekvenser med många sondmätningar. Klipper kan lämna sonden utfälld mellan på varandra följande sonderingar, vilket minskar sonderingstiden. Läget aktiveras genom att ange `stow_on_each_sample` till False i konfigurationsfilen.

Viktigt! Om `stow_on_each_sample` anges till False kan Klipper göra horisontella verktygshuvudsrörelser medan sonden är utfälld. Kontrollera att alla sonderingar har tillräcklig Z-frigång innan värdet anges till False. Otillräcklig frigång kan göra att stiftet fastnar i ett hinder vid en horisontell rörelse och skadar skrivaren.

Viktigt! När `stow_on_each_sample` är False rekommenderas `probe_with_touch_mode` satt till True. Vissa "klon"-enheter kanske inte känner av nästa bäddkontakt om `probe_with_touch_mode` inte är satt. På alla enheter förenklar kombinationen av dessa två inställningar enhetens signalering, vilket kan förbättra den totala stabiliteten.

Observera dock att vissa "klon"-enheter och BL-Touch v2.0 (och äldre) kan få sämre precision när `probe_with_touch_mode` anges till True. För sådana enheter är det lämpligt att testa sondens precision före och efter att `probe_with_touch_mode` anges (använd `PROBE_ACCURACY`).

## Kalibrera BL-Touch-offset

Följ anvisningarna i guiden [Sondkalibrering](Probe_Calibrate.md) för att ange konfigurationsparametrarna x_offset, y_offset och z_offset.

Det är lämpligt att kontrollera att Z-offset ligger nära 1 mm. Om inte bör sonden förmodligen flyttas upp eller ned. Den ska utlösas i god tid innan munstycket träffar bädden, så att eventuellt fastnat filament eller en skev bädd inte påverkar sonderingen. Samtidigt ska det indragna läget vara så långt ovanför munstycket som möjligt för att undvika att sonden rör utskrivna delar. Om sondpositionen justeras kör du sondkalibreringen igen.

## BL-Touch-utmatningsläge

* En BL-Touch V3.0 har ett utmatningsläge för 5 V eller OPEN-DRAIN. BL-Touch V3.1 har också detta, men kan dessutom lagra valet i sin interna EEPROM. Om styrkortet behöver den fasta höga logiknivån på 5 V från 5V-läget kan parametern 'set_output_mode' i `[bltouch]`-sektionen i skrivarens konfigurationsfil anges till "5V".

   *** Använd endast 5V-läget om styrkortets ingångsledning tål 5 V. Därför är standardkonfigurationen för dessa BL-Touch-versioner OPEN-DRAIN-läge. Du kan skada styrkortets CPU. ***

   Alltså: Om ett styrkort KRÄVER 5V-läge OCH dess ingångssignalledning tål 5 V OCH om

   - du har en BL-Touch Smart V3.0, måste du använda parametern 'set_output_mode: 5V' för att säkra inställningen vid varje uppstart eftersom sonden inte kan komma ihåg den nödvändiga inställningen.
   - du har en BL-Touch Smart V3.1, kan du välja mellan 'set_output_mode: 5V' och att lagra läget en gång manuellt med kommandot 'BLTOUCH_STORE MODE=5V' utan att använda parametern 'set_output_mode:'.
   - du har en annan sond: Vissa sonder har en ledarbana på kretskortet som ska klippas av eller en bygel som ska sättas för att ställa in utmatningsläget permanent. Uteslut då parametern 'set_output_mode' helt.
Om du har V3.1 ska lagring av utmatningsläget inte automatiseras eller upprepas, för att inte slita ut sondens EEPROM. BLTouch-EEPROM klarar ungefär 100 000 uppdateringar. 100 lagringar per dag ger ungefär tre års drift innan den slits ut. Leverantören har därför gjort lagringen av utmatningsläget i V3.1 till en komplicerad åtgärd (fabriksstandarden är det säkra OPEN DRAIN-läget). Den är inte avsedd att upprepade gånger köras av ett skivningsprogram, makro eller annat, utan bör helst bara användas när sonden först integreras med skrivarens elektronik.
