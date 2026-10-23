# Versioner

Historik över Klipper-utgåvor. Information om hur du installerar Klipper finns i [installationsanvisningarna](Installation.md).

## Klipper 0.13.0

Tillgänglig den 2025-04-11. Större ändringar i den här utgåvan:

* Ny mekanism för resonanstest med "svepande vibrationer" för input shaper.
* Fläktar och GPIO-stift kan nu tilldelas en formel (via Jinja2-"mallar").
* Koden bed_mesh stöder nu "adaptiv bäddmesh". Det sonderade området kan anpassas till utskriftens storlek.
* En ny kinematikparameter, `minimum_cruise_ratio`, har lagts till (den ersätter den tidigare parametern `max_accel_to_decel`).
* Flera nya sensorer:
   * Stöd för ldc1612-"eddy current"-sensorer. Det omfattar stöd för sondering, snabb "scan"-sondering och temperaturkalibrering.
   * Nytt stöd för mätningar med "load cell". Stöd för att ansluta dessa lastceller till ADC-sensorerna hx71x och ads1220.
   * Stöd för temperatursensorerna BMP180, BMP388 och SHT3x. Stöd för temperaturmätning med ADS1x1x ADC-chip.
   * Nytt stöd för accelerometrarna lis3dh och icm20948.
   * Stöd för "hall angle"-sensorerna mt6816 och mt6826s.
* Nya förbättringar av mikrokontroller:
   * Nytt stöd för rp2350-mikrokontroller.
   * Befintliga rp2040-chip körs nu vid 200 MHz (i stället för 125 MHz).
   * Mikrokontrollerkoden kan nu definiera betydligt fler kommandon (upp till 16384 i stället för 128).
* Andra tillagda moduler: aip31068_spi, canbus_stats, error_mcu, garbage_collection, pwm_cycle_time, pwm_tool, garbage_collection.
* Flera felrättningar och kodstädningar.

## Klipper 0.12.0

Tillgänglig den 2023-11-10. Större ändringar i den här utgåvan:

* Stöd för lägena COPY och MIRROR på IDEX-skrivare.
* Flera förbättringar av mikrokontroller:
   * Stöd för de nya arkitekturerna ar100 och hc32f460.
   * Stöd för chipvarianterna stm32f7, stm32g0b0, stm32g07x, stm32g4, stm32h723, n32g45x, samc21 och samd21j18.
   * Förbättrad hantering av omstarter med DFU och Katapult.
   * Förbättrad prestanda för bryggläget USB till CAN-buss.
   * Förbättrad prestanda för "linux mcu".
   * Nytt stöd för programvarubaserad I2C.
* Nytt maskinvarustöd för stegmotordrivrutinerna tmc2240, accelerometrarna lis2dw12 och temperatursensorerna aht10.
* Nya moduler axis_twist_compensation och temperature_combined.
* Nytt stöd för g-kodbågar i XY-, XZ- och YZ-plan.
* Flera felrättningar och kodstädningar.

## Klipper 0.11.0

Tillgänglig den 2022-11-28. Större ändringar i den här utgåvan:

* Optimering för Trinamic-stegmotordrivrutiner: "step on both edges".
* Stöd för Python 3. Klippers värdkod körs med antingen Python 2 eller Python 3.
* Förbättrat CAN-bussstöd. Stöd för CAN-buss på chipen rp2040, stm32g0, stm32h7, same51 och same54. Stöd för läget "USB till CAN-bussbrygga".
* Stöd för CanBoot-bootloader.
* Stöd för accelerometrarna mpu9250 och mpu6050.
* Förbättrad felhantering för temperatursensorerna max31856, max31855, max31865 och max6675.
* Det går nu att konfigurera LED:ar så att de uppdateras under långvariga G-kodkommandon med stöd för LED-"mallar".
* Flera förbättringar av mikrokontroller. Nytt stöd för chipen stm32h743, stm32h750, stm32l412, stm32g0b1, same70, same51 och same54. Stöd för I2C-läsningar på atsamd och stm32f0. Maskinvarustöd för PWM på stm32. Händelseutskick i Linux MCU baserat på signaler. Nytt rp2040-stöd för "make flash", I2C och USB-erratan rp2040-e5.
* Nya moduler: angle, dac084S085, exclude_object, led, mpu9250, pca9632, smart_effector, z_thermal_adjust. Ny deltesisk kinematik. Nytt verktyg dump_mcu.
* Flera felrättningar och kodstädningar.

## Klipper 0.10.0

Tillgänglig den 2021-09-29. Större ändringar i den här utgåvan:

* Stöd för "Multi-MCU Homing". En stegmotor och dess ändläge kan nu vara anslutna till separata mikrokontroller. Det förenklar kabeldragningen för Z-sonder på "toolhead boards".
* Klipper har nu en [Discord-server för communityn](https://discord.klipper3d.org) och en [Discourse-server för communityn](https://community.klipper3d.org).
* [Klippers webbplats](https://www.klipper3d.org) använder nu infrastrukturen "mkdocs". Det finns också projektet [Klipper Translations](https://github.com/Klipper3d/klipper-translations).
* Automatiserat stöd för att flasha firmware via SD-kort på många kort.
* Nytt kinematikstöd för skrivarna "Hybrid CoreXY" och "Hybrid CoreXZ".
* Klipper använder nu `rotation_distance` för att konfigurera stegmotorers rörelsesträckor.
* Klippers huvudsakliga värdkod kan nu kommunicera direkt med mikrokontroller via CAN-buss.
* Nytt system för "rörelseanalys". Klippers interna rörelseuppdateringar och sensorresultat kan följas och loggas för analys.
* Trinamic-stegmotordrivrutiner övervakas nu kontinuerligt för feltillstånd.
* Stöd för mikrokontrollern rp2040 (Raspberry Pi Pico-kort).
* Systemet "make menuconfig" använder nu kconfiglib.
* Många ytterligare moduler: ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu.
* Flera felrättningar och kodstädningar.

## Klipper 0.9.0

Tillgänglig den 2020-10-20. Större ändringar i den här utgåvan:

* Stöd för "Input Shaping" – en metod för att motverka skrivarresonanser. Den kan minska eller eliminera "ringing" i utskrifter.
* Nytt system för "Smooth Pressure Advance". Det implementerar "Pressure Advance" utan att införa omedelbara hastighetsändringar. Det går nu också att trimma pressure advance med metoden "Tuning Tower".
* Ny API-server för "webhooks". Den tillhandahåller ett programmerbart JSON-gränssnitt till Klipper.
* LCD-skärmen och menyn kan nu konfigureras med mallspråket Jinja2.
* Stegmotordrivrutinerna TMC2208 kan nu användas i "fristående" läge med Klipper.
* Förbättrat stöd för BL-Touch v3.
* Förbättrad USB-identifiering. Klipper har nu en egen USB-identifieringskod och mikrokontroller kan rapportera sina unika serienummer vid USB-identifiering.
* Nytt kinematikstöd för skrivarna "Rotary Delta" och "CoreXZ".
* Förbättringar för mikrokontroller: stöd för stm32f070 och stm32f207, stöd för GPIO-stift på "Linux MCU", stöd för stm32 "HID bootloader", Chitu-bootloader och MKS Robin-bootloader.
* Förbättrad hantering av händelser för Python "garbage collection".
* Många ytterligare moduler: adc_scaled, adxl345, bme280, display_status, extruder_stepper, fan_generic, hall_filament_width_sensor, htu21d, homing_heaters, input_shaper, lm75, print_stats, resonance_tester, shaper_calibrate, query_adc, graph_accelerometer, graph_extruder, graph_motion, graph_shaper, graph_temp_sensor, whconsole
* Flera felrättningar och kodstädningar.

### Klipper 0.9.1

Tillgänglig den 2020-10-28. Utgåva som endast innehåller felrättningar.

## Klipper 0.8.0

Tillgänglig den 2019-10-21. Större ändringar i den här utgåvan:

* Nytt stöd för G-kodkommandon i mallar. G-kod i konfigurationsfilen utvärderas nu med mallspråket Jinja2.
* Förbättringar av Trinamic-stegdrivrutiner:
   * Nytt stöd för drivrutinerna TMC2209 och TMC5160.
   * Förbättrade G-kodkommandon DUMP_TMC, SET_TMC_CURRENT och INIT_TMC.
   * Förbättrat stöd för hantering av TMC UART med en analog multiplexor.
* Förbättrat stöd för hemlägeskörning, sondering och bäddnivellering:
   * Nya moduler tillagda: manual_probe, bed_screws, screws_tilt_adjust, skew_correction, safe_z_home.
   * Förbättrad sondering med flera prov, median-, medelvärdes- och återförsökslogik.
   * Förbättrad dokumentation för BL-Touch, sondkalibrering, ändlägeskalibrering, delta-kalibrering, sensorlös hemlägeskörning och kalibrering av ändlägesfas.
   * Förbättrat stöd för hemlägeskörning på en stor Z-axel.
* Många förbättringar för Klipper-mikrokontroller:
   * Klipper portat till: SAM3X8C, SAM4S8C, SAMD51, STM32F042, STM32F4.
   * Nya implementationer av USB CDC-drivrutiner på SAM3X, SAM4, STM32F4.
   * Förbättrat stöd för att flasha Klipper över USB.
   * Stöd för programvaru-SPI.
   * Kraftigt förbättrad temperaturfiltrering på LPC176x.
   * Tidiga inställningar för utgångsstift kan konfigureras i mikrokontrollern.
* Ny webbplats med Klipper-dokumentationen: http://klipper3d.org/
   * Klipper har nu en logotyp.
* Experimentellt stöd för polar- och "cable winch"-kinematik.
* Konfigurationsfilen kan nu inkludera andra konfigurationsfiler.
* Många ytterligare moduler: board_pins, controller_fan, delayed_gcode, dotstar, filament_switch_sensor, firmware_retraction, gcode_arcs, gcode_button, heater_generic, manual_stepper, mcp4018, mcp4728, neopixel, pause_resume, respond, temperature_sensor, tsl1401cl_filament_width_sensor, tuning_tower.
* Många nya kommandon: RESTORE_GCODE_STATE, SAVE_GCODE_STATE, SET_GCODE_VARIABLE, SET_HEATER_TEMPERATURE, SET_IDLE_TIMEOUT, SET_TEMPERATURE_FAN_TARGET.
* Flera felrättningar och kodstädningar.

## Klipper 0.7.0

Tillgänglig den 2018-12-20. Större ändringar i den här utgåvan:

* Klipper stöder nu "mesh"-bäddnivellering.
* Nytt stöd för "förbättrad" delta-kalibrering (kalibrerar utskriftens x/y-mått på delta-skrivare).
* Stöd för körningskonfiguration av Trinamic-stegmotordrivrutiner (tmc2130, tmc2208, tmc2660).
* Förbättrat stöd för temperatursensorer: MAX6675, MAX31855, MAX31856, MAX31865, egna termistorer och vanliga pt100-sensorer.
* Flera nya moduler: temperature_fan, sx1509, force_move, mcp4451, z_tilt, quad_gantry_level, endstop_phase, bltouch.
* Flera nya kommandon: SAVE_CONFIG, SET_PRESSURE_ADVANCE, SET_GCODE_OFFSET, SET_VELOCITY_LIMIT, STEPPER_BUZZ, TURN_OFF_HEATERS, M204, anpassade g-kodmakron.
* Utökat LCD-skärmstöd:
   * Stöd för körningsmenyer.
   * Nya skärmikoner.
   * Stöd för skärmarna "uc1701" och "ssd1306".
* Ytterligare stöd för mikrokontroller:
   * Klipper portat till: LPC176x (Smoothieboards), SAM4E8E (Duet2), SAMD21 (Arduino Zero), STM32F103 ("Blue pill"-enheter), atmega32u4.
   * Ny generisk USB CDC-drivrutin implementerad på AVR, LPC176x, SAMD21 och STM32F103.
   * Prestandaförbättringar på ARM-processorer.
* Koden för kinematik skrevs om för att använda en "iterativ lösare".
* Nya automatiska testfall för Klippers värdprogramvara.
* Många nya exempelkonfigurationsfiler för vanliga standardskrivare.
* Dokumentationsuppdateringar för bootloaders, prestandamätning, portning av mikrokontroller, konfigurationskontroller, stiftmappning, slicer-inställningar, paketering med mera.
* Flera felrättningar och kodstädningar.

## Klipper 0.6.0

Tillgänglig den 2018-03-31. Större ändringar i den här utgåvan:

* Förbättrade kontroller av maskinvarufel för värmare och termistorer.
* Stöd för Z-sonder.
* Inledande stöd för automatisk parameterkalibrering på delta-skrivare (via ett nytt kommando delta_calibrate).
* Inledande stöd för kompensation av bäddlutning (via kommandot bed_tilt_calibrate).
* Inledande stöd för "safe homing" och åsidosättanden av hemlägeskörning.
* Inledande stöd för statusvisning på 2004- och 12864-skärmar av RepRapDiscount-typ.
* Nya förbättringar för flera extrudrar:
   * Stöd för delade värmare.
   * Inledande stöd för dubbla vagnar.
* Stöd för att konfigurera flera stegmotorer per axel (till exempel dubbel Z).
* Stöd för anpassade digitala utgångsstift och PWM-utgångsstift (med ett nytt kommando SET_PIN).
* Inledande stöd för ett "virtuellt SD-kort" som möjliggör utskrift direkt från Klipper (hjälper på maskiner som är för långsamma för att köra OctoPrint väl).
* Stöd för att ange olika armlängder på varje torn i en delta-skrivare.
* Stöd för G-kodkommandona M220/M221 (åsidosättande av hastighetsfaktor/extruderingsfaktor).
* Flera dokumentationsuppdateringar:
   * Många nya exempelkonfigurationsfiler för vanliga standardskrivare.
   * Nytt konfigurationsexempel för flera MCU:er.
   * Nytt konfigurationsexempel för bltouch-sensor.
   * Nya dokument om vanliga frågor, konfigurationskontroll och G-kod.
* Inledande stöd för kontinuerlig integreringstestning på alla GitHub-incheckningar.
* Flera felrättningar och kodstädningar.

## Klipper 0.5.0

Tillgänglig den 2017-10-25. Större ändringar i den här utgåvan:

* Stöd för skrivare med flera extrudrar.
* Inledande stöd för körning på Beaglebone PRU. Inledande stöd för Replicape-kortet.
* Inledande stöd för att köra mikrokontrollerkoden i en Linux-process med realtidsegenskaper.
* Stöd för flera mikrokontroller. (En extruder kan till exempel styras med en mikrokontroller och resten av skrivaren med en annan.) Programvaruklocksynkronisering implementeras för att samordna åtgärder mellan mikrokontroller.
* Prestandaförbättringar för stegmotorer (20 MHz AVR:er upp till 189 K steg per sekund).
* Stöd för styrning av servon och för att definiera fläktar för munstyckskylning.
* Flera felrättningar och kodstädningar.

## Klipper 0.4.0

Tillgänglig den 2017-05-03. Större ändringar i den här utgåvan:

* Förbättrad installation på Raspberry Pi-maskiner. Merparten av installationen skriptas nu.
* Stöd för corexy-kinematik.
* Dokumentationsuppdateringar: nytt dokument om kinematik, ny guide för trimning av Pressure Advance, nya exempelkonfigurationsfiler med mera.
* Prestandaförbättringar för stegmotorer (20 MHz AVR:er över 175 K steg per sekund, Arduino Due över 460 K).
* Stöd för automatiska återställningar av mikrokontrollern. Stöd för återställning genom att växla USB-strömmen på Raspberry Pi.
* Algoritmen för pressure advance använder nu look-ahead för att minska tryckändringar vid hörn.
* Stöd för att begränsa topphastigheten för korta sicksackrörelser.
* Stöd för AD595-sensorer.
* Flera felrättningar och kodstädningar.

## Klipper 0.3.0

Tillgänglig den 2016-12-23. Större ändringar i den här utgåvan:

* Förbättrad dokumentation.
* Stöd för robotar med delta-kinematik.
* Stöd för Arduino Due-mikrokontroller (ARM Cortex-M3).
* Stöd för USB-baserade AVR-mikrokontroller.
* Stöd för algoritmen "pressure advance" – den minskar filamentläckage under utskrifter.
* Ny funktion för "stegmotorbaserad ändlägesfas" – ger högre precision vid hemlägeskörning mot ändlägen.
* Stöd för "extended g-code"-kommandon som "help", "restart" och "status".
* Stöd för att läsa om Klipper-konfigurationen och starta om värdprogramvaran genom att utfärda kommandot "restart" i terminalen.
* Prestandaförbättringar för stegmotorer (20 MHz AVR:er upp till 158 K steg per sekund).
* Förbättrad felrapportering. De flesta fel visas nu i terminalen tillsammans med hjälp om hur de löses.
* Flera felrättningar och kodstädningar.

## Klipper 0.2.0

Klippers första utgåva. Tillgänglig den 2016-05-25. De främsta funktionerna i den första utgåvan omfattar:

* Grundläggande stöd för kartesiska skrivare (stegmotorer, extruder, uppvärmd bädd, kylfläkt).
* Stöd för vanliga g-kodkommandon. Stöd för gränssnitt mot OctoPrint.
* Hantering av acceleration och look-ahead.
* Stöd för AVR-mikrokontroller via vanliga seriella portar.
