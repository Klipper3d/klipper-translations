# Több mikrovezélős kezdőpnt és szondázás

A Klipper támogatja a kezdőpont mechanizmusát egy végállással, amely egy mikrokontrollerhez van csatlakoztatva, míg a léptetőmotorok egy másik mikrokontrollerhez vannak csatlakoztatva. Ezt a támogatást nevezik "multi-mcu homing" -nak. Ez a funkció akkor is használatos, ha a Z-érzékelő más mikrokontrollerre van kötve, mint a Z léptetőmotorok.

Ez a funkció hasznos lehet a vezetékezés egyszerűsítése érdekében, mivel kényelmesebb lehet egy végálláskapcsolót vagy szondát egy közelebbi mikrokontrollerhez csatlakoztatni. Ennek a funkciónak a használata azonban a léptetőmotorok "túllendülését" eredményezheti a kezdőpont és a szondázási műveletek során.

A túllövés a végállást figyelő mikrovezérlő és a léptetőmotorokat mozgató mikrovezérlők közötti esetleges üzenetátviteli késések miatt következik be. A Klipper kódot úgy tervezték, hogy ezt a késleltetést legfeljebb 25 ms-ra korlátozza. (Ha a multi-mcu homing aktiválva van, a mikrovezérlők időszakos állapotüzeneteket küldenek, és ellenőrzik, hogy a megfelelő állapotüzenetek 25 ms-on belül érkeznek-e meg.)

Így például, ha 10 mm/s sebességgel történik a kezdőpont felvétele, akkor akár 0,250 mm-es túllövés is lehetséges (10 mm/s * .025s == 0,250 mm). A multi-mcu homing konfigurálásakor gondosan kell eljárni, hogy az ilyen típusú túllövést figyelembe vegyük. Lassabb kezdőpont fevétel vagy tapintási sebességek használata csökkentheti a túlcsúszást.

A léptetőmotor túllendülése nem befolyásolhatja hátrányosan az alaphelyzetbe állítási és tapintási eljárás pontosságát. A Klipper kód észleli a túllendülést, és számításai során figyelembe veszi azt. Fontos azonban, hogy a hardvertervezés képes legyen kezelni a túllendülést anélkül, hogy a gépben kárt okozna.

Ha a Klipper kommunikációs problémát észlel a mikrovezérlők között a multi-mcu homing során, akkor egy "Kommunikációs időkiesés a kezdőpont felvétel során" hibát jelez.

Vegye figyelembe, hogy a több stepperrel rendelkező tengelyeknek (pl. `stepper_z` és `stepper_z1`) ugyanazon a mikrokontrolleren kell lenniük a multi-mcu homing használatához. Például, ha egy végállás a `stepper_z` mikrokontrollertől külön mikrokontrolleren van, akkor a `stepper_z1`-nek ugyanazon a mikrokontrolleren kell lennie, mint a `stepper_z`.
