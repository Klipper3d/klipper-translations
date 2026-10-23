# Skevhetskorrigering

Programvarubaserad skevhetskorrigering kan hjälpa till att lösa dimensionsfel som beror på att skrivaren inte är helt vinkelrät. Om skrivaren är kraftigt skev rekommenderas starkt att du först justerar den mekaniskt så att den blir så vinkelrät som möjligt innan programvarubaserad korrigering används.

## Skriv ut ett kalibreringsobjekt

Det första steget för att korrigera skevhet är att skriva ut ett [kalibreringsobjekt](https://www.thingiverse.com/thing:2563185/files) längs det plan som ska korrigeras. Det finns också ett [kalibreringsobjekt](https://www.thingiverse.com/thing:2972743) som innehåller alla plan i en modell. Vänd objektet så att hörn A vetter mot planets origo.

Kontrollera att ingen skevhetskorrigering används under utskriften. Du kan antingen ta bort modulen `[skew_correction]` från printer.cfg eller skicka G-koden `SET_SKEW CLEAR=1`.

## Gör dina mätningar

Modulen `[skew_correction]` kräver tre mätningar för varje plan som ska korrigeras: längden från hörn A till hörn C, längden från hörn B till hörn D och längden från hörn A till hörn D. Ta inte med de plana ytorna vid hörnen som vissa testobjekt har när du mäter längden AD.

![skew_lengths](img/skew_lengths.png)

## Konfigurera skevhetskorrigeringen

Kontrollera att `[skew_correction]` finns i printer.cfg. Du kan nu använda G-koden `SET_SKEW` för att konfigurera skew_correction. Om dina uppmätta längder längs XY till exempel är följande:

```
Length AC = 140.4
Length BD = 142.8
Length AD = 99.8
```

`SET_SKEW` kan användas för att konfigurera skevhetskorrigering för XY-planet.

```
SET_SKEW XY=140.4,142.8,99.8
```

Du kan också lägga till mätningar för XZ och YZ i G-koden:

```
SET_SKEW XY=140.4,142.8,99.8 XZ=141.6,141.4,99.8 YZ=142.4,140.5,99.5
```

Modulen `[skew_correction]` har även stöd för profilhantering på samma sätt som `[bed_mesh]`. När du har angett skevheten med G-koden `SET_SKEW` kan du spara den med G-koden `SKEW_PROFILE`:

```
SKEW_PROFILE SAVE=my_skew_profile
```

Efter kommandot uppmanas du att skicka G-koden `SAVE_CONFIG` för att spara profilen permanent. Om det inte finns någon profil med namnet `my_skew_profile` skapas en ny profil. Finns den angivna profilen skrivs den över.

När du har sparat en profil kan du läsa in den:

```
SKEW_PROFILE LOAD=my_skew_profile
```

Du kan också ta bort en gammal eller inaktuell profil:

```
SKEW_PROFILE REMOVE=my_skew_profile
```

När en profil har tagits bort uppmanas du att skicka `SAVE_CONFIG` så att ändringen sparas permanent.

## Verifiera korrigeringen

När skew_correction har konfigurerats kan du skriva ut kalibreringsdelen igen med korrigering aktiverad. Använd följande G-kod för att kontrollera skevheten i varje plan. Resultaten bör vara lägre än de som rapporteras av `GET_CURRENT_SKEW`.

```
CALC_MEASURED_SKEW AC=<ac_length> BD=<bd_length> AD=<ad_length>
```

## Begränsningar

På grund av hur skevhetskorrigering fungerar rekommenderas att den konfigureras i G-koden för start, efter ändlägeskörning och rörelser nära utskriftsområdets kant, till exempel rensning eller munstycksavtorkning. Använd G-koderna `SET_SKEW` eller `SKEW_PROFILE`. Det rekommenderas också att skicka `SET_SKEW CLEAR=1` i G-koden för slut.

Tänk på att `[skew_correction]` kan skapa en korrigering som flyttar verktyget utanför skrivarens gränser på X- och/eller Y-axeln. Placera delar en bit från kanterna när `[skew_correction]` används.
