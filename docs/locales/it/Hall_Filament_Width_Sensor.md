# Sensore di Hall per larghezza del filamento

Questo documento descrive il modulo host del sensore di larghezza del filamento Filament Width Sensor. L'hardware utilizzato per lo sviluppo di questo modulo host si basa su due sensori lineari Hall (ad esempio ss49e). I sensori nel corpo si trovano ai lati opposti. Principio di funzionamento: due sensori Hall funzionano in modalità differenziale, la stessa deriva di temperatura per il sensore. Non è necessaria una speciale compensazione della temperatura.

Puoi trovare i design su [Thingiverse](https://www.thingiverse.com/thing:4138933), un video di assemblaggio è disponibile anche su [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)

Per utilizzare il sensore di larghezza del filamento Hall, leggere [Config Reference](Config_Reference.md#hall_filament_width_sensor) e [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Come funziona?

Il sensore genera due uscite analogiche in base alla larghezza del filamento calcolata. La somma della tensione di uscita è sempre uguale alla larghezza del filamento rilevata. Il modulo host monitora le variazioni di tensione e regola il moltiplicatore di estrusione. Uso il connettore aux2 su una scheda simile a rampe analog11 e analog12 pin. Puoi usare diversi pin e diverse schede.

## Modello per variabili di menu

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## Procedura di calibrazione

Per ottenere il valore grezzo del sensore è possibile utilizzare la voce di menu o il comando **QUERY_RAW_FILAMENT_WIDTH** nel terminale.

1. Inserire la prima barra di calibrazione (dimensione 1,5 mm) ottenere il primo valore grezzo del sensore
1. Inserire la seconda barra di calibrazione (dimensione 2,0 mm) per ottenere il secondo valore grezzo del sensore
1. Salva i valori grezzi del sensore nel parametro di configurazione `Raw_dia1` e `Raw_dia2`

## Come abilitare il sensore

Per impostazione predefinita, il sensore è disabilitato all'accensione.

Per abilitare il sensore, emettere il comando **ENABLE_FILAMENT_WIDTH_SENSOR** o impostare il parametro `enable` su `true`.

## Registrazione

Per impostazione predefinita, la registrazione del diametro è disabilitata all'accensione.

Emettere il comando **ENABLE_FILAMENT_WIDTH_LOG** per avviare la registrazione ed emettere il comando **DISABLE_FILAMENT_WIDTH_LOG** per interrompere la registrazione. Per abilitare la registrazione all'accensione, impostare il parametro `logging` su `true`.

Il diametro del filamento viene registrato con un intervallo di misurazione (10 mm per impostazione predefinita).
