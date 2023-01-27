# Homen en Proben met meerdere microcontrollers

Klipper ondersteunt een methode om te homen vanaf een andere microcontroller dan waar de stappenmotoren op aangesloten zijn. Deze ondersteuning wordt "multi-mcu homing" genoemd. Deze optie kan ook gebruikt worden als de Z-probe op een andere microcontroller is aangesloten dan de Z-stappenmotors.

Deze functie kan nuttig zijn bij het vereenvoudigen van de bedrading, omdat het handiger kan zijn om een endstop of probe aan te sluiten op een dichterbij gelegen microcontroller. Deze optie kan echter zorgen voor een overshoot van de stappenmotors tijdens het homen en proben.

De overshoot ontstaat door mogelijke vertragingen in de communicatie tussen de microcontroller die de endstop meet en de microcontrollers die de stappenmotors bewegen. De Klipper-code is ontworpen om deze vertraging te beperken tot maximaal 25 ms. (Als multi-mcu homing is geactiveerd, sturen de microcontrollers periodiek statusberichten en controleren of de overeenkomstige statusberichten binnen 25 ms worden ontvangen)

Dus, bijvoorbeeld bij een home-snelheid van 10 mm/s is er een mogelijke overshoot tot 0,25mm (10 mm/s * 0,025 s = 0,25 mm). Bij het configureren van multi-mcu homen moet rekening worden gehouden met deze overshoot. Gebruik langzamere home-snelheden om de overshoot te beperken.

Overshoot van stappenmotors zullen niet veel impact hebben op de nauwkeurigheid van het homen en proben. De Klipper-code meet de overshoot en compenseert hiervoor in de berekeningen. Belangrijk is wel dat de hardware deze overshoot op kan vangen zonder schade te veroorzaken.

Als Klipper een communicatiefout heeft tussen de microcontrollers tijdens multi-mcu homen, dan geeft het de error "Communication timeout during homing".

Let op dat een as met meerdere stappenmotors (bijv. `stepper_z` en `stepper_z1`) op dezelfde microcontroller aangesloten moeten zijn voor het multi-mcu homen. Als bijvoorbeeld een endstop op een andere microcontroller dan `stepper_z` aangesloten is, dan moet `stepper_z1` op dezelfde microcontroller als `z_stepper` aangesloten zijn.
