# Objektumok kizárása

The `[exclude_object]` module allows Klipper to exclude objects while a print is in progress. To enable this feature include an [exclude_object config
section](Config_Reference.md#exclude_object) (also see the [command
reference](G-Codes.md#exclude-object) and [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.)

Más 3D nyomtatók firmware opcióitól eltérően a Klippert futtató nyomtató komponenscsomagot használ, és a felhasználók számos lehetőség közül választhatnak. Ezért az egységes felhasználói élmény biztosítása érdekében az `[exclude_object]` modul egyfajta szerződést vagy API-t hoz létre. A szerződés tartalmazza a G-kód fájl tartalmát, a modul belső állapotának vezérlését és azt, hogy ez az állapot hogyan kerül a kliensek rendelkezésre bocsátásra.

## Munkafolyamat áttekintése

Egy tipikus munkafolyamat egy fájl nyomtatásához így nézhet ki:

1. A szeletelés befejeződik, és a fájl feltöltésre kerül nyomtatásra. A feltöltés során a fájl feldolgozása megtörténik, és `[exclude_object]` jelölések kerülnek a fájlhoz. A szeletelőket úgy is be lehet állítani, hogy az objektumkizáró jelöléseket natívan vagy saját előfeldolgozási lépésben készítsék el.
1. A nyomtatás megkezdésekor a Klipper visszaállítja az `[exclude_object]` [státuszt](Status_Reference.md#exclude_object).
1. Amikor a Klipper feldolgozza az `EXCLUDE_OBJECT_DEFINE` blokkot, frissíti a státuszt az ismert objektumokkal, és továbbítja azt az ügyfeleknek.
1. Az ügyfél felhasználhatja ezeket az információkat arra, hogy egy felhasználói felületet jelenítsen meg a felhasználónak, hogy nyomon követhesse az előrehaladást. A Klipper frissíti az állapotot, hogy tartalmazza az aktuálisan nyomtatott objektumot, amelyet az ügyfél megjelenítési célokra használhat.
1. Ha a felhasználó egy objektum törlését kéri, a kliens egy `EXCLUDE_OBJECT NAME=<name>` parancsot ad a Klippernek.
1. Amikor a Klipper feldolgozza a parancsot, hozzáadja az objektumot a kizárt objektumok listájához, és frissíti állapotát az ügyfél felé.
1. Az ügyfél megkapja a Klipper frissített állapotát, és ezt az információt felhasználhatja az objektum állapotának megjelenítéséhez a felhasználói felületen.
1. A nyomtatás befejezésekor az `[exclude_object]` állapot továbbra is elérhető marad, amíg egy másik művelet vissza nem állítja.

## A G-kód fájl

Az objektumok kizárásához szükséges speciális G-kód feldolgozás nem illeszkedik a Klipper alapvető tervezési céljaihoz. Ezért ez a modul megköveteli a fájl feldolgozását, mielőtt a Klippernek nyomtatásra elküldi. A fájl Klipper számára történő előkészítésére két lehetőség egy utófeldolgozó szkript használata a szeletelőben, vagy a fájl feltöltéskor történő feldolgozása a middleware segítségével. Egy referencia utófeldolgozó szkript elérhető futtatható és python könyvtárként is, lásd [az objektum előfeldolgozó törlése](https://github.com/kageurufu/cancelobject-preprocessor).

### Objektum meghatározások

Az `EXCLUDE_OBJECT_DEFINE` parancsot arra használjuk, hogy a G-kód fájlban lévő minden egyes objektumról összefoglalót adjunk a nyomtatáshoz. A fájlban lévő objektumok összefoglalóját adja meg. Az objektumokat nem kell definiálni ahhoz, hogy más parancsok hivatkozhassanak rájuk. Ennek a parancsnak az elsődleges célja, hogy információt szolgáltasson a felhasználói felületnek anélkül, hogy a teljes G-kód fájlt elemeznie kellene.

Az objektumdefiníciókat elnevezik, hogy a felhasználók könnyen kiválaszthassák a kizárandó objektumot, és további metaadatokat is megadhatnak a grafikus törlésmegjelenítéshez. A jelenleg definiált metaadatok közé tartozik egy `CENTER` X,Y koordináta, valamint egy `POLYGON` X,Y pontok listája, amely az objektum minimális körvonalát ábrázolja. Ez lehet egy egyszerű határoló doboz, vagy egy bonyolult burkolat a nyomtatott objektumok részletesebb megjelenítéséhez. Különösen akkor, ha a G-kód fájlok több, egymást átfedő határoló régiókkal rendelkező alkatrészt tartalmaznak, a középpontok vizuálisan nehezen megkülönböztethetők. `POLYGONS` pontokból álló json-kompatibilis tömbnek kell lennie `[X,Y]` szóközök nélkül. A további paraméterek karakterláncokként kerülnek elmentésre az objektumdefinícióban, és állapotfrissítésekben lesznek megadva.

`EXCLUDE_OBJECT_DEFINE NAME=calibration_pyramid CENTER=50,50 POLYGON=[[40,40],[50,60],[60,40]]`

All available G-Code commands are documented in the [G-Code
Reference](./G-Codes.md#excludeobject)

## Állapotinformáció

The state of this module is provided to clients by the [exclude_object
status](Status_Reference.md#exclude_object).

Az állapot visszaáll, amikor:

- A Klipper firmware újraindul.
- A `[virtual_sdcard]` visszaállítása megtörtént. Figyelemre méltó, hogy ezt a Klipper a nyomtatás kezdetén visszaállítja.
- Amikor egy `EXCLUDE_OBJECT_DEFINE RESET=1` parancsot adunk ki.

A meghatározott objektumok listája az `exclude_object.objects` állapotmezőben jelenik meg. Egy jól definiált G-kód fájlban ez a fájl elején található `EXCLUDE_OBJECT_DEFINE` parancsokkal történik. Ez biztosítja a kliensek számára az objektumok nevét és koordinátáit, így a felhasználói felület kívánság szerint grafikusan is megjelenítheti az objektumokat.

A nyomtatás előrehaladtával az `exclude_object.current_object` állapotmező frissül, ahogy a Klipper feldolgozza az `EXCLUDE_OBJECT_START` és `EXCLUDE_OBJECT_END` parancsokat. A `current_object` mező akkor is be lesz állítva, ha az objektumot kizárták. Az `EXCLUDE_OBJECT_START` mezővel jelölt nem definiált objektumok hozzá lesznek adva az ismert objektumokhoz, hogy segítsék a felhasználói felületre való utalásukat, minden további metaadat nélkül.

Az `EXCLUDE_OBJECT` parancsok kiadásakor a kizárt objektumok listáját az `exclude_object.excluded_objects` tömb tartalmazza. Mivel a Klipper előre tekint, hogy feldolgozza a közelgő G-kódot, a parancs kiadása és az állapot frissítése között késés lehet.
