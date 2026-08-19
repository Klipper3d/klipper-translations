# Kontroly konfigurace

Tento dokument obsahuje seznam kroků, které vám pomohou potvrdit nastavení pinů v souboru Klipper printer.cfg. Je dobré si projít tyto kroky po provedení kroků v [ instalační dokument]( Installation .md).

Během této příručky může být nutné provést změny v konfiguračním souboru Klipper . Ujistěte se, že po každé změně konfiguračního souboru vydáte příkaz RESTART , abyste zajistili, že se změna projeví ( na kartě terminálu Octoprint zadejte " restart " a poté klikněte na "Odeslat"). Je také dobré po každém RESTARTU zadat příkaz STATUS , abyste ověřili, že byl konfigurační soubor úspěšně načten.

## Ověřte teplotu

Začněte ověřením, zda jsou teploty správně hlášeny. Přejděte do části grafu teploty v uživatelském rozhraní. Ověřte, zda je přítomna teplota trysky a bedu (pokud je to relevantní) a zda se nezvyšuje. Pokud se zvyšuje, odpojte tiskárnu od napájení. Pokud teploty nejsou přesné, zkontrolujte nastavení „sensor_type“ a „sensor_pin“ pro trysku a/nebo bedu.

## Ověřte M112

Přejděte na příkazovou konzolu a v okně terminálu zadejte příkaz M112. Tento příkaz požaduje, aby Klipper přešel do stavu „vypnutí“. To způsobí zobrazení chyby, kterou lze vymazat příkazem FIRMWARE_RESTART v příkazové konzole. Octoprint bude rovněž vyžadovat opětovné připojení. Poté přejděte do části s teplotním grafem a zkontrolujte, zda se teploty nadále aktualizují a zda se nezvyšují. Pokud se teploty zvyšují, odpojte tiskárnu od napájení.

## Ověření ohřívačů

Přejděte do části s teplotním grafem a do pole pro teplotu extrudéru/nástroje zadejte 50 a následně enter. Teplota extrudéru v grafu by se měla začít zvyšovat (přibližně během 30 sekund). Poté přejděte do rozevíracího pole Teplota extrudéru a vyberte možnost „Vypnuto“. Po několika minutách by se teplota měla začít vracet na původní hodnotu pokojové teploty. Pokud se teplota nezvyšuje, ověřte nastavení „heater_pin“ v konfiguraci.

Pokud má tiskárna vyhřívané lůžko, proveďte výše uvedený test znovu s lůžkem.

## Ověřte aktivační kolík krokového motoru

Zkontrolujte, zda se všechny osy tiskárny mohou volně pohybovat (krokové motory jsou vypnuté). Pokud tomu tak není, vydejte příkaz M84 k deaktivaci motorů. Pokud se některá z os stále nemůže volně pohybovat, ověřte konfiguraci krokových motorů „enable_pin“ pro danou osu. U většiny komoditních ovladačů krokových motorů je pin povolení motoru „active low“, a proto by měl mít pin povolení před sebou znak „!“ (například „enable_pin: !PA1“).

## Ověření koncovek

Ručně přesuňte všechny osy tiskárny tak, aby se žádná z nich nedotýkala koncového dorazu. Odešlete příkaz QUERY_ENDSTOPS prostřednictvím příkazové konzoly. Měla by odpovědět s aktuálním stavem všech nakonfigurovaných koncových dorazů a všechny by měly hlásit stav „otevřeno“. Pro každý koncový uzávěr znovu spusťte příkaz QUERY_ENDSTOPS a zároveň ručně spusťte koncový uzávěr. Příkaz QUERY_ENDSTOPS by měl hlásit koncovou zarážku jako „TRIGGERED“.

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!PA2"), or remove the "!" if there is already one present.

Pokud se koncová zarážka vůbec nezmění, obecně to znamená, že koncová zarážka je připojena k jinému kolíku. Může však také vyžadovat změnu nastavení pullup pinu ('^' na začátku názvu endstop_pin - většina tiskáren bude používat pullup rezistor a '^' by mělo být přítomno).

## Ověřte krokové motory

Pomocí příkazu STEPPER_BUZZ ověřte připojení každého krokového motoru. Začněte ručním nastavením dané osy do středního bodu a poté v příkazové konzole spusťte `STEPPER_BUZZ STEPPER=stepper_x`. Příkaz STEPPER_BUZZ způsobí, že se daný krokový motor posune o jeden milimetr v kladném směru a poté se vrátí do výchozí polohy. (Pokud je koncový doraz definován na pozici position_endstop=0, pak se na začátku každého pohybu krokový ovladač od tohoto dorazu vzdálí.) Tuto oscilaci provede desetkrát.

Pokud se stepper vůbec nepohybuje, ověřte nastavení "enable_pin" a "step_pin" pro stepper. Pokud se krokový motor pohybuje, ale nevrátí se do své původní polohy, ověřte nastavení "dir_pin". Pokud krokový motor kmitá nesprávným směrem, pak to obecně znamená, že "dir_pin" pro osu je třeba převrátit. To se provádí přidáním '!' na "dir_pin" v konfiguračním souboru tiskárny (nebo jej odstraňte, pokud tam již nějaký je). Pokud se motor pohybuje výrazně více nebo výrazně méně než jeden milimetr, ověřte nastavení "rotation_distance".

Spusťte výše uvedený test pro každý krokový motor definovaný v konfiguračním souboru. (Nastavte parametr STEPPER příkazu STEPPER_BUZZ na název konfigurační sekce, která má být testována.) Pokud v extruderu není žádné vlákno, můžete použít STEPPER_BUZZ k ověření připojení motoru extrudéru (použijte STEPPER=extruder). V opačném případě je nejlepší vyzkoušet motor extrudéru samostatně (viz další část).

Po ověření všech koncových dorazů a ověření všech krokových motorů by měl být otestován naváděcí mechanismus. Zadejte příkaz G28 pro návrat všech os. Pokud není tiskárna správně připojena, odpojte napájení. V případě potřeby zopakujte kroky ověření koncového dorazu a krokového motoru.

## Ověřte motor extruderu

Pro otestování motoru extrudéru je nutné zahřát extrudér na tiskovou teplotu. Přejděte do části s teplotním grafem a vyberte cílovou teplotu z rozevíracího pole teploty (nebo zadejte vhodnou teplotu ručně). Počkejte, až tiskárna dosáhne požadované teploty. Poté přejděte do příkazové konzoly a klikněte na tlačítko „Extrude“. Zkontrolujte, zda se motor extrudéru otáčí správným směrem. Pokud se tak neděje, podívejte se na tipy pro řešení problémů v předchozí části a potvrďte nastavení „enable_pin“, „step_pin“ a „dir_pin“ pro extrudér.

## Kalibrace nastavení PID

Klipper podporuje [PID ovládání](https://en.wikipedia.org/wiki/PID_controller) pro extruder a ohřívače lože. Aby bylo možné použít tento kontrolní mechanismus, je nutné zkalibrovat nastavení PID na každé tiskárně (nastavení PID nalezená v jiných firmwarech nebo v příkladech konfiguračních souborů často fungují špatně).

Chcete-li kalibrovat extrudér, přejděte do příkazové konzoly a spusťte příkaz PID_CALIBRATE. Například: `PID_CALIBRATE HEATER=extruder TARGET=170`

Po dokončení testu ladění spusťte `SAVE_CONFIG` a aktualizujte soubor printer.cfg na nové nastavení PID.

Pokud má tiskárna vyhřívané lůžko a podporuje řízení pomocí PWM (Pulse Width Modulation), pak se doporučuje použít pro lůžko PID řízení. (Když je ohřívač postele řízen pomocí algoritmu PID, může se zapnout a vypnout desetkrát za sekundu, což nemusí být vhodné pro ohřívače používající mechanický spínač.) Typický příkaz pro kalibraci PID lůžka je: `PID_CALIBRATE HEATER=heater_bed CÍL=60`

## Další kroky

Tato příručka má pomoci se základním ověřením nastavení pinů v konfiguračním souboru Klipper. Nezapomeňte si přečíst průvodce [vyrovnání postele](Bed_Level.md). Viz také dokument [Slicers](Slicers.md) pro informace o konfiguraci sliceru pomocí Klipperu.

Poté, co si ověříte, že základní tisk funguje, je dobré zvážit kalibraci [pressure_advance](Pressure_Advance.md).

Může být nutné provést další typy podrobné kalibrace tiskárny – online je k dispozici řada příruček, které vám s tím pomohou (například vyhledejte na webu „kalibrace 3D tiskárny“). Pokud například zaznamenáte efekt zvaný zvonění, můžete zkusit postupovat podle průvodce laděním [kompenzace rezonance](Resonance_Compensation.md).
