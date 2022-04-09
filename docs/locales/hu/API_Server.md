# API szerver

Ez a dokumentum leírja a Klipper Alkalmazás Programozói Interfészt (API). Ez az interfész lehetővé teszi külső alkalmazások számára a Klipper gazdaszoftver lekérdezését és vezérlését.

## Az API foglalat engedélyezése

Az API-kiszolgáló használatához a klippy.py host szoftvert a `-a` paraméterrel kell elindítani. Például:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

Ennek hatására a gazdaszoftver létrehoz egy Unix Domain Socketet. Az ügyfél ezután kapcsolatot nyithat ezen keresztül, és parancsokat küldhet a Klippernek.

## Kérelem formátuma

A socket-en küldött és fogadott üzenetek JSON kódolású karakterláncok, amelyeket egy ASCII 0x03 karakter zár le:

```
<json_object_1><0x03><json_object_2><0x03>...
```

A Klipper tartalmaz egy `scripts/whconsole.py` eszközt, amely képes a fenti üzenetkeretezést elvégezni. Például:

```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

Ez az eszköz képes beolvasni egy sor JSON parancsot az stdin-ből, elküldeni őket a Klippernek, és jelenteni az eredményeket. Az eszköz elvárja, hogy minden JSON parancs egyetlen sorban legyen, és a kérés elküldésekor automatikusan hozzáadja a 0x03 végrehajtót. (A Klipper API szervernek nincs újsor követelménye.)

## API Protokoll

A kommunikációs foglalat által használt parancsprotokollt a [json-rpc](https://www.jsonrpc.org/) ihlette.

Egy kérés így nézhet ki:

`{"id": 123, "method": "info", "params": {}}`

és a válasz így nézhet ki:

`{"id": 123, "result": {"state_message": "Printer is ready", "klipper_path": "/home/pi/klipper", "config_file": "/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6", "hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4 (v7l)", "state": "ready", "python_path": "/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}`

Minden egyes kérésnek egy JSON szótárnak kell lennie. (Ez a dokumentum a Pythonban a "szótár" kifejezést használja a "JSON objektum" - a `</x>{}`-ban található kulcs/érték párok leképezése, leírására.)

A kérési szótárnak tartalmaznia kell egy "method" paramétert, amely egy elérhető Klipper "végpont" húr neve.

A kérési szótár tartalmazhat egy "params" paramétert, amelynek szótár típusúnak kell lennie. A "params" további paraméterinformációkat biztosít a kérést kezelő Klipper "végpont" számára. Tartalma a "végpontra" jellemző.

A kérési szótár tartalmazhat egy "id" paramétert, amely bármilyen JSON típusú lehet. Ha az "id" paraméter jelen van, akkor a Klipper egy válaszüzenettel válaszol a kérésre, amely tartalmazza ezt az "id" paramétert. Ha az "id" nincs megadva (vagy egy JSON "null" értékre van beállítva), akkor a Klipper nem ad választ a kérésre. A válaszüzenet egy JSON szótár, amely tartalmazza az "id" és az "eredmény" értékeket. A "result" mindig egy szótár melynek tartalma a kérést kezelő "végpontra" jellemző.

Ha egy kérés feldolgozása hibát eredményez, akkor a válaszüzenet egy "hiba" mezőt fog tartalmazni az "eredmény" mező helyett. Például a kérés: `{"id": 123, "method": "gcode/script", "params": {"script": "G1 X200"}}}` egy olyan hibás választ eredményezhet, mint például: `{"id": 123, "error": {"message": "Must home axis first: 200.000 0.000 0.000 0.000 [0.000]", "error": "WebRequestError"}}`

A Klipper mindig a beérkezésük sorrendjében kezdi meg a kérések feldolgozását. Előfordulhat azonban, hogy egyes kérések nem fejeződnek be azonnal, ami azt eredményezheti, hogy a kapcsolódó válasz más kérések válaszaihoz képest nem a megfelelő sorrendben kerül elküldésre. Egy JSON-kérés soha nem fogja szüneteltetni a jövőbeli JSON-kérések feldolgozását.

## Feliratkozások

Néhány Klipper "végpont" kérés lehetővé teszi a "feliratkozást" a jövőbeli aszinkron frissítési üzenetekre.

Például:

`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{"key": 345}}}`

kezdetben válaszolhat:

`{"id": 123, "result": {}}`

és a Klipper a következőhöz hasonló üzeneteket fog küldeni a jövőben:

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

Az előfizetési kérés elfogad egy "response_template" szótárat a kérés "params" mezőjében. Ez a "response_template" szótár sablonként szolgál a jövőbeli aszinkron üzenetekhez. Tetszőleges kulcs/érték párokat tartalmazhat. Ezen jövőbeli aszinkron üzenetek küldésekor a Klipper hozzáad egy "params" mezőt, amely egy "endpoint" specifikus tartalmú szótárat tartalmaz a válaszsablonnak, majd elküldi ezt a sablont. Ha nem adunk meg egy "response_template" mezőt, akkor az alapértelmezés szerint egy üres szótár lesz (`{}`).

## Elérhető "végpontok"

A Klipper "végpontok" a konvenció szerint a `<module_name>/<some_name>` formájúak. Ha egy "végponthoz" intézünk kérést, a teljes nevet a kérési szótár "method" paraméterében kell megadni (pl. `{"method"="gcode/restart"}`).

### infó

Az "info" végpontot a Klipper rendszert és verzióinformációinak lekérdezésére használjuk. Arra is szolgál, hogy a kliens'verziót a Klipper számára megadja. Például: `{"id": 123, "method": "info", "params": { "client_info": { "version": "v1"}}}}`

Ha jelen van a "client_info" paraméter egy szótárnak kell lennie, de a szótár tetszőleges tartalmú lehet. A felhasználóknak ajánlott megadniuk az ügyfél nevét és a szoftver verzióját, amikor először csatlakoznak a Klipper API kiszolgálóhoz.

### emergency_stop

Az "emergency_stop" végpont arra szolgál, hogy utasítsa a Klippert a "shutdown" állapotba való átmenetre. Hasonlóan viselkedik, mint a G-kód `M112` parancs. Például: `{"id": 123, "method": "emergency_stop"}`

### register_remote_method

Ez a végpont lehetővé teszi az ügyfelek számára, hogy regisztrálják a klipperből hívható metódusokat. Siker esetén egy üres objektumot ad vissza.

Például: `{"id": 123, "method": "register_remote_method", "params": {"response_template": {"action": "run_paneldue_beep"}, "remote_method": "paneldue_beep"}}}` fog visszatérni: `{"id": 123, "result": {}}`

A távoli `paneldue_beep` metódus mostantól hívható a Klipperből. Vegyük figyelembe, hogy ha a metódus paramétereket vesz fel, akkor azokat kulcsszavas argumentumként kell megadni. Az alábbiakban egy példa látható arra, hogyan hívható meg egy gcode_macro-ból:

```
[gcode_macro PANELDUE_BEEP]
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

Amikor a PANELDUE_BEEP G-kód makró végrehajtódik, a Klipper valami ilyesmit küld a kapcsolaton keresztül: `{"action": "run_paneldue_beep", "params": {"frequency": 300, "duration": 1.0}}`

### objects/list

Ez a végpont lekérdezi az elérhető nyomtató objektumok listáját, amelyeket lekérdezhetünk (az "objects/query" végponton keresztül). Például: `{"id": 123, "method": "objects/list"}` visszatérhet: `{"id": 123, "result": {"objects": ["webhooks", "configfile", "heaters", "gcode_move", "query_endstops", "idle_timeout", "toolhead", "extruder"]}}`

### objects/query

Ez a végpont lehetővé teszi a nyomtató objektumokból származó információk lekérdezését. Például: `{"id": 123, "method": "objects/query", "params": {"objects": {"toolhead": ["position"], "webhooks": null}}}}` might return: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready", "state_message": "Printer is ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3051555.377933684}}`

A kérés "objects" paraméterének egy szótárnak kell lennie, amely a lekérdezendő nyomtató objektumokat tartalmazza. A kulcs a nyomtató objektum nevét tartalmazza, az érték pedig vagy "null" (az összes mező lekérdezése), vagy a mezőnevek listája.

A válaszüzenet tartalmaz egy "status" mezőt, amely egy szótárat tartalmaz a lekérdezett információkkal. A kulcs a nyomtató objektum nevét tartalmazza, az érték pedig a mezőit tartalmazó szótár. A válaszüzenet tartalmaz egy "eventtime" mezőt is, amely a lekérdezés időpontjának időbélyegét tartalmazza.

A rendelkezésre álló mezők a [Állapothivatkozás](Status_Reference.md) dokumentumban vannak dokumentálva.

### objects/subscribe

Ez a végpont lehetővé teszi a nyomtató objektumokból származó információk lekérdezését, majd előjegyzését. A végpont kérése és válasza megegyezik a "objects/query" végponttal. Például: `{"id": 123, "method": "objects/subscribe", "params": {"objects":{"toolhead": ["position"], "webhooks": ["state"]}, "response_template":{}}}` might return: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3052153.382083195}}` és az ezt követő aszinkron üzeneteket eredményez, mint például: `{"params": {"status": {"webhooks": {"state": "shutdown"}}, "eventtime": 3052165.418815847}}`

### gcode/help

Ez a végpont lehetővé teszi a rendelkezésre álló G-kód parancsok lekérdezését, amelyekhez súgószöveg van definiálva. Például: `{"id": 123, "method": "gcode/help"}` visszatérhet: `{"id": 123, "result": {"RESTORE_GCODE_STATE": "Egy korábban elmentett G-kód állapot visszaállítása", "PID_CALIBRATE": "PID kalibrációs teszt futtatása", "QUERY_ADC": "Egy analóg tű utolsó értékének jelentése", ...}}`

### gcode/script

Ez a végpont lehetővé teszi egy sor G-kód parancs futtatását. Például: `{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}}`

Ha a megadott G-kód szkript hibát okoz, akkor a rendszer hibaválaszt generál. Ha azonban a G-kód parancs terminál kimenetet eredményez, a terminál kimenete nem szerepel a válaszban. (A "gcode/subscribe_output" végpontot használja a G-kód terminálkimenethez.)

Ha a kérés beérkezésekor éppen egy G-kód parancsot dolgoznak fel, akkor a megadott szkript sorba kerül. Ez a késedelem jelentős lehet (pl. ha egy G-kódos hőmérsékleti várakozás parancs fut). A JSON válaszüzenet akkor kerül elküldésre, amikor a parancsfájl feldolgozása teljesen befejeződött.

### gcode/restart

Ez a végpont lehetővé teszi az újraindítás kérését, hasonlóan a G-kód "RESTART" parancs futtatásához. Például: `{"id": }`<x id="123, "method": "gcode/restart"}`

A "gcode/script" végponthoz hasonlóan ez a végpont is csak a függőben lévő G-kód parancsok befejezése után fejeződik be.

### gcode/firmware_restart

Ez hasonló a "gcode/restart" végponthoz. A G-kód "FIRMWARE_RESTART" parancsot valósítja meg. Például: `{"id": 123, "method": "gcode/firmware_restart"}`

A "gcode/script" végponthoz hasonlóan ez a végpont is csak a függőben lévő G-kód parancsok befejezése után fejeződik be.

### gcode/subscribe_output

Ez a végpont a Klipper által generált G-kódos terminálüzenetekre való feliratkozásra szolgál. Például: `{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{}}}}` később olyan aszinkron üzeneteket eredményezhet, mint például: `{"params": {"response": "// Klipper state: Shutdown"}}`

Ez a végpont az emberi interakciót hivatott támogatni egy "terminálablak" interfészen keresztül. A G-kód terminál kimenetéből származó tartalom elemzése nem javasolt. A Klipper'állapotának frissítéséhez használja az "objects/subscribe" végpontot.

### motion_report/dump_stepper

Ez a végpont a Klipper belső léptető queue_step parancsfolyamra való feliratkozásra szolgál egy léptető számára. Ezeknek az alacsony szintű mozgásfrissítéseknek a lekérése hasznos lehet diagnosztikai és hibakeresési célokra. Ennek a végpontnak a használata növelheti a Klipper rendszer terhelését.

Egy kérés így nézhet ki: `{"id": 123, "method":"motion_report/dump_stepper", "params": {"name": "stepper_x", "response_template": {}}}` és esetleg visszatér: `{"id": 123, "result": {"header": }}}`, és később aszinkron üzeneteket produkálhat, mint például: ["intervallum", "count", "add"]}}`: `{"params": {"first_clock": 179601081, "first_time": 8.98, "first_position": 0, "last_clock": 219686097, "last_time": 10.984, "data": [[179601081, 1, 0], [29573, 2, -8685], [16230, 4, -1525], [10559, 6, -160], [10000, 976, 0], [10000, 1000, 0], [10000, 1000, 0], [10000, 1000, 0], [10000, 1000, 0], [9855, 5, 187], [11632, 4, 1534], [20756, 2, 9442]]}}`

A kezdeti lekérdezési válasz "header" mezője a későbbi "data" válaszokban található mezők leírására szolgál.

### motion_report/dump_trapq

Ezt a végpontot a Klipper belső "trapézmozgás-várólistára" való feliratkozásra használják. Ezeknek az alacsony szintű mozgásfrissítéseknek a lekérése hasznos lehet diagnosztikai és hibakeresési célokra. Ennek a végpontnak a használata növelheti a Klipper rendszer terhelését.

Egy kérés így nézhet ki: `{"id": 123, "method": "motion_report/dump_trapq", "params": {"name": "toolhead", "response_template":{}}}` és esetleg visszatér: `{"id": 1, "result": {"header": ["time", "duration", "start_velocity", "acceleration", "start_position", "direction"]}}}` és később aszinkron üzeneteket produkálhat, mint például: `{"params": {"data": [[4.05, 1.0, 0.0, 0.0, 0.0, [300.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0]], [5.054, 0.001, 0.0, 3000.0, [300.0, 0.0, 0.0, 0.0], [-1.0, 0.0, 0.0, 0.0]]}}`

A kezdeti lekérdezési válasz "header" mezője a későbbi "data" válaszokban található mezők leírására szolgál.

### adxl345/dump_adxl345

Ez a végpont az ADXL345 gyorsulásmérő adataira való feliratkozásra szolgál. Ezeknek az alacsony szintű mozgásfrissítéseknek a lekérése hasznos lehet diagnosztikai és hibakeresési célokra. Ennek a végpontnak a használata növelheti a Klipper rendszer terhelését.

Egy kérés így nézhet ki: `{"id": 123, "method":"adxl345/dump_adxl345", "params": {"sensor": "adxl345", "response_template": {}}}` és esetleg visszatér: `{"id": 123,"result":{"header":["time","x_acceleration","y_acceleration", "z_acceleration"]}}}` és később olyan aszinkron üzeneteket produkálhat, mint például: `{"params":{"overflows":0,"data":[[3292.432935,-535.44309,-1529.8374,9561.4], [3292.433256,-382.45935,-1606.32927,9561.48375]]}}`

A kezdeti lekérdezési válasz "header" mezője a későbbi "data" válaszokban található mezők leírására szolgál.

### angle/dump_angle

This endpoint is used to subscribe to [angle sensor data](Config_Reference.md#angle). Obtaining these low-level motion updates may be useful for diagnostic and debugging purposes. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method":"angle/dump_angle", "params": {"sensor": "my_angle_sensor", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["time","angle"]}}` and might later produce asynchronous messages such as: `{"params":{"position_offset":3.151562,"errors":0, "data":[[1290.951905,-5063],[1290.952321,-5065]]}}`

A kezdeti lekérdezési válasz "header" mezője a későbbi "data" válaszokban található mezők leírására szolgál.

### pause_resume/cancel

Ez a végpont hasonló a "PRINT_CANCEL" G-kód parancs futtatásához. Például: `{"id": }`

A "gcode/script" végponthoz hasonlóan ez a végpont is csak a függőben lévő G-kód parancsok befejezése után fejeződik be.

### pause_resume/pause

Ez a végpont hasonló a "PAUSE" G-kód parancs futtatásához. Például: `{"id": }`

A "gcode/script" végponthoz hasonlóan ez a végpont is csak a függőben lévő G-kód parancsok befejezése után fejeződik be.

### pause_resume/resume

Ez a végpont hasonló a "RESUME" G-kód parancs futtatásához. Például: `{"id": }`

A "gcode/script" végponthoz hasonlóan ez a végpont is csak a függőben lévő G-kód parancsok befejezése után fejeződik be.

### query_endstops/status

Ez a végpont lekérdezi az aktív végpontokat és visszaadja azok állapotát. Például: `{"id": 123, "method": "query_endstops/status"}` visszatérhet: `{"id": 123, "result": {"y": "open", "x": "open", "z": "TRIGGERED"}}`

A "gcode/script" végponthoz hasonlóan ez a végpont is csak a függőben lévő G-kód parancsok befejezése után fejeződik be.
