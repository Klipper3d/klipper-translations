# CANBUS protokoll

Ez a dokumentum a Klipper által a [CAN-buszon](https://hu.wikipedia.org/wiki/CAN-busz) keresztül történő kommunikációhoz használt protokollt írja le. A Klipper CAN-busszal való konfigurálásával kapcsolatos információkért lásd a <CANBUS.md> című dokumentumot.

## Mikrokontroller azonosító hozzárendelése

A Klipper csak a CAN 2.0A szabványos méretű CAN-busz csomagokat használja, amelyek 8 adatbájtra és egy 11 bites CAN-busz azonosítóra korlátozódnak. A hatékony kommunikáció támogatása érdekében minden mikrokontrollerhez futáskor egy egyedi, 1 bájtos CAN-busz nodeid (`canbus_nodeid`) van rendelve az általános Klipper parancs és válaszforgalomhoz. A gazdagépről a mikrokontroller felé irányuló Klipper-parancsüzenetek a `canbus_nodeid * 2 + 256` CAN-busz azonosítót használják, míg a mikrokontrollerről a gazdagép felé irányuló Klipper-válaszüzenetek a `canbus_nodeid * 2 + 256 + 1` azonosítót.

Minden mikrokontroller rendelkezik egy gyárilag hozzárendelt egyedi chipazonosítóval, amelyet az azonosító hozzárendelése során használnak. Ez az azonosító meghaladhatja egy CAN csomag hosszát, ezért egy hash függvényt használunk arra, hogy a gyári azonosítóból egy egyedi 6 bájtos azonosítót (`canbus_uuid`) generáljunk.

## Rendszergazdai üzenetek

Az rendszergazdai üzeneteket az azonosító hozzárendeléséhez használják. A gazdatesttől a mikrokontrollerhez küldött admin üzenetek a CAN-buszon a `0x3f0`, a mikrokontrollerről a gazdatesthez küldött üzenetek pedig a CAN-buszon a `0x3f1` azonosítót használják. Minden mikrovezérlő a `0x3f0` azonosítón fogadja az üzeneteket; ez az azonosító egy "broadcast cím" -nek tekinthető.

### CMD_QUERY_UNASSIGNED üzenet

Ez a parancs lekérdezi az összes olyan mikrovezérlőt, amely még nem kapott `canbus_nodeid` azonosítót. A nem hozzárendelt mikrovezérlők RESP_NEED_NODEID válaszüzenettel válaszolnak.

A CMD_QUERY_UNASSIGNED üzenet formátuma: `<1-byte message_id = 0x00>`

### CMD_SET_KLIPPER_NODEID üzenet

Ez a parancs hozzárendel egy `canbus_nodeid` mikrokontrollert egy adott `canbus_uuid` mikrokontrollerhez.

A CMD_SET_KLIPPER_NODEID üzenet formátuma: `<1-byte message_id = 0x01><6-byte canbus_uuid><1-byte canbus_nodeid>.`

### RESP_NEED_NODEID üzenet

A RESP_NEED_NODEID üzenet formátuma: `<1-byte message_id = 0x20><6-byte canbus_uuid><1-byte set_klipper_nodeid = 0x01>.`

## Adatcsomagok

A CMD_SET_KLIPPER_NODEID paranccsal nodeid-ot kapott mikrokontroller adatcsomagokat küldhet és fogadhat.

A csomópontot használó üzenetek csomagadatai (`canbus_nodeid * 2 + 256`) egyszerűen egy pufferbe kerülnek, és amikor egy teljes [mcu protokoll üzenet](Protocol.md) található, annak tartalmát elemezzük és feldolgozzuk. Az adatokat bájtfolyamként kezelik. Nem követelmény, hogy a Klipper üzenetblokk kezdete egyezzen a CAN-buszcsomag kezdetével.

Hasonlóképpen, az MCU protokoll üzenetválaszok a mikrokontrollerről a gazdagéphez úgy kerülnek elküldésre, hogy az üzenetadatokat egy vagy több csomagba másolják a csomópontnak a CAN-buszon való átvitelére vonatkozó azonosítójával (`canbus_nodeid * 2 + 256 + 1`).
