# OctoPrint för Klipper

Klipper har flera alternativ för gränssnitt. OctoPrint var Klippers första och ursprungliga gränssnitt. Det här dokumentet ger en kort översikt över installation med detta alternativ.

## Installera med OctoPi

Börja med att installera [OctoPi](https://github.com/guysoft/OctoPi) på Raspberry Pi-datorn. Använd OctoPi v0.17.0 eller senare; se [OctoPi-utgåvorna](https://github.com/guysoft/OctoPi/releases) för versionsinformation.

Kontrollera att OctoPi startar och att OctoPrints webbserver fungerar. Efter anslutning till OctoPrints webbsida följer du uppmaningen att uppgradera OctoPrint vid behov.

Efter installation av OctoPi och uppgradering av OctoPrint måste du ansluta via SSH till måldatorn för att köra några systemkommandon.

Börja med att köra följande kommandon på värdenheten:

**Om git inte är installerat installerar du det med:**

```
sudo apt install git
```

fortsätt sedan:

```
cd ~
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

Kommandona ovan hämtar Klipper, installerar nödvändiga systemberoenden, konfigurerar Klipper att köras vid systemstart och startar Klippers värdprogramvara. Internetanslutning krävs och åtgärden kan ta några minuter.

## Installera med KIAUH

KIAUH kan användas för att installera OctoPrint på flera Debian-baserade Linux-system. Mer information finns på https://github.com/dw-0/kiauh

## Konfigurera OctoPrint för Klipper

OctoPrints webbserver måste konfigureras för att kommunicera med Klippers värdprogramvara. Logga in på OctoPrints webbsida i en webbläsare och konfigurera sedan följande:

Gå till fliken "Settings" (skiftnyckelikonen längst upp på sidan). Lägg till följande under "Serial Connection" i "Additional serial ports":

```
~/printer_data/comms/klippy.serial
```

Klicka sedan på "Save".

*I vissa äldre installationer kan adressen vara `/tmp/printer`.*

Gå till fliken "Settings" igen och ändra inställningen "Serial Port" under "Serial Connection" till den port som lades till ovan.

Gå till underfliken "Behavior" på fliken "Settings" och välj alternativet "Cancel any ongoing prints but stay connected to the printer". Klicka på "Save".

Kontrollera på huvudsidan, under avsnittet "Connection" längst upp till vänster, att "Serial Port" är inställd på den nya tillagda porten och klicka på "Connect". Om den inte finns i urvalet laddar du om sidan.

När anslutningen har upprättats går du till fliken "Terminal", skriver "status" utan citattecken i kommandofältet och klickar på "Send". Terminalfönstret rapporterar sannolikt ett fel när konfigurationsfilen öppnas; det betyder att OctoPrint kommunicerar korrekt med Klipper.

Fortsätt till <Installation.md> och avsnittet *Bygga och flasha mikrokontrollern*
