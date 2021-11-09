# TSL1401CL 필라멘트 너비 센서

이 문서에서는 필라멘트 폭 센서 호스트 모듈에 대해 설명합니다. 이 호스트 모듈을 개발하는 데 사용되는 하드웨어는 TSL1401CL 선형 센서 어레이를 기반으로 하지만 아날로그 출력이 있는 모든 센서 어레이와 함께 작동할 수 있습니다. 디자인은 [thingiverse.com](https://www.thingiverse.com/search?q=filament%20width%20sensor)에서 확인하실 수 있습니다

## 어떻게 동작하나요?

센서는 계산된 필라멘트 폭을 기반으로 아날로그 출력을 생성합니다. 출력 전압은 항상 감지된 필라멘트 너비와 동일합니다(예: 1.65v, 1.70v, 3.0v). 호스트 모듈은 전압 변화를 모니터링하고 압출 배율을 조정합니다.

## 설정

    [tsl1401cl_filament_width_sensor]
    pin: analog5
    # Analog input pin for sensor output on Ramps board
    
    default_nominal_filament_diameter: 1.75
    # This parameter is in millimeters (mm)
    
    max_difference: 0.2
    #  Maximum allowed filament diameter difference in millimeters (mm)
    #  If difference between nominal filament diameter and sensor output is more
    #  than +- max_difference, extrusion multiplier set back to %100
    
    measurement_delay 100
    #  The distance from sensor to the melting chamber/hot-end in millimeters (mm).
    #  The filament between the sensor and the hot-end will be treated as the default_nominal_filament_diameter.
    #  Host module works with FIFO logic. It keeps each sensor value and position in
    #  an array and POP them back in correct position.

센서 판독은 기본적으로 10mm 간격으로 수행됩니다. 필요한 경우 **filament_width_sensor.py** 파일의 ***MEASUREMENT_INTERVAL_MM*** 매개변수를 편집하여 이 설정을 자유롭게 변경할 수 있습니다.

## 명령어

**QUERY_FILAMENT_WIDTH** - 현재 측정된 필라멘트 너비를 결과로 반환 **
RESET_FILAMENT_WIDTH_SENSOR** – 모든 센서 판독값을 지웁니다. 필라멘트 교체 후 사용 가능합니다. **
DISABLE_FILAMENT_WIDTH_SENSOR** – 필라멘트 폭 센서를 끄고 흐름 제어를 위해 사용을 중지하십시오. **
ENABLE_FILAMENT_WIDTH_SENSOR** - 필라멘트 폭 센서를 켜고 흐름 제어를 수행하는 데 사용하기 시작합니다
