# Kommandomallar

Dokumentet innehåller information om att implementera G-kodkommandosekvenser i konfigurationsavsnittet gcode_macro och liknande avsnitt.

## Namngivning av G-kodmakron

Skiftläge saknar betydelse för G-kodmakrons namn: MY_MACRO och my_macro tolkas lika och kan anropas med versaler eller gemener. Om namn innehåller siffror måste alla stå sist i namnet (TEST_MACRO25 är giltigt, men MACRO25_TEST3 är det inte).

## Formatering av G-kod i konfigurationen

Indrag är viktigt när ett makro definieras i konfigurationsfilen. För en G-kodsekvens på flera rader måste varje rad ha korrekt indrag. Exempelvis:

```
[gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

Observera att konfigurationsalternativet `gcode:` alltid börjar i radens början och att efterföljande rader i G-kodmakrot aldrig börjar där.

## Lägg till en beskrivning av makrot

En kort beskrivning kan läggas till för att identifiera funktionen. Lägg till `description:` med en kort funktionstext. Standardvärdet är "G-kodmakro" om inget anges. Exempelvis:

```
[gcode_macro blink_led]
description: Blink my_led one time
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

Terminalen visar beskrivningen när du använder kommandot `HELP` eller funktionen för automatisk komplettering.

## Spara/återställ tillstånd för G-kodrörelser

G-kodens kommandospråk kan tyvärr vara svårt att använda. Standardmekanismen för att flytta verktygshuvudet är kommandot `G1` (`G0` är ett alias för `G1`). Kommandot beror dock på "G-kodtolkningstillståndet" som anges av `M82`, `M83`, `G90`, `G91`, `G92` och tidigare `G1`-kommandon. Ange därför alltid G-kodtolkningstillståndet uttryckligen innan ett `G1`-kommando utfärdas i ett G-kodmakro, annars kan `G1` begära en oönskad rörelse.

Ett vanligt sätt är att omsluta `G1`-rörelser med `SAVE_GCODE_STATE`, `G91` och `RESTORE_GCODE_STATE`. Exempelvis:

```
[gcode_macro MOVE_UP]
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state
  G91
  G1 Z10 F300
  RESTORE_GCODE_STATE NAME=my_move_up_state
```

Kommandot `G91` sätter G-kodtolkningstillståndet i "läge för relativ rörelse" och `RESTORE_GCODE_STATE` återställer tillståndet från före makrot. Ange alltid en uttrycklig hastighet med parametern `F` vid första `G1`-kommandot.

## Mallexpansion

Konfigurationsavsnittet gcode_macro `gcode:` tolkas med mallspråket Jinja2. Uttryck kan utvärderas vid körning genom att omslutas med `{ }`, och villkorssatser med `{% %}`. Se [Jinja2-dokumentationen](http://jinja.pocoo.org/docs/2.10/templates/) för syntaxen.

Ett exempel på ett komplext makro:

```
[gcode_macro clean_nozzle]
gcode:
  {% set wipe_count = 8 %}
  SAVE_GCODE_STATE NAME=clean_nozzle_state
  G90
  G0 Z15 F300
  {% for wipe in range(wipe_count) %}
    {% for coordinate in [(275, 4),(235, 4)] %}
      G0 X{coordinate[0]} Y{coordinate[1] + 0.25 * wipe} Z9.7 F12000
    {% endfor %}
  {% endfor %}
  RESTORE_GCODE_STATE NAME=clean_nozzle_state
```

### Makroparametrar

Det är ofta användbart att inspektera parametrar som skickas till ett makro vid anrop. De finns via pseudovariabeln `params`. Om makrot exempelvis:

```
[gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
```

anropas som `SET_PERCENT VALUE=.2` tolkas det som `M117 Now at 20%`. Parameternamn är alltid versaler när de tolkas i makrot och skickas alltid som strängar. Vid beräkningar måste de uttryckligen omvandlas till heltal eller flyttal.

Det är vanligt att använda Jinja2-direktivet `set` för att använda en standardparameter och tilldela resultatet ett lokalt namn. Exempelvis:

```
[gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp}
```

### Variabeln "rawparams"

De fullständiga otolkade parametrarna för makrot som körs nås via pseudovariabeln `rawparams`.

Observera att detta inkluderar kommentarer som var del av det ursprungliga kommandot.

Se filen [sample-macros.cfg](../config/sample-macros.cfg) för ett exempel på hur kommandot `M117` åsidosätts med `rawparams`.

### Variabeln "printer"

Skrivarens aktuella tillstånd kan inspekteras och ändras via pseudovariabeln `printer`. Exempelvis:

```
[gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
```

Tillgängliga fält definieras i dokumentet [Statusreferens](Status_Reference.md).

Viktigt! Makron utvärderas först helt och därefter körs de resulterande kommandona. Om ett makro skickar ett kommando som ändrar skrivarens tillstånd syns inte resultatet av ändringen medan makrot utvärderas. Detta kan också ge subtilt beteende när ett makro genererar kommandon som anropar andra makron, eftersom det anropade makrot utvärderas när det anropas, alltså efter att det anropande makrot har utvärderats helt.

Enligt konvention är namnet direkt efter `printer` namnet på ett konfigurationsavsnitt. `printer.fan` avser exempelvis fläktobjektet som skapas av avsnittet `[fan]`. Undantag är bland annat objekten `gcode_move` och `toolhead`. Om avsnittet innehåller blanksteg nås det med accessor-operatorn `[ ]`, exempelvis `printer["generic_heater my_chamber_heater"].temperature`.

Observera att Jinja2-direktivet `set` kan ge ett objekt i `printer`-hierarkin ett lokalt namn. Det kan göra makron mer lättlästa och minska skrivandet. Exempelvis:

```
[gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
```

## Åtgärder

Det finns kommandon som kan ändra skrivarens tillstånd. `{ action_emergency_stop() }` försätter exempelvis skrivaren i avstängt läge. Åtgärderna utförs när makrot utvärderas, vilket kan vara långt innan de genererade G-kodkommandona körs.

Tillgängliga "action"-kommandon:

- `action_respond_info(msg)`: Skriv angivet `msg` till pseudoterminalen /tmp/printer. Varje rad i `msg` skickas med prefixet "// ".
- `action_raise_error(msg)`: Avbryt det aktuella makrot, inklusive anropande makron, och skriv `msg` till pseudoterminalen /tmp/printer. Första raden skickas med prefixet "!! " och efterföljande rader med "// ".
- `action_emergency_stop(msg)`: Försätt skrivaren i avstängt läge. Parametern `msg` är valfri och kan beskriva orsaken till avstängningen.
- `action_call_remote_method(method_name)`: Anropar en metod som registrerats av en fjärrklient. Om metoden tar parametrar ska de anges som nyckelordsargument, exempelvis `action_call_remote_method("print_stuff", my_arg="hello_world")`.

## Variabler

Kommandot SET_GCODE_VARIABLE kan användas för att spara tillstånd mellan makroanrop. Variabelnamn får inte innehålla versaler. Exempelvis:

```
[gcode_macro start_probe]
variable_bed_temp: 0
gcode:
  # Save target temperature to bed_temp variable
  SET_GCODE_VARIABLE MACRO=start_probe VARIABLE=bed_temp VALUE={printer.heater_bed.target}
  # Disable bed heater
  M140
  # Perform probe
  PROBE
  # Call finish_probe macro at completion of probe
  finish_probe

[gcode_macro finish_probe]
gcode:
  # Restore temperature
  M140 S{printer["gcode_macro start_probe"].bed_temp}
```

Ta hänsyn till tidpunkterna för makroutvärdering och kommandoexekvering när SET_GCODE_VARIABLE används.

## Fördröjd G-kod

Konfigurationsalternativet [delayed_gcode] kan användas för att köra en fördröjd G-kodsekvens:

```
[delayed_gcode clear_display]
gcode:
  M117

[gcode_macro load_filament]
gcode:
 G91
 G1 E50
 G90
 M400
 M117 Load Complete!
 UPDATE_DELAYED_GCODE ID=clear_display DURATION=10
```

När makrot `load_filament` ovan körs visas meddelandet "Inläsning klar!" efter avslutad extrudering. Sista G-kodraden aktiverar delayed_gcode `clear_display`, som körs efter 10 sekunder.

Konfigurationsalternativet `initial_duration` kan köra delayed_gcode vid skrivarstart. Nedräkningen börjar när skrivaren går in i läget "ready". Följande delayed_gcode körs exempelvis fem sekunder efter att skrivaren är klar och initierar displayen med "Välkommen!":

```
[delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
```

En fördröjd G-kod kan upprepa sig genom att uppdatera sig själv i alternativet gcode:

```
[delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
```

Ovanstående delayed_gcode skickar "// Extruder Temp: [ex0_temp]" till OctoPrint varannan sekund. Det kan avbrytas med följande G-kod:

```
UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
```

## Menymallar

Om ett [display-konfigurationsavsnitt](Config_Reference.md#display) är aktiverat kan menyn anpassas med [menu](Config_Reference.md#menu)-konfigurationsavsnitt.

Följande skrivskyddade attribut finns i menymallar:

* `menu.width` – elementets bredd (antal displaykolumner)
* `menu.ns` – elementets namnrymd
* `menu.event` – namnet på händelsen som utlöste skriptet
* `menu.input` – indatavärde, endast tillgängligt i indataskriptets kontext

Följande åtgärder finns i menymallar:

* `menu.back(force, update)`: kör kommandot för att gå tillbaka i menyn; de booleska parametrarna `<force>` och `<update>` är valfria.
   * Om `<force>` är True avslutas även redigering. Standardvärdet är False.
   * Om `<update>` är False uppdateras inte den överordnade behållarens objekt. Standardvärdet är True.
* `menu.exit(force)` – kör kommandot för att avsluta menyn; den booleska parametern `<force>` är valfri och har standardvärdet False.
   * Om `<force>` är True avslutas även redigering. Standardvärdet är False.

## Spara variabler på disk

Om ett [save_variables-konfigurationsavsnitt](Config_Reference.md#save_variables) är aktiverat kan `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>` spara variabeln på disk så att den bevaras vid omstarter. Alla sparade variabler läses in i uppslagsstrukturen `printer.save_variables.variables` vid uppstart och kan användas i G-kodmakron. För att undvika alltför långa rader kan följande läggas överst i makrot:

```
{% set svv = printer.save_variables.variables %}
```

Det kan exempelvis användas för att spara tillståndet för en 2-in-1-out-värmdel och vid utskriftsstart säkerställa att den aktiva extrudern används i stället för T0:

```
[gcode_macro T1]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder1
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder1"'

[gcode_macro T0]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder"'

[gcode_macro START_GCODE]
gcode:
  {% set svv = printer.save_variables.variables %}
  ACTIVATE_EXTRUDER extruder={svv.currentextruder}
```
