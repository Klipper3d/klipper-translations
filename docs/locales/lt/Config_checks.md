# Konfigūracijos patikrinimai

Šiame dokumente pateikiamas veiksmų sąrašas, padedantis patvirtinti kaiščių nustatymus Klipper printer.cfg faile. Rekomenduojama atlikti šiuos veiksmus atlikus veiksmus, nurodytus [diegimo dokumente](Installation.md).

Šio vadovo metu gali prireikti atlikti pakeitimus Klipper konfigūracijos faile. Būtinai išleiskite komandą RESTART po kiekvieno konfigūracijos failo pakeitimo, kad pakeitimas įsigaliotų (įveskite "restart" Octoprint terminalo skirtuke ir tada spustelėkite "Siųsti"). Taip pat patartina išleisti STATUS komandą po kiekvieno RESTART, kad būtų patikrinta, ar konfigūracijos failas sėkmingai įkeltas.

## Patikrinkite temperatūrą

Pradėkite patikrindami, ar temperatūros tinkamai pranešamos. Eikite į temperatūros grafiko skyrių vartotojo sąsajoje. Patikrinkite, ar antgalio ir platformos (jei taikoma) temperatūra yra rodoma ir nedidėja. Jei ji didėja, atjunkite maitinimą nuo spausdintuvo. Jei temperatūros nėra tikslios, peržiūrėkite "sensor_type" ir "sensor_pin" nustatymus antgaliui ir (arba) platformai.

## Patikrinkite M112

Eikite į komandų konsolę ir įveskite M112 komandą terminalo lange. Ši komanda prašo Klipper pereiti į "išjungimo" būseną. Tai sukels klaidą, kurią galima išvalyti naudojant FIRMWARE_RESTART komandą komandų konsolėje. Octoprint taip pat reikės iš naujo prisijungti. Tada eikite į temperatūros grafiko skyrių ir patikrinkite, ar temperatūros toliau atnaujinamos ir temperatūros nedidėja. Jei temperatūros didėja, atjunkite maitinimą nuo spausdintuvo.

## Patikrinkite šildytuvus

Eikite į temperatūros grafiko skyrių ir įveskite 50, po to spauskite enter ekstruzerio/įrankio temperatūros langelyje. Ekstruzerio temperatūra grafike turėtų pradėti didėti (per maždaug 30 sekundžių ar panašiai). Tada eikite į ekstruzerio temperatūros išskleidžiamąjį laukelį ir pasirinkite "Išjungta". Po kelių minučių temperatūra turėtų pradėti grįžti į pradinę kambario temperatūros vertę. Jei temperatūra nedidėja, patikrinkite "heater_pin" nustatymą konfigūracijoje.

Jei spausdintuvas turi šildomą platformą, atlikite aukščiau nurodytą testą dar kartą su platforma.

## Patikrinkite žingsninio variklio įjungimo kaištį

Patikrinkite, ar visos spausdintuvo ašys gali laisvai judėti rankiniu būdu (žingsniniai varikliai yra išjungti). Jei ne, išleiskite M84 komandą, kad išjungtumėte variklius. Jei kuri nors iš ašių vis tiek negali laisvai judėti, patikrinkite žingsninio variklio "enable_pin" konfigūraciją tai ašiai. Daugelyje įprastų žingsninių variklių valdiklių variklio įjungimo kaištis yra "aktyvus žemas", todėl įjungimo kaištis turėtų turėti "!" prieš kaiščio numerį (pavyzdžiui, "enable_pin: !PA1").

## Patikrinkite galinius jungiklius

Rankiniu būdu pajudinkite visas spausdintuvo ašis taip, kad nė viena iš jų nebūtų kontakte su galiniu jungikliu. Išsiųskite QUERY_ENDSTOPS komandą per komandų konsolę. Ji turėtų atsakyti su visų sukonfigūruotų galinių jungiklių esama būsena ir jie visi turėtų pranešti apie "atvirą" būseną. Kiekvienam iš galinių jungiklių pakartokite QUERY_ENDSTOPS komandą, rankiniu būdu aktyvuodami galinį jungiklį. QUERY_ENDSTOPS komanda turėtų pranešti apie galinį jungiklį kaip "SUVEIKĘS".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!PA2"), or remove the "!" if there is already one present.

Jei galinis jungiklis visai nesikeičia, tai paprastai rodo, kad galinis jungiklis yra prijungtas prie kito kaiščio. Tačiau taip pat gali prireikti pakeisti kaiščio ištraukimo nustatymą ('^' ženklas endstop_pin pavadinimo pradžioje - dauguma spausdintuvų naudos ištraukimo rezistorių ir '^' turėtų būti).

## Patikrinkite žingsninius variklius

Naudokite STEPPER_BUZZ komandą, kad patikrintumėte kiekvieno žingsninio variklio jungiamumą. Pradėkite rankiniu būdu nustatydami duotą ašį į vidurinį tašką ir tada paleiskite `STEPPER_BUZZ STEPPER=stepper_x` komandų konsolėje. STEPPER_BUZZ komanda privers duotą žingsninį variklį judėti vieną milimetrą teigiama kryptimi, o tada jis grįš į pradinę padėtį. (Jei galinis jungiklis apibrėžtas position_endstop=0, tai kiekvieno judėjimo pradžioje žingsninis variklis judės tolyn nuo galinio jungiklio.) Jis atliks šį svyravimą dešimt kartų.

Jei žingsninis variklis visai nejuda, patikrinkite "enable_pin" ir "step_pin" nustatymus žingsniniam varikliui. Jei žingsninis variklis juda, bet negrįžta į pradinę padėtį, patikrinkite "dir_pin" nustatymą. Jei žingsninis variklis svyruoja neteisinga kryptimi, tai paprastai rodo, kad ašies "dir_pin" reikia invertuoti. Tai daroma pridedant '!' prie "dir_pin" spausdintuvo konfigūracijos faile (arba pašalinant jį, jei jis jau yra). Jei variklis juda žymiai daugiau arba žymiai mažiau nei vieną milimetrą, patikrinkite "rotation_distance" nustatymą.

Atlikite aukščiau nurodytą testą kiekvienam žingsniniam varikliui, apibrėžtam konfigūracijos faile. (Nustatykite STEPPER_BUZZ komandos STEPPER parametrą į konfigūracijos skyriaus, kurį reikia patikrinti, pavadinimą.) Jei ekstruzeryje nėra gijos, galima naudoti STEPPER_BUZZ, kad būtų patikrintas ekstruzerio variklio jungiamumas (naudokite STEPPER=extruder). Priešingu atveju geriausia patikrinti ekstruzerio variklį atskirai (žr. kitą skyrių).

Patikrinus visus galinius jungiklius ir patikrinus visus žingsninius variklius, reikėtų patikrinti pradinės padėties mechanizmą. Išleiskite G28 komandą, kad nustatytumėte visų ašių pradinę padėtį. Atjunkite maitinimą nuo spausdintuvo, jei jis tinkamai negrįžta į pradinę padėtį. Jei reikia, pakartokite galinių jungiklių ir žingsninių variklių patikrinimo veiksmus.

## Patikrinkite ekstruzerio variklį

Norint išbandyti ekstruzerio variklį, reikės įkaitinti ekstruzerį iki spausdinimo temperatūros. Eikite į temperatūros grafiko skyrių ir pasirinkite tikslinę temperatūrą iš temperatūros išskleidžiamojo laukelio (arba rankiniu būdu įveskite tinkamą temperatūrą). Palaukite, kol spausdintuvas pasieks norimą temperatūrą. Tada eikite į komandų konsolę ir spustelėkite mygtuką "Ekstruduoti". Patikrinkite, ar ekstruzerio variklis sukasi teisinga kryptimi. Jei ne, žr. trikčių šalinimo patarimus ankstesniame skyriuje, kad patvirtintumėte "enable_pin", "step_pin" ir "dir_pin" nustatymus ekstruzeriui.

## Kalibruokite PID nustatymus

Klipper palaiko [PID valdymą](https://en.wikipedia.org/wiki/PID_controller) ekstruzerio ir platformos šildytuvams. Norint naudoti šį valdymo mechanizmą, būtina kalibruoti PID nustatymus kiekvienam spausdintuvui (PID nustatymai, rasti kitose programinėse įrangose arba pavyzdiniuose konfigūracijos failuose, dažnai veikia prastai).

Norėdami kalibruoti ekstruzerį, eikite į komandų konsolę ir paleiskite PID_CALIBRATE komandą. Pavyzdžiui: `PID_CALIBRATE HEATER=extruder TARGET=170`

Baigus derinimo testą, paleiskite `SAVE_CONFIG`, kad atnaujintumėte printer.cfg failą su naujais PID nustatymais.

Jei spausdintuvas turi šildomą platformą ir ji palaiko PWM (impulso pločio moduliaciją) valdymą, rekomenduojama naudoti PID valdymą platformai. (Kai platformos šildytuvas valdomas naudojant PID algoritmą, jis gali įsijungti ir išsijungti dešimt kartų per sekundę, o tai gali netikti šildytuvams, naudojantiems mechaninį jungiklį.) Tipinė platformos PID kalibravimo komanda yra: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Kiti žingsniai

Šis vadovas skirtas padėti atlikti pagrindinį kaiščių nustatymų patikrinimą Klipper konfigūracijos faile. Būtinai perskaitykite [platformos lyginimo](Bed_Level.md) vadovą. Taip pat žiūrėkite [Pjaustytuvai](Slicers.md) dokumentą, kuriame pateikiama informacija apie pjaustytuvo konfigūravimą su Klipper.

Patikrinus, kad pagrindinis spausdinimas veikia, rekomenduojama apsvarstyti [slėgio išankstinio](Pressure_Advance.md) kalibravimą.

Gali prireikti atlikti kitų tipų išsamų spausdintuvo kalibravimą - internete yra daug vadovų, padedančių tai atlikti (pavyzdžiui, atlikite internetinę paiešką "3d spausdintuvo kalibravimas"). Pavyzdžiui, jei pastebite efektą, vadinamą skambesiu, galite pabandyti vadovautis [rezonanso kompensavimo](Resonance_Compensation.md) derinimo vadovu.
