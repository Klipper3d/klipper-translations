# Kodöversikt

Detta dokument beskriver Klippers övergripande kodstruktur och viktiga kodflöden.

## Katalogstruktur

Katalogen **src/** innehåller C-källkod för mikrokontrollerkoden. Katalogerna **src/atsam/**, **src/atsamd/**, **src/avr/**, **src/linux/**, **src/lpc176x/**, **src/pru/** och **src/stm32/** innehåller arkitekturspecifik mikrokontrollerkod. **src/simulator/** innehåller kodstubbar som gör att mikrokontrollern kan testkompileras på andra arkitekturer. Katalogen **src/generic/** innehåller hjälpkod som kan vara användbar för olika arkitekturer. Bygget söker först efter inkluderingar av "board/somefile.h" i den aktuella arkitekturkatalogen (t.ex. src/avr/somefile.h) och därefter i den generiska katalogen (t.ex. src/generic/somefile.h).

Katalogen **klippy/** innehåller värdprogramvaran. Större delen av värdprogramvaran är skriven i Python, men **klippy/chelper/** innehåller några hjälprutiner i C. **klippy/kinematics/** innehåller kod för robotkinematik. **klippy/extras/** innehåller utbyggbara "moduler" för värdkoden.

Katalogen **lib/** innehåller extern bibliotekskod från tredje part som krävs för att bygga vissa mål.

Katalogen **config/** innehåller exempel på skrivarkonfigurationsfiler.

Katalogen **scripts/** innehåller byggskript som är användbara för att kompilera mikrokontrollerkoden.

Katalogen **test/** innehåller automatiserade testfall.

Under kompileringen kan bygget skapa katalogen **out/**. Den innehåller tillfälliga byggobjekt. Det färdiga mikrokontrollerobjektet är **out/klipper.elf.hex** på AVR och **out/klipper.bin** på ARM.

## Mikrokontrollerkodens flöde

Körningen av mikrokontrollerkoden börjar i arkitekturspecifik kod (t.ex. **src/avr/main.c**) som slutligen anropar sched_main() i **src/sched.c**. Koden sched_main() börjar med att köra alla funktioner som märkts med makrot DECL_INIT(). Därefter körs upprepade gånger alla funktioner som märkts med makrot DECL_TASK().

En av huvuduppgiftsfunktionerna är command_dispatch() i **src/command.c**. Funktionen anropas från kortspecifik in-/utmatningskod (t.ex. **src/avr/serial.c**, **src/generic/serial_irq.c**) och kör de kommandofunktioner som hör till kommandona i indataströmmen. Kommandofunktioner deklareras med makrot DECL_COMMAND() (se dokumentet [protokoll](Protocol.md) för mer information).

Uppgifts-, initierings- och kommandofunktioner körs alltid med avbrott aktiverade, även om de tillfälligt kan inaktivera avbrott vid behov. Dessa funktioner bör undvika långa pauser, fördröjningar eller arbete som tar avsevärd tid. Långa fördröjningar i dessa "task"-funktioner ger schemaläggningsjitter för andra uppgifter: fördröjningar över 100 us kan märkas, över 500 us kan leda till omsändning av kommandon och över 100 ms kan leda till omstarter genom watchdog. Funktionerna schemalägger arbete vid bestämda tider genom att schemalägga timers.

Timerfunktioner schemaläggs genom anrop av sched_add_timer() (i **src/sched.c**). Schemaläggaren ser till att den angivna funktionen anropas vid den begärda klocktiden. Timeravbrott hanteras först av en arkitekturspecifik avbrottshanterare (t.ex. **src/avr/timer.c**), som anropar sched_timer_dispatch() i **src/sched.c**. Timeravbrottet leder till körning av schemalagda timerfunktioner. Timerfunktioner körs alltid med avbrott inaktiverade och bör alltid slutföras inom några få mikrosekunder. När timerhändelsen är klar kan funktionen välja att schemalägga sig själv igen.

Om ett fel upptäcks kan koden anropa shutdown() (ett makro som anropar sched_shutdown() i **src/sched.c**). Anrop av shutdown() gör att alla funktioner som märkts med makrot DECL_SHUTDOWN() körs. Shutdown-funktioner körs alltid med avbrott inaktiverade.

En stor del av mikrokontrollerns funktionalitet arbetar med GPIO-stift (General-Purpose Input/Output). För att abstrahera den arkitekturspecifika koden på låg nivå från uppgiftskoden på hög nivå implementeras alla GPIO-händelser i arkitekturspecifika omslutningar (t.ex. **src/avr/gpio.c**). Koden kompileras med gcc-optimeringen "-flto -fwhole-program", som är mycket bra på att infoga funktioner mellan kompileringsenheter. De flesta av dessa små GPIO-funktioner infogas därför hos sina anropare, utan någon körtidskostnad.

## Översikt över Klippy-koden

Värdkoden (Klippy) är avsedd att köras på en billig dator, exempelvis en Raspberry Pi, tillsammans med mikrokontrollern. Koden är huvudsakligen skriven i Python men använder CFFI för viss funktionalitet i C.

Den inledande körningen startar i **klippy/klippy.py**. Den läser kommandoradsargumenten, öppnar skrivarens konfigurationsfil, instansierar de huvudsakliga skrivarobjekten och startar den seriella anslutningen. Huvudkörningen av G-kodkommandon sker i metoden _process_commands() i **klippy/gcode.py**. Koden översätter G-kodkommandon till anrop av skrivarobjekt, vilka ofta översätter åtgärderna till kommandon som ska köras på mikrokontrollern, enligt deklarationen med makrot DECL_COMMAND i mikrokontrollerkoden.

Det finns flera trådar i Klippers värdkod:

* Det finns en "huvudtråd" i Python som hanterar inkommande G-kodkommandon och är startpunkten för de flesta åtgärder. Tråden kör [reaktorn](https://en.wikipedia.org/wiki/Reactor_pattern) (**klippy/reactor.py**) och de flesta åtgärder på hög nivå härstammar från IO- och timerhändelseåteranrop från den reaktorn.
* En tråd skriver meddelanden till loggen så att övriga trådar inte blockeras vid loggskrivning. Den finns i koden **klippy/queuelogger.py** och dess flertrådiga natur exponeras inte för Pythons huvudtråd.
* En tråd per mikrokontroller utför läsning och skrivning av meddelanden på låg nivå till den mikrokontrollern. Den finns i C-koden **klippy/chelper/serialqueue.c** och dess flertrådiga natur exponeras inte för Python-koden.
* En tråd per mikrokontroller bearbetar meddelanden som tagits emot från den mikrokontrollern i Python-koden. Tråden skapas i **klippy/serialhdl.py**. Försiktighet krävs med Python-återanrop från denna tråd eftersom den kan interagera direkt med Pythons huvudtråd.
* En tråd per stegmotor beräknar tidpunkterna för stegmotorns stegpulser och komprimerar tiderna. Den finns i C-koden **klippy/chelper/steppersync.c** och dess flertrådiga natur exponeras inte för Python-koden.

## Kodflöde för ett rörelsekommando

En vanlig skrivarrörelse börjar när kommandot "G1" skickas till Klippy-värden och avslutas när motsvarande stegpulser skapas på mikrokontrollern. Det här avsnittet beskriver kodflödet för ett vanligt rörelsekommando. Dokumentet [kinematik](Kinematics.md) innehåller mer information om rörelsernas mekanik.

* Bearbetningen av ett rörelsekommando börjar i gcode.py. Syftet med gcode.py är att översätta G-kod till interna anrop. Ett G1-kommando anropar cmd_G1() i klippy/extras/gcode_move.py. Koden gcode_move.py hanterar ändringar av origo (t.ex. G92), relativa respektive absoluta positioner (t.ex. G90) och enheter (t.ex. F6000=100mm/s). Kodvägen för en rörelse är: `_process_data() -> _process_commands() -> cmd_G1()`. Slutligen anropas klassen ToolHead för att utföra den faktiska begäran: `cmd_G1() -> ToolHead.move()`
* Klassen ToolHead, i toolhead.py, hanterar "look-ahead" och spårar tiden för utskriftsåtgärder. Huvudkodvägen för en rörelse är: `ToolHead.move() -> LookAheadQueue.add_move()`, sedan `ToolHead.move() -> ToolHead._process_lookahead() -> LookAheadQueue.flush() -> Move.set_junction()` och därefter `ToolHead._process_lookahead() -> trapq_append()`.

   * ToolHead.move() skapar ett Move()-objekt med rörelsens parametrar (i kartesiskt rum och i enheterna sekunder och millimeter).
   * Kinematikklassen får möjlighet att kontrollera varje rörelse (`ToolHead.move() -> kin.check_move()`). Kinematikklasserna finns i katalogen klippy/kinematics/. Koden check_move() kan utlösa ett fel om rörelsen inte är giltig. Om check_move() slutförs utan fel måste den underliggande kinematiken kunna hantera rörelsen.
   * LookAheadQueue.add_move() placerar rörelseobjektet i "look-ahead"-kön.
   * LookAheadQueue.flush() fastställer start- och sluthastigheten för varje rörelse.
   * Move.set_junction() implementerar "trapetsgeneratorn" för en rörelse. Trapetsgeneratorn delar upp varje rörelse i tre delar: en fas med konstant acceleration, följd av en fas med konstant hastighet, följd av en fas med konstant retardation. Varje rörelse innehåller dessa tre faser i denna ordning, men vissa faser kan ha noll i varaktighet.
   * När ToolHead._process_lookahead() fortsätter är allt om rörelsen känt: startplats, slutplats, acceleration, start-/marschart-/sluthastighet samt sträckan under acceleration, marschfart och retardation. All information lagras i klassen Move() och är i kartesiskt rum med enheterna millimeter och sekunder.
   * Rörelserna placeras sedan i en "trapetsrörelsekö" via trapq_append(), i klippy/chelper/trapq.c. Trapq lagrar all information i klassen Move() i en C-struktur som värdens C-kod kan komma åt.
* Observera att extrudern hanteras i en egen kinematikklass: `ToolHead._process_lookahead() -> PrinterExtruder.process_move()`. Eftersom klassen Move() anger exakt rörelsetid och stegpulser skickas till mikrokontrollern med specifik tidpunkt synkroniseras stegmotorrörelser som skapas av extruderklassen med huvudets rörelser även om koden hålls separat.
* Av effektivitetsorsaker genereras stegmotorrörelser i C-koden i en tråd per stegmotor. Trådarna meddelas när steg ska genereras av modulen motion_queuing (klippy/extras/motion_queuing.py): `PrinterMotionQueuing._flush_handler() -> PrinterMotionQueuing._advance_move_time() -> steppersyncmgr_gen_steps() -> se_start_gen_steps()`.
* Klipper använder en [iterativ lösare](https://en.wikipedia.org/wiki/Root-finding_algorithm) för att generera stegtider för varje stegmotor. Stegtiderna genereras från bakgrundstråden (klippy/chelper/steppersync.c): `se_background_thread() -> se_generate_steps() -> itersolve_generate_steps() -> itersolve_gen_steps_range()` i klippy/chelper/itersolve.c. Målet med den iterativa lösaren är att hitta stegtider utifrån en funktion som beräknar en stegmotorposition från en tid. Det görs genom att upprepade gånger "gissa" olika tider tills formeln för stegmotorpositionen returnerar den önskade positionen för nästa steg. Återkopplingen från varje gissning används för att förbättra kommande gissningar så att processen snabbt konvergerar mot önskad tid. De kinematiska formlerna för stegmotorpositioner finns i klippy/chelper/, exempelvis kin_cart.c, kin_corexy.c, kin_delta.c och kin_extruder.c.
* När den iterativa lösaren har beräknat stegtiderna läggs de till i en vektor: `itersolve_gen_steps_range() -> stepcompress_append()` (i klippy/chelper/stepcompress.c). Vektorn (struct stepcompress.queue) lagrar motsvarande mikrokontrollerklocktider för varje steg. Värdet för "mikrokontrollerklockräknaren" motsvarar direkt mikrokontrollerns hårdvaruräknare och är relativt till när mikrokontrollern senast slogs på.
* Nästa stora steg är att komprimera stegen: `stepcompress_flush() -> compress_bisect_add()` i klippy/chelper/stepcompress.c. Koden genererar och kodar en serie mikrokontrollerkommandon av typen "queue_step" som motsvarar listan över stegmotorns stegtider från föregående steg. Dessa "queue_step"-kommandon köas sedan, prioriteras och skickas till mikrokontrollern via steppersync.c:steppersync och serialqueue.c:serialqueue.
* Bearbetningen av queue_step-kommandon på mikrokontrollern börjar i src/command.c, som tolkar kommandot och anropar `command_queue_step()`. Koden command_queue_step() (i src/stepper.c) lägger endast parametrarna för varje queue_step-kommando i en kö per stegmotor. Vid normal drift tolkas och köas queue_step-kommandot minst 100 ms före tiden för dess första steg. Slutligen genereras stegmotorhändelser i `stepper_event()`. Den anropas från maskinvarans timeravbrott vid den schemalagda tiden för det första steget. Koden stepper_event() skapar en stegpuls och schemalägger sedan sig själv på tiden för nästa stegpuls för de angivna queue_step-parametrarna. Parametrarna för varje queue_step-kommando är "interval", "count" och "add". På en övergripande nivå kör stepper_event() följande 'count' gånger: `do_step(); next_wake_time = last_wake_time + interval; interval += add;`

Ovanstående kan verka vara mycket komplexitet för att utföra en rörelse. De egentligt intressanta delarna finns dock bara i klasserna ToolHead och kinematik. Det är denna del av koden som anger rörelserna och deras tider. Resten av bearbetningen är mest kommunikation och kopplingskod.

## Lägga till en värdmodul

Klippys värdkod kan läsa in moduler dynamiskt. Om en konfigurationssektion med namnet "[my_module]" finns i skrivarens konfigurationsfil försöker programvaran automatiskt läsa in Python-modulen klippy/extras/my_module.py. Detta modulsystem är den rekommenderade metoden för att lägga till ny funktionalitet i Klipper.

Det enklaste sättet att lägga till en ny modul är att använda en befintlig modul som referens – se **klippy/extras/servo.py** som exempel.

Följande kan också vara användbart:

* Modulens körning startar i funktionen `load_config()` på modulnivå (för konfigurationssektioner av formen [my_module]) eller i `load_config_prefix()` (för konfigurationssektioner av formen [my_module my_name]). Funktionen får ett "config"-objekt och måste returnera ett nytt "printer object" som hör till den angivna konfigurationssektionen.
* När ett nytt skrivarobjekt instansieras kan config-objektet användas för att läsa parametrar från den aktuella konfigurationssektionen. Det görs med metoderna `config.get()`, `config.getfloat()`, `config.getint()` och så vidare. Läs alla värden från konfigurationen när skrivarobjektet skapas. Om användaren anger en konfigurationsparameter som inte läses i detta skede antas den vara ett skrivfel i konfigurationen och ett fel utlöses.
* Använd metoden `config.get_printer()` för att få en referens till huvudklassen "printer". Klassen lagrar referenser till alla instansierade "printer objects". Använd `printer.lookup_object()` för att hitta referenser till andra skrivarobjekt. Nästan all funktionalitet, även centrala kinematikmoduler, är inkapslad i ett av dessa objekt. När en ny modul instansieras har dock inte alla andra skrivarobjekt nödvändigtvis instansierats. Modulerna "gcode" och "pins" finns alltid, men för andra moduler är det lämpligt att skjuta upp uppslaget.
* Registrera händelsehanterare med metoden `printer.register_event_handler()` om koden behöver anropas under "händelser" som utlöses av andra skrivarobjekt. Varje händelsenamn är en sträng och består enligt konvention av namnet på den huvudsakliga källmodulen som utlöser händelsen samt ett kort namn på åtgärden (t.ex. "klippy:connect"). Parametrarna till varje händelsehanterare är specifika för händelsen, liksom undantagshantering och körningskontext. Två vanliga starthändelser är:
   * klippy:connect – Denna händelse genereras efter att alla skrivarobjekt har instansierats. Den används vanligen för att slå upp andra skrivarobjekt, kontrollera konfigurationsinställningar och utföra en första "handskakning" med skrivarens maskinvara.
   * klippy:ready – Denna händelse genereras när alla connect-hanterare har slutförts utan fel. Den anger att skrivaren övergår till ett tillstånd där den är redo för normal drift. Utlös inte ett fel i detta återanrop.
* Om användarens konfiguration innehåller ett fel ska det utlösas under fasen `load_config()` eller "connect event". Använd antingen `raise config.error("my error")` eller `raise printer.config_error("my error")` för att rapportera felet.
* Lagra inte en referens till objektet `config` i en medlemsvariabel i en klass, eller på en liknande plats som kan finnas kvar efter den första modulinläsningen. Objektet `config` är en referens till en klass för "konfigurationsinläsningsfasen" och dess metoder får inte anropas efter att denna fas har slutförts.
* Använd modulen "pins" för att konfigurera ett stift på en mikrokontroller. Det görs vanligen med något som `printer.lookup_object("pins").setup_pin("pwm", config.get("my_pin"))`. Det returnerade objektet kan sedan styras vid körning.
* Om skrivarobjektet definierar metoden `get_status()` kan modulen exportera [statusinformation](Status_Reference.md) via [makron](Command_Templates.md) och [API-servern](API_Server.md). Metoden `get_status()` måste returnera en Python-ordbok med strängnycklar och värden som är heltal, flyttal, strängar, listor, ordböcker, True, False eller None. Tupler och namngivna tupler kan också användas; de visas som listor via API-servern. Exporterade listor och ordböcker måste behandlas som "oföränderliga". Om innehållet ändras måste `get_status()` returnera ett nytt objekt, annars upptäcker API-servern inte ändringarna.
* Om modulen behöver åtkomst till systemtid eller externa filbeskrivare, använd `printer.get_reactor()` för att få åtkomst till den globala klassen "event reactor". Reaktorklassen gör det möjligt att schemalägga timerhändelser, vänta på indata från filbeskrivare och "sova" värdkoden.
* Använd inte globala variabler. Allt tillstånd ska lagras i skrivarobjektet som returneras från `load_config()`. Detta är viktigt eftersom kommandot RESTART annars kanske inte fungerar som väntat. Om externa filer eller socketar öppnas ska dessutom en händelsehanterare för "klippy:disconnect" registreras och stänga dem från återanropet.
* Undvik att komma åt interna medlemsvariabler, eller att anropa metoder som börjar med understreck, i andra skrivarobjekt. Genom att följa denna konvention blir framtida ändringar enklare att hantera.
* Det rekommenderas att tilldela alla medlemsvariabler ett värde i Python-klassernas konstruktor. Undvik därmed Pythons möjlighet att skapa nya medlemsvariabler dynamiskt.
* Om en Python-variabel ska lagra ett flyttal rekommenderas att alltid tilldela och ändra den med flyttalskonstanter, aldrig heltalskonstanter. Föredra till exempel `self.speed = 1.` framför `self.speed = 1` och `self.speed = 2. * x` framför `self.speed = 2 * x`. Konsekvent användning av flyttal kan undvika svårfelsökta egenheter i Pythons typomvandlingar.
* Om modulen skickas in för att inkluderas i Klippers huvudkod ska en copyrightnotis placeras högst upp i modulen. Se befintliga moduler för föredraget format.

## Lägga till ny kinematik

Detta avsnitt ger några råd om att lägga till stöd för ytterligare typer av skrivarkinematik i Klipper. Arbetet kräver god förståelse för de matematiska formlerna för den aktuella kinematiken samt programutvecklingskunskaper, även om bara värdprogramvaran normalt behöver uppdateras.

Användbara steg:

1. Börja med att studera avsnittet "[kodflöde för en rörelse](#code-flow-of-a-move-command)" och [kinematikdokumentet](Kinematics.md).
1. Granska befintliga kinematikklasser i katalogen klippy/kinematics/. Kinematikklasserna omvandlar en rörelse i kartesiska koordinater till rörelser på varje stegmotor. En av dessa filer kan kopieras som utgångspunkt.
1. Implementera C-funktionerna för stegmotorernas kinematiska position för varje stegmotor om de inte redan finns (se kin_cart.c, kin_corexy.c och kin_delta.c i klippy/chelper/). Funktionen ska anropa `move_get_coord()` för att omvandla en angiven rörelsetid i sekunder till en kartesisk koordinat i millimeter och sedan beräkna önskad stegmotorposition i millimeter från den kartesiska koordinaten.
1. Implementera metoden `calc_position()` i den nya kinematikklassen. Metoden beräknar verktygshuvudets position i kartesiska koordinater från varje stegmotors position. Den behöver inte vara effektiv eftersom den vanligtvis bara anropas vid hemkörning och sondering.
1. Andra metoder. Implementera `check_move()`, `get_status()`, `get_steppers()`, `home()`, `clear_homing_state()` och `set_position()`. Funktionerna används vanligen för kinematikspecifika kontroller. I början av utvecklingen kan dock standardkod användas här.
1. Implementera testfall. Skapa en G-kodfil med en serie rörelser som kan testa viktiga fall för den aktuella kinematiken. Följ [felsökningsdokumentationen](Debugging.md) för att omvandla G-kodfilen till mikrokontrollerkommandon. Detta är användbart för att testa randfall och kontrollera regressioner.

## Portera till en ny mikrokontroller

Detta avsnitt ger några råd om att portera Klippers mikrokontrollerkod till en ny arkitektur. Arbetet kräver goda kunskaper om inbyggd utveckling och praktisk tillgång till målmikrokontrollern.

Användbara steg:

1. Börja med att identifiera tredjepartsbibliotek som används vid porteringen. Vanliga exempel är omslutningar för "CMSIS" och tillverkarens "HAL"-bibliotek. All tredjepartskod måste vara kompatibel med GNU GPLv3. Koden från tredje part ska checkas in i Klippers katalog lib/. Uppdatera lib/README med information om var och när biblioteket hämtades. Det är bäst att kopiera koden oförändrad till Klipper-förrådet, men om ändringar krävs ska de anges uttryckligen i lib/README.
1. Skapa en ny underkatalog för arkitekturen i src/ och lägg till initialt stöd för Kconfig och Makefile. Använd befintliga arkitekturer som vägledning. src/simulator ger ett grundläggande exempel på en minsta utgångspunkt.
1. Den första huvudsakliga programmeringsuppgiften är att få kommunikationsstöd för målkortet att fungera. Detta är det svåraste steget i en ny portning. När grundläggande kommunikation fungerar blir de återstående stegen oftast mycket enklare. Vid den första utvecklingen används vanligen en seriell enhet av typen UART eftersom sådan maskinvara normalt är lättare att aktivera och styra. Använd under denna fas gärna hjälpkod från src/generic/ (se hur src/simulator/Makefile inkluderar den generiska C-koden i bygget). Det är också nödvändigt att definiera timer_read_time(), som returnerar den aktuella systemklockan, men fullständigt stöd för timer-IRQ behöver ännu inte finnas.
1. Bekanta dig med verktyget console.py, såsom det beskrivs i [felsökningsdokumentet](Debugging.md), och kontrollera anslutningen till mikrokontrollern med det. Verktyget omvandlar kommunikationsprotokollet på låg nivå till en människoläsbar form.
1. Lägg till stöd för timerdistribution från maskinvaruavbrott. Se Klipper-[commit 970831ee](https://github.com/Klipper3d/klipper/commit/970831ee0d3b91897196e92270d98b2a3067427f) som exempel på steg 1–5 för arkitekturen LPC176x.
1. Få grundläggande stöd för GPIO-indata och -utdata att fungera. Se Klipper-[commit c78b9076](https://github.com/Klipper3d/klipper/commit/c78b90767f19c9e8510c3155b89fb7ad64ca3c54) som exempel.
1. Få ytterligare kringutrustning att fungera – se till exempel Klipper-[commitarna 65613aed](https://github.com/Klipper3d/klipper/commit/65613aeddfb9ef86905cb1dade9e773a02ef3c27), [c812a40a](https://github.com/Klipper3d/klipper/commit/c812a40a3782415e454b04bf7bd2158a6f0ec8b5) och [c381d03a](https://github.com/Klipper3d/klipper/commit/c381d03aad5c3ee761169b7c7bced519cc14da29).
1. Skapa en exempelkonfigurationsfil för Klipper i katalogen config/. Testa mikrokontrollern med huvudprogrammet klippy.py.
1. Överväg att lägga till testfall för bygget i katalogen test/.

Ytterligare programmeringstips:

1. Undvik att använda "C-bitfält" för åtkomst till IO-register. Föredra direkta läs- och skrivoperationer av 32-, 16- eller 8-bitars heltal. C-språkspecifikationen anger inte tydligt hur kompilatorn måste implementera C-bitfält, exempelvis byteordning och bitlayout, och det är svårt att avgöra vilka IO-operationer som sker vid läsning eller skrivning av ett C-bitfält.
1. Föredra att skriva explicita värden till IO-register framför läs-ändra-skriv-operationer. Om ett fält i ett IO-register ska uppdateras och övriga fält har kända värden är det bättre att uttryckligen skriva hela registrets innehåll. Explicita skrivningar ger kod som är mindre, snabbare och enklare att felsöka.

## Koordinatsystem

Internt spårar Klipper främst verktygshuvudets position i kartesiska koordinater relativt till det koordinatsystem som anges i konfigurationsfilen. Det innebär att större delen av Klipper-koden aldrig upplever ett byte av koordinatsystem. Om användaren begär en ändring av origo, exempelvis med `G92`, uppnås effekten genom att framtida kommandon översätts till det primära koordinatsystemet.

I vissa fall är det dock användbart att hämta verktygshuvudets position i ett annat koordinatsystem, och Klipper har flera verktyg för detta. Det kan ses genom att köra kommandot GET_POSITION. Exempel:

```
Send: GET_POSITION
Recv: // mcu: stepper_a:-2060 stepper_b:-1169 stepper_c:-1613
Recv: // stepper: stepper_a:457.254159 stepper_b:466.085669 stepper_c:465.382132
Recv: // kinematic: X:8.339144 Y:-3.131558 Z:233.347121
Recv: // toolhead: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode base: X:0.000000 Y:0.000000 Z:0.000000 E:0.000000
Recv: // gcode homing: X:0.000000 Y:0.000000 Z:0.000000
```

Positionen "mcu" (`stepper.get_mcu_position()` i koden) är det totala antal steg som mikrokontrollern har utfärdat i positiv riktning minus antalet steg i negativ riktning sedan mikrokontrollern senast återställdes. Om roboten rör sig vid frågan innehåller det rapporterade värdet rörelser som buffrats på mikrokontrollern men inte rörelser i look-ahead-kön.

Positionen "stepper" (`stepper.get_commanded_position()`) är den aktuella stegmotorns position så som den spåras av kinematikkoden. Den motsvarar vanligen vagnens position i mm längs skenan, relativt till position_endstop som anges i konfigurationsfilen. Vissa kinematiska modeller spårar stegmotorpositioner i radianer i stället för millimeter. Om roboten rör sig vid frågan innehåller det rapporterade värdet rörelser som buffrats på mikrokontrollern men inte rörelser i look-ahead-kön. Anropen `toolhead.flush_step_generation()` eller `toolhead.wait_moves()` kan användas för att tömma look-ahead- och steggenereringskoden helt.

Positionen "kinematic" (`kin.calc_position()`) är verktygshuvudets kartesiska position, härledd från "stepper"-positionerna och relativ till koordinatsystemet i konfigurationsfilen. Den kan skilja sig från den begärda kartesiska positionen på grund av stegmotorernas upplösning. Om roboten rör sig när "stepper"-positionerna tas innehåller det rapporterade värdet rörelser som buffrats på mikrokontrollern men inte rörelser i look-ahead-kön. Anropen `toolhead.flush_step_generation()` eller `toolhead.wait_moves()` kan användas för att tömma look-ahead- och steggenereringskoden helt.

Positionen "toolhead" (`toolhead.get_position()`) är verktygshuvudets senast begärda position i kartesiska koordinater relativt till koordinatsystemet i konfigurationsfilen. Om roboten rör sig vid frågan innehåller det rapporterade värdet alla begärda rörelser, även de som ligger i buffertar och väntar på att skickas till stegmotordrivarna.

Positionen "gcode" är den senast begärda positionen från kommandot `G1` (eller `G0`) i kartesiska koordinater relativt till koordinatsystemet i konfigurationsfilen. Den kan skilja sig från positionen "toolhead" om en G-kodtransformering, exempelvis bed_mesh, bed_tilt eller skew_correction, är aktiv. Den kan också skilja sig från de faktiska koordinaterna i det senaste `G1`-kommandot om G-kodens origo har ändrats, exempelvis med `G92`, `SET_GCODE_OFFSET` eller `M221`. Kommandot `M114` (`gcode_move.get_status()['gcode_position']`) rapporterar den senaste G-kod-positionen relativt till det aktuella G-kodkoordinatsystemet.

"gcode base" är G-kodens origo i kartesiska koordinater relativt till koordinatsystemet i konfigurationsfilen. Kommandon som `G92`, `SET_GCODE_OFFSET` och `M221` ändrar detta värde.

"gcode homing" är den plats som ska användas för G-kodens origo i kartesiska koordinater relativt till koordinatsystemet i konfigurationsfilen efter ett hemkörningskommando `G28`. Kommandot `SET_GCODE_OFFSET` kan ändra värdet.

## Tid

Hanteringen av klockor, tider och tidsstämplar är grundläggande för Klippers funktion. Klipper utför åtgärder på skrivaren genom att schemalägga händelser inom den närmaste framtiden. För att exempelvis slå på en fläkt kan koden schemalägga en ändring av ett GPIO-stift om 100 ms. Koden försöker sällan utföra en momentant åtgärd. Därför är tidshanteringen i Klipper avgörande för korrekt funktion.

Det finns tre typer av tider som spåras internt i Klippers värdprogramvara:

* Systemtid. Systemtiden använder systemets monotona klocka. Det är ett flyttal lagrat i sekunder och är vanligtvis relativt till när värddatorn senast startades. Systemtider har begränsad användning i programvaran och används främst vid interaktion med operativsystemet. I värdkoden lagras systemtider ofta i variabler med namnet *eventtime* eller *curtime*.
* Utskriftstid. Utskriftstiden är synkroniserad med huvudmikrokontrollerns klocka, alltså den mikrokontroller som definieras i konfigurationssektionen "[mcu]". Det är ett flyttal lagrat i sekunder, relativt till när huvud-MCU:n senast startades om. En "utskriftstid" kan omvandlas till huvud-mikrokontrollerns hårdvaruklocka genom att multiplicera den med MCU:ns statiskt konfigurerade frekvens. Värdkoden på hög nivå använder utskriftstider för att beräkna nästan alla fysiska åtgärder, exempelvis huvudrörelser och ändringar av värmaren. I värdkoden lagras utskriftstider vanligen i variabler med namnet *print_time* eller *move_time*.
* MCU-klocka. Detta är hårdvaruklockräknaren på varje mikrokontroller. Den lagras som ett heltal och uppdateringshastigheten är relativ till den aktuella mikrokontrollerns frekvens. Värdprogramvaran omvandlar sina interna tider till klockor före överföringen till MCU:n. MCU-koden spårar endast tid i klocktick. I värdkoden spåras klockvärden som 64-bitars heltal, medan MCU-koden använder 32-bitars heltal. I värdkoden lagras klockor vanligtvis i variabler vars namn innehåller *clock* eller *ticks*.

Omvandlingen mellan de olika tidsformaten implementeras främst i koden **klippy/clocksync.py**.

Några saker att tänka på vid granskning av koden:

* 32- och 64-bitars klockor: För att minska bandbredden och effektivisera mikrokontrollern spåras mikrokontrollerns klockor som 32-bitars heltal. Vid jämförelse av två klockor i MCU-koden måste funktionen `timer_is_before()` alltid användas för att säkerställa att heltalsöverslag hanteras korrekt. Värdprogramvaran omvandlar 32-bitarsklockor till 64-bitarsklockor genom att lägga till höga bitar från den senaste MCU-tidsstämpel den tagit emot. Inget meddelande från MCU:n ligger mer än 2^31 klocktick i framtiden eller dåtiden, så omvandlingen är aldrig tvetydig. Värden omvandlar 64-bitarsklockor till 32-bitarsklockor genom att helt enkelt trunkera de höga bitarna. För att säkerställa att denna omvandling inte är tvetydig buffrar koden **klippy/chelper/serialqueue.c** meddelanden tills de ligger inom 2^31 klocktick från sin måltid.
* Flera mikrokontroller: Värdprogramvaran stöder flera mikrokontroller på en enskild skrivare. I detta fall spåras varje mikrokontrollers "MCU clock" separat. Koden clocksync.py hanterar klockdrift mellan mikrokontroller genom att ändra hur den omvandlar "print time" till "MCU clock". På sekundära MCU:er uppdateras MCU-frekvensen som används i omvandlingen regelbundet för att ta hänsyn till uppmätt drift.
