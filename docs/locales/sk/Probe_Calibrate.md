# Kalibrácia sondy

Tento dokument popisuje metódu kalibrácie X, Y a Z offsetov "automatickej z sondy" v Klipper. Toto je užitočné pre používateľov, ktorí majú vo svojom konfiguračnom súbore sekciu `[probe]` alebo `[bltouch]`.

## Kalibrácia odchýlok X a Y sondy

Ak chcete kalibrovať posun X a Y, prejdite na kartu „Ovládanie“ OctoPrint, umiestnite tlačiareň do pôvodnej polohy a potom pomocou posúvacích tlačidiel OctoPrint posuňte hlavu do polohy blízko stredu postele.

Položte kúsok modrej maliarskej pásky (alebo podobnej) na posteľ pod sondu. Prejdite na kartu „Terminál“ OctoPrint a zadajte príkaz PROBE:

```
PROBE
```

Umiestnite značku na pásku priamo pod miesto, kde je sonda (alebo použite podobnú metódu na zaznamenanie umiestnenia na posteli).

Vydajte príkaz `GET_POSITION` a zaznamenajte polohu hlavy nástroja XY hlásenú týmto príkazom. Napríklad, ak niekto vidí:

```
Recv: // toolhead: X:46.500000 Y:27.000000 Z:15.000000 E:0.000000
```

potom by sa zaznamenala poloha X sondy 46,5 a poloha sondy Y 27.

Po zaznamenaní polohy sondy zadajte sériu príkazov G1, kým nebude tryska priamo nad značkou na lôžku. Napríklad, jeden by mohol vydať:

```
G1 F300 X57 Y30 Z15
```

na posunutie dýzy do polohy X 57 a Y 30. Keď nájdete polohu priamo nad značkou, použite príkaz `GET_POSITION` na ohlásenie tejto polohy. Toto je poloha trysky.

X_offset je potom `poloha_x_dýzy - poloha_x_sondy` a y_offset je podobne `poloha_y_dýzy - poloha_y_ sondy`. Aktualizujte súbor printer.cfg s danými hodnotami, odstráňte pásku/značky z lôžka a potom zadajte príkaz `RESTART`, aby sa nové hodnoty prejavili.

## Kalibračná sonda Z offset

Poskytnutie presnej sondy z_offset je rozhodujúce pre získanie vysoko kvalitných výtlačkov. Z_offset je vzdialenosť medzi tryskou a lôžkom, keď sa sonda spustí. Na získanie tejto hodnoty je možné použiť nástroj Klipper `PROBE_CALIBRATE` – spustí automatickú sondu na meranie polohy spúšťania Z sondy a potom spustí manuálnu sondu na získanie výšky Z trysky. Z týchto meraní sa potom vypočíta z_offset sondy.

Začnite umiestnením tlačiarne a potom presuňte hlavu do polohy blízko stredu postele. Prejdite na kartu terminálu OctoPrint a spustite nástroj `PROBE_CALIBRATE`.

Tento nástroj vykoná automatickú sondu, potom zdvihne hlavu, presunie dýzu nad miesto bodu sondy a spustí ručnú sondu. Ak sa dýza nepohne do polohy nad bodom automatickej sondy, potom  `ABORT` nástroj manuálnej sondy a vykonajte vyššie opísanú kalibráciu posunu sondy XY.

Po spustení nástroja manuálnej sondy postupujte podľa krokov popísaných v časti ["test papiera"](Bed_Level.md#the-paper-test)), aby ste určili skutočnú vzdialenosť medzi tryskou a lôžkom na danom mieste. Po dokončení týchto krokov môžete pozíciu  `ACCEPT` a uložiť výsledky do konfiguračného súboru pomocou:

```
SAVE_CONFIG
```

Všimnite si, že ak sa vykoná zmena v pohybovom systéme tlačiarne, polohe hotendu alebo umiestnení sondy, výsledky PROBE_CALIBRATE sa zneplatnia.

Ak má sonda posunutie X alebo Y a zmení sa sklon lôžka (napr. nastavením skrutiek lôžka, spustením DELTA_CALIBRATE, spustením Z_TILT_ADJUST, spustením QUAD_GANTRY_LEVEL alebo podobne), budú výsledky PROBE_CALIBRATE neplatné. Po vykonaní niektorej z vyššie uvedených úprav bude potrebné znova spustiť PROBE_CALIBRATE.

Ak sú výsledky PROBE_CALIBRATE neplatné, potom všetky predchádzajúce [bed mesh](Bed_Mesh.md) výsledky, ktoré boli získané pomocou sondy, sú tiež neplatné – po prekalibrovaní sondy bude potrebné znova spustiť BED_MESH_CALIBRATE.

## Kontrola opakovateľnosti

Po kalibrácii offsetov X, Y a Z sondy je dobré overiť, či sonda poskytuje opakovateľné výsledky. Začnite umiestnením tlačiarne a potom presuňte hlavu do polohy blízko stredu postele. Prejdite na kartu terminálu OctoPrint a spustite príkaz `PROBE_ACCURACY`.

Tento príkaz spustí sondu desaťkrát a vytvorí výstup podobný nasledujúcemu:

```
Recv: // probe accuracy: at X:0.000 Y:0.000 Z:10.000
Recv: // and read 10 times with speed of 5 mm/s
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe accuracy results: maximum 2.519448, minimum 2.506948, range 0.012500, average 2.513198, median 2.513198, standard deviation 0.006250
```

V ideálnom prípade bude nástroj hlásiť rovnakú maximálnu a minimálnu hodnotu. (To znamená, že v ideálnom prípade sonda získa identický výsledok na všetkých desiatich sondách.) Je však normálne, že sa minimálne a maximálne hodnoty líšia o jedno Z "kroková vzdialenosť" alebo až o 5 mikrónov (0,005 mm). "Vzdialenosť krokov" je `rotation_distance/(full_steps_per_rotation*microsteps)`. Vzdialenosť medzi minimálnou a maximálnou hodnotou sa nazýva rozsah. Takže vo vyššie uvedenom príklade, keďže tlačiareň používa vzdialenosť kroku Z 0,0125, rozsah 0,012500 by sa považoval za normálny.

Ak výsledky testu ukazujú hodnotu rozsahu, ktorá je väčšia ako 25 mikrónov (0,025 mm), potom sonda nemá dostatočnú presnosť pre typické postupy vyrovnávania lôžka. Môže byť možné vyladiť rýchlosť sondy a/alebo počiatočnú výšku sondy, aby sa zlepšila opakovateľnosť sondy. Príkaz `PROBE_ACCURACY` umožňuje spustiť testy s rôznymi parametrami, aby ste videli ich vplyv – ďalšie podrobnosti nájdete v [dokumente G-Codes](G-Codes.md#probe_accuracy). Ak sonda vo všeobecnosti dosahuje opakovateľné výsledky, ale má príležitostnú odľahlú hodnotu, potom je možné to zohľadniť použitím viacerých vzoriek na každej sonde – prečítajte si popis konfiguračných parametrov „vzorky“ sondy v  [config reference](Config_Reference.md#probe) pre ďalšie podrobnosti.

Ak je potrebná nová rýchlosť sondy, počet vzoriek alebo iné nastavenia, aktualizujte súbor printer.cfg a zadajte príkaz `RESTART`. Ak áno, je dobré znova [kalibrovať z_offset](#calibrating-probe-z-offset). Ak nie je možné dosiahnuť opakovateľné výsledky, nepoužívajte sondu na vyrovnávanie lôžka. Klipper má niekoľko ručných snímacích nástrojov, ktoré možno použiť namiesto toho – ďalšie podrobnosti nájdete v  [Bed Level document](Bed_Level.md).

## Kontrola skreslenia polohy

Niektoré sondy môžu mať systémové skreslenie, ktoré kazí výsledky sondy na určitých miestach hlavy nástroja. Napríklad, ak sa držiak sondy pri pohybe pozdĺž osi Y mierne nakloní, môže to viesť k tomu, že sonda bude hlásiť skreslené výsledky v rôznych polohách Y.

Toto je bežný problém so sondami na delta tlačiarňach, môže sa však vyskytnúť na všetkých tlačiarňach.

Je možné skontrolovať odchýlku polohy pomocou príkazu `PROBE_CALIBRATE` na meranie z_offsetu sondy na rôznych miestach X a Y. V ideálnom prípade by sonda z_offset mala konštantnú hodnotu na každom mieste tlačiarne.

Pre delta tlačiarne skúste zmerať z_offset v polohe blízko veže A, v polohe blízko veže B a v polohe blízko veže C. V prípade kartézskych, korexových a podobných tlačiarní skúste zmerať z_offset v polohách blízko štyroch rohov postele.

Pred spustením tohto testu najskôr nakalibrujte ofsety X, Y a Z sondy, ako je popísané na začiatku tohto dokumentu. Potom umiestnite tlačiareň do pôvodnej polohy a prejdite na prvú pozíciu XY. Postupujte podľa krokov v časti [kalibrácia sondy Z offset](#calibrating-probe-z-offset) a spustite príkaz `PROBE_CALIBRATE`, príkazy `TESTZ` a príkaz `ACCEPT`, ale nespúšťajte `SAVE_CONFIG`. Všimnite si nájdený hlásený z_offset. Potom prejdite na ďalšie pozície XY, zopakujte tieto kroky „PROBE_CALIBRATE“ a zaznamenajte si nahlásený z_offset.

Ak je rozdiel medzi minimálnym zaznamenaným z_offsetom a maximálnym zaznamenaným z_offsetom väčší ako 25 mikrónov (0,025 mm), potom sonda nie je vhodná na typické postupy vyrovnávania lôžka. Alternatívy manuálnej sondy nájdete v [Bed Level document](Bed_Level.md).

## Teplotná odchýlka

Mnohé sondy majú systémovú odchýlku pri sondovaní pri rôznych teplotách. Napríklad, sonda sa môže konzistentne spúšťať v nižšej výške, keď má sonda vyššiu teplotu.

Odporúča sa spustiť nástroje na vyrovnávanie lôžka pri konštantnej teplote, aby sa zohľadnila táto odchýlka. Napríklad buď vždy spustite nástroje, keď má tlačiareň izbovú teplotu, alebo vždy spustite nástroje, keď tlačiareň dosiahne konzistentnú teplotu tlače. V každom prípade je dobré počkať niekoľko minút po dosiahnutí požadovanej teploty, aby bolo zariadenie tlačiarne trvalo na požadovanej teplote.

Ak chcete skontrolovať odchýlku teploty, začnite s tlačiarňou pri izbovej teplote a potom tlačiareň umiestnite do pôvodného stavu, posuňte hlavu do polohy blízko stredu lôžka a spustite príkaz „PROBE_ACCURACY“. Všimnite si výsledky. Potom bez navádzania alebo deaktivácie krokových motorov zohrejte trysku tlačiarne a lôžko na teplotu tlače a znova spustite príkaz `PROBE_ACCURACY`. V ideálnom prípade bude príkaz hlásiť rovnaké výsledky. Ako je uvedené vyššie, ak má sonda odchýlku teploty, dávajte pozor, aby ste sondu vždy používali pri konštantnej teplote.
