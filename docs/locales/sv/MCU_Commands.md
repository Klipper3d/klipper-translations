# MCU-kommandon

Det här dokumentet innehåller information om de lågnivåkommandon för mikrokontrollern som skickas från Klippers värdprogramvara och behandlas av Klippers mikrokontrollerprogramvara. Dokumentet är varken en normerande referens för kommandona eller en fullständig lista över tillgängliga kommandon.

Dokumentet kan vara användbart för utvecklare som vill förstå mikrokontrollerns lågnivåkommandon.

Se dokumentet [protokoll](Protocol.md) för mer information om kommandonas format och överföring. Kommandona beskrivs här med syntax i "printf"-stil. Om du inte känner till formatet: ersätt varje följd '%...' med ett heltal. Beskrivningen "count=%c" kan till exempel ersättas med "count=10". Parametrar som betraktas som "uppräkningar" (se protokolldokumentet ovan) tar ett strängvärde som automatiskt omvandlas till ett heltalsvärde för mikrokontrollern. Detta är vanligt för parametrar med namnet "pin" eller suffixet "_pin".

## Startkommandon

Det kan vara nödvändigt att utföra vissa engångsåtgärder för att konfigurera mikrokontrollern och dess kringutrustning. Det här avsnittet listar vanliga kommandon för det ändamålet. Till skillnad från de flesta mikrokontrollerkommandon körs dessa så snart de tas emot och kräver ingen särskild konfiguration.

Vanliga startkommandon:

* `set_digital_out pin=%u value=%c` : Kommandot konfigurerar omedelbart den angivna pinnen som en digital GPIO-utgång och ställer den antingen på låg nivå (value=0) eller hög nivå (value=1). Det kan användas för att ange startvärden för lysdioder och för mikrostegspinnar på stegmotordrivare.
* `set_pwm_out pin=%u cycle_ticks=%u value=%hu` : Kommandot konfigurerar omedelbart den angivna pinnen för hårdvarubaserad pulsbreddsmodulering (PWM) med angivet antal cycle_ticks. "cycle_ticks" anger antalet MCU-klocktick för varje cykel på respektive av. Värdet 1 kan användas för kortast möjliga cykeltid. Parametern "value" är mellan 0 och 255; 0 betyder helt av och 255 helt på. Kommandot kan användas för att aktivera kylfläktar för CPU och munstycke.

## Lågnivåkonfiguration av mikrokontroller

De flesta mikrokontrollerkommandon kräver en inledande konfiguration innan de kan anropas. Det här avsnittet ger en översikt över konfigurationsprocessen. Detta och följande avsnitt är sannolikt bara intressanta för utvecklare som vill förstå Klippers interna detaljer.

När värden först ansluter till mikrokontrollern hämtar den alltid en dataordbok (se [protokoll](Protocol.md) för mer information). Därefter kontrollerar värden om mikrokontrollern är i tillståndet "configured" och konfigurerar den annars. Konfigurationen omfattar följande faser:

* `get_config` : Värden börjar med att kontrollera om mikrokontrollern redan är konfigurerad. Mikrokontrollern svarar med svarsmeddelandet "config". Mikrokontrollerprogramvaran startar alltid i ett okonfigurerat tillstånd vid påslagning och förblir där tills värden slutför konfigurationen genom att skicka kommandot finalize_config. Om mikrokontrollern redan är konfigurerad från en tidigare session med önskade inställningar behövs inget mer från värden och konfigurationen avslutas korrekt.
* `allocate_oids count=%c` : Kommandot informerar mikrokontrollern om det maximala antal objekt-ID:n (oid) som värden behöver. Det får bara skickas en gång. Ett oid är ett heltals-ID som tilldelas varje stegmotor, ändstopp och schemaläggningsbar GPIO-pinne. Värden bestämmer i förväg hur många oid:er som behövs för hårdvaran och skickar antalet till mikrokontrollern, som då kan reservera tillräckligt minne för en mappning från oid till internt objekt.
* `config_XXX oid=%c ...` : Enligt konvention skapar varje kommando som börjar med prefixet "config_" ett nytt mikrokontrollerobjekt och tilldelar det angivna oid. Till exempel konfigurerar config_digital_out den angivna pinnen som digital GPIO-utgång och skapar ett internt objekt som värden kan använda för att schemalägga ändringar av GPIO:n. Parametern oid väljs av värden och måste vara mellan noll och det högsta antal som angavs i allocate_oids. Config-kommandon får bara köras när mikrokontrollern inte är konfigurerad, efter allocate_oids men före finalize_config.
* `finalize_config crc=%u` : Kommandot finalize_config flyttar mikrokontrollern från okonfigurerat till konfigurerat tillstånd. Parametern crc lagras och skickas tillbaka till värden i svarsmeddelanden av typen "config". Enligt konvention beräknar värden en 32-bitars CRC för konfigurationen som ska begäras och kontrollerar i början av senare kommunikationssessioner att CRC-värdet i mikrokontrollern exakt motsvarar det önskade CRC-värdet. Om det inte stämmer vet värden att mikrokontrollern inte har konfigurerats i önskat tillstånd.

### Vanliga mikrokontrollerobjekt

Det här avsnittet listar några vanliga config-kommandon.

* `config_digital_out oid=%c pin=%u value=%c default_value=%c max_duration=%u` : Kommandot skapar ett internt mikrokontrollerobjekt för angiven GPIO-pinne. Pinnen konfigureras som digital utgång med startvärdet i 'value' (0 för låg, 1 för hög). Ett digital_out-objekt gör att värden kan schemalägga GPIO-uppdateringar vid angivna tidpunkter (se queue_digital_out nedan). Om mikrokontrollerprogramvaran går in i avstängningsläge ställs alla konfigurerade digital_out-objekt på 'default_value'. Parametern 'max_duration' är en säkerhetskontroll: om den inte är noll anger den maximalt antal klocktick som värden får lämna GPIO:n på ett annat värde än standardvärdet utan ny uppdatering. Om default_value är noll och max_duration är 16000 måste värden exempelvis schemalägga en ny uppdatering av GPIO-pinnen inom 16000 klocktick efter att ha angett värdet ett. Säkerhetsfunktionen kan användas med värmarpinnar så att värden inte kan aktivera värmaren och sedan kopplas från.
* `config_pwm_out oid=%c pin=%u cycle_ticks=%u value=%hu default_value=%hu max_duration=%u` : Kommandot skapar ett internt objekt för hårdvarubaserade PWM-pinnar som värden kan schemalägga uppdateringar för. Användningen motsvarar config_digital_out; se beskrivningarna av kommandona 'set_pwm_out' och 'config_digital_out' för parametrarna.
* `config_analog_in oid=%c pin=%u` : Kommandot konfigurerar en pinne för samplad analog ingång. När den är konfigurerad kan pinnen samplas regelbundet med kommandot query_analog_in (se nedan).
* `config_stepper oid=%c step_pin=%c dir_pin=%c invert_step=%c step_pulse_ticks=%u` : Kommandot skapar ett internt stegobjekt. Parametrarna 'step_pin' och 'dir_pin' anger steg- respektive riktningspinnarna och konfigureras som digitala utgångar. 'invert_step' anger om ett steg sker vid stigande flank (invert_step=0) eller fallande flank (invert_step=1). 'step_pulse_ticks' anger minsta längd för stegimpulsen. Om MCU:n exporterar konstanten 'STEPPER_BOTH_EDGE=1' ställer step_pulse_ticks=0 och invert_step=-1 in stegning på både stigande och fallande flank för stegpinnen.
* `config_endstop oid=%c pin=%c pull_up=%c stepper_count=%c` : Kommandot skapar ett internt "endstop"-objekt. Det används för att ange ändstoppspinnar och aktivera "homing"-åtgärder (se endstop_home nedan). Den angivna pinnen konfigureras som digital ingång. Parametern 'pull_up' avgör om tillgängliga hårdvaruresistorer för pullup aktiveras. 'stepper_count' anger maximalt antal stegmotorer som ändstoppet kan behöva stoppa vid homing.
* `config_spi oid=%c bus=%u pin=%u mode=%u rate=%u shutdown_msg=%*s` : Kommandot skapar ett internt SPI-objekt. Det används med kommandona spi_transfer och spi_send (se nedan). "bus" anger den SPI-buss som ska användas, om mikrokontrollern har fler än en. "pin" anger enhetens chip-select-pinne (CS). "mode" är SPI-läget (mellan 0 och 3). Parametern "rate" anger SPI-busshastigheten i cykler per sekund. Slutligen är "shutdown_msg" ett SPI-kommando som skickas till enheten om mikrokontrollern går in i avstängningsläge.
* `config_spi_without_cs oid=%c bus=%u mode=%u rate=%u shutdown_msg=%*s` : Kommandot liknar config_spi men saknar definition av CS-pinne. Det används för SPI-enheter utan chip-select-ledning.

## Vanliga kommandon

Det här avsnittet listar några vanliga körtidskommandon. Det är sannolikt bara intressant för utvecklare som vill få insikt i Klipper.

* `set_digital_out_pwm_cycle oid=%c cycle_ticks=%u` : Kommandot konfigurerar en digital utgångspinne (skapad av config_digital_out) för "programvaru-PWM". 'cycle_ticks' är antalet klocktick för PWM-cykeln. Eftersom växlingen implementeras i mikrokontrollerprogramvaran rekommenderas att 'cycle_ticks' motsvarar 10 ms eller mer.
* `queue_digital_out oid=%c clock=%u on_ticks=%u` : Kommandot schemalägger en ändring av en digital GPIO-utgångspinne vid angiven klocktid. För att använda kommandot måste config_digital_out med samma 'oid' ha skickats under mikrokontrollerkonfigurationen. Om set_digital_out_pwm_cycle har anropats är 'on_ticks' till-tiden i klocktick för PWM-cykeln. Annars ska 'on_ticks' vara 0 för låg spänning eller 1 för hög spänning.
* `queue_pwm_out oid=%c clock=%u value=%hu` : Schemalägger en ändring av en PWM-utgångspinne i hårdvara. Se kommandona 'queue_digital_out' och 'config_pwm_out' för mer information.
* `query_analog_in oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u min_value=%hu max_value=%hu` : Kommandot upprättar ett återkommande schema för analoga ingångsprov. För att använda det måste config_analog_in med samma 'oid' ha skickats under mikrokontrollerkonfigurationen. Proverna börjar vid tiden 'clock'; kommandot rapporterar det erhållna värdet var 'rest_ticks' klocktick, gör 'sample_count' översamplingsprov och pausar 'sample_ticks' klocktick mellan proverna. Parametrarna 'min_value' och 'max_value' utgör en säkerhetsfunktion: mikrokontrollerprogramvaran kontrollerar att det samplade värdet, efter eventuell översampling, alltid ligger inom intervallet. Detta är avsett för pinnar anslutna till termistorer som styr värmare, för att kontrollera att en värmare håller sig inom ett temperaturintervall.
* `get_clock` : Kommandot får mikrokontrollern att skapa svarsmeddelandet "clock". Värden skickar kommandot en gång per sekund för att hämta mikrokontrollerklockans värde och uppskatta avdriften mellan värdens och mikrokontrollerns klockor. Det låter värden beräkna mikrokontrollerklockan noggrant.

### Stegmotorkommandon

* `queue_step oid=%c interval=%u count=%hu add=%hi` : Kommandot schemalägger 'count' steg för den aktuella stegmotorn, med 'interval' klocktick mellan varje steg. Första steget sker 'interval' klocktick efter det senaste schemalagda steget för motorn. Om 'add' inte är noll justeras intervallet med 'add' efter varje steg. Kommandot lägger den givna följden interval/count/add sist i en kö per stegmotor. Vid normal drift kan hundratals sådana följder köas. När en följd har utfört sina 'count' steg tas den bort från början av kön. Systemet låter mikrokontrollern köa potentiellt hundratusentals steg med tillförlitliga och förutsägbara schematider.
* `set_next_step_dir oid=%c dir=%c` : Kommandot anger värdet för dir_pin som nästa queue_step-kommando ska använda.
* `reset_step_clock oid=%c clock=%u` : Normalt är stegtimingen relativ till senaste steg för den aktuella stegmotorn. Kommandot återställer klockan så att nästa steg blir relativt till den angivna tiden 'clock'. Värden skickar vanligen bara detta kommando i början av en utskrift.
* `stepper_get_position oid=%c` : Kommandot får mikrokontrollern att skapa svarsmeddelandet "stepper_position" med stegmotorns aktuella position. Positionen är totalt antal steg med dir=1 minus totalt antal steg med dir=0.
* `endstop_home oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u pin_value=%c` : Kommandot används vid "homing" av stegmotorer. För att använda det måste config_endstop med samma 'oid' ha skickats under mikrokontrollerkonfigurationen. När kommandot anropas samplar mikrokontrollern ändstoppspinnen var 'rest_ticks' klocktick och kontrollerar om dess värde är lika med 'pin_value'. Om värdet stämmer och fortsätter stämma för ytterligare 'sample_count' prov med 'sample_ticks' mellanrum rensas rörelsekön för den berörda stegmotorn och motorn stannar omedelbart. Värden använder kommandot för homing: den instruerar ändstoppet att sampla efter en utlösning och skickar sedan en serie queue_step-kommandon som flyttar stegmotorn mot ändstoppet. När motorn träffar ändstoppet upptäcks utlösningen, rörelsen stoppas och värden meddelas.

### Rörelsekö

Varje queue_step-kommando använder en post i mikrokontrollerns "rörelsekö". Kön allokeras när den tar emot kommandot "finalize_config" och antalet tillgängliga köposter rapporteras i svarsmeddelanden av typen "config".

Värden ansvarar för att säkerställa att det finns ledigt utrymme i kön innan ett queue_step-kommando skickas. Den gör det genom att beräkna när varje queue_step-kommando avslutas och schemalägga nya queue_step-kommandon därefter.

### SPI-kommandon

* `spi_transfer oid=%c data=%*s` : Kommandot får mikrokontrollern att skicka 'data' till SPI-enheten som anges av 'oid' och skapar svarsmeddelandet "spi_transfer_response" med data som returneras vid överföringen.
* `spi_send oid=%c data=%*s` : Kommandot liknar "spi_transfer", men skapar inte något "spi_transfer_response"-meddelande.
