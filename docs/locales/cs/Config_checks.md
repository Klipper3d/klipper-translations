# Kontroly konfigurace

Tento dokument obsahuje seznam kroků, které vám pomohou potvrdit nastavení pinů v souboru Klipper printer.cfg. Je dobré si projít tyto kroky po provedení kroků v [ instalační dokument]( Installation .md).

Během této příručky může být nutné provést změny v konfiguračním souboru Klipper . Ujistěte se, že po každé změně konfiguračního souboru vydáte příkaz RESTART , abyste zajistili, že se změna projeví ( na kartě terminálu Octoprint zadejte " restart " a poté klikněte na "Odeslat"). Je také dobré po každém RESTARTU zadat příkaz STATUS , abyste ověřili, že byl konfigurační soubor úspěšně načten.

## Ověřte teplotu

Začněte tím, že si ověříte, že jsou teploty správně hlášeny. Přejděte na kartu teploty Octoprint .

! [oktotisk-teplota] (img/octoprint-teplota.png)

Ověřte, že teplota trysky a lože (je-li k dispozici) je přítomna a nezvyšuje se. Pokud se zvyšuje, odpojte napájení tiskárny. Pokud teploty nejsou přesné, zkontrolujte nastavení „sensor_type“ a „sensor_pin“ pro trysku a/nebo lože.

## Ověřte M112

Přejděte na kartu Terminál Octoprint a zadejte příkaz M112 ve svorkovnici. Tento příkaz požaduje , aby Klipper přešel do stavu „vypnutí“. Způsobí to odpojení Octoprint od Klipper – přejděte do oblasti Připojení a klikněte na „Připojit“, aby se Octoprint znovu připojil. Poté přejděte na kartu teploty Octoprint a ověřte, zda se teploty nadále aktualizují a teploty se nezvyšují. Pokud se teploty zvyšují, odpojte napájení tiskárny.

Příkaz M112 způsobí , že Klipper přejde do stavu „vypnutí“. Chcete-li tento stav vymazat, zadejte příkaz FIRMWARE_RESTART na kartě terminálu Octoprint .

## Ověření ohřívačů

Přejděte na kartu teploty Octoprint a zadejte 50 a poté zadejte do pole teploty "Nástroj". Teplota extrudéru v grafu by se měla začít zvyšovat (asi do 30 sekund). Poté přejděte do rozevíracího pole teploty „Nástroj“ a vyberte „Vypnuto“. Po několika minutách by se teplota měla začít vracet na původní hodnotu pokojové teploty. Pokud se teplota nezvýší, ověřte nastavení "heater_pin" v konfiguraci.

Pokud má tiskárna vyhřívané lůžko, proveďte výše uvedený test znovu s lůžkem.

## Ověřte aktivační kolík krokového motoru

Ověřte, že se všechny osy tiskárny mohou ručně volně pohybovat (krokové motory jsou deaktivovány). Pokud ne, zadejte příkaz M84 k deaktivaci motorů. Pokud se některá z os stále nemůže volně pohybovat, ověřte konfiguraci krokového ovladače "enable_pin" pro danou osu. Na většině běžných ovladačů krokových motorů je kolík aktivace motoru "aktivní nízko" a proto by měl mít kolík "!" před pin (například "enable_pin: !ar38").

## Ověření koncovek

Ručně posuňte všechny osy tiskárny tak, aby žádná z nich nebyla v kontaktu s koncovým dorazem. Odešlete příkaz QUERY_ENDSTOPS přes kartu terminálu Octoprint. Měl by reagovat aktuálním stavem všech nakonfigurovaných koncových zarážek a všechny by měly hlásit stav „otevřeno“. Pro každou z koncových zarážek znovu spusťte příkaz QUERY_ENDSTOPS a ručně spusťte koncovou zarážku. Příkaz QUERY_ENDSTOPS by měl hlásit koncovou zastávku jako "TRIGGERED".

Pokud se endstop jeví jako inverzní (při spuštění hlásí "open" a naopak), přidejte k definici pinu "!" (například "endstop_pin: ^!ar3") nebo odstraňte "!", pokud je již přítomen.

Pokud se koncová zarážka vůbec nezmění, obecně to znamená, že koncová zarážka je připojena k jinému kolíku. Může však také vyžadovat změnu nastavení pullup pinu ('^' na začátku názvu endstop_pin - většina tiskáren bude používat pullup rezistor a '^' by mělo být přítomno).

## Ověřte krokové motory

Pomocí příkazu STEPPER_BUZZ ověřte konektivitu každého krokového motoru. Začněte ručním umístěním dané osy do středního bodu a poté spusťte `STEPPER_BUZZ STEPPER=stepper_x`. Příkaz STEPPER_BUZZ způsobí, že se daný stepper posune o jeden milimetr kladným směrem a poté se vrátí do výchozí polohy. (Pokud je koncová zarážka definována jako position_endstop=0, pak se na začátku každého pohybu stepper odkloní od koncové zarážky.) Tuto oscilaci provede desetkrát.

Pokud se stepper vůbec nepohybuje, ověřte nastavení "enable_pin" a "step_pin" pro stepper. Pokud se krokový motor pohybuje, ale nevrátí se do své původní polohy, ověřte nastavení "dir_pin". Pokud krokový motor kmitá nesprávným směrem, pak to obecně znamená, že "dir_pin" pro osu je třeba převrátit. To se provádí přidáním '!' na "dir_pin" v konfiguračním souboru tiskárny (nebo jej odstraňte, pokud tam již nějaký je). Pokud se motor pohybuje výrazně více nebo výrazně méně než jeden milimetr, ověřte nastavení "rotation_distance".

Spusťte výše uvedený test pro každý krokový motor definovaný v konfiguračním souboru. (Nastavte parametr STEPPER příkazu STEPPER_BUZZ na název konfigurační sekce, která má být testována.) Pokud v extruderu není žádné vlákno, můžete použít STEPPER_BUZZ k ověření připojení motoru extrudéru (použijte STEPPER=extruder). V opačném případě je nejlepší vyzkoušet motor extrudéru samostatně (viz další část).

Po ověření všech koncových dorazů a ověření všech krokových motorů by měl být otestován naváděcí mechanismus. Zadejte příkaz G28 pro návrat všech os. Pokud není tiskárna správně připojena, odpojte napájení. V případě potřeby zopakujte kroky ověření koncového dorazu a krokového motoru.

## Ověřte motor extruderu

Pro testování motoru extrudéru bude nutné zahřát extrudér na tiskovou teplotu. Přejděte na kartu Octoprint teplota a vyberte cílovou teplotu z rozevíracího pole teploty (nebo ručně zadejte vhodnou teplotu). Počkejte, až tiskárna dosáhne požadované teploty. Poté přejděte na kartu ovládání Octoprint a klikněte na tlačítko "Extrude". Ověřte, že se motor extrudéru otáčí správným směrem. Pokud ne, podívejte se na tipy pro odstraňování problémů v předchozí části a potvrďte nastavení „enable_pin“, „step_pin“ a „dir_pin“ pro extruder.

## Kalibrace nastavení PID

Klipper podporuje [PID ovládání](https://en.wikipedia.org/wiki/PID_controller) pro extruder a ohřívače lože. Aby bylo možné použít tento kontrolní mechanismus, je nutné zkalibrovat nastavení PID na každé tiskárně (nastavení PID nalezená v jiných firmwarech nebo v příkladech konfiguračních souborů často fungují špatně).

Chcete-li kalibrovat extruder, přejděte na kartu terminálu OctoPrint a spusťte příkaz PID_CALIBRATE. Například: `PID_CALIBRATE HEATER=extruder TARGET=170`

Po dokončení testu ladění spusťte `SAVE_CONFIG` a aktualizujte soubor printer.cfg na nové nastavení PID.

Pokud má tiskárna vyhřívané lůžko a podporuje řízení pomocí PWM (Pulse Width Modulation), pak se doporučuje použít pro lůžko PID řízení. (Když je ohřívač postele řízen pomocí algoritmu PID, může se zapnout a vypnout desetkrát za sekundu, což nemusí být vhodné pro ohřívače používající mechanický spínač.) Typický příkaz pro kalibraci PID lůžka je: `PID_CALIBRATE HEATER=heater_bed CÍL=60`

## Další kroky

Tato příručka má pomoci se základním ověřením nastavení pinů v konfiguračním souboru Klipper. Nezapomeňte si přečíst průvodce [vyrovnání postele](Bed_Level.md). Viz také dokument [Slicers](Slicers.md) pro informace o konfiguraci sliceru pomocí Klipperu.

Poté, co si ověříte, že základní tisk funguje, je dobré zvážit kalibraci [pressure advance] (Pressure_Advance.md).

Může být nutné provést další typy podrobné kalibrace tiskárny – online je k dispozici řada příruček, které vám s tím pomohou (například vyhledejte na webu „kalibrace 3D tiskárny“). Pokud například zaznamenáte efekt zvaný zvonění, můžete zkusit postupovat podle průvodce laděním [kompenzace rezonance](Resonance_Compensation.md).
