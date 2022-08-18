# Modelli di comandi

Questo documento fornisce informazioni sull'implementazione di sequenze di comandi G-Code nelle sezioni di configurazione gcode_macro (e simili).

## Denominazione macro G-Code

Le maiuscole non sono importanti per il nome della macro G-Code: MY_MACRO e my_macro saranno considerate allo stesso modo e possono essere chiamati in maiuscolo o minuscolo. Se nel nome della macro vengono utilizzati dei numeri, devono trovarsi tutti alla fine del nome (ad es. TEST_MACRO25 è valido, ma MACRO25_TEST3 non lo è).

## Formattazione di G-Code nel config

L'indentazione è importante quando si definisce una macro nel file di configurazione. Per specificare una sequenza G-Code su più righe è importante che ogni riga abbia un'indentazione adeguata. Per esempio:

```
[gcode_macro led_lampeggiante]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

Nota come l'opzione di configurazione `gcode:` inizia sempre all'inizio della riga e le righe successive nella macro G-Code non iniziano mai all'inizio.

## Aggiungi una descrizione alla tua macro

Per aiutare a identificare la funzionalità è possibile aggiungere una breve descrizione. Aggiungi `descrizione:` con un breve testo per descrivere la funzionalità. L'impostazione predefinita è "Macro codice G" se non specificato. Per esempio:

```
[gcode_macro led_lampeggiante]
description: Esegue lampeggio del led una volta
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

Il terminale visualizzerà la descrizione quando si utilizza il comando `HELP` o la funzione di completamento automatico.

## Salva/ripristina lo stato per i movimenti G-Code

Sfortunatamente, il linguaggio di comando G-Code può essere difficile da usare. Il meccanismo standard per spostare la testa di stampa è tramite il comando `G1` (il comando `G0` è un alias per `G1` e può essere usato in modo intercambiabile con esso). Tuttavia, questo comando si basa sull'impostazione dello "stato di analisi del codice G" da `M82`, `M83`, `G90`, `G91`, `G92` e precedenti comandi `G1`. Quando si crea una macro G-Code è una buona idea impostare sempre in modo esplicito lo stato di analisi del G-Code prima di emettere un comando `G1`. (Altrimenti, c'è il rischio che il comando `G1` faccia una richiesta indesiderabile.)

Un modo comune per farlo è avvolgere le mosse `G1` in `SAVE_GCODE_STATE`, `G91` e `RESTORE_GCODE_STATE`. Per esempio:

```
[gcode_macro MOVE_UP]
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state
  G91
  G1 Z10 F300
  RESTORE_GCODE_STATE NAME=my_move_up_state
```

Il comando `G91` pone lo stato di analisi del codice G in "modalità di spostamento relativo" e il comando `RESTORE_GCODE_STATE` ripristina lo stato a quello che era prima di entrare nella macro. Assicurati di specificare una velocità esplicita (tramite il parametro `F`) sul primo comando `G1`.

## Espansione del modello

La sezione di configurazione di gcode_macro `gcode:` viene valutata utilizzando il linguaggio del modello Jinja2. È possibile valutare le espressioni in fase di esecuzione racchiudendole in caratteri `{ }` o utilizzando istruzioni condizionali racchiuse in `{% %}`. Vedere la [documentazione Jinja2](http://jinja.pocoo.org/docs/2.10/templates/) per ulteriori informazioni sulla sintassi.

Un esempio di macro complessa:

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

### Parametri Macro

Spesso è utile controllare i parametri passati alla macro quando viene chiamata. Questi parametri sono disponibili tramite la pseudo-variabile `params`. Ad esempio, se la macro:

```
[gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
```

sono stati invocati come `SET_PERCENT VALUE=.2` verrebbero valutati in `M117 Now at 20%`. Si noti che i nomi dei parametri sono sempre in maiuscolo quando vengono valutati nella macro e vengono sempre passati come stringhe. Se si eseguono calcoli matematici, devono essere convertiti esplicitamente in numeri interi o float.

È comune usare la direttiva Jinja2 `set` per usare un parametro predefinito e assegnare il risultato a un nome locale. Per esempio:

```
[gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp
```

### La variabile "rawparams"

È possibile accedere ai parametri completi non analizzati per la macro in esecuzione tramite la pseudo-variabile `rawparams`.

Nota che questo includerà tutti i commenti che facevano parte del comando originale.

Vedere il file [sample-macros.cfg](../config/sample-macros.cfg) per un esempio che mostra come sovrascrivere il comando `M117` usando `rawparams`.

### La variabile "printer"

È possibile ispezionare (e modificare) lo stato corrente della stampante tramite la pseudo-variabile `printer`. Per esempio:

```
[gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
```

I campi disponibili sono definiti nel documento [Status Reference](Status_Reference.md).

Importante! Le macro vengono prima valutate per intero e solo dopo vengono eseguiti i comandi risultanti. Se una macro emette un comando che altera lo stato della stampante, i risultati di tale cambiamento di stato non saranno visibili durante la valutazione della macro. Ciò può anche comportare un comportamento impercettibile quando una macro genera comandi che chiamano altre macro, poiché la macro chiamata viene valutata quando viene richiamata (che avviene dopo l'intera valutazione della macro chiamante).

Per convenzione, il nome immediatamente successivo a `printer` è il nome di una sezione di configurazione. Quindi, ad esempio, `printer.fan` si riferisce all'oggetto fan creato dalla sezione di configurazione `[fan]`. Ci sono alcune eccezioni a questa regola, in particolare gli oggetti `gcode_move` e `toolhead`. Se la sezione di configurazione contiene spazi, è possibile accedervi tramite l'accessor `[ ]`, ad esempio: `printer["generic_heater my_chamber_heater"].temperature`.

Si noti che la direttiva Jinja2 `set` può assegnare un nome locale a un oggetto nella gerarchia `printer`. Ciò può rendere le macro più leggibili e ridurre la digitazione. Per esempio:

```
[gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
```

## Azioni

Sono disponibili alcuni comandi che possono alterare lo stato della stampante. Ad esempio, `{ action_emergency_stop() }` provocherebbe l'arresto della stampante. Si noti che queste azioni vengono eseguite nel momento in cui viene valutata la macro, il che potrebbe richiedere un periodo di tempo significativo prima dell'esecuzione dei comandi g-code generati.

Comandi "azione" disponibili:

- `action_respond_info(msg)`: scrive il dato `msg` sullo pseudo-terminale /tmp/printer. Ogni riga di `msg` verrà inviata con un prefisso "//".
- `action_raise_error(msg)`: annulla la macro corrente (e qualsiasi macro chiamante) e scrivie il dato `msg` sullo pseudo-terminale /tmp/printer. La prima riga di `msg` verrà inviata con un prefisso "!!" e le righe successive avranno un prefisso "//".
- `action_emergency_stop(msg)`: fa passare la stampante a uno stato di spegnimento. Il parametro `msg` è opzionale, può essere utile per descrivere il motivo dell'arresto.
- `action_call_remote_method(method_name)`: chiama un metodo registrato da un client remoto. Se il metodo accetta parametri, questi dovrebbero essere forniti tramite argomenti chiave, ad esempio: `action_call_remote_method("print_stuff", my_arg="hello_world")`

## Variabili

Il comando SET_GCODE_VARIABLE può essere utile per salvare lo stato tra le chiamate di macro. I nomi delle variabili non possono contenere caratteri maiuscoli. Per esempio:

```
[gcode_macro start_probe]
variable_bed_temp: 0
gcode:
  # Salva la temperatura target nella variabile bed_temp
  SET_GCODE_VARIABLE MACRO=start_probe VARIABLE=bed_temp VALUE={printer.heater_bed.target}
  # Disattiva il riscaldamento del piatto
  M140
  # Esegue sonda
  PROBE
  # Chiama la macro finish_probe al completamento
  finish_probe

[gcode_macro finish_probe]
gcode:
  # Ripristinare la temperatura del piatto
  M140 S{printer["gcode_macro start_probe"].bed_temp}
```

Assicurarsi di tenere in considerazione i tempi della valutazione della macro e dell'esecuzione dei comandi quando si utilizza SET_GCODE_VARIABLE.

## Gcode ritardati

L'opzione di configurazione [delayed_gcode] può essere utilizzata per eseguire una sequenza gcode ritardata:

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

Quando viene eseguita la macro `load_filament` sopra, visualizzerà un "Load Complete!" messaggio al termine dell'estrusione. L'ultima riga di gcode abilita il delay_gcode "clear_display", impostato per essere eseguito in 10 secondi.

L'opzione di configurazione `initial_duration` può essere impostata per eseguire il delay_gcode all'avvio della stampante. Il conto alla rovescia inizia quando la stampante entra nello stato "ready". Ad esempio, il codice delay_g riportato di seguito verrà eseguito 5 secondi dopo che la stampante è pronta, inizializzando il display con un messaggio"Welcome!":

```
[delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
```

È possibile che un gcode ritardato si ripeta aggiornandosi nell'opzione gcode:

```
[delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
```

Il codice delayed_gcode sopra riportato invierà "// Extruder Temp: [ex0_temp]" a Octoprint ogni 2 secondi. Questo può essere annullato con il seguente gcode:

```
UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
```

## Modelli di menu

Se è abilitata una [sezione di configurazione display](Config_Reference.md#display), è possibile personalizzare il menu con le sezioni di configurazione [menu](Config_Reference.md#menu).

I seguenti attributi di sola lettura sono disponibili nei modelli di menu:

* `menu.width` - larghezza dell'elemento (numero di colonne di visualizzazione)
* `menu.ns` - namespace del elemento
* `menu.event` - nome dell'evento che ha attivato lo script
* `menu.input` - valore di input, disponibile solo nel contesto dello script di input

Le seguenti azioni sono disponibili nei modelli di menu:

* `menu.back(force, update)`: eseguirà il comando menu back, parametri booleani opzionali `<force>` e `<update>`.
   * Quando `<force>` è impostato su True, interromperà anche la modifica. Il valore predefinito è False.
   * Quando `<update>` è impostato su False, gli elementi del contenitore padre non vengono aggiornati. Il valore predefinito è True.
* `menu.exit(force)` - eseguirà il comando di uscita dal menu, parametro booleano opzionale `<force>` valore predefinito False.
   * Quando `<force>` è impostato su True, interromperà anche la modifica. Il valore predefinito è False.

## Salvare variabili su disco

Se è stata abilitata una [sezione di configurazione save_variables](Config_Reference.md#save_variables), `SAVE_VARIABLE VARIABLE=<nome> VALUE=<valore>` può essere utilizzato per salvare la variabile su disco in modo che possa essere utilizzata tra i riavvii. Tutte le variabili memorizzate vengono caricate nel dict `printer.save_variables.variables` all'avvio e possono essere utilizzate nelle macro gcode. per evitare righe troppo lunghe puoi aggiungere quanto segue nella parte superiore della macro:

```
{% set svv = printer.save_variables.variables %}
```

Ad esempio, potrebbe essere utilizzato per salvare lo stato dell'hotend 2-in-1-out e quando si avvia una stampa assicurarsi che venga utilizzato l'estrusore attivo, anziché T0:

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
