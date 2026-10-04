# Vanliga frågor

## Hur kan jag donera till projektet?

Tack för ditt stöd. Se [sponsorsidan](Sponsors.md) för information.

## Hur beräknar jag konfigurationsparametern rotation_distance?

Se [dokumentet om rotationsavstånd](Rotation_Distance.md).

## Var finns min seriella port?

Det vanliga sättet att hitta en seriell USB-port är att köra `ls /dev/serial/by-id/*` från en SSH-terminal på värddatorn. Resultatet liknar troligen följande:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Namnet från kommandot ovan är stabilt och kan användas i konfigurationsfilen och vid flashning av mikrokontrollerkoden. Ett flashningskommando kan till exempel se ut så här:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

och den uppdaterade konfigurationen kan se ut så här:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Kopiera och klistra alltid in namnet från `ls`-kommandot ovan, eftersom namnet skiljer sig mellan skrivare.

Om du använder flera mikrokontroller och de saknar unika id:n (vanligt på kort med CH340 USB-krets) följer du anvisningarna ovan men använder kommandot `ls /dev/serial/by-path/*` i stället.

## När mikrokontrollern startar om ändras enheten till /dev/ttyUSB1

Följ anvisningarna i avsnittet ["Var finns min seriella port?"](#wheres-my-serial-port) för att förhindra detta.

## Kommandot "make flash" fungerar inte

Koden försöker flasha enheten med den vanligaste metoden för varje plattform. Flashningsmetoderna varierar dock mycket, så kommandot "make flash" kanske inte fungerar på alla kort.

Om felet kommer och går eller om du har en standardinstallation bör du kontrollera att Klipper inte körs vid flashning (sudo service klipper stop), att OctoPrint inte försöker ansluta direkt till enheten och att FLASH_DEVICE är rätt angiven för ditt kort (se [frågan ovan](#wheres-my-serial-port)).

Om "make flash" inte fungerar för ditt kort måste du flasha manuellt. Kontrollera en fil i [konfigurationskatalogen](../config) med särskilda anvisningar. Kontrollera även korttillverkarens dokumentation. Det kan också gå att flasha med "avrdude" eller "bossac"; se [bootloader-dokumentet](Bootloaders.md) för mer information.

## Hur ändrar jag den seriella överföringshastigheten?

Den rekommenderade överföringshastigheten för Klipper är 250000. Den fungerar bra på alla mikrokontrollerkort som Klipper stöder. Om en nätguide rekommenderar en annan hastighet ska den delen ignoreras och standardvärdet 250000 användas.

Om du ändå vill ändra hastigheten måste den nya hastigheten konfigureras i mikrokontrollern (under **make menuconfig**) och den uppdaterade koden måste kompileras och flashas till mikrokontrollern. Klippers printer.cfg måste också uppdateras till samma hastighet (se [konfigurationsreferensen](Config_Reference.md#mcu) för detaljer). Till exempel:

```
[mcu]
baud: 250000
```

Överföringshastigheten som visas på OctoPrints webbsida påverkar inte Klippers interna överföringshastighet för mikrokontrollern. Ställ alltid OctoPrints hastighet till 250000 när Klipper används.

Klippers överföringshastighet för mikrokontrollern har inget samband med mikrokontrollerns starthanterares hastighet. Mer information om starthanterare finns i [dokumentet om starthanterare](Bootloaders.md).

## Kan jag köra Klipper på något annat än en Raspberry Pi 3?

Rekommenderad maskinvara är Raspberry Pi Zero2w, Raspberry Pi 3, Raspberry Pi 4 eller Raspberry Pi 5. Klipper fungerar även på andra SBC-enheter och x86-maskinvara, enligt beskrivningen nedan.

Klipper fungerar på Raspberry Pi 1 och 2 samt Raspberry Pi Zero1, men dessa kort har inte tillräcklig beräkningskapacitet för att köra Klipper väl. Vid utskrift uppstår ofta stopp, eftersom skrivaren kan röra sig snabbare än Klipper hinner skicka rörelsekommandon. Det rekommenderas inte att köra Klipper på dessa äldre maskiner.

Se [de särskilda installationsanvisningarna för Beaglebone](Beaglebone.md) för att köra på Beaglebone.

Klipper har körts på andra maskiner. Värdprogramvaran kräver endast Python på en Linuxdator (eller liknande). Om du vill köra den på en annan maskin behöver du dock Linuxadministratörskunskap för att installera systemkraven för just den maskinen. Skriptet [install-octopi.sh](../scripts/install-octopi.sh) beskriver de nödvändiga Linuxadministrationsstegen närmare.

Om Klippers värdprogramvara ska köras på ett enklare chip måste maskinen som minst ha maskinvarustöd för flyttal med dubbel precision.

Om Klippers värdprogramvara körs på en delad allmän dator eller server måste du tänka på att Klipper har krav på realtidsschemaläggning. Om värddatorn under en utskrift samtidigt gör en resurskrävande allmän beräkning (t.ex. diskdefragmentering, 3D-rendering eller kraftig växling) kan Klipper rapportera utskriftsfel.

Obs: Om du inte använder en OctoPi-avbildning bör du känna till att flera Linuxdistributioner aktiverar paketet "ModemManager" (eller liknande), som kan störa seriell kommunikation. Det kan få Klipper att rapportera till synes slumpmässiga fel som "Lost communication with MCU". Om du installerar Klipper på en sådan distribution kan paketet behöva inaktiveras.

## Kan jag köra flera Klipper-instanser på samma värddator?

Det går att köra flera instanser av Klippers värdprogramvara, men det kräver Linuxadministratörskunskap. Klippers installationsskript kör i slutänden följande Unix-kommando:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

Flera instanser av kommandot ovan kan köras så länge varje instans har sin egen skrivarkonfigurationsfil, egen loggfil och egen pseudo-TTY. Till exempel:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

Om du väljer detta måste nödvändiga start-, stopp- och installationsskript implementeras. Skripten [install-octopi.sh](../scripts/install-octopi.sh) och [klipper-start.sh](../scripts/klipper-start.sh) kan vara användbara exempel.

## Måste jag använda OctoPrint?

Klippers programvara är inte beroende av OctoPrint. Det går att använda alternativ programvara för att skicka kommandon till Klipper, men det kräver Linuxadministratörskunskap.

Klipper skapar en "virtuell seriell port" via filen "/tmp/printer" och emulerar ett klassiskt seriellt 3D-skrivargränssnitt genom den filen. Alternativ programvara kan i allmänhet fungera med Klipper om den kan konfigureras för att använda "/tmp/printer" som skrivarens seriella port.

## Varför kan jag inte flytta stegmotorn innan skrivaren hemställs?

Koden gör detta för att minska risken att av misstag kommendera huvudet in i bädden eller en vägg. När skrivaren har hemställts försöker programvaran kontrollera att varje rörelse ligger inom position_min/max i konfigurationsfilen. Om motorerna inaktiveras (med M84 eller M18) måste de hemställas igen innan de kan flyttas.

Om du vill flytta huvudet efter att en utskrift avbrutits via OctoPrint kan du ändra OctoPrints avbrytningssekvens så att den gör det. Den konfigureras i en webbläsare i OctoPrint under Inställningar → GCODE-skript.

Om du vill flytta huvudet efter avslutad utskrift kan du lägga till önskad rörelse i avsnittet "custom g-code" i skivningsprogrammet.

Om skrivaren kräver ytterligare rörelse som del av själva hemställningen (eller saknar hemställning) kan du använda ett avsnitt `safe_z_home` eller `homing_override` i konfigurationsfilen. Om en stegmotor behöver flyttas för diagnostik eller felsökning kan ett avsnitt `force_move` läggas till. Mer information finns i [konfigurationsreferensen](Config_Reference.md#customized_homing).

## Varför är Z position_endstop satt till 0,5 i standardkonfigurationerna?

För kartesiska skrivare anger Z position_endstop hur långt munstycket är från bädden när ändläget aktiveras. Om möjligt rekommenderas ett Z-max-ändläge och hemställning bort från bädden, vilket minskar risken för bäddkollisioner. Om hemställning mot bädden krävs bör ändläget placeras så att det aktiveras medan munstycket fortfarande är en liten bit från bädden. Axeln stannar då innan munstycket rör bädden. Mer information finns i [dokumentet om bäddnivellering](Bed_Level.md).

## Jag konverterade konfigurationen från Marlin och X/Y-axlarna fungerar, men Z-axeln skriker vid hemställning

Kort svar: Kontrollera först stegmotorkonfigurationen enligt [dokumentet om konfigurationskontroll](Config_checks.md). Om problemet kvarstår kan du prova att sänka inställningen max_z_velocity i skrivarkonfigurationen.

Långt svar: I praktiken kan Marlin vanligen bara stega med omkring 10 000 steg per sekund. Om en begärd rörelse kräver högre stegfrekvens stegar Marlin i allmänhet bara så fort det går. Klipper kan nå mycket högre stegfrekvenser, men stegmotorn kanske inte har tillräckligt vridmoment vid den högre hastigheten. För en Z-axel med hög utväxling eller många mikrosteg kan den faktiskt möjliga max_z_velocity därför vara lägre än värdet i Marlin.

## Min TMC-motordrivrutin stängs av mitt under en utskrift

Om drivrutinen TMC2208 (eller TMC2224) används i "standalone mode" ska du använda [senaste Klipper-versionen](#how-do-i-upgrade-to-the-latest-software). En lösning för ett problem med TMC2208-drivrutinens "stealthchop" lades till i Klipper i mitten av mars 2020.

## Jag får slumpmässiga fel av typen "Lost communication with MCU"

Detta orsakas ofta av maskinvarufel i USB-anslutningen mellan värddatorn och mikrokontrollern. Kontrollera följande:

- Använd en USB-kabel av god kvalitet mellan värddatorn och mikrokontrollern. Kontrollera att kontakterna sitter ordentligt.
- Om du använder Raspberry Pi ska du använda en [nätadapter av god kvalitet](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply) och en [USB-kabel av god kvalitet](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877) mellan nätadaptern och Pi. Varningar om "under voltage" från OctoPrint beror på nätadaptern och måste åtgärdas.
- Kontrollera att skrivarens nätaggregat inte överbelastas. (Spänningsvariationer till mikrokontrollerns USB-krets kan göra att kretsen startas om.)
- Kontrollera att kablar till stegmotorer, värmare och andra skrivardelar inte är klämda eller slitna. (Skrivarens rörelser kan belasta en felaktig kabel så att den tappar kontakt, kortsluts kortvarigt eller skapar överdrivet brus.)
- Det har rapporterats om kraftigt USB-brus när både skrivarens och värddatorns 5 V-strömförsörjning blandas. Om mikrokontrollern startar när antingen skrivarens nätaggregat är på eller USB-kabeln ansluts betyder det att 5 V-försörjningarna är sammankopplade. Det kan hjälpa att konfigurera mikrokontrollern att använda endast en strömkälla. Alternativt kan en USB-kabel ändras så att den inte för 5 V mellan värddatorn och mikrokontrollern, om kortet inte kan konfigureras för strömkällan.

## Min Raspberry Pi fortsätter att starta om under utskrifter

Det beror troligen på spänningsvariationer. Följ samma felsökningssteg som för ett fel ["Lost communication with MCU"](#i-keep-getting-random-lost-communication-with-mcu-errors).

## Min AVR-enhet hänger sig vid omstart när jag ställer in `restart_method=command`

Vissa gamla versioner av AVR-starthanteraren har ett känt fel i hanteringen av watchdog-händelser. Det visar sig vanligen när restart_method i printer.cfg är satt till "command". När felet uppstår svarar AVR-enheten inte förrän strömmen tas bort och ansluts igen (ström- eller statuslysdioder kan också blinka upprepat tills strömmen bryts).

Lösningen är att använda en restart_method annan än "command" eller att flasha en uppdaterad starthanterare till AVR-enheten. Att flasha en ny starthanterare är ett engångssteg som vanligen kräver en extern programmerare – se [Starthanterare](Bootloaders.md) för mer information.

## Lämnas värmarna på om Raspberry Pi kraschar?

Programvaran är konstruerad för att förhindra detta. När värddatorn aktiverar en värmare måste den bekräfta aktiveringen var tredje sekund. Om mikrokontrollern inte får en bekräftelse var tredje sekund går den till läget "shutdown", som är utformat för att stänga av alla värmare och stegmotorer.

Se kommandot "config_digital_out" i dokumentet [MCU-kommandon](MCU_Commands.md) för mer information.

Dessutom konfigureras mikrokontrollerprogramvaran vid start med ett minimi- och maximitemperaturintervall för varje värmare (se parametrarna min_temp och max_temp i [konfigurationsreferensen](Config_Reference.md#extruder)). Om mikrokontrollern upptäcker temperatur utanför intervallet går den också till tillståndet "shutdown".

Värdprogramvaran har dessutom kod som kontrollerar att värmare och temperatursensorer fungerar korrekt. Se [konfigurationsreferensen](Config_Reference.md#verify_heater) för mer information.

## Hur konverterar jag ett Marlin-stiftnummer till ett Klipper-stiftnamn?

Kort svar: En mappning finns i [sample-aliases.cfg](../config/sample-aliases.cfg). Använd den för att hitta mikrokontrollerns verkliga stiftnamn. Du kan använda alias i konfigurationen, men det är bättre att använda de verkliga stiftnamnen. Filen använder prefixet "ar" i stället för "D" (t.ex. `D23` blir `ar23`) och "analog" i stället för "A" (t.ex. `A14` blir `analog14`).

Långt svar: Klipper använder mikrokontrollerns standardiserade stiftnamn. På Atmega-kretsar har dessa maskinvarustift namn som `PA4`, `PC7` eller `PD2`.

Arduino-projektet beslutade för länge sedan att undvika maskinvarans standardnamn och använda egna stiftnamn med löpnummer, vanligtvis `D23` eller `A14`. Det har orsakat mycket förvirring, eftersom Arduinos stiftnummer ofta inte motsvarar samma maskinvarunamn. Exempelvis är `D21` `PD0` på ett vanligt Arduino-kort men `PC7` på ett annat.

För att undvika denna förvirring använder Klippers kärnkod de standardiserade stiftnamn som definieras av mikrokontrollern.

## Måste jag ansluta enheten till en viss typ av mikrokontrollerstift?

Det beror på typen av enhet och stift:

ADC-stift (eller analoga stift): För termistorer och liknande "analoga" sensorer måste enheten anslutas till ett stift på mikrokontrollern som stöder "analog" eller "ADC". Om Klipper konfigureras att använda ett stift utan analogt stöd rapporteras felet "Not a valid ADC pin".

PWM-stift (eller timerstift): Klipper använder inte maskinvaru-PWM som standard för någon enhet. I allmänhet kan värmare, fläktar och liknande anslutas till vilket I/O-stift som helst. Fläktar och output_pin-enheter kan dock konfigureras med `hardware_pwm: True`; då måste mikrokontrollern stödja maskinvaru-PWM på stiftet, annars rapporterar Klipper "Not a valid PWM pin".

IRQ-stift (eller avbrottsstift): Klipper använder inte maskinvaruavbrott på I/O-stift, så en enhet behöver aldrig anslutas till ett sådant mikrokontrollerstift.

SPI-stift: Vid maskinvaru-SPI måste stiften anslutas till mikrokontrollerns SPI-kompatibla stift. De flesta enheter kan dock konfigureras för "mjukvaru-SPI", så att valfria IO-stift för allmänna ändamål kan användas.

I2C-stift: Vid användning av I2C måste stiften anslutas till mikrokontrollerns I2C-kompatibla stift.

Andra enheter kan anslutas till valfria IO-stift för allmänna ändamål, till exempel stegmotorer, värmare, fläktar, Z-prober, servon, lysdioder, vanliga hd44780-/st7920-LCD-skärmar och Trinamics UART-styrledning.

## Hur avbryter jag en M109/M190-begäran om att vänta på temperatur?

Gå till terminalfliken i OctoPrint och skriv M112. Klipper går då till läget "shutdown" och OctoPrint kopplas från. Klicka på "Connect" i OctoPrint för att ansluta igen. Gå tillbaka till terminalfliken och kör FIRMWARE_RESTART för att rensa Klippers felstatus. Den tidigare uppvärmningsbegäran avbryts och en ny utskrift kan startas.

## Kan jag ta reda på om skrivaren har tappat steg?

På sätt och vis. Nollställ skrivaren, kör `GET_POSITION`, kör utskriften, nollställ igen och kör ytterligare `GET_POSITION`. Jämför sedan värdena på raden `mcu:`.

Det kan hjälpa till att finjustera stegmotorströmmar, accelerationer och hastigheter utan att skriva ut och slösa filament: kör bara snabba rörelser mellan `GET_POSITION`-kommandona.

Observera att ändlägesbrytare tenderar att lösa ut vid något olika positioner, så en skillnad på några mikrosteg beror sannolikt på deras onoggrannhet. En stegmotor kan bara tappa steg i steg om fyra hela steg. Vid 16 mikrosteg innebär ett tappat steg att stegräknaren `mcu:` avviker med en multipel av 64 mikrosteg.

## Varför rapporterar Klipper fel? Jag förlorade min utskrift!

Kort svar: Vi vill veta när skrivaren upptäcker ett problem så att orsaken kan åtgärdas och utskrifterna blir av hög kvalitet. Vi vill definitivt inte att skrivaren tyst producerar utskrifter av låg kvalitet.

Långt svar: Klipper är konstruerat för att automatiskt hantera många övergående problem. Det upptäcker exempelvis kommunikationsfel och skickar om data samt buffrar kommandon på flera nivåer för exakt tidsstyrning trots störningar. Om programvaran upptäcker ett fel den inte kan återhämta sig från, får ett ogiltigt kommando eller inte kan utföra sin uppgift, rapporterar Klipper ett fel. Då är risken stor för en utskrift av låg kvalitet eller värre. Felmeddelandet ger användaren möjlighet att åtgärda orsaken.

Några närliggande frågor är: Varför pausar inte Klipper utskriften i stället? Varför visas inte en varning? Varför kontrolleras inte fel före utskriften? Varför ignoreras inte kommandon som användaren skriver? Klipper använder för närvarande G-kodprotokollet, som tyvärr inte är tillräckligt flexibelt för att dessa alternativ ska vara praktiska. Utvecklarna vill förbättra användarupplevelsen vid onormala händelser, men det kräver troligen betydande infrastrukturarbete, inklusive en övergång från G-kod.

## Hur uppgraderar jag till den senaste programvaran?

Det första steget vid uppgradering är att läsa det senaste dokumentet om [konfigurationsändringar](Config_Changes.md). Ibland kräver ändringar i programvaran att användaren uppdaterar inställningarna. Det är bra att läsa dokumentet före uppgraderingen.

Den vanliga metoden är att ansluta med ssh till Raspberry Pi och köra:

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

Därefter kan mikrokontrollerns kod kompileras om och flashas, till exempel:

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

Ofta ändras dock bara värdprogramvaran. Då kan enbart den uppdateras och startas om med:

```
cd ~/klipper
git pull
sudo service klipper restart
```

Om programvaran efter denna genväg varnar för att mikrokontrollern behöver flashas om, eller om något annat ovanligt fel uppstår, följer du de fullständiga uppgraderingsstegen ovan.

Om något fel kvarstår ska du kontrollera dokumentet om [konfigurationsändringar](Config_Changes.md) en gång till; skrivarens konfiguration kan behöva ändras.

Observera att G-kodkommandona RESTART och FIRMWARE_RESTART inte läser in ny programvara; för att en programvaruändring ska börja gälla krävs kommandona "sudo service klipper restart" respektive "make flash" ovan.

## Hur avinstallerar jag Klipper?

På firmware-sidan behövs inget särskilt. Följ bara flashningsanvisningarna för den nya firmware-versionen.

På Raspberry Pi finns ett avinstallationsskript i [scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh), till exempel:

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
