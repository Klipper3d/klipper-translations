# Посилання на конфігурацію

Цей документ є довідкою для опцій доступник у файлі конфігурації Klipper.

Описи в цьому документі відформатовано таким чином, що їх можна вирізати та вставити у файл конфігурації принтера. Перегляньте [документ інсталяції](Installation.md) для отримання інформації щодо налаштування Klipper та вибору початкового конфігураційного файлу.

## Конфігурація мікроконтролера

### Формат імен контактів мікроконтролера

Багато параметрів конфігурації вимагають назви контакту мікроконтролера. Klipper використовує апаратні назви для цих контактів, наприклад  PA4 .

Назві контактів може передувати  ! , щоб вказати, що слід використовувати зворотну полярність (наприклад, тригер на низькому рівні замість високого).

Вхідним контактам може передувати  ^ , щоб вказати, що апаратний підтягуючий резистор повинен бути включений для контакту. Якщо мікроконтролер підтримує висувні резистори, перед вхідним висновком може стояти «~».

Зауважте, що деякі розділи конфігурації можуть «створювати» додаткові шпильки. Якщо це трапляється, розділ конфігурації, що визначає контакти, має бути вказаний у файлі конфігурації перед будь-якими розділами, які використовують ці контакти.

### [mcu]

Конфігурація основного мікроконтролера.

```
[mcu]
серійний:
# Послідовний порт для підключення до MCU. Якщо не впевнений (або якщо
# зміни) перегляньте "Де мій послідовний порт?" розділ поширених запитань.
# Цей параметр необхідно вказати, якщо використовується послідовний порт.
#бод: 250000
# Швидкість передачі даних для використання. За замовчуванням 250000.
#canbus_uuid:
# Якщо використовується пристрій, підключений до шини CAN, це встановлює унікальність
# ідентифікатор мікросхеми для підключення. Це значення необхідно вказати під час використання
# Шина CAN для зв'язку.
#canbus_interface:
# Якщо використовується пристрій, підключений до шини CAN, це встановлює CAN
# мережевий інтерфейс для використання. Типовим є 'can0'.
#restart_method:
# Це керує механізмом, який хост використовуватиме для скидання
# мікроконтролер. Можливі варіанти: «arduino», «cheetah», «rpi_usb»,
# і 'команда'. Метод «arduino» (перемикач DTR) поширений на
# Плати та клони Arduino. Метод «гепард» особливий
# метод необхідний для деяких дощок Fysetc Cheetah. Метод «rpi_usb».
# корисний на платах Raspberry Pi з живленням мікроконтролерів
# через USB - короткочасно вимикає живлення всіх портів USB
# виконати скидання мікроконтролера. «Командний» метод передбачає
# надсилання команди Klipper до мікроконтролера, щоб він міг
# скинути себе. За замовчуванням це «arduino», якщо мікроконтролер
# спілкується через послідовний порт, 'command' інакше.
```

### [mcu my_extra_mcu]

Додаткові мікроконтролери (можна визначити будь-яку кількість секцій з префіксом "mcu"). Додаткові мікроконтролери вводять додаткові контакти, які можуть бути налаштовані як нагрівачі, кроки, вентилятори тощо. Наприклад, якщо введено розділ «[mcu extra_mcu]», тоді такі контакти, як «extra_mcu:ar9», можна використовувати в іншому місці у конфігурації (де «ar9» — це ім’я апаратного контакту або псевдонім на даному мікроконтроллері).

```
[mcu my_extra_mcu]

Параметри конфігурації див. у розділі "mcu".
```

## Загальні кінематичні налаштування

### [printer]

Розділ принтера керує налаштуваннями принтера високого рівня.

```
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid_corexy, hybrid_corexz, generic_cartesian,
#   rotary_delta, delta, deltesian, polar, winch, or none.
#   This parameter must be specified.
max_velocity:
#   Maximum velocity (in mm/s) of the toolhead (relative to the
#   print). This parameter must be specified.
max_accel:
#   Maximum acceleration (in mm/s^2) of the toolhead (relative to the
#   print). Although this parameter is described as a "maximum"
#   acceleration, in practice most moves that accelerate or decelerate
#   will do so at the rate specified here. The value specified here
#   may be changed at runtime using the SET_VELOCITY_LIMIT command.
#   This parameter must be specified.
#minimum_cruise_ratio: 0.5
#   Most moves will accelerate to a cruising speed, travel at that
#   cruising speed, and then decelerate. However, some moves that
#   travel a short distance could nominally accelerate and then
#   immediately decelerate. This option reduces the top speed of these
#   moves to ensure there is always a minimum distance traveled at a
#   cruising speed. That is, it enforces a minimum distance traveled
#   at cruising speed relative to the total distance traveled. It is
#   intended to reduce the top speed of short zigzag moves (and thus
#   reduce printer vibration from these moves). For example, a
#   minimum_cruise_ratio of 0.5 would ensure that a standalone 1.5mm
#   move would have a minimum cruising distance of 0.75mm. Specify a
#   ratio of 0.0 to disable this feature (there would be no minimum
#   cruising distance enforced between acceleration and deceleration).
#   The value specified here may be changed at runtime using the
#   SET_VELOCITY_LIMIT command. The default is 0.5.
#square_corner_velocity: 5.0
#   The maximum velocity (in mm/s) that the toolhead may travel a 90
#   degree corner at. A non-zero value can reduce changes in extruder
#   flow rates by enabling instantaneous velocity changes of the
#   toolhead during cornering. This value configures the internal
#   centripetal velocity cornering algorithm; corners with angles
#   larger than 90 degrees will have a higher cornering velocity while
#   corners with angles less than 90 degrees will have a lower
#   cornering velocity. If this is set to zero then the toolhead will
#   decelerate to zero at each corner. The value specified here may be
#   changed at runtime using the SET_VELOCITY_LIMIT command. The
#   default is 5mm/s.
#max_accel_to_decel:
#   This parameter is deprecated and should no longer be used.
```

### [stepper]

Визначення крокового двигуна. Різні типи принтерів (як зазначено параметром "kinematics" у розділі конфігурації [printer]) вимагають різних імен для крокового пристрою (наприклад, `stepper_x` проти `stepper_a`). Нижче наведено загальні визначення степера.

Перегляньте [документ про відстань обертання](Rotation_Distance.md), щоб отримати інформацію про обчислення параметра `rotation_distance`. Див. документ [Multi-MCU homing](Multi_MCU_Homing.md) для отримання інформації про наведення за допомогою кількох мікроконтролерів.

```
[stepper_x]
 step_pin:
 # Крок GPIO контакт (спрацьовує високий рівень). Цей параметр необхідно вказати.
 dir_pin:
 # Напрямок контакту GPIO (високий вказує на позитивний напрямок). Це
 Потрібно вказати # параметр.
 enable_pin:
 # Увімкнути PIN-код (за замовчуванням включений високий; використовуйте !, щоб вказати ввімкнення).
 # низький). Якщо цей параметр не передбачено, то кроковий двигун
 # драйвер має бути завжди ввімкнено.
 відстань_обертання:
 # Відстань (у мм), яку проходить вісь за один повний оберт
 # кроковий двигун (або кінцева передача, якщо вказано gear_ratio).
 # Цей параметр необхідно вказати.
 мікрокроки:
 # Кількість мікрокроків, які використовує драйвер крокового двигуна. Це
 Потрібно вказати # параметр.
 #full_steps_per_rotation: 200
 # Кількість повних кроків за один оберт крокового двигуна.
 # Встановіть значення 200 для крокового двигуна 1,8 градуса або встановіть значення 400 для a
 # Мотор 0,9 градусів. За замовчуванням 200.
 #gear_ratio:
 # Передавальне число, якщо кроковий двигун підключено до осі через a
 # коробка передач. Наприклад, можна вказати «5:1», якщо коробка передач 5 до 1
 # у використанні. Якщо вісь має кілька коробок передач, можна вказати кому
 # відокремлений список передавальних чисел (наприклад, «57:11, 2:1»). Якщо a
 # gear_ratio вказано, тоді rotation_distance визначає
 # відстань, яку проходить вісь за один повний оберт кінцевої шестерні.
 # За замовчуванням передавальне число не використовується.
 #step_pulse_duration:
 # Мінімальний час між фронтом сигналу крокового імпульсу та
 # наступний фронт сигналу "unstep". Це також використовується для встановлення
 # мінімальний час між кроковим імпульсом і сигналом зміни напрямку.
 # Значення за замовчуванням становить 0,000000100 (100 нс) для степерів TMC, які
 # налаштовано в режимі UART або SPI, а за замовчуванням 0,000002 (що
 # дорівнює 2 нас) для всіх інших степерів.
 endstop_pin:
 # Штифт виявлення кінцевого перемикача. Якщо цей кінцевий штифт знаходиться на a
 # відрізняється від крокового двигуна mcu, тоді він увімкне "multi-mcu
 # homing". Цей параметр необхідно надати для X, Y і Z
 # степери на принтерах декартового типу.
 #position_min: 0
 # Мінімальна допустима відстань (у мм), яку користувач може вказати степеру
 # перейти до. За замовчуванням 0 мм.
 position_endstop:
 # Розташування кінцевого упору (у мм). Цей параметр необхідно вказати
 # для кроків X, Y та Z на принтерах декартового типу.
 position_max:
 # Максимальна дійсна відстань (у мм), яку користувач може вказати степеру
 # перейти до. Цей параметр необхідно надати для X, Y і Z
 # степери на принтерах декартового типу.
 #homing_speed: 5,0
 # Максимальна швидкість (у мм/с) крокового кроку при наведенні. За замовчуванням
 # становить 5 мм/с.
 #homing_retract_dist: 5.0
 # Відстань до відступу (у мм) перед повторним поверненням до початку
 # самонаведення. Встановіть це значення на нуль, щоб вимкнути другий будинок. За замовчуванням
 # становить 5 мм.
 #homing_retract_speed:
 # Швидкість для використання під час руху втягування після наведення у разі потреби
 # відрізнятися від швидкості наведення, яка є типовою для цього
 # параметр
 #second_homing_speed:
 # Швидкість (у мм/с) кроку при виконанні другого дому.
 # Типовим є homing_speed/2.
 #homing_positive_dir:
 # Якщо істина, наведення призведе до позитивного руху крокового кроку
 # напрямок (від нуля); якщо false, додому до нуля. Це так
 # краще використовувати значення за замовчуванням, ніж вказувати цей параметр. The
 # за замовчуванням значення true, якщо position_endstop близько до position_max і false
 # якщо поблизу position_min.
```

### Декартова кінематика

Перегляньте [example-cartesian.cfg](../config/example-cartesian.cfg) для прикладу конфігураційного файлу декартової кінематики.

Тут описано лише параметри, характерні для декартових принтерів - див. загальні кінематичні параметри для доступних параметрів.

```
[принтер] кінематика: декартова max_z_velocity:

Це встановлює максимальну швидкість (у мм/с) руху вздовж z

вісь. Цей параметр можна використовувати для обмеження максимальної швидкості

кроковий двигун z. За умовчанням використовується max_velocity для

max_z_velocity.

max_z_accel:

Це встановлює максимальне прискорення (у мм/с^2) руху вздовж

вісь z. Він обмежує прискорення крокового двигуна z. The

за замовчуванням для max_z_accel використовується max_accel.

Розділ stepper_x використовується для опису керування кроком

вісь X у декартовому роботі.

[stepper_x]

Секція stepper_y використовується для опису керування кроком

вісь Y у декартовому роботі.

[stepper_y]

Секція stepper_z використовується для опису керування кроком

вісь Z у декартовому роботі.

[stepper_z]
```

### Лінійна дельта-кінематика

Перегляньте [example-delta.cfg](../config/example-delta.cfg) для прикладу файлу конфігурації лінійної дельта-кінематики. Перегляньте [посібник із дельта-калібрування](Delta_Calibrate.md), щоб отримати інформацію про калібрування.

Тут описано лише параметри, характерні для лінійних дельта-принтерів - див. загальні кінематичні налаштування для доступних параметрів.

```
[принтер]
 кінематика: дельта
 max_z_velocity:
 # Для дельта-принтерів це обмежує максимальну швидкість (у мм/с).
 # рухається з рухом осі z. Цей параметр можна використовувати для зменшення
 # максимальна швидкість рухів вгору/вниз (для яких потрібна більша швидкість кроку
 # ніж інші рухи на дельта-принтері). За умовчанням використовується
 # max_velocity для max_z_velocity.
 #max_z_accel:
 # Це встановлює максимальне прискорення (у мм/с^2) руху вздовж
 # вісь z. Це налаштування може бути корисним, якщо принтер може досягати більших значень
 # прискорення рухів XY, ніж рухів Z (наприклад, під час використання формувача введення).
 # За замовчуванням для max_z_accel використовується max_accel.
 #minimum_z_position: 0
 # Мінімальне положення Z, яке користувач може наказати рухати головою
 # до. За замовчуванням 0.
 delta_radius:
 # Радіус (у мм) горизонтального кола, утвореного трьома лінійними
 # осьові вежі. Цей параметр також можна розрахувати як:
 # дельта_радіус = гладкий_зсув_стрижня - зміщення_ефектора - зміщення_каретки
 # Цей параметр необхідно вказати.
 #print_radius:
 # Радіус (у мм) дійсних координат головки XY. Можна використовувати
 # це налаштування для налаштування діапазону перевірки рухів інструментальної головки. Якщо
 # тут вказано велике значення, тоді його можна вказати
 # головка інструменту в зіткнення з вежею. За умовчанням використовується
 # delta_radius для print_radius (що зазвичай запобігає a
 # зіткнення веж).

 # Розділ stepper_a описує степпер, який керує фронтом
 # ліва вежа (на 210 градусів). Цей розділ також керує самонаведенням
 # параметри (homing_speed, homing_retract_dist) для всіх веж.
 [stepper_a]
 position_endstop:
 # Відстань (у мм) між соплом і ліжком, коли сопло є
 # у центрі області збірки та спрацьовує кінцевий упор. Це
 # параметр повинен бути наданий для stepper_a; для stepper_b і
 # stepper_c цей параметр за умовчанням має значення, указане для
 # степпер_а.
 arm_length:
 # Довжина (у мм) діагонального стрижня, який з’єднує цю вежу з
 # друкуюча головка. Цей параметр необхідно надати для stepper_a; для
 # stepper_b і stepper_c цей параметр має значення за замовчуванням
 # вказано для stepper_a.
 #кут:
 # Ця опція вказує кут (у градусах), під яким розташована вежа
 # в. За замовчуванням 210 для stepper_a, 330 для stepper_b і 90
 # для stepper_c.

 # Розділ stepper_b описує степпер, який керує фронтом
 # права вежа (на 330 градусів).
 [stepper_b]

 # Розділ stepper_c описує степпер, який контролює задню частину
 # башта (на 90 градусів).
 [stepper_c]

 # Розділ delta_calibrate дозволяє розширений DELTA_CALIBRATE
 # Команда g-коду, яка може відкалібрувати положення кінцевих упорів вежі та
 # кути.
 [delta_calibrate]
 радіус:
 # Радіус (у мм) зони, яка може бути досліджена. Це радіус
 # координат сопла, що досліджується; якщо використовується автоматичний зонд
 # зі зміщенням XY, а потім виберіть достатньо малий радіус, щоб
 # зонд завжди підходить над ліжком. Цей параметр необхідно вказати.
 #швидкість: 50
 # Швидкість (у мм/с) незондувальних рухів під час калібрування.
 # За замовчуванням 50.
 #horizontal_move_z: 5
 # Висота (у мм), на яку слід наказати рухатися голові
 # безпосередньо перед початком операції зондування. За замовчуванням 5.
```

### Кінематика Дельта

Перегляньте [example-deltesian.cfg](../config/example-deltesian.cfg) для прикладу конфігураційного файлу дельтесової кінематики.

Тут описано лише параметри, характерні для дельтезійних принтерів - див. загальні кінематичні налаштування для доступних параметрів.

```
[принтер]
 кінематика: дельтезиана
 max_z_velocity:
 # Для дельтезіанських принтерів це обмежує максимальну швидкість (у мм/с).
 # рухається з рухом осі z  Цей параметр можна використовувати для зменшення
 # максимальна швидкість рухів вгору/вниз (для яких потрібна більша швидкість кроку
 # ніж інші рухи на дельтезіанському принтері). За умовчанням використовується
 # max_velocity для max_z_velocity.
 #max_z_accel:
 # Це встановлює максимальне прискорення (у мм/с^2) руху вздовж
 # вісь z. Це налаштування може бути корисним, якщо принтер може досягати більших значень
 # прискорення рухів XY, ніж рухів Z (наприклад, під час використання формувача введення).
 # За замовчуванням для max_z_accel використовується max_accel.
 #minimum_z_position: 0
 # Мінімальне положення Z, яке користувач може наказати рухати головою
 # до. За замовчуванням 0.
 #min_angle: 5
 # Це мінімальний кут (у градусах) відносно горизонталі
 # що дозволено досягати дельтезіанським рукавам. Цей параметр є
 # призначений для обмеження того, щоб руки стали повністю горизонтальними,
 # що може призвести до випадкової інверсії осі XZ. За замовчуванням 5.
 #print_width:
 # Відстань (у мм) дійсних координат головки X.  Можна використовувати
 # це налаштування для налаштування діапазону перевірки рухів інструментальної головки. Якщо
 # тут вказано велике значення, тоді його можна вказати
 # головка інструменту в зіткнення з вежею. Цей параметр зазвичай
 # відповідає ширині ліжка (у мм).
 #slow_ratio: 3
 # Коефіцієнт, який використовується для обмеження швидкості та прискорення під час рухів поблизу
 # крайні точки осі X. Якщо вертикальну відстань розділити на горизонтальну
 # відстань перевищує значення slow_ratio, потім швидкість і
 # прискорення обмежені половиною їх номінальних значень. Якщо вертикально
 # відстань, поділена на горизонтальну відстань, перевищує подвійне значення
 # відношення_повільного, тоді швидкість і прискорення обмежені одиницею
 # чверті їх номінальних значень. За замовчуванням 3.

 # Секція stepper_left використовується для опису керування кроком
 # ліва вежа. Цей розділ також керує параметрами наведення
 # (homing_speed, homing_retract_dist) для всіх веж.
 [stepper_left]
 position_endstop:
 # Відстань (у мм) між соплом і ліжком, коли сопло є
 # у центрі області побудови, і кінцеві упори спрацьовують. Це
 # параметр повинен бути наданий для stepper_left; для stepper_right це
 # параметр за умовчанням має значення, указане для stepper_left.
 arm_length:
 # Довжина (у мм) діагонального стрижня, який з’єднує каретку башти
 # друкуюча головка. Цей параметр необхідно надати для stepper_left; для
 # stepper_right, цей параметр за умовчанням має значення, указане для
 # крок_вліво.
 arm_x_length:
 # Горизонтальна відстань між друкуючою голівкою та вежею, коли
 # принтерів переведено на домашню сторінку. Цей параметр необхідно надати для stepper_left;
 # для stepper_right цей параметр за замовчуванням має значення, указане для
 # крок_вліво.

 # Розділ stepper_right використовується для опису степера, який контролює
 # права вежа.
 [stepper_right]

 # Розділ stepper_y використовується для опису керування кроком
 # вісь Y у дельтезіанному роботі.
 [stepper_y]
```

### Кінематика CoreXY

Перегляньте [example-corexy.cfg](../config/example-corexy.cfg) для прикладу файлу кінематики corexy (і h-bot).

Тут описано лише параметри, характерні для принтерів corexy – доступні параметри див. у загальних кінематичних налаштуваннях.

```
[принтер] кінематика: корексія max_z_velocity:

Це встановлює максимальну швидкість (у мм/с) руху вздовж z

вісь. Цей параметр можна використовувати для обмеження максимальної швидкості

кроковий двигун z. За умовчанням використовується max_velocity для

max_z_velocity.

max_z_accel:

Це встановлює максимальне прискорення (у мм/с^2) руху вздовж

вісь z. Він обмежує прискорення крокового двигуна z. The

за замовчуванням для max_z_accel використовується max_accel.

Секція stepper_x використовується для опису осі X, а також

степпер, що контролює рух X+Y.

[stepper_x]

Секція stepper_y використовується для опису осі Y, а також

степпер, що контролює рух XY.

[stepper_y]

Секція stepper_z використовується для опису керування кроком

вісь Z.

[stepper_z]
```

### Кінематика CoreXZ

Перегляньте [example-corexz.cfg](../config/example-corexz.cfg) для прикладу файлу конфігурації кінематики corexz.

Тут описано лише параметри, характерні для принтерів Corexz - див. загальні кінематичні налаштування для доступних параметрів.

```
[принтер] кінематика: corexz max_z_velocity:

Це встановлює максимальну швидкість (у мм/с) руху вздовж z

вісь. За замовчуванням для max_z_velocity використовується max_velocity.

max_z_accel:

Це встановлює максимальне прискорення (у мм/с^2) руху вздовж

вісь z. За замовчуванням для max_z_accel використовується max_accel.

Секція stepper_x використовується для опису осі X, а також

степпер, що контролює рух X+Z.

[stepper_x]

Секція stepper_y використовується для опису керування кроком

вісь Y.

[stepper_y]

Секція stepper_z використовується для опису осі Z, а також

степпер контролює рух XZ.

[stepper_z]
```

### Кінематика Hybrid-CoreXY

Перегляньте [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg) для прикладу файлу конфігурації гібридної кінематики corexy.

Ця кінематика також відома як кінематика Markforged.

Тут описано лише параметри, характерні для гібридних принтерів corexy. Доступні параметри можна знайти в загальних кінематичних параметрах.

```
[принтер]
 кінематика: hybrid_corexy
 max_z_velocity:
 # Це встановлює максимальну швидкість (у мм/с) руху вздовж z
 # вісь. За замовчуванням для max_z_velocity використовується max_velocity.
 max_z_accel:
 # Це встановлює максимальне прискорення (у мм/с^2) руху вздовж
 # вісь z. За замовчуванням для max_z_accel використовується max_accel.

 # Секція stepper_x використовується для опису осі X, а також
 # степпер, що контролює рух X-Y.
 [stepper_x]

 # Розділ stepper_y використовується для опису керування кроком
 # вісь Y.
 [stepper_y]

 # Секція stepper_z використовується для опису керування кроком
 # вісь Z.
 [stepper_z]
```

### Кінематика Hybrid-CoreXZ

Перегляньте [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg) для прикладу файлу конфігурації кінематики hybrid corexz.

Ця кінематика також відома як кінематика Markforged.

Тут описано лише параметри, характерні для гібридних принтерів corexy. Доступні параметри можна знайти в загальних кінематичних параметрах.

```
[принтер]
 кінематика: hybrid_corexz
 max_z_velocity:
 # Це встановлює максимальну швидкість (у мм/с) руху вздовж z
 # вісь. За замовчуванням для max_z_velocity використовується max_velocity.
 max_z_accel:
 # Це встановлює максимальне прискорення (у мм/с^2) руху вздовж
 # вісь z. За замовчуванням для max_z_accel використовується max_accel.

 # Секція stepper_x використовується для опису осі X, а також
 # степпер, що контролює рух X-Z.
 [stepper_x]

 # Розділ stepper_y використовується для опису керування кроком
 # вісь Y.
 [stepper_y]

 # Секція stepper_z використовується для опису керування кроком
 # вісь Z.
 [stepper_z]
```

### Полярна кінематика

Перегляньте [example-polar.cfg](../config/example-polar.cfg) для прикладу конфігураційного файлу полярної кінематики.

Тут описано лише параметри, характерні для полярних принтерів - див. загальні кінематичні налаштування для доступних параметрів.

Polar kinematics

```
[принтер]
 кінематика: полярна
 max_z_velocity:
 # Це встановлює максимальну швидкість (у мм/с) руху вздовж z
 # вісь. Цей параметр можна використовувати для обмеження максимальної швидкості
 # кроковий двигун z. За умовчанням використовується max_velocity для
 # max_z_velocity.
 max_z_accel:
 # Це встановлює максимальне прискорення (у мм/с^2) руху вздовж
 # вісь z. Він обмежує прискорення крокового двигуна z. The
 # за замовчуванням для max_z_accel використовується max_accel.

 # Розділ stepper_bed використовується для опису управління кроком
 # ліжко.
 [stepper_bed]
 передаточне число:
 # Необхідно вказати gear_ratio, а rotation_distance — не можна
 # вказано. Наприклад, якщо ліжко має 80-зубчастий шків
 # кроковим кроком із 16-зубчастим шківом, тоді можна вказати a
 # передавальне число «80:16». Цей параметр необхідно вказати.

 # Секція stepper_arm використовується для опису керування кроком
 # коляска на кронштейні.
 [stepper_arm]

 # Секція stepper_z використовується для опису керування кроком
 # вісь Z.
 [stepper_z]
```

### Кінематика поворотної дельти

Перегляньте [example-rotary-delta.cfg](../config/example-rotary-delta.cfg) для прикладу файлу конфігурації поворотної дельта-кінематики.

Тут описано лише параметри, характерні для ротаційних дельта-принтерів – доступні параметри див. у загальних кінематичних налаштуваннях.

КІНЕМАТИКА РОТАЦІЙНОЇ ДЕЛЬТА РОБОТА В ПРОЦЕСІ. Переміщення до початку може закінчитися, а деякі перевірки меж не реалізуються.

```
[принтер]
 кінематика: rotary_delta
 max_z_velocity:
 # Для дельта-принтерів це обмежує максимальну швидкість (у мм/с).
 # рухається з рухом осі z. Цей параметр можна використовувати для зменшення
 # максимальна швидкість рухів вгору/вниз (для яких потрібна більша швидкість кроку
 # ніж інші рухи на дельта-принтері). За умовчанням використовується
 # max_velocity для max_z_velocity.
 #minimum_z_position: 0
 # Мінімальне положення Z, яке користувач може наказати рухати головою
 # до. За замовчуванням 0.
 радіус плеча:
 # Радіус (у мм) горизонтального кола, утвореного трьома
 # плечових суглобів, мінус радіус кола, утвореного
 # ефекторні суглоби. Цей параметр також можна розрахувати як:
 # радіус_плеча = (delta_f - delta_e) / sqrt(12)
 # Цей параметр необхідно вказати.
 висота плечей:
 # Відстань (у мм) плечових суглобів від ліжка, мінус
 # Висота інструментальної головки ефектора. Цей параметр необхідно вказати.

 # Розділ stepper_a описує степпер, який контролює задню частину
 # права рука (під кутом 30 градусів). Цей розділ також керує самонаведенням
 # параметри (homing_speed, homing_retract_dist) для всіх рук.
 [stepper_a]
 передаточне число:
 # Необхідно вказати gear_ratio, а rotation_distance — не можна
 # вказано. Наприклад, якщо важіль має шків із 80 зубцями
 # шківом із 16 зубцями, який у свою чергу з’єднаний із 60
 # зубчастий шків, що приводиться в рух кроковим механізмом з 16-зубчастим шківом, тоді
 # можна вказати передавальне число "80:16, 60:16". Цей параметр
 Потрібно вказати #.
 position_endstop:
 # Відстань (у мм) між соплом і ліжком, коли сопло є
 # у центрі області збірки та спрацьовує кінцевий упор. Це
 # параметр повинен бути наданий для stepper_a; для stepper_b і
 # stepper_c цей параметр за умовчанням має значення, указане для
 # степпер_а.
 upper_arm_length:
 # Довжина (у мм) плеча, що з’єднує «плечовий суглоб» із
 # «ліктьовий суглоб». Цей параметр необхідно надати для stepper_a; для
 # stepper_b і stepper_c цей параметр має значення за замовчуванням
 # вказано для stepper_a.
 нижня_довжина_руки:
 # Довжина (у мм) руки, що з’єднує «ліктьовий суглоб» з
 # «ефекторний суглоб». Цей параметр необхідно надати для stepper_a;
 # для stepper_b і stepper_c цей параметр має значення за замовчуванням
 # вказано для stepper_a.
 #кут:
 # Ця опція вказує кут (у градусах), під яким знаходиться плече.
 # За замовчуванням 30 для stepper_a, 150 для stepper_b і 270 для
 # кроковий_c.

 # Розділ stepper_b описує степпер, який контролює задню частину
 # ліва рука (на 150 градусів).
 [stepper_b]

 # Розділ stepper_c описує степпер, який керує фронтом
 # рука (на 270 градусів).
 [stepper_c]

 # Розділ delta_calibrate дозволяє розширений DELTA_CALIBRATE
 # Команда g-коду, яка може відкалібрувати позиції кінцевих упорів плеча.
 [delta_calibrate]
 радіус:
 # Радіус (у мм) зони, яка може бути досліджена. Це радіус
 # координат сопла, що досліджується; якщо використовується автоматичний зонд
 # зі зміщенням XY, а потім виберіть достатньо малий радіус, щоб
 # зонд завжди підходить над ліжком. Цей параметр необхідно вказати.
 #швидкість: 50
 # Швидкість (у мм/с) незондувальних рухів під час калібрування.
 # За замовчуванням 50.
 #horizontal_move_z: 5
 # Висота (у мм), на яку слід наказати рухатися голові
 # безпосередньо перед початком операції зондування. За замовчуванням 5.
```

### Тросова лебідка Кінематика

Перегляньте файл [example-winch.cfg](../config/example-winch.cfg) для прикладу конфігураційного файлу кінематики тросової лебідки.

Тут описано лише параметри, характерні для принтерів із тросовою лебідкою – доступні параметри див. у загальних кінематичних налаштуваннях.

ОПОРА КАНАТНОЇ ЛЕБІДКИ Є ЕКСПЕРИМЕНТАЛЬНОЮ. На кінематиці тросової лебідки не реалізовано самонаведення. Щоб повернути принтер, вручну надішліть команди руху, доки інструментальна головка не буде на 0, 0, 0, а потім видайте команду  G28 .

```
[принтер]
 кінематика: лебідка

 # Розділ stepper_a описує степер, підключений до першого
 # тросова лебідка. Можуть бути мінімум 3 і максимум 26 тросових лебідок
 # визначено (від stepper_a до stepper_z), хоча зазвичай визначати 4.
 [stepper_a]
 відстань_обертання:
 # Відстань_обертання — це номінальна відстань (у мм) головки інструменту
 # рухається до тросової лебідки для кожного повного оберту
 # кроковий двигун. Цей параметр необхідно вказати.
 anchor_x:
 anchor_y:
 anchor_z:
 # Положення X, Y та Z тросової лебідки в декартовому просторі.
 # Ці параметри мають бути надані.
```

### Generic Cartesian Kinematics

See [example-generic-cartesian.cfg](../config/example-generic-caretesian.cfg) for an example generic Cartesian kinematics config file.

This printer kinematic class allows a user to define in a pretty flexible manner an arbitrary Cartesian-style kinematics. In principle, the regular cartesian, corexy, hybrid_corexy can be defined this way too. However, more importantly, various otherwise unsupported kinematics such as inverted hybrid_corexy or corexyuv can be defined using this kinematic.

Notably, the definition of a generic Cartesian kinematic deviates significantly from the other kinematic types. It follows the following convention: a user defines a set of carriages with certain range of motion that can move independently from each other (they should move over the Cartesian axes X, Y, and Z, hence the name of the kinematic) and corresponding endstops that allow the firmware to determine the position of carriages during homing, as well as a set of steppers that move those carriages. The `[printer]` section must specify the kinematic and other printer-level settings same as the regular Cartesian kinematic:

```
[printer]
kinematics: generic_cartesian
max_velocity:
max_accel:
#minimum_cruise_ratio:
#square_corner_velocity:
#max_accel_to_decel:
#max_z_velocity:
#max_z_accel:
```

Then a user must define the following three carriages: `[carriage x]`, `[carriage y]`, and `[carriage z]`, e.g.

```
[carriage x]
endstop_pin:
#   Endstop switch detection pin. If this endstop pin is on a
#   different mcu than the stepper motor(s) moving this carriage,
#   then it enables "multi-mcu homing". This parameter must be provided.
#position_min: 0
#   Minimum valid distance (in mm) the user may command the carriage to
#   move to.  The default is 0mm.
position_endstop:
#   Location of the endstop (in mm). This parameter must be provided.
position_max:
#   Maximum valid distance (in mm) the user may command the stepper to
#   move to. This parameter must be provided.
#homing_speed: 5.0
#   Maximum velocity (in mm/s) of the carriage when homing. The default
#   is 5mm/s.
#homing_retract_dist: 5.0
#   Distance to backoff (in mm) before homing a second time during
#   homing. Set this to zero to disable the second home. The default
#   is 5mm.
#homing_retract_speed:
#   Speed to use on the retract move after homing in case this should
#   be different from the homing speed, which is the default for this
#   parameter
#second_homing_speed:
#   Velocity (in mm/s) of the carriage when performing the second home.
#   The default is homing_speed/2.
#homing_positive_dir:
#   If true, homing will cause the carriage to move in a positive
#   direction (away from zero); if false, home towards zero. It is
#   better to use the default than to specify this parameter. The
#   default is true if position_endstop is near position_max and false
#   if near position_min.
```

Afterwards, a user specifies the stepper motors that move these carriages, for instance

```
[stepper my_stepper]
carriages:
#   A string describing the carriages the stepper moves. All defined
#   carriages can be specified here, as well as their linear combinations,
#   e.g. x, x+y, y-0.5*z, x-z, etc. This parameter must be provided.
step_pin:
dir_pin:
enable_pin:
rotation_distance:
microsteps:
#full_steps_per_rotation: 200
#gear_ratio:
#step_pulse_duration:
```

See [stepper](#stepper) section for more information on the regular stepper parameters. The `carriages` parameter defines how the stepper affects the motion of the carriages. For example, `x+y` indicates that the motion of the stepper in the positive direction by the distance `d` moves the carriages `x` and `y` by the same distance `d` in the positive direction, while `x-0.5*y` means the motion of the stepper in the positive direction by the distance `d` moves the carriage `x` by the distance `d` in the positive direction, but the carriage `y` will travel distance `d/2` in the negative direction.

More than a single stepper motor can be defined to drive the same axis or belt. For example, on a CoreXY AWD setups two motors driving the same belt can be defined as

```
[carriage x]
endstop_pin: ...
...

[carriage y]
endstop_pin: ...
...

[stepper a0]
carriages: x-y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...

[stepper a1]
carriages: x-y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...
```

with `a0` and `a1` steppers having their own control pins, but sharing the same `carriages` and corresponding endstops.

There are situations when a user wants to have more than one endstop per axis. Examples of such configurations include Y axis driven by two independent stepper motors with belts attached to both ends of the X beam, with effectively two carriages on Y axis each having an independent endstop, and multi-stepper Z axis with each stepper having its own endstop (not to be confused with the configurations with multiple Z motors but only a single endstop). These configurations can be declared by specifying additional carriage(s) with their endstops:

```
[extra_carriage my_carriage]
primary_carriage:
#   The name of the primary carriage this carriage corresponds to.
#   It also effectively defines the axis the carriage moves over.
#   This parameter must be provided.
endstop_pin:
#   Endstop switch detection pin. This parameter must be provided.
```

and the corresponding stepper motors, for example:

```
[extra_carriage y1]
primary_carriage: y
endstop_pin: ...

[stepper sy1]
carriages: y1
...
```

Notably, an `[extra_carriage]` does not define parameters such as `position_min`, `position_max`, and `position_endstop`, but instead inherits them from the specified `primary_carriage`, thus sharing the same range of motion with the primary carriage.

For the references on how to configure IDEX setups, see the [dual carriage](#dual-carriage) section.

### Немає Кінематика

Можна визначити спеціальну кінематику "немає", щоб вимкнути кінематичну підтримку в Klipper. Це може бути корисно для керування пристроями, які не є типовими 3d-принтерами, або для налагодження.

```
[принтер]
 кінематика: немає
 максимальна_швидкість: 1
 max_accel: 1
 # Необхідно визначити параметри max_velocity і max_accel. The
 # значення не використовуються для кінематики "немає".
```

## Загальний екструдер і підставка з підігрівом

### [extruder]

Описи в цьому документі відформатовано таким чином, що їх можна вирізати та вставити у файл конфігурації принтера. Перегляньте [інсталяції документа](Installation.md) для отримання інформації щодо налаштування Klipper та вибору початкового конфігураційного файлу.

```
[extruder]
Крок_pin:
Дир_пін:
Увімкнути:
мікрокропи:
catalog / saw / Ресурси
#full_steps_per_rotation:
#gear_ratio:
Нема Див. розділ "Степпер" для опису вище
# параметри. Якщо не вказано вищевказаних параметрів, то немає
# степпер буде асоціюватися з насадкою гарячим (хоча б
# SYNC_EXTRUDER_MOTION Команда може асоціювати один за замовчуванням.
сопл_діаметр:
Нема Діаметр насадки (в мм). Цей параметр повинен бути
# надано.
JavaScript licenses API Веб-сайт
Нема Номінальний діаметр сировини (в мм) як він надходить
# екструдер. Цей параметр необхідно надати.
#max_extrude_cross_секція:
# Максимальна площа (в мм^2) екструзійного перерізу (наприклад,
# ширина екструзії множиться на висоту шару. Ця установка запобігає
# надмірна кількість екструзії при порівняно малих переміщеннях XY.
Нема Якщо перемістити запит на екструзійну швидкість, яка буде перевищити це значення
Повернеться помилка. За замовчуванням: 4.0 *
# сопл_діаметр^2
#instantaneous_corner_velocity: 1.000
Нема Максимальна миттєва зміна швидкості (в мм / с)
# екструдера під час з'єднання двох рухів. За замовчуванням 1 мм/с.
#max_extrude_only_distance: 50.0
# Максимальна довжина (в мм сирої нитки), що втракція або
Чи може мати екструзії. Якщо відшкодування або зовнішнє переміщення
# вимагає відстані більше, ніж це значення, це призведе до помилки
# повернути. За замовчуванням 50мм.
#max_extrude_only_velocity:
#max_extrude_only_accel:
# Максимальна швидкість (в мм / с) і прискорення (в мм / s^2)
# екструдераторний двигун для ретракцій і екструзійних рухів. Про нас
# налаштування не впливають на нормальні переходи друку. Якщо
# вказаний, потім вони розраховуються, щоб відповідати ліміту XY
# друк переміщення з перерізом 4.0*nozzle_diameter^2 б
Немає.
#pressure_advance: 0.0
Нема Сума сирої нитки для натискання на екструдер під час
# прискорення екструдера. Рівномірна кількість ниток
# при декларації. Вимірюється в міліметрах на
# міліметр/секунд. За замовчуванням 0, який відключає тиск
# заздалегідь.
#pressure_advance_smooth_time: 0.040
# Діапазон часу (в секундах) для використання при розрахунку середня
# Швидкість екструдера для тиску заздалегідь. Більші результати значення в
# гладкі рухи екструдера. Цей параметр не може перевищувати 200 м.
Нема Ця установка застосовується тільки при тиску_advance не-zero. Про нас
# За замовчуванням 0.040 (40 мілісекунди).
Нема
Нема Решта змінних описують зовнішній нагрівач.
Термопомпи:
# PWM вихідний штифт, що контролює нагрівач. Цей параметр повинен бути
# надано.
#max_power: 1.0
Нема Максимальна потужність (визначена як значення від 0.0 до 1.0)
# нагрівач_pin може бути встановлений. Значення 1.0 дозволяє встановлювати шпильку
# повністю ввімкнено для розширених періодів, при цьому значення 0,5 буде
# дозволяють ввімкнути шпильку не більше половини часу. Про нас
# налаштування може бути використана для обмеження загальної потужності
# періоди) нагрівач. За замовчуванням 1.0.
Датчик_тип:
Нема Тип датчика - загальні арматури "EPCOS 100K B57560G104F",
# "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Генерик"
# 3950", "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
# "SliceEngineering 450", "TDK NTCG104LH104JT1". Дивитися
# "Температурні датчики" для інших датчиків. Цей параметр
Не обов'язково бути надані.
Датчик_pin:
Нема Аналоговий вхідний штифт підключений до датчика. Цей параметр повинен бути
# надано.
#pullup_resistor: 4700
Нема Стійкість (в омах) тяги прикріплюється до арматури.
Нема Цей параметр діє лише тоді, коли датчик є аристором. Про нас
# За замовчуванням 4700 Ом.
#smooth_time: 1.0
# Значення часу (в секундах), над якими вимірюється температура
Згладити вплив шуму вимірювання. За замовчуванням
No 1 секунд.
контроль:
Нема Алгоритм управління (або під водою). Цей параметр повинен
Немає наданих.
pid_Kp:
pid_Ki:
pid_Kd:
Нема Пропорційний (pid_Kp), інтегральний (pid_Ki), похідний
Параметри керування зворотним зв'язком PID. Клиппер
# оцінює параметри PID з наступним загальним формулою:
# heater_pwm = (Kp*error + Ki*integral(error) - Kd *derivative(error)) / 255
Нема Де "error" "requested_ Infrastructure - вимірюється_температура"
# і "heater_pwm" є запитаним коефіцієнтом опалення з 0,0 будучи повним
#від і 1,0 повною мірою. Розглянемо використання PID_CALIBRATE
# команди для отримання цих параметрів. pid_Kp, pid_Ki, pid_Kd
# параметри повинні бути надані для нагрівачів PID.
#max_delta: 2.6 км
Нема На керованих обігрівачах «водамарка» це кількість ступенів
Нема Цельсій над цільовою температурою перед відключенням нагрівача
#, а також кількість градусів нижче цілі перед
# перезнімання нагрівача. За замовчуванням 2 градусів Celsius.
#pwm_cycle_time: 0.100
Нема Час за секундами для кожного програмного забезпечення PWM цикл обігрівача. Він
Не рекомендується встановлювати це, якщо є електрика
# Вимоги до перемикання обігрівача швидше 10 разів на секунду.
Нема За замовчуванням 0.100 секунд.
#min_extrude_temp: 170
Нема Мінімальна температура (в Цельсію) при якому пересуватися екструдер
# команди можуть бути видані. За замовчуванням 170 Celsius.
min_temp:
максимум:
Нема Максимальний діапазон допустимих температур (в Кельсі)
# обігрівач повинен залишатися в межах. Це контролює функцію безпеки
# реалізований в мікроконтролерному коді - слід вимірювати
# температура коли-небудь падає за межі цього діапазону, то мікроконтролер
# перейде в стан відключення. Ця перевірка може допомогти виявити деякі
# Теплові та сенсорні апаратні збої. Встановити цей діапазон просто широкий
Чи не вистачить розумних температур, що не призводить до помилки.
Нема Ці параметри повинні бути надані.
.
```

### [heater_bed]

Розділ heater_bed описує ліжко з підігрівом. Він використовує ті самі налаштування нагрівача, які описані в розділі «Екструдер».

```
[heater_bed]
heater_pin:
тип_датчика:
sensor_pin:
КОНТРОЛЬ:
min_temp:
max_temp:
# Опис наведених вище параметрів див. у розділі «Екструдер».
```

## Підтримка рівня ліжка

### [bed_mesh]

Вирівнювання сітки. Можна визначити розділ конфігурації bed_mesh, щоб увімкнути трансформації переміщення, які зміщують вісь z на основі сітки, згенерованої із зондованих точок. У разі використання датчика для встановлення осі z у початковий кут, рекомендовано визначити розділ safe_z_home у файлі printer.cfg, щоб він був спрямований у центр області друку.

Додаткову інформацію див. у [посібнику з сітки для ліжок](Bed_Mesh.md) і [довідці про команди](G-Codes.md#bed_mesh).

Візуальні приклади:

```
 прямокутна грядка, probe_count = 3, 3:
              x---x---x (max_point)
              |
              х---х---х
                      |
  (min_point) x---x---x

  кругле ліжко, round_probe_count = 5, bed_radius = r:
                  x (0, r) кінець
                /
              х---х---х
                        \
  (-r, 0) x---x---x---x---x (r, 0)
            \
              х---х---х
                    /
                  x (0, -r) початок
```

```
[bed_mesh] #швидкість: 50

Швидкість (у мм/с) незондувальних рухів під час калібрування.

За замовчуванням 50.

#horizontal_move_z: 5

Висота (у мм), на яку слід наказати рухатися голові

безпосередньо перед початком операції зондування. За замовчуванням 5.

#mesh_radius:

Визначає радіус сітки для зондування для круглих грядок. Зауважте, що

радіус є відносно координати, заданої в

mesh_origin option. This parameter must be provided for round beds

і опущено для прямокутних ліжок.

#mesh_origin:

Defines the center X, Y coordinate of the mesh for round beds. This

координата відносно місця розташування зонда. Це може бути корисним

to adjust the mesh_origin in an effort to maximize the size of the

радіус сітки. За замовчуванням 0, 0. Цей параметр потрібно пропустити для

прямокутні ліжка.

#mesh_min:

Визначає мінімальну координату X, Y прямокутної сітки

ліжко. Ця координата відноситься до місця розташування зонда. Це

буде першою досліджуваною точкою, найближчою до початку координат. Це

Для прямокутних грядок потрібно вказати # параметр. #mesh_max:

Визначає максимальну координату X, Y прямокутної сітки

ліжко. Дотримується того самого принципу, що й mesh_min, однак це буде

be the furthest point probed from the bed's origin. This parameter

необхідно передбачити для прямокутних ліжок.

#probe_count: 3, 3

Для прямокутних ліжок це пара цілих чисел, розділених комою

values X, Y defining the number of points to probe along each

вісь. Єдине значення також є дійсним, і в цьому випадку це значення буде

be applied to both axes. Default is 3, 3.

#round_probe_count: 5

For round beds, this integer value defines the maximum number of

точки для зондування вздовж кожної осі. Це значення має бути непарним числом.

За замовчуванням 5.

#fade_start: 1.0

Позиція g-коду z, у якій розпочинається поступова відміна z-коригування

коли ввімкнено згасання. За замовчуванням 1.0.

#fade_end: 0.0

Позиція gcode z, у якій завершується поетапна відмова. Якщо встановлено значення a

значення нижче fade_start, затухання вимкнено. Слід зазначити, що

fade може додати небажане масштабування вздовж осі z друку. Якщо a

user wishes to enable fade, a value of 10.0 is recommended.

За замовчуванням 0.0, що вимикає згасання.

#fade_target:

The z position in which fade should converge. When this value is

set to a non-zero value it must be within the range of z-values in

сітка. Користувачі, які бажають наблизитися до початкової позиції z

має встановити значення 0. За замовчуванням це середнє значення z сітки.

#split_delta_z: .025

Величина різниці Z (у мм) уздовж ходу, який спрацює

a split. Default is .025.

#move_check_distance: 5.0

Відстань (у мм) уздовж ходу для перевірки split_delta_z.

Це також мінімальна довжина, на яку можна розділити хід. За замовчуванням

is 5.0.

#mesh_pps: 2, 2

Пара цілих чисел X, Y, розділених комами, визначає кількість

points per segment to interpolate in the mesh along each axis. A

"segment" can be defined as the space between each probed point.

Користувач може ввести одне значення, яке буде застосовано до обох

осей. За замовчуванням 2, 2.

#алгоритм: Лагранжа

Алгоритм інтерполяції для використання. Може бути або «Лагранжа», або

"бікубічний". Цей параметр не вплине на сітки 3x3, які є примусовими

для використання вибірки Лагранжа. За замовчуванням — Лагранж.

#бікубічний_натяг: .2

При використанні бікубічного алгоритму параметр натягу вище може

застосовувати для зміни величини інтерпольованого нахилу. Більший

число збільшить величину нахилу, що призведе до більшого

кривизна в сітці. Типовим є .2.

#zero_reference_position:

An optional X,Y coordinate that specifies the location on the bed

where Z = 0.  When this option is specified the mesh will be offset

щоб у цьому місці відбулося коригування нуля Z. За замовчуванням

немає нульового посилання.

#faulty_region_1_min: #faulty_region_1_max:

Необов'язкові точки, які визначають дефектну область. Див. docs/Bed_Mesh.md

для детальної інформації про несправні регіони. Можна додати до 99 дефектних регіонів.

By default no faulty regions are set.

#adaptive_margin:

Додаткове поле (у мм), яке потрібно додати навколо використовуваної площі ліжка

визначені об'єкти друку під час генерації адаптивної сітки.

#scan_overshoot:

Максимальний хід (у мм), доступний за межами сітки.

Для прямокутних ліжок це стосується руху по осі X, а для круглих ліжок

застосовується до всього радіусу. Інструмент повинен мати можливість переміщати кількість

вказано за межами сітки. Це значення використовується для оптимізації подорожі

шлях під час виконання "швидкого сканування". Мінімальне значення, яке можна вказати

дорівнює 1. За умовчанням немає перевищення.
```

### [bed_tilt]

Компенсація нахилу ліжка. Можна визначити розділ конфігурації bed_tilt, щоб увімкнути переміщення, які враховують нахилене ліжко. Зауважте, що bed_mesh і bed_tilt несумісні; обидва не можуть бути визначені.

Додаткову інформацію див. у [довідці про команди](G-Codes.md#bed_tilt).

```
[bed_tilt] #x_adjust: 0

Сума, яку потрібно додати до висоти Z кожного ходу для кожного мм на X

вісь. За замовчуванням 0.

#y_adjust: 0

Сума, яку потрібно додати до висоти Z кожного ходу для кожного мм на Y

вісь. За замовчуванням 0.

#z_adjust: 0

Кількість, яку потрібно додати до висоти Z, коли сопло знаходиться на номінальному рівні

0, 0. За замовчуванням 0.

Решта параметрів керують розширенням BED_TILT_CALIBRATE

команда g-коду, яку можна використовувати для калібрування відповідних x і y

параметри коригування.

#бали:

Список координат X, Y (по одній на рядок; наступні рядки

з відступом), які слід перевірити під час BED_TILT_CALIBRATE

команда. Вкажіть координати насадки і обов'язково щуп

знаходиться над шаром у заданих координатах сопла. За замовчуванням

щоб не ввімкнути команду.

#швидкість: 50

Швидкість (у мм/с) незондувальних рухів під час калібрування.

За замовчуванням 50.

#horizontal_move_z: 5

Висота (у мм), на яку слід наказати рухатися голові

безпосередньо перед початком операції зондування. За замовчуванням 5.
```

### [bed_screws]

Інструмент для регулювання гвинтів вирівнювання ліжка. Щоб увімкнути команду g-коду BED_SCREWS_ADJUST, можна визначити розділ конфігурації [bed_screws].

Додаткову інформацію див. у [посібнику з вирівнювання](Manual_Level.md#adjusting-bed-leveling-screws) і [довідці про команди](G-Codes.md#bed_screws).

```
[bed_screws]
#screw1:
#   The X, Y coordinate of the first bed leveling screw. This is a
#   position to command the nozzle to that is directly above the bed
#   screw (or as close as possible while still being above the bed).
#   This parameter must be provided.
#screw1_name:
#   An arbitrary name for the given screw. This name is displayed when
#   the helper script runs. The default is to use a name based upon
#   the screw XY location.
#screw1_fine_adjust:
#   An X, Y coordinate to command the nozzle to so that one can fine
#   tune the bed leveling screw. The default is to not perform fine
#   adjustments on the bed screw.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#   Additional bed leveling screws. At least three screws must be
#   defined.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   when moving from one screw location to the next. The default is 5.
#probe_height: 0
#   The height of the probe (in mm) after adjusting for the thermal
#   expansion of bed and nozzle. The default is zero.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#probe_speed: 5
#   The speed (in mm/s) when moving from a horizontal_move_z position
#   to a probe_height position. The default is 5.
```

### [screws_tilt_adjust]

Інструмент, який допомагає регулювати нахил кріпильних гвинтів за допомогою Z-щупа. Можна визначити розділ конфігурації screws_tilt_adjust, щоб увімкнути команду g-коду SCREWS_TILT_CALCULATE.

Щоб отримати додаткову інформацію, перегляньте [посібник з вирівнювання](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) і [довідку про команди](G-Codes.md#screws_tilt_adjust).

```
[screws_tilt_adjust]
 #гвинт1:
 # Координата (X, Y) першого гвинта для вирівнювання ліжка.  Це а
 # положення, щоб наказати насадці, щоб зонд знаходився прямо
 # над гвинтом ліжка (або якомога ближче, залишаючись
 # над ліжком). Це базовий гвинт, який використовується в розрахунках. Це
 # Потрібно вказати # параметр.
 #screw1_name:
 # Довільна назва для заданого гвинта. Ця назва відображається, коли
 # виконується допоміжний сценарій. За умовчанням використовується назва на основі
 # розташування гвинта XY.
 #гвинт2:
 #screw2_name:
 #...
 # Додаткові гвинти для вирівнювання ліжка. Повинно бути як мінімум два гвинти
 # визначено.
 #швидкість: 50
 # Швидкість (у мм/с) незондувальних рухів під час калібрування.
 # За замовчуванням 50.
 #horizontal_move_z: 5
 # Висота (у мм), на яку слід наказати рухатися голові
 # безпосередньо перед початком операції зондування. За замовчуванням 5.
 #гвинтова_різьба: CW-M3
 # Тип гвинта, який використовується для вирівнювання ліжка, M3, M4 або M5, і
 # напрямок обертання ручки, яка використовується для вирівнювання ліжка.
 # Прийнятні значення: CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
 # Значення за замовчуванням CW-M3, яке використовують більшість принтерів. A за годинниковою стрілкою
 # обертання ручки зменшує зазор між соплом і
 # ліжко. І навпаки, обертання проти годинникової стрілки збільшує зазор.
```

### [z_tilt]

Багаторазове регулювання нахилу степпера Z. Ця функція дозволяє незалежно регулювати кілька z-степперів (див. розділ «stepper_z1») для налаштування нахилу. Якщо цей розділ присутній, стає доступною розширена [команда G-Code] (G-Codes.md#z_tilt) Z_TILT_ADJUST.

```
[z_tilt]
 #z_positions:
 # Список координат X, Y (по одній на рядок; наступні рядки
 # з відступом), що описує розташування кожної ліжка «точка опори». The
 # "точка опори" - це точка, де ліжко прикріплюється до даної Z
 # степпер. Це описується за допомогою координат сопла (положення X, Y
 # сопла, якщо воно могло рухатися безпосередньо над точкою). The
 # перший запис відповідає stepper_z, другий — stepper_z1,
 # третій до stepper_z2 і т. д. Цей параметр повинен бути наданий.
 #бали:
 # Список координат X, Y (по одній на рядок; наступні рядки
 # з відступом), який слід перевірити під час команди Z_TILT_ADJUST.
 # Вкажіть координати сопла та переконайтеся, що зонд знаходиться вище
 # ложе при заданих координатах сопла. Цей параметр повинен бути
 # надано.
 #швидкість: 50
 # Швидкість (у мм/с) незондувальних рухів під час калібрування.
 # За замовчуванням 50.
 #horizontal_move_z: 5
 # Висота (у мм), на яку слід наказати рухатися голові
 # безпосередньо перед початком операції зондування. За замовчуванням 5.
 #повторні спроби: 0
 # Кількість повторних спроб, якщо досліджувані точки не знаходяться в межах
 #толерантність.
 #retry_tolerance: 0
 # Якщо повторні спроби ввімкнено, повторіть спробу, якщо перевірено найбільший і найменший
 # точки відрізняються більше, ніж retry_tolerance. Зверніть увагу на найменшу одиницю
 # зміна тут буде одним кроком. Однак якщо ви досліджуєте
 На # балів більше, ніж у степперів, тоді ви, ймовірно, матимете фіксований результат
 # мінімальне значення для діапазону досліджуваних точок, яке ви можете дізнатися
 # шляхом спостереження за виведенням команди.
```

### [quad_gantry_level]

Рухоме вирівнювання порталу за допомогою 4 незалежно керованих двигунів Z. Виправляє ефекти гіперболічної параболи (картопляна стружка) на рухомому порталі, що є більш гнучким. ПОПЕРЕДЖЕННЯ: використання цього на рухомому ліжку може призвести до небажаних результатів. Якщо цей розділ присутній, стає доступною розширена команда G-коду QUAD_GANTRY_LEVEL. Ця процедура передбачає наступну конфігурацію двигуна Z:

```
 ----------------
  |Z1 Z2|
  |   --------- |
  |   |        |    |
  |   |        |    |
  |   х-------- |
  |Z Z3|
  ----------------
```

Де x — точка 0, 0 на ліжку

```
[quad_gantry_level]
 #gantry_corners:
 # Розділений новим рядком список координат X, Y, що описує обидва
 # протилежні кути порталу. Перший запис відповідає Z,
 # другий до Z2. Цей параметр необхідно вказати.
 #бали:
 # Розділений новим рядком список із чотирьох точок X, Y, які слід перевірити
 # під час команди QUAD_GANTRY_LEVEL. Порядок розташування є
 # важливий і має відповідати місцезнаходженням Z, Z1, Z2 і Z3
 # замовлення. Цей параметр необхідно вказати. Для максимальної точності,
 # переконайтеся, що ваші зсуви зонду налаштовані.
 #швидкість: 50
 # Швидкість (у мм/с) незондувальних рухів під час калібрування.
 # За замовчуванням 50.
 #horizontal_move_z: 5
 # Висота (у мм), на яку слід наказати рухатися голові
 # безпосередньо перед початком операції зондування. За замовчуванням 5.
 #max_adjust: 4
 # Безпечна межа, якщо вимагається коригування, що перевищує це значення
 # quad_gantry_level буде перервано.
 #повторні спроби: 0
 # Кількість повторних спроб, якщо досліджувані точки не знаходяться в межах
 #толерантність.
 #retry_tolerance: 0
 # Якщо повторні спроби ввімкнено, повторіть спробу, якщо перевірено найбільший і найменший
 # точки відрізняються більше, ніж retry_tolerance.
```

### [виправлення перекосу]

Корекція перекосу принтера. Можна використовувати програмне забезпечення для виправлення перекосу принтера в 3 площинах, xy, xz, yz. Це робиться шляхом друку калібрувальної моделі вздовж площини та вимірювання трьох довжин. Через характер корекції перекосу ці довжини встановлюються за допомогою gcode. Докладніше див. у [Корекція перекосів](Skew_Correction.md) і [Довідка про команди](G-Codes.md#skew_correction).

```
[виправлення перекосу]
```

### [z_thermal_adjust]

Регулювання положення головки інструменту по Z залежно від температури. Компенсація вертикального руху головки інструменту, викликаного тепловим розширенням рами принтера, у режимі реального часу за допомогою датчика температури (зазвичай підключеного до вертикальної частини рами).

Дивіться також: [розширені команди g-коду](G-Codes.md#z_thermal_adjust).

```
[z_thermal_adjust]
 #temp_coeff:
 # Температурний коефіцієнт розширення, мм/град. Наприклад, a
 # temp_coeff 0,01 мм/градус Цельсія перемістить вісь Z вниз на 0,01 мм для
 # кожен градус Цельсія, який датчик температури підвищує. За замовчуванням
 # 0,0 мм/градус C, що не застосовує коригування.
 #smooth_time:
 # Вікно згладжування, застосоване до датчика температури, за секунди. Може зменшити
 # шум двигуна від надмірно малих поправок у відповідь на шум датчика.
 # За замовчуванням 2,0 секунди.
 #z_adjust_off_above:
 # Вимикає налаштування вище цієї висоти Z [мм]. Остання обчислена корекція
 # залишатиметься застосованим, доки інструментальна головка не переміститься нижче вказаної висоти Z
 # знову. За замовчуванням 99999999,0 мм (завжди ввімкнено).
 #max_z_adjustment:
 # Максимальне абсолютне коригування, яке можна застосувати до осі Z [мм]. The
 # за замовчуванням 99999999,0 мм (необмежено).
 #sensor_type:
 #sensor_pin:
 #min_temp:
 #max_temp:
 # Конфігурація датчика температури.
 # Дивіться розділ «екструдер» для визначення наведеного вище
 # параметри.
 #gcode_id:
 # Перегляньте розділ "heater_generic" для визначення цього
 # параметр.
```

## Індивідуальне самонаведення

### [safe_z_home]

Безпечне наведення Z. Можна використати цей механізм для встановлення осі Z на конкретну координату X, Y. Це корисно, наприклад, якщо інструментальна головка повинна переміститися в центр станини, перш ніж Z можна буде повернути на вихід.

```
[safe_z_home]
 home_xy_position:
 # Координати X, Y (наприклад, 100, 100), де повинна бути точка наведення Z
 # виконано. Цей параметр необхідно вказати.
 #швидкість: 50.0
 # Швидкість, з якою інструментальна головка переміщується до безпечного місця Z
 # координата. За замовчуванням 50 мм/с
 #z_hop:
 # Відстань (у мм) для підйому осі Z перед поверненням до початку. Це є
 # застосовується до будь-якої команди повернення до початку, навіть якщо вона не повертає вісь Z.
 # Якщо вісь Z уже налаштована, а поточна позиція Z менша
 # ніж z_hop, тоді це підніме голову на висоту z_hop. Якщо
 # вісь Z ще не повернута, голова піднімається за допомогою z_hop.
 # За замовчуванням не реалізовано Z-хоп.
 #z_hop_speed: 15,0
 # Швидкість (у мм/с), з якою вісь Z піднімається перед поверненням у початкове положення.  The
 # за замовчуванням 15 мм/с.
 #move_to_previous: false
 # Якщо встановлено значення True, осі X і Y скидаються до попередніх
 # позиції після наведення осі Z. За замовчуванням значення False.
```

### [homing_override]

Перевизначення початкового положення. Можна використати цей механізм для виконання ряду команд g-коду замість G28, який міститься у звичайному введенні g-коду. Це може бути корисним для принтерів, які потребують певної процедури для встановлення апарата.

```
[homing_override] gcode:

Список команд G-Code для виконання замість команд G28

знайдено у звичайному введенні g-коду. Перегляньте docs/Command_Templates.md

для формату G-коду. Якщо G28 міститься в цьому списку команд

тоді він викличе звичайну процедуру початкового переходу для принтера.

Перелічені тут команди мають налаштувати всі осі. Цей параметр повинен

бути надано.

#осі: xyz

Осі для перевизначення. Наприклад, якщо встановлено значення "z", то

Сценарій # перевизначення буде запущено лише тоді, коли вісь z переведена на вихідну (наприклад, через

команда "G28" або "G28 Z0"). Зауважте, сценарій перевизначення повинен

ще вдома всі осі. Типовим є "xyz", що викликає

сценарій перевизначення, який буде запущено замість усіх команд G28.

#set_position_x: #set_position_y: #set_position_z:

Якщо вказано, принтер вважатиме, що вісь знаходиться на вказаному місці

позиція перед виконанням наведених вище команд g-коду. Налаштування цього

вимикає перевірку початкового положення для цієї осі. Це може бути корисним, якщо

голова повинна рухатися перед тим, як викликати звичайний механізм G28 для an

вісь. За замовчуванням положення осі не примусово встановлюється.
```

### [кінцева_фаза]

Кінцеві упори з кроковою фазою. Щоб скористатися цією функцією, визначте розділ конфігурації з префіксом "endstop_phase", за яким слідує назва відповідного розділу конфігурації степера (наприклад, "[endstop_phase stepper_z]"). Ця функція може підвищити точність кінцевих вимикачів. Додайте голе оголошення "[endstop_phase]", щоб увімкнути команду ENDSTOP_PHASE_CALIBRATE.

Щоб отримати додаткову інформацію, перегляньте [посібник із фаз кінцевої зупинки](Endstop_Phase.md) і [довідку про команди](G-Codes.md#endstop_phase).

```
[endstop_phase stepper_z] #endstop_accuracy:

Встановлює очікувану точність (у мм) кінцевого упору. Це представляє

максимальна відстань помилки, яку може викликати кінцевий упор (наприклад, якщо an

Кінцева зупинка може іноді запускати 100um раніше або до 100um пізніше

потім встановіть значення 0,200 для 200um). За замовчуванням

4*відстань_обертання/повні_кроки_обертання.

#trigger_phase:

Це визначає очікувану фазу драйвера крокового двигуна

при попаданні в кінцевий упор. Він складається з двох розділених чисел

через косу риску - фаза і загальна кількість

фази (наприклад, "7/64"). Встановлюйте це значення, лише якщо впевнені

драйвер крокового двигуна скидається щоразу, коли скидається мікроконтролер. Якщо це

не встановлено, то крокову фазу буде виявлено першою

будинок, і ця фаза використовуватиметься в усіх наступних будинках.

#endstop_align_zero: невірно

Якщо істинно, тоді position_endstop осі фактично буде таким

змінено таким чином, що нульове положення для осі відбувається на повному рівні

крок на кроковому двигуні. (Якщо використовується на осі Z і друку

Висота # шару є кратною відстані повного кроку, а потім кожні

шар з'явиться на повному кроці.) Типовим значенням є False.
```

## Макроси та події G-коду

### [gcode_macro]

Макроси G-Code (можна визначити будь-яку кількість розділів із префіксом "gcode_macro"). Додаткову інформацію див. у посібнику з шаблонів команд.

```
[gcode_macro my_cmd] #gcode:

Список команд G-Code для виконання замість "my_cmd". див

docs/Command_Templates.md для формату G-Code. Цей параметр повинен

бути надано.

#variable_ :

Можна вказати будь-яку кількість параметрів із префіксом "variable_".

Даному імені змінної буде присвоєно вказане значення (розібрано

як літерал Python) і буде доступним під час розширення макросу.

Наприклад, конфігурація з "variable_fan_speed = 75" може мати

команди gcode, що містять "M106 S{fan_speed * 255 }". Змінні

можна змінити під час виконання за допомогою команди SET_GCODE_VARIABLE

(докладніше див. docs/Command_Templates.md). Імена змінних можуть

не використовувати символи верхнього регістру.

#rename_existing:

Цей параметр призведе до того, що макрос замінить існуючий G-код

команда та надайте попереднє визначення команди через

Тут указано # ім’я. Це можна використовувати для заміни вбудованого G-коду

команди. Слід бути обережним, перевизначаючи команди, наскільки це можливо

викликають складні та несподівані результати. За замовчуванням – ні

перевизначити існуючу команду G-коду.

#опис: макрос G-коду

Це додасть короткий опис, який використовується в команді HELP або під час

за допомогою функції автозаповнення. За умовчанням "макрос G-коду"
```

### [delayed_gcode]

Виконати gcode із встановленою затримкою. Для отримання додаткової інформації перегляньте посібник із шаблонів команд і довідку про команди.

```
[delayed_gcode my_delayed_gcode] gcode:

Список команд G-Code для виконання, якщо тривалість затримки має

минуло. Підтримуються шаблони G-Code. Цей параметр повинен бути

надано.

#початкова_тривалість: 0.0

Тривалість початкової затримки (у секундах). Якщо встановлено значення a

ненульове значення delayed_gcode виконає вказане число

секунд після переходу принтера в стан «готовність». Це може бути

корисно для процедур ініціалізації або повторюваного delayed_gcode.

Якщо встановлено значення 0, delayed_gcode не виконуватиметься під час запуску.

За замовчуванням 0.
```

### [зберегти_змінні]

Підтримка збереження змінних на диск, щоб вони зберігалися під час перезапусків. Щоб отримати додаткову інформацію, перегляньте [шаблони команд](Command_Templates.md#save-variables-to-disk) і [довідник G-Code](G-Codes.md#save_variables).

```
[зберегти_змінні]
 ім'я файлу:
 # Обов'язково - вкажіть ім'я файлу, яке використовуватиметься для збереження
 # змінні на диск, напр. ~/variables.cfg
```

### [idle_timeout]

Час простою. Тайм-аут простою вмикається автоматично - додайте явний розділ конфігурації idle_timeout, щоб змінити параметри за замовчуванням.

```
[idle_timeout] #gcode:

Список команд G-коду для виконання після тайм-ауту простою. див

docs/Command_Templates.md для формату G-Code. За замовчуванням запущено

"TURN_OFF_HEATERS" і "M84".

#тайм-аут: 600

Час простою (у секундах) перед запуском вищезазначеного G-коду

команди. За замовчуванням 600 секунд.
```

## Додаткові функції G-Code

### [virtual_sdcard]

Віртуальна sdcard може бути корисною, якщо хост-комп’ютер недостатньо швидкий для нормального запуску OctoPrint. Це дозволяє програмному забезпеченню хоста Klipper безпосередньо друкувати файли gcode, що зберігаються в каталозі на хості, за допомогою стандартних команд G-коду sdcard (наприклад, M24).

```
[virtual_sdcard]
 шлях:
 # Шлях до локального каталогу на головній машині, який потрібно шукати
 # файли g-code. Це каталог лише для читання (файл sdcard записує
 # не підтримуються). Це можна вказати на завантаження OctoPrint
 # каталог (зазвичай ~/.octoprint/uploads/ ). Цей параметр повинен
 # бути надано.
 #on_error_gcode:
 # Список команд G-Code для виконання, коли повідомляється про помилку.
 # Перегляньте docs/Command_Templates.md для формату G-коду. За умовчанням встановлено значення
 # запустити TURN_OFF_HEATERS.
```

### [sdcard_loop]

Деякі принтери з функціями очищення сцени, такі як виштовхувач частин або стрічковий принтер, можуть використовуватися в циклічних розділах файлу sdcard. (Наприклад, щоб друкувати ту саму деталь знову і знову або повторювати частину частини для ланцюжка чи іншого повторюваного візерунка).

Перегляньте [довідку про команди](G-Codes.md#sdcard_loop), щоб дізнатися про підтримувані команди. Перегляньте файл [sample-macros.cfg](../config/sample-macros.cfg) для макросу M808 G-Code, сумісного з Marlin.

```
[sdcard_loop]
```

### [force_move]

Підтримка рухомих крокових двигунів вручну для діагностичних цілей. Зауважте, що використання цієї функції може призвести до недійсного стану принтера - див. [довідку про команди](G-Codes.md#force_move), щоб отримати важливі відомості.

```
[force_move] #enable_force_move: Помилка

Установіть значення true, щоб увімкнути FORCE_MOVE і SET_KINEMATIC_POSITION

розширені команди G-коду. Типовим значенням є false.
```

### [pause_resume]

Функція паузи/відновлення з підтримкою захоплення та відновлення позиції. Додаткову інформацію див. у довідковій частині команд.

```
призупинити_відновити
```

### [firmware_retraction]

Втягування нитки прошивки. Це вмикає команди G10 (відкликати) і G11 (скасувати) GCODE, які видають багато зрізів. Наведені нижче параметри надають параметри запуску за замовчуванням, хоча значення можна налаштувати за допомогою [команди] SET_RETRACTION (G-Codes.md#firmware_retraction)), що дозволяє налаштовувати параметри для кожної нитки та час виконання.

```
[firmware_retraction] #retract_length: 0

Довжина нитки (у мм), яку потрібно втягнути, коли активовано G10,

і скасувати втягування, коли G11 активовано (але див

unretract_extra_length нижче). За замовчуванням 0 мм.

#retract_speed: 20

Швидкість втягування, мм/с. За замовчуванням 20 мм/с.

#unretract_extra_length: 0

Довжина (у мм) додаткової нитки, яку потрібно додати

скасування відкликання.

#unretract_speed: 10

Швидкість розвороту, мм/с. За замовчуванням 10 мм/с.
```

### [gcode_arcs]

Підтримка команд gcode arc (G2/G3).

```
[gcode_arcs] #роздільна здатність: 1.0

Дуга буде розділена на сегменти. Довжина кожного сегмента буде

дорівнює роздільній здатності в мм, встановленій вище. Менші значення дадуть a

тонша дуга, але також більше роботи для вашої машини. Дуги менші за

налаштоване значення стане прямими лініями. За замовчуванням

1mm.
```

### [відповісти]

Увімкніть розширені [команди] «M118» і «RESPOND» (G-Codes.md#respond).

```
[відповісти]
 #тип_за замовчуванням: луна
 # Встановлює префікс за замовчуванням для виходу "M118" і "RESPOND" на одиницю
 # з наступного:
 # echo: "echo: " (це за замовчуванням)
 # команда: "// "
 # помилка: "!!"
 #default_prefix: echo:
 # Безпосередньо встановлює префікс за умовчанням. Якщо присутнє, це значення буде
 # перевизначити "default_type".
```

### [exclude_object]

Вмикає підтримку для виключення або скасування окремих об’єктів під час процесу друку.

Додаткову інформацію див. у [посібнику з виключення об’єктів](Exclude_Object.md) і [довідці про команди](G-Codes.md#excludeobject). Перегляньте файл [sample-macros.cfg](../config/sample-macros.cfg) для макросу M486 G-Code, сумісного з Marlin/RepRapFirmware.

```
[exclude_object]
```

## Резонансна компенсація

### [input_shaper]

Вмикає компенсацію резонансу. Також перегляньте довідку про команди.

```
[input_shaper] #shaper_freq_x: 0

Частота (у Гц) вхідного формувача для осі X. Це є

зазвичай це резонансна частота осі X, яка вхідний формувач

слід придушити. Для більш складних формувачів, таких як 2- та 3-горби EI

формувачі вводу, цей параметр можна встановити з різних

міркування. Значення за замовчуванням — 0, що вимикає введення

формування для осі X.

#shaper_freq_y: 0

Частота (у Гц) вхідного формувача для осі Y. Це є

зазвичай це резонансна частота осі Y, що вхідний формувач

слід придушити. Для більш складних формувачів, таких як 2- та 3-горби EI

формувачі вводу, цей параметр можна встановити з різних

міркування. Значення за замовчуванням — 0, що вимикає введення

формування для осі Y.

#shaper_type: mzv

Тип формувача вхідних даних для використання як для осей X, так і для осей Y. Підтримується

формувачами є zv, mzv, zvd, ei, 2hump_ei і 3hump_ei. За замовчуванням

є формувачем вводу mzv.

#shaper_type_x: #shaper_type_y:

Якщо shaper_type не встановлено, можна використовувати ці два параметри

налаштувати різні форми введення для осей X і Y. Те саме

Підтримуються # значення параметра shaper_type. #damping_ratio_x: 0,1 #damping_ratio_y: 0,1

Коефіцієнти демпфування коливань осей X і Y, які використовуються вхідними формувачами

для покращення придушення вібрації. Значення за замовчуванням становить 0,1, тобто a

хороше універсальне значення для більшості принтерів. У більшості випадків це

параметр не потребує налаштування та не повинен змінюватися.
```

### [adxl345]

Підтримка акселерометрів ADXL345. Ця підтримка дозволяє запитувати вимірювання акселерометра від датчика. Це вмикає команду ACCELEROMETER_MEASURE (додаткову інформацію див. у [G-коди](G-Codes.md#adxl345). Назва мікросхеми за замовчуванням — «default», але можна вказати явну назву (наприклад, [adxl345 my_chip_name]).

```
[adxl345] cs_pin:

Штифт увімкнення SPI для датчика. Цей параметр необхідно вказати.

#spi_speed: 5000000

Швидкість SPI (у Гц), яка використовується під час обміну даними з чіпом.

За замовчуванням 5000000.

#spi_bus: #spi_software_sclk_pin: #spi_software_mosi_pin: #spi_software_miso_pin:

Перегляньте розділ «Загальні налаштування SPI», щоб отримати опис

параметр вище.

#axes_map: x, y, z

Вісь акселерометра для кожної з осей X, Y і Z принтера.

Це може бути корисним, якщо акселерометр встановлено в

орієнтація не відповідає орієнтації принтера. для

Наприклад, можна встановити значення "y, x, z", щоб поміняти місцями осі X і Y.

Також можна заперечити вісь, якщо акселерометр

напрямок змінюється (наприклад, "x, z, -y"). За замовчуванням "x, y, z".

#тариф: 3200

Вихідна швидкість передачі даних для ADXL345. ADXL345 підтримує такі дані

ставки: 3200, 1600, 800, 400, 200, 100, 50 і 25. Зауважте, що це

не рекомендується змінювати цю ставку з 3200 за замовчуванням, і

показники нижче 800 значно вплинуть на якість резонансу

вимірювання.
```

### [icm20948]

Support for icm20948 accelerometers.

```
[icm20948]
#i2c_address:
#   Default is 104 (0x68). If AD0 is high, it would be 0x69 instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [lis2dw]

Підтримка акселерометрів LIS2DW.

```
[lis2dw]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [lis3dh]

Підтримка акселерометрів LIS3DH.

```
[lis3dh]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [mpu9250]

Підтримка акселерометрів MPU-9250, MPU-9255, MPU-6515, MPU-6050 і MPU-6500 (можна визначити будь-яку кількість секцій з префіксом «mpu9250»).

```
[mpu9250 мій_акселерометр] #i2c_адреса:

За замовчуванням 104 (0x68). Якщо AD0 високий, замість нього буде 0x69.

#i2c_mcu: #i2c_bus: #i2c_software_scl_pin: #i2c_software_sda_pin: #i2c_швидкість: 400000

Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис

параметр вище. За замовчуванням "i2c_speed" становить 400000.

#axes_map: x, y, z

Перегляньте розділ "adxl345", щоб отримати інформацію про цей параметр.
```

### [resonance_tester]

Підтримка резонансного тестування та автоматичного калібрування формувача вхідного сигналу. Щоб використовувати більшу частину функціональних можливостей цього модуля, необхідно встановити додаткові програмні залежності; для отримання додаткової інформації зверніться до [Вимірювання резонансів](Measuring_Resonances.md) і [довідки щодо команд](G-Codes.md#resonance_tester). Перегляньте розділ [Максимальне згладжування](Measuring_Resonances.md#max-smoothing) посібника з вимірювання резонансів, щоб отримати додаткові відомості про параметр `max_smoothing` та його використання.

```
[resonance_tester]
#probe_points:
#   A list of X, Y, Z coordinates of points (one point per line) to test
#   resonances at. At least one point is required. Make sure that all
#   points with some safety margin in XY plane (~a few centimeters)
#   are reachable by the toolhead.
#accel_chip:
#   A name of the accelerometer chip to use for measurements. If
#   adxl345 chip was defined without an explicit name, this parameter
#   can simply reference it as "accel_chip: adxl345", otherwise an
#   explicit name must be supplied as well, e.g. "accel_chip: adxl345
#   my_chip_name". Either this, or the next two parameters must be
#   set.
#accel_chip_x:
#accel_chip_y:
#   Names of the accelerometer chips to use for measurements for each
#   of the axis. Can be useful, for instance, on bed slinger printer,
#   if two separate accelerometers are mounted on the bed (for Y axis)
#   and on the toolhead (for X axis). These parameters have the same
#   format as 'accel_chip' parameter. Only 'accel_chip' or these two
#   parameters must be provided.
#max_smoothing:
#   Maximum input shaper smoothing to allow for each axis during shaper
#   auto-calibration (with 'SHAPER_CALIBRATE' command). By default no
#   maximum smoothing is specified. Refer to Measuring_Resonances guide
#   for more details on using this feature.
#move_speed: 50
#   The speed (in mm/s) to move the toolhead to and between test points
#   during the calibration. The default is 50.
#min_freq: 5
#   Minimum frequency to test for resonances. The default is 5 Hz.
#max_freq: 133.33
#   Maximum frequency to test for resonances. The default is 133.33 Hz.
#accel_per_hz: 60
#   This parameter is used to determine which acceleration to use to
#   test a specific frequency: accel = accel_per_hz * freq. Higher the
#   value, the higher is the energy of the oscillations. Can be set to
#   a lower than the default value if the resonances get too strong on
#   the printer. However, lower values make measurements of
#   high-frequency resonances less precise. The default value is 75
#   (mm/sec).
#hz_per_sec: 1
#   Determines the speed of the test. When testing all frequencies in
#   range [min_freq, max_freq], each second the frequency increases by
#   hz_per_sec. Small values make the test slow, and the large values
#   will decrease the precision of the test. The default value is 1.0
#   (Hz/sec == sec^-2).
#sweeping_accel: 400
#   An acceleration of slow sweeping moves. The default is 400 mm/sec^2.
#sweeping_period: 1.2
#   A period of slow sweeping moves. Setting this parameter to 0
#   disables slow sweeping moves. Avoid setting it to a too small
#   non-zero value in order to not poison the measurements.
#   The default is 1.2 sec which is a good all-round choice.
```

## Помічники конфігураційних файлів

### [board_pins]

Псевдоніми контактів дошки (можна визначити будь-яку кількість розділів із префіксом "board_pins"). Використовуйте це, щоб визначити псевдоніми для контактів на мікроконтролері.

```
[board_pins my_aliases]
mcu: mcu
#   A comma separated list of micro-controllers that may use the
#   aliases. The default is to apply the aliases to the main "mcu".
aliases:
aliases_<name>:
#   A comma separated list of "name=value" aliases to create for the
#   given micro-controller. For example, "EXP1_1=PE6" would create an
#   "EXP1_1" alias for the "PE6" pin. However, if "value" is enclosed
#   in "<>" then "name" is created as a reserved pin (for example,
#   "EXP1_9=<GND>" would reserve "EXP1_9"). Any number of options
#   starting with "aliases_" may be specified.
```

### [включити]

Включити підтримку файлів. Можна включити додатковий файл конфігурації з основного файлу конфігурації принтера. Також можна використовувати символи підстановки (наприклад, "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

Цей інструмент дозволяє визначати один контакт мікроконтролера кілька разів у файлі конфігурації без звичайної перевірки помилок. Це призначено для діагностики та налагодження. Цей розділ непотрібний, якщо Klipper підтримує використання одного і того ж PIN-коду кілька разів, і використання цього перевизначення може призвести до незрозумілих і неочікуваних результатів.

```
[duplicate_pin_override]
шпильки:
# Розділений комами список пінів, які можна використовувати кілька разів
# конфігураційний файл без звичайної перевірки помилок. Цей параметр повинен бути
# надано.
```

## Обладнання для зондування ліжка

### [зонд]

Зонд висоти Z. Можна визначити цей розділ, щоб увімкнути обладнання для вимірювання висоти Z. Коли цей розділ увімкнено, PROBE та QUERY_PROBE розширені [команди g-коду] (G-Codes.md#probe) стають доступними. Також перегляньте [посібник із калібрування зонда](Probe_Calibrate.md). Розділ зонду також створює віртуальний пін «probe:z_virtual_endstop». Можна встановити stepper_z endstop_pin на цей віртуальний штифт на принтерах у декартовому стилі, які використовують зонд замість z endstop. Якщо використовується «probe:z_virtual_endstop», не визначайте position_endstop у розділі конфігурації stepper_z.

```
[зонд]
 прикріпити:
 # Штифт виявлення зонда. Якщо штифт знаходиться на іншому мікроконтролері
 # ніж Z-степери, то він дає змогу "наведення з кількома мікроконтроллерами". Це
 Потрібно вказати # параметр.
 #deactivate_on_each_sample: Правда
 # Це визначає, чи має Klipper виконувати gcode дезактивації
 # між кожною спробою тестування під час виконання кількох тестів
 # послідовність. Типовим значенням є True.
 #x_offset: 0,0
 # Відстань (у мм) між зондом і соплом уздовж
 # вісь х. За замовчуванням 0.
 #y_offset: 0,0
 # Відстань (у мм) між зондом і соплом уздовж
 # вісь y. За замовчуванням 0.
 z_offset:
 # Відстань (у мм) між ложем і соплом, коли зонд
 # тригери. Цей параметр необхідно вказати.
 #швидкість: 5.0
 # Швидкість (у мм/с) осі Z під час вимірювання. За замовчуванням 5 мм/с.
 #зразки: 1
 # Кількість разів для зондування кожної точки.  Досліджувані z-значення будуть
 # бути усередненим. За замовчуванням досліджується 1 раз.
 #sample_retract_dist: 2.0
 # Відстань (у мм), щоб підняти інструментальну головку між кожним зразком (якщо
 # вибірка більше одного разу). За замовчуванням 2 мм.
 #ліфт_швидкість:
 # Швидкість (у мм/с) осі Z під час підняття зонда між
 # зразків. За умовчанням використовується те саме значення, що й «швидкість».
 # параметр.
 #samples_result: середній
 # Метод розрахунку при вибірці більше одного разу - будь-який
 # "медіана" або "середнє". За умовчанням встановлено середнє значення.
 #samples_tolerance: 0,100
 # Максимальна відстань Z (у мм), якою зразок може відрізнятися від інших
 # зразків. Якщо цей допуск перевищено, то є помилка
 # повідомлено або спробу розпочато повторно (див
 # samples_tolerance_retries). За замовчуванням 0,100 мм.
 #samples_tolerance_retries: 0
 # Кількість повторів, якщо знайдено зразок, що перевищує
 # зразки_допуску. Під час повторної спроби всі поточні зразки скидаються
 # і спроба зонду розпочнеться повторно. Якщо дійсний набір зразків є
 # не отримано за задану кількість повторів, тоді виникає помилка
 # повідомлено. За умовчанням дорівнює нулю, що спричиняє повідомлення про помилку
 # на першому зразку, який перевищує samples_tolerance.
 #activate_gcode:
 # Список команд G-коду для виконання перед кожною спробою зондування.
 # Перегляньте docs/Command_Templates.md для формату G-коду. Це може бути
 # корисно, якщо зонд потрібно якимось чином активувати. не треба
 # видати тут будь-які команди, які переміщують інструментальну головку (наприклад, G1). The
 # За замовчуванням під час активації не запускаються спеціальні команди G-коду.
 #deactivate_gcode:
 # Список команд G-Code для виконання після кожної спроби зонду
 # виконано. Перегляньте docs/Command_Templates.md для формату G-коду. не треба
 # видайте тут будь-які команди, які переміщують інструментальну головку. Типовим значенням є
 # не запускати жодних спеціальних команд G-Code після деактивації.
```

### [bltouch]

Зонд BLTouch. Можна визначити цей розділ (замість розділу зонда), щоб увімкнути зонд BLTouch. Додаткову інформацію див. у посібнику BL-Touch і командній довідці. Також створюється віртуальний пін «probe:z_virtual_endstop» (детальніше див. розділ «зонд»).

```
[bltouch] sensor_pin:

Штифт, підключений до контакту датчика BLTouch. Більшість пристроїв BLTouch

вимагають підтягування контакту датчика (префікс назви контакту "^").

Цей параметр необхідно вказати.

control_pin:

Штифт, підключений до контакту керування BLTouch. Цей параметр повинен бути

надано.

#pin_move_time: 0,680

Час (у секундах), який потрібно очікувати на пін BLTouch

рух вгору або вниз. За замовчуванням 0,680 секунди.

#stow_on_each_sample: Правда

Це визначає, чи має Кліппер наказувати шпильці рухатися вгору

між кожною спробою тестування під час виконання кількох тестів

послідовність. Перед налаштуванням прочитайте вказівки в docs/BLTouch.md

це на False. Типовим значенням є True.

#probe_with_touch_mode: False

Якщо для цього значення встановлено значення True, тоді Klipper виконуватиме зондування з пристроєм

"сенсорний_режим". За замовчуванням значення False (зондування в режимі "pin_down").

#pin_up_reports_not_triggered: Правда

Установіть, якщо BLTouch постійно повідомляє про зонд у "not

triggered" стан після успішної команди "pin_up". Це повинно

бути вірним для всіх справжніх пристроїв BLTouch. Прочитайте вказівки в

docs/BLTouch.md, перш ніж встановити значення False. Типовим значенням є True.

#pin_up_touch_mode_reports_triggered: Правда

Установіть, якщо BLTouch постійно повідомляє про «запущений» стан після

команди "pin_up", а потім "touch_mode". Це повинно бути

Вірно для всіх справжніх пристроїв BLTouch. Прочитайте вказівки в

docs/BLTouch.md, перш ніж встановити значення False. Типовим значенням є True.

#set_output_mode:

Запит на певний режим виведення контактів датчика на BLTouch V3.0 (і

пізніше). Цей параметр не слід використовувати для інших типів датчиків.

Встановіть значення "5V", щоб вимагати вихідну напругу датчика 5 В (використовуйте, лише якщо

платі контролера потрібен режим 5 В і він толерантний до 5 В на вході

сигнальна лінія). Встановіть значення "OD", щоб надіслати запит на використання вихідного контакту датчика

відкритий режим зливу. За замовчуванням режим виведення не запитується.

#x_offset: #y_offset: #z_offset: #швидкість: #ліфт_швидкість: #зразки: #sample_retract_dist: #samples_result: #samples_tolerance: #samples_tolerance_retries:

Перегляньте розділ "зонд", щоб отримати інформацію про ці параметри.
```

### [smart_effector]

«Розумний ефектор» від Duet3d реалізує зонд Z за допомогою датчика сили. Можна визначити цей розділ замість `[probe]`, щоб увімкнути особливі функції Smart Effector. Це також дає змогу [командам виконання] (G-Codes.md#smart_effector) регулювати параметри Smart Effector під час виконання.

```
[smart_effector]
 прикріпити:
 # Штифт, підключений до вихідного контакту зонда Smart Effector Z (контакт 5). Зауважте, що
 # Підтягуючий резистор на платі зазвичай не потрібен. Однак, якщо
 # вихідний висновок підключений до контакту плати за допомогою підтягуючого резистора, тобто
 # резистор має мати велике значення (наприклад, 10 кОм або більше). Деякі дошки мають низький
 # значення підтягуючого резистора на вході датчика Z, що, ймовірно, призведе до
 # стан зонда, що завжди запускається. У цьому випадку підключіть Smart Effector до
 # інший контакт на платі. Цей параметр обов'язковий.
 #control_pin:
 # Штифт, підключений до вхідного контакту керування Smart Effector (контакт 7). Якщо передбачено,
 # Стають доступними команди програмування чутливості Smart Effector.
 #probe_accel:
 # Якщо встановлено, обмежує прискорення рухів зондування (у мм/с^2).
 # Можливе раптове велике прискорення на початку зондувального руху
 # спричинити помилкове спрацьовування зонда, особливо якщо хотенд важкий.
 # Щоб запобігти цьому, може знадобитися зменшити прискорення
 # зондування рухається через цей параметр.
 #час_відновлення: 0,4
 # Затримка в секундах між рухом руху та рухом зондування. Швидкий
 # пересування перед зондуванням може призвести до помилкового запуску зонда.
 # Це може спричинити помилку «Зонд спрацьовує перед рухом», якщо немає затримки
 # встановлено. Значення 0 вимикає затримку відновлення.
 # Значення за замовчуванням 0,4.
 #x_offset:
 #y_offset:
 # Не має бути встановлено (або встановлено на 0).
 z_offset:
 # Висота тригера зонда. Почніть з -0,1 (мм) і налаштуйте пізніше за допомогою
 # Команда `PROBE_CALIBRATE`. Цей параметр необхідно вказати.
 #швидкість:
 # Швидкість (у мм/с) осі Z під час вимірювання. Рекомендується почати
 # зі швидкістю зондування 20 мм/с і відрегулюйте її за необхідності для покращення
 # точність і повторюваність спрацьовування зонда.
 #зразки:
 #sample_retract_dist:
 #samples_result:
 #samples_tolerance:
 #samples_tolerance_retries:
 #activate_gcode:
 #deactivate_gcode:
 #deactivate_on_each_sample:
 # Перегляньте розділ "зонд", щоб отримати додаткові відомості про параметри вище.
```

### [probe_eddy_current]

Підтримка вихрострумових індуктивних зондів. Можна визначити цей розділ (замість розділу зонда), щоб увімкнути це зондування. Дивіться [довідку про команди](G-Codes.md#probe_eddy_current) для отримання додаткової інформації.

```
[probe_eddy_current my_eddy_probe]
sensor_type: ldc1612
#   The sensor chip used to perform eddy current measurements. This
#   parameter must be provided and must be set to ldc1612.
#frequency:
#   The external crystal frequency (in Hz) of the LDC1612 chip.
#   The default is 12000000.
#intb_pin:
#   MCU gpio pin connected to the ldc1612 sensor's INTB pin (if
#   available). The default is to not use the INTB pin.
#z_offset:
#   The nominal distance (in mm) between the nozzle and bed that a
#   probing attempt should stop at. This parameter must be provided.
#i2c_address:
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   The i2c settings for the sensor chip. See the "common I2C
#   settings" section for a description of the above parameters.
#x_offset:
#y_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   See the "probe" section for information on these parameters.
```

### [axis_twist_compensation]

Інструмент для компенсації неточних показань датчика через скручування в гентрі X або Y. Перегляньте [Посібник з компенсації скручування осі](Axis_Twist_Compensation.md), щоб отримати докладнішу інформацію щодо симптомів, конфігурації та налаштування.

```
[axis_twist_compensation]
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
calibrate_start_x: 20
#   Defines the minimum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the starting
#   calibration position.
calibrate_end_x: 200
#   Defines the maximum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the ending
#   calibration position.
calibrate_y: 112.5
#   Defines the Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle during the
#   calibration process. This parameter is recommended to
#   be near the center of the bed

# For Y-axis twist compensation, specify the following parameters:
calibrate_start_y: ...
#   Defines the minimum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the starting
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_end_y: ...
#   Defines the maximum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the ending
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_x: ...
#   Defines the X coordinate of the calibration for Y axis twist compensation
#   This should be the X coordinate that positions the nozzle during the
#   calibration process for Y axis twist compensation. This parameter must be
#   provided and is recommended to be near the center of the bed.
```

## Додаткові крокові двигуни та екструдери

### [stepper_z1]

Багатокрокові осі. На принтері в декартовому стилі кроковий механізм, який керує заданою віссю, може мати додаткові конфігураційні блоки, що визначають крокові кроки, які мають працювати разом із основним кроковим механізмом. Можна визначити будь-яку кількість розділів із цифровим суфіксом, починаючи з 1 (наприклад, «stepper_z1», «stepper_z2» тощо).

```
[stepper_z1]
 #step_pin:
 #dir_pin:
 #enable_pin:
 #мікрокроки:
 #rotation_distance:
 # Дивіться розділ «кроковий» для визначення наведених вище параметрів.
 #endstop_pin:
 # Якщо endstop_pin визначено для додаткового кроку, то
 # степер повертається, доки не спрацює кінцевий упор. В іншому випадку,
 # степпер буде повертатися до кінцевого упору на основному степпері для
 Спрацьовує # вісь.
```

### [екструдер1]

У мультиекструдерному принтері додайте додаткову секцію екструдера для кожного додаткового екструдера. Додаткові секції екструдера мають називатися «екструдер1», «екструдер2», «екструдер3» і так далі. Опис доступних параметрів див. у розділі «Екструдер».

Перегляньте [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg) для прикладу конфігурації.

```
[екструдер1] #step_pin: #dir_pin: #...

Дивіться розділ «Екструдер», щоб дізнатися про доступні кроковий механізм і нагрівач

параметри.

#спільний_обігрівач:

Цей параметр застарів і його більше не слід вказувати.
```

### [dual_carriage]

Support for cartesian, generic_cartesian and hybrid_corexy/z printers with dual carriages on a single axis. The carriage mode can be set via the SET_DUAL_CARRIAGE extended g-code command. For example, "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation. Note that during G28 homing, typically the primary carriage is homed first followed by the carriage defined in the `[dual_carriage]` config section. However, the `[dual_carriage]` carriage will be homed first if both carriages home in a positive direction and the [dual_carriage] carriage has a `position_endstop` greater than the primary carriage, or if both carriages home in a negative direction and the `[dual_carriage]` carriage has a `position_endstop` less than the primary carriage.

Крім того, можна використовувати команди «SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY» або «SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR», щоб активувати режим копіювання або дзеркального відображення подвійної каретки, у цьому випадку вона відповідним чином слідуватиме руху каретки 0. . Ці команди можна використовувати для друку двох частин одночасно - двох ідентичних частин (у режимі КОПІЮВАННЯ) або дзеркальних частин (у режимі ДЗЕРКАЛО). Зауважте, що режими COPY та MIRROR також вимагають відповідної конфігурації екструдера на подвійній каретці, що зазвичай можна досягти за допомогою "SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=<dual_carriage_extruder> " або подібна команда.

See [sample-idex.cfg](../config/sample-idex.cfg) for an example configuration with a regular Cartesian kinematic.

```
[dual_carriage]
axis:
#   The axis this extra carriage is on (either x or y). This parameter
#   must be provided.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carriages), the carriages proximity
#   checks will be disabled.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   See the "stepper" section for the definition of the above parameters.
```

For an example of dual carriage configuration with `generic_cartesian` kinematic, see the following configuration [sample](../config/example-generic-caretesian.cfg). Please note that in this case the `[dual_carriage]` configuration deviates from the configuration described above:

```
[dual_carriage my_dc_carriage]
primary_carriage:
#   Defines the matching primary carriage of this dual carriage and
#   the corresponding IDEX axis. Valid choices are x, y, z.
#   This parameter must be provided.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carriages), the carriages proximity
#   checks will be disabled.
endstop_pin:
#position_min:
position_endstop:
position_max:
#homing_speed:
#homing_retract_dist:
#homing_retract_speed:
#second_homing_speed:
#homing_positive_dir:
...
```

Refer to [generic cartesian](#generic-cartesian) section for more information on the regular `carriage` parameters.

Then a user must define one or more stepper motors moving the dual carriage (and other carriages as appropriate), for instance

```
[carriage x]
...

[carriage y]
...

[dual_carriage u]
primary_carriage: x
...

[stepper dc_stepper]
carriages: u-y
...
```

`[dual_carriage]` requires special configuration for the input shaper. In general, it is necessary to run input shaper calibration twice - for the `dual_carriage` and its `primary_carriage` for the axis they share. Then the input shaper can be configured as follows, assuming the example above:

```
[input_shaper]
# Intentionally empty

[delayed_gcode init_shaper]
initial_duration: 0.1
gcode:
  SET_DUAL_CARRIAGE CARRIAGE=u
  SET_INPUT_SHAPER SHAPER_TYPE_X=<dual_carriage_x_shaper> SHAPER_FREQ_X=<dual_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
  SET_DUAL_CARRIAGE CARRIAGE=x
  SET_INPUT_SHAPER SHAPER_TYPE_X=<primary_carriage_x_shaper> SHAPER_FREQ_X=<primary_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
```

Note that `SHAPER_TYPE_Y` and `SHAPER_FREQ_Y` must be the same in both commands in this case, since the same motors drive Y axis when either of the `x` and `u` carriages are active.

It is worth noting that `generic_cartesian` kinematic can support two dual carriages for X and Y axes. For reference, see for instance a [sample](../config/sample-corexyuv.cfg) of CoreXYUV configuration.

### [extruder_stepper]

Підтримка додаткових степерів, синхронізованих з рухом екструдера (можна визначити будь-яку кількість секцій з префіксом "extruder_stepper").

Додаткову інформацію див. у [довідці щодо команд](G-Codes.md#extruder).

```
[extruder_stepper my_extra_stepper] екструдер:

Екструдер, з яким синхронізовано цей степер. Якщо для цього встановлено значення an

пустий рядок, тоді степпер не буде синхронізовано з an

екструдер. Цей параметр необхідно вказати.

#step_pin: #dir_pin: #enable_pin: #мікрокроки: #rotation_distance:

Перегляньте розділ «степпер» для визначення наведеного вище

параметри.
```

### [ручний_степпер]

Ручні степпери (можна визначити будь-яку кількість секцій з префіксом "ручний_степер"). Це степери, які керуються командою g-коду MANUAL_STEPPER. Наприклад: "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". Опис команди MANUAL_STEPPER див. у файлі G-Codes. Степери не пов’язані зі звичайною кінематикою принтера.

```
[manual_stepper my_stepper]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   See the "stepper" section for a description of these parameters.
#velocity:
#   Set the default velocity (in mm/s) for the stepper. This value
#   will be used if a MANUAL_STEPPER command does not specify a SPEED
#   parameter. The default is 5mm/s.
#accel:
#   Set the default acceleration (in mm/s^2) for the stepper. An
#   acceleration of zero will result in no acceleration. This value
#   will be used if a MANUAL_STEPPER command does not specify an ACCEL
#   parameter. The default is zero.
#endstop_pin:
#   Endstop switch detection pin. If specified, then one may perform
#   "homing moves" by adding a STOP_ON_ENDSTOP parameter to
#   MANUAL_STEPPER movement commands.
#position_min:
#position_max:
#   The minimum and maximum position the stepper can be commanded to
#   move to. If specified then one may not command the stepper to move
#   past the given position. Note that these limits do not prevent
#   setting an arbitrary position with the `MANUAL_STEPPER
#   SET_POSITION=x` command. The default is to not enforce a limit.
```

## Нагрівачі та датчики на замовлення

### [verify_heater]

Повірка обігрівача і датчика температури. Перевірка нагрівача автоматично вмикається для кожного нагрівача, налаштованого на принтері. Використовуйте розділи verify_heater, щоб змінити налаштування за замовчуванням.

```
[verify_heater heater_config_name]
 #max_error: 120
 # Максимальна "сукупна температурна помилка" перед підвищенням an
 # помилка. Менші значення призводять до суворішої перевірки, а більші
 # значення дозволяють пройти більше часу, перш ніж буде повідомлено про помилку.
 # Зокрема, температура перевіряється раз на секунду і якщо вона
 # близька до цільової температури, тоді внутрішня "помилка
 # лічильник" скидається; інакше, якщо температура нижча
 # діапазон цілі, тоді лічильник збільшується на величину the
 # зареєстрована температура відрізняється від цього діапазону. Слід лічильник
 # перевищує це "max_error", тоді виникає помилка. За замовчуванням
 # 120.
 #check_gain_time:
 # Це контролює перевірку нагрівача під час початкового нагрівання. Менший
 # значення призводять до суворішої перевірки та дозволяють більші значення
 Ще # раз до повідомлення про помилку. Зокрема, під час
 # початкове нагрівання, доки температура нагрівача підвищується
 # протягом цього періоду часу (зазначеного в секундах), а потім внутрішнього
 # "лічильник помилок" скинуто. За замовчуванням 20 секунд для екструдерів
 # і 60 секунд для heater_bed.
 #гістерезис: 5
 # Максимальна різниця температур (у градусах Цельсія) до цілі
 # температура, яка вважається в діапазоні цілі. Це
 # контролює перевірку діапазону max_error. Це рідко можна налаштувати
 # значення. За замовчуванням 5.
 #посилення_нагріву: 2
 # Мінімальна температура (у градусах Цельсія), яку має підвищити нагрівач
 # під час перевірки check_gain_time.  Це рідко можна налаштувати
 # значення. За замовчуванням 2.
```

### [homing_heaters]

Інструмент для відключення нагрівачів під час наведення або зондування осі.

```
[homing_heaters] #степери:

Відокремлений комами список степперів, які мають викликати нагрівачі

вимкнено. За замовчуванням нагрівачі вимикаються для будь-якого наведення/зондування

рух.

Типовий приклад: stepper_z

#нагрівачі:

Розділений комами список нагрівачів, які потрібно вимкнути під час наведення/зондування

ходи. За замовчуванням усі нагрівачі вимкнено.

Типовий приклад: екструдер, heater_bed
```

### [термістор]

Нестандартні терморезистори (можна визначити будь-яку кількість секцій з префіксом «термістор»). Спеціальний термістор можна використовувати в полі sensor_type розділу конфігурації нагрівача. (Наприклад, якщо визначено розділ «[thermistor my_thermistor]», тоді можна використовувати «sensor_type: my_thermistor» під час визначення нагрівача.) Обов’язково розмістіть розділ термістора у файлі конфігурації над його першим використанням у розділі нагрівача. .

```
[термістор my_thermistor]
 #temperature1:
 #опір1:
 #temperature2:
 #опір2:
 #temperature3:
 #опір3:
 # Три вимірювання опору (в Омах) при заданих температурах
 # (у градусах Цельсія). Три вимірювання будуть використані для розрахунку
 # Коефіцієнти Штейнхарта-Харта для термістора. Ці параметри
 У разі використання Steinhart-Hart для визначення необхідно вказати #
 #термістор.
 #бета:
 # Крім того, можна визначити температуру1, опір1 та бета
 # для визначення параметрів термістора. Цей параметр повинен бути
 # надається при використанні "бета" для визначення термістора.
```

### [adc_temperature]

Спеціальні датчики температури ADC (можна визначити будь-яку кількість секцій з префіксом "adc_temperature"). Це дозволяє визначити настроюваний датчик температури, який вимірює напругу на контакті аналого-цифрового перетворювача (АЦП) і використовує лінійну інтерполяцію між набором налаштованих вимірювань температури/напруги (або температури/опору) для визначення температури. Отриманий датчик можна використовувати як тип датчика в секції нагрівача. (Наприклад, якщо визначено розділ «[adc_temperature my_sensor]», тоді можна використовувати «sensor_type: my_sensor» під час визначення нагрівача.) Обов’язково розмістіть розділ датчика у файлі конфігурації над його першим використанням у розділі нагрівача. .

```
[adc_temperature my_sensor] #temperature1: #voltage1: #temperature2: #voltage2: #...

Набір температур (у градусах Цельсія) і напруг (у вольтах) для використання

як еталон під час перетворення температури. Використання секції обігрівача

цей датчик також може вказувати adc_voltage і voltage_offset

параметри для визначення напруги АЦП (див. «Загальна температура

підсилювачі" для детальної інформації). Необхідно провести принаймні два вимірювання

бути надано.

#temperature1: #опір1: #temperature2: #опір2: #...

Крім того, можна вказати набір температур (у градусах Цельсія)

і опір (в Омах) для використання в якості еталонного під час перетворення a

температура. Секція нагрівача, яка використовує цей датчик, також може вказувати a

параметр pullup_resistor (подробиці див. у розділі «екструдер»). на

необхідно надати принаймні два вимірювання.
```

### [heater_generic]

Загальні нагрівачі (можна визначити будь-яку кількість розділів з префіксом "heater_generic"). Ці нагрівачі поводяться подібно до стандартних нагрівачів (екструдерів, ліжок з підігрівом). Використовуйте команду SET_HEATER_TEMPERATURE (додаткову інформацію див. у G-Codes), щоб установити цільову температуру.

```
[heater_generic my_generic_heater] #gcode_id:

Ідентифікатор для використання під час повідомлення температури в команді M105.

Цей параметр необхідно вказати.

#heater_pin: #max_power: #sensor_type: #sensor_pin: #smooth_time: #control: #pid_Kp: #pid_Ki: #pid_Kd: #pwm_cycle_time: #min_temp: #max_temp:

See the "extruder" section for the definition of the above

параметри.
```

### [temperature_sensor]

Загальні датчики температури. Можна визначити будь-яку кількість додаткових датчиків температури, які повідомляються за допомогою команди M105.

```
[датчик_температури мій_сенсор]
 #sensor_type:
 #sensor_pin:
 #min_temp:
 #max_temp:
 # Дивіться розділ «екструдер» для визначення наведеного вище
 # параметри.
 #gcode_id:
 # Перегляньте розділ "heater_generic" для визначення цього
 # параметр.
```

### [temperature_probe]

Повідомляє температуру котушки датчика. Включає додаткове калібрування теплового дрейфу для датчиків на основі вихрових струмів. Секція `[temperature_probe]` може бути пов’язана з `[probe_eddy_current]` за допомогою того самого постфікса для обох секцій.“

```
[temperature_probe my_probe]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Temperature sensor configuration.
#   See the "extruder" section for the definition of the above
#   parameters.
#smooth_time:
#   A time value (in seconds) over which temperature measurements will
#   be smoothed to reduce the impact of measurement noise. The default
#   is 2.0 seconds.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
#speed:
#   The travel speed [mm/s] for xy moves during calibration.  Default
#   is the speed defined by the probe.
#horizontal_move_z:
#   The z distance [mm] from the bed at which xy moves will occur
#   during calibration. Default is 2mm.
#resting_z:
#   The z distance [mm] from the bed at which the tool will rest
#   to heat the probe coil during calibration.  Default is .4mm
#calibration_position:
#   The X, Y, Z position where the tool should be moved when
#   probe drift calibration initializes.  This is the location
#   where the first manual probe will occur.  If omitted, the
#   default behavior is not to move the tool prior to the first
#   manual probe.
#calibration_bed_temp:
#   The maximum safe bed temperature (in C) used to heat the probe
#   during probe drift calibration.  When set, the calibration
#   procedure will turn on the bed after the first sample is
#   taken.  When the calibration procedure is complete the bed
#   temperature will be set to zero.  When omitted the default
#   behavior is not to set the bed temperature.
#calibration_extruder_temp:
#   The extruder temperature (in C) set probe during drift calibration.
#   When this option is supplied the procedure will wait for until the
#   specified temperature is reached before requesting the first manual
#   probe.  When the calibration procedure is complete the extruder
#   temperature will be set to 0.  When omitted the default behavior is
#   not to set the extruder temperature.
#extruder_heating_z: 50.
#   The Z location where extruder heating will occur if the
#   "calibration_extruder_temp" option is set.  Its recommended to heat
#   the extruder some distance from the bed to minimize its impact on
#   the probe coil temperature.  The default is 50.
#max_validation_temp: 60.
#   The maximum temperature used to validate the calibration.  It is
#   recommended to set this to a value between 100 and 120 for enclosed
#   printers.  The default is 60.
```

## Датчики температури

Klipper містить визначення для багатьох типів датчиків температури. Ці датчики можна використовувати в будь-якому розділі конфігурації, для якого потрібен датчик температури (наприклад, у розділі  [extruder]  або  [heater_bed] ).

### Звичайні термістори

Звичайні термістори. Наступні параметри доступні в секціях нагрівача, які використовують один із цих датчиків.

```
тип_датчика:
 # Один із "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
 # "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
 # "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
 # "SliceEngineering 450" або "TDK NTCG104LH104JT1"
 sensor_pin:
 # Аналоговий вхід, підключений до термістора. Цей параметр повинен
 # бути надано.
 #pullup_resistor: 4700
 # Опір (в Омах) підтягування, підключеного до термістора.
 # За замовчуванням 4700 Ом.
 #inline_resistor: 0
 # Опір (в Омах) додаткового (не змінного нагріву) резистора
 # який розміщено в одній лінії з термістором. Таке встановлюється рідко.
 # За замовчуванням 0 Ом.
```

### Загальні підсилювачі температури

Загальні підсилювачі температури. Наступні параметри доступні в секціях нагрівача, які використовують один із цих датчиків.

```
тип_датчика:
 # Один із «PT100 INA826», «AD595», «AD597», «AD8494», «AD8495»,
 # "AD8496" або "AD8497".
 sensor_pin:
 # Аналоговий вхід, підключений до датчика. Цей параметр повинен бути
 # надано.
 #adc_voltage: 5,0
 # Напруга порівняння АЦП (у вольтах). За замовчуванням 5 вольт.
 #voltage_offset: 0
 # Зсув напруги АЦП (у вольтах). За замовчуванням 0.
```

### Безпосередньо підключений датчик PT1000

Безпосередньо підключений датчик PT1000. Наступні параметри доступні в секціях нагрівача, які використовують один із цих датчиків.

```
тип датчика: PT1000
 sensor_pin:
 # Аналоговий вхід, підключений до датчика. Цей параметр повинен бути
 # надано.
 #pullup_resistor: 4700
 # Опір (в Омах) підтягування, прикріпленого до датчика. The
 # за замовчуванням 4700 Ом.
```

### Датчики температури MAXxxxxx

Датчики температури на основі послідовного периферійного інтерфейсу (SPI) MAXxxxxx. Наступні параметри доступні в секціях нагрівача, які використовують один із цих типів датчиків.

```
тип_датчика:
 # Один із «MAX6675», «MAX31855», «MAX31856» або «MAX31865».
 sensor_pin:
 # Лінія вибору чіпа для чіпа датчика. Цей параметр повинен бути
 # надано.
 #spi_speed: 4000000
 # Швидкість SPI (у Гц), яка використовується під час обміну даними з чіпом.
 # За замовчуванням 4000000.
 #spi_bus:
 #spi_software_sclk_pin:
 #spi_software_mosi_pin:
 #spi_software_miso_pin:
 # Перегляньте розділ «Загальні налаштування SPI», щоб отримати опис
 # параметр вище.
 #tc_type: К
 #tc_use_50Hz_filter: помилка
 #tc_everaging_count: 1
 # Наведені вище параметри керують параметрами датчика MAX31856
 # фішки. Значення за замовчуванням для кожного параметра вказані поруч із параметром
 # ім'я у списку вище.
 #rtd_nominal_r: 100
 #rtd_reference_r: 430
 #rtd_num_of_wires: 2
 #rtd_use_50Hz_filter: помилка
 # Наведені вище параметри керують параметрами датчика MAX31865
 # фішки. Значення за замовчуванням для кожного параметра вказані поруч із параметром
 # ім'я у списку вище.
```

### Датчик температури BMP180/BMP280/BME280/BMP388/BME680

BMP180/BMP280/BME280/BMP388/BME680 двопровідні датчики навколишнього середовища (I2C). Зауважте, що ці датчики не призначені для використання з екструдерами та нагрівальними ліжками, а скоріше для моніторингу температури навколишнього середовища (C), тиску (hPa), відносної вологості та у випадку рівня газу BME680. Перегляньте sample-macros.cfg для макросу gcode_macro, який можна використовувати для повідомлення тиску та вологості на додаток до температури.

```
тип_датчика: BME280
 #i2c_адреса:
 # За замовчуванням 118 (0x76). Датчики BMP180, BMP388 і деякі BME280
 # мають адресу 119 (0x77).
 #i2c_mcu:
 #i2c_bus:
 #i2c_software_scl_pin:
 #i2c_software_sda_pin:
 #i2c_швидкість:
 # Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис
 # параметр вище.
```

### AHT10/AHT20/AHT21 temperature sensor

Датчики навколишнього середовища з двопровідним інтерфейсом (I2C) AHT10/AHT20/AHT21. Зауважте, що ці датчики не призначені для використання з екструдерами та нагрівальними ліжками, а скоріше для моніторингу температури навколишнього середовища (C) і відносної вологості. Перегляньте sample-macros.cfg для gcode_macro, який можна використовувати для повідомлення вологості на додаток до температури.

```
тип датчика: AHT10
 # Також використовуйте AHT10 для датчиків AHT20 і AHT21.
 #i2c_адреса:
 # За замовчуванням 56 (0x38). Деякі датчики AHT10 дають можливість використовувати
 # 57 (0x39) шляхом переміщення резистора.
 #i2c_mcu:
 #i2c_bus:
 #i2c_швидкість:
 # Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис
 # параметр вище.
 #aht10_report_time:
 # Інтервал у секундах між читаннями. За замовчуванням 30, мінімум 5
```

### Датчик HTU21D

Датчик навколишнього середовища сімейства HTU21D з двопровідним інтерфейсом (I2C). Зауважте, що цей датчик не призначений для використання з екструдерами та нагрівальними ліжками, а скоріше для моніторингу температури навколишнього середовища (C) і відносної вологості. Перегляньте sample-macros.cfg для gcode_macro, який можна використовувати для повідомлення вологості на додаток до температури.

```
тип_датчика:
 # Має бути "HTU21D", "SI7013", "SI7020", "SI7021" або "SHT21"
 #i2c_адреса:
 # За замовчуванням 64 (0x40).
 #i2c_mcu:
 #i2c_bus:
 #i2c_software_scl_pin:
 #i2c_software_sda_pin:
 #i2c_швидкість:
 # Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис
 # параметр вище.
 #htu21d_hold_master:
 # Якщо датчик може утримувати буфер I2C під час читання. Якщо True, немає іншого
 # Зв'язок по шині може здійснюватися під час читання.
 # За замовчуванням значення False.
 #htu21d_resolution:
 # Роздільна здатність зчитування температури та вологості.
 # Дійсні значення:
 # 'TEMP14_HUM12' -> 14 біт для температури та 12 біт для вологості
 # 'TEMP13_HUM10' -> 13 біт для температури та 10 біт для вологості
 # 'TEMP12_HUM08' -> 12 біт для температури та 08 біт для вологості
 # 'TEMP11_HUM11' -> 11 біт для температури та 11 біт для вологості
 # За замовчуванням: "TEMP11_HUM11"
 #htu21d_report_time:
 # Інтервал у секундах між читаннями. За замовчуванням 30
```

### Датчик SHT3X

Датчик навколишнього середовища сімейства SHT3X з двопровідним інтерфейсом (I2C). Ці датчики мають діапазон -55~125 C, тому їх можна використовувати, наприклад, для контроль температури камери. Вони також можуть функціонувати як прості контролери вентилятора/нагрівача.

```
тип_датчика: SHT3X
 #i2c_адреса:
 # За замовчуванням 68 (0x44).
 #i2c_mcu:
 #i2c_bus:
 #i2c_software_scl_pin:
 #i2c_software_sda_pin:
 #i2c_швидкість:
 # Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис
 # параметр вище.
```

### Датчик температури LM75

LM75/LM75A двопровідні (I2C) датчики температури. Ці датчики мають діапазон -55~125 C, тому їх можна використовувати, наприклад, для моніторингу температури в камері. Вони також можуть функціонувати як прості контролери вентилятора/нагрівача.

```
тип датчика: LM75
 #i2c_адреса:
 # За замовчуванням 72 (0x48). Нормальний діапазон становить 72-79 (0x48-0x4F) і 3
 # молодших бітів адреси налаштовуються через контакти на мікросхемі
 # (зазвичай з перемичками або з жорстким проводом).
 #i2c_mcu:
 #i2c_bus:
 #i2c_software_scl_pin:
 #i2c_software_sda_pin:
 #i2c_швидкість:
 # Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис
 # параметр вище.
 #lm75_report_time:
 # Інтервал у секундах між читаннями. За замовчуванням 0,8, мінімальний
 # 0,5.
```

### Вбудований датчик температури мікроконтролера

Мікроконтролери atsam, atsamd і stm32 містять внутрішній датчик температури. Для моніторингу цих температур можна використовувати датчик «temperature_mcu».

```
тип_датчика: temperature_mcu
 #sensor_mcu: mcu
 # Мікроконтролер для читання. Типовим є "mcu".
 #sensor_temperature1:
 #sensor_adc1:
 # Вкажіть два параметри вище (температуру в градусах Цельсія та ан
 # Значення АЦП як плаваюче значення між 0,0 і 1,0) для калібрування
 # мікроконтролер температури. Це може покращити звіт
 # точність температури на деяких мікросхемах. Типовий спосіб отримати це
 # інформація про калібрування полягає в повному відключенні живлення від
 # принтер протягом кількох годин (щоб переконатися, що він знаходиться при температурі навколишнього середовища
 # температура), потім увімкніть його та скористайтеся командою QUERY_ADC, щоб
 # отримати вимірювання АЦП. Використовуйте інший датчик температури
 # принтер, щоб знайти відповідну температуру навколишнього середовища. The
 # за замовчуванням використовуються дані заводського калібрування
 # мікроконтролер (за наявності) або номінальні значення з
 # Специфікація мікроконтролера.
 #sensor_temperature2:
 #sensor_adc2:
 # Якщо вказано sensor_temperature1/sensor_adc1, можна також
 # вказати дані калібрування sensor_temperature2/sensor_adc2. Роблячи так
 # може надати відкалібровану інформацію про "нахил температури". The
 # за замовчуванням використовуються дані заводського калібрування
 # мікроконтролер (за наявності) або номінальні значення з
 # Специфікація мікроконтролера.
```

### Датчик температури хоста

Температура машини (наприклад, Raspberry Pi), на якій запущено програмне забезпечення.

```
тип_сенсора: host_temperature
 #sensor_path:
 # Шлях до системного файлу температури. За замовчуванням
 # "/sys/class/thermal/thermal_zone0/temp", що є температурою
 # системний файл на комп’ютері Raspberry Pi.
```

### Датчик температури DS18B20

DS18B20 — це 1-провідний (w1) цифровий датчик температури. Зверніть увагу, що цей датчик не призначений для використання з екструдерами та нагрівальними ліжками, а скоріше для моніторингу температури навколишнього середовища (C). Ці датчики мають діапазон до 125 C, тому їх можна використовувати, наприклад, для моніторингу температури в камері. Вони також можуть функціонувати як прості контролери вентилятора/нагрівача. Датчики DS18B20 підтримуються лише на «host mcu», наприклад, Raspberry Pi. Необхідно встановити модуль ядра Linux w1-gpio.

```
тип датчика: DS18B20
 serial_no:
 # Кожен 1-провідний пристрій має унікальний серійний номер, який використовується для ідентифікації пристрою,
 # зазвичай у форматі 28-031674b175ff. Цей параметр необхідно вказати.
 # Приєднані 1-провідні пристрої можна перерахувати за допомогою такої команди Linux:
 # ls /sys/bus/w1/devices/
 #ds18_report_time:
 # Інтервал у секундах між читаннями. За замовчуванням 3.0, мінімум 1.0
 #sensor_mcu:
 # Мікроконтролер для читання. Має бути host_mcu
```

### Комбінований датчик температури

Комбінований датчик температури — це віртуальний датчик температури на основі кількох інших датчиків. Цей датчик можна використовувати з екструдерами, heater_generic і нагрівальними ліжками.

```
тип_сенсора: комбінований_температурний
 #sensor_list:
 # Необхідно надати. Список датчиків для об’єднання в новий «віртуальний»
 # датчик.
 # Наприклад 'temperature_sensor sensor1,extruder,heater_bed'
 #combination_method:
 # Необхідно надати. Для датчика використовується комбінований метод.
 # Доступні параметри: «max», «min», «mean».
 #maximum_deviation:
 # Необхідно надати. Максимально допустиме відхилення між датчиками
 # для поєднання (наприклад, 5 градусів). Щоб вимкнути його, використовуйте велике значення (наприклад, 999,9)
```

## вболівальники

### [шанувальник]

Вентилятор охолодження друку.

```
[шанувальник]
прикріпити:
# Вихідний контакт для керування вентилятором. Цей параметр необхідно вказати.
#max_power: 1,0
# Максимальна потужність (виражена значенням від 0,0 до 1,0), яку
# pin може бути встановлено на. Значення 1,0 дозволяє встановити штифт повністю
# увімкнено протягом тривалого часу, тоді як значення 0,5 дозволить
# PIN має бути ввімкнено не більше половини часу. Цей параметр може
# використовувати для обмеження загальної вихідної потужності (протягом тривалих періодів).
# вентилятор. Якщо це значення менше 1,0, запитується швидкість вентилятора
# буде масштабовано від нуля до max_power (наприклад, якщо
# max_power дорівнює 0,9, а швидкість вентилятора становить 80%.
# потужність буде встановлено на 72%). За замовчуванням 1.0.
#shutdown_speed: 0
# Бажана швидкість вентилятора (виражена значенням від 0,0 до 1,0), якщо
# програмне забезпечення мікроконтролера переходить у стан помилки. За замовчуванням
# дорівнює 0.
#час_циклу: 0,010
# Час (у секундах) для кожного циклу живлення ШІМ до
# шанувальник. Рекомендується, щоб це було 10 мілісекунд або більше
# з використанням програмної ШІМ. За замовчуванням 0,010 секунди.
#hardware_pwm: Помилка
# Увімкніть це, щоб використовувати апаратну ШІМ замість програмної ШІМ. Більшість уболівальників
# погано працюють з апаратною ШІМ, тому не рекомендується
# увімкніть це, якщо немає електричних вимог для перемикання
# дуже високі швидкості. При використанні апаратної ШІМ фактичний час циклу становить
# обмежена впровадженням і може бути значною
# відрізняється від запитуваного cycle_time. За замовчуванням значення False.
#кік_старт_час: 0,100
# Час (у секундах) для запуску вентилятора на повній швидкості, коли будь-який перший
# увімкнення або збільшення більш ніж на 50% (допомагає отримати вентилятор
# спінінг). За замовчуванням 0,100 секунди.
#off_below: 0,0
# Мінімальна вхідна швидкість, яка забезпечує живлення вентилятора (виражена як a
# значення від 0,0 до 1,0). Коли швидкість нижче, ніж off_below
# запитав, вентилятор буде вимкнено. Цей параметр може бути
# використовується для запобігання зупинці вентилятора та для забезпечення швидкого запуску
# ефективний. За замовчуванням 0,0.
#
# Цей параметр потрібно повторно калібрувати щоразу, коли регулюється max_power.
# Щоб відкалібрувати це налаштування, почніть з off_below, встановленого на 0.0, і
# вентилятор обертається. Поступово знижуйте швидкість вентилятора, щоб визначити найнижчу
# вхідна швидкість, яка надійно керує вентилятором без зупинок. встановити
# off_below до робочого циклу, що відповідає цьому значенню (для
# наприклад, 12% -> 0,12) або трохи вище.
#tachometer_pin:
# Вхідний контакт тахометра для контролю швидкості вентилятора. Підтягування - це взагалі
# потрібно. Цей параметр необов'язковий.
#тахометр_ppr: 2
# Коли вказано tachometer_pin, це кількість імпульсів на
# оборот сигналу тахометра. Це для фаната BLDC
# зазвичай половина кількості полюсів. За замовчуванням 2.
#інтервал_опитування_тахометра: 0,0015
# Якщо вказано tachometer_pin, це період опитування
# штифт тахометра, у секундах. За замовчуванням 0,0015, що є швидким
# достатньо для вентиляторів нижче 10000 об/хв при 2 PPR. Це має бути менше ніж
# 30/(tachometer_ppr*rpm), з деяким запасом, де кількість обертів на хвилину є
# максимальна швидкість (об/хв) вентилятора.
#enable_pin:
# Додатковий штифт для підключення живлення вентилятора. Це може бути корисним для вболівальників
# з виділеними входами ШІМ. Деякі з цих вентиляторів залишаються включеними навіть при 0% ШІМ
# вхід. У такому випадку штифт ШІМ можна використовувати як звичайно, наприклад a
# FET з перемиканням на землю (стандартний контакт вентилятора) можна використовувати для керування живленням
# вентилятор.
```

### [обігрівач_вентилятор]

Вентилятори охолодження обігрівача (за допомогою префікса "heater_fan" можна визначити будь-яку кількість секцій). «Вентилятор обігрівача» — це вентилятор, який буде ввімкнено щоразу, коли пов’язаний з ним нагрівач активний. За замовчуванням heater_fan має shutdown_speed, що дорівнює max_power.

```
[heater_fan heatbreak_cooling_fan] #pin: #max_power: #shutdown_speed: #час_циклу: #hardware_pwm: #kick_start_time: #off_below: #tachometer_pin: #тахометр_ppr: #tachometer_poll_interval: #enable_pin:

Дивіться розділ "вентилятор" для опису наведених вище параметрів.

#нагрівач: екструдер

Назва розділу конфігурації, що визначає нагрівач, яким є цей вентилятор

пов'язано з. Якщо розділений комами список імен нагрівачів

наведено тут, тоді вентилятор буде ввімкнено, коли будь-який із наведених

Увімкнено # обігрівача. Типовим є "екструдер". #heater_temp: 50.0

Температура (у градусах Цельсія), нижче якої нагрівач повинен опуститися раніше

вентилятор вимкнено. За замовчуванням 50 за Цельсієм.

#швидкість_вентилятора: 1.0

Швидкість вентилятора (виражена значенням від 0,0 до 1,0), яку вентилятор

буде встановлено, коли відповідний обігрівач увімкнено. За замовчуванням

is 1.0
```

### [controller_fan]

Контролер вентилятора охолодження (можна визначити будь-яку кількість секцій за допомогою префікса «controller_fan»). «Вентилятор контролера» — це вентилятор, який буде ввімкнено щоразу, коли пов’язаний із ним нагрівач або пов’язаний із ним кроковий драйвер активний. Вентилятор зупинятиметься щоразу, коли буде досягнуто idle_timeout, щоб гарантувати відсутність перегріву після дезактивації компонента, який контролюється.

```
[controller_fan my_controller_fan] #pin: #max_power: #shutdown_speed: #час_циклу: #hardware_pwm: #kick_start_time: #off_below: #tachometer_pin: #тахометр_ppr: #tachometer_poll_interval: #enable_pin:

Дивіться розділ "вентилятор" для опису наведених вище параметрів.

#швидкість_вентилятора: 1.0

Швидкість вентилятора (виражена значенням від 0,0 до 1,0), яку вентилятор

буде встановлено, коли нагрівач або кроковий драйвер активний.

За замовчуванням 1.0

#idle_timeout:

Час (у секундах) після крокового драйвера або нагрівача

був активним, і вентилятор повинен працювати. За замовчуванням

становить 30 секунд.

#idle_speed:

Швидкість вентилятора (виражена значенням від 0,0 до 1,0), яку вентилятор

буде встановлено, коли нагрівач або кроковий драйвер був активним і

до досягнення idle_timeout. Типовим значенням є fan_speed.

#обігрівач: #степер:

Назва розділу конфігурації, що визначає нагрівач/кроковий вентилятор

пов'язано з. Якщо відокремлено комами, список назв нагрівачів/крокових елементів

#, тоді вентилятор буде ввімкнено, коли будь-який із наведених Увімкнено # обігрівачів/кроків. Нагрівачем за замовчуванням є «екструдер».

степпер за замовчуванням — це всі.
```

### [temperature_fan]

Вентилятори охолодження, що працюють за температурою (можна визначити будь-яку кількість секцій за допомогою префікса "temperature_fan"). «Температурний вентилятор» — це вентилятор, який вмикатиметься щоразу, коли його пов’язаний датчик буде вище заданої температури. За замовчуванням temperature_fan має shutdown_speed, що дорівнює max_power.

Додаткову інформацію див. у [довідці щодо команд](G-Codes.md#temperature_fan).

```
[temperature_fan my_temp_fan]
 #pin:
 #max_power:
 #shutdown_speed:
 #цикл_час:
 #hardware_pwm:
 #kick_start_time:
 #off_below:
 #tachometer_pin:
 #тахометр_ppr:
 #tachometer_poll_interval:
 #enable_pin:
 # Дивіться розділ "вентилятор" для опису наведених вище параметрів.
 #sensor_type:
 #sensor_pin:
 #КОНТРОЛЬ:
 #max_delta:
 #min_temp:
 #max_temp:
 # Перегляньте розділ «Екструдер» для опису наведених вище параметрів.
 #pid_Kp:
 #pid_Ki:
 #pid_Kd:
 # Пропорційна (pid_Kp), інтегральна (pid_Ki) і похідна
 # (pid_Kd) параметри для ПІД системи керування зворотним зв'язком. Кліппер
 # оцінює параметри PID за такою загальною формулою:
 # fan_pwm = max_power - (Kp*e + Ki*integral(e) - Kd*derivative(e)) / 255
 # Де "e" означає "цільова_температура - виміряна_температура" і
 # "fan_pwm" - це запитана швидкість вентилятора, при цьому 0,0 повністю вимкнено і
 # 1.0 повний. Параметри pid_Kp, pid_Ki та pid_Kd повинні
 # надається, коли ввімкнено алгоритм ПІД-регулювання.
 #pid_deriv_time: 2.0
 # Значення часу (у секундах), протягом якого відбуватимуться вимірювання температури
 # бути згладженими при використанні алгоритму ПІД-регулювання. Це може зменшити
 # вплив вимірювального шуму. За замовчуванням 2 секунди.
 #цільова_температура: 40,0
 # Температура (у градусах Цельсія), яка буде цільовою температурою.
 # За замовчуванням 40 градусів.
 #max_speed: 1.0
 # Швидкість вентилятора (виражена значенням від 0,0 до 1,0), яку вентилятор
 # буде встановлено, коли температура датчика перевищує встановлене значення.
 # За замовчуванням 1.0.
 #хв_швидкість: 0,3
 # Мінімальна швидкість вентилятора (виражена значенням від 0,0 до 1,0), що
 # вентилятор буде налаштовано на вентилятори температури PID.
 # За замовчуванням 0,3.
 #gcode_id:
 # Якщо встановлено, температура повідомлятиметься в запитах M105 за допомогою
 # заданий ідентифікатор. За замовчуванням температура не повідомляється через M105.
```

### [fan_generic]

Вентилятор з ручним управлінням (можна визначити будь-яку кількість секцій з префіксом "fan_generic"). Швидкість вентилятора з ручним керуванням встановлюється за допомогою SET_FAN_SPEED команда gcode.

```
[fan_generic extruder_partfan] #pin: #max_power: #shutdown_speed: #час_циклу: #hardware_pwm: #kick_start_time: #off_below: #tachometer_pin: #тахометр_ppr: #tachometer_poll_interval: #enable_pin:

Дивіться розділ "вентилятор" для опису наведених вище параметрів.
```

## світлодіоди

### [під керівництвом]

Підтримка світлодіодів (і світлодіодних стрічок), керованих через ШІМ-контакти мікроконтролера (можна визначити будь-яку кількість секцій з префіксом "led"). Додаткову інформацію див. у [довідковій частині команд](G-Codes.md#led).

```
[led my_led] #red_pin: #green_pin: #blue_pin: #white_pin:

Штифт, що контролює даний світлодіодний колір. Принаймні один із перерахованих

Необхідно вказати # параметр. #час_циклу: 0,010

Час (у секундах) на цикл ШІМ. Рекомендується

це має бути 10 мілісекунд або більше, якщо використовується програмна ШІМ.

За замовчуванням 0,010 секунди.

#hardware_pwm: Помилка

Увімкніть це, щоб використовувати апаратну ШІМ замість програмної ШІМ. Коли

з використанням апаратної ШІМ фактичний час циклу обмежений

реалізації та може значно відрізнятися від

запитаний час_циклу. За замовчуванням значення False.

#initial_RED: 0,0 #initial_GREEN: 0,0 #початковий_СИНІЙ: 0,0 #початковий_БІЛИЙ: 0,0

Встановлює початковий колір світлодіода. Кожне значення має бути від 0,0 до

1.0. За замовчуванням для кожного кольору дорівнює 0.
```

### [неопіксель]

Підтримка світлодіодів Neopixel (він же WS2812) (можна визначити будь-яку кількість секцій з префіксом "neopixel"). Додаткову інформацію див. у довідці про команди.

Зауважте, що реалізація linux mcu наразі не підтримує безпосередньо підключені неопікселі. Поточний дизайн із використанням інтерфейсу ядра Linux не дозволяє цей сценарій, оскільки інтерфейс GPIO ядра недостатньо швидкий, щоб забезпечити необхідну частоту імпульсів.

```
[neopixel my_neopixel] прикріпити:

Штифт, підключений до neopixel. Цей параметр повинен бути

надано.

#chain_count:

Кількість чіпів Neopixel, які «шлейфово прив’язані» до

наданий PIN-код. За замовчуванням 1 (що вказує лише на один

Neopixel підключений до контакту).

#color_order: GRB

Встановіть порядок пікселів, необхідний для обладнання світлодіодів (за допомогою рядка

містить літери R, G, B, W з W необов’язковим). Як альтернатива,

це може бути розділений комами список порядків пікселів - по одному для кожного

Світлодіод в ланцюжку. Типовим є GRB.

#initial_RED: 0,0 #initial_GREEN: 0,0 #початковий_СИНІЙ: 0,0 #початковий_БІЛИЙ: 0,0

Дивіться розділ "led", щоб отримати інформацію про ці параметри.
```

### [dotstar]

Підтримка світлодіодів Dotstar (aka APA102) (можна визначити будь-яку кількість секцій з префіксом "dotstar"). Додаткову інформацію див. у довідковій частині команд.

```
[dotstar my_dotstar] data_pin:

Штифт, підключений до лінії даних дотстар. Цей параметр

Потрібно вказати #. clock_pin:

Штифт, підключений до тактової лінії зірки. Цей параметр

Потрібно вказати #. #chain_count:

Перегляньте розділ "neopixel" для отримання інформації про цей параметр.

#initial_RED: 0,0 #initial_GREEN: 0,0 #початковий_СИНІЙ: 0,0

Дивіться розділ "led", щоб отримати інформацію про ці параметри.
```

### [pca9533]

Підтримка світлодіодів PCA9533. PCA9533 використовується на могутній платі.

```
[pca9533 my_pca9533] #i2c_адреса: 98

Адреса i2c, яку чіп використовує на шині i2c. Використовуйте 98 для

PCA9533/1, 99 для PCA9533/2. За замовчуванням 98.

#i2c_mcu: #i2c_bus: #i2c_software_scl_pin: #i2c_software_sda_pin: #i2c_швидкість:

Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис

параметр вище.

#initial_RED: 0,0 #initial_GREEN: 0,0 #початковий_СИНІЙ: 0,0 #початковий_БІЛИЙ: 0,0

Дивіться розділ "led", щоб отримати інформацію про ці параметри.
```

### [pca9632]

Підтримка світлодіодів PCA9632. PCA9632 використовується на FlashForge Dreamer.

```
[pca9632 my_pca9632] #i2c_адреса: 98

Адреса i2c, яку чіп використовує на шині i2c. Це може бути

96, 97, 98 або 99. За замовчуванням 98.

#i2c_mcu: #i2c_bus: #i2c_software_scl_pin: #i2c_software_sda_pin: #i2c_швидкість:

Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис

параметр вище.

#scl_pin: #sda_pin:

Альтернативно, якщо pca9632 не підключено до апаратного I2C

шина, тоді можна вказати "годинник" (scl_pin) і "дані"

(sda_pin) контактів. За замовчуванням використовується апаратне забезпечення I2C.

#color_order: RGBW

Встановити порядок пікселів світлодіода (використовуючи рядок, що містить

літери R, G, B, W). Типовим є RGBW.

#initial_RED: 0,0 #initial_GREEN: 0,0 #початковий_СИНІЙ: 0,0 #початковий_БІЛИЙ: 0,0

Дивіться розділ "led", щоб отримати інформацію про ці параметри.
```

## Додаткові сервоприводи, кнопки та інші шпильки

### [серво]

Сервоприводи (можна визначити будь-яку кількість секцій з префіксом «сервоприводи»). Сервоприводами можна керувати за допомогою SET_SERVO [команда g-code](G-Codes.md#servo). Наприклад: SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
 прикріпити:
 # Вихід ШІМ, що керує сервоприводом. Цей параметр повинен бути
 # надано.
 #maximum_servo_angle: 180
 # Максимальний кут (у градусах), на який можна встановити цей сервопривід. The
 # за замовчуванням 180 градусів.
 #мінімальна_широта_імпульсу: 0,001
 # Мінімальна тривалість імпульсу (у секундах). Це має відповідати
 # з кутом 0 градусів. За замовчуванням 0,001 секунди.
 #максимальна_широта_імпульсу: 0,002
 # Максимальна тривалість імпульсу (у секундах). Це має відповідати
 # з кутом max_servo_angle. За замовчуванням 0,002
 # секунди.
 #початковий_кут:
 # Початковий кут (у градусах), на який потрібно встановити сервопривід. За умовчанням встановлено значення
 # не посилати жодного сигналу під час запуску.
 #initial_pulse_width:
 # Початковий час ширини імпульсу (у секундах), на який потрібно встановити сервопривід. (Це
 # дійсний, лише якщо початковий_кут не встановлено.) Типовим значенням є ні
 # посилати будь-який сигнал під час запуску.
```

### [gcode_button]

Виконувати gcode, коли кнопку натискають або відпускають (або коли пін змінює стан). Ви можете перевірити стан кнопки за допомогою  QUERY_BUTTON button=my_gcode_button .

```
[gcode_button my_gcode_button]
pin:
#   The pin on which the button is connected. This parameter must be
#   provided.
#analog_range:
#   Two comma separated resistances (in Ohms) specifying the minimum
#   and maximum resistance range for the button. If analog_range is
#   provided then the pin must be an analog capable pin. The default
#   is to use digital gpio for the button.
#analog_pullup_resistor:
#   The pullup resistance (in Ohms) when analog_range is specified.
#   The default is 4700 ohms.
#press_gcode:
#   A list of G-Code commands to execute when the button is pressed.
#   G-Code templates are supported. This parameter must be provided.
#release_gcode:
#   A list of G-Code commands to execute when the button is released.
#   G-Code templates are supported. The default is to not run any
#   commands on a button release.
#debounce_delay:
#   A period of time in seconds to debounce events prior to running the
#   button gcode. If the button is pressed and released during this
#   delay, the entire button press is ignored. Default is 0.
```

### [вихідний_контакт]

Вихідні контакти, що настроюються під час виконання (можна визначити будь-яку кількість секцій із префіксом "output_pin"). Налаштовані тут контакти буде встановлено як вихідні контакти, і їх можна буде змінити під час виконання за допомогою розширеного типу "SET_PIN PIN=my_pin VALUE=.1" [команди g-коду](G-Codes.md#output_pin).

```
[вихід_pin my_pin]
шпилька:
Нема шпилька для налаштування як виходу. Цей параметр повинен бути
# надано.
#pwm: False
Нема Встановити, якщо вихідний штифт повинен бути здатний пульс-широт-моделювання.
Нема Якщо це правда, поля значення повинні бути між 0 і 1; якщо це правда, значення має бути між 0 і 1; якщо це правда, поля значення повинні бути між 0 і 1; якщо це правда, значення поля повинні бути між 0 і 1; якщо це правда, значення поля повинні бути між 0 і 1; якщо це правда, значення поля повинні бути між 0 і 1; якщо це правда, значення поля повинні бути між 0 і 1; якщо це правда, значення поля повинні бути між 0 і 1; якщо це правда, значення поля повинні бути між 0 і 1; якщо це правда, значення поля повинні бути між 0 і 1; якщо це правда, значення поля повинні бути між 0 і 1;
# помилкові поля значення повинні бути або 0 або 1. За замовчуванням
# Фальсе.
#значення:
Нема Значення спочатку встановити шпильку під час конфігурації МКУ.
Нема За замовчуванням 0 (для низької напруги).
#shutdown_value:
Нема Вартість встановлення шпильки на випадок відключення MCU. За замовчуванням
# - 0 (для низької напруги).
#цикл_час: 0.100
Нема Кількість часу (в секундах) за цикл PWM. Рекомендовано
# це буде 10 мілісекундів або більше при використанні програмного забезпечення на основі PWM.
Нема За замовчуванням 0.100 секунд для шпильок pwm.
#hardware_pwm: Фальзе
Нема Увімкнути це для використання апаратних PWM замість програмного забезпечення PWM. Коли
# за допомогою апаратного PWM фактичний час циклу обмежений
# виконання і може бути значно різним, ніж
# запитаний цикл_час. За замовчуванням False.
#масштабний:
Нема Цей параметр можна використовувати для зміни значення 'value' і
Параметри "shutdown_value" інтерпретуються для штифтів. Якщо
# передбачено, потім параметр 'value' повинен бути між 0.0 і
# 'розмір'. Це може бути корисним при налаштуванні штифта PWM, який
# Контроль за посиланням на степпер напруги. «масштабний» може бути встановлений
# еквівалентний кроковий ампераж, якщо PWM повністю ввімкнено, і
# потім параметр 'value' можна вказати за допомогою бажаного параметра
# ампераж для степпера. За замовчуванням не потрібно масштабувати 'value'
# параметр.
#maximum_mcu_duration:
#static_value:
Нема Ці параметри депресовані і не повинні бути вказані.
.
```

### [pwm_інструмент]

Цифрові вихідні контакти широтно-імпульсної модуляції, здатні виконувати високошвидкісні оновлення (можна визначити будь-яку кількість секцій за допомогою префікса "output_pin"). Налаштовані тут контакти буде встановлено як вихідні контакти, і їх можна буде змінити під час виконання за допомогою розширеного типу "SET_PIN PIN=my_pin VALUE=.1" [команди g-коду](G-Codes.md#output_pin).

```
[pwm_tool мій_інструмент]
 прикріпити:
 # Пін, який потрібно налаштувати як вихід. Цей параметр необхідно вказати.
 #maximum_mcu_duration:
 # Максимальна тривалість значення без відключення може керуватися MCU
 # без підтвердження від хоста.
 # Якщо хост не встигає за оновленнями, MCU вимкнеться
 # і встановіть для всіх пінів відповідні значення вимкнення.
 # За замовчуванням: 0 (вимкнено)
 # Звичайні значення становлять близько 5 секунд.
 #value:
 #shutdown_value:
 #час_циклу: 0,100
 #hardware_pwm: Помилка
 #масштаб:
 # Перегляньте розділ «output_pin» для визначення цих параметрів.
```

### [pwm_cycle_time]

Настроювані під час виконання вихідні контакти з динамічною синхронізацією циклу ШІМ (можна визначити будь-яку кількість секцій за допомогою префікса "pwm_cycle_time"). Налаштовані тут контакти будуть встановлені як вихідні контакти, і їх можна буде змінити під час виконання за допомогою розширеного типу "SET_PIN PIN=my_pin VALUE=.1 CYCLE_TIME=0.100" [команди g-коду](G-Codes.md#pwm_cycle_time).

```
[pwm_cycle_time my_pin]
 прикріпити:
 #value:
 #shutdown_value:
 #час_циклу: 0,100
 #масштаб:
 # Перегляньте розділ "output_pin" для інформації про ці параметри.
```

### [статичний_цифровий_вихід]

Статично налаштовані цифрові виводи (можна визначити будь-яку кількість секцій за допомогою префікса "static_digital_output"). Налаштовані тут контакти будуть налаштовані як вихід GPIO під час налаштування MCU. Їх не можна змінити під час виконання.

```
[static_digital_output my_output_pins]
 шпильки:
 # Розділений комами список контактів, які будуть встановлені як вихідні контакти GPIO. The
 # пін буде встановлено на високий рівень, якщо перед ним не буде назва пін-коду
 # з "!". Цей параметр необхідно вказати.
```

### [multi_pin]

Кілька пінових виходів (можна визначити будь-яку кількість секцій з префіксом "multi_pin"). Вихід multi_pin створює внутрішній псевдонім піна, який може змінювати кілька вихідних пінів кожного разу, коли встановлено псевдонім піна. Наприклад, можна визначити об’єкт «[multi_pin my_fan]», що містить два контакти, а потім встановити «pin=multi_pin:my_fan» у розділі «[fan]» — при кожній зміні вентилятора обидва вихідні контакти оновлюватимуться. Ці псевдоніми не можна використовувати з контактами крокового двигуна.

```
[multi_pin my_multi_pin] шпильки:

Розділений комами список пінів, пов’язаних із цим псевдонімом. Це

Потрібно вказати # параметр.
```

## Конфігурація крокового драйвера TMC

Конфігурація драйверів крокових двигунів Trinamic у режимі UART/SPI. Додаткову інформацію можна знайти в посібнику з драйверів TMC і в довідці щодо команд.

### [tmc2130]

Налаштуйте драйвер крокового двигуна TMC2130 через шину SPI. Щоб скористатися цією функцією, визначте розділ конфігурації з префіксом «tmc2130», за яким слідує назва відповідного розділу конфігурації степера (наприклад, «[tmc2130 stepper_x]»).

```
[tmc2130 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2130 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 0
#driver_TBL: 1
#driver_TOFF: 4
#driver_HEND: 7
#driver_HSTRT: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 4
#driver_PWM_AMPL: 128
#driver_FREEWHEEL: 0
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#   Set the given register during the configuration of the TMC2130
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2130 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2130_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2208]

Налаштуйте драйвер крокового двигуна TMC2208 (або TMC2224) через однопровідний UART. Щоб скористатися цією функцією, визначте розділ конфігурації з префіксом «tmc2208», за яким слідує назва відповідного розділу конфігурації степера (наприклад, «[tmc2208 stepper_x]»).

```
[tmc2208 stepper_x]
uart_pin:
#   The pin connected to the TMC2208 PDN_UART line. This parameter
#   must be provided.
#tx_pin:
#   If using separate receive and transmit lines to communicate with
#   the driver then set uart_pin to the receive pin and tx_pin to the
#   transmit pin. The default is to use uart_pin for both reading and
#   writing.
#select_pins:
#   A comma separated list of pins to set prior to accessing the
#   tmc2208 UART. This may be useful for configuring an analog mux for
#   UART communication. The default is to not configure any pins.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#driver_FREEWHEEL: 0
#   Set the given register during the configuration of the TMC2208
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
```

### [tmc2209]

Налаштуйте драйвер крокового двигуна TMC2209 через однопровідний UART. Щоб скористатися цією функцією, визначте розділ конфігурації з префіксом «tmc2209», за яким слідує назва відповідного розділу конфігурації степера (наприклад, «[tmc2209 stepper_x]»).

```
[tmc2209 stepper_x]
uart_pin:
#tx_pin:
#select_pins:
#interpolate: True
run_current:
#hold_current:
#sense_resistor: 0.110
#stealthchop_threshold: 0
#   See the "tmc2208" section for the definition of these parameters.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#uart_address:
#   The address of the TMC2209 chip for UART messages (an integer
#   between 0 and 3). This is typically used when multiple TMC2209
#   chips are connected to the same UART pin. The default is zero.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#driver_FREEWHEEL: 0
#driver_SGTHRS: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#   Set the given register during the configuration of the TMC2209
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag_pin:
#   The micro-controller pin attached to the DIAG line of the TMC2209
#   chip. The pin is normally prefaced with "^" to enable a pullup.
#   Setting this creates a "tmc2209_stepper_x:virtual_endstop" virtual
#   pin which may be used as the stepper's endstop_pin. Doing this
#   enables "sensorless homing". (Be sure to also set driver_SGTHRS to
#   an appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2660]

Налаштуйте драйвер крокового двигуна TMC2660 через шину SPI. Щоб скористатися цією функцією, визначте розділ конфігурації з префіксом tmc2660 і назвою відповідного розділу конфігурації степера (наприклад, «[tmc2660 stepper_x]»).

```
[tmc2660 stepper_x]
 cs_pin:
 # Пін, що відповідає лінії вибору мікросхеми TMC2660. Ця шпилька
 # буде встановлено на низький рівень на початку повідомлень SPI і встановлено на високий
 # після завершення передачі повідомлення. Цей параметр повинен бути
 # надано.
 #spi_speed: 4000000
 # Частота шини SPI, яка використовується для зв’язку з кроковим процесором TMC2660
 # водій. За замовчуванням 4000000.
 #spi_bus:
 #spi_software_sclk_pin:
 #spi_software_mosi_pin:
 #spi_software_miso_pin:
 # Перегляньте розділ «Загальні налаштування SPI», щоб отримати опис
 # параметр вище.
 #interpolate: Правда
 # Якщо істина, увімкнути покрокову інтерполяцію (драйвер буде внутрішньо
 # крок зі швидкістю 256 мікрокроків). Це працює лише з мікрокроками
 # встановлено на 16. Інтерполяція вводить невелику системність
 # позиційне відхилення - подробиці див. TMC_Drivers.md. За замовчуванням
 # вірно.
 run_current:
 # Величина струму (в амперах RMS), що використовується драйвером під час
 # кроковий рух. Цей параметр необхідно вказати.
 #sense_resistor:
 # Опір (в Омах) резистора датчика двигуна. Це
 Потрібно вказати # параметр.
 #idle_current_percent: 100
 # Відсоток run_current крокового драйвера
 # знижено до закінчення часу простою (необхідно налаштувати
 # тайм-аут за допомогою розділу конфігурації [idle_timeout]. Нинішня воля
 # підняти знову, як тільки степпер повинен рухатися знову. Переконайтеся, що
 # встановіть досить високе значення, щоб степери не програвали
 # їх позиція. Існує також невелика затримка до появи струму
 # піднятий знову, тому візьміть це до уваги, коли командуєте швидкими рухами
 # під час холостого ходу степпера. За замовчуванням 100 (без зменшення).
 #драйвер_TBL: 2
 #драйвер_RNDTF: 0
 #driver_HDEC: 0
 #driver_CHM: 0
 #driver_HEND: 3
 #driver_HSTRT: 3
 #driver_TOFF: 4
 #driver_SEIMIN: 0
 #driver_SEDN: 0
 #driver_SEMAX: 0
 #driver_SEUP: 0
 #driver_SEMIN: 0
 #driver_SFILT: 0
 #driver_SGT: 0
 #driver_SLPH: 0
 #driver_SLPL: 0
 #driver_DISS2G: 0
 #драйвер_TS2G: 3
 # Встановіть заданий параметр під час налаштування TMC2660
 # чіп. Це може бути використано для встановлення власних параметрів драйвера. The
 # значення за замовчуванням для кожного параметра вказано поруч із назвою параметра в
 # список вище. Перегляньте таблицю даних TMC2660 про те, що таке кожен параметр
 # робить і які обмеження на комбінації параметрів. бути
 # особливо пам'ятайте про регістр CHOPCONF, де встановлено значення CHM
 # нуль або одиниця призведуть до змін макета (перший біт
 # HDEC) інтерпретується як MSB HSTRT у цьому випадку).
```

### [tmc2240]

Налаштуйте драйвер крокового двигуна TMC2240 через шину SPI або UART. Щоб скористатися цією функцією, визначте розділ конфігурації з префіксом «tmc2240», за яким слідує назва відповідного розділу конфігурації степера (наприклад, «[tmc2240 stepper_x]»).

```
[tmc2240 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2240 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#uart_pin:
#   The pin connected to the TMC2240 DIAG1/SW line. If this parameter
#   is provided UART communication is used rather then SPI.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#rref: 12000
#   The resistance (in ohms) of the resistor between IREF and GND. The
#   default is 12000.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#driver_OFFSET_SIN90: 0
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#   Additionally, this driver also has the OFFSET_SIN90 field which can be used
#   to tune a motor with unbalanced coils. See the `Sine Wave Lookup Table`
#   section in the datasheet for information about this field and how to tune
#   it.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_IRUNDELAY: 4
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 29
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_SG4_ANGLE_OFFSET: 1
#driver_SLOPE_CONTROL: 0
#   Set the given register during the configuration of the TMC2240
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2240 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2240_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc5160]

Налаштуйте драйвер крокового двигуна TMC5160 через шину SPI. Щоб скористатися цією функцією, визначте розділ конфігурації з префіксом «tmc5160», за яким слідує назва відповідного розділу конфігурації степера (наприклад, «[tmc5160 stepper_x]»).

```
[tmc5160 stepper_x]
cs_pin:
#   The pin corresponding to the TMC5160 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.075
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.075 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 30
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_DRVSTRENGTH: 0
#driver_BBMCLKS: 4
#driver_BBMTIME: 0
#driver_FILT_ISENSE: 0
#   Set the given register during the configuration of the TMC5160
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC5160 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc5160_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

## Конфігурація струму крокового двигуна під час роботи

### [ad5206]

Статично налаштовані дигіпоти AD5206, підключені через шину SPI (можна визначити будь-яку кількість секцій з префіксом "ad5206").

```
[ad5206 my_digipot] enable_pin:

Вивід, що відповідає лінії вибору мікросхеми AD5206. Ця шпилька

буде встановлено на низький рівень на початку повідомлень SPI і підвищено на високий

після завершення повідомлення. Цей параметр необхідно вказати.

#spi_speed: #spi_bus: #spi_software_sclk_pin: #spi_software_mosi_pin: #spi_software_miso_pin:

Перегляньте розділ «Загальні налаштування SPI», щоб отримати опис

параметр вище.

#channel_1: #channel_2: #channel_3: #channel_4: #channel_5: #channel_6:

Значення для статичної установки даного каналу AD5206. Це є

зазвичай встановлюється на число від 0,0 до 1,0, де 1,0 є

найвищий опір і 0,0 — найнижчий опір. однак,

діапазон можна змінити за допомогою параметра 'scale' (див. нижче).

Якщо канал не вказано, він не налаштований.

#масштаб:

Цей параметр можна використовувати для зміни параметрів 'channel_x'

інтерпретуються. Параметри 'channel_x', якщо надано

має бути між 0,0 і 'scale'. Це може бути корисним, коли

AD5206 використовується для встановлення опорної напруги крокової напруги. «Шкала» може

бути встановлено на еквівалентну силу струму крокового кроку, якщо AD5206 був на рівні

його найвищий опір, а потім можуть бути параметри 'channel_x'

вказано за допомогою бажаного значення сили струму для крокового кроку. The

за замовчуванням параметри 'channel_x' не масштабуються.
```

### [mcp4451]

Статично налаштований дигіпот MCP4451, підключений через шину I2C (можна визначити будь-яку кількість секцій з префіксом "mcp4451").

```
[mcp4451 my_digipot]
i2c_address:
Нема Адреса i2c, що використовує на i2c автобусі. Про нас
# параметр повинен бути надана.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
Нема Див. розділ "компонентні налаштування I2C" для опису
# над параметрами.
#wiper_0:
#wiper_1:
#wiper_2:
#wiper_3:
Нема Значення статично встановити дану MCP4451 "фіпер" до. Це
#, як правило, встановити номер між 0.0 і 1,0 з 1,0 будучи
# найвищий опір і 0,0 будучи найнижчою стійкістю. Однак
# діапазон може бути змінений з параметром 'розмір' (див. нижче).
Нема Якщо ви не вказали, то він залишається неналаштуваним.
#масштабний:
Нема Цей параметр можна використовувати для зміни параметрів 'wiper_x'
# перекладаються. Якщо передбачено, то параметри 'wiper_x' повинні
# бути між 0.0 і 'розміром'. Це може бути корисним при MCP4451
# використовується для встановлення крокової напруги посилань. «масштабний» може бути встановлений
# еквівалент амперажу крокової залози, якщо MCP4451 був на найвищому рівні
# опір, а потім параметри 'wiper_x' можна вказати
# за допомогою необхідного значення амперажу для степпера. За замовчуванням
# не масштабувати параметри 'wiper_x'.
.
```

### [mcp4728]

Статично налаштований цифро-аналоговий перетворювач MCP4728, підключений через шину I2C (можна визначити будь-яку кількість секцій з префіксом "mcp4728").

```
[mcp4728 my_dac] #i2c_адреса: 96

Адреса i2c, яку чіп використовує на шині i2c. За замовчуванням

дорівнює 96.

#i2c_mcu: #i2c_bus: #i2c_software_scl_pin: #i2c_software_sda_pin: #i2c_швидкість:

Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис

параметр вище.

#channel_a: #channel_b: #channel_c: #channel_d:

Значення для статичної установки даного каналу MCP4728. Це є

зазвичай встановлюється на число від 0,0 до 1,0, де 1,0 є

найвища напруга (2,048 В), а 0,0 — найнижча напруга.

Однак діапазон можна змінити за допомогою параметра 'scale' (див

нижче). Якщо канал не вказано, він залишиться

не налаштовано.

#масштаб:

Цей параметр можна використовувати для зміни параметрів 'channel_x'

інтерпретуються. Параметри 'channel_x', якщо надано

має бути між 0,0 і 'scale'. Це може бути корисним, коли

MCP4728 використовується для встановлення опорної напруги крокової напруги. «Шкала» може

бути встановлено на еквівалентну силу струму крокового кроку, якби MCP4728 був на рівні

найвища напруга (2,048 В), а потім параметри 'channel_x'

можна вказати за допомогою бажаного значення сили струму для

степпер. За замовчуванням параметри 'channel_x' не масштабуються.
```

### [mcp4018]

Статично налаштований цифровий пот MCP4018, підключений через два контакти gpio "bit banging" (можна визначити будь-яку кількість секцій з префіксом "mcp4018").

```
[mcp4018 my_digipot] scl_pin:

Штифт SCL "годинник". Цей параметр необхідно вказати.

sda_pin:

Пін SDA "data". Цей параметр необхідно вказати.

склоочисник:

Значення для статичної установки даного "wiper" MCP4018. Це є

зазвичай встановлюється на число від 0,0 до 1,0, де 1,0 є

найвищий опір і 0,0 — найнижчий опір. однак,

діапазон можна змінити за допомогою параметра 'scale' (див. нижче).

Цей параметр необхідно вказати.

#масштаб:

Цей параметр можна використовувати для зміни параметра wiper

інтерпретовано. Якщо надано, то має бути параметр wiper

між 0,0 і 'scale'. Це може бути корисним, коли MCP4018 працює

використовується для встановлення опорної напруги кроку. «Шкала» може бути встановлена на

еквівалентна сила струму крокового кроку, якщо MCP4018 має максимальне значення

опору, а потім можна вказати параметр wiper за допомогою

бажане значення сили струму для степпера. За замовчуванням – ні

масштабувати параметр wiper.
```

## Підтримка дисплея

### [дисплей]

Підтримка дисплея, підключеного до мікроконтролера.

```
[display]
lcd_type:
#   The type of LCD chip in use. This may be "hd44780", "hd44780_spi",
#   "aip31068_spi", "st7920", "emulated_st7920", "uc1701", "ssd1306", or
#   "sh1106".
#   See the display sections below for information on each type and
#   additional parameters they provide. This parameter must be
#   provided.
#display_group:
#   The name of the display_data group to show on the display. This
#   controls the content of the screen (see the "display_data" section
#   for more information). The default is _default_20x4 for hd44780 or
#   aip31068_spi displays and _default_16x4 for other displays.
#menu_timeout:
#   Timeout for menu. Being inactive this amount of seconds will
#   trigger menu exit or return to root menu when having autorun
#   enabled. The default is 0 seconds (disabled)
#menu_root:
#   Name of the main menu section to show when clicking the encoder
#   on the home screen. The defaults is __main, and this shows the
#   the default menus as defined in klippy/extras/display/menu.cfg
#menu_reverse_navigation:
#   When enabled it will reverse up and down directions for list
#   navigation. The default is False. This parameter is optional.
#encoder_pins:
#   The pins connected to encoder. 2 pins must be provided when using
#   encoder. This parameter must be provided when using menu.
#encoder_steps_per_detent:
#   How many steps the encoder emits per detent ("click"). If the
#   encoder takes two detents to move between entries or moves two
#   entries from one detent, try changing this. Allowed values are 2
#   (half-stepping) or 4 (full-stepping). The default is 4.
#click_pin:
#   The pin connected to 'enter' button or encoder 'click'. This
#   parameter must be provided when using menu. The presence of an
#   'analog_range_click_pin' config parameter turns this parameter
#   from digital to analog.
#back_pin:
#   The pin connected to 'back' button. This parameter is optional,
#   menu can be used without it. The presence of an
#   'analog_range_back_pin' config parameter turns this parameter from
#   digital to analog.
#up_pin:
#   The pin connected to 'up' button. This parameter must be provided
#   when using menu without encoder. The presence of an
#   'analog_range_up_pin' config parameter turns this parameter from
#   digital to analog.
#down_pin:
#   The pin connected to 'down' button. This parameter must be
#   provided when using menu without encoder. The presence of an
#   'analog_range_down_pin' config parameter turns this parameter from
#   digital to analog.
#kill_pin:
#   The pin connected to 'kill' button. This button will call
#   emergency stop. The presence of an 'analog_range_kill_pin' config
#   parameter turns this parameter from digital to analog.
#analog_pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the analog
#   button. The default is 4700 ohms.
#analog_range_click_pin:
#   The resistance range for a 'enter' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_back_pin:
#   The resistance range for a 'back' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_up_pin:
#   The resistance range for a 'up' button. Range minimum and maximum
#   comma-separated values must be provided when using analog button.
#analog_range_down_pin:
#   The resistance range for a 'down' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_kill_pin:
#   The resistance range for a 'kill' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
```

#### дисплей hd44780

Інформація щодо налаштування дисплеїв hd44780 (який використовується в дисплеях типу «RepRapDiscount 2004 Smart Controller»).

```
[дисплей] lcd_type: hd44780

Встановіть "hd44780" для дисплеїв hd44780.

rs_pin: e_pin: d4_pin: d5_pin: d6_pin: d7_pin:

Контакти, підключені до РК-дисплея типу hd44780. Ці параметри повинні

be provided.

#hd44780_protocol_init: True

Виконайте ініціалізацію 8-бітного/4-бітного протоколу на дисплеї hd44780.

This is necessary on real hd44780 devices. However, one may need

щоб вимкнути це на деяких "клонованих" пристроях. Типовим значенням є True.

#line_length:

Set the number of characters per line for an hd44780 type lcd.

Possible values are 20 (default) and 16. The number of lines is

fixed to 4.

...
```

#### дисплей hd44780_spi

Інформація про конфігурацію дисплея hd44780_spi — дисплея 20x04, керованого через апаратний «регістр зсуву» (який використовується в принтерах на базі mightyboard).

```
[дисплей] Тип_дисплея: hd44780_spi

Встановіть значення "hd44780_spi" для дисплеїв hd44780_spi.

фіксатор: spi_software_sclk_pin: spi_software_mosi_pin: spi_software_miso_pin:

Виводи, підключені до регістру зсуву, що керує дисплеєм.

Для spi_software_miso_pin потрібно встановити невикористаний пін

материнська плата принтера, оскільки регістр зсуву не має контакту MISO,

але програмна реалізація spi вимагає наявності цього PIN-коду

налаштовано.

#hd44780_protocol_init: Правда

Виконайте ініціалізацію 8-бітного/4-бітного протоколу на дисплеї hd44780.

Це необхідно на справжніх пристроях hd44780. Однак може знадобитися

щоб вимкнути це на деяких "клонованих" пристроях. Типовим значенням є True.

#line_length:

Встановіть кількість символів у рядку для РК-дисплея типу hd44780.

Можливі значення: 20 (за замовчуванням) і 16. Кількість рядків

встановлено на 4.

...
```

#### aip31068_spi дисплей

Інформація про налаштування дисплея aip31068_spi — дуже схожий на hd44780_spi дисплей 20x04 (20 символів по 4 рядки) із дещо іншим внутрішнім протоколом.

```
[display]
lcd_type: aip31068_spi
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   The pins connected to the shift register controlling the display.
#   The spi_software_miso_pin needs to be set to an unused pin of the
#   printer mainboard as the shift register does not have a MISO pin,
#   but the software spi implementation requires this pin to be
#   configured.
#line_length:
#   Set the number of characters per line for an hd44780 type lcd.
#   Possible values are 20 (default) and 16. The number of lines is
#   fixed to 4.
...
```

#### дисплей st7920

Інформація щодо налаштування дисплеїв st7920 (який використовується в дисплеях типу «RepRapDiscount 12864 Full Graphic Smart Controller»).

```
[display] Тип_дисплея: st7920

Set to "st7920" for st7920 displays.

cs_pin: sclk_pin: sid_pin:

The pins connected to an st7920 type lcd. These parameters must be

надано.

...
```

#### emulated_st7920 дисплей

Інформація щодо налаштування емульованого дисплея st7920 – зустрічається в деяких «пристроях із сенсорним екраном 2,4 дюйма» тощо.

```
[дисплей] lcd_type: emulated_st7920

Встановіть значення "emulated_st7920" для дисплеїв emulated_st7920.

en_pin: spi_software_sclk_pin: spi_software_mosi_pin: spi_software_miso_pin:

Контакти, підключені до РК-дисплея типу emulated_st7920. en_pin

відповідає cs_pin lcd типу st7920,

spi_software_sclk_pin відповідає sclk_pin і

spi_software_mosi_pin відповідає sid_pin. The

spi_software_miso_pin потрібно встановити на невикористаний PIN-код

материнська плата принтера як st7920 без контакту MISO, але програмного забезпечення

Реалізація # spi вимагає налаштувати цей PIN-код. ...
```

#### дисплей uc1701

Інформація про налаштування дисплеїв uc1701 (який використовується в дисплеях типу «МКС Міні 12864»).

```
[дисплей] LCD_type: uc1701

Встановіть значення "uc1701" для дисплеїв uc1701.

cs_pin: a0_pin:

The pins connected to a uc1701 type lcd. These parameters must be

надано.

#rst_pin:

Штифт, підключений до «першого» контакту на РК-дисплеї. Якщо це не так

зазначено, тоді апаратне забезпечення повинно мати підтягування на

відповідна лінія РК-дисплея.

#контраст:

Контраст для встановлення. Значення може бути в діапазоні від 0 до 63 і

за замовчуванням 40.

...
```

#### дисплеї ssd1306 і sh1106

Інформація про налаштування дисплеїв ssd1306 і sh1106.

```
[дисплей] lcd_type:

Встановіть значення "ssd1306" або "sh1106" для заданого типу дисплея.

#i2c_mcu: #i2c_bus: #i2c_software_scl_pin: #i2c_software_sda_pin: #i2c_швидкість:

Доступні додаткові параметри для дисплеїв, підключених через i2c

автобус. Опис див. у розділі «Загальні налаштування I2C».

наведені вище параметри.

#cs_pin: #dc_pin: #spi_speed: #spi_bus: #spi_software_sclk_pin: #spi_software_mosi_pin: #spi_software_miso_pin:

Контакти, підключені до РК-дисплея в режимі «4-провідний» spi. Див

розділ «загальні налаштування SPI» для опису параметрів

#, які починаються на "spi_". За замовчуванням використовується режим i2c для

дисплей.

#reset_pin:

На дисплеї може бути вказаний PIN-код скидання. Якщо це не так

зазначено, тоді апаратне забезпечення повинно мати підтягування на

відповідна лінія РК-дисплея.

#контраст:

Контраст для встановлення. Значення може бути в діапазоні від 0 до 256 і

за замовчуванням 239.

#vcomh: 0

Встановіть значення Vcomh на дисплеї. Це значення пов'язане з

ефект "розмазування" на деяких OLED-дисплеях. Значення може коливатися

від 0 до 63. За замовчуванням 0.

#invert: False

TRUE інвертує пікселі на певних OLED-дисплеях. За замовчуванням

Неправда.

#x_offset: 0

Встановіть значення горизонтального зсуву на дисплеях SH1106. За замовчуванням

0.

...
```

### [відображати_дані]

Підтримка відображення користувацьких даних на РК-екрані. Можна створити будь-яку кількість груп відображення та будь-яку кількість елементів даних у цих групах. На дисплеї відображатимуться всі елементи даних для певної групи, якщо для параметра display_group у розділі [display] встановлено вказане ім’я групи.

[Набір груп відображення за замовчуванням] (../klippy/extras/display/display.cfg) створюється автоматично. Можна замінити або розширити ці елементи display_data, перевизначивши значення за замовчуванням у головному конфігураційному файлі printer.cfg.

```
[display_data my_group_name my_data_name] посада:

Розділені комами рядок і стовпець позиції відображення, яка повинна

використовувати для відображення інформації. Цей параметр повинен бути

надано.

текст:

Текст для відображення у вказаній позиції. Це поле оцінюється

використання шаблонів команд (див. docs/Command_Templates.md). Це

Потрібно вказати # параметр.
```

### [шаблон_відображення]

«Макроси» відображення тексту даних (можна визначити будь-яку кількість розділів за допомогою префікса display_template). Перегляньте документ шаблони команд, щоб отримати інформацію про оцінку шаблону.

Ця функція дозволяє зменшити кількість повторюваних визначень у розділах display_data. Щоб оцінити шаблон, можна використати вбудовану функцію `render()` у розділах display_data. Наприклад, якщо потрібно визначити `[display_template my_template]`, то можна використовувати `{ render('my_template') }` у розділі display_data.

Цю функцію також можна використовувати для постійного оновлення світлодіодів за допомогою команди [SET_LED_TEMPLATE](G-Codes.md#set_led_template).

```
[display_template my_template_name] #param_ :

Можна вказати будь-яку кількість параметрів з префіксом "param_". The

заданому імені буде присвоєно вказане значення (розібране як Python

літерал) і буде доступним під час розширення макросу. Якщо

параметр передається під час виклику render(), тоді це значення буде

використовувати під час розширення макросу. Наприклад, конфігурація з

"param_speed = 75" може мати абонента з

"render('my_template_name', param_speed=80)". Імена параметрів можуть

не використовувати символи верхнього регістру.

текст:

Текст, який повертається під час відтворення цього шаблону. Це поле

обчислюється за допомогою шаблонів команд (див

docs/Command_Templates.md). Цей параметр необхідно вказати.
```

### [display_glyph]

Відображати спеціальний гліф на дисплеях, які його підтримують. Даному імені буде присвоєно задані дані відображення, на які потім можна буде посилатися в шаблонах відображення за їхнім іменем, оточеним двома символами «тильда», тобто ~my_display_glyph~

Перегляньте [sample-glyphs.cfg](../config/sample-glyphs.cfg) для деяких прикладів.

```
[display_glyph my_display_glyph] #дані:

Дані дисплея, збережені у вигляді 16 рядків, що складаються з 16 бітів (1 на

піксель), де '.' – це порожній піксель, а «*» – увімкнений піксель (наприклад,

"****************" для відображення суцільної горизонтальної лінії).

Крім того, можна використовувати '0' для порожнього пікселя і '1' для ввімкнення

піксель. Помістіть кожен рядок дисплея в окремий рядок конфігурації. The

гліф має складатися рівно з 16 рядків по 16 біт кожен. Це

параметр необов'язковий.

#hd44780_data:

Гліф для використання на дисплеях 20x4 hd44780. Гліф повинен складатися з

рівно 8 рядків по 5 біт кожен. Цей параметр необов'язковий.

#hd44780_slot:

Апаратний індекс hd44780 (0..7) для зберігання гліфа. Якщо

кілька різних зображень використовують один і той самий слот, тоді переконайтеся, що лише

використовуйте одне з цих зображень на будь-якому екрані. Цей параметр є

потрібно, якщо вказано hd44780_data.
```

### [відобразити my_extra_display]

Якщо основний розділ [display] було визначено у printer.cfg, як показано вище, можна визначити кілька допоміжних дисплеїв. Зауважте, що допоміжні дисплеї наразі не підтримують функції меню, тому вони не підтримують параметри «меню» або конфігурацію кнопок.

```
[відобразити my_extra_display]

Доступні параметри див. у розділі «Дисплей».
```

### [меню]

Настроювані меню РК-дисплея.

[Набір меню за замовчуванням] (../klippy/extras/display/menu.cfg) створюється автоматично. Меню можна замінити або розширити, змінивши значення за замовчуванням у головному конфігураційному файлі printer.cfg.

Перегляньте [документ шаблону команди](Command_Templates.md#menu-templates), щоб отримати інформацію про атрибути меню, доступні під час візуалізації шаблону.

```
Загальні параметри доступні для всіх розділів конфігурації меню.

#[menu __some_list __some_name] #тип: вимкнено

Постійно вимкнений елемент меню, єдиним обов'язковим атрибутом є 'type'.

Дозволяє легко вимкнути/приховати наявні пункти меню.

#[меню some_name] #тип:

Один із команд, введення, списку, тексту:

команда - основний елемент меню з різними тригерами скриптів

input — те саме, що й 'command', але має можливість змінювати значення.

Натисніть, щоб запустити/зупинити режим редагування.

список - дозволяє згрупувати пункти меню в a

список, який можна прокручувати. Додайте до списку, створивши меню

конфігурації з використанням "some_list" як префікса - для

приклад: [menu some_list some_item_in_the_list]

vsdlist — те саме, що й «список», але додаватиме файли з віртуальної sdcard

(буде видалено в майбутньому)

#ім'я:

Назва пункту меню - оцінюється як шаблон.

#включити:

Шаблон, який має значення True або False.

#index:

Позиція, де потрібно вставити елемент у список. За умовчанням

елемент додається в кінці.

#[меню some_list] #тип: список #ім'я: #включити:

Опис цих параметрів див. вище.

#[меню some_list some_command] #тип: команда #ім'я: #включити:

Опис цих параметрів див. вище.

#gcode:

Скрипт для запуску після натискання кнопки або тривалого натискання. Оцінюється як a

шаблон.

#[меню some_list some_input] #тип: вхід #ім'я: #включити:

Опис цих параметрів див. вище.

#вхід:

Початкове значення для використання під час редагування - оцінюється як шаблон.

Результат має бути float.

#input_min:

Мінімальне значення діапазону - оцінюється як шаблон. За замовчуванням -99999.

#input_max:

Максимальне значення діапазону - оцінюється як шаблон. За замовчуванням 99999.

#input_step:

Крок редагування – має бути додатним цілим числом або значенням з плаваючою точкою. Це має

внутрішній швидкий крок. Коли "(input_max - input_min) /

input_step > 100", тоді швидкий крок становить 10 * input_step, інакше швидко

крок швидкості – це той самий input_step.

#в реальному часі:

Цей атрибут приймає статичне логічне значення. Коли ввімкнено тоді

сценарій gcode запускається після кожної зміни значення. За замовчуванням значення False.

#gcode:

Скрипт для запуску після натискання кнопки, тривалого натискання або зміни значення.

Оцінюється як шаблон. Натискання кнопки запустить редагування

початок або кінець режиму.
```

## Датчики розжарювання

### [filament_switch_sensor]

Датчик перемикання нитки. Підтримка виявлення вставки та биття нитки за допомогою датчика перемикача, наприклад кінцевого перемикача.

Додаткову інформацію див. у [довідці щодо команд](G-Codes.md#filament_switch_sensor).

```
[filament_switch_sensor my_sensor]
#pause_on_runout: True
#   When set to True, a PAUSE will execute immediately after a runout
#   is detected. Note that if pause_on_runout is False and the
#   runout_gcode is omitted then runout detection is disabled. Default
#   is True.
#runout_gcode:
#   A list of G-Code commands to execute after a filament runout is
#   detected. See docs/Command_Templates.md for G-Code format. If
#   pause_on_runout is set to True this G-Code will run after the
#   PAUSE is complete. The default is not to run any G-Code commands.
#insert_gcode:
#   A list of G-Code commands to execute after a filament insert is
#   detected. See docs/Command_Templates.md for G-Code format. The
#   default is not to run any G-Code commands, which disables insert
#   detection.
#event_delay: 3.0
#   The minimum amount of time in seconds to delay between events.
#   Events triggered during this time period will be silently
#   ignored. The default is 3 seconds.
#pause_delay: 0.5
#   The amount of time to delay, in seconds, between the pause command
#   dispatch and execution of the runout_gcode. It may be useful to
#   increase this delay if OctoPrint exhibits strange pause behavior.
#   Default is 0.5 seconds.
#debounce_delay:
#   A period of time in seconds to debounce events prior to running the
#   switch gcode. The switch must he held in a single state for at least
#   this long to activate. If the switch is toggled on/off during this delay,
#   the event is ignored. Default is 0.
#switch_pin:
#   The pin on which the switch is connected. This parameter must be
#   provided.
```

### [filament_motion_sensor]

Датчик руху нитки. Підтримка виявлення вставки та биття нитки за допомогою кодера, який перемикає вихідний штифт під час руху нитки через датчик.

Додаткову інформацію див. у [довідці щодо команд](G-Codes.md#filament_switch_sensor).

```
[filament_motion_sensor my_sensor] довжина_виявлення: 7,0

Мінімальна довжина нитки розжарення, протягнутої через датчик для спрацьовування

зміна стану на switch_pin

За замовчуванням 7 мм.

екструдер:

Назва секції екструдера, з якою пов’язаний цей датчик.

Цей параметр необхідно вказати.

switch_pin: #pause_on_runout: #runout_gcode: #insert_gcode: #event_delay: #pause_delay:

Перегляньте розділ "filament_switch_sensor" для опису

параметр вище.
```

### [tsl1401cl_filament_width_sensor]

Датчик ширини нитки на основі TSLl401CL. Додаткову інформацію див. у [посібнику](TSL1401CL_Filament_Width_Sensor.md).

```
[tsl1401cl_filament_width_sensor] #pin: #default_nominal_filament_diameter: 1,75 # (мм)

Максимально допустима різниця діаметрів нитки розжарення в мм.

#max_difference: 0,2

Відстань від датчика до плавильної камери в мм.

#затримка_вимірювання: 100
```

### [сенсор_ширини_нитки_холу]

Датчик ширини нитки Холла (див. Датчик ширини нитки Холла).

```
[сенсор_ширини_нитки_холу] adc1: adc2:

Аналогові входи, підключені до датчика. Ці параметри повинні

бути надано.

#cal_dia1: 1,50 #cal_dia2: 2.00

Значення калібрування (у мм) для датчиків. За замовчуванням

1.50 для cal_dia1 і 2.00 для cal_dia2.

#raw_dia1: 9500 #raw_dia2: 10500

Необроблені значення калібрування для датчиків. За замовчуванням 9500

для raw_dia1 і 10500 для raw_dia2.

#default_nominal_filament_diameter: 1,75

Номінальний діаметр нитки. Цей параметр необхідно вказати.

#max_difference: 0,200

Максимально допустима різниця діаметрів нитки в міліметрах (мм).

Якщо різниця між номінальним діаметром нитки і вихідним сигналом датчика

більше ніж +- max_difference, множник екструзії встановлюється назад

до %100. За замовчуванням 0,200.

#затримка_вимірювання: 70

Відстань від датчика до плавильної камери/гарячого кінця

міліметрів (мм). Нитка розжарення між датчиком і гарячим кінцем

буде розглядатися як номінальний_діаметр нитки за замовчуванням. Хост

модуль працює з логікою FIFO. Він зберігає значення кожного датчика та

позицію в масиві та POP їх назад у правильну позицію. Це

Потрібно вказати # параметр. #enable: False

Датчик увімкнено або вимкнено після ввімкнення. Типовим значенням є

відключити.

#інтервал_вимірів: 10

Приблизна відстань (у мм) між показаннями датчика. The

за замовчуванням 10 мм.

#logging: False

Вихідний діаметр до терміналу та klipper.log можна ввімкнути

команда.

#мін_діаметр: 1,0

Мінімальний діаметр для запуску віртуального filament_switch_sensor.

#use_current_dia_while_delay: невірно

Використовуйте поточний діаметр замість номінального

затримка вимірювання не закінчилася.

#pause_on_runout: #runout_gcode: #insert_gcode: #event_delay: #pause_delay:

Перегляньте розділ "filament_switch_sensor" для опису

параметр вище.
```

## Датчики навантаження

### [load_cell]

Датчик навантаження. Використовує датчик АЦП, прикріплений до тензодатчика, для створення цифрових ваг.

```
[load_cell]
sensor_type:
#   This must be one of the supported sensor types, see below.
#counts_per_gram:
#   The floating point number of sensor counts that indicates 1 gram of force.
#   This value is calculated by the LOAD_CELL_CALIBRATE command.
#reference_tare_counts:
#   The integer tare value, in raw sensor counts, taken when LOAD_CELL_CALIBRATE
#   is run. This is the default tare value when klipper starts up.
#sensor_orientation:
#   Change the sensor's orientation. Can be either 'normal' or 'inverted'.
#   The default is 'normal'. Use 'inverted' if the sensor reports a
#   decreasing force value when placed under load.
```

#### HX711

Це 24-бітний чіп із низькою частотою дискретизації, який використовує зв’язок «bit-bang». Підходить для нитяних лусочок.

```
[load_cell] тип_датчика: hx711 sclk_pin:

Штифт, підключений до тактової лінії HX711. Цей параметр необхідно вказати.

dout_pin:

Штифт, підключений до лінії виведення даних HX711. Цей параметр повинен бути

надано.

#посилення: A-128

Дійсні значення посилення: A-128, A-64, B-32. Типовим є A-128.

'A' позначає вхідний канал, а цифра позначає посилення. Тільки 3

перераховані комбінації підтримуються чіпом. Зверніть увагу, що зміна посилення

Параметр # також вибирає канал, який читається. #sample_rate: 80

Дійсні значення для sample_rate — 80 або 10. Значення за замовчуванням — 80.

Це має відповідати розводці чіпа. Частоту дискретизації не можна змінити

в програмному забезпеченні.
```

#### HX717

Це версія HX711 з 4-кратною вищою частотою дискретизації, придатна для зондування.

```
[load_cell] тип_датчика: hx717 sclk_pin:

Штифт, підключений до тактової лінії HX717. Цей параметр необхідно вказати.

dout_pin:

Штифт, підключений до лінії виведення даних HX717. Цей параметр повинен бути

надано.

#посилення: A-128

Дійсні значення посилення: A-128, B-64, A-64, B-8.

'A' позначає вхідний канал, а цифра позначає налаштування посилення.

Чіп підтримує тільки 4 перераховані комбінації. Зауважте, що

зміна налаштування посилення також вибирає канал, який зчитується.

#sample_rate: 320

Дійсні значення для sample_rate: 10, 20, 80, 320. За замовчуванням 320.

Це має відповідати розводці чіпа. Частоту дискретизації не можна змінити

в програмному забезпеченні.
```

#### ADS1220

ADS1220 — це 24-розрядний АЦП, що підтримує частоту дискретизації до 2 КГц, яку можна налаштувати програмно.

```
[load_cell]
sensor_type: ads1220
cs_pin:
#   The pin connected to the ADS1220 chip select line. This parameter must
#   be provided.
#spi_speed: 512000
#   This chip supports 2 speeds: 256000 or 512000. The faster speed is only
#   enabled when one of the Turbo sample rates is used. The correct spi_speed
#   is selected based on the sample rate.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
data_ready_pin:
#   Pin connected to the ADS1220 data ready line. This parameter must be
#   provided.
#gain: 128
#   Valid gain values are 128, 64, 32, 16, 8, 4, 2, 1
#   The default is 128
#pga_bypass: False
#   Disable the internal Programmable Gain Amplifier. If
#   True the PGA will be disabled for gains 1, 2, and 4. The PGA is always
#   enabled for gain settings 8 to 128, regardless of the pga_bypass setting.
#   If AVSS is used as an input pga_bypass is forced to True.
#   The default is False.
#sample_rate: 660
#   This chip supports two ranges of sample rates, Normal and Turbo. In turbo
#   mode the chip's internal clock runs twice as fast and the SPI communication
#   speed is also doubled.
#   Normal sample rates: 20, 45, 90, 175, 330, 600, 1000
#   Turbo sample rates: 40, 90, 180, 350, 660, 1200, 2000
#   The default is 660
#input_mux:
#   Input multiplexer configuration, select a pair of pins to use. The first pin
#   is the positive, AINP, and the second pin is the negative, AINN. Valid
#   values are: 'AIN0_AIN1', 'AIN0_AIN2', 'AIN0_AIN3', 'AIN1_AIN2', 'AIN1_AIN3',
#   'AIN2_AIN3', 'AIN1_AIN0', 'AIN3_AIN2', 'AIN0_AVSS', 'AIN1_AVSS', 'AIN2_AVSS'
#   and 'AIN3_AVSS'. If AVSS is used the PGA is bypassed and the pga_bypass
#   setting will be forced to True.
#   The default is AIN0_AIN1.
#vref:
#   The selected voltage reference. Valid values are: 'internal', 'REF0', 'REF1'
#   and 'analog_supply'. Default is 'internal'.
```

### [load_cell_probe]

Load Cell Probe. This combines the functionality of a [probe] and a [load_cell].

```
[load_cell_probe]
sensor_type:
#   This must be one of the supported bulk ADC sensor types and support
#   load cell endstops on the mcu.
#counts_per_gram:
#reference_tare_counts:
#sensor_orientation:
#   These parameters must be configured before the probe will operate.
#   See the [load_cell] section for further details.
#force_safety_limit: 2000
#   The safe limit for probing force relative to the reference_tare_counts on
#   the load_cell. The default is +/-2Kg.
#trigger_force: 75.0
#   The force that the probe will trigger at. 75g is the default.
#drift_filter_cutoff_frequency: 0.8
#   Enable optional continuous taring while homing & probing to reject drift.
#   The value is a frequency, in Hz, below which drift will be ignored. This
#   option requires the SciPy library. Default: None
#drift_filter_delay: 2
#   The delay, or 'order', of the drift filter. This controls the number of
#   samples required to make a trigger detection. Can be 1 or 2, the default
#   is 2.
#buzz_filter_cutoff_frequency: 100.0
#   The value is a frequency, in Hz, above which high frequency noise in the
#   load cell will be igfiltered outnored. This option requires the SciPy
#   library. Default: None
#buzz_filter_delay: 2
#   The delay, or 'order', of the buzz filter. This controle the number of
#   samples required to make a trigger detection. Can be 1 or 2, the default
#   is 2.
#notch_filter_frequencies: 50, 60
#   1 or 2 frequencies, in Hz, to filter out of the load cell data. This is
#   intended to reject power line noise. This option requires the SciPy
#   library.  Default: None
#notch_filter_quality: 2.0
#   Controls how narrow the range of frequencies are that the notch filter
#   removes. Larger numbers produce a narrower filter. Minimum value is 0.5 and
#   maximum is 3.0. Default: 2.0
#tare_time:
#   The rime in seconds used for taring the load_cell before each probe. The
#   default value is: 4 / 60 = 0.066. This collects samples from 4 cycles of
#   60Hz mains power to cancel power line noise.
#z_offset:
#speed:
#samples:
#sample_retract_dist:
#lift_speed:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#   See the "[probe]" section for a description of the above parameters.
```

## Спеціальна апаратна підтримка плати

### [sx1509]

Налаштуйте розширювач SX1509 I2C на GPIO. Через затримку, спричинену зв’язком I2C, вам НЕ слід використовувати контакти SX1509 як крокові ввімкнення, крокові або напрямні контакти або будь-які інші контакти, які потребують швидкої обробки бітів. Їх найкраще використовувати як статичні чи керовані gcode цифрові виходи або штифти апаратної ШІМ для, наприклад, вентиляторів. Можна визначити будь-яку кількість розділів із префіксом "sx1509". Кожен розширювач має набір із 16 контактів (sx1509_my_sx1509:PIN_0 до sx1509_my_sx1509:PIN_15), які можна використовувати в конфігурації принтера.

Перегляньте приклад файлу [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg).

```
[sx1509 my_sx1509]
 i2c_адреса:
 # Адреса I2C, що використовується цим розширювачем. Залежно від обладнання
 # перемички це одна з наступних адрес: 62 63 112
 # 113. Цей параметр необхідно вказати.
 #i2c_mcu:
 #i2c_bus:
 #i2c_software_scl_pin:
 #i2c_software_sda_pin:
 #i2c_швидкість:
 # Перегляньте розділ «Загальні налаштування I2C», щоб отримати опис
 # параметр вище.
```

### [samd_sercom]

Конфігурація SAMD SERCOM, щоб визначити, які контакти використовувати на певному SERCOM. Можна визначити будь-яку кількість розділів із префіксом "samd_sercom". Кожен SERCOM необхідно налаштувати перед використанням як периферійного пристрою SPI або I2C. Розмістіть цей розділ конфігурації над будь-яким іншим розділом, який використовує шини SPI або I2C.

```
[samd_sercom my_sercom]
 sercom:
 # Назва шини Sercom для налаштування в мікроконтролері.
 # Доступні імена: "sercom0", "sercom1" тощо. Цей параметр
 Потрібно вказати #.
 tx_pin:
 # PIN-код MOSI для зв’язку SPI або контакт SDA (дані) для I2C
 # спілкування. PIN-код повинен мати дійсну конфігурацію pinmux
 # для даного периферійного пристрою SERCOM. Цей параметр необхідно вказати.
 #rx_pin:
 # PIN MISO для зв'язку SPI. Цей контакт не використовується для I2C
 # зв'язок (I2C використовує tx_pin як для надсилання, так і для отримання).
 # PIN-код повинен мати дійсну конфігурацію pinmux для даного
 # Периферійний пристрій SERCOM. Цей параметр необов'язковий.
 clk_pin:
 # Штифт CLK для зв'язку SPI або контакт SCL (тактовий сигнал) для I2C
 # спілкування. PIN-код повинен мати дійсну конфігурацію pinmux
 # для даного периферійного пристрою SERCOM. Цей параметр необхідно вказати.
```

### [adc_scaled]

Аналогове масштабування Duet2 Maestro за показниками vref і vssa. Визначення розділу adc_scaled увімкне віртуальні контакти ADC (наприклад, «my_name:PB0»), які автоматично регулюються контактами моніторингу vref і vssa плати. Обов’язково визначте цей розділ конфігурації над усіма розділами конфігурації, які використовують ці віртуальні контакти.

Перегляньте приклад файлу [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg).

```
[adc_scaled my_name] vref_pin:

Штифт АЦП для моніторингу VREF. Цей параметр повинен бути

надано.

vssa_pin:

Штифт АЦП для моніторингу VSSA. Цей параметр повинен бути

надано.

#smooth_time: 2.0

Значення часу (у секундах), протягом якого vref і vssa

вимірювання буде згладжено, щоб зменшити вплив вимірювання

#шум. За замовчуванням 2 секунди.
```

### [ads1x1x]

ADS1013, ADS1014, ADS1015, ADS1113, ADS1114 and ADS1115 are I2C based Analog to Digital Converters that can be used for temperature sensors. They provide 4 analog input pins either as single line or as differential input.

Note: Use caution if using this sensor to control heaters. The heater min_temp and max_temp are only verified in the host and only if the host is running and operating normally. (ADC inputs directly connected to the micro-controller verify min_temp and max_temp within the micro-controller and do not require a working connection to the host.)

```
[ads1x1x my_ads1x1x]
chip: ADS1115
#pga: 4.096V
#   Default value is 4.096V. The maximum voltage range used for the input. This
#   scales all values read from the ADC. Options are: 6.144V, 4.096V, 2.048V,
#   1.024V, 0.512V, 0.256V
#adc_voltage: 3.3
#   The suppy voltage for the device. This allows additional software scaling
#   for all values read from the ADC.
i2c_mcu: host
i2c_bus: i2c.1
#address_pin: GND
#   Default value is GND.  There can be up to four addressed devices depending
#   upon wiring of the device. Check the datasheet for details. The i2c_address
#   can be specified directly instead of using the address_pin.
```

The chip provides pins that can be used on other sensors.

```
sensor_type: ...
#   Can be any thermistor or adc_temperature.
sensor_pin: my_ads1x1x:AIN0
#   A combination of the name of the ads1x1x chip and the pin. Possible
#   pin values are AIN0, AIN1, AIN2 and AIN3 for single ended lines and
#   DIFF01, DIFF03, DIFF13 and DIFF23 for differential between their
#   correspoding lines. For example
#   DIFF03 measures the differential between line 0 and 3. Only specific
#   combinations for the differentials are allowed.
```

### [репліка]

Підтримка реплікатів – дивіться [посібник з beaglebone](Beaglebone.md) і файл [generic-replicape.cfg](../config/generic-replicape.cfg) для прикладу.

```
# Розділ конфігурації "replicape" додає "replicape:stepper_x_enable"
 # шпильки для активації віртуального степера (для степерів X, Y, Z, E та H) і
 # "replicape:power_x" Вихідні контакти ШІМ (для hotbed, e, h, fan0, fan1,
 # fan2 і fan3), які потім можна використовувати в іншому місці конфігураційного файлу.
 [репліка]
 версія:
 # Версія апаратного забезпечення копії. На даний момент є лише версія "B3".
 # підтримується. Цей параметр необхідно вказати.
 #enable_pin: !gpio0_20
 # Глобальний пін активації репліки. Типовим є !gpio0_20 (він же
 # P9_41).
 host_mcu:
 # Назва розділу конфігурації mcu, який взаємодіє з
 # Екземпляр mcu "процес linux" Klipper. Цей параметр повинен бути
 # надано.
 #standstill_power_down: Неправда
 # Цей параметр керує лінією CFG6_ENN на всіх степерах
 # мотори. True встановлює для активних ліній значення "відкриті". За замовчуванням
 # Неправда.
 #stepper_x_microstep_mode:
 #stepper_y_microstep_mode:
 #stepper_z_microstep_mode:
 #stepper_e_microstep_mode:
 #stepper_h_microstep_mode:
 # Цей параметр керує виводами CFG1 і CFG2 заданого
 # драйвер крокового двигуна. Доступні варіанти: вимкнути, 1, 2,
 # spread2, 4, 16, spread4, spread16, stealth4 і stealth16.  The
 # за умовчанням вимкнено.
 #stepper_x_current:
 #stepper_y_current:
 #stepper_z_current:
 #stepper_e_current:
 #stepper_h_current:
 # Сконфігурований максимальний струм (в амперах) крокового двигуна
 # водій. Цей параметр необхідно вказати, якщо степпер знаходиться не в a
 # режим вимкнення.
 #stepper_x_chopper_off_time_high:
 #stepper_y_chopper_off_time_high:
 #stepper_z_chopper_off_time_high:
 #stepper_e_chopper_off_time_high:
 #stepper_h_chopper_off_time_high:
 # Цей параметр керує контактом CFG0 драйвера крокового двигуна
 # (True встановлює CFG0 на високий рівень, False встановлює його на низький). За замовчуванням значення False.
 #stepper_x_chopper_hysteresis_high:
 #stepper_y_chopper_hysteresis_high:
 #stepper_z_chopper_hysteresis_high:
 #stepper_e_chopper_hysteresis_high:
 #stepper_h_chopper_hysteresis_high:
 # Цей параметр керує контактом CFG4 драйвера крокового двигуна
 # (True встановлює CFG4 на високий рівень, False встановлює його на низький). За замовчуванням значення False.
 #stepper_x_chopper_blank_time_high:
 #stepper_y_chopper_blank_time_high:
 #stepper_z_chopper_blank_time_high:
 #stepper_e_chopper_blank_time_high:
 #stepper_h_chopper_blank_time_high:
 # Цей параметр керує контактом CFG5 драйвера крокового двигуна
 # (True встановлює CFG5 на високий рівень, False встановлює його на низький). Типовим значенням є True.
```

## Інші спеціальні модулі

### [палітра2]

Багатоматеріальна підтримка Palette 2 - забезпечує більш тісну інтеграцію, підтримуючи пристрої Palette 2 у підключеному режимі.

Ці модулі також потребують `[virtual_sdcard]` і `[pause_resume]` для повної функціональності.

Якщо ви використовуєте цей модуль, не використовуйте плагін Palette 2 для Octoprint, оскільки вони конфліктуватимуть, і 1 не вдасться правильно ініціалізувати, імовірно, ваш друк буде перервано.

If you use Octoprint and stream gcode over the serial port instead of printing from virtual_sd, then remove **M1** and **M0** from *Pausing commands* in *Settings > Serial Connection > Firmware & protocol* will prevent the need to start print on the Palette 2 and unpausing in Octoprint for your print to begin.

```
[палітра2] серійний:

Послідовний порт для підключення до Palette 2.

#бод: 115200

Швидкість передачі даних для використання. За замовчуванням 115200.

#feedrate_splice: 0,8

Швидкість подачі, яка використовується під час зварювання, за замовчуванням становить 0,8

#feedrate_normal: 1,0

Швидкість подачі, яка використовується після зварювання, за замовчуванням 1,0

#швидкість_автозавантаження: 2

Швидкість подачі екструзії під час автозавантаження, за замовчуванням 2 (мм/с)

#auto_cancel_variation: 0.1

Автоматичне скасування друку, коли зміна ping вище цього порогу
```

### [кут]

Підтримка магнітного датчика кута Холла для зчитування вимірювань кута вала крокового двигуна за допомогою мікросхем SPI a1333, as5047d, mt6816, mt6826s або tle5012b. Вимірювання доступні через [API-сервер](API_Server.md) і [інструмент аналізу руху](Debugging.md#motion-analysis-and-data-logging). Доступні команди див. у [довідці G-Code](G-Codes.md#angle).

```
[angle my_angle_sensor]
sensor_type:
#   The type of the magnetic hall sensor chip. Available choices are
#   "a1333", "as5047d", "mt6816", "mt6826s", and "tle5012b". This parameter must be
#   specified.
#sample_period: 0.000400
#   The query period (in seconds) to use during measurements. The
#   default is 0.000400 (which is 2500 samples per second).
#stepper:
#   The name of the stepper that the angle sensor is attached to (eg,
#   "stepper_x"). Setting this value enables an angle calibration
#   tool. To use this feature, the Python "numpy" package must be
#   installed. The default is to not enable angle calibration for the
#   angle sensor.
cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
```

## Загальні параметри шини

### Загальні налаштування SPI

Наступні параметри зазвичай доступні для пристроїв, які використовують шину SPI.

```
#spi_speed:
 # Швидкість SPI (у Гц), яка використовується під час обміну даними з пристроєм.
 # Значення за замовчуванням залежить від типу пристрою.
 #spi_bus:
 # Якщо мікроконтролер підтримує кілька шин SPI, то одна може
 # вкажіть тут назву шини мікроконтролера. За замовчуванням залежить від
 # тип мікроконтролера.
 #spi_software_sclk_pin:
 #spi_software_mosi_pin:
 #spi_software_miso_pin:
 # Вкажіть наведені вище параметри, щоб використовувати "SPI на основі програмного забезпечення". Це
 Режим # не вимагає апаратної підтримки мікроконтролера (зазвичай
 # можна використовувати будь-які штифти загального призначення). За умовчанням не використовувати
 # "програмне забезпечення spi".
```

### Загальні налаштування I2C

Наступні параметри зазвичай доступні для пристроїв, які використовують шину I2C.

Зауважте, що поточна підтримка мікроконтролерів Klipper для I2C, як правило, нетерпима до лінійного шуму. Неочікувані помилки в проводах I2C можуть призвести до того, що Klipper викличе помилку виконання. Підтримка Klipper для відновлення помилок залежить від кожного типу мікроконтролера. Зазвичай рекомендується використовувати лише пристрої I2C, які розташовані на одній друкованій платі з мікроконтролером.

Більшість реалізацій мікроконтролерів Klipper підтримують лише `i2c_speed` 100000 (*стандартний режим*, 100 кбіт/с). Мікроконтролер Klipper "Linux" підтримує швидкість 400 000 (*швидкий режим*, 400 кбіт/с), але вона має бути [встановлена в операційній системі] (RPi_microcontroller.md#optional-enabling-i2c), а параметр `i2c_speed` інакше ігнорується. Сімейство мікроконтролерів Klipper "RP2040" і ATmega AVR, а також деякі STM32 (F0, G0, G4, L4, F7, H7) підтримують швидкість 400 000 за допомогою параметра `i2c_speed`. Усі інші мікроконтролери Klipper використовують швидкість 100 000 і ігнорують параметр `i2c_speed`.

```
#i2c_адреса:

i2c-адреса пристрою. Це має бути вказано як десяткове число

число (не в шістнадцятковому). Стандартне значення залежить від типу пристрою.

#i2c_mcu:

Назва мікроконтролера, до якого підключено чіп.

Типовим є "mcu".

#i2c_bus:

Якщо мікроконтролер підтримує кілька шин I2C, то одна може

вкажіть тут назву шини мікроконтролера. За замовчуванням залежить від

тип мікроконтролера.

#i2c_software_scl_pin: #i2c_software_sda_pin:

Укажіть ці параметри, щоб використовувати програмне забезпечення на основі мікроконтролера

Підтримка I2C "bit-banging". Два параметри мають бути двома контактами

на мікроконтролері для використання проводів scl і sda. The

за замовчуванням використовується апаратна підтримка I2C, як зазначено в

Параметр i2c_bus.

#i2c_швидкість:

Швидкість I2C (у Гц), яка використовується під час обміну даними з пристроєм.

Реалізація Klipper на більшості мікроконтролерів жорстко закодована

до 100000, і зміна цього значення не має ефекту. За замовчуванням

100000. Linux, RP2040 і ATmega підтримують 400000.
```
