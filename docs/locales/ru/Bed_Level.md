# Bed leveling

Выравнивание кровати (иногда также называемое "выравниванием стола") имеет решающее значение для получения высококачественных отпечатков. Если кровать не выровнен должным образом, это может привести к плохой адгезии слоя, "деформации" и незначительным проблемам по всей печати. Этот документ служит руководством по выполнению выравнивания слоя в Klipper.

Важно понимать цель выравнивания кровати. Если во время печати принтеру задается положение "X0 Y0 Z10", то цель состоит в том, чтобы сопло принтера находилось ровно в 10 мм от станины принтера. Кроме того, если затем принтеру будет дана команда на положение "X50 Z10", цель состоит в том, чтобы сопло сохраняло точное расстояние в 10 мм от станины во время всего этого горизонтального перемещения.

Для получения отпечатков хорошего качества принтер должен быть откалиброван таким образом, чтобы расстояния Z были точными с точностью примерно до 25 микрон (0,025 мм). Это небольшое расстояние - значительно меньше ширины обычного человеческого волоса. Эта шкала не может быть измерена "на глаз". Тонкие эффекты (такие как тепловое расширение) влияют на измерения в этом масштабе. Секрет получения высокой точности заключается в использовании повторяющегося процесса и метода выравнивания, который использует высокую точность собственной системы перемещения принтера.

## Выберите подходящий механизм калибровки

Различные типы принтеров используют разные методы для выполнения выравнивания ложа. Все они в конечном итоге зависят от "бумажного теста" (описанного ниже). Однако фактический процесс для конкретного типа принтера описан в других документах.

Перед запуском любого из этих инструментов калибровки обязательно выполните проверки, описанные в документе [config check document](Config_checks.md). Перед выполнением выравнивания станины необходимо проверить базовое движение принтера.

Для принтеров с "автоматическим Z-зондом" обязательно откалибруйте зонд, следуя указаниям в документе [Probe Calibrate](Probe_Calibrate.md). Для дельта-принтеров см. документ [Delta Calibrate](Delta_Calibrate.md). Для принтеров с винтами станины и традиционными концевыми упорами Z см. документ [Manual Level](Manual_Level.md).

Во время калибровки может потребоваться установить для параметра Z принтера `position_min` отрицательное число (например, `position_min = -2`). Принтер обеспечивает проверку границ даже во время процедуры калибровки. Установка отрицательного числа позволяет принтеру двигаться ниже номинального положения станины, что может помочь при попытке определить фактическое положение станины.

## "Бумажный тест"

Основным механизмом калибровки станины является "бумажный тест". Он включает в себя размещение обычного листа "копировальной бумаги" между станиной принтера и соплом, а затем подачу команды соплу на разные высоты Z до тех пор, пока не будет ощущаться небольшое трение при проталкивании бумаги вперед и назад.

Важно понимать "бумажный тест", даже если у вас есть "автоматический Z-зонд". Для получения хороших результатов часто требуется калибровка самого датчика. Калибровка датчика выполняется с помощью этого "бумажного теста".

In order to perform the paper test, cut a small rectangular piece of paper using a pair of scissors (eg, 5x3 cm). The paper generally has a thickness of around 100 microns (0.100mm). (The exact thickness of the paper isn't crucial.)

Первым шагом проверки бумаги является осмотр сопла и станины принтера. Убедитесь, что на сопле и станине нет пластика (или другого мусора).

**Осмотрите сопло и станину, чтобы убедиться в отсутствии пластика!**

If one always prints on a particular tape or printing surface then one may perform the paper test with that tape/surface in place. However, note that tape itself has a thickness and different tapes (or any other printing surface) will impact Z measurements. Be sure to rerun the paper test to measure each type of surface that is in use.

Если на сопле остался пластик, нагрейте экструдер и удалите его металлическим пинцетом. Подождите, пока экструдер полностью остынет до комнатной температуры, прежде чем продолжить тест бумаги. Пока насадка остывает, удалите металлическим пинцетом пластик, который может вытечь.

**Всегда проводите тест бумаги, когда сопло и станина находятся при комнатной температуре!**

When the nozzle is heated, its position (relative to the bed) changes due to thermal expansion. This thermal expansion is typically around a 100 microns, which is about the same thickness as a typical piece of printer paper. The exact amount of thermal expansion isn't crucial, just as the exact thickness of the paper isn't crucial. Start with the assumption that the two are equal (see below for a method of determining the difference between the two distances).

Может показаться странным калибровать расстояние при комнатной температуре, когда цель - получить постоянное расстояние при нагревании. Однако, если калибровать при нагретом сопле, то на бумагу попадает небольшое количество расплавленного пластика, что изменяет величину ощущаемого трения. Это затрудняет получение хорошей калибровки. Калибровка при горячем ложе/сопле также значительно повышает риск обжечься. Величина теплового расширения стабильна, поэтому ее легко учесть позже в процессе калибровки.

**Используйте автоматизированный инструмент для точного определения высоты Z!**

В Klipper есть несколько вспомогательных скриптов (например, MANUAL_PROBE, Z_ENDSTOP_CALIBRATE, PROBE_CALIBRATE, DELTA_CALIBRATE). Чтобы выбрать один из них, смотрите документы [описанные выше](#choose-the-appropriate-calibration-mechanism).

Запустите соответствующую команду в окне терминала OctoPrint. Сценарий запросит взаимодействие с пользователем в выводе терминала OctoPrint. Это будет выглядеть примерно так:

```
Recv: // Starting manual Z probe. Use TESTZ to adjust position.
Recv: // Finish with ACCEPT or ABORT command.
Recv: // Z position: ?????? --> 5.000 <-- ??????
```

Текущая высота сопла (как ее понимает принтер в данный момент) отображается между символами "--> <--". Число справа - это высота последней попытки зонда чуть больше текущей высоты, а слева - последняя попытка зонда меньше текущей высоты (или ??????, если попыток не было).

Поместите бумагу между соплом и станиной. Может быть полезно загнуть угол бумаги, чтобы ее было легче захватить. (Старайтесь не давить на станину при перемещении бумаги вперед-назад.)

![paper-test](img/paper-test.jpg)

Используйте команду TESTZ, чтобы запросить перемещение сопла ближе к бумаге. Например:

```
TESTZ Z=-.1
```

Команда TESTZ переместит сопло на относительное расстояние от текущего положения сопла. (Так, `Z=-.1` просит сопло переместиться ближе к станине на .1 мм.) После того, как сопло перестанет двигаться, подтолкните бумагу вперед-назад, чтобы проверить, соприкасается ли сопло с бумагой, и почувствовать трение. Продолжайте подавать команды TESTZ, пока не почувствуете небольшое трение при тестировании с бумагой.

If too much friction is found then one can use a positive Z value to move the nozzle up. It is also possible to use `TESTZ Z=+` or `TESTZ Z=-` to "bisect" the last position - that is to move to a position half way between two positions. For example, if one received the following prompt from a TESTZ command:

```
Recv: // Z position: 0.130 --> 0.230 <-- 0.280
```

Then a `TESTZ Z=-` would move the nozzle to a Z position of 0.180 (half way between 0.130 and 0.230). One can use this feature to help rapidly narrow down to a consistent friction. It is also possible to use `Z=++` and `Z=--` to return directly to a past measurement - for example, after the above prompt a `TESTZ Z=--` command would move the nozzle to a Z position of 0.130.

After finding a small amount of friction run the ACCEPT command:

```
ACCEPT
```

This will accept the given Z height and proceed with the given calibration tool.

The exact amount of friction felt isn't crucial, just as the amount of thermal expansion and exact width of the paper isn't crucial. Just try to obtain the same amount of friction each time one runs the test.

If something goes wrong during the test, one can use the `ABORT` command to exit the calibration tool.

## Determining Thermal Expansion

After successfully performing bed leveling, one may go on to calculate a more precise value for the combined impact of "thermal expansion", "thickness of the paper", and "amount of friction felt during the paper test".

This type of calculation is generally not needed as most users find the simple "paper test" provides good results.

The easiest way to make this calculation is to print a test object that has straight walls on all sides. The large hollow square found in [docs/prints/square.stl](prints/square.stl) can be used for this. When slicing the object, make sure the slicer uses the same layer height and extrusion widths for the first level that it does for all subsequent layers. Use a coarse layer height (the layer height should be around 75% of the nozzle diameter) and do not use a brim or raft.

Print the test object, wait for it to cool, and remove it from the bed. Inspect the lowest layer of the object. (It may also be useful to run a finger or nail along the bottom edge.) If one finds the bottom layer bulges out slightly along all sides of the object then it indicates the nozzle was slightly closer to the bed then it should be. One can issue a `SET_GCODE_OFFSET Z=+.010` command to increase the height. In subsequent prints one can inspect for this behavior and make further adjustment as needed. Adjustments of this type are typically in 10s of microns (.010mm).

If the bottom layer consistently appears narrower than subsequent layers then one can use the SET_GCODE_OFFSET command to make a negative Z adjustment. If one is unsure, then one can decrease the Z adjustment until the bottom layer of prints exhibit a small bulge, and then back-off until it disappears.

The easiest way to apply the desired Z adjustment is to create a START_PRINT g-code macro, arrange for the slicer to call that macro during the start of each print, and add a SET_GCODE_OFFSET command to that macro. See the [slicers](Slicers.md) document for further details.
