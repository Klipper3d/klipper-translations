# CANBUS

Det här dokumentet beskriver Klippers stöd för CAN-buss.

## Enhetshårdvara

Klipper har för närvarande stöd för CAN på chipen stm32, SAME5x och rp2040. Mikrokontrollerchipet måste dessutom sitta på ett kort med en CAN-transceiver.

Kör `make menuconfig` och välj ”CAN-buss” som kommunikationsgränssnitt för att kompilera för CAN. Kompilera sedan mikrokontrollerkoden och skriv den till målkortet.

## Värddatorns maskinvara

För att använda en CAN-buss krävs en värdadapter. Vi rekommenderar en ”USB-till-CAN-adapter”. Det finns många sådana adaptrar från olika tillverkare. Kontrollera vid valet att dess inbyggda programvara kan uppdateras. Vissa USB-adaptrar kör tyvärr felaktig inbyggd programvara och är låsta, så kontrollera detta före köp. Leta efter adaptrar som kan köra Klipper direkt i bryggläget ”USB till CAN-buss”, eller som kör [candlelight-programvaran](https://github.com/candle-usb/candleLight_fw).

Det är också nödvändigt att konfigurera värdoperativsystemet för att använda adaptern. Det görs vanligen genom att skapa en ny fil med namnet `/etc/network/interfaces.d/can0` med följande innehåll:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```

## Termineringsmotstånd

En CAN-buss ska ha två motstånd på 120 ohm mellan CANH- och CANL-ledningarna. Helst ska ett motstånd sitta i vardera änden av bussen.

Observera att vissa enheter har ett inbyggt motstånd på 120 ohm som inte är lätt att ta bort. Vissa enheter har inget motstånd alls. Andra enheter har en mekanism för att välja motstånd, vanligtvis genom att ansluta en bygel. Kontrollera kopplingsschemat för alla enheter på CAN-bussen så att bussen har exakt två motstånd på 120 ohm.

För att kontrollera att motstånden är korrekta kan du koppla bort strömmen till skrivaren och mäta resistansen mellan CANH- och CANL-ledningarna med en multimeter. En korrekt kopplad CAN-buss ska visa ungefär 60 ohm.

## Hitta canbus_uuid för nya mikrokontroller

Varje mikrokontroller på CAN-bussen tilldelas ett unikt ID baserat på den fabriksidentifierare för chipet som är inbyggd i varje mikrokontroller. Kontrollera att maskinvaran är strömsatt och korrekt ansluten och kör sedan följande kommando för att hitta varje mikrokontrollers enhets-ID:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Om oinitierade CAN-enheter identifieras visar kommandot ovan rader som följande:

```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

Varje enhet har en unik identifierare. I exemplet ovan är `11aa22bb33cc` mikrokontrollerns ”canbus_uuid”.

Observera att verktyget `canbus_query.py` endast visar oinitierade enheter. Om Klipper eller ett liknande verktyg konfigurerar enheten visas den inte längre i listan.

## Konfigurera Klipper

Uppdatera Klippers [MCU-konfiguration](Config_Reference.md#mcu) så att CAN-bussen används för kommunikationen med enheten, till exempel:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## Bryggläge för USB till CAN-buss

Vissa mikrokontroller kan välja läget ”USB-till-CAN-bussbrygga” i Klippers `make menuconfig`. I detta läge kan en mikrokontroller användas både som USB-till-CAN-bussadapter och som Klipper-nod.

När Klipper använder detta läge visas mikrokontrollern som en ”USB-CAN-bussadapter” i Linux. Själva Klipper-brygg-MCU:n visas som om den fanns på CAN-bussen. Den kan identifieras med `canbus_query.py` och måste konfigureras som andra Klipper-noder på CAN-bussen.

Några viktiga saker att tänka på när du använder detta läge:

* Det är nödvändigt att konfigurera gränssnittet `can0` eller liknande i Linux för att kommunicera med bussen. Klipper ignorerar dock för närvarande Linux inställningar för CAN-bussens hastighet och bittid. CAN-bussens frekvens anges i `make menuconfig` och den busshastighet som anges i Linux ignoreras.
* Varje gång brygg-MCU:n återställs inaktiverar Linux motsvarande `can0`-gränssnitt. För att säkerställa korrekt hantering av kommandona FIRMWARE_RESTART och RESTART rekommenderas `allow-hotplug` i filen `/etc/network/interfaces.d/can0`, till exempel:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```

* Brygg-MCU:n finns inte faktiskt på CAN-bussen. Meddelanden till och från brygg-MCU:n kan inte ses av andra adaptrar som kan finnas på CAN-bussen.
* Den tillgängliga bandbredden för både brygg-MCU:n och alla enheter på CAN-bussen begränsas i praktiken av CAN-bussens frekvens. Därför rekommenderas en CAN-bussfrekvens på 1000000 vid användning av bryggläget USB till CAN-buss.
* Det är endast giltigt att använda bryggläget USB till CAN-buss om det finns en fungerande CAN-buss med minst en annan tillgänglig nod, utöver själva bryggnoden. Använd en vanlig USB-konfiguration om avsikten endast är att kommunicera med den enda USB-enheten. Att använda bryggläget USB till CAN-buss utan en fullt fungerande CAN-buss, inklusive termineringsmotstånd och en ytterligare nod, kan orsaka sporadiska fel även vid kommunikation med bryggnoden.
* Ett USB-till-CAN-bryggkort visas inte som en seriell USB-enhet, det syns inte när `ls /dev/serial/by-id` körs och det kan inte konfigureras i Klippers printer.cfg-fil med parametern `serial:`. Bryggkortet visas som en ”USB-CAN-adapter” och konfigureras i printer.cfg som en [CAN-nod](#configuring-klipper).

## Tips för felsökning

Se dokumentet om [felsökning av CAN-buss](CANBUS_Troubleshooting.md).
