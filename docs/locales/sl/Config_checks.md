# Preverjanje konfiguracije

Ta dokument vsebuje seznam korakov za pomoč pri potrditvi nastavitev pinov v datoteki Klipper printer.cfg. Priporočljivo je, da te korake izvedete po tem, ko ste sledili navodilom v [dokumentu za namestitev](Installation.md).

Med tem vodnikom bo morda treba spremeniti konfiguracijsko datoteko Klipper. Po vsaki spremembi konfiguracijske datoteke obvezno izvedite ukaz RESTART, da zagotovite uveljavitev sprememb (v zavihek terminala Octoprint vtipkajte "restart" in kliknite "Pošlji"). Prav tako je priporočljivo po vsakem ponovnem zagonu izvesti ukaz STATUS, da preverite, ali je bila konfiguracijska datoteka uspešno naložena.

## Preveri temperaturo

Začnite s preverjanjem, ali se temperature pravilno javljajo. V uporabniškem vmesniku pojdite na razdelek z grafom temperature. Preverite, ali sta temperaturi šobe in mize (če je na voljo) prikazani in ali ne naraščata. Če temperatura narašča, tiskalnik izklopite iz električnega omrežja. Če temperature niso točne, preglejte nastavitvi "sensor_type" in "sensor_pin" za šobo ali mizo.

## Preveri M112

Pojdite v ukazno konzolo in v polje terminala vnesite ukaz M112. Ta ukaz zahteva, da Klipper preide v stanje "izklopa". To bo povzročilo prikaz napake, ki jo lahko počistite z ukazom FIRMWARE_RESTART v ukazni konzoli. Octoprint bo zahteval tudi ponovno povezavo. Nato pojdite na razdelek z grafom temperature in preverite, ali se temperature še naprej posodabljajo in ne naraščajo. Če temperature naraščajo, tiskalnik izklopite iz električnega omrežja.

## Preverjanje grelnikov

Pojdite na razdelek z grafom temperature in v polje za temperaturo ekstruderja/orodja vpišite 50 ter pritisnite enter. Temperatura ekstruderja na grafu bi morala začeti naraščati (v približno 30 sekundah). Nato v spustnem polju za temperaturo ekstruderja izberite "Izklop". Po nekaj minutah bi se morala temperatura začeti vračati na prvotno sobno vrednost. Če temperatura ne naraste, preverite nastavitev "heater_pin" v konfiguraciji.

Če ima tiskalnik ogrevano mizo, ponovite zgornji preizkus še z mizo.

## Preverjanje pina za omogočanje koračnega motorja

Preverite, ali se vse osi tiskalnika lahko ročno prosto premikajo (koračni motorji so onemogočeni). Če ne, izvedite ukaz M84, da onemogočite motorje. Če se katera od osi še vedno ne more prosto premikati, preverite konfiguracijo "enable_pin" za to os. Pri večini običajnih gonilnikov koračnih motorjev, je pin za omogočanje motorja "aktivno nizek", zato mora imeti pin "!" pred pinom (na primer, "enable_pin: ! PA1").

## Preverjanje končnih stikal

Ročno premaknite vse osi tiskalnika tako, da nobena ni v stiku s končnim stikalom. Preko ukazne konzole pošljite ukaz QUERY_ENDSTOPS. Odziv bi moral prikazati trenutno stanje vseh konfiguriranih končnih stikal, vsa pa bi morala javiti stanje "open". Za vsako od končnih stikal ponovno zaženite ukaz QUERY_ENDSTOPS, medtem ko ročno sprožite stikalo. Ukaz QUERY_ENDSTOPS bi moral javiti, da je končno stikalo v stanju "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!PA2"), or remove the "!" if there is already one present.

Če se stanje končnega stikala sploh ne spremeni, to običajno pomeni, da je končno stikalo povezano na drug pin. Vendar pa bo morda treba spremeniti tudi nastavitev upora, ki potegne gor, za pin (znak '^' na začetku imena endstop_pin – večina tiskalnikov uporablja upor, ki potegne gor, zato mora biti znak '^' prisoten).

## Preverjanje koračnih motorjev

Z ukazom STEPPER_BUZZ preverite povezljivost vsakega koračnega motorja. Začnite tako, da določeno os ročno postavite na sredino, nato pa v ukazni konzoli zaženite `STEPPER_BUZZ STEPPER=stepper_x`. Ukaz STEPPER_BUZZ bo povzročil, da se bo določen koračni motor premaknil za en milimeter v pozitivno smer in se nato vrnil v začetni položaj. (Če je končno stikalo definirano pri position_endstop=0, se bo koračni motor na začetku vsakega giba odmaknil od končnega stikala.) To oscilacijo bo izvedel desetkrat.

Če se koračni motor sploh ne premakne, preverite nastavitvi "enable_pin" in "step_pin" za ta motor. Če se koračni motor premakne, vendar se ne vrne v prvotni položaj, preverite nastavitev "dir_pin". Če se koračni motor vrti v napačno smer, to običajno pomeni, da je treba obrniti nastavitev "dir_pin" za to os. To storite tako, da dodate znak '! ' pred "dir_pin" v konfiguracijski datoteki tiskalnika (ali ga odstranite, če je že tam). Če se motor premakne znatno več ali manj kot en milimeter, preverite nastavitev "rotation_distance".

Zgornji preizkus izvedite za vsak koračni motor, definiran v konfiguracijski datoteki. (Parameter STEPPER ukaza STEPPER_BUZZ nastavite na ime konfiguracijskega razdelka, ki ga želite preizkusiti.) Če v ekstruderju ni filamenta, lahko s STEPPER_BUZZ preverite povezljivost motorja ekstruderja (uporabite STEPPER=extruder). V nasprotnem primeru je najbolje motor ekstruderja preizkusiti ločeno (glejte naslednji razdelek).

Po preverjanju vseh končnih stikal in vseh koračnih motorjev, je treba preizkusiti mehanizem nuliranja. Izvedite ukaz G28, da postavite vse osi v izhodiščni položaj. Če se tiskalnik ne postavi pravilno v izhodišče, ga izklopite iz električnega omrežja. Po potrebi ponovite korake za preverjanje končnih stikal in koračnih motorjev.

## Preverjanje motorja ekstruderja

Za preizkus motorja ekstruderja bo treba ekstruder segreti na temperaturo tiskanja. Pojdite na razdelek z grafom temperature in v spustnem polju izberite ciljno temperaturo (ali ročno vnesite ustrezno temperaturo). Počakajte, da tiskalnik doseže želeno temperaturo. Nato pojdite v ukazno konzolo in kliknite gumb "Extrude". Preverite, ali se motor ekstruderja vrti v pravilno smer. Če se ne, si oglejte nasvete za odpravljanje težav v prejšnjem razdelku, da potrdite nastavitve "enable_pin", "step_pin" in "dir_pin" za ekstruder.

## Kalibracija nastavitev PID

Klipper podpira [krmiljenje PID](https://en.wikipedia.org/wiki/PID_controller) za ekstruder in grelce mize. Za uporabo tega krmilnega mehanizma, je treba kalibrirati nastavitve PID na vsakem tiskalniku (nastavitve PID iz drugih strojnih programov ali iz vzorčnih konfiguracijskih datotek pogosto delujejo slabo).

Za kalibracijo ekstruderja pojdite v ukazno konzolo in zaženite ukaz PID_CALIBRATE. Na primer: `PID_CALIBRATE HEATER=extruder TARGET=170`

Po končanem preizkusu nastavljanja zaženite `SAVE_CONFIG`, da posodobite datoteko printer.cfg z novimi nastavitvami PID.

Če ima tiskalnik ogrevano mizo in ta podpira krmiljenje s PWM (pulzno-širinska modulacija), je za mizo priporočljivo uporabiti krmiljenje PID. (Kadar se grelnik mize krmili z algoritmom PID, se lahko vklopi in izklopi desetkrat na sekundo, kar morda ni primerno za grelnike z mehanskim stikalom.) Tipičen ukaz za kalibracijo PID mize je: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Naslednji koraki

Ta vodnik je namenjen pomoči pri osnovnem preverjanju nastavitev pinov v konfiguracijski datoteki Klipper. Obvezno preberite vodnik za [poravnavo mize](Bed_Level.md). Oglejte si tudi dokument [Rezalniki](Slicers.md) za informacije o konfiguraciji rezalnika za Klipper.

Ko potrdite, da osnovno tiskanje deluje, je priporočljivo razmisliti o kalibraciji [naprednega tlaka](Pressure_Advance.md).

Morda bo treba izvesti tudi druge vrste podrobne kalibracije tiskalnika – na spletu je na voljo več vodnikov, ki vam pri tem lahko pomagajo (npr. v spletnem iskalniku poiščite "3d printer calibration"). Če se na primer srečujete s pojavom, imenovanim zvonjenje, lahko poskusite slediti vodniku za nastavitev [kompenzacije resonanc](Resonance_Compensation.md).
