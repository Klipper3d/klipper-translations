# Kontroly konfigurácie

Tento dokument obsahuje zoznam krokov, ktoré vám pomôžu potvrdiť nastavenia pinov v súbore Klipper printer.cfg. Po vykonaní krokov v [installation document](Installation.md) je dobré prejsť si tieto kroky.

Počas tejto príručky môže byť potrebné vykonať zmeny v konfiguračnom súbore Klipper. Uistite sa, že po každej zmene konfiguračného súboru vydáte príkaz RESTART, aby ste sa uistili, že sa zmena prejaví (na karte Octoprint terminal napíšte „restart“ a potom kliknite na „Odoslať“). Je tiež dobré po každom REŠTARTE vydať príkaz STATUS, aby ste si overili, či sa konfiguračný súbor úspešne načítal.

## Overte teplotu

Začnite tým, že si overíte, či sú teploty správne hlásené. Prejdite do časti grafu teploty v používateľskom rozhraní. Skontrolujte, či je teplota dýzy a lôžka (ak je k dispozícii) prítomná a nezvyšuje sa. Ak sa zvyšuje, odpojte tlačiareň od napájania. Ak teploty nie sú presné, skontrolujte nastavenia „sensor_type“ a „sensor_pin“ pre trysku a/alebo lôžko.

## Overte M112

Prejdite na príkazovú konzolu a zadajte príkaz M112 v svorkovnici. Tento príkaz požaduje, aby Klipper prešiel do stavu „vypnutia“. Spôsobí to zobrazenie chyby, ktorú možno vymazať príkazom FIRMWARE_RESTART v príkazovej konzole. Octoprint bude tiež vyžadovať opätovné pripojenie. Potom prejdite do sekcie teplotného grafu a overte, či sa teploty naďalej aktualizujú a teploty sa nezvyšujú. Ak sa teplota zvyšuje, odpojte tlačiareň od napájania.

## Overenie ohrievačov

Prejdite do časti grafu teploty a zadajte 50 a potom zadajte do poľa teploty extrudéra/náradia. Teplota extrudéra v grafe by sa mala začať zvyšovať (asi do 30 sekúnd). Potom prejdite do rozbaľovacieho poľa teploty extrudéra a vyberte možnosť „Vypnuté“. Po niekoľkých minútach by sa teplota mala začať vracať na pôvodnú hodnotu izbovej teploty. Ak sa teplota nezvýši, overte nastavenie "heater_pin" v konfigurácii.

Ak má tlačiareň vyhrievané lôžko, vykonajte vyššie uvedený test znova s lôžkom.

## Skontrolujte aktivačný pin krokového motora

Skontrolujte, či sa všetky osi tlačiarne môžu ručne voľne pohybovať (krokové motory sú vypnuté). Ak nie, zadajte príkaz M84 na deaktiváciu motorov. Ak sa niektorá z osí stále nemôže voľne pohybovať, skontrolujte konfiguráciu krokového ovládača „enable_pin“ pre danú os. Na väčšine komoditných ovládačov krokových motorov je kolík aktivácie motora "aktívny nízko" a preto by mal mať kolík aktivácie "!" pred pin (napríklad „enable_pin: !PA1“).

## Overenie koncákov

Ručne posuňte všetky osi tlačiarne tak, aby žiadna z nich nebola v kontakte s koncovým dorazom. Odošlite príkaz QUERY_ENDSTOPS cez príkazovú konzolu. Mal by reagovať s aktuálnym stavom všetkých nakonfigurovaných koncových zarážok a všetky by mali hlásiť stav „otvorené“. Pre každú z koncových zarážok znova spustite príkaz QUERY_ENDSTOPS, pričom koncovú zarážku spúšťajte manuálne. Príkaz QUERY_ENDSTOPS by mal hlásiť koncovú zarážku ako „TRIGGERED“.

Ak sa koncový doraz javí ako invertovaný (pri spustení hlási "otvorený" a naopak), pridajte "!" na definíciu pinu (napríklad "endstop_pin: ^PA2") alebo odstráňte znak "!" ak je už jeden prítomný.

Ak sa koncová poloha vôbec nezmení, potom to vo všeobecnosti znamená, že koncová poloha je pripojená k inému pinu. Môže to však vyžadovať aj zmenu nastavenia pullup pinu ('^' na začiatku názvu endstop_pin - väčšina tlačiarní bude používať pullup rezistor a '^' by mal byť prítomný).

## Skontrolujte krokové motory

Na overenie pripojenia každého krokového motora použite príkaz STEPPER_BUZZ. Začnite manuálnym umiestnením danej osi do stredu a potom spustite `STEPPER_BUZZ STEPPER=stepper_x` v príkazovej konzole. Príkaz STEPPER_BUZZ spôsobí, že daný stepper sa posunie o jeden milimeter kladným smerom a následne sa vráti do východiskovej polohy. (Ak je koncová zarážka definovaná na position_endstop=0, potom sa na začiatku každého pohybu krokovač vzdiali od koncovej zarážky.) Túto osciláciu vykoná desaťkrát.

Ak sa stepper vôbec nepohybuje, skontrolujte nastavenia „enable_pin“ a „step_pin“ pre stepper. Ak sa krokový motor pohne, ale nevráti sa do svojej pôvodnej polohy, skontrolujte nastavenie "dir_pin". Ak krokový motor osciluje v nesprávnom smere, potom to vo všeobecnosti znamená, že "dir_pin" pre os je potrebné prevrátiť. To sa dosiahne pridaním '!' na "dir_pin" v konfiguračnom súbore tlačiarne (alebo ho odstráňte, ak tam už nejaký je). Ak sa motor pohybuje výrazne viac alebo výrazne menej ako jeden milimeter, overte nastavenie "rotation_distance".

Spustite vyššie uvedený test pre každý krokový motor definovaný v konfiguračnom súbore. (Nastavte parameter STEPPER príkazu STEPPER_BUZZ na názov konfiguračnej sekcie, ktorá sa má testovať.) Ak v extrudéri nie je žiadne vlákno, môžete použiť STEPPER_BUZZ na overenie pripojenia motora extrudéra (použite STEPPER=extruder). V opačnom prípade je najlepšie vyskúšať motor extrudéra samostatne (pozri nasledujúcu časť).

Po overení všetkých koncových dorazov a overení všetkých krokových motorov by sa mal otestovať navádzací mechanizmus. Zadajte príkaz G28, aby ste uviedli všetky osi. Ak tlačiareň nefunguje správne, odpojte ju od napájania. V prípade potreby zopakujte kroky overenia koncového dorazu a krokového motora.

## Skontrolujte motor extrudéra

Na testovanie motora extrudéra bude potrebné zohriať extrudér na teplotu tlače. Prejdite do časti grafu teploty a vyberte cieľovú teplotu z rozbaľovacieho poľa teploty (alebo manuálne zadajte vhodnú teplotu). Počkajte, kým tlačiareň nedosiahne požadovanú teplotu. Potom prejdite do príkazovej konzoly a kliknite na tlačidlo "Extrude". Skontrolujte, či sa motor extrudéra otáča správnym smerom. Ak nie, pozrite si tipy na riešenie problémov v predchádzajúcej časti a potvrďte nastavenia „enable_pin“, „step_pin“ a „dir_pin“ pre extrudér.

## Kalibrujte nastavenia PID

Klipper podporuje [PID ovládanie](https://en.wikipedia.org/wiki/PID_controller) pre extrudér a ohrievače lôžka. Aby bolo možné použiť tento riadiaci mechanizmus, je potrebné kalibrovať nastavenia PID na každej tlačiarni (nastavenia PID nachádzajúce sa v iných firmvéroch alebo v príkladoch konfiguračných súborov často fungujú zle).

Ak chcete kalibrovať extrudér, prejdite do príkazovej konzoly a spustite príkaz PID_CALIBRATE. Napríklad: `PID_CALIBRATE HEATER=extruder TARGET=170`

Po dokončení testu ladenia spustite `SAVE_CONFIG` na aktualizáciu súboru printer.cfg na nové nastavenia PID.

Ak má tlačiareň vyhrievané lôžko a podporuje riadenie pomocou PWM (Pulse Width Modulation), potom sa odporúča použiť pre lôžko PID riadenie. (Keď je ohrievač lôžka riadený pomocou algoritmu PID, môže sa zapnúť a vypnúť desaťkrát za sekundu, čo nemusí byť vhodné pre ohrievače používajúce mechanický spínač.) Typický príkaz na kalibráciu PID lôžka je: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Ďalšie kroky

Táto príručka je určená na pomoc so základným overením nastavení pinov v konfiguračnom súbore Klipper. Nezabudnite si prečítať príručku [vyrovnanie postele](Bed_Level.md). Pozrite si tiež dokument [Slicers](Slicers.md), kde nájdete informácie o konfigurácii filtra pomocou Klipper.

Po overení, že základná tlač funguje, je dobré zvážiť kalibráciu [pressure advance] (Pressure_Advance.md).

Možno bude potrebné vykonať iné typy podrobnej kalibrácie tlačiarne – online je k dispozícii množstvo príručiek, ktoré vám s tým pomôžu (napríklad vyhľadajte na webe výraz „kalibrácia 3D tlačiarne“). Ak napríklad pocítite efekt nazývaný zvonenie, môžete skúsiť postupovať podľa sprievodcu ladením [kompenzácia rezonancie](Resonance_Compensation.md).
