# Mise à l'origine et Palpage multi contrôleurs

Klipper possède un mécanisme pour la mise à l'origine avec une fin de course raccordée à un microcontrôleur et des moteurs pas à pas raccordés à un autre microcontrôleur. Ce mécanisme est connu sous le nom de "multi-mcu homing". Cette fonctionnalité est aussi utilisée si la sonde de palpage Z est raccordée à un microcontrôleur différent de celui des moteurs Z.

Cette fonctionnalité peut être utile pour simplifier le câblage : il peut être plus simple de raccorder un fin de course ou une sonde au microcontrôleur le plus proche. Cependant, l'utilisation de cette fonctionnalité peut provoquer un "dépassement" des moteurs pas à pas pendant les opération de mise à l'origine ou de palpage.

Cette possibilité de "dépassement" peut arriver à cause des délais de transmission entre le microcontrôleur des endstop et le microcontrôleur qui déplce les moteurs pas à pas. Le code de Klipper a été conçu pour limiter ce délai a moins de 25 ms. (Quand la mise à l'origine multi contrôleurs est active, les microcontrôleurs envoient des messages d'état périodiquement et il y a une vérification que ces messages sont bien reçus dans la limite des 25 ms.)

Donc, par exemple, si l'on fait une mise à l'origine à 10 mm/s, il est alors possible de dépasser de 0.250 mm maximum (10 mm/s * 0.25 s = 0.250 mm).Il faut bien faire attention à cette possibilité de "dépassement" lors de la configuration d'une mise à l'origine avec multiples contrôleurs. Une mise à l'origine ou un palpage plus lent peut réduite le "dépassement".

Ce dépassement des moteurs pas à pas ne nuit pas à la précision de la procédure de mise à l'origine et de palpage. Le code de Klipper détectera le dépassement et en tiendra compte dans ses calculs. Cependant, il est important que la conception matérielle soit capable de gérer les dépassements sans endommager la machine.

Si Klipper détecte un problème de communication entre les microcontrôleurs lors de la mise à l'origine multi-mcu, il déclenchera une erreur "Délai de communication pendant la mise à l'origine".

Notez qu'un axe avec plusieurs steppers (par exemple, `stepper_z` et `stepper_z1`) doit avoir tous les meteeurs pas à pas sur le même microcontrôleur afin d'utiliser le référencement multi-mcu. Par exemple, si une fin de course est sur un microcontrôleur distinct de `stepper_z` alors `stepper_z1` doit être sur le même microcontrôleur que `stepper_z`.
