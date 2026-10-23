# Funktioner

Klipper har flera viktiga funktioner:

* Stegmotorrörelser med hög precision. Klipper använder en applikationsprocessor (till exempel en billig Raspberry Pi) för att beräkna skrivarens rörelser. Applikationsprocessorn bestämmer när varje stegmotor ska stega, komprimerar händelserna, överför dem till mikrokontrollern och mikrokontrollern utför varje händelse vid den begärda tidpunkten. Varje stegmotorhändelse schemaläggs med en precision på 25 mikrosekunder eller bättre. Programvaran använder inte kinematiska uppskattningar (som Bresenhams algoritm), utan beräknar exakta stegtider utifrån accelerationsfysik och maskinens kinematik. Exaktare stegmotorrörelser ger tystare och stabilare skrivardrift.
* Marknadsledande prestanda. Klipper kan uppnå höga steghastigheter på både nya och äldre mikrokontroller. Även äldre 8-bitars mikrokontroller kan nå över 175 000 steg per sekund. På modernare mikrokontroller är flera miljoner steg per sekund möjliga. Högre steghastigheter möjliggör högre utskriftshastigheter. Tidpunkten för stegmotorhändelser förblir exakt även vid höga hastigheter, vilket förbättrar den övergripande stabiliteten.
* Klipper stöder skrivare med flera mikrokontroller. En mikrokontroller kan till exempel styra en extruder, en annan skrivarens värmare och en tredje resten av skrivaren. Klippers värdprogramvara har klocksynkronisering för att kompensera för klockdrift mellan mikrokontroller. Ingen särskild kod behövs för att aktivera flera mikrokontroller; det kräver bara några extra rader i konfigurationsfilen.
* Konfiguration via en enkel konfigurationsfil. Mikrokontrollern behöver inte programmeras om för att ändra en inställning. Hela Klippers konfiguration lagras i en standardiserad konfigurationsfil som enkelt kan redigeras. Det förenklar installation och underhåll av maskinvaran.
* Klipper stöder "Smooth Pressure Advance", en mekanism som kompenserar för tryckets effekter i en extruder. Det minskar extruderns "efterflöde" och förbättrar kvaliteten på utskriftens hörn. Klippers implementation inför inte omedelbara hastighetsändringar för extrudern, vilket förbättrar stabilitet och robusthet.
* Klipper stöder "Input Shaping" för att minska vibrationers inverkan på utskriftskvaliteten. Det kan minska eller eliminera "ringing" (även kallat "ghosting", "echoing" eller "rippling") i utskrifter. Det kan även ge högre utskriftshastighet utan att försämra utskriftskvaliteten.
* Klipper använder en "iterativ lösningsmetod" för att beräkna exakta stegtider från enkla kinematiska ekvationer. Det förenklar portering av Klipper till nya typer av robotar och håller tidsberäkningen exakt även vid komplex kinematik (ingen "linjesegmentering" behövs).
* Klipper är maskinvaruoberoende. Man bör få samma exakta tidsstyrning oberoende av den underliggande elektroniska maskinvaran. Klippers mikrokontrollerkod är utformad för att troget följa schemat från Klippers värdprogramvara (eller tydligt varna användaren om den inte kan göra det). Detta gör det enklare att använda tillgänglig maskinvara, uppgradera till ny maskinvara och känna förtroende för maskinvaran.
* Portabel kod. Klipper fungerar på ARM, AVR, PRU och andra mikrokontroller. Befintliga skrivare av typen "reprap" kan köra Klipper utan att maskinvaran ändras – lägg bara till en Raspberry Pi. Klippers interna kodstruktur gör det också enklare att stödja andra mikrokontrollerarkitekturer.
* Enklare kod. Klipper använder ett mycket högnivåspråk (Python) för merparten av koden. Algoritmerna för kinematik, tolkning av G-kod, uppvärmning och termistorer med mera är alla skrivna i Python. Det gör det enklare att utveckla nya funktioner.
* Anpassade programmerbara makron. Nya G-kodkommandon kan definieras i skrivarens konfigurationsfil (inga kodändringar behövs). Kommandona är programmerbara och kan utföra olika åtgärder beroende på skrivarens tillstånd.
* Inbyggd API-server. Utöver standardgränssnittet för G-kod stöder Klipper ett omfattande JSON-baserat programgränssnitt. Det gör det möjligt för utvecklare att bygga externa program med detaljerad styrning av skrivaren.

## Ytterligare funktioner

Klipper stöder många vanliga funktioner för 3D-skrivare:

* Flera webbgränssnitt finns tillgängliga. Fungerar med Mainsail, Fluidd, OctoPrint och andra. Detta gör att skrivaren kan styras med en vanlig webbläsare. Samma Raspberry Pi som kör Klipper kan också köra webbgränssnittet.
* Standardstöd för G-kod. Vanliga G-kodkommandon som skapas av typiska "skivningsprogram" (SuperSlicer, Cura, PrusaSlicer osv.) stöds.
* Stöd för flera extrudrar. Extrudrar med delade värmare och extrudrar på oberoende vagnar (IDEX) stöds också.
* Stöd för skrivare av typen kartesisk, delta, CoreXY, CoreXZ, hybrid-CoreXY, hybrid-CoreXZ, deltesian, roterande delta, polär och kabelvinsch.
* Stöd för automatisk bäddnivellering. Klipper kan konfigureras för enkel avkänning av bäddlutning eller fullständig nätbaserad bäddnivellering. Bäddnätet kan anpassas till utskriftsstorleken (adaptivt bäddnät). Om bädden använder flera Z-stegmotorer kan Klipper också nivellera den genom att styra Z-stegmotorerna oberoende av varandra. De flesta Z-höjdsonder stöds, inklusive BLTouch-sonder och servoaktiverade sonder. Sonder kan kalibreras för kompensation av axelvridning. Med en "virvelströmssond" kan man använda snabb avsökning av bäddnätet.
* Stöd för automatisk delta-kalibrering. Kalibreringsverktyget kan utföra enkel höjdkalibrering samt förbättrad kalibrering av X- och Y-dimensioner. Kalibreringen kan göras med en Z-höjdsond eller manuellt.
* Stöd för att "utesluta objekt" under körning. När modulen är konfigurerad kan den underlätta att avbryta endast ett objekt i en utskrift med flera delar.
* Stöd för vanliga temperatursensorer (till exempel vanliga termistorer, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20, AHT1X, AHT2X, AHT3X, SHT3x och LM75). Anpassade termistorer och analoga temperatursensorer kan också konfigureras. Man kan övervaka den interna temperatursensorn i mikrokontrollern och den interna temperatursensorn i en Raspberry Pi.
* Grundläggande skydd mot värmarfel är aktiverat som standard.
* Stöd för vanliga fläktar, munstycksfläktar och temperaturstyrda fläktar. Fläktarna behöver inte vara igång när skrivaren är overksam. Fläkthastigheten kan övervakas för fläktar med varvräknare. En "matematisk formel" kan tilldelas en fläkt för automatisk uppdatering av fläkthastigheten.
* Stöd för konfiguration under körning av stegmotordrivarna TMC2130, TMC2208/TMC2224, TMC2209, TMC2240, TMC2660 och TMC5160. Det finns också stöd för strömstyrning av traditionella stegdrivare via AD5206, DAC084S085, MCP4451, MCP4728, MCP4018 och PWM-stift.
* Stöd för vanliga LCD-skärmar som ansluts direkt till skrivaren. En standardmeny finns också. Skärmens och menyns innehåll kan anpassas helt via konfigurationsfilen.
* Stöd för konstant acceleration och "framåtblick". Alla skrivarrörelser accelererar gradvis från stillastående till normal hastighet och bromsar sedan gradvis in igen. Den inkommande strömmen av G-kodkommandon för rörelse köas och analyseras; accelerationen mellan rörelser i liknande riktning optimeras för att minska utskriftsstopp och förbättra den totala utskriftstiden.
* Klipper implementerar en algoritm för "stegmotorfas-ändstopp" som kan förbättra noggrannheten hos vanliga ändstoppsbrytare. När den är rätt inställd kan den förbättra första lagrets vidhäftning mot byggplattan.
* Stöd för sensorer för filamentnärvaro, filamentrörelse och filamentbredd.
* Stöd för att mäta och registrera acceleration med accelerometrarna adxl345, mpu9250, mpu6050, lis2dw12, lis3dh och icm20948.
* Stöd för att begränsa topphastigheten för korta "sicksackrörelser" och minska skrivarens vibrationer och ljud. Se dokumentet [kinematik](Kinematics.md) för mer information.
* Exempelkonfigurationsfiler finns för många vanliga skrivare. Se [konfigurationskatalogen](../config/) för en lista.

Läs guiden [installation](Installation.md) för att komma igång med Klipper.

## Prestandamätningar för steg

Nedan visas resultaten från prestandatester för stegmotorer. Siffrorna anger totalt antal steg per sekund på mikrokontrollern.

| Mikrokontroller | 1 stegmotor aktiv | 3 stegmotorer aktiva |
| --- | --- | --- |
| 16Mhz AVR | 157K | 99K |
| 20Mhz AVR | 196K | 123K |
| SAMD21 | 686K | 471K |
| STM32F042 | 814K | 578K |
| Beaglebone PRU | 866K | 708K |
| STM32G0B1 | 1103K | 790K |
| STM32F103 | 1180K | 818K |
| SAM3X8E | 1273K | 981K |
| SAM4S8C | 1690K | 1385K |
| LPC1768 | 1923K | 1351K |
| LPC1769 | 2353K | 1622K |
| SAM4E8E | 2500K | 1674K |
| SAMD51 | 3077K | 1885K |
| AR100 | 3529K | 2507K |
| STM32G431 | 3617K | 2452K |
| STM32F407 | 3652K | 2459K |
| STM32F446 | 3913K | 2634K |
| RP2040 | 4000K | 2571K |
| RP2350 | 4167K | 2663K |
| SAME70 | 6667K | 4737K |
| STM32H723 | 7429K | 8619K |

Om du är osäker på vilken mikrokontroller ett visst kort har, leta upp lämplig [konfigurationsfil](../config/) och sök efter mikrokontrollerns namn i kommentarerna högst upp i filen.

Mer information om prestandamätningarna finns i dokumentet [prestandamätningar](Benchmarks.md).
