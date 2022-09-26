# Ferdeség korrekció

A szoftveralapú ferdeség korrekció segíthet a nem tökéletesen szögletes nyomtatóegységből eredő méretpontatlanságok feloldásában. Vedd figyelembe, hogy ha a nyomtatója jelentősen ferde, erősen ajánlott először mechanikai eszközökkel a nyomtatót a lehető legegyenletesebbre állítani, mielőtt a szoftveralapú korrekciót alkalmazná.

## Kalibrációs objektum nyomtatása

A ferdeség korrekciójának első lépése egy [kalibrációs objektum](https://www.thingiverse.com/thing:2563185/files) nyomtatása a korrigálni kívánt sík mentén. Létezik egy másik [kalibrációs objektum](https://www.thingiverse.com/thing:2972743) is, amely egy modell összes síkját tartalmazza. Az objektumot úgy kell tájolni, hogy az A sarok a sík origója felé legyen.

Győződjön meg róla, hogy a nyomtatás során nem alkalmaz ferdeségkorrekciót. Ezt úgy teheti meg, hogy vagy eltávolítja a `[skew_correction]` modult a printer.cfg fájlból, vagy kiad egy `SET_SKEW CLEAR=1` parancsot.

## Mérje meg

A `[skew_correcton]` modul minden egyes korrigálandó síkhoz 3 mérést igényel; az A saroktól a C sarokig terjedő hosszúságot, a B saroktól a D sarokig terjedő hosszúságot és az A saroktól a D sarokig terjedő hosszúságot. Az AD hosszmérésnél ne vedd figyelembe a sarkokon lévő síkokat, amelyeket néhány tesztobjektum mutat.

![skew_lengths](img/skew_lengths.png)

## Konfigurálja a ferdeséget

Győződjön meg róla, hogy a `[skew_correction]` szerepel a printer.cfg fájlban. Most már használhatod a `SET_SKEW` G-kódot a skew_correction beállításához. Például, ha az XY mentén mért hosszok a következők:

```
Length AC = 140.4
Length BD = 142.8
Length AD = 99.8
```

`SET_SKEW` az XY-sík ferdeségkorrekciójának beállítására használható.

```
SET_SKEW XY=140.4,142.8,99.8
```

Az XZ és YZ méréseket is hozzáadhatja a G-kódhoz:

```
SET_SKEW XY=140.4,142.8,99.8 XZ=141.6,141.4,99.8 YZ=142.4,140.5,99.5
```

A `[skew_correction]` modul a `[bed_mesh]` modulhoz hasonló módon támogatja a profilkezelést is. Miután a `SET_SKEW` G-kóddal beállította a ferdeséget, a `SKEW_PROFILE` G-kóddal elmentheti azt:

```
SKEW_PROFILE SAVE=my_skew_profile
```

A parancs után a rendszer felszólítja a `SAVE_CONFIG` G-kód kiadását a profil tartós tárolóba történő mentéséhez. Ha nincs `my_skew_profile` nevű profil, akkor egy új profil jön létre. Ha a megnevezett profil létezik, akkor azt felülírja.

Ha már van mentett profilja, betöltheti azt:

```
SKEW_PROFILE LOAD=my_skew_profile
```

Lehetőség van régi vagy elavult profilok eltávolítására is:

```
SKEW_PROFILE REMOVE=my_skew_profile
```

A profil eltávolítása után a rendszer felszólítja, hogy adjon ki egy `SAVE_CONFIG` parancsot, hogy a módosítás mentésre kerüljön.

## A korrekció ellenőrzése

A skew_correction beállítása után újra kinyomtathatja a kalibrációs részt a korrekció engedélyezésével. A következő G-kóddal ellenőrizheti a ferdeséget minden síkban. Az eredményeknek alacsonyabbaknak kell lenniük, mint a `GET_CURRENT_SKEW` segítségével jelentett eredmények.

```
CALC_MEASURED_SKEW AC=<ac_length> BD=<bd_length> AD=<ad_length>
```

## Óvintézkedések

A ferdeségkorrekció természetéből adódóan ajánlott a ferdeséget az indító G-kódban konfigurálni, a kezdőpont felvétel és minden olyan mozgás után, amely a nyomtatási terület széléhez közelít, mint például a tisztítás vagy a fúvóka törlése. Ehhez használhatod a `SET_SKEW` vagy a `SKEW_PROFILE` G-kódokat. Ajánlott továbbá a `SET_SKEW CLEAR=1` parancs kiadása a befejező G-kódban.

Ne feledd! Lehetséges, hogy a `[skew_correction]` olyan korrekciót generál, amely a fejet az X és/vagy Y tengelyen a nyomtató határain túlra helyezi. A `[skew_correction]` használatakor ajánlott a nyomtatófejet a szélektől távolabb elhelyezni.
