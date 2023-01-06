# BL-Touch

## Connexion du BL-Touch

Un **avertissement** avant de commencer : Évitez de toucher la broche BL-Touch avec vos doigts nus, car elle est très sensible à la graisse des doigts. Et si vous la touchez, soyez très doux, afin de ne pas plier ou pousser quoi que ce soit.

Connectez le connecteur "servo" de la BL-Touch à une `control_pin` selon la documentation de la BL-Touch ou celle de votre MCU. En utilisant le câblage originel, le fil jaune du câblage triple est la `control_pin` et le fil blanc du câblage double est la `sensor_pin`. Vous devez configurer ces broches en fonction de votre câblage. La plupart des dispositifs BL-Touch nécessitent un pullup sur la broche du capteur (préfixez le nom de la broche par "^"). Par exemple :

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

Si le BL-Touch est utilisé pour amener l'axe Z à l'origine, réglez `endstop_pin : probe:z_virtual_endstop` et supprimez `position_endstop` dans la section de configuration `[stepper_z]`, puis ajoutez une section de configuration `[safe_z_home]` pour lever l'axe z, ramener les axes xy à la position d'origine, se déplacer au centre du lit et ramener l'axe z à la position d'origine. Par exemple :

```
[safe_z_home]
home_xy_position: 100, 100 # Change coordinates to the center of your print bed
speed: 50
z_hop: 10                 # Move up 10mm
z_hop_speed: 5
```

Il est important que le mouvement z_hop dans safe_z_home soit suffisamment élevé pour que la sonde ne heurte rien, même si la broche de la sonde se trouve dans son état le plus bas.

## Tests initiaux

Avant de poursuivre, vérifiez que la BL-Touch est montée à la bonne hauteur, la tige doit se trouver à environ 2 mm au-dessus de la buse lorsqu'elle est rétractée

Lorsque vous mettez l'imprimante sous tension, la sonde BL-Touch doit effectuer un auto-test en sortant et rétractant le pointeau plusieurs Une fois l'auto-test terminé, le pointeau doit être rétracté et le voyant rouge de la sonde doit être allumé. En cas d'erreur, par exemple si la sonde clignote en rouge ou si le pointeau est en bas au lieu d'être en haut, veuillez éteindre l'imprimante et vérifier le câblage et la configuration.

Si tout ce qui précède semble bon, il est temps de tester que la broche de contrôle fonctionne correctement. Exécutez d'abord `BLTOUCH_DEBUG COMMAND=pin_down` dans votre terminal d'imprimante. Vérifiez que le pointeau se déplace vers le bas et que la LED rouge de la sonde s'éteint. Si ce n'est pas le cas, vérifiez à nouveau votre câblage et votre configuration. Ensuite, lancez une commande `BLTOUCH_DEBUG COMMAND=pin_up`, vérifiez que le pointeau se rétracte et que la lumière rouge s'allume à nouveau. Si elle clignote, il y a un problème.

L'étape suivante consiste à confirmer que la tige du capteur fonctionne correctement. Exécutez `BLTOUCH_DEBUG COMMAND=pin_down`, vérifiez que le pointeau se déplace vers le bas, exécutez `BLTOUCH_DEBUG COMMAND=touch_mode`, exécutez `QUERY_PROBE`, et vérifiez que la commande rapporte "probe : open". Ensuite, tout en poussant légèrement le pointeau vers le haut avec l'ongle de votre doigt, exécutez à nouveau `QUERY_PROBE`. Vérifiez que la commande rapporte "probe : TRIGGERED". Si l'une ou l'autre des requêtes ne donne pas le bon message, cela indique généralement un câblage ou une configuration incorrecte (certains [clones](#bl-touch-clones) peuvent nécessiter une manipulation spéciale). A la fin de ce test, exécutez `BLTOUCH_DEBUG COMMAND=pin_up` et vérifiez que le pointeau se déplace vers le haut.

Après avoir effectué les tests de la broche de contrôle et de la broche de détection du BL-Touch, il est maintenant temps de tester le palpage, mais avec une petite astuce. Au lieu de laisser le pointeau de la sonde toucher le lit d'impression, laissez-le toucher l'ongle de votre doigt. Positionnez la tête d'impression loin du lit, émettez un `G28` (ou `PROBE` si vous n'utilisez pas probe:z_virtual_endstop), attendez que la tête d'impression commence à descendre, et arrêtez le mouvement en touchant très doucement le pointeau avec votre ongle. Il se peut que vous deviez le faire deux fois, car la configuration par défaut de l'autoguidage sonde deux fois. Préparez-vous à éteindre l'imprimante si elle ne s'arrête pas lorsque vous touchez le pointeau.

Si ce test a réussi, faites un autre `G28` (ou `PROBE`) mais cette fois-ci laissez-le toucher le lit comme il se doit.

## BL-Touch défaillant

Une fois que le BL-Touch est dans un état incohérent, il se met à clignoter en rouge. Vous pouvez le forcer à quitter cet état en émettant :

BLTOUCH_DEBUG COMMAND=reset

Cela peut se produire si son étalonnage est interrompu par un blocage de l'extraction du pointeau.

Cependant, il se peut également que le BL-Touch ne soit plus capable de se calibrer lui-même. Cela se produit si la vis située sur le dessus est mal positionnée ou si le noyau magnétique à l'intérieur de la tige du pointeau a bougé. S'il s'est déplacé vers le haut au point de coller à la vis, il se peut que le BL-Touch ne soit plus capable de libérer sa tige. Dans ce cas, vous devez ouvrir la vis et utiliser un stylo à bille pour le remettre doucement en place. Réintroduisez la tige dans le BL-Touch de façon à ce qu'elle tombe dans la position extraite. Réajustez délicatement la vis sans tête du dessus. Vous devez trouver la juste position pour qu'elle soit capable d'abaisser et de relever la tige et que la lumière rouge s'allume et s'éteigne. Utilisez les commandes `reset`, `pin_up` et `pin_down` pour y parvenir.

## "Clones" du BL-Touch

De nombreux "clones" BL-Touch fonctionnent correctement avec Klipper en utilisant la configuration par défaut. Cependant, certains "clones" peuvent ne pas supporter la commande `QUERY_PROBE` et certains autres "clones" peuvent nécessiter la configuration de `pin_up_reports_not_triggered` ou `pin_up_touch_mode_reports_triggered`.

Important ! Ne configurez pas `pin_up_reports_not_triggered` ou `pin_up_touch_mode_reports_triggered` à False sans suivre ces instructions. Ne configurez pas l'une ou l'autre de ces options sur False sur un véritable BL-Touch. Une configuration incorrecte de ces paramètres sur False peut augmenter le temps de palpage et peut augmenter le risque d'endommager l'imprimante.

Certains "clones" ne supportent pas le `touch_mode` et par conséquent la commande `QUERY_PROBE` ne fonctionne pas. Malgré cela, il est possible d'effectuer un palpage et une mise à l'origine avec ces dispositifs. Sur ces dispositifs, la commande `QUERY_PROBE` pendant les [tests initiaux](#initial-tests) n'aboutira pas, mais le test suivant `G28` (ou `PROBE`) aboutira. Il est possible d'utiliser ces "clones" avec Klipper tant que l'on n'utilise pas la commande `QUERY_PROBE` et que l'on n'active pas la fonction `probe_with_touch_mode`.

Certains "clones" sont incapables d'effectuer le test de vérification du capteur interne de Klipper. Sur ces appareils, les tentatives de mise à l'origine ou de palpage peuvent entraîner le signalement par Klipper de l'erreur "BLTouch failed to verify sensor state". Si cela se produit, exécutez manuellement les étapes pour confirmer que la broche du capteur fonctionne comme décrit dans la section [tests initiaux](#initial-tests). Si les commandes `QUERY_PROBE` de ce test produisent toujours les résultats attendus et que l'erreur "BLTouch failed to verify sensor state" se produit toujours, il peut être nécessaire de mettre `pin_up_touch_mode_reports_triggered` à False dans le fichier de configuration de Klipper.

Un nombre rare d'anciens "clones" sont incapables de signaler qu'ils ont réussi à relever leur pointeau. Sur ces appareils, Klipper signalera une erreur "BLTouch failed to raise probe" après chaque tentative de retour à l'origine ou de palpage. On peut tester ces appareils - éloigner la tête du lit, exécuter `BLTOUCH_DEBUG COMMAND=pin_down`, vérifier que le pointeau s'est déplacé vers le bas, exécuter `QUERY_PROBE`, vérifier que la commande rapporte "probe : open", exécuter `BLTOUCH_DEBUG COMMAND=pin_up`, vérifier que le pointeau s'est déplacé vers le haut, et exécuter `QUERY_PROBE`. Si la broche reste en haut, que le dispositif n'entre pas dans un état d'erreur, et que la première requête rapporte "probe : open" alors que la seconde rapporte "probe : TRIGGERED" alors cela indique que `pin_up_reports_not_triggered` doit être mis à False dans le fichier de configuration de Klipper.

## BL-Touch v3

Certains BL-Touch v3.0 et BL-Touch 3.1 peuvent nécessiter la configuration de `probe_with_touch_mode` dans le fichier de configuration de l'imprimante.

Si le fil de signal du BL-Touch v3.0 est connecté à une broche d'arrêt (avec un condensateur de filtrage du bruit), il se peut que le BL-Touch v3.0 ne soit pas capable d'envoyer un signal de manière constante pendant la recherche de l'origine et le palpage. Si les commandes `QUERY_PROBE` dans la section des [tests initiaux](#initial-tests) produisent toujours les résultats attendus, mais que la tête de l'outil ne s'arrête toujours pas pendant les commandes G28/PROBE, alors cela indique ce problème. Une solution de contournement est de définir `probe_with_touch_mode : True` dans le fichier de configuration.

Le BL-Touch v3.1 peut entrer incorrectement dans un état d'erreur après une tentative de sondage réussie. Les symptômes sont une lumière clignotante occasionnelle sur le BL-Touch v3.1 qui dure quelques secondes après qu'il ait réussi à entrer en contact avec le lit. Klipper devrait effacer cette erreur automatiquement et elle est généralement inoffensive. Cependant, on peut définir `probe_with_touch_mode` dans le fichier de configuration pour éviter ce problème.

Important ! Certains "clones" ainsi que le BL-Touch v2.0 (et antérieur) peuvent avoir une précision réduite lorsque `probe_with_touch_mode` est réglé sur True. Le réglage de cette valeur sur True augmente également le temps nécessaire au déploiement de la sonde. Si vous configurez cette valeur sur un dispositif BL-Touch "clone" ou plus ancien, assurez-vous de tester la précision de la sonde avant et après avoir défini cette valeur (utilisez la commande `PROBE_ACCURACY` pour tester).

## Multi-palpages sans rétraction du pointeau

Par défaut, Klipper déploie le pointeau au début de chaque tentative de mesure et le rétracte ensuite. Ce déploiement et cette rétraction répétitifs du pointeau peuvent augmenter la durée totale des séquences d'étalonnage impliquant de nombreuses mesures du plateau. Klipper permet de laisser le pointeau déployé entre deux mesures consécutives, ce qui peut réduire la durée totale des mesures. Ce mode est activé en configurant `stow_on_each_sample` à False dans le fichier de configuration.

Important ! Si vous réglez la valeur `Stow_on_each_sample` sur False, Klipper peut effectuer des mouvements horizontaux de la tête de l'outil durant le déploiement du palpeur. Assurez-vous que toutes les opérations de palpage ont un dégagement Z suffisant avant de régler cette valeur sur False. Si l'espace est insuffisant, un mouvement horizontal peut faire en sorte que le pointeau s'accroche à une obstruction et endommager l'imprimante.

Important ! Il est recommandé d'utiliser `probe_with_touch_mode` configuré à True lorsque vous utilisez `stow_on_each_sample` configuré à False. Certains "clones" peuvent ne pas détecter un contact ultérieur du lit si `probe_with_touch_mode` n'est pas configuré. Sur tous les dispositifs, l'utilisation de la combinaison de ces deux paramètres simplifie la signalisation de l'appareil, améliorant la stabilité globale.

Notez cependant que certains "clones" ainsi que le BL-Touch v2.0 (et antérieurs) peuvent avoir une précision réduite lorsque `probe_with_touch_mode` est réglé sur True. Sur ces appareils, c'est une bonne idée de tester la précision de la sonde avant et après avoir réglé `probe_with_touch_mode` (utilisez la commande `PROBE_ACCURACY` pour tester).

## Étalonnage des décalages du BL-Touch

Suivez les instructions du guide [Calibration de la sonde](Probe_Calibrate.md) pour définir les paramètres de configuration x_offset, y_offset et z_offset.

C'est une bonne idée de vérifier que le décalage Z est proche de 1mm. Si ce n'est pas le cas, vous devrez probablement déplacer le dispositif vers le haut ou vers le bas pour résoudre ce problème. Vous voulez qu'il se déclenche bien avant que la buse ne touche le lit, afin qu'un éventuel filament coincé ou un lit déformé n'affecte pas l'action du BL-Touch. Mais en même temps, vous voulez que la position rétractée soit aussi loin que possible au-dessus de la buse pour éviter qu'elle ne touche les pièces imprimées. Si un ajustement est effectué sur la position du BL-Touch, recommencez les étapes d'étalonnage de celui-ci.

## Mode de sortie du BL-Touch


   * Un BL-Touch V3.0 accepte le réglage d'un mode de sortie 5V ou OPEN-DRAIN, un BL-Touch V3.1 le supporte aussi et peut également le stocker dans son EEPROM interne. Si votre carte contrôleur a besoin du niveau logique haut de 5V du mode 5V, vous pouvez régler le paramètre 'set_output_mode' dans la section [bltouch] du fichier de configuration de l'imprimante sur "5V".***N'utilisez le mode 5V que si la ligne d'entrée de votre carte contrôleur est tolérante à cette tension (5V). C'est pourquoi la configuration par défaut de ces versions de BL-Touch est le mode OPEN-DRAIN. Vous pourriez potentiellement endommager le CPU de votre carte contrôleur***

   En résumé : Si une carte contrôleur a besoin d'un mode 5V ET qu'elle est tolérante à 5V sur sa ligne de signal d'entrée ET si

   - vous avez un BL-Touch Smart V3.0, vous devez utiliser le paramètre 'set_output_mode : 5V' pour assurer ce réglage à chaque démarrage, puisque la sonde ne peut pas se souvenir du réglage nécessaire.
   - vous avez un BL-Touch Smart V3.1, vous avez le choix d'utiliser 'set_output_mode : 5V' ou de mémoriser le mode une fois pour toutes en utilisant une commande 'BLTOUCH_STORE MODE=5V' manuellement et sans plus utiliser le paramètre 'set_output_mode:'.
   - vous avez une autre sonde : Certaines sondes ont une trace sur la carte de circuit imprimé à couper ou un cavalier à régler afin de définir (de façon permanente) le mode de sortie. Dans ce cas, omettez complètement le paramètre 'set_output_mode'.
Si vous avez une version V3.1, n'automatisez pas ou ne répétez pas la mémorisation du mode de sortie afin d'éviter d'user l'EEPROM de la sonde. L'EEPROM du BLTouch permet environ 100.000 mises à jour. 100 mises à jour par jour représentent environ 3 ans de fonctionnement avant l'usure de la mémoire. Ainsi, le stockage du mode de sortie dans la V3.1 est conçu par le vendeur pour être une opération compliquée (le défaut d'usine étant un mode sûr OPEN DRAIN) et n'est pas adapté pour être émis de manière répétée par un trancheur, une macro ou autre, il est préférable de ne l'utiliser que lors de la première intégration de la sonde dans l'électronique de l'imprimante.
