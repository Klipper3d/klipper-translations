# КАНБУС Виправлення несправностей

Цей документ надає інформацію про проблеми з усунення неполадок при використанні [Кліппер з автобусом CAN](CANBUS.md).

## Verify CAN автобусний електропроводка

Першим кроком у вирішенні проблемних питань зв'язку є перевірка проводки CAN.

Be sure there are exactly two 120 Ohm [terminating
resistors](CANBUS.md#terminating-resistors) on the CAN bus. If the resistors are not properly installed then messages may not be able to be sent at all or the connection may have sporadic instability.

Автопроводка CANH та CANL повинна бути перекручена між собою. На мінімумі проводка повинна мати скручування кожні кілька сантиметрів. Уникайте скручування проводів CANH і CANL навколо проводів живлення і переконайтеся, що проводи живлення, які подорожують паралельно до проводів CANH і CANL, не мають однакової кількості скручувань.

Перевірити, що всі штекери та дротові креветки на автобусі CAN повністю закріплюються. Рух принтера інструментголова може зануритися в проводку CAN, викликаючи поганий дротовий щіпка або непропущений штепсель, щоб призвести до переривчастих помилок зв'язку.

## Перевірити для зняття байтів_інвалідний лічильник

Файл журналу Klipper буде звітувати `Stats` рядок один раз, коли принтер активний. Ці лінійки «Стати» мають `байти_invalid` лічильник для кожного мікроконтролера. Цей лічильник не повинен підходити під час нормальної роботи принтера (це нормально для лічильника, щоб бути незеро після RESTART, і це не стосується, якщо протипоказання один раз на місяць або так). Якщо це протипоказання на мікроконтролері CAN на мікроконтролері CAN під час нормального друку (приблизні кожні кілька годин або частіше), то це індикація важкої проблеми.

Incrementing `bytes_invalid` on a CAN bus connection is a symptom of reordered messages on the CAN bus. If seen, make sure to:

* Use a Linux kernel version 6.6.0 or later.
* If using a USB-to-CANBUS adapter running candlelight firmware, use v2.0 or later of candleLight_fw.
* If using Klipper's USB-to-CANBUS bridge mode, make sure the bridge node is flashed with Klipper v0.12.0 or later.

Reordered messages is a severe problem that must be fixed. It will result in unstable behavior and can lead to confusing errors at any part of a print. An incrementing `bytes_invalid` is not caused by wiring or similar hardware issues and can only be fixed by identifying and updating the faulty software.

Older versions of the Linux kernel had a bug in the gs_usb canbus driver code that could cause reordered canbus packets. The issue is thought to be fixed in [Linux commit 24bc41b4](https://github.com/torvalds/linux/commit/24bc41b4558347672a3db61009c339b1f5692169) which was released in v6.6.0. In some cases, older Linux versions may not show the problem (due to how hardware interrupts are configured), however if problems are seen the recommended solution is to upgrade to a newer kernel.

Older versions of candlelight firmware could reorder canbus packets, and the issue is thought to be fixed in [candlelight_fw commit 8b3a7b45](https://github.com/candle-usb/candleLight_fw/commit/8b3a7b4565a3c9521b762b154c94c72c5acb2bcf).

Older versions of Klipper's USB-to-CANBUS bridge code could incorrectly drop canbus messages. This is not as severe as reordering messages, but it should still be fixed. It is thought to be fixed with [Klipper PR #6175](https://github.com/Klipper3d/klipper/pull/6175).

## Використовуйте відповідні налаштування txqueuelen

Код Klipper використовує ядро Linux для управління трафіком CAN. За замовчуванням ядро буде тільки черга 10 CAN. Рекомендовано [configure the can0 device](CANBUS.md#host-hardware) з `txqueuelen 128` для збільшення цього розміру.

Якщо Klipper передає пакет і Linux заповнить весь простір передачі, то Linux знизить цей пакет і повідомлення, як показано наступне, з'явиться в журналі Klipper:

```
Got error -1 in може написати: (105)Не доступний буферний простір
```

Klipper автоматично перетворить втрачені повідомлення в складі системи переадресації поточного рівня програми. Таким чином, це повідомлення журналу є попередженням і він не вказує на невідновлювальну помилку.

Якщо відбувається повна відмова автобуса CAN (наприклад, перерву дроту CAN), то Linux не зможе передавати будь-які повідомлення на автобусі CAN і є загальним, щоб знайти вище повідомлення в журналі Klipper. У цьому випадку лог-повідомлення є симптомом більшої проблеми (здатність передачі будь-яких повідомлень) і не безпосередньо пов'язана з Linux `txqueuelen`.

Один може перевірити поточний розмір черги за допомогою команди Linux `ip посилання show can0`. Повідомляти пучок тексту, включаючи хіппе `qlen 128`. Якщо ви бачите щось схоже `qlen 10`, то це вказує на пристрій CAN не було належним чином налаштовано.

Не рекомендується використовувати `txqueuelen` значно більше 128. автобус CAN, який працює на частоті 1000000, зазвичай займе близько 120us для передачі пакету CAN. Таким чином, черга 128 пакетів, ймовірно, займе близько 15-20 метрів для зливу. Значно більша черга може призвести до надмірних спій в повідомлення кругло-часовому режимі, що може призвести до небажаних помилок. Збережіть ще один спосіб, система переадресації програми Klipper є більш надійним, якщо вона не повинна чекати Linux, щоб злити надмірно велику чергу, можливо, застою даних. Це аналог з проблемою [bufferbloat](https://en.wikipedia.org/wiki/Bufferbloat) в маршрутизаторах Інтернету.

При нормальних обставинах Klipper може використовувати ~25 черги слотів для MCU - зазвичай тільки використовуючи більше слотів під час переадресації. (Своїсно, хост Кліппер може передавати до 192 байтів до кожного Кліппера МКУ перед отриманням відступу від цього МКУ.) Якщо один автобус CAN має 5 або більше Klipper MCUs на ньому, то це може знадобитися для збільшення `txqueuelen` над рекомендованою вартістю 128. Однак, як і вище, догляд слід приймати при виборі нового значення, щоб уникнути зайвої затримки часу.

## Use `canbus_query.py` only to identify nodes never previously seen

It is only valid to use the [`canbus_query.py` tool](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) to identify micro-controllers that have never been previously identified. Once all nodes on a bus are identified, record the resulting uuids in the printer.cfg, and avoid running the tool unnecessarily.

The tool is implemented using a low-level mechanism that can cause nodes to internally observe bus errors. These internal errors may result in communication interruptions and may result is some nodes disconnecting from the bus.

It is not valid to use the tool to "ping" if a node is connected. Do not run the tool during an active print.

## Зберігаючі колоди

Повідомлення автобуса CAN і з мікроконтролера керуються ядром Linux. Ви можете захопити ці повідомлення з ядра для розвантаження цілей. Журнал цих повідомлень може використовуватися в діагностиці.

Інструмент Linux [can-utils](https://github.com/linux-can/can-utils) надає програмне забезпечення для захоплення. Зазвичай він встановлюється на машину за допомогою:

```
sudo apt-get update & & sudo apt-get встановити can-utils
```

Після встановлення, можна отримати захоплення всіх повідомлень про автобуси CAN на інтерфейсі з наступним командуванням:

```
#FFFFFFFFFFFFFFFF > Дельсаль Груп Український
```

Один може переглянути отриманий файл журналу (`mycanlog`, щоб побачити кожну сиру CAN автобусне повідомлення, яке було відправлено і отримано Klipper. Розуміння вмісту цих повідомлень, ймовірно, зажадає низьким рівнем знань протоколу Klipper's [CANBUS](CANBUS_protocol.md) і Klipper's [MCU команди](MCU_Commands.md).

### Повідомлень Кліппера в журналі кандемп

Один може використовуватися `parsecandump.py` інструментом для запарювання низькорівневих мікроконтролерів, що містяться в кандump log. За допомогою цього інструменту є розширена тема, яка вимагає знання Klipper [MCU команди](MCU_Commands.md). Наприклад:

```
./scripts/parsecandump.py my canlog 108 ./out/klipper.dict
```

This tool produces output similar to the [parsedump
tool](Debugging.md#translating-gcode-files-to-micro-controller-commands). See the documentation for that tool for information on generating the Klipper micro-controller data dictionary.

In the above example, `108` is the [CAN bus
id](CANBUS_protocol.md#micro-controller-id-assignment). It is a hexadecimal number. The id `108` is assigned by Klipper to the first micro-controller. If the CAN bus has multiple micro-controllers on it, then the second micro-controller would be `10a`, the third would be `10c`, and so on.

Журнал може бути виготовлений за допомогою `-tz -Ddex` аргументів командного рядка (наприклад: `candump -tz -Ddex can0,#FFFFFFFFFF`) для використання `parsecandump.py`.

## Використання логіки аналізатора на проводці каналів

[Sigrok Pulseview](https://sigrok.org/wiki/PulseView) програмне забезпечення разом з низькою вартістю [логічний аналізатор](https://en.wikipedia.org/wiki/Logic_analyzer) може бути корисною для діагностики автобусів CAN. Це розширена тема, швидше за все, тільки інтерес до експертів.

Часто можна знайти «УСБ-логічні аналізатори» за 15 доларів США (ВСЦ від 2023). Ці пристрої часто перераховані як "Продажі логічні клони" або як "24MHz 8 каналів USB-логічні аналізатори".

![pulseview -canbus](img/pulseview-canbus.png)

Наведено вищезгадане зображення при використанні Pulseview з логікою "Saleae clone". Програма Sigrok і Pulseview була встановлена на настільній машині (також встановити прошивку "fx2lafw", якщо вона упакована окремо). Пиріг CH0 на логічному аналізаторі був маршрутизований до лінії CAN Rx, штифт CH1 проводився до шпильки CAN Tx, а ГНД проводився до GND. Імпульсний перегляд був налаштований тільки для відображення D0 і D1 ліній (червоний "пробе" іконковий центр панелі інструментів). Кількість зразків була встановлена до 5 мільйонів (під панелі інструментів) і частота зразка була встановлена до 24Mhz (під панелі інструментів). Додана декодер CAN (жовтий і зелений "чорний значок" правий верхній панелі інструментів). Канал D0 був позначений як RX і встановити, щоб запустити на падіння краю (натисніть на ярлик D0 зліва). Канал D1 був позначений як TX (клацніть на коричневому етикетці D1 зліва). CAN decoder було налаштовано на 1Mbit курс (клацніть на зелену CAN етикетку зліва). CAN decoder було переведено в верхній частині дисплея (натисніть і перетягніть зелену CAN етикетку). Нарешті, захоплення було розпочато (клацніть "Run" у верхньому лівому верхньому куті) і пакет було передано на автобусі CAN (`cansend can0 123#121212121212`).

Логічний аналізатор забезпечує незалежний інструмент для захоплення пачок і перевірки термінів.
