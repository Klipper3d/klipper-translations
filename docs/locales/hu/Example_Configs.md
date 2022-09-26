# Példa konfigurációk

Ez a dokumentum a Klipper github tárhoz (a [config könyvtárban](../config/) található) egy Klipper példakonfigurációhoz való hozzájáruláshoz tartalmaz útmutatást.

Ne feledd, hogy a [Klipper Community Discourse szerver](https://community.klipper3d.org) szintén hasznos forrás a konfigurációs fájlok kereséséhez és megosztásához.

## Irányelvek

1. Válassza ki a megfelelő konfigurációs fájlnév előtagot:
   1. A `printer` előtagot az általános gyártó által értékesített nyomtatókra használják.
   1. Az `általános` előtagot olyan 3D nyomtató alaplapra használják, amely számos különböző típusú nyomtatóban használható.
   1. A `kit` előtag olyan 3D nyomtatókra vonatkozik, amelyeket egy széles körben használt specifikáció szerint állítanak össze. Ezek a "kit" nyomtatók általában abban különböznek a normál "nyomtatóktól", hogy nem egy gyártó értékesíti őket.
   1. A `sample` előtagot a konfigurációs "snippetek" számára használjuk, amelyeket másolva beilleszthetünk a fő konfigurációs fájlba.
   1. A `példa` előtag a nyomtató kinematikájának leírására szolgál. Az ilyen típusú konfiguráció jellemzően csak a nyomtató kinematikájának új típusához tartozó kóddal együtt kerül hozzáadásra.
1. Minden konfigurációs fájlnak `.cfg` végződéssel kell végződnie. A `printer` konfigurációs fájloknak egy évszámmal kell végződniük, amelyet a `.cfg` végződés követ (pl. `-2019.cfg`). Ebben az esetben az évszám az adott nyomtató eladásának hozzávetőleges éve.
1. Ne használjon szóközöket vagy speciális karaktereket a konfigurációs fájlnévben. A fájlnév csak a `A-Z`, `a-z`, `0-9`, `-` és ` karaktereket tartalmazhatja.`.
1. A Klippernek hiba nélkül el kell tudnia indítani a `printer`, `generic` és `kit` példa konfigurációs fájlt. Ezeket a konfigurációs fájlokat hozzá kell adni a [test/klippy/printers.test](../test/klippy/printers.test) regressziós tesztesethez. Add hozzá az új konfigurációs fájlokat ehhez a tesztesethez a megfelelő szakaszban és a szakaszon belül ábécé sorrendben.
1. A példakonfigurációnak a nyomtató "stock" konfigurációjára kell vonatkoznia. (Túl sok "testreszabott" konfiguráció van ahhoz, hogy a Klipper fő tárolójában nyomon lehessen követni.) Hasonlóképpen, csak olyan nyomtatók, készletek és kártyák példakonfigurációs fájljait adjuk hozzá, amelyek népszerűek (pl. legalább 100 darabnak kell lennie belőlük aktív használatban). Fontolja meg a [Klipper Community Discourse szerver](https://community.klipper3d.org) használatát más konfigurációkhoz.
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. Ne add meg a `pressure_advance` értéket egy példakonfigurációban, mivel ez az érték a szálra, nem pedig a nyomtató hardverére jellemző. Hasonlóképpen ne adjon meg `max_extrude_only_velocity` és `max_extrude_only_accel` beállításokat.
   1. Ne adjon meg olyan konfigurációs részt, amely állomás elérési útvonalat vagy állomáshardvert tartalmaz. Például ne adjon meg `[virtual_sdcard]` és `[temperature_host]` konfigurációs szakaszokat.
   1. Csak olyan makrókat definiáljon, amelyek az adott nyomtatóra jellemző funkciókat használják, vagy olyan g-kódokat definiáljon, amelyeket az adott nyomtatóhoz konfigurált szeletelők általában kiadnak.
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. Ne másold be a mező dokumentációját a példakonfigurációs fájlokba. (Ez karbantartási terhet jelent, mivel a dokumentáció frissítése sok helyen változtatást igényelne.)
   1. A példa konfigurációs fájlok nem tartalmazhatnak "SAVE_CONFIG" részt. Ha szükséges, másold át a SAVE_CONFIG szakaszból a megfelelő mezőket a fő konfigurációs terület megfelelő szakaszába.
   1. Használja a `field: value` szintaxist a `field=value` helyett.
   1. Extruder `rotation_distance` hozzáadásakor célszerű megadni a `gear_ratio` értéket, ha az extruder fogaskerékkel rendelkezik. A példakonfigurációkban szereplő rotation_distance értéktől azt várjuk, hogy korreláljon az extruderben lévő fogaskerék kerületével. Ez általában 20 és 35 mm közötti tartományban van. A `gear_ratio` megadásakor előnyösebb a mechanizmuson lévő tényleges fogaskerekek fogszámának megadása (pl. inkább `gear_ratio: 80:20`, mint `gear_ratio: 4:1`). További információkért lásd a [forgatási távolság dokumentumot](Rotation_Distance.md#using-a-gear_ratio).
   1. Kerülje az alapértelmezett értékre beállított mezőértékek meghatározását. Például nem szabad megadni `min_extrude_temp: 170`, mivel ez már az alapértelmezett érték.
   1. Ahol lehetséges, a sorok száma nem haladhatja meg a 80 oszlopot.
   1. Kerülje el az attribúciós vagy revíziós üzenetek hozzáadását a konfigurációs fájlokhoz. (Például kerülje az olyan sorok hozzáadását, mint a "this file was created by ..."). Helyezze el az attribúciót és a változtatási előzményeket a git commit üzenetben.
1. Ne használjon semmilyen elavult funkciót a példakonfigurációs fájlban.
1. Ne tiltson le egy alapértelmezett biztonsági rendszert egy példakonfig-fájlban. Például egy konfiguráció nem adhat meg egy egyéni `max_extrude_cross_section` értéket. Ne engedélyezze a hibakeresési funkciókat. Például ne legyen `force_move` config szakasz.
1. A Klipper által támogatott összes ismert kártya az alapértelmezett 250000-es soros adatátvitelt tudja használni. Ne javasoljon eltérő adatátvitel beállítását egy példa konfigurációs fájlban.

A példa konfigurációs fájlok elküldése egy github "pull request" létrehozásával történik. Kérjük, kövesse a [közreműködő dokumentum](CONTRIBUTING.md) utasításait is.
