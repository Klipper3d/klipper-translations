# Viacnásobné mikrokontrolérové navádzanie a snímanie

Klipper podporuje mechanizmus pre navigáciu do pôvodného bodu s koncovým dorazom pripojeným k jednému mikrokontroléru, zatiaľ čo jeho krokové motory sú na inom mikrokontroléri. Táto podpora sa označuje ako „navigácia do pôvodného bodu s viacerými mikrokontrolérmi“. Táto funkcia sa používa aj vtedy, keď je sonda Z na inom mikrokontroléri ako krokové motory Z.

Táto funkcia môže byť užitočná na zjednodušenie zapojenia, pretože môže byť pohodlnejšie pripojiť koncový doraz alebo sondu k mikrokontroléru zatvárača. Použitie tejto funkcie však môže viesť k „prekmitnutiu“ krokových motorov počas operácií navádzania a snímania.

K prekročeniu dochádza v dôsledku možného oneskorenia prenosu správ medzi mikrokontrolérom monitorujúcim koncový doraz a mikrokontrolérmi pohybujúcimi krokovými motormi. Klipperov kód je navrhnutý tak, aby toto oneskorenie nepresiahlo 25 ms. (Keď je aktivované navádzanie viacerých mikrokontrolérov, mikrokontroléry odosielajú periodické stavové správy a kontrolujú, či sú zodpovedajúce stavové správy prijaté do 25 ms.)

Napríklad, ak sa navádzanie vykonáva rýchlosťou 10 mm/s, je možné prekročenie až o 0,250 mm (10 mm/s * 0,025 s == 0,250 mm). Pri konfigurácii navádzania s viacerými mikrokontrolérmi je potrebná opatrnosť, aby sa zohľadnil tento typ prekročenia. Použitie pomalších rýchlostí navádzania alebo snímania môže prekročenie znížiť.

Prekmit krokového motora by nemal mať nepriaznivý vplyv na presnosť postupu navádzania a snímania. Klipperov kód prekročenie zistí a zohľadní ho vo svojich výpočtoch. Je však dôležité, aby hardvérový návrh bol schopný zvládnuť prekročenie bez poškodenia stroja.

Aby bolo možné využiť túto schopnosť „homingu viacerých mikrokontrolérov“, hardvér musí mať predvídateľne nízku latenciu medzi hostiteľským počítačom a všetkými mikrokontrolérmi. Čas prenosu musí byť zvyčajne konzistentne kratší ako 10 ms. Vysoká latencia (aj na krátke obdobia) pravdepodobne povedie k zlyhaniu homingu.

Ak by vysoká latencia spôsobila zlyhanie (alebo ak sa zistí iný problém s komunikáciou), Klipper vyvolá chybu „Časový limit komunikácie počas navádzania“.

Upozorňujeme, že os s viacerými krokovými motormi (napr. `stepper_z` a `stepper_z1`) musí byť na rovnakom mikrokontroléri, aby sa dalo použiť navádzanie z viacerých MCU. Napríklad, ak je koncový doraz na inom mikrokontroléri ako `stepper_z`, potom `stepper_z1` musí byť na rovnakom mikrokontroléri ako `stepper_z`.
