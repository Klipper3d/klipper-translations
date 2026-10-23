# Installation

De här anvisningarna förutsätter att programvaran körs på en Linux-baserad värd med ett Klipper-kompatibelt gränssnitt. Vi rekommenderar en enkortsdator (SBC), som Raspberry Pi, eller en Debian-baserad Linux-enhet som värddator (fler alternativ finns i [vanliga frågor](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)).

I dessa anvisningar avser värd Linux-enheten och mcu skrivarkortet. SBC står för Small Board Computer, till exempel Raspberry Pi.

## Hämta en Klipper-konfigurationsfil

De flesta Klipper-inställningar anges i skrivarens konfigurationsfil, printer.cfg, som lagras på värden. En lämplig konfigurationsfil finns ofta i Klippers [konfigurationskatalog](../config/) som en fil med prefixet "printer-" för den aktuella skrivaren. Konfigurationsfilen innehåller den tekniska information om skrivaren som behövs under installationen.

Om det saknas en lämplig skrivarkonfigurationsfil i Klippers konfigurationskatalog, sök på skrivartillverkarens webbplats efter en lämplig Klipper-konfigurationsfil.

Om ingen konfigurationsfil för skrivaren går att hitta men skrivarkortets typ är känd, leta efter en lämplig [konfigurationsfil](../config/) med prefixet "generic-". Exempelfilerna för skrivarkort bör göra det möjligt att slutföra den första installationen, men kräver anpassning för full funktionalitet.

Du kan också skapa en ny skrivarkonfiguration från grunden. Det kräver dock betydande teknisk kunskap om skrivaren och dess elektronik. De flesta bör börja med en lämplig konfigurationsfil. Om du skapar en egen fil, börja med närmaste exempel-[konfigurationsfil](../config/) och använd Klippers [konfigurationsreferens](Config_Reference.md) för mer information.

## Använda Klipper

Klipper är firmware för 3D-skrivare och behöver därför ett sätt för användaren att interagera med det.

De bästa alternativen är för närvarande gränssnitt som hämtar information via [Moonrakers webb-API](https://moonraker.readthedocs.io/). Du kan också använda [OctoPrint](https://octoprint.org/) för att styra Klipper.

Valet är användarens, men Klipper i grunden är samma i alla fall. Vi uppmuntrar användare att undersöka tillgängliga alternativ och fatta ett välgrundat beslut.

## Hämta en OS-avbildning för SBC:er

Det finns många sätt att hämta en OS-avbildning för Klipper på en SBC och valet beror oftast på vilket gränssnitt du vill använda. Vissa tillverkare av SBC-kort erbjuder även egna Klipper-anpassade avbildningar.

De två främsta Moonraker-baserade gränssnitten är [Fluidd](https://docs.fluidd.xyz/) och [Mainsail](https://docs.mainsail.xyz/). Det senare har den färdiga installationsavbildningen ["MainsailOS"](https://docs-os.mainsail.xyz/) för Raspberry Pi och vissa OrangePi-varianter.

Fluidd kan installeras via KIAUH (Klipper Install And Update Helper), som beskrivs nedan och är ett tredjepartsinstallationsprogram för Klipper.

OctoPrint kan installeras med den populära OctoPi-avbildningen eller via KIAUH; processen beskrivs i <OctoPrint.md>

## Installera med KIAUH

Vanligen börjar du med en grundavbildning för SBC:n, till exempel RPiOS Lite, eller Ubuntu Server för en x86-baserad Linux-enhet. Skrivbordsversioner rekommenderas inte, eftersom vissa hjälpprogram kan hindra Klipper-funktioner och till och med dölja åtkomst till vissa skrivarkort.

KIAUH kan användas för att installera Klipper och tillhörande program på flera Debian-baserade Linux-system. Mer information finns på https://github.com/dw-0/kiauh

## Bygga och flasha mikrokontrollern

Börja kompilera mikrokontrollerkoden genom att köra följande kommandon på värdenheten:

```
cd ~/klipper/
make menuconfig
```

Kommentarerna överst i [skrivarens konfigurationsfil](#obtain-a-klipper-configuration-file) ska beskriva de inställningar som behöver göras i "make menuconfig". Öppna filen i en webbläsare eller textredigerare och leta efter anvisningarna högst upp. När rätt "menuconfig"-inställningar är gjorda, tryck "Q" för att avsluta och sedan "Y" för att spara. Kör därefter:

```
make
```

Om kommentarerna högst upp i [skrivarens konfigurationsfil](#obtain-a-klipper-configuration-file) beskriver särskilda steg för att "flasha" den färdiga avbildningen till skrivarkortet följer du dem och fortsätter sedan till [konfigurera OctoPrint](#configuring-octoprint-to-use-klipper).

I annat fall används ofta följande steg för att "flasha" skrivarkortet. Bestäm först vilken seriell port som är ansluten till mikrokontrollern. Kör:

```
ls /dev/serial/by-id/*
```

Den ska visa något som liknar följande:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Varje skrivare har vanligen ett eget unikt seriellt portnamn. Det används vid flashning av mikrokontrollern. Utdata ovan kan innehålla flera rader; välj då raden som motsvarar mikrokontrollern. Om många poster visas och valet är tvetydigt kopplar du från kortet och kör kommandot igen. Den post som försvinner är skrivarkortet (se [vanliga frågor](FAQ.md#wheres-my-serial-port) för mer information).

Vanliga mikrokontroller med STM32-kretsar eller kloner, LPC-kretsar och andra behöver normalt en första Klipper-flashning via SD-kort.

Vid denna metod är det viktigt att skrivarkortet inte är anslutet till värden via USB. Vissa kort kan mata tillbaka ström till kortet och därmed förhindra flashning.

Observera att de flesta skrivarkort som flashas via SD-kort har någon form av skydd mot en flashningsslinga när SD-kortet lämnas kvar. Det finns två vanliga metoder:

Filnamnet måste ändras (vanligen originalskrivarkort):

Dessa kort kräver att firmwarefilen har ett nytt namn vid varje flashning (till exempel firmware1.bin, firmware2.bin och så vidare). Om du återanvänder samma filnamn kan kortet ignorera den och inte uppdateras.

Automatisk namnändring av filer (vanligen eftermarknadsskrivarkort):

Andra kort tillåter samma filnamn, vanligen firmware.bin, men efter flashningen byter kortet namn på filen till firmware.cur. Det visar att firmware har flashats och förhindrar att den flashas igen vid nästa uppstart.

Kontrollera vilket beteende ditt kort har före flashningen.

För vanliga mikrokontroller med Atmega-kretsar, till exempel 2560, kan koden flashas med något i stil med:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Kontrollera att FLASH_DEVICE uppdateras med skrivarens unika seriella portnamn.

För vanliga mikrokontroller med RP2040-kretsar kan koden flashas med något i stil med:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

Observera att RP2040-kretsar kan behöva försättas i startläge före åtgärden.

## Konfigurera Klipper

Nästa steg är att kopiera [skrivarens konfigurationsfil](#obtain-a-klipper-configuration-file) till värden.

Det enklaste sättet att ange Klippers konfigurationsfil är sannolikt de inbyggda redigerarna i Mainsail eller Fluidd. Där kan du öppna konfigurationsexemplen och spara dem som printer.cfg.

Ett annat alternativ är en skrivbordsredigerare som kan redigera filer via protokollen "scp" och/eller "sftp". Det finns fria verktyg för detta, till exempel Notepad++, WinSCP och Cyberduck. Öppna skrivarens konfigurationsfil i redigeraren och spara den som "printer.cfg" i användaren pi:s hemkatalog, alltså /home/pi/printer.cfg.

Du kan också kopiera och redigera filen direkt på värden via SSH. Det kan se ut ungefär så här (uppdatera kommandot med rätt filnamn för skrivarens konfiguration):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Varje skrivare har vanligen ett eget unikt namn för mikrokontrollern. Namnet kan ändras efter att Klipper har flashats, så upprepa stegen även om de redan har utförts vid flashningen. Kör:

```
ls /dev/serial/by-id/*
```

Den ska visa något som liknar följande:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Uppdatera sedan konfigurationsfilen med det unika namnet. Uppdatera till exempel avsnittet `[mcu]` så att det ser ut ungefär så här:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

När filen har skapats och redigerats måste du köra kommandot "restart" i kommandokonsolen för att läsa in konfigurationen. Kommandot "status" visar att skrivaren är klar om Klippers konfigurationsfil har lästs och mikrokontrollern har hittats och konfigurerats.

När du anpassar skrivarens konfigurationsfil är det inte ovanligt att Klipper rapporterar ett konfigurationsfel. Rätta vid behov filen och kör "restart" tills "status" visar att skrivaren är klar.

Klipper rapporterar felmeddelanden i kommandokonsolen och som popupfönster i Fluidd och Mainsail. Kommandot "status" kan användas för att visa felmeddelandena igen. En logg finns normalt på `~/printer_data/logs/klippy.log`.

När Klipper visar att skrivaren är klar går du vidare till [konfigurationskontrollen](Config_checks.md) för att utföra grundläggande kontroller av definitionerna i konfigurationsfilen. Mer information finns i huvudreferensen för [dokumentationen](Overview.md).
