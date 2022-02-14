# TSL1401CL 필라멘트 너비 센서

This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on TSL1401CL linear sensor array but it can work with any sensor array that has analog output. You can find designs at [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

To use a sensor array as a filament width sensor, read [Config Reference](Config_Reference.md#tsl1401cl_filament_width_sensor) and [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## 어떻게 동작하나요?

센서는 계산된 필라멘트 폭을 기반으로 아날로그 출력을 생성합니다. 출력 전압은 항상 감지된 필라멘트 너비와 동일합니다(예: 1.65v, 1.70v, 3.0v). 호스트 모듈은 전압 변화를 모니터링하고 압출 배율을 조정합니다.

## Note:

센서 판독은 기본적으로 10mm 간격으로 수행됩니다. 필요한 경우 **filament_width_sensor.py** 파일의 ***MEASUREMENT_INTERVAL_MM*** 매개변수를 편집하여 이 설정을 자유롭게 변경할 수 있습니다.
