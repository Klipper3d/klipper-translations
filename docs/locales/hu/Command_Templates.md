# Parancssablonok

Ez a dokumentum a G-kód parancssorozatok gcode_macro (és hasonló) konfigurációs szakaszokban történő implementálásáról nyújt információt.

## G-kód makró elnevezése

A G-kódos makronév esetében a nagy- és kisbetűs írásmód nem fontos - a MY_MACRO és a my_macro ugyanúgy kiértékelődik, és kicsi vagy nagybetűvel is meghívható. Ha a makronévben számokat használunk, akkor azoknak a név végén kell állniuk (pl. a TEST_MACRO25 érvényes, de a MACRO25_TEST3 nem).

## A G-kód formázása a konfigurációban

A behúzás fontos, amikor makrót definiál a konfigurációs fájlban. Többsoros G-kód szekvencia megadásához fontos, hogy minden sorban megfelelő behúzás legyen. Például:

```
[gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

Figyeljük meg, hogy a `gcode:` config opció mindig a sor elején kezdődik, valamint a G-kód makró további sorai soha nem kezdődnek a sor elején.

## Leírás hozzáadása a makróhoz

A funkció azonosításának megkönnyítése érdekében rövid leírás adható hozzá. Adjunk hozzá `description:` egy rövid szöveget a funkció leírására. Ha nincs megadva, az alapértelmezett érték "G-kód makró". Például:

```
[gcode_macro blink_led]
description: Blink my_led one time
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

A terminál megjeleníti a leírást, ha a `HELP` parancsot vagy az automatikus kitöltés funkciót használja.

## Állapot mentése/visszaállítása G-kódos mozgásokhoz

Sajnos a G-kód parancsnyelv használata kihívást jelenthet. A nyomtatófej mozgatásának szabványos mechanizmusa a `G1` parancson keresztül történik (a `G0` parancs a `G1` parancs álnevének tekinthető, és felcserélhető vele). Ez a parancs azonban a "G-kód elemzési állapotára" támaszkodik: `M82`, `M83`, `G90` általi beállításra, `G91`, `G92` és a korábbi `G1` parancsok is. Egy G-kód makró létrehozásakor célszerű mindig kifejezetten beállítani a G-kód elemzési állapotát a `G1` parancs kiadása előtt. (Ellenkező esetben fennáll annak a veszélye, hogy a `G1` parancs nemkívánatos kérést fog végrehajtani.)

Ennek egyik gyakori módja, hogy a `G1` mozdulatokat `SAVE_GCODE_STATE`-be csomagoljuk, `G91`, és `RESTORE_GCODE_STATE`-ba. Például:

```
[gcode_macro MOVE_UP]
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state
  G91
  G1 Z10 F300
  RESTORE_GCODE_STATE NAME=my_move_up_state
```

A `G91` parancs a G-kód elemzési állapotot "relatív mozgatási módba" helyezi, a `RESTORE_GCODE_STATE` parancs pedig visszaállítja a makró belépése előtti állapotot. Ügyeljen arra, hogy az első `G1` parancsnál adjon meg explicit sebességet (az `F` paraméterrel).

## Sablon bővítés

A gcode_macro `gcode:` konfigurációs szakasz kiértékelése a Jinja2 sablonnyelv használatával történik. A kifejezéseket kiértékelhetjük futásidőben `{ }` karakterekbe csomagolva, vagy használhatunk feltételes utasításokat `{% %}` karakterekbe csomagolva. A szintaxissal kapcsolatos további információkért lásd a [Jinja2 dokumentáció](http://jinja.pocoo.org/docs/2.10/templates/).

Példa egy összetett makróra:

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

### Makró paraméterek

Gyakran hasznos a makrónak a meghívásakor átadott paraméterek vizsgálata. Ezek a paraméterek a `params` álváltozóval érhetők el. Például, ha a makró:

```
[gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
```

`SET_PERCENT VALUE=.2` értéket adna, akkor `M117 Most 20%-os értéken`. Vegye figyelembe, hogy a paraméternevek a makróban történő kiértékeléskor mindig nagybetűsek, és mindig karakterláncként kerülnek átadásra. Ha matematikai műveletet hajtunk végre, akkor azokat explicit módon egész számokká vagy lebegőszámokká kell konvertálni.

Gyakori a Jinja2 `set` direktíva használata egy alapértelmezett paraméter használatához és az eredmény hozzárendelése egy helyi névhez. Például:

```
[gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp}
```

### A "rawparams" változó

A futó makró teljes, be nem elemzett paraméterei a `rawparams` pszeudováltozóval érhetők el.

Ez nagyon hasznos, ha meg akarod változtatni bizonyos parancsok viselkedését, mint például az `M117`. Például:

```
[gcode_macro M117]
rename_existing: M117.1
gcode:
  M117.1 { rawparams }
  M118 { rawparams }
```

### A "nyomtató" változó

A nyomtató aktuális állapotát a `printer` álváltozóval lehet ellenőrizni (és megváltoztatni). Például:

```
[gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
```

A rendelkezésre álló mezők a [Referencia állapot](Status_Reference.md) dokumentumban vannak meghatározva.

Fontos! A makrók először teljes egészében kiértékelésre kerülnek, és csak ezután kerülnek végrehajtásra a kapott parancsok. Ha egy makró olyan parancsot ad ki, amely megváltoztatja a nyomtató állapotát, az állapotváltozás eredményei nem lesznek láthatóak a makró kiértékelése során. Ez akkor is furcsa viselkedést eredményezhet, ha egy makró más makrókat, hívó parancsokat generál, mivel a meghívott makró a meghíváskor kerül kiértékelésre (ami a hívó makró teljes kiértékelése után történik).

A konvenció szerint a `printer` után közvetlenül következő név a config szakasz neve. Így például a `printer.fan` a `[fan]` config szakasz által létrehozott ventilátor objektumra utal. Van néhány kivétel ez alól a szabály alól. Nevezetesen a `gcode_move` és a `toolhead` objektumok. Ha a config szakasz szóközöket tartalmaz, akkor a `[ ]` jellel lehet elérni. Például: `printer["generic_heater my_chamber_heater"].temperature`.

Vegyük észre, hogy a Jinja2 `set` direktíva a `printer` hierarchiában lévő objektumhoz rendelhet helyi nevet. Ez olvashatóbbá teheti a makrókat és csökkentheti a gépelést. Például:

```
[gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
```

## Tevékenységek

A nyomtató állapotának megváltoztatására néhány parancs áll rendelkezésre. Például az `{ action_emergency_stop() }` a nyomtatót leállítási állapotba helyezi. Vegye figyelembe, hogy ezek a műveletek a makró kiértékelésének időpontjában történnek, ami jelentős idővel a generált G-kód parancsok végrehajtása előtt történhet.

Elérhető "művelet" parancsok:

- `action_respond_info(msg)`: A megadott `msg` kiírása a /tmp/printer álterminálra. Az `msg` minden egyes sora "// " előtaggal lesz elküldve.
- `action_raise_error(msg)`: Megszakítja az aktuális makrót (és minden hívó makrót), és a megadott `msg` üzenetet kiírja a /tmp/printer pseudo-terminálra. Az `msg` első sora "!! " előtaggal, a további sorok pedig "// " előtaggal lesznek elküldve.
- `action_emergency_stop(msg)`: A nyomtatót leállítási állapotba helyezi. Az `msg` paraméter opcionális, hasznos lehet a leállítás okának leírása.
- `action_call_remote_method(method_name)`: Egy távoli ügyfél által regisztrált metódus hívása. Ha a metódus paramétereket fogad el, akkor azokat kulcsszavas argumentumokkal kell megadni, azaz: `action_call_remote_method("print_stuff", my_arg="hello_world")`

## Változók

A SET_GCODE_VARIABLE parancs hasznos lehet a makróhívások közötti állapotmentéshez. A változók nevei nem tartalmazhatnak nagybetűket. Például:

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

A SET_GCODE_VARIABLE használatakor mindenképpen vegye figyelembe a makró kiértékelésének és a parancs végrehajtásának időzítését.

## Késleltetett G-kódok

A [delayed_gcode] konfigurációs opció késleltetett G-kód szekvencia végrehajtásához használható:

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

Amikor a fenti `load_filament` makró végrehajtódik, az extrudálás befejezése után megjelenik egy "Load Complete!" üzenet. A G-kód utolsó sora engedélyezi a "clear_display" delayed_gcode-ot, amely 10 másodperc múlva végrehajtásra van beállítva.

Az `initial_duration` konfigurációs beállítás beállítható úgy, hogy a nyomtató indításakor végrehajtsa a delayed_gcode parancsot. A visszaszámlálás akkor kezdődik, amikor a nyomtató a "ready" állapotba lép. Az alábbi delayed_gcode például a nyomtató elkészülte után 5 másodperccel végrehajtja a műveletet, és a kijelzőt "Üdvözlés!" üzenettel inicializálja:

```
[delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
```

Lehetséges, hogy egy késleltetett G-kód megismétlődik a G-kód opcióban történő frissítéssel:

```
[delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
```

A fenti delayed_gcode 2 másodpercenként elküldi az "// Extruder Temp: [ex0_temp]" kódot az Octoprintnek. Ez a következő G-kóddal törölhető:

```
UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
```

## Menüsablonok

Ha a [display config section](Config_Reference.md#display) engedélyezve van, akkor lehetőség van a menü testreszabására a [menu](Config_Reference.md#menu) konfigurációs szakaszokkal.

A menüsablonokban a következő csak olvasható attribútumok állnak rendelkezésre:

* `menu.width` - az elem szélessége (a megjelenített oszlopok száma)
* `menu.ns` - elem névtere
* `menu.event` - a szkriptet kiváltó esemény neve
* `menu.input` - beviteli érték, csak input script kontextusban érhető el

A menüsablonokban a következő műveletek érhetők el:

* `menu.back(force, update)`: végrehajtja a menü vissza parancsát, az opcionális logikai paramétereket `<force>` és `<frissítés>`.
   * Ha a `<force>` értéke True, akkor a szerkesztés is leáll. Az alapértelmezett érték False.
   * Ha az `<update>` értéke False, akkor a felsőbb tárolóelemek nem frissülnek. Az alapértelmezett érték True.
* `menu.exit(force)` - végrehajtja a menüből való kilépés parancsát, opcionális boolean paraméter `<force>` alapértelmezett értéke False.
   * Ha a `<force>` értéke True, akkor a szerkesztés is leáll. Az alapértelmezett érték False.

## Változók mentése lemezre

Ha a [save_variables config section](Config_Reference.md#save_variables) engedélyezve van, a `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>` használható a változó lemezre mentésére, hogy az újraindítások során is használható legyen. Minden tárolt változó betöltődik a `printer.save_variables.variables` dict-be indításkor, és felhasználható a G-kód makrókban. A túl hosszú sorok elkerülése érdekében a makró elejére a következőket írhatjuk:

```
{% set svv = printer.save_variables.variables %}
```

Példaként a 2 az 1-ben nyomtatófej állapotának mentésére használható, és nyomtatás indításakor győződjön meg arról, hogy az aktív fejet használja a T0 helyett:

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
