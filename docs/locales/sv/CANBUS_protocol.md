# CAN-busprotokoll

Detta dokument beskriver protokollet som Klipper använder för kommunikation via [CAN-bus](https://en.wikipedia.org/wiki/CAN_bus). Information om hur Klipper konfigureras med CAN-bus finns i <CANBUS.md>.

## Tilldelning av mikrokontroller-id

Klipper använder endast CAN-buspaket av standardstorleken CAN 2.0A, som är begränsade till 8 databyte och en 11-bitars CAN-busidentifierare. För effektiv kommunikation tilldelas varje mikrokontroller vid körning ett unikt 1-bytes CAN-busnod-id (`canbus_nodeid`) för Klipper-kommandon och svar. Kommandon från värden till mikrokontrollern använder CAN-bus-id:t `canbus_nodeid * 2 + 256`, medan svar från mikrokontrollern till värden använder `canbus_nodeid * 2 + 256 + 1`.

Varje mikrokontroller har en unik, fabriksinställd chipidentifierare som används vid id-tilldelning. Identifieraren kan vara längre än ett CAN-paket, så en hashfunktion används för att skapa ett unikt id på 6 byte (`canbus_uuid`) från fabriks-id:t.

## Administrativa meddelanden

Administrativa meddelanden används för id-tilldelning. Meddelanden från värden till mikrokontrollern använder CAN-bus-id:t `0x3f0`, och meddelanden från mikrokontrollern till värden använder CAN-bus-id:t `0x3f1`. Alla mikrokontrollers lyssnar på id:t `0x3f0`; det kan betraktas som en "broadcast-adress".

### Meddelandet CMD_QUERY_UNASSIGNED

Detta kommando frågar alla mikrokontrollers som ännu inte har tilldelats ett `canbus_nodeid`. Mikrokontrollers utan tilldelning svarar med svarsmeddelandet RESP_NEED_NODEID.

Formatet för CMD_QUERY_UNASSIGNED är: `<1-byte message_id = 0x00>`

### Meddelandet CMD_SET_KLIPPER_NODEID

Detta kommando tilldelar `canbus_nodeid` till mikrokontrollern med angivet `canbus_uuid`.

Formatet för CMD_SET_KLIPPER_NODEID är: `<1-byte message_id = 0x01><6-byte canbus_uuid><1-byte canbus_nodeid>`

### Meddelandet RESP_NEED_NODEID

Formatet för RESP_NEED_NODEID är: `<1-byte message_id = 0x20><6-byte canbus_uuid><1-byte set_klipper_nodeid = 0x01>`

## Datapaket

En mikrokontroller som har tilldelats ett nodeid med kommandot CMD_SET_KLIPPER_NODEID kan skicka och ta emot datapaket.

Paketdata i meddelanden som använder nodens mottagande CAN-bus-id (`canbus_nodeid * 2 + 256`) läggs helt enkelt till i en buffert. När ett fullständigt [mcu-protokollmeddelande](Protocol.md) hittas tolkas och behandlas innehållet. Datan behandlas som en byteström; början av ett Klipper-meddelandeblock behöver inte sammanfalla med början av ett CAN-buspaket.

På motsvarande sätt skickas svar på mcu-protokollmeddelanden från mikrokontrollern till värden genom att meddelandedatan kopieras till ett eller flera paket med nodens sändande CAN-bus-id (`canbus_nodeid * 2 + 256 + 1`).
