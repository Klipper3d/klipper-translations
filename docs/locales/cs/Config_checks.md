# Kontroly konfigurace

Tento dokument obsahuje seznam kroků, které vám pomohou potvrdit nastavení pinů v souboru Klipper printer.cfg. Je dobré si projít tyto kroky po provedení kroků v [ instalační dokument]( Installation .md).

Během této příručky může být nutné provést změny v konfiguračním souboru Klipper . Ujistěte se, že po každé změně konfiguračního souboru vydáte příkaz RESTART , abyste zajistili, že se změna projeví ( na kartě terminálu Octoprint zadejte " restart " a poté klikněte na "Odeslat"). Je také dobré po každém RESTARTU zadat příkaz STATUS , abyste ověřili, že byl konfigurační soubor úspěšně načten.

## Ověřte teplotu

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Ověřte M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Ověření ohřívačů

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Pokud má tiskárna vyhřívané lůžko, proveďte výše uvedený test znovu s lůžkem.

## Ověřte aktivační kolík krokového motoru

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Ověření koncovek

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Pokud se koncová zarážka vůbec nezmění, obecně to znamená, že koncová zarážka je připojena k jinému kolíku. Může však také vyžadovat změnu nastavení pullup pinu ('^' na začátku názvu endstop_pin - většina tiskáren bude používat pullup rezistor a '^' by mělo být přítomno).

## Ověřte krokové motory

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Pokud se stepper vůbec nepohybuje, ověřte nastavení "enable_pin" a "step_pin" pro stepper. Pokud se krokový motor pohybuje, ale nevrátí se do své původní polohy, ověřte nastavení "dir_pin". Pokud krokový motor kmitá nesprávným směrem, pak to obecně znamená, že "dir_pin" pro osu je třeba převrátit. To se provádí přidáním '!' na "dir_pin" v konfiguračním souboru tiskárny (nebo jej odstraňte, pokud tam již nějaký je). Pokud se motor pohybuje výrazně více nebo výrazně méně než jeden milimetr, ověřte nastavení "rotation_distance".

Spusťte výše uvedený test pro každý krokový motor definovaný v konfiguračním souboru. (Nastavte parametr STEPPER příkazu STEPPER_BUZZ na název konfigurační sekce, která má být testována.) Pokud v extruderu není žádné vlákno, můžete použít STEPPER_BUZZ k ověření připojení motoru extrudéru (použijte STEPPER=extruder). V opačném případě je nejlepší vyzkoušet motor extrudéru samostatně (viz další část).

Po ověření všech koncových dorazů a ověření všech krokových motorů by měl být otestován naváděcí mechanismus. Zadejte příkaz G28 pro návrat všech os. Pokud není tiskárna správně připojena, odpojte napájení. V případě potřeby zopakujte kroky ověření koncového dorazu a krokového motoru.

## Ověřte motor extruderu

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Kalibrace nastavení PID

Klipper podporuje [PID ovládání](https://en.wikipedia.org/wiki/PID_controller) pro extruder a ohřívače lože. Aby bylo možné použít tento kontrolní mechanismus, je nutné zkalibrovat nastavení PID na každé tiskárně (nastavení PID nalezená v jiných firmwarech nebo v příkladech konfiguračních souborů často fungují špatně).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

Po dokončení testu ladění spusťte `SAVE_CONFIG` a aktualizujte soubor printer.cfg na nové nastavení PID.

Pokud má tiskárna vyhřívané lůžko a podporuje řízení pomocí PWM (Pulse Width Modulation), pak se doporučuje použít pro lůžko PID řízení. (Když je ohřívač postele řízen pomocí algoritmu PID, může se zapnout a vypnout desetkrát za sekundu, což nemusí být vhodné pro ohřívače používající mechanický spínač.) Typický příkaz pro kalibraci PID lůžka je: `PID_CALIBRATE HEATER=heater_bed CÍL=60`

## Další kroky

Tato příručka má pomoci se základním ověřením nastavení pinů v konfiguračním souboru Klipper. Nezapomeňte si přečíst průvodce [vyrovnání postele](Bed_Level.md). Viz také dokument [Slicers](Slicers.md) pro informace o konfiguraci sliceru pomocí Klipperu.

Poté, co si ověříte, že základní tisk funguje, je dobré zvážit kalibraci [pressure_advance](Pressure_Advance.md).

Může být nutné provést další typy podrobné kalibrace tiskárny – online je k dispozici řada příruček, které vám s tím pomohou (například vyhledejte na webu „kalibrace 3D tiskárny“). Pokud například zaznamenáte efekt zvaný zvonění, můžete zkusit postupovat podle průvodce laděním [kompenzace rezonance](Resonance_Compensation.md).
