# Ändlägeskörning och sondering med flera mikrokontroller

Klipper har stöd för ändlägeskörning där ändlägesbrytaren är ansluten till en mikrokontroller medan stegmotorerna finns på en annan. Funktionen kallas ”ändlägeskörning med flera MCU:er”. Den används också när en Z-sond finns på en annan mikrokontroller än Z-stegmotorerna.

Funktionen kan förenkla kabeldragningen eftersom det kan vara lämpligare att ansluta en ändlägesbrytare eller sond till en närmare mikrokontroller. Den kan dock leda till att stegmotorerna går för långt vid ändlägeskörning och sondering.

Överskridningen uppstår på grund av möjliga fördröjningar i meddelandeöverföringen mellan mikrokontrollern som övervakar ändlägesbrytaren och mikrokontrollerna som driver stegmotorerna. Klippers kod är utformad för att begränsa fördröjningen till högst 25 ms. När ändlägeskörning med flera MCU:er är aktiverad skickar mikrokontrollerna periodiska statusmeddelanden och kontrollerar att motsvarande statusmeddelanden tas emot inom 25 ms.

Vid ändlägeskörning med 10 mm/s kan överskridningen till exempel bli upp till 0,250 mm (10 mm/s * 0,025 s = 0,250 mm). Ta hänsyn till denna typ av överskridning när du konfigurerar ändlägeskörning med flera MCU:er. Långsammare hastigheter för ändlägeskörning eller sondering kan minska överskridningen.

Överskridning av stegmotorer bör inte påverka precisionen vid ändlägeskörning och sondering negativt. Klippers kod identifierar överskridningen och tar hänsyn till den i sina beräkningar. Maskinvaran måste dock vara utformad för att klara överskridningen utan att maskinen skadas.

För att använda ändlägeskörning med flera MCU:er måste maskinvaran ha förutsägbart låg latens mellan värddatorn och alla mikrokontroller. Tur- och returtiden måste vanligen konsekvent vara kortare än 10 ms. Hög latens, även under korta perioder, leder sannolikt till fel vid ändlägeskörning.

Om hög latens leder till ett fel, eller om ett annat kommunikationsproblem identifieras, visas felet ”Kommunikationens tidsgräns överskreds under ändlägeskörning” i Klipper.

Observera att en axel med flera stegmotorer, till exempel `stepper_z` och `stepper_z1`, måste finnas på samma mikrokontroller för att ändlägeskörning med flera MCU:er ska kunna användas. Om en ändlägesbrytare till exempel finns på en annan mikrokontroller än `stepper_z` måste `stepper_z1` finnas på samma mikrokontroller som `stepper_z`.
