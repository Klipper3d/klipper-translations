# 홀 필라멘트 너비 센서

This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on Two Hall liniar sensors (ss49e for example). Sensors in the body are located opposite sides. Principle of operation : two hall sensors work in differential mode, temperature drift same for sensor. Special temperature compensation not needed. You can find designs at [Thingiverse](https://www.thingiverse.com/thing:4138933)

[홀 기반 필라멘트 폭 센서 조립 영상](https://www.youtube.com/watch?v=TDO9tME8vp4)

## 어떻게 동작하나요?

센서는 계산된 필라멘트 폭을 기반으로 두 개의 아날로그 출력을 생성합니다. 출력 전압의 합은 항상 감지된 필라멘트 너비와 동일합니다. 호스트 모듈은 전압 변화를 모니터링하고 압출 배율을 조정합니다. 설계자는 ramps 와 유사한 보드의 analog11 및 analog12 핀에 aux2 커넥터를 사용했지만 다른 핀과 다른 보드를 사용할 수 있습니다.

## 설정

```
[hall_filament_width_sensor]

adc1: analog11
adc2: analog12
# adc1 and adc2 channels select own pins Analog input pins on 3d printer board
# Sensor power supply can be 3.3v or 5v

Cal_dia1: 1.50 # Reference diameter point 1 (mm)
Cal_dia2: 2.00 # Reference diameter point 2 (mm)

# The measurement principle provides for two-point calibration
# In calibration process you must use rods of known diameter
# I use drill rods as the base diameter.
# nominal filament diameter must be between Cal_dia1 and Cal_dia2
# Your size may differ from the indicated ones, for example 2.05

Raw_dia1:10630 # Raw sensor value for reference point 1
Raw_dia2:8300  # Raw sensor value for reference point 2

# Raw value of sensor in units
# can be readed by command QUERY_RAW_FILAMENT_WIDTH

default_nominal_filament_diameter: 1.75 # This parameter is in millimeters (mm)

max_difference: 0.15
# Maximum allowed filament diameter difference in millimeters (mm)
# If difference between nominal filament diameter and sensor output is more
# than +- max_difference, extrusion multiplier set back to %100

measurement_delay: 70
# The distance from sensor to the melting chamber/hot-end in millimeters (mm).
# The filament between the sensor and the hot-end will be treated as the default_nominal_filament_diameter.
# Host module works with FIFO logic. It keeps each sensor value and position in
# an array and POP them back in correct position.

#enable:False
# Sensor enabled or disabled after power on. Disabled by default

# measurement_interval:10
# Sensor readings done with 10 mm intervals by default. If necessary you are free to change this setting

#logging: False
#  Out diameter to terminal and klipper.log
#  can be turn on|of by command

#Virtual filament_switch_sensor suppurt. Create sensor named hall_filament_width_sensor.
#
#min_diameter:1.0
#Minimal diameter for trigger virtual filament_switch_sensor.
#use_current_dia_while_delay: False
#   Use the current diameter instead of the nominal diamenter while the measurement delay has not run through.
#
#Values from filament_switch_sensor. See the "filament_switch_sensor" section for information on these parameters.
#
#pause_on_runout: True
#runout_gcode:
#insert_gcode:
#event_delay: 3.0
#pause_delay: 0.5
```

## G-Code Commands

**QUERY_FILAMENT_WIDTH** - 현재 측정된 필라멘트 너비를 결과로 반환

**RESET_FILAMENT_WIDTH_SENSOR** - Clear all sensor readings. Can be used after filament change.

**DISABLE_FILAMENT_WIDTH_SENSOR** - Turn off the filament width sensor and stop using it to do flow control

**ENABLE_FILAMENT_WIDTH_SENSOR** - 필라멘트 폭 센서를 켜고 흐름 제어를 수행하는 데 사용하기 시작합니다

*QUERY_RAW_FILAMENT_WIDTH** - 교정 포인트에 대한 현재 ADC 채널 값 및 RAW 센서 값 반환

**ENABLE_FILAMENT_WIDTH_LOG** - 직경 로깅 켜기

**DISABLE_FILAMENT_WIDTH_LOG** - 직경 로깅 끄기

## 메뉴 값

**hall_filament_width_sensor.Diameter** 현재 측정된 필라멘트 너비(mm)

**hall_filament_width_sensor.Raw** 현재 측정된 필라멘트 폭(단위)

**hall_filament_width_sensor.is_active** 센서 켜기 또는 끄기

## 메뉴 값 템플릿

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## 교정 절차

raw 센서 값을 얻으려면 터미널에서 메뉴 항목 또는 **QUERY_RAW_FILAMENT_WIDTH** 명령을 사용할 수 있습니다

1. 첫 번째 보정 막대(1.5mm 크기) 삽입해서 raw 센서 값 가져오기
1. 두 번째 보정 막대(2.0mm 크기) 삽입 후 raw 센서 값 가져오기
1. Save raw sensor values in config parameter `Raw_dia1` and `Raw_dia2`

## 센서 활성 방법

By default, the sensor is disabled at power-on.

To enable the sensor, issue **ENABLE_FILAMENT_WIDTH_SENSOR** command or set the `enable` parameter to `true.`

## 로깅 (logging)

By default, diameter logging is disabled at power-on.

Issue **ENABLE_FILAMENT_WIDTH_LOG** command to start logging and issue **DISABLE_FILAMENT_WIDTH_LOG** command to stop logging. To enable logging at power-on, set the `logging` parameter to `true`.

Filament diameter is logged on every measurement interval (10 mm by default).
