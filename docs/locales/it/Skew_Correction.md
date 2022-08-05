# Correzione dell'inclinazione

La correzione dell'inclinazione basata su software può aiutare a risolvere le imprecisioni dimensionali risultanti da un gruppo stampante non perfettamente in squadrato. Si noti che se la stampante è notevolmente inclinata, si consiglia vivamente di utilizzare prima mezzi meccanici per ottenere la stampante il più squadrata possibile prima di applicare la correzione basata sul software.

## Stampa un oggetto di calibrazione

Il primo passaggio per correggere l'inclinazione è stampare un [calibration object](https://www.thingiverse.com/thing:2563185/files) lungo il piano che si desidera correggere. C'è anche un [calibration object](https://www.thingiverse.com/thing:2972743) che include tutti i piani in un modello. Vuoi che l'oggetto sia orientato in modo che l'angolo A sia verso l'origine del piano.

Assicurarsi che durante questa stampa non venga applicata alcuna correzione dell'inclinazione. Puoi farlo rimuovendo il modulo `[skew_correction]` da printer.cfg o inserendo un gcode `SET_SKEW CLEAR=1`.

## Prendi le tue misure

Il modulo `[skew_correcton]` richiede 3 misurazioni per ogni piano che vuoi correggere; la lunghezza dall'angolo A all'angolo C, la lunghezza dall'angolo B all'angolo D e la lunghezza dall'angolo A all'angolo D. Quando si misura la lunghezza AD non includere i piani sugli angoli forniti da alcuni oggetti di prova.

![skew_lengths](img/skew_lengths.png)

## Configura la tua inclinazione

Assicurati che la sezione `[skew_correction]` sia in printer.cfg. Ora puoi usare il gcode `SET_SKEW` per configurare skew_correcton. Ad esempio, se le lunghezze misurate lungo XY sono le seguenti:

```
Length AC = 140.4
Length BD = 142.8
Length AD = 99.8
```

`SET_SKEW` può essere utilizzato per configurare la correzione dell'inclinazione per il piano XY.

```
SET_SKEW XY=140.4,142.8,99.8
```

Puoi anche aggiungere misure per XZ e YZ al gcode:

```
SET_SKEW XY=140.4,142.8,99.8 XZ=141.6,141.4,99.8 YZ=142.4,140.5,99.5
```

Il modulo `[skew_correction]` supporta anche la gestione del profilo in un modo simile a `[bed_mesh]`. Dopo aver impostato l'inclinazione usando il gcode `SET_SKEW`, puoi usare il gcode `SKEW_PROFILE` per salvarlo:

```
SKEW_PROFILE SAVE=my_skew_profile
```

Dopo questo comando ti verrà chiesto di emettere un gcode `SAVE_CONFIG` per salvare il profilo nella memoria permanente. Se nessun profilo è denominato `my_skew_profile`, verrà creato un nuovo profilo. Se il profilo indicato esiste, verrà sovrascritto.

Una volta che hai un profilo salvato, puoi caricarlo:

```
SKEW_PROFILE LOAD=my_skew_profile
```

È anche possibile rimuovere un profilo vecchio o superato:

```
SKEW_PROFILE REMOVE=my_skew_profile
```

Dopo aver rimosso un profilo, ti verrà chiesto di emettere un `SAVE_CONFIG` per far sì che questa modifica persista.

## Verifica della tua correzione

Dopo aver configurato skew_correction è possibile ristampare la parte di calibrazione con la correzione abilitata. Usa il seguente gcode per controllare la tua inclinazione su ciascun piano. I risultati dovrebbero essere inferiori a quelli riportati tramite `GET_CURRENT_SKEW`.

```
CALC_MEASURED_SKEW AC=<ac_length> BD=<bd_length> AD=<ad_length>
```

## Avvertenze

A causa della natura della correzione dell'inclinazione, si consiglia di configurare l'inclinazione nel codice g iniziale, dopo l'homing e qualsiasi tipo di movimento che si sposta vicino al bordo dell'area di stampa, come uno spurgo o una pulizia degli ugelli. È possibile utilizzare i codici g "SET_SKEW" o "SKEW_PROFILE" per ottenere ciò. Si consiglia inoltre di emettere un `SET_SKEW CLEAR=1` alla fine del gcode.

Tenere presente che è possibile che `[skew_correction]` generi una correzione che sposti la testa oltre i limiti della stampante sugli assi X e/o Y. Si consiglia di disporre le parti lontano dai bordi quando si utilizza `[skew_correction]`.
