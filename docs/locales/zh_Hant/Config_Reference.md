# 配置參考

本文件是 Klipper 配置檔案中可用配置分段的參考。

本文件中的描述已經格式化，以便可以將它們剪下並貼上到印表機配置檔案中。 見 [installation document](Installation.md) 有關設定 Klipper 和選擇初始配置檔案的資訊。

## 微控制器配置

### 微控制器引腳名字的格式

許多配置選項需要微控制器引腳的名稱。Klipper 使用了這些引腳的硬體名稱 - 例如`PA4`。

在 引腳名稱前加 `!`來表示相反的電極極性（ 例如觸發條件時低電平而不是高電平）。

在引腳名稱前面加 `^` ，以指示該引腳啟用硬體上拉電阻。如果微控制器支援下拉電阻器，那麼輸入引腳也可以在前面加上`~`。

注意，某些配置部分可能會「建立」額外的引腳。 如果發生這種情況，定義引腳的配置部分必須在使用這些引腳的任何部分之前列在配置檔案中。

### [MCU]

主微控制器的配置。

```
[mcu]
serial:
# 連接MCU的串口。如果不確定（或者如果它
# 更改）查看“我的串口在哪裡？”常見問題解答部分。
# 使用串口時必須提供此參數。
#baud: 250000
# 要使用的波特率。默認值為 250000。
#canbus_uuid:
# 如果使用連接到 CAN 總線的設備，則設置唯一
# 要連接的芯片標識符。使用時必須提供此值
# CAN 總線進行通訊。
#canbus_interface：
# 如果使用連接到 CAN 總線的設備，那麼這將設置 CAN
# 要使用的網絡接口。默認值為“can0”。
#restart_method：
# 這控制主機將用於重置的機制
#微控制器。選擇是'arduino'，'cheetah'，'rpi_usb'，
# 和“命令”。 'arduino' 方法（切換 DTR）在
# Arduino 板和克隆。 “獵豹”方法是一種特殊的方法
# 一些 Fysetc Cheetah 板需要的方法。 'rpi_usb' 方法
# 在帶有微控制器供電的 Raspberry Pi 板上很有用
# over USB - 它會暫時禁用所有 USB 端口的電源以
# 完成微控制器復位。 “命令”方法涉及
# 向微控制器發送一個 Klipper 命令，以便它可以
# 重置自己。如果微控制器默認為“arduino”
# 通過串行端口進行通信，否則為“命令”。
```

### 額外的mcu [mcu my_extra_mcu]

額外的微控制器（可以定義任意數量的帶有「mcu」字首的部分）。 額外的微控制器引入了額外的引腳，這些引腳可以配置為加熱器、步進器、風扇等。例如，如果引入了「[mcu extra_mcu]」部分，那麼諸如「extra_mcu:ar9」之類的引腳就可以在其他地方使用 ，在配置中（其中「ar9」是給定 mcu 上的硬體引腳名稱或別名）。

```
[mcu my_extra_mcu]
#   請參閱"mcu"分段的配置參數。
```

## 常用的機型設定

### [printer]

印表機控制的高級設定部分。

```
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid_corexy, hybrid_corexz, rotary_delta, delta,
#   polar, winch, or none. This
#   parameter must be specified.
max_velocity:
#   Maximum velocity (in mm/s) of the toolhead (relative to the
#   print). This parameter must be specified.
max_accel:
#   Maximum acceleration (in mm/s^2) of the toolhead (relative to the
#   print). This parameter must be specified.
#max_accel_to_decel:
#   A pseudo acceleration (in mm/s^2) controlling how fast the
#   toolhead may go from acceleration to deceleration. It is used to
#   reduce the top speed of short zig-zag moves (and thus reduce
#   printer vibration from these moves). The default is half of
#   max_accel.
#square_corner_velocity: 5.0
#   The maximum velocity (in mm/s) that the toolhead may travel a 90
#   degree corner at. A non-zero value can reduce changes in extruder
#   flow rates by enabling instantaneous velocity changes of the
#   toolhead during cornering. This value configures the internal
#   centripetal velocity cornering algorithm; corners with angles
#   larger than 90 degrees will have a higher cornering velocity while
#   corners with angles less than 90 degrees will have a lower
#   cornering velocity. If this is set to zero then the toolhead will
#   decelerate to zero at each corner. The default is 5mm/s.
```

### [stepper]

步進電機定義。 不同的印表機型別（由 [列印] 配置部分中的「機型」選項指定）步進器需要定義不同的名稱（例如，`stepper_x` 與 `stepper_a`）。 以下是常見的步進器定義。

有關計算 `rotation_distance` 參數的信息，請參閱 [rotation distance document](Rotation_Distance.md)。有關使用多個微控制器進行歸位的信息，請參見 [Multi-MCU homing](Multi_MCU_Homing.md) 文檔。

```
[stepper_x]
step_pin:
#   Step GPIO pin (triggered high). This parameter must be provided.
dir_pin:
#   Direction GPIO pin (high indicates positive direction). This
#   parameter must be provided.
enable_pin:
#   Enable pin (default is enable high; use ! to indicate enable
#   low). If this parameter is not provided then the stepper motor
#   driver must always be enabled.
rotation_distance:
#   Distance (in mm) that the axis travels with one full rotation of
#   the stepper motor (or final gear if gear_ratio is specified).
#   This parameter must be provided.
microsteps:
#   The number of microsteps the stepper motor driver uses. This
#   parameter must be provided.
#full_steps_per_rotation: 200
#   The number of full steps for one rotation of the stepper motor.
#   Set this to 200 for a 1.8 degree stepper motor or set to 400 for a
#   0.9 degree motor. The default is 200.
#gear_ratio:
#   The gear ratio if the stepper motor is connected to the axis via a
#   gearbox. For example, one may specify "5:1" if a 5 to 1 gearbox is
#   in use. If the axis has multiple gearboxes one may specify a comma
#   separated list of gear ratios (for example, "57:11, 2:1"). If a
#   gear_ratio is specified then rotation_distance specifies the
#   distance the axis travels for one full rotation of the final gear.
#   The default is to not use a gear ratio.
#step_pulse_duration:
#   The minimum time between the step pulse signal edge and the
#   following "unstep" signal edge. This is also used to set the
#   minimum time between a step pulse and a direction change signal.
#   The default is 0.000000100 (100ns) for TMC steppers that are
#   configured in UART or SPI mode, and the default is 0.000002 (which
#   is 2us) for all other steppers.
endstop_pin:
#   Endstop switch detection pin. If this endstop pin is on a
#   different mcu than the stepper motor then it enables "multi-mcu
#   homing". This parameter must be provided for the X, Y, and Z
#   steppers on cartesian style printers.
#position_min: 0
#   Minimum valid distance (in mm) the user may command the stepper to
#   move to.  The default is 0mm.
position_endstop:
#   Location of the endstop (in mm). This parameter must be provided
#   for the X, Y, and Z steppers on cartesian style printers.
position_max:
#   Maximum valid distance (in mm) the user may command the stepper to
#   move to. This parameter must be provided for the X, Y, and Z
#   steppers on cartesian style printers.
#homing_speed: 5.0
#   Maximum velocity (in mm/s) of the stepper when homing. The default
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
#   Velocity (in mm/s) of the stepper when performing the second home.
#   The default is homing_speed/2.
#homing_positive_dir:
#   If true, homing will cause the stepper to move in a positive
#   direction (away from zero); if false, home towards zero. It is
#   better to use the default than to specify this parameter. The
#   default is true if position_endstop is near position_max and false
#   if near position_min.
```

### 笛卡爾機型

有關示例XYZ機型配置檔案，請參閱 [example-cartesian.cfg](../config/example-cartesian.cfg)。

此處描述的參數只適用於笛卡爾印表機，有關可用參數，請參閱 [常用運動設定](#common-kinematic-settings)。

```
[printer]
kinematics: cartesian
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. This setting can be used to restrict the maximum speed of
#   the z stepper motor. The default is to use max_velocity for
#   max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. It limits the acceleration of the z stepper motor. The
#   default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the stepper controlling
# the X axis in a cartesian robot.
[stepper_x]

# The stepper_y section is used to describe the stepper controlling
# the Y axis in a cartesian robot.
[stepper_y]

# The stepper_z section is used to describe the stepper controlling
# the Z axis in a cartesian robot.
[stepper_z]
```

### 線性三角洲機型

有關示例線性三角洲機型配置檔案，請參閱 [example-delta.cfg](../config/example-delta.cfg)。 有關校準的資訊，請參閱 [delta calibrate guide](Delta_Calibrate.md)。

此處僅描述了線性三角洲印表機的特定參數 - 有關可用參數，請參閱 [常用運動設定](#common-kinematic-settings)。

```
[printer]
kinematics: delta
max_z_velocity:
#   For delta printers this limits the maximum velocity (in mm/s) of
#   moves with z axis movement. This setting can be used to reduce the
#   maximum speed of up/down moves (which require a higher step rate
#   than other moves on a delta printer). The default is to use
#   max_velocity for max_z_velocity.
#max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. Setting this may be useful if the printer can reach higher
#   acceleration on XY moves than Z moves (eg, when using input shaper).
#   The default is to use max_accel for max_z_accel.
#minimum_z_position: 0
#   The minimum Z position that the user may command the head to move
#   to. The default is 0.
delta_radius:
#   Radius (in mm) of the horizontal circle formed by the three linear
#   axis towers. This parameter may also be calculated as:
#    delta_radius = smooth_rod_offset - effector_offset - carriage_offset
#   This parameter must be provided.
#print_radius:
#   The radius (in mm) of valid toolhead XY coordinates. One may use
#   this setting to customize the range checking of toolhead moves. If
#   a large value is specified here then it may be possible to command
#   the toolhead into a collision with a tower. The default is to use
#   delta_radius for print_radius (which would normally prevent a
#   tower collision).

# The stepper_a section describes the stepper controlling the front
# left tower (at 210 degrees). This section also controls the homing
# parameters (homing_speed, homing_retract_dist) for all towers.
[stepper_a]
position_endstop:
#   Distance (in mm) between the nozzle and the bed when the nozzle is
#   in the center of the build area and the endstop triggers. This
#   parameter must be provided for stepper_a; for stepper_b and
#   stepper_c this parameter defaults to the value specified for
#   stepper_a.
arm_length:
#   Length (in mm) of the diagonal rod that connects this tower to the
#   print head. This parameter must be provided for stepper_a; for
#   stepper_b and stepper_c this parameter defaults to the value
#   specified for stepper_a.
#angle:
#   This option specifies the angle (in degrees) that the tower is
#   at. The default is 210 for stepper_a, 330 for stepper_b, and 90
#   for stepper_c.

# The stepper_b section describes the stepper controlling the front
# right tower (at 330 degrees).
[stepper_b]

# The stepper_c section describes the stepper controlling the rear
# tower (at 90 degrees).
[stepper_c]

# The delta_calibrate section enables a DELTA_CALIBRATE extended
# g-code command that can calibrate the tower endstop positions and
# angles.
[delta_calibrate]
radius:
#   Radius (in mm) of the area that may be probed. This is the radius
#   of nozzle coordinates to be probed; if using an automatic probe
#   with an XY offset then choose a radius small enough so that the
#   probe always fits over the bed. This parameter must be provided.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### CoreXY 機型

有關 corexy（及 H-BOT）機型文件的示例，請參見 [example-corexy.cfg](../config/example-corexy.cfg)。

這裡只描述了 CoreXY 印表機特有的參數 -- 有關可用參數，請參閱 [常見機型設定](#common-kinematic-settings)。

```
[printer]
kinematics: corexy
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. This setting can be used to restrict the maximum speed of
#   the z stepper motor. The default is to use max_velocity for
#   max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. It limits the acceleration of the z stepper motor. The
#   default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the X axis as well as the
# stepper controlling the X+Y movement.
[stepper_x]

# The stepper_y section is used to describe the Y axis as well as the
# stepper controlling the X-Y movement.
[stepper_y]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
[stepper_z]
```

### CoreX 機型

有關 corexz 機型配置文件的示例，請參見 [example-corexz.cfg](../config/example-corexz.cfg)。

此處描述的參數只適用於笛卡爾印表機—有關全部可用參數，請參閱 [常用的機型設定](#common-kinematic-settings)。

```
[printer]
kinematics: corexz
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. The default is to use max_velocity for max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. The default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the X axis as well as the
# stepper controlling the X+Z movement.
[stepper_x]

# The stepper_y section is used to describe the stepper controlling
# the Y axis.
[stepper_y]

# The stepper_z section is used to describe the Z axis as well as the
# stepper controlling the X-Z movement.
[stepper_z]
```

### 混合型 CoreXY 機型

有關示例混合 corexy 機型配置文件，請參見 [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg)。

這種機型也稱為 Markforged 機型。

此處僅描述了線性三角洲印表機的特定參數—有關全部可用參數，請參閱 [常用的機型設定](#common-kinematic-settings)。

```
[printer]
kinematics: hybrid_corexy
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. The default is to use max_velocity for max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. The default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the X axis as well as the
# stepper controlling the X-Y movement.
[stepper_x]

# The stepper_y section is used to describe the stepper controlling
# the Y axis.
[stepper_y]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
[stepper_z]
```

### 混合型 CoreXZ 機型

有關示例混合 corexz 機型配置文件，請參見 [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg)。

這種機型也稱為 Markforged 機型。

此處僅描述了線性三角洲印表機的特定參數—有關全部可用參數，請參閱 [常用的機型設定](#common-kinematic-settings)。

```
[printer]
kinematics: hybrid_corexz
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. The default is to use max_velocity for max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. The default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the X axis as well as the
# stepper controlling the X-Z movement.
[stepper_x]

# The stepper_y section is used to describe the stepper controlling
# the Y axis.
[stepper_y]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
[stepper_z]
```

### Polar機型

有關Polar機型配置文件的示例，請參見 [example-polar.cfg](../config/example-polar.cfg)。

這裡只描述了極地印表機特有的參數—全部可用的參數請見[常用的機型設定](#common-kinematic-settings)。

POLAR 機型支援還在進行中。已知在 0、0 位置附近移動無法正常工作。

```
[printer]
kinematics: polar
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. This setting can be used to restrict the maximum speed of
#   the z stepper motor. The default is to use max_velocity for
#   max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. It limits the acceleration of the z stepper motor. The
#   default is to use max_accel for max_z_accel.

# The stepper_bed section is used to describe the stepper controlling
# the bed.
[stepper_bed]
gear_ratio:
#   A gear_ratio must be specified and rotation_distance may not be
#   specified. For example, if the bed has an 80 toothed pulley driven
#   by a stepper with a 16 toothed pulley then one would specify a
#   gear ratio of "80:16". This parameter must be provided.

# The stepper_arm section is used to describe the stepper controlling
# the carriage on the arm.
[stepper_arm]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
[stepper_z]
```

### 旋轉三角洲機型

有關旋轉三角洲機型配置文件的示例，請參見 [example-rotary-delta.cfg](../config/example-rotary-delta.cfg)。

此處僅介紹特定於旋轉三角洲印表機的參數—有關可用參數，請參閱[常用的機型設定](#common-kinematic-settings)。

旋轉三角洲機型的設定還在進行中。歸位移動可能會超時，並且某些邊界檢查未實施。

```
[printer]
kinematics: rotary_delta
max_z_velocity:
#   For delta printers this limits the maximum velocity (in mm/s) of
#   moves with z axis movement. This setting can be used to reduce the
#   maximum speed of up/down moves (which require a higher step rate
#   than other moves on a delta printer). The default is to use
#   max_velocity for max_z_velocity.
#minimum_z_position: 0
#   The minimum Z position that the user may command the head to move
#   to.  The default is 0.
shoulder_radius:
#   Radius (in mm) of the horizontal circle formed by the three
#   shoulder joints, minus the radius of the circle formed by the
#   effector joints. This parameter may also be calculated as:
#     shoulder_radius = (delta_f - delta_e) / sqrt(12)
#   This parameter must be provided.
shoulder_height:
#   Distance (in mm) of the shoulder joints from the bed, minus the
#   effector toolhead height. This parameter must be provided.

# The stepper_a section describes the stepper controlling the rear
# right arm (at 30 degrees). This section also controls the homing
# parameters (homing_speed, homing_retract_dist) for all arms.
[stepper_a]
gear_ratio:
#   A gear_ratio must be specified and rotation_distance may not be
#   specified. For example, if the arm has an 80 toothed pulley driven
#   by a pulley with 16 teeth, which is in turn connected to a 60
#   toothed pulley driven by a stepper with a 16 toothed pulley, then
#   one would specify a gear ratio of "80:16, 60:16". This parameter
#   must be provided.
position_endstop:
#   Distance (in mm) between the nozzle and the bed when the nozzle is
#   in the center of the build area and the endstop triggers. This
#   parameter must be provided for stepper_a; for stepper_b and
#   stepper_c this parameter defaults to the value specified for
#   stepper_a.
upper_arm_length:
#   Length (in mm) of the arm connecting the "shoulder joint" to the
#   "elbow joint". This parameter must be provided for stepper_a; for
#   stepper_b and stepper_c this parameter defaults to the value
#   specified for stepper_a.
lower_arm_length:
#   Length (in mm) of the arm connecting the "elbow joint" to the
#   "effector joint". This parameter must be provided for stepper_a;
#   for stepper_b and stepper_c this parameter defaults to the value
#   specified for stepper_a.
#angle:
#   This option specifies the angle (in degrees) that the arm is at.
#   The default is 30 for stepper_a, 150 for stepper_b, and 270 for
#   stepper_c.

# The stepper_b section describes the stepper controlling the rear
# left arm (at 150 degrees).
[stepper_b]

# The stepper_c section describes the stepper controlling the front
# arm (at 270 degrees).
[stepper_c]

# The delta_calibrate section enables a DELTA_CALIBRATE extended
# g-code command that can calibrate the shoulder endstop positions.
[delta_calibrate]
radius:
#   Radius (in mm) of the area that may be probed. This is the radius
#   of nozzle coordinates to be probed; if using an automatic probe
#   with an XY offset then choose a radius small enough so that the
#   probe always fits over the bed. This parameter must be provided.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### 纜繩絞盤機型

請參閱 [example-winch.cfg](../config/example-winch.cfg) 以獲取示例電纜絞盤運動學配置文件。

這裡只描述了纜繩鉸盤式印表機特有的參數 — 全部可用的參數見[常用的機型設定](#common-kinematic-settings)。

CABLE WINCH支援是實驗性的。未在電纜絞盤運動學上實現歸位。為了使打印機歸位，手動發送移動命令，直到工具頭位於 0、0、0 處，然後發出“G28”命令。

```
[printer]
kinematics: winch

# The stepper_a section describes the stepper connected to the first
# cable winch. A minimum of 3 and a maximum of 26 cable winches may be
# defined (stepper_a to stepper_z) though it is common to define 4.
[stepper_a]
rotation_distance:
#   The rotation_distance is the nominal distance (in mm) the toolhead
#   moves towards the cable winch for each full rotation of the
#   stepper motor. This parameter must be provided.
anchor_x:
anchor_y:
anchor_z:
#   The X, Y, and Z position of the cable winch in cartesian space.
#   These parameters must be provided.
```

### 無機型

可以定義特殊的 "none" 機型來禁用 Klipper 中的機型支援。可以用於控制不是 3D 印表機的裝置或除錯。

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   The max_velocity and max_accel parameters must be defined. The
#   values are not used for "none" kinematics.
```

## 通用擠出機和熱床支援

### [extruder]

The extruder section is used to describe the heater parameters for the nozzle hotend along with the stepper controlling the extruder. See the [command reference](G-Codes.md#extruder) for additional information. See the [pressure advance guide](Pressure_Advance.md) for information on tuning pressure advance.

```
[extruder]
step_pin:
dir_pin:
enable_pin:
microsteps:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#   See the "stepper" section for a description of the above
#   parameters. If none of the above parameters are specified then no
#   stepper will be associated with the nozzle hotend (though a
#   SYNC_EXTRUDER_MOTION command may associate one at run-time).
nozzle_diameter:
#   Diameter of the nozzle orifice (in mm). This parameter must be
#   provided.
filament_diameter:
#   The nominal diameter of the raw filament (in mm) as it enters the
#   extruder. This parameter must be provided.
#max_extrude_cross_section:
#   Maximum area (in mm^2) of an extrusion cross section (eg,
#   extrusion width multiplied by layer height). This setting prevents
#   excessive amounts of extrusion during relatively small XY moves.
#   If a move requests an extrusion rate that would exceed this value
#   it will cause an error to be returned. The default is: 4.0 *
#   nozzle_diameter^2
#instantaneous_corner_velocity: 1.000
#   The maximum instantaneous velocity change (in mm/s) of the
#   extruder during the junction of two moves. The default is 1mm/s.
#max_extrude_only_distance: 50.0
#   Maximum length (in mm of raw filament) that a retraction or
#   extrude-only move may have. If a retraction or extrude-only move
#   requests a distance greater than this value it will cause an error
#   to be returned. The default is 50mm.
#max_extrude_only_velocity:
#max_extrude_only_accel:
#   Maximum velocity (in mm/s) and acceleration (in mm/s^2) of the
#   extruder motor for retractions and extrude-only moves. These
#   settings do not have any impact on normal printing moves. If not
#   specified then they are calculated to match the limit an XY
#   printing move with a cross section of 4.0*nozzle_diameter^2 would
#   have.
#pressure_advance: 0.0
#   The amount of raw filament to push into the extruder during
#   extruder acceleration. An equal amount of filament is retracted
#   during deceleration. It is measured in millimeters per
#   millimeter/second. The default is 0, which disables pressure
#   advance.
#pressure_advance_smooth_time: 0.040
#   A time range (in seconds) to use when calculating the average
#   extruder velocity for pressure advance. A larger value results in
#   smoother extruder movements. This parameter may not exceed 200ms.
#   This setting only applies if pressure_advance is non-zero. The
#   default is 0.040 (40 milliseconds).
#
# The remaining variables describe the extruder heater.
heater_pin:
#   PWM output pin controlling the heater. This parameter must be
#   provided.
#max_power: 1.0
#   The maximum power (expressed as a value from 0.0 to 1.0) that the
#   heater_pin may be set to. The value 1.0 allows the pin to be set
#   fully enabled for extended periods, while a value of 0.5 would
#   allow the pin to be enabled for no more than half the time. This
#   setting may be used to limit the total power output (over extended
#   periods) to the heater. The default is 1.0.
sensor_type:
#   Type of sensor - common thermistors are "EPCOS 100K B57560G104F",
#   "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Generic
#   3950","Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", and "TDK NTCG104LH104JT1". See the
#   "Temperature sensors" section for other sensors. This parameter
#   must be provided.
sensor_pin:
#   Analog input pin connected to the sensor. This parameter must be
#   provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the thermistor.
#   This parameter is only valid when the sensor is a thermistor. The
#   default is 4700 ohms.
#smooth_time: 1.0
#   A time value (in seconds) over which temperature measurements will
#   be smoothed to reduce the impact of measurement noise. The default
#   is 1 seconds.
control:
#   Control algorithm (either pid or watermark). This parameter must
#   be provided.
pid_Kp:
pid_Ki:
pid_Kd:
#   The proportional (pid_Kp), integral (pid_Ki), and derivative
#   (pid_Kd) settings for the PID feedback control system. Klipper
#   evaluates the PID settings with the following general formula:
#     heater_pwm = (Kp*error + Ki*integral(error) - Kd*derivative(error)) / 255
#   Where "error" is "requested_temperature - measured_temperature"
#   and "heater_pwm" is the requested heating rate with 0.0 being full
#   off and 1.0 being full on. Consider using the PID_CALIBRATE
#   command to obtain these parameters. The pid_Kp, pid_Ki, and pid_Kd
#   parameters must be provided for PID heaters.
#max_delta: 2.0
#   On 'watermark' controlled heaters this is the number of degrees in
#   Celsius above the target temperature before disabling the heater
#   as well as the number of degrees below the target before
#   re-enabling the heater. The default is 2 degrees Celsius.
#pwm_cycle_time: 0.100
#   Time in seconds for each software PWM cycle of the heater. It is
#   not recommended to set this unless there is an electrical
#   requirement to switch the heater faster than 10 times a second.
#   The default is 0.100 seconds.
#min_extrude_temp: 170
#   The minimum temperature (in Celsius) at which extruder move
#   commands may be issued. The default is 170 Celsius.
min_temp:
max_temp:
#   The maximum range of valid temperatures (in Celsius) that the
#   heater must remain within. This controls a safety feature
#   implemented in the micro-controller code - should the measured
#   temperature ever fall outside this range then the micro-controller
#   will go into a shutdown state. This check can help detect some
#   heater and sensor hardware failures. Set this range just wide
#   enough so that reasonable temperatures do not result in an error.
#   These parameters must be provided.
```

### [heater_bed]

heat_bed 部分描述了一個加熱床。它使用與“擠出機”部分中描述的相同的加熱器設置。

```
[heater_bed]
heater_pin:
sensor_type:
sensor_pin:
control:
min_temp:
max_temp:
#   以上參數詳見「extruder」配置分段。
```

## 列印床調平支援

### [bed_mesh]

網床調平。定義一個 bed_mesh 配置分段來啟用基於探測點產生網格的 Z 軸偏移移動變換。當使用探針歸位 Z 軸時，建議通過 printer.cfg 中定義一個 safe_z_home 分段使 Z 軸歸位在列印區域的中心執行。

有關更多信息，請參閱 [床網格指南](Bed_Mesh.md) 和 [命令參考](G-Codes.md#bed_mesh)。

視覺化示例：

```
 rectangular bed, probe_count = 3, 3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 round bed, round_probe_count = 5, bed_radius = r:
                 x (0, r) end
               /
             x---x---x
                       \
 (-r, 0) x---x---x---x---x (r, 0)
           \
             x---x---x
                   /
                 x  (0, -r) start
```

```
[bed_mesh]
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#mesh_radius:
#   Defines the radius of the mesh to probe for round beds. Note that
#   the radius is relative to the coordinate specified by the
#   mesh_origin option. This parameter must be provided for round beds
#   and omitted for rectangular beds.
#mesh_origin:
#   Defines the center X, Y coordinate of the mesh for round beds. This
#   coordinate is relative to the probe's location. It may be useful
#   to adjust the mesh_origin in an effort to maximize the size of the
#   mesh radius. Default is 0, 0. This parameter must be omitted for
#   rectangular beds.
#mesh_min:
#   Defines the minimum X, Y coordinate of the mesh for rectangular
#   beds. This coordinate is relative to the probe's location. This
#   will be the first point probed, nearest to the origin. This
#   parameter must be provided for rectangular beds.
#mesh_max:
#   Defines the maximum X, Y coordinate of the mesh for rectangular
#   beds. Adheres to the same principle as mesh_min, however this will
#   be the furthest point probed from the bed's origin. This parameter
#   must be provided for rectangular beds.
#probe_count: 3, 3
#   For rectangular beds, this is a comma separate pair of integer
#   values X, Y defining the number of points to probe along each
#   axis. A single value is also valid, in which case that value will
#   be applied to both axes. Default is 3, 3.
#round_probe_count: 5
#   For round beds, this integer value defines the maximum number of
#   points to probe along each axis. This value must be an odd number.
#   Default is 5.
#fade_start: 1.0
#   The gcode z position in which to start phasing out z-adjustment
#   when fade is enabled. Default is 1.0.
#fade_end: 0.0
#   The gcode z position in which phasing out completes. When set to a
#   value below fade_start, fade is disabled. It should be noted that
#   fade may add unwanted scaling along the z-axis of a print. If a
#   user wishes to enable fade, a value of 10.0 is recommended.
#   Default is 0.0, which disables fade.
#fade_target:
#   The z position in which fade should converge. When this value is
#   set to a non-zero value it must be within the range of z-values in
#   the mesh. Users that wish to converge to the z homing position
#   should set this to 0. Default is the average z value of the mesh.
#split_delta_z: .025
#   The amount of Z difference (in mm) along a move that will trigger
#   a split. Default is .025.
#move_check_distance: 5.0
#   The distance (in mm) along a move to check for split_delta_z.
#   This is also the minimum length that a move can be split. Default
#   is 5.0.
#mesh_pps: 2, 2
#   A comma separated pair of integers X, Y defining the number of
#   points per segment to interpolate in the mesh along each axis. A
#   "segment" can be defined as the space between each probed point.
#   The user may enter a single value which will be applied to both
#   axes. Default is 2, 2.
#algorithm: lagrange
#   The interpolation algorithm to use. May be either "lagrange" or
#   "bicubic". This option will not affect 3x3 grids, which are forced
#   to use lagrange sampling. Default is lagrange.
#bicubic_tension: .2
#   When using the bicubic algorithm the tension parameter above may
#   be applied to change the amount of slope interpolated. Larger
#   numbers will increase the amount of slope, which results in more
#   curvature in the mesh. Default is .2.
#relative_reference_index:
#   A point index in the mesh to reference all z values to. Enabling
#   this parameter produces a mesh relative to the probed z position
#   at the provided index.
#faulty_region_1_min:
#faulty_region_1_max:
#   Optional points that define a faulty region.  See docs/Bed_Mesh.md
#   for details on faulty regions.  Up to 99 faulty regions may be added.
#   By default no faulty regions are set.
```

### [bed_tilt]

列印床傾斜補償。可以定義一個 bed_tilt 配置分段來啟用移動變換傾斜列印床補償。請注意，bed_mesh 和 bed_tilt 不相容：兩者無法同時被定義。

有關更多信息，請參閱 [命令參考](G-Codes.md#bed_tilt)。

```
[bed_tilt]
#x_adjust: 0
#   The amount to add to each move's Z height for each mm on the X
#   axis. The default is 0.
#y_adjust: 0
#   The amount to add to each move's Z height for each mm on the Y
#   axis. The default is 0.
#z_adjust: 0
#   The amount to add to the Z height when the nozzle is nominally at
#   0, 0. The default is 0.
# The remaining parameters control a BED_TILT_CALIBRATE extended
# g-code command that may be used to calibrate appropriate x and y
# adjustment parameters.
#points:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) that should be probed during a BED_TILT_CALIBRATE
#   command. Specify coordinates of the nozzle and be sure the probe
#   is above the bed at the given nozzle coordinates. The default is
#   to not enable the command.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### [bed_screws]

幫助調整床調平螺絲的工具。可以定義 [bed_screws] 配置部分以啟用 BED_SCREWS_ADJUST G-Code 命令。

有關更多信息，請參閱 [leveling guide](Manual_Level.md#adjusting-bed-leveling-screws) 和 [command reference](G-Codes.md#bed_screws)。

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

使用 Z 探頭幫助調整床螺絲傾斜度的工具。可以定義一個 screw_tilt_adjust 配置部分來啟用 SCREWS_TILT_CALCULATE G-Code 命令。

有關更多信息，請參閱 [leveling guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) 和 [command reference](G-Codes.md#screws_tilt_adjust)。

```
[screws_tilt_adjust]
#screw1:
#   The (X, Y) coordinate of the first bed leveling screw. This is a
#   position to command the nozzle to so that the probe is directly
#   above the bed screw (or as close as possible while still being
#   above the bed). This is the base screw used in calculations. This
#   parameter must be provided.
#screw1_name:
#   An arbitrary name for the given screw. This name is displayed when
#   the helper script runs. The default is to use a name based upon
#   the screw XY location.
#screw2:
#screw2_name:
#...
#   Additional bed leveling screws. At least two screws must be
#   defined.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#screw_thread: CW-M3
#   The type of screw used for bed level, M3, M4 or M5 and the
#   direction of the knob used to level the bed, clockwise decrease
#   counter-clockwise decrease.
#   Accepted values: CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
#   Default value is CW-M3, most printers use an M3 screw and
#   turning the knob clockwise decrease distance.
```

### [z_tilt]

多 Z 步進傾斜調整。此功能可以獨立調整多個 z 步進器（請參閱“stepper_z1”部分）以調整傾斜。如果此部分存在，則 Z_TILT_ADJUST 擴展 [G-Code 命令](G-Codes.md#z_tilt) 變得可用。

```
[z_tilt]
#z_positions:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) describing the location of each bed "pivot point". The
#   "pivot point" is the point where the bed attaches to the given Z
#   stepper. It is described using nozzle coordinates (the X, Y position
#   of the nozzle if it could move directly above the point). The
#   first entry corresponds to stepper_z, the second to stepper_z1,
#   the third to stepper_z2, etc. This parameter must be provided.
#points:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) that should be probed during a Z_TILT_ADJUST command.
#   Specify coordinates of the nozzle and be sure the probe is above
#   the bed at the given nozzle coordinates. This parameter must be
#   provided.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#retries: 0
#   Number of times to retry if the probed points aren't within
#   tolerance.
#retry_tolerance: 0
#   If retries are enabled then retry if largest and smallest probed
#   points differ more than retry_tolerance. Note the smallest unit of
#   change here would be a single step. However if you are probing
#   more points than steppers then you will likely have a fixed
#   minimum value for the range of probed points which you can learn
#   by observing command output.
```

### [quad_gantry_level]

使用 4 個獨立控制的 Z 電機移動龍門調平。修正移動龍門上的雙曲拋物線效應（薯片），更加靈活。警告：在移動床上使用它可能會導致不良結果。如果此部分存在，則 QUAD_GANTRY_LEVEL 擴展 G 代碼命令可用。此例程假定以下 Z 電機配置：

```
 ----------------
 |Z1          Z2|
 |  ---------   |
 |  |       |   |
 |  |       |   |
 |  x--------   |
 |Z           Z3|
 ----------------
```

其中 X 是床上的0、0點

```
[quad_gantry_level]
#gantry_corners:
#   A newline separated list of X, Y coordinates describing the two
#   opposing corners of the gantry. The first entry corresponds to Z,
#   the second to Z2. This parameter must be provided.
#points:
#   A newline separated list of four X, Y points that should be probed
#   during a QUAD_GANTRY_LEVEL command. Order of the locations is
#   important, and should correspond to Z, Z1, Z2, and Z3 location in
#   order. This parameter must be provided. For maximum accuracy,
#   ensure your probe offsets are configured.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#max_adjust: 4
#   Safety limit if an adjustment greater than this value is requested
#   quad_gantry_level will abort.
#retries: 0
#   Number of times to retry if the probed points aren't within
#   tolerance.
#retry_tolerance: 0
#   If retries are enabled then retry if largest and smallest probed
#   points differ more than retry_tolerance.
```

### [skew_correction]

打印機歪斜校正。可以使用軟件糾正打印機在 3 個平面 xy、xz、yz 上的歪斜。這是通過沿平面打印校準模型並測量三個長度來完成的。由於歪斜校正的性質，這些長度是通過 gcode 設置的。有關詳細信息，請參閱 [Skew Correction](Skew_Correction.md) 和 [Command Reference](G-Codes.md#skew_correction)。

```
[skew_correction]
```

## 自定義歸零

### [safe_z_home]

安全 Z 歸位。可以使用這種機制將 Z 軸歸位到特定的 X、Y 坐標。例如，如果工具頭必須在 Z 可以歸位之前移動到床的中心，這很有用。

```
[safe_z_home]
home_xy_position:
#   A X, Y coordinate (e.g. 100, 100) where the Z homing should be
#   performed. This parameter must be provided.
#speed: 50.0
#   Speed at which the toolhead is moved to the safe Z home
#   coordinate. The default is 50 mm/s
#z_hop:
#   Distance (in mm) to lift the Z axis prior to homing. This is
#   applied to any homing command, even if it doesn't home the Z axis.
#   If the Z axis is already homed and the current Z position is less
#   than z_hop, then this will lift the head to a height of z_hop. If
#   the Z axis is not already homed the head is lifted by z_hop.
#   The default is to not implement Z hop.
#z_hop_speed: 15.0
#   Speed (in mm/s) at which the Z axis is lifted prior to homing. The
#   default is 15 mm/s.
#move_to_previous: False
#   When set to True, the X and Y axes are reset to their previous
#   positions after Z axis homing. The default is False.
```

### [homing_override]

歸位覆寫。可以使用這種機制來執行一系列 G-Code 命令來替代常規的G28。通常用於需要特定過程才能將機器歸零的印表機。

```
[homing_override]
gcode：
#   覆蓋常規 G28 命令的 G 程式碼命令序列。
#   G 程式碼格式請參閱 docs/Command_Templates.md。如果
#   G28 包含在此命令列表中，常規版本的G28會被呼叫並進
#   行印表機的正常歸位過程。此處列出的命令必須歸位所
#   有軸。
#   必須提供此參數。
#axes: xyz
#   要覆蓋的軸。例如，如果將其設定為"z"，則覆蓋指令碼將
#   僅在 z 軸被歸位時執行（例如，通過"G28" 或 "G28 Z0"
#   命令）。請注意，覆蓋指令碼仍然需要歸位所有軸。
#   預設值為"xyz"，覆蓋全部所有 G28 命令。
#set_position_x：
#set_position_y：
#set_position_z：
#   如果指定，印表機將假定軸在執行上述 G 程式碼命令序列
#   之前的位置。該設定會禁用相應軸的歸位檢查。在列印
#   頭必須在執行常規 G28 機制前移動相應的軸時有用。
#   預設不假定軸的位置。
```

### [endstop_phase]

步進相位調整擋塊。要使用此功能，請使用“endstop_phase”前綴定義配置部分，後跟相應步進器配置部分的名稱（例如，“[endstop_phase stepper_z]”）。此功能可以提高限位開關的準確性。添加一個簡單的“[endstop_phase]”聲明以啟用 ENDSTOP_PHASE_CALIBRATE 命令。

有關更多信息，請參閱 [endstop phases guide](Endstop_Phase.md) 和 [command reference](G-Codes.md#endstop_phase)。

```
[endstop_phase stepper_z]
#endstop_accuracy:
#   設定預期的限位精度（以毫米(mm)為單位）。 代表了相位可能
#   觸發的最大誤差距離（比如，一個可能會提早 100um 觸發或延遲
#   100um 觸發的限位需要將該值設為 0.200,也就是 200um）。
#  預設為 4*rotation_distance/full_steps_per_rotation。
#trigger_phase:
#   該參數定義了相位觸發時預期的步進電機驅動相位。這通常是兩
#   個由正斜槓符號分隔的整數 - 相位和總相位數（例如 "7/64"）。
#   只有當步進電機驅動在 mcu 重置時也會重置才需要該參數。
#   如果沒有定義，步進相位會在第一次歸位時檢測並被用於後續歸位。
#endstop_align_zero: False
#   如果是 True 則印表機的 position_endstop 相應軸的零點位置是步進
#   電機的一個全步位置。(在Z軸上，如果列印層高是全步的倍數，每
#   層都會在全步上。）
#   預設為 False。
```

## G 程式碼宏和事件

### [gcode_macro]

G-Code宏（"gcode_macro"字首定義的G-Code 宏分段沒有數量限制）。更多資訊請參見[命令模板指南](Command_Templates.md)。

```
[gcode_macro 命令] 。
#gcode:
#   一個替代"命令" 執行的 G 程式碼命令的列表。請看
#   docs/Command_Templates.md 瞭解支援的 G 程式碼格式。
#   必須提供此參數。
#variable_<名稱>:
#   可以指定任意數量的帶有"變數_"字首的設定。
#   定義的變數名將被賦予給定的值（並被解析為作為一個
#   Python Literal），並在宏擴充套件時可用。
#   例如，一個帶有"variable_fan_speed = 75"的 G-Code 命令的
#   G 程式碼列表中可以包含"M106 S{ fan_speed * 255 }"。變數
#   可以在執行時使用 SET_GCODE_VARIABLE 命令進行修改
#   （詳見docs/Command_Templates.md）。變數名稱
#   不能使用大寫字母。
#rename_existing:
#   這個選項將導致宏覆蓋一個現有的 G-Code 命令，並通過
#   這裡提供的名稱引用該命令的先前定義。覆蓋命令時應注
#   意，因為它可能會導致複雜和意外的錯誤。
#   預設不覆蓋現有的 G-Code 命令。
#description: G-Code macro
#   在 HELP 命令或自動完成中使用的簡單描述。
#   預設為"G-Code macro"。
```

### [delayed_gcode]

在設定的延遲上執行 G-Codee。有關詳細信息，請參閱 [command template guide](Command_Templates.md#delayed-gcodes) 和 [command reference](G-Codes.md#delayed_gcode)。

```
[delayed_gcode my_delayed_gcode]。
gcode:
#   當延遲時間結束后執行的G程式碼命令列表。支援G程式碼模板。
#   必須提供這個參數。
#initial_duration:0.0
#   初始延遲的持續時間(以秒為單位)。如果設定為一個
#   非零值，delayed_gcode 將在印表機進入 "就緒 "狀態后指定
#   秒數后執行。可能對初始化程式或重複的 delayed_gcode 有
#   用。如果設定為 0，delayed_gcode 將在啟動時不執行。
# 預設為0。
```

### [save_variables]

支持將變量保存到磁盤，以便在重新啟動時保留它們。有關詳細信息，請參閱 [command templates]](Command_Templates.md#save-variables-to-disk) 和 [G-Code reference](G-Codes.md#save_variables)。

```
[save_variables]
filename:
#   必須提供一個可以用來儲存參數到磁碟的檔名。
#   例如 . ~/variables.cfg
```

### [idle_timeout]

閒置超時。預設啟用閒置超時 - 新增顯式 idle_timeout 配置分段以更改預設設定。

```
[idle_timeout]
#gcode:
#   在空閑超時時執行的一系列 G-Code 命令。G-Code 格式請見
#   docs/Command_Templates.md。
#   預設執行 "TURN_OFF_HEATERS" 和 "M84"。
#timeout: 600
#   在執行以上 G-Code 前等待的空閑時間（以秒為單位）
#   預設為 600 秒。
```

## 可選的 G-Code 特性

### [virtual_sdcard]

如果主機的速度不足以很好地執行 OctoPrint，虛擬 SD 卡可能有幫助。它允許 Klipper 主機軟體使用標準的 SD 卡G程式碼命令（例如，M24）直接列印儲存在主機目錄中的 gcode 檔案。

```
[virtual_sdcard]
path:
#   The path of the local directory on the host machine to look for
#   g-code files. This is a read-only directory (sdcard file writes
#   are not supported). One may point this to OctoPrint's upload
#   directory (generally ~/.octoprint/uploads/ ). This parameter must
#   be provided.
#on_error_gcode:
#   A list of G-Code commands to execute when an error is reported.
```

### [sdcard_loop]

一些具有階段清除功能的打印機，例如部件彈出器或帶式打印機，可以在 sdcard 文件的循環部分中找到用途。 （例如，一遍又一遍地打印相同的零件，或重複零件的一部分以獲得鍊或其他重複圖案）。

有關支持的命令，請參閱 [命令參考](G-Codes.md#sdcard_loop)。請參閱 [sample-macros.cfg](../config/sample-macros.cfg) 文件了解 Marlin 兼容的 M808 G-Code碼。

```
[sdcard_loop]
```

### [force_move]

支持手動移動步進電機進行診斷。請注意，使用此功能可能會使打印機處於無效狀態 - 有關重要詳細信息，請參閱 [命令參考](G-Codes.md#force_move)。

```
[force_move]
#enable_force_move: False
#   設定為true來啟用 FORCE_MOVE 和 SET_KINEMATIC_POSITION 擴充套件 
#   G程式碼命令。
#   預設為false。
```

### [pause_resume]

支持位置捕獲和恢復的暫停/恢復功能。有關詳細信息，請參閱 [命令參考](G-Codes.md#pause_resume)。

```
[pause_resume]
#recover_velocity: 50.
#   當捕捉/恢復功能被啟用時，返回到捕獲的位置的速度(單位：毫米/秒)。
#   預設為50.0 mm/s。
```

### [firmware_retraction]

固件印絲回抽。這啟用了由許多切片器發出的 G10（回抽）和 G11（取消回抽）GCODE 命令。下面的參數提供了啟動默認值，儘管可以通過 SET_RETRACTION [命令](G-Codes.md#firmware_retraction)) 調整這些值，從而允許每燈絲設置和運行時間調整。

```
[firmware_retraction]
#retract_length: 0
#   當 G10 被執行時回抽的長度（以毫米(mm)為單位）
#   和當 G11 被執行時退回的長度（但同時也包括
#   以下的unretract_extra_length）。
#   預設為0毫米。
#retract_speed: 20
#   回抽速度，以毫米每秒(mm/s)為單位。預設為每秒20毫米。
#unretract_extra_length: 0
#   退回時增加*額外*長度（以毫米(mm)為單位）的耗材。
#unretract_speed: 10
#   退回速度，以毫米(mm)為單位。
#   預設為每秒10毫米
```

### [gcode_arcs]

支持 G-Code arc (G2/G3) 命令。

```
[gcode_arcs]
#resolution: 1.0
#   一條弧線將被分割成若干段。每段的長度將
#   等於上面設定的解析度（mm）。更低的值會產生一個
#   更細膩的弧線，但也會需要機器進行更多運算。小於
#   配置值的曲線會被視為直線。
#   預設為1毫米。
```

### [respond]

啟用“M118”和“RESPOND”擴展 [commands](G-Codes.md#respond)。

```
[respond]
#default_type: echo
# 設置“M118”和“RESPOND”輸出的默認前綴為
#   以下的一項
#       echo: "echo: " (This is the default)
#       command: "// "
#       error: "!! "
#default_prefix: echo:
# 直接設置默認前綴。如果存在，該值將
# 覆蓋“default_type”。
```

### [exclude_object]

Enables support to exclude or cancel individual objects during the printing process.

See the [exclude objects guide](Exclude_Object.md) and [command reference](G-Codes.md#excludeobject) for additional information. See the [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.

```
[exclude_object]
```

## 共振補償

### [input_shaper]

啟用 [resonance compensation](Resonance_Compensation.md)。另請參閱 [命令參考](G-Codes.md#input_shaper)。

```
[input_shaper]
#shaper_freq_x: 0
#   輸入整形器的 X 軸頻率(Hz)。通常這是希望被輸入整形器消除的
#   X 軸共振頻率。對於更復雜的整形器，例如2- 和 3-hump EI 輸入
#   整形器，設定這個參數可能需要考慮其他特性。
#   預設值是0，禁用 X 軸輸入整形。
#shaper_freq_y: 0
#   輸入整形器的 Y 軸頻率(Hz)。通常這是希望被輸入整形器消除的
#   Y 軸共振頻率。對於更復雜的整形器，例如2- 和 3-hump EI 輸入
#   整形器，設定這個參數可能需要考慮其他特性。
#   預設值是0，禁用 Y 軸輸入整形。
#shaper_type: mzv
#   用於 X 和 Y 軸的輸入整形器。支援的輸入整形器有 zv、mzv、
#   zvd、ei、2hump_ei 和 3hump_ei。
#   預設為 mzv 輸入整形器。
#shaper_type_x:
#shaper_type_y:
#   如果沒有設定 shaper_type，可以用這兩個參數來單獨配置 X
#   和 Y 軸的 輸入整形器。
#   該參數支援全部shaper_type 支援的選項。
#damping_ratio_x: 0.1
#damping_ratio_y: 0.1
#   X 和 Y 軸的共振抑制比例，可以用來改善振動抑制效果。
#   預設值是 0.1，適用於大多數印表機。
#   大多數情況下不需要調整這個值。
```

### [adxl345]

支持 ADXL345 加速度計。這種支持允許人們從傳感器查詢加速度計測量值。這將啟用 ACCELEROMETER_MEASURE 命令（有關詳細信息，請參閱 [G-Codes](G-Codes.md#adxl345)）。默認芯片名稱是“default”，但可以指定一個明確的名稱（例如，[adxl345 my_chip_name]）。

```
[adxl345]
cs_pin:
#   感測器的 SPI 啟用引腳。
#   必須提供此參數。
#spi_speed: 5000000
#   與晶片通訊時使用的SPI速度(hz)。
#   預設為5000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   參見"常見的SPI設定"章節，以瞭解對上述參數的描述。
#axes_map: x, y, z
#   印表機的X、Y和Z軸的加速度計軸。
#   如果加速度計的安裝方向與印表機的方向不一致，
#   可能需要修改該設定。
#   例如，可以將其設定為"y, x, z"來交換X和Y軸。
#   如果加速度計方向是相反的，可能需要反轉相應軸
#   （例如，"x, z, -y"）。
#   預設是"x, y, z"。
#rate: 3200
#   ADXL345的輸出數據速率。ADXL345支援以下數據速率。
#   3200、1600、800、400、200、100、50和25。請注意，不建議
#   將此速率從預設的3200改為低於800的速率，這將大大影響
#   共振測量的質量。
```

### [mpu9250]

Support for mpu9250 and mpu6050 accelerometers (one may define any number of sections with an "mpu9250" prefix).

```
[mpu9250 my_accelerometer]
#i2c_address:
#   Default is 104 (0x68).
#i2c_mcu:
#i2c_bus:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [resonance_tester]

支持共振測試和自動輸入整形器校準。為了使用該模塊的大部分功能，必須安裝額外的軟件依賴項；有關詳細信息，請參閱 [測量共振](Measuring_Resonances.md) 和 [命令參考](G-Codes.md#resonance_tester)。有關 `max_smoothing` 參數及其使用的更多信息，請參閱測量共振指南的 [Max Smoothing](Measuring_Resonances.md#max-smoothing) 部分。

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
#min_freq: 5
#   Minimum frequency to test for resonances. The default is 5 Hz.
#max_freq: 133.33
#   Maximum frequency to test for resonances. The default is 133.33 Hz.
#accel_per_hz: 75
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
```

## 配置檔案助手

### [board_pins]

控制板引腳別名（可以定義任意數量的帶有 "board_pins "字首的分段）。用它來定義微控制器上的引腳的別名。

```
[board_pins my_aliases]。
mcu: mcu
#   一個可以使用別名的逗號分隔的微控制器列表。
#   預設將別名應用於主 "mcu"。
aliases:
aliases_<name>:
#   為給定的微控制器建立的一個以逗號分隔的 "name=value "
#   別名列表。例如，"EXP1_1=PE6" 將建立一個用於 "PE6 "引
#   腳的"EXP1_1 "別名。然而，如果 "值 " 被包括在 "<>"中，
#   則 "name "將被建立為一個保留針腳（例如，"EXP1_9=<GND>" 
#   將保留 "EXP1_9"）。可以指定任何數量以 "aliases_"開頭的分段。
```

### [include]

引入檔案支援。可以在主印表機配置檔案中引用額外的配置檔案。支援萬用字元（例如，`configs/*.cfg`）。

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

該工具允許在配置文件中多次定義單個微控制器引腳，而無需進行正常的錯誤檢查。這用於診斷和調試目的。如果 Klipper 支持多次使用相同的引腳，則不需要此部分，並且使用此覆蓋可能會導致混淆和意外結果。

```
[duplicate_pin_override]
pins:
#   一個逗號分隔的引腳列表，允許其中的引腳在配置檔案中被多次使用而不觸發錯誤檢查。
#   必須提供此參數。
```

## 列印床探測硬體

### [probe]

Z 高度探頭。可以定義此部分以啟用 Z 高度探測硬件。啟用此部分後，PROBE 和 QUERY_PROBE 擴展 [g-code commands](G-Codes.md#probe) 變得可用。此外，請參閱 [探頭校準指南](Probe_Calibrate.md)。探測部分還創建一個虛擬的“probe:z_virtual_endstop”引腳。可以將 stepper_z endstop_pin 設置為笛卡爾式打印機上的此虛擬引腳，該打印機使用探針代替 z 終點。如果使用“probe:z_virtual_endstop”，則不要在 stepper_z 配置部分定義 position_endstop。

```
[probe]
pin:
#   Probe detection pin. If the pin is on a different microcontroller
#   than the Z steppers then it enables "multi-mcu homing". This
#   parameter must be provided.
#deactivate_on_each_sample: True
#   This determines if Klipper should execute deactivation gcode
#   between each probe attempt when performing a multiple probe
#   sequence. The default is True.
#x_offset: 0.0
#   The distance (in mm) between the probe and the nozzle along the
#   x-axis. The default is 0.
#y_offset: 0.0
#   The distance (in mm) between the probe and the nozzle along the
#   y-axis. The default is 0.
z_offset:
#   The distance (in mm) between the bed and the nozzle when the probe
#   triggers. This parameter must be provided.
#speed: 5.0
#   Speed (in mm/s) of the Z axis when probing. The default is 5mm/s.
#samples: 1
#   The number of times to probe each point. The probed z-values will
#   be averaged. The default is to probe 1 time.
#sample_retract_dist: 2.0
#   The distance (in mm) to lift the toolhead between each sample (if
#   sampling more than once). The default is 2mm.
#lift_speed:
#   Speed (in mm/s) of the Z axis when lifting the probe between
#   samples. The default is to use the same value as the 'speed'
#   parameter.
#samples_result: average
#   The calculation method when sampling more than once - either
#   "median" or "average". The default is average.
#samples_tolerance: 0.100
#   The maximum Z distance (in mm) that a sample may differ from other
#   samples. If this tolerance is exceeded then either an error is
#   reported or the attempt is restarted (see
#   samples_tolerance_retries). The default is 0.100mm.
#samples_tolerance_retries: 0
#   The number of times to retry if a sample is found that exceeds
#   samples_tolerance. On a retry, all current samples are discarded
#   and the probe attempt is restarted. If a valid set of samples are
#   not obtained in the given number of retries then an error is
#   reported. The default is zero which causes an error to be reported
#   on the first sample that exceeds samples_tolerance.
#activate_gcode:
#   A list of G-Code commands to execute prior to each probe attempt.
#   See docs/Command_Templates.md for G-Code format. This may be
#   useful if the probe needs to be activated in some way. Do not
#   issue any commands here that move the toolhead (eg, G1). The
#   default is to not run any special G-Code commands on activation.
#deactivate_gcode:
#   A list of G-Code commands to execute after each probe attempt
#   completes. See docs/Command_Templates.md for G-Code format. Do not
#   issue any commands here that move the toolhead. The default is to
#   not run any special G-Code commands on deactivation.
```

### [bltouch]

BLTouch 探針。可以定義這個分段（而不是探針（probe）分段）來啟用 BLTouch 探針。更多資訊見[BL-Touch 指南](BLTouch.md)和[命令參考](G-Code.md#bltouch)。一個虛擬的 "probe:z_virtual_endstop "引腳也會被同時建立（詳見 "probe "章節）。

```
[bltouch]
sensor_pin:
#   Pin connected to the BLTouch sensor pin. Most BLTouch devices
#   require a pullup on the sensor pin (prefix the pin name with "^").
#   This parameter must be provided.
control_pin:
#   Pin connected to the BLTouch control pin. This parameter must be
#   provided.
#pin_move_time: 0.680
#   The amount of time (in seconds) to wait for the BLTouch pin to
#   move up or down. The default is 0.680 seconds.
#stow_on_each_sample: True
#   This determines if Klipper should command the pin to move up
#   between each probe attempt when performing a multiple probe
#   sequence. Read the directions in docs/BLTouch.md before setting
#   this to False. The default is True.
#probe_with_touch_mode: False
#   If this is set to True then Klipper will probe with the device in
#   "touch_mode". The default is False (probing in "pin_down" mode).
#pin_up_reports_not_triggered: True
#   Set if the BLTouch consistently reports the probe in a "not
#   triggered" state after a successful "pin_up" command. This should
#   be True for all genuine BLTouch devices. Read the directions in
#   docs/BLTouch.md before setting this to False. The default is True.
#pin_up_touch_mode_reports_triggered: True
#   Set if the BLTouch consistently reports a "triggered" state after
#   the commands "pin_up" followed by "touch_mode". This should be
#   True for all genuine BLTouch devices. Read the directions in
#   docs/BLTouch.md before setting this to False. The default is True.
#set_output_mode:
#   Request a specific sensor pin output mode on the BLTouch V3.0 (and
#   later). This setting should not be used on other types of probes.
#   Set to "5V" to request a sensor pin output of 5 Volts (only use if
#   the controller board needs 5V mode and is 5V tolerant on its input
#   signal line). Set to "OD" to request the sensor pin output use
#   open drain mode. The default is to not request an output mode.
#x_offset:
#y_offset:
#z_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   See the "probe" section for information on these parameters.
```

### [smart_effector]

The "Smart Effector" from Duet3d implements a Z probe using a force sensor. One may define this section instead of `[probe]` to enable the Smart Effector specific features. This also enables [runtime commands](G-Codes.md#smart_effector) to adjust the parameters of the Smart Effector at run time.

```
[smart_effector]
pin:
#   Pin connected to the Smart Effector Z Probe output pin (pin 5). Note that
#   pullup resistor on the board is generally not required. However, if the
#   output pin is connected to the board pin with a pullup resistor, that
#   resistor must be high value (e.g. 10K Ohm or more). Some boards have a low
#   value pullup resistor on the Z probe input, which will likely result in an
#   always-triggered probe state. In this case, connect the Smart Effector to
#   a different pin on the board. This parameter is required.
#control_pin:
#   Pin connected to the Smart Effector control input pin (pin 7). If provided,
#   Smart Effector sensitivity programming commands become available.
#probe_accel:
#   If set, limits the acceleration of the probing moves (in mm/sec^2).
#   A sudden large acceleration at the beginning of the probing move may
#   cause spurious probe triggering, especially if the hotend is heavy.
#   To prevent that, it may be necessary to reduce the acceleration of
#   the probing moves via this parameter.
#recovery_time: 0.4
#   A delay between the travel moves and the probing moves in seconds. A fast
#   travel move prior to probing may result in a spurious probe triggering.
#   This may cause 'Probe triggered prior to movement' errors if no delay
#   is set. Value 0 disables the recovery delay.
#   Default value is 0.4.
#x_offset:
#y_offset:
#   Should be left unset (or set to 0).
z_offset:
#   Trigger height of the probe. Start with -0.1 (mm), and adjust later using
#   `PROBE_CALIBRATE` command. This parameter must be provided.
#speed:
#   Speed (in mm/s) of the Z axis when probing. It is recommended to start
#   with the probing speed of 20 mm/s and adjust it as necessary to improve
#   the accuracy and repeatability of the probe triggering.
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#deactivate_on_each_sample:
#   See the "probe" section for more information on the parameters above.
```

## 額外的步進電機和擠出機

### [stepper_z1]

多步進軸。在XYZ機型打印機上，控制給定軸的步進器可能具有額外的配置塊，這些配置塊定義了應該與主步進器一起步進的步進器。可以使用從 1 開始的數字後綴定義任意數量的部分（例如，“stepper_z1”、“stepper_z2”等）。

```
[stepper_z1]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
# 上述參數的定義見“步進器”部分。
#endstop_pin:
# 如果為附加步進器定義了 endstop_pin，則
# stepper 將返回直到 endstop 被觸發。否則，該
# 步進器將返回原位，直到主步進器上的 endstop 為
# 軸被觸發。
```

### [extruder1]

在一個多擠出機的印表機中，為每個額外的擠出機新增一個額外擠出機分段。額外擠出機分段應被命名為"extruder1"、"extruder2"、"extruder3"，以此類推。有關可用參數，參見"extruder"章節。

有關示例配置，請參見 [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg)。

```
[extruder1]
#step_pin:
#dir_pin:
#...
# 有關可用的步進器和加熱器，請參閱“擠出機”部分
＃   參數。
#shared_heater:
# 此選項已棄用，不應再指定。
```

### [dual_carriage]

支持在單軸上具有雙托架的XYZ機型打印機。活動托架通過 SET_DUAL_CARRIAGE 擴展 G-Code設置。 “SET_DUAL_CARRIAGE CARRIAGE=1”命令將激活本節中定義的托架（CARRIAGE=0 將激活返回到主托架）。雙托架支持通常與額外的擠出機結合使用 - SET_DUAL_CARRIAGE 命令通常與 ACTIVATE_EXTRUDER 命令同時調用。請務必在停用期間停放托架。

有關示例配置，請參閱 [sample-idex.cfg](../config/sample-idex.cfg)。

```
[dual_carriage]
axis:
#   額外滑車所在的軸（x或者y）。
#   必須提供這個參數。
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   以上參數的定義請查閱「stepper」分段。
```

### [extruder_stepper]

支持與擠出機運動同步的附加步進器（可以定義任意數量的帶有“extruder_stepper”前綴的部分）。

有關詳細信息，請參閱 [命令參考](G-Codes.md#extruder)。

```
[extruder_stepper my_extra_stepper]
extruder:
#   The extruder this stepper is synchronized to. If this is set to an
#   empty string then the stepper will not be synchronized to an
#   extruder. This parameter must be provided.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   See the "stepper" section for the definition of the above
#   parameters.
```

### [manual_stepper]

手動步進器（可以使用“manual_stepper”前綴定義任意數量的部分）。這些是由 MANUAL_STEPPER g-code 命令控制的步進器。例如：“MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5”。有關 MANUAL_STEPPER 命令的說明，請參見 [G-Codes](G-Codes.md#manual_stepper) 文件。步進器未連接到正常的打印機運動學。

```
[manual_stepper my_stepper]。
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   有關這些參數的描述請見"stepper"分段。
#velocity:
#   設定步進電機的預設速度（單位：mm/s）。這個值會在 MANUAL_STEPPER
#   命令沒有指定一個 SPEED 參數時會被使用。
#   預設為 5 mm/s。
#accel:
#   設定步進電機的預設加速度（單位：mm/s^2）。設定加速度為零將導致
#   沒有加速度。這個值會在 MANUAL_STEPPER 命令沒有指定 ACCEL 參數時
#   會被使用。
#   預設為 0。
#endstop_pin:
#   限位開關檢測引腳。如果定義了這個參數，可以通過在 MANUAL_STEPPER
#   運動命令中新增一個 STOP_ON_ENDSTOP 參數來執行 "歸位動作" 。
```

## 自定義加熱器和感測器

### [verify_heater]

加熱器和溫度感測器驗證。預設在印表機上每個配置的加熱器上啟用加熱器驗證。使用 verify_heater 分段來覆蓋預設設定。

```
[verify_heater heater_config_name]
#max_error: 120
#   The maximum "cumulative temperature error" before raising an
#   error. Smaller values result in stricter checking and larger
#   values allow for more time before an error is reported.
#   Specifically, the temperature is inspected once a second and if it
#   is close to the target temperature then an internal "error
#   counter" is reset; otherwise, if the temperature is below the
#   target range then the counter is increased by the amount the
#   reported temperature differs from that range. Should the counter
#   exceed this "max_error" then an error is raised. The default is
#   120.
#check_gain_time:
#   This controls heater verification during initial heating. Smaller
#   values result in stricter checking and larger values allow for
#   more time before an error is reported. Specifically, during
#   initial heating, as long as the heater increases in temperature
#   within this time frame (specified in seconds) then the internal
#   "error counter" is reset. The default is 20 seconds for extruders
#   and 60 seconds for heater_bed.
#hysteresis: 5
#   The maximum temperature difference (in Celsius) to a target
#   temperature that is considered in range of the target. This
#   controls the max_error range check. It is rare to customize this
#   value. The default is 5.
#heating_gain: 2
#   The minimum temperature (in Celsius) that the heater must increase
#   by during the check_gain_time check. It is rare to customize this
#   value. The default is 2.
```

### [homing_heaters]

在歸位或探測軸時禁用加熱器的工具。

```
[homing_heaters]
#steppers:
#   會使加熱器被禁用的步進電機逗號分隔列表。
#   預設在歸零和探測時禁用全部加熱器。
#   例如：stepper_z
#heaters:
#   歸零和探測時會被禁用的加熱器的逗號分隔列表。
#   預設禁用全部加熱器。
#   例如：extruder, heater_bed
```

### [thermistor]

自定義熱敏電阻（可以定義任意數量的帶有「熱敏電阻」字首的分段）。可以在加熱器配置分段的 sensor_type 欄位中使用自定義熱敏電阻。 （例如，如果定義了「[thermistor my_thermistor]」分段，那麼在定義加熱器時可以使用「sensor_type: my_thermistor」。）確保將熱敏電阻分段放在配置檔案中第一次使用這個感測器的加熱器分段的上方。

```
[thermistor my_thermistor]
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#temperature3:
#resistance3:
#   Three resistance measurements (in Ohms) at the given temperatures
#   (in Celsius). The three measurements will be used to calculate the
#   Steinhart-Hart coefficients for the thermistor. These parameters
#   must be provided when using Steinhart-Hart to define the
#   thermistor.
#beta:
#   Alternatively, one may define temperature1, resistance1, and beta
#   to define the thermistor parameters. This parameter must be
#   provided when using "beta" to define the thermistor.
```

### [adc_temperature]

自定義 ADC 溫度感測器（可以使用 「adc_temperature」 字首定義任意數量的分段）。這允許定義一個自定義溫度感測器，該感測器測量一個模數轉換器 (ADC) 引腳上的電壓，並在一組配置的溫度/電壓（或溫度/電阻）測量值之間使用線性插值來確定溫度。設定的感測器可被用作加熱器分段中的 sensor_type。 （例如，如果定義了 「[adc_temperature my_sensor]」 分段，則在定義加熱器時可以使用 「sensor_type: my_sensor」 。）確保將感測器分段放在配置檔案中第一次使用這個感測器的加熱器分段的上方。

```
[adc_temperature my_sensor]
#temperature1:
#voltage1:
#temperature2:
#voltage2:
#...
#   一組用作溫度轉換的參考溫度（以攝氏度為單位）和電壓（以
#   伏特為單位）。使用這個感測器的加熱器分段也可以指定
#   adc_voltage 和 voltage_offset 參數來定義 ADC 電壓（詳見「常用溫度
#   放大器」章節）。至少要提供兩個測量點。
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#...
#   作為替代，也可以指定一組用作溫度轉換的參考溫度（以攝氏度為
#   單位）和阻值（以歐姆為單位）。使用這個感測器的加熱器分段也
#   可以指定一個 pullup_resistor 參數（詳見「擠出機」章節）。至少要
#   提供兩個測量點。
```

### [heater_generic]

通用加熱器（可以使用“heater_generic”前綴定義任意數量的部分）。這些加熱器的行為類似於標準加熱器（擠出機、加熱床）。使用 SET_HEATER_TEMPERATURE 命令（詳見 [G-Codes](G-Codes.md#heaters)）設置目標溫度。

```
[heater_generic my_generic_heater]
#gcode_id:
#   使用M105查詢溫度時使用的ID。
#   必須提供此參數。
#heater_pin:
#max_power:
#sensor_type:
#sensor_pin:
#smooth_time:
#control:
#pid_Kp:
#pid_Ki:
#pid_Kd:
#pwm_cycle_time:
#min_temp:
#max_temp:
#   以上參數詳見「extruder」分段。
```

### [temperature_sensor]

通用溫度感測器（可以定義任意數量的通用溫度感測器）。通過 M105 命令查詢溫度。

```
[temperature_sensor my_sensor]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   See the "extruder" section for the definition of the above
#   parameters.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
```

## 溫度傳感器

Klipper 包括許多型別的溫度感測器的定義。這些感測器可以在任何需要溫度感測器的配置分段中使用（例如`[extruder]`或`[heated_bed]`分段）。

### 常見熱敏電阻

常見的熱敏電阻。在使用這些感測器之一的加熱器分段中可以使用以下參數。

```
sensor_type:
#   One of "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
#   "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
#   "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", or "TDK NTCG104LH104JT1"
sensor_pin:
#   Analog input pin connected to the thermistor. This parameter must
#   be provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the thermistor.
#   The default is 4700 ohms.
#inline_resistor: 0
#   The resistance (in ohms) of an extra (not heat varying) resistor
#   that is placed inline with the thermistor. It is rare to set this.
#   The default is 0 ohms.
```

### 常見溫度放大器

常見溫度放大器。在使用這些感測器之一的加熱器分段中可以使用以下參數。

```
sensor_type:

# “PT100 INA826”、“AD595”、“AD597”、“AD8494”、“AD8495”之一，
#“AD8496” 或“AD8497”。
sensor_pin:
# 模擬輸入引腳連接到傳感器。該參數必須是
＃   設定。
#adc_voltage: 5.0
# ADC 比較電壓（以伏特為單位）。默認值為 5 伏。
#voltage_offset: 0
# ADC 電壓偏移（以伏特為單位）。默認值為 0。
```

### 直接連線的 PT1000 感測器

直接連線到控制板的 PT1000 感測器。以下參數可用於使用這些感測器之一的加熱器分段。

```
sensor_type: PT1000
sensor_pin:
# 模擬輸入引腳連接到傳感器。該參數必須是
＃   設定。
#pullup_resistor: 4700
# 連接到傳感器的上拉電阻（以歐姆為單位）。這
# 默認為 4700 歐姆。
```

### MAXxxxxx 溫度感測器

MAXxxxxx 序列外設介面（SPI）溫度感測器。以下參數在使用該型別感測器的加熱器分段中可用。

```
sensor_type:
#   One of "MAX6675", "MAX31855", "MAX31856", or "MAX31865".
sensor_pin:
#   The chip select line for the sensor chip. This parameter must be
#   provided.
#spi_speed: 4000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#tc_type: K
#tc_use_50Hz_filter: False
#tc_averaging_count: 1
#   The above parameters control the sensor parameters of MAX31856
#   chips. The defaults for each parameter are next to the parameter
#   name in the above list.
#rtd_nominal_r: 100
#rtd_reference_r: 430
#rtd_num_of_wires: 2
#rtd_use_50Hz_filter: False
#   The above parameters control the sensor parameters of MAX31865
#   chips. The defaults for each parameter are next to the parameter
#   name in the above list.
```

### BMP280/BME280/BME680 溫度感測器

BMP280/BME280/BME680 兩線介面 (I2C) 環境感測器。注意，這些感測器不適用于擠出機和加熱床。它們可以用於監測環境溫度 (C)、壓力 (hPa)、相對濕度以及氣體水平（僅在BME680上）。請參閱 [sample-macros.cfg](../config/sample-macros.cfg) 以獲取可用於報告壓力和濕度以及溫度的gcode_macro。

```
sensor_type: BME280
#i2c_address:
#   Default is 118 (0x76). Some BME280 sensors have an address of 119
#   (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### HTU21D 感測器

HTU21D 系列雙線介面（I2C）環境感測器。注意，這種感測器不適用于擠出機和加熱床，它們可以用於監測環境溫度（C）和相對濕度。參見 [sample-macros.cfg](../config/sample-macros.cfg) 中可以報告溫度和濕度的 gcode_macro。

```
sensor_type:
#   Must be "HTU21D" , "SI7013", "SI7020", "SI7021" or "SHT21"
#i2c_address:
#   Default is 64 (0x40).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#htu21d_hold_master:
#   If the sensor can hold the I2C buf while reading. If True no other
#   bus communication can be performed while reading is in progress.
#   Default is False.
#htu21d_resolution:
#   The resolution of temperature and humidity reading.
#   Valid values are:
#    'TEMP14_HUM12' -> 14bit for Temp and 12bit for humidity
#    'TEMP13_HUM10' -> 13bit for Temp and 10bit for humidity
#    'TEMP12_HUM08' -> 12bit for Temp and 08bit for humidity
#    'TEMP11_HUM11' -> 11bit for Temp and 11bit for humidity
#   Default is: "TEMP11_HUM11"
#htu21d_report_time:
#   Interval in seconds between readings. Default is 30
```

### LM75 溫度感測器

LM75/LM75A 兩線 (I2C) 連接的溫度傳感器。這些傳感器的範圍為 -55~125 C，因此可用於例如室溫度監測。它們還可以用作簡單的風扇/加熱器控制器。

```
sensor_type: LM75
#i2c_address:
#   Default is 72 (0x48). Normal range is 72-79 (0x48-0x4F) and the 3
#   low bits of the address are configured via pins on the chip
#   (usually with jumpers or hard wired).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#lm75_report_time:
#   Interval in seconds between readings. Default is 0.8, with minimum
#   0.5.
```

### 微控制器的內建溫度感測器

atsam、atsamd 和 stm32 微控制器包含一個內部溫度傳感器。可以使用“temperature_mcu”傳感器來監控這些溫度。

```
sensor_type: temperature_mcu
#sensor_mcu: mcu
#   The micro-controller to read from. The default is "mcu".
#sensor_temperature1:
#sensor_adc1:
#   Specify the above two parameters (a temperature in Celsius and an
#   ADC value as a float between 0.0 and 1.0) to calibrate the
#   micro-controller temperature. This may improve the reported
#   temperature accuracy on some chips. A typical way to obtain this
#   calibration information is to completely remove power from the
#   printer for a few hours (to ensure it is at the ambient
#   temperature), then power it up and use the QUERY_ADC command to
#   obtain an ADC measurement. Use some other temperature sensor on
#   the printer to find the corresponding ambient temperature. The
#   default is to use the factory calibration data on the
#   micro-controller (if applicable) or the nominal values from the
#   micro-controller specification.
#sensor_temperature2:
#sensor_adc2:
#   If sensor_temperature1/sensor_adc1 is specified then one may also
#   specify sensor_temperature2/sensor_adc2 calibration data. Doing so
#   may provide calibrated "temperature slope" information. The
#   default is to use the factory calibration data on the
#   micro-controller (if applicable) or the nominal values from the
#   micro-controller specification.
```

### 主機溫度感測器

運行主機軟件的機器（例如 Raspberry Pi）的溫度。

```
sensor_type: temperature_host
#sensor_path:
#   The path to temperature system file. The default is
#   "/sys/class/thermal/thermal_zone0/temp" which is the temperature
#   system file on a Raspberry Pi computer.
```

### DS18B20 溫度感測器

DS18B20 是一個單匯流排 (1-wire (w1)) 數值溫度感測器。注意，這個感測器不是被設計用於熱端或熱床， 而是用於監測環境溫度(C)。這些感測器最高量程是125 C，因此可用於例如箱體溫度監測。它們也可以被當作簡單的風扇/加熱器控制器。DS18B20 感測器僅在「主機 mcu」上支援，例如樹莓派。w1-gpio Linux 內核模組必須被安裝。

```
sensor_type: DS18B20
serial_no:
#   Each 1-wire device has a unique serial number used to identify the device,
#   usually in the format 28-031674b175ff. This parameter must be provided.
#   Attached 1-wire devices can be listed using the following Linux command:
#   ls /sys/bus/w1/devices/
#ds18_report_time:
#   Interval in seconds between readings. Default is 3.0, with a minimum of 1.0
#sensor_mcu:
#   The micro-controller to read from. Must be the host_mcu
```

## 風扇

### [fan]

列印冷卻風扇。

```
[fan]
pin:
#   控制風扇的輸出引腳。
#   必須提供此參數。
#max_power: 1.0
#   引腳允許被設定的最大占空比（在0.0和1.0之間）。
#   1.0 允許引腳被長時間完全啟用，而0.5會只允許引腳只在一半的時間裡
#   被啟用。這個設定可以限制風扇的最大功率（平均功率）。如果這個值
#   小於 1.0 則風速請求會被縮放到 0 和 max_power 之間（例如，如果
#   max_power 是 0.9，請求 80% 風速速度會使風扇功率設為72%）。
#   預設為1.0。
#shutdown_speed: 0
#   在微控制器進入錯誤狀態時期望的（一個在0.0和1.0之間的值）
#   風扇速度。
#   預設為 0。
#cycle_time: 0.010
#   The amount of time (in seconds) for each PWM power cycle to the
#   fan. It is recommended this be 10 milliseconds or greater when
#   using software based PWM. The default is 0.010 seconds.
#hardware_pwm: False
#   Enable this to use hardware PWM instead of software PWM. Most fans
#   do not work well with hardware PWM, so it is not recommended to
#   enable this unless there is an electrical requirement to switch at
#   very high speeds. When using hardware PWM the actual cycle time is
#   constrained by the implementation and may be significantly
#   different than the requested cycle_time. The default is False.
#kick_start_time: 0.100
#   Time (in seconds) to run the fan at full speed when either first
#   enabling or increasing it by more than 50% (helps get the fan
#   spinning). The default is 0.100 seconds.
#off_below: 0.0
#   The minimum input speed which will power the fan (expressed as a
#   value from 0.0 to 1.0). When a speed lower than off_below is
#   requested the fan will instead be turned off. This setting may be
#   used to prevent fan stalls and to ensure kick starts are
#   effective. The default is 0.0.
#
#   This setting should be recalibrated whenever max_power is adjusted.
#   To calibrate this setting, start with off_below set to 0.0 and the
#   fan spinning. Gradually lower the fan speed to determine the lowest
#   input speed which reliably drives the fan without stalls. Set
#   off_below to the duty cycle corresponding to this value (for
#   example, 12% -> 0.12) or slightly higher.
#tachometer_pin:
#   Tachometer input pin for monitoring fan speed. A pullup is generally
#   required. This parameter is optional.
#tachometer_ppr: 2
#   When tachometer_pin is specified, this is the number of pulses per
#   revolution of the tachometer signal. For a BLDC fan this is
#   normally half the number of poles. The default is 2.
#tachometer_poll_interval: 0.0015
#   When tachometer_pin is specified, this is the polling period of the
#   tachometer pin, in seconds. The default is 0.0015, which is fast
#   enough for fans below 10000 RPM at 2 PPR. This must be smaller than
#   30/(tachometer_ppr*rpm), with some margin, where rpm is the
#   maximum speed (in RPM) of the fan.
```

### [heater_fan]

加熱器冷卻風扇（可以用"heater_fan"字首定義任意數量的分段）。"加熱器風扇"是一種當其關聯的加熱器活躍時會啟用的風扇。預設情況下，heater_fan shutdown_speed 等於 max_power。

```
[heater_fan my_nozzle_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#   以上參數詳見「fan」章節。
#heater: extruder
#   該風扇關聯的加熱器配置分段名稱。如果提供了一個逗號分隔的
#   加熱器列表，則風扇將會在任一加熱器被啟用時啟動。
#   預設為"extruder"。
#heater_temp: 50.0
#   風扇可以被禁用的最高加熱器溫度（以攝氏度為單位）。加熱器
#   必須被降低到該溫度以下風扇才會被禁用。
#   預設為 50 攝氏度。
#fan_speed: 1.0
#   當相關聯的加熱器活躍時該風扇的速度（在0.0和1.0之間）。
#   預設為 1.0
```

### [controller_fan]

控制器冷卻風扇（可以定義任意數量帶有"controller_fan"字首的分段）。"控制器風扇"(Controller fan)是一個只要關聯的加熱器或步進驅動程式處於活動狀態就會啟動的風扇。風扇會在空閑超時(idle_timeout)后停止，以確保被監視元件不再活躍后不會過熱。

```
[controller_fan my_controller_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#  以上參數請見「風扇」(fan)分段。
#fan_speed: 1.0
#   當一個加熱器或步進電機活躍時的風扇速度（以一個0.0到1.0
#   的數值表示）。
#   預設為 1.0。
#idle_timeout:
#   在步進電機或加熱器不再活躍后風扇持續執行的時間（以秒
#   為單位）。
#   預設為 30秒。
#idle_speed:
#   當一個加熱器或步進電機不再活躍，但沒有達到空閑超時(
#   idle_timeout)時的風扇速度（以一個0.0到1.0的數值表示）。
#   預設為 fan_speed。
#heater:
#stepper:
#   與這個風扇關聯的加熱器/步進驅動配置分段名稱。如果提
#   供一個逗號分隔的加熱器/步進驅動名稱，任意一個列表中
#   的裝置啟用時風扇將會啟動。
#   預設加熱器是「擠出機」（extruder)，預設步進驅動是全部步進驅動。
```

### [temperature_fan]

溫度觸發的冷卻風扇（可以定義任意數量的帶有“temperature_fan”前綴的部分）。 “溫度風扇”是一種風扇，只要其關聯的傳感器高於設定溫度，就會啟用該風扇。默認情況下，temperature_fan 的 shutdown_speed 等於 max_power。

有關更多信息，請參閱 [command reference](G-Codes.md#temperature_fan)。

```
[temperature_fan my_temp_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#   See the "fan" section for a description of the above parameters.
#sensor_type:
#sensor_pin:
#control:
#max_delta:
#min_temp:
#max_temp:
#   See the "extruder" section for a description of the above parameters.
#pid_Kp:
#pid_Ki:
#pid_Kd:
#   The proportional (pid_Kp), integral (pid_Ki), and derivative
#   (pid_Kd) settings for the PID feedback control system. Klipper
#   evaluates the PID settings with the following general formula:
#     fan_pwm = max_power - (Kp*e + Ki*integral(e) - Kd*derivative(e)) / 255
#   Where "e" is "target_temperature - measured_temperature" and
#   "fan_pwm" is the requested fan rate with 0.0 being full off and
#   1.0 being full on. The pid_Kp, pid_Ki, and pid_Kd parameters must
#   be provided when the PID control algorithm is enabled.
#pid_deriv_time: 2.0
#   A time value (in seconds) over which temperature measurements will
#   be smoothed when using the PID control algorithm. This may reduce
#   the impact of measurement noise. The default is 2 seconds.
#target_temp: 40.0
#   A temperature (in Celsius) that will be the target temperature.
#   The default is 40 degrees.
#max_speed: 1.0
#   The fan speed (expressed as a value from 0.0 to 1.0) that the fan
#   will be set to when the sensor temperature exceeds the set value.
#   The default is 1.0.
#min_speed: 0.3
#   The minimum fan speed (expressed as a value from 0.0 to 1.0) that
#   the fan will be set to for PID temperature fans.
#   The default is 0.3.
#gcode_id:
#   If set, the temperature will be reported in M105 queries using the
#   given id. The default is to not report the temperature via M105.
```

### [fan_generic]

手動控制的風扇（可以定義任意數量的帶有“fan_generic”前綴的部分）。手動控制風扇的速度使用 SET_FAN_SPEED [gcode 命令](G-Codes.md#fan_generic) 設置。

```
[fan_generic extruder_partfan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#   以上參數介紹請見「fan」（風扇）章節。
```

## LEDs

### [led]

Support for LEDs (and LED strips) controlled via micro-controller PWM pins (one may define any number of sections with an "led" prefix). See the [command reference](G-Codes.md#led) for more information.

```
[led my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
#   The pin controlling the given LED color. At least one of the above
#   parameters must be provided.
#cycle_time: 0.010
#   The amount of time (in seconds) per PWM cycle. It is recommended
#   this be 10 milliseconds or greater when using software based PWM.
#   The default is 0.010 seconds.
#hardware_pwm: False
#   Enable this to use hardware PWM instead of software PWM. When
#   using hardware PWM the actual cycle time is constrained by the
#   implementation and may be significantly different than the
#   requested cycle_time. The default is False.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Sets the initial LED color. Each value should be between 0.0 and
#   1.0. The default for each color is 0.
```

### [neopixel]

Neopixel (aka WS2812) LED support (one may define any number of sections with a "neopixel" prefix). See the [command reference](G-Codes.md#led) for more information.

Note that the [linux mcu](RPi_microcontroller.md) implementation does not currently support directly connected neopixels. The current design using the Linux kernel interface does not allow this scenario because the kernel GPIO interface is not fast enough to provide the required pulse rates.

```
[neopixel my_neopixel]
pin:
#   The pin connected to the neopixel. This parameter must be
#   provided.
#chain_count:
#   The number of Neopixel chips that are "daisy chained" to the
#   provided pin. The default is 1 (which indicates only a single
#   Neopixel is connected to the pin).
#color_order: GRB
#   Set the pixel order required by the LED hardware (using a string
#   containing the letters R, G, B, W with W optional). Alternatively,
#   this may be a comma separated list of pixel orders - one for each
#   LED in the chain. The default is GRB.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

### [dotstar]

Dotstar (aka APA102) LED support (one may define any number of sections with a "dotstar" prefix). See the [command reference](G-Codes.md#led) for more information.

```
[dotstar my_dotstar]
data_pin:
#   The pin connected to the data line of the dotstar. This parameter
#   must be provided.
clock_pin:
#   The pin connected to the clock line of the dotstar. This parameter
#   must be provided.
#chain_count:
#   See the "neopixel" section for information on this parameter.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#   See the "led" section for information on these parameters.
```

### [pca9533]

PCA9533 LED支援。PCA9533 在 mightyboard上出現。

```
[pca9533 my_pca9533]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. Use 98 for
#   the PCA9533/1, 99 for the PCA9533/2. The default is 98.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

### [pca9632]

PCA9632 LED support. The PCA9632 is used on the FlashForge Dreamer.

```
[pca9632 my_pca9632]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. This may be
#   96, 97, 98, or 99.  The default is 98.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#scl_pin:
#sda_pin:
#   Alternatively, if the pca9632 is not connected to a hardware I2C
#   bus, then one may specify the "clock" (scl_pin) and "data"
#   (sda_pin) pins. The default is to use hardware I2C.
#color_order: RGBW
#   Set the pixel order of the LED (using a string containing the
#   letters R, G, B, W). The default is RGBW.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

## Additional servos, buttons, and other pins

### [servo]

伺服（可以定義任意數量的帶有“伺服”前綴的部分）。可以使用 SET_SERVO [g-code command](G-Codes.md#servo) 控制舵機。例如：SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
pin:
#   PWM output pin controlling the servo. This parameter must be
#   provided.
#maximum_servo_angle: 180
#   The maximum angle (in degrees) that this servo can be set to. The
#   default is 180 degrees.
#minimum_pulse_width: 0.001
#   The minimum pulse width time (in seconds). This should correspond
#   with an angle of 0 degrees. The default is 0.001 seconds.
#maximum_pulse_width: 0.002
#   The maximum pulse width time (in seconds). This should correspond
#   with an angle of maximum_servo_angle. The default is 0.002
#   seconds.
#initial_angle:
#   Initial angle (in degrees) to set the servo to. The default is to
#   not send any signal at startup.
#initial_pulse_width:
#   Initial pulse width time (in seconds) to set the servo to. (This
#   is only valid if initial_angle is not set.) The default is to not
#   send any signal at startup.
```

### [gcode_button]

在一個按鈕被按下或放開（或當一個引腳狀態發生變化時）時執行G程式碼。你可以使用 `QUERY_BUTTON button=my_gcode_button` 來查詢按鈕的狀態。

```
[gcode_button my_gcode_button]
pin:
#   連線到按鈕的引腳。
#   必須提供此參數。
#analog_range:
#   兩個逗號分隔的阻值(單位：歐姆)，指定了按鈕的最小和最大電阻。
#   如果提供了 analog_range ，必須使用一個模擬功能的引腳。預設
#   情況下為按鈕使用數字GPIO。
#   analog_pullup_resistor:
#   當定義 analog_range 時的上拉電阻(歐姆)。預設為4700歐姆。
#press_gcode:
#   當按鈕被按下時要執行的 G-Code 命令序列，支援G-Code模板。
#   必須提供此參數。
#release_gcode:
#   當按鈕被釋放時要執行的G-Code命令序列，支援G-Code模板。
#   預設在按鈕釋放時不執行任何命令。
```

### [output_pin]

運行時可配置的輸出引腳（可以使用“output_pin”前綴定義任意數量的部分）。此處配置的引腳將設置為輸出引腳，並且可以在運行時使用“SET_PIN PIN=my_pin VALUE=.1”類型擴展 [g-code commands](G-Codes.md#output_pin) 修改它們。

```
[output_pin my_pin]
pin:
#   The pin to configure as an output. This parameter must be
#   provided.
#pwm: False
#   Set if the output pin should be capable of pulse-width-modulation.
#   If this is true, the value fields should be between 0 and 1; if it
#   is false the value fields should be either 0 or 1. The default is
#   False.
#static_value:
#   If this is set, then the pin is assigned to this value at startup
#   and the pin can not be changed during runtime. A static pin uses
#   slightly less ram in the micro-controller. The default is to use
#   runtime configuration of pins.
#value:
#   The value to initially set the pin to during MCU configuration.
#   The default is 0 (for low voltage).
#shutdown_value:
#   The value to set the pin to on an MCU shutdown event. The default
#   is 0 (for low voltage).
#maximum_mcu_duration:
#   The maximum duration a non-shutdown value may be driven by the MCU
#   without an acknowledge from the host.
#   If host can not keep up with an update, the MCU will shutdown
#   and set all pins to their respective shutdown values.
#   Default: 0 (disabled)
#   Usual values are around 5 seconds.
#cycle_time: 0.100
#   The amount of time (in seconds) per PWM cycle. It is recommended
#   this be 10 milliseconds or greater when using software based PWM.
#   The default is 0.100 seconds for pwm pins.
#hardware_pwm: False
#   Enable this to use hardware PWM instead of software PWM. When
#   using hardware PWM the actual cycle time is constrained by the
#   implementation and may be significantly different than the
#   requested cycle_time. The default is False.
#scale:
#   This parameter can be used to alter how the 'value' and
#   'shutdown_value' parameters are interpreted for pwm pins. If
#   provided, then the 'value' parameter should be between 0.0 and
#   'scale'. This may be useful when configuring a PWM pin that
#   controls a stepper voltage reference. The 'scale' can be set to
#   the equivalent stepper amperage if the PWM were fully enabled, and
#   then the 'value' parameter can be specified using the desired
#   amperage for the stepper. The default is to not scale the 'value'
#   parameter.
```

### [static_digital_output]

靜態配置的數字輸出引腳（可以使用“static_digital_output”前綴定義任意數量的部分）。此處配置的引腳將在 MCU 配置期間設置為 GPIO 輸出。它們不能在運行時更改。

```
[static_digital_output my_output_pins]
pins:
#   A comma separated list of pins to be set as GPIO output pins. The
#   pin will be set to a high level unless the pin name is prefaced
#   with "!". This parameter must be provided.
```

### [multi_pin]

多個引腳輸出（可以定義任意數量的帶有“multi_pin”前綴的部分）。 multi_pin 輸出會創建一個內部引腳別名，每次設置別名引腳時可以修改多個輸出引腳。例如，可以定義一個包含兩個引腳的“[multi_pin my_fan]”對象，然後在“[fan]”部分設置“pin=multi_pin:my_fan”——在每次風扇更改時，兩個輸出引腳都會更新。這些別名可能不適用於步進電機引腳。

```
[multi_pin my_multi_pin]
pins:
#   與此別名關聯的引腳的逗號分隔列表。
#   必須提供此參數。
```

## TMC 步進驅動器配置

在 UART/SPI 模式下配置 Trinamic 步進電機驅動器。其他信息在 [TMC Drivers guide](TMC_Drivers.md) 和 [command reference](G-Codes.md#tmcxxxx) 中。

### [tmc2130]

通過 SPI 匯流排配置 TMC2130 步進電機驅動。要使用此功能，請定義一個帶有「tmc2130」字首並後跟步進驅動配置分段相應名稱的配置分段（例如，「[tmc2130 stepper_x]」）。

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
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 0
#driver_TBL: 1
#driver_TOFF: 4
#driver_HEND: 7
#driver_HSTRT: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 4
#driver_PWM_AMPL: 128
#driver_SGT: 0
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

通過單線 UART 配置 TMC2208（或 TMC2224）步進電機驅動。要使用此功能，請定義一個帶有 「tmc2208」 字首並後跟步進驅動配置分段相應名稱的配置分段（例如，「[tmc2208 stepper_x]」）。

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
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
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
#   Set the given register during the configuration of the TMC2208
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
```

### [tmc2209]

通過單線 UART 配置 TMC2209 步進電機驅動。要使用此功能，請定義一個帶有 「tmc2209」 字首並後跟步進驅動配置分段相應名稱的配置分段（例如，「[tmc2209 stepper_x]」）。

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
#uart_address:
#   The address of the TMC2209 chip for UART messages (an integer
#   between 0 and 3). This is typically used when multiple TMC2209
#   chips are connected to the same UART pin. The default is zero.
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
#driver_SGTHRS: 0
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

通過 SPI 匯流排配置 TMC2660 步進電機驅動。要使用此功能，請定義一個帶有 「tmc 2660」 字首並後跟步進驅動配置分段相應名稱的配置分段（例如，「[tmc2660 stepper_x]」）。

```
[tmc2660 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2660 chip select line. This pin
#   will be set to low at the start of SPI messages and set to high
#   after the message transfer completes. This parameter must be
#   provided.
#spi_speed: 4000000
#   SPI bus frequency used to communicate with the TMC2660 stepper
#   driver. The default is 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This only works if microsteps
#   is set to 16. Interpolation does introduce a small systemic
#   positional deviation - see TMC_Drivers.md for details. The default
#   is True.
run_current:
#   The amount of current (in amps RMS) used by the driver during
#   stepper movement. This parameter must be provided.
#sense_resistor:
#   The resistance (in ohms) of the motor sense resistor. This
#   parameter must be provided.
#idle_current_percent: 100
#   The percentage of the run_current the stepper driver will be
#   lowered to when the idle timeout expires (you need to set up the
#   timeout using a [idle_timeout] config section). The current will
#   be raised again once the stepper has to move again. Make sure to
#   set this to a high enough value such that the steppers do not lose
#   their position. There is also small delay until the current is
#   raised again, so take this into account when commanding fast moves
#   while the stepper is idling. The default is 100 (no reduction).
#driver_TBL: 2
#driver_RNDTF: 0
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
#driver_TS2G: 3
#   Set the given parameter during the configuration of the TMC2660
#   chip. This may be used to set custom driver parameters. The
#   defaults for each parameter are next to the parameter name in the
#   list above. See the TMC2660 datasheet about what each parameter
#   does and what the restrictions on parameter combinations are. Be
#   especially aware of the CHOPCONF register, where setting CHM to
#   either zero or one will lead to layout changes (the first bit of
#   HDEC) is interpreted as the MSB of HSTRT in this case).
```

### [tmc5160]

通過 SPI 匯流排配置 TMC5160 步進電機驅動。要使用此功能，請定義一個帶有 「tmc5160」 字首並後跟步進驅動配置分段相應名稱的配置分段（例如，「[tmc5160 stepper_x]」）。

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
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
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

## 運行時步進電機電流配置

### [ad5206]

通過 SPI 總線連接的靜態配置 AD5206 數字電位器（可以定義任意數量的帶有“ad5206”前綴的部分）。

```
[ad5206 my_digipot]
enable_pin:
#   對應AD5206 晶片選擇(chip select)線路的引腳。這個引腳將
#   在 SPI 訊息開始時拉低，並在訊息結束后拉高。必須提供
#   這個參數。
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   以上參數的定義請檢視 "常規 SPI 設定" 章節
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
#   設定AD5206通道的靜態值。通常在0.0和1.0之間，1.0為最高
#   電阻，而0.0為最低電阻。然而，這個範圍也可以被 『scale』 參
#   數配置。（見下文）如果一個通道沒有參數則它不會被配置。
#scale:
#   這個參數可以用來修改 『channel_x』 參數的定義。如被提供，
#   則 『channel_x』 的範圍會在 0.0 和 『scale』 之間。在 AD5206 被作
#   為步進電機參考電壓時可能很有幫助。當AD5206在最高電阻時
#   『scale』 可以被設定為步進電機的電流， 然後 『channel_x』 參數可
#   以設定為步進電機的期望電流安培。預設為不對 'channel_x' 參
#   數進行縮放。
```

### [mcp4451]

通過 I2C 總線連接的靜態配置 MCP4451 數字電位器（可以定義任意數量的帶有“mcp4451”前綴的部分）。

```
[mcp4451 my_digipot]
i2c_address:
#   The i2c address that the chip is using on the i2c bus. This
#   parameter must be provided.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#wiper_0:
#wiper_1:
#wiper_2:
#wiper_3:
#   The value to statically set the given MCP4451 "wiper" to. This is
#   typically set to a number between 0.0 and 1.0 with 1.0 being the
#   highest resistance and 0.0 being the lowest resistance. However,
#   the range may be changed with the 'scale' parameter (see below).
#   If a wiper is not specified then it is left unconfigured.
#scale:
#   This parameter can be used to alter how the 'wiper_x' parameters
#   are interpreted. If provided, then the 'wiper_x' parameters should
#   be between 0.0 and 'scale'. This may be useful when the MCP4451 is
#   used to set stepper voltage references. The 'scale' can be set to
#   the equivalent stepper amperage if the MCP4451 were at its highest
#   resistance, and then the 'wiper_x' parameters can be specified
#   using the desired amperage value for the stepper. The default is
#   to not scale the 'wiper_x' parameters.
```

### [mcp4728]

通過 I2C 總線連接的靜態配置的 MCP4728 數模轉換器（可以使用“mcp4728”前綴定義任意數量的部分）。

```
[mcp4728 my_dac]
#i2c_address: 96
#   The i2c address that the chip is using on the i2c bus. The default
#   is 96.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#channel_a:
#channel_b:
#channel_c:
#channel_d:
#   The value to statically set the given MCP4728 channel to. This is
#   typically set to a number between 0.0 and 1.0 with 1.0 being the
#   highest voltage (2.048V) and 0.0 being the lowest voltage.
#   However, the range may be changed with the 'scale' parameter (see
#   below). If a channel is not specified then it is left
#   unconfigured.
#scale:
#   This parameter can be used to alter how the 'channel_x' parameters
#   are interpreted. If provided, then the 'channel_x' parameters
#   should be between 0.0 and 'scale'. This may be useful when the
#   MCP4728 is used to set stepper voltage references. The 'scale' can
#   be set to the equivalent stepper amperage if the MCP4728 were at
#   its highest voltage (2.048V), and then the 'channel_x' parameters
#   can be specified using the desired amperage value for the
#   stepper. The default is to not scale the 'channel_x' parameters.
```

### [mcp4018]

靜態配置的 MCP4018 數字電位器通過兩個 gpio“bit banging”引腳連接（可以定義任意數量的帶有“mcp4018”前綴的部分）。

```
[mcp4018 my_digipot]
scl_pin:
#   SCL "時鐘"引腳。
#   必須提供此參數。
sda_pin:
#   SCL "數據"引腳。
#   必須提供此參數。
wiper:
#   The value to statically set the given MCP4018 "wiper" to. This is
#   typically set to a number between 0.0 and 1.0 with 1.0 being the
#   highest resistance and 0.0 being the lowest resistance. However,
#   the range may be changed with the 'scale' parameter (see below).
#   This parameter must be provided.
#scale:
#   This parameter can be used to alter how the 'wiper' parameter is
#   interpreted. If provided, then the 'wiper' parameter should be
#   between 0.0 and 'scale'. This may be useful when the MCP4018 is
#   used to set stepper voltage references. The 'scale' can be set to
#   the equivalent stepper amperage if the MCP4018 is at its highest
#   resistance, and then the 'wiper' parameter can be specified using
#   the desired amperage value for the stepper. The default is to not
#   scale the 'wiper' parameter.
```

## 顯示屏支援

### [display]

支持連接到微控制器的顯示屏。

```
[display]
lcd_type:
#   使用的 LCD 晶片型別。這可以是「hd44780」、「hd44780_spi」、
#   「st7920」、「emulated_st7920」、「uc1701」、「ssd1306」、或「sh1106」。
#   有關不同的LCD晶片型別和它們特有的參數，請檢視下面的顯示屏分段。
#   必須提供此參數。
#display_group:
#   顯示在這個顯示屏上的 display_data 組。它決定了這個螢幕顯示
#   的內容（詳見「display_data」分段）。
#   hd44780 預設使用 _default_20x4，其他顯示屏則預設使用 _default_16x4。
#menu_timeout:
#   菜單超時時間。在不活躍給定時間后將會退出菜單或在 autorun 啟用時
#   回到根菜單。
#   預設為 0 秒（禁用）。
#menu_root:
#   在主螢幕按下編碼器時顯示的主菜單段名稱。
#   預設為 __main，這會顯示在 klippy/extras/display/menu.cfg中定義的主菜單。
#menu_reverse_navigation:
#   啟用時反轉上滾動和下滾動。
#   預設為False。這是一個可選參數。
#encoder_pins:
#   連線到編碼器的引腳。使用編碼器時必須提供兩個引腳。
#   使用菜單時必須提供此參數。
#encoder_steps_per_detent:
#   編碼器在每一個凹陷處（"click"）發出多少步。如果編碼器需要轉過兩個凹
#   陷才能在條目之間移動，或者轉過一個凹痕會在兩個詞條之間移動/跳過
#   一個詞條，可以嘗試改變這個值。
#   允許的值是2 （半步）或 4（全步）。
#   預設為 4。
#click_pin:
#   連線到 "enter" 按鈕或編碼器按壓的引腳。
#   使用菜單時必須提供此參數。
#   如果定義了 「analog_range_click_pin」配置參數，則這個參數的引腳需要
#   是模擬引腳。
#back_pin:
#   連線到「back」按鈕的引腳。這是一個可選參數，菜單不需要這個按鈕。
#   如果定義了 「analog_range_back_pin」配置參數，則這個參數的引腳需要
#   是模擬引腳。
#up_pin:
#   連線到「up」按鈕的引腳。在不使用編碼器時使用菜單必須提供這個參數。
#   如果定義了 「analog_range_up_pin」配置參數，則這個參數的引腳需要
#   是模擬引腳。
#down_pin:
#   連線到「down」按鈕的引腳。 在不使用編碼器時使用菜單必須提供這個參數。
#   如果定義了 「analog_range_down_pin」配置參數，則這個參數的引腳需要
#   是模擬引腳。
#kill_pin:
#   連線到「kill」按鈕的引腳。 這個按鈕將會觸發緊急停止。
#   如果定義了 「analog_range_kill_pin」配置參數，則這個參數的引腳需要
#   是模擬引腳。
#analog_pullup_resistor: 4700
#   連線到模擬按鈕的拉高電阻阻值(ohms)
#   預設為 4700 ohms。
#analog_range_click_pin:
#   'enter'按鈕的阻值範圍。
#   在使用模擬按鈕時必須提供由逗號分隔最小和最大值。
#analog_range_back_pin:
#   'back'按鈕的阻值範圍。
#   在使用模擬按鈕時必須提供由逗號分隔最小和最大值。
#analog_range_up_pin:
#   'up'按鈕的阻值範圍。
#   在使用模擬按鈕時必須提供由逗號分隔最小和最大值。
#analog_range_down_pin:
#   'down'按鈕的阻值範圍。
#   在使用模擬按鈕時必須提供由逗號分隔最小和最大值。
#analog_range_kill_pin:
#   'kill'按鈕的阻值範圍。
#   在使用模擬按鈕時必須提供由逗號分隔最小和最大值。
```

#### hd44780顯示屏

有關配置 hd44780 顯示屏（在"RepRapDiscount 2004 Smart Controller"型別顯示屏中可以找到）的資訊。

```
[display]
lcd_type: hd44780
#   對於hd44780顯示屏，填寫 "hd44780"。
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#   連線到hd44780 類LCD的引腳。
#   必須提供這些參數
#hd44780_protocol_init: True
#   在一個 hd44780 顯示屏上執行 8-bit/4-bit 協議初始化。對於所有
#   正版的 hd44780 裝置，這是必須的。但是，在一些克隆的裝置上
#   可能需要禁用。
#   預設為True（啟用）。
#line_length:
#   設定 hd44780 類LCD 每行顯示的字元數。可能的數值有20（預設）
#   和16。行數被鎖定為4行。
...
```

#### hd44780_spi顯示屏

有關配置 hd44780_spi 顯示屏的資訊 - 通過硬體"移位暫存器"（用於基於 mightyboard 的印表機）控制的20x04顯示屏。

```
[display]
lcd_type: hd44780_spi
#   對於hd44780_spi 顯示屏，設定為「hd44780_spi」。
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   控制顯示屏的移位暫存器的引腳。由於位移暫存器沒有 MISO 引
#   腳，但是軟體 SPI 實現需要這個引腳被配置，
#   spi_software_miso_pin 需要被設定為一個印表機主板上未被使
#   用的引腳。
#hd44780_protocol_init: True
#   在 hd44780 顯示屏上執行 8-bit/4-bit 協議初始化。正版的
#   hd44780 裝置必須執行此操作，但是某些克隆裝置上可能需要
#   禁用。
#   預設為True（啟用）。
#line_length:
#   設定一個 hd44780 類 LCD 每行顯示的字元數量。可能的值為20
#   （預設）和 16。行數固定為4。
...
```

#### st7920 顯示屏

有關配置 st7920 類顯示屏的資訊（可用於 "RepRapDiscount 12864 Full Graphic Smart Controller" 型別的顯示屏）。

```
[display]
lcd_type: st7920
#   為st7920顯示屏設定為 "st7920"。
cs_pin:
sclk_pin:
sid_pin:
#   連線到 st7920 類LCD的引腳。
#   這些參數必須被提供。
...
```

#### emulated_st7920（模擬ST7920）顯示屏

有關配置模擬 st7920 顯示屏的資訊 —它可以在一些"2.4 寸觸控式螢幕"和其他類似裝置中找到。

```
[display]
lcd_type: emulated_st7920
#   對於 emulated_st7920 顯示屏，設定為"emulated_st7920"。
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   連線到 emulated_st7920 類LCD的引腳。 en_pin 對應
#   st7920 類LCD的 cs_pin。spi_software_sclk_pin 對應 sclk_pin，
#   還有 spi_software_mosi_pin 對應 sid_pin。由於軟體SPI實現
#   的方式，雖然 ST7920 不使用 MISO 引腳， 依舊需要將
#   spi_software_miso_pin設為一個印表機控制板上一個沒有被
#   使用的引腳。
...
```

#### uc1701顯示屏

有關配置 uc1701 顯示屏的資訊（用於「MKS Mini 12864」型顯示屏）。

```
[display]
lcd_type: uc1701
#   uc1701 顯示屏應設為"uc1701"。
cs_pin:
a0_pin:
#   連線到 uc1701 類LCD的引腳。
#   必須提供這些參數。
#rst_pin:
#   連線到 LCD "rst" 的引腳。 如果沒有定義，則硬體必須在LCD
#   相應的線路上帶一個LCD引腳。
#contrast:
#   顯示屏的對比度。必須在0和63之間。
#   預設為40。
...
```

#### ssd1306 和 sh1106 顯示屏

ssd1306 和 sh1106 顯示屏的配置資訊.

```
[display]
lcd_type:
#   對於給定的顯示屏型別，設定為 「ssd1306" 或 "sh1106"。
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   連線到I2C匯流排的顯示屏的可選參數， 以上參數詳見通
#   用 I2C 設定章節。
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   使用4線 SPI 模式時連線到 lcd 的引腳。以 "spi_" 開頭的
#   參數詳見 「通用 SPI 設定」 章節。
#   顯示屏預設使用 I2C 模式
#reset_pin:
#   可以指定一個顯示屏上的重置引腳，如果不指定，硬體
#   必須在相應的 lcd 線路上有一個拉高電阻。
#contrast:
#   可設定的對比度。
#   數值必須在 0 和 256 之間，預設為 239。
#vcomh: 0
#   設定顯示屏的 Vcomh 值。這個值與一些OLED顯示屏的
#   模糊效果有關。這個數值可以在 0 和 63 之間。
#   預設為0。
#invert: False
#   TRUE 可以在一些OLED顯示屏上反轉畫素
#   預設為 False。
#x_offset: 0
#   設定在 SH1106 顯示屏上的水平偏移。
#   預設為0。
...
```

### [display_data]

支持在液晶屏上顯示自定義數據。可以在這些組下創建任意數量的顯示組和任意數量的數據項。如果 [display] 部分中的 display_group 選項設置為給定組名稱，則顯示將顯示給定組的所有數據項。

一套[預設顯示組](../klippy/extras/display/display.cfg)將被自動建立。通過覆蓋印表機的 printer.cfg 主配置檔案中的預設值可以替換或擴充套件這些 display_data 項。

```
[display_data my_group_name my_data_name]
position:
#   用於顯示資訊的螢幕位置，由逗號分隔行與列表示。
#   這個參數必須被提供。
text:
#   在指定位置顯示的文字。本欄位必須用命令樣板進行評估。
#   （檢視 docs/Command_Templates.md）。
#   這個參數必須被提供。
```

### [display_template]

Display data text "macros" (one may define any number of sections with a display_template prefix). See the [command templates](Command_Templates.md) document for information on template evaluation.

This feature allows one to reduce repetitive definitions in display_data sections. One may use the builtin `render()` function in display_data sections to evaluate a template. For example, if one were to define `[display_template my_template]` then one could use `{ render('my_template') }` in a display_data section.

This feature can also be used for continuous LED updates using the [SET_LED_TEMPLATE](G-Codes.md#set_led_template) command.

```
[display_template my_template_name]
#param_<name>:
#   One may specify any number of options with a "param_" prefix. The
#   given name will be assigned the given value (parsed as a Python
#   literal) and will be available during macro expansion. If the
#   parameter is passed in the call to render() then that value will
#   be used during macro expansion. For example, a config with
#   "param_speed = 75" might have a caller with
#   "render('my_template_name', param_speed=80)". Parameter names may
#   not use upper case characters.
text:
#   The text to return when the this template is rendered. This field
#   is evaluated using command templates (see
#   docs/Command_Templates.md). This parameter must be provided.
```

### [display_glyph]

在支援自定義字形的顯示屏上顯示一個自定義字形。給定的名稱將被分配給給定的顯示數據，然後可以在顯示模板中通過用「波浪形（～）」符號包圍的名稱來引用，即 `~my_display_glyph~`

有關一些示例，請參閱 [sample-glyphs.cfg](../config/sample-glyphs.cfg)。

```
[display_glyph my_display_glyph]
#data:
#   被儲存為16 行，每行 16 位（1位代表1個畫素）的顯示數據。「.」是一個
#   空白的畫素，而『*』是一個開啟的畫素（例如，"****************"
#   可以用來顯示一條橫向的實線。除此以外，也可以用「0」作為空
#   白的畫素，而『1』作為開啟的畫素。需要將每個顯示的行放到配置檔案
#   中獨立的一行。每個字形都必須包含且僅包含 16 行，每行 16 位。
#   這是一個可選參數。
#hd44780_data:
#   用於 20x4 hd44780 顯示屏的字形。字形必須包含且僅包含 8 行，
#   每行 5 位。
#   這是一個可選參數。
#hd44780_slot:
#   用於儲存字形的 hd44780 硬體索引（0..7）。如果多個獨特的圖片使用
#   了相同的索引位置，需要保證在任何螢幕上只使用其中一個圖片。
#   如果定義了 hd44780_data ，則必須提供此參數。
```

### [display my_extra_display]

如果如上所示在 printer.cfg 中定義了主要的 [display] 分段，還可以定義多個輔助顯示屏。注意，輔助顯示屏目前不支援菜單功能，因此它們不支援「menu」選項或按鈕配置。

```
[display my_extra_display] 。
#   可用參數參見 "顯示 "分段。
```

### [menu]

可自定義液晶顯示屏菜單。

一套[預設菜單](../klippy/extras/display/menu.cfg)將被自動建立。通過覆蓋 printer.cfg 主配置檔案中的預設值可以替換或擴充套件該菜單。

有關模板呈現期間可用的菜單屬性的信息，請參閱 [command template document](Command_Templates.md#menu-templates)。

```
# 所有的菜單配置分段都有的通用參數。
#[menu __some_list __some_name]
#type: disabled
#   永久禁用這個菜單元素，唯一需要的屬性是 "型別"。
#   允許你簡單啊的禁用/隱藏現有的菜單專案。
#[menu some_name]
#type:
#   command（命令）, input（輸入）, list（列表）, text（文字）之一：
#       command - 可以觸發各種指令碼的基本菜單元素。
#       input   - 類似 「command」 但是可以修改數值。
#                 點選來進入/退出修改模式。
#       list    - 這允許菜單項被組織成一個可滾動的列表。通過建立由 "some_list"
#                 開頭的菜單配置 - 例如：[menu some_list some_item_in_the_list]
#       vsdlist - 和「list」一樣，但是會自動從虛擬SD卡中新增檔案。
#                 （將在未來被移除）
#name:
#   菜單項的名稱 - 被視為模板
#enable:
#   視為 True 或 False 的模板。
#index:
#   專案插入到列表的位置。
#   預設新增到結尾。

#[menu some_list]
#type: list
#name:
#enable:
#   見上文對這些參數的描述。

#[menu some_list some_command]
#type: command
#name:
#enable:
#   見上文對這些參數的描述。
#gcode:
#   點選按鈕或長按時執行的G程式碼指令碼。被視為模板。
#[menu some_list some_input]
#type: input
#name:
#enable:
#   見上文對這些參數的描述。
#input:
#   用於修改的初始數值 - 被視為模板。
#   結果必須為浮點數。
#input_min:
#   範圍的最小值 - 被視為模板。預設-99999。
#input_max:
#   範圍的最大值 - 被視為模板。 預設-99999。
#input_step:
#   修改的步長 - 必須是一個正整數或浮點數。它有內建快進
#   步長。當"(input_max - input_min) /
#   input_step > 100" 時，快進步長是 10 * input_step， 否則
#   步長和 input_step 相同。
#realtime:
#   此屬性接受靜態布爾值。 在啟用時，G程式碼指令碼將會在每
#   次數值變化時執行。
#   預設為False（否）。
#gcode:
#   點選按鈕、長按或數值變化時執行的G程式碼指令碼。
#   被視為模板。點選按鈕會進入或退出修改模式。
```

## 耗材感測器

### [filament_switch_sensor]

耗材開關感測器。支援使用開關感測器（如限位開關）進行耗材插入和耗盡檢測。

有關詳細信息，請參閱 [命令參考](G-Codes.md#filament_switch_sensor)。

```
[filament_switch_sensor my_sensor]。
#pause_on_runout: True
#   當設定為 "True "時，會在檢測到耗盡后立即暫停印表機。
#   請注意, 如果 pause_on_runout 為 False 並且沒有定義。
#   runout_gcode的話, 耗盡檢測將被禁用。
#   預設為 True。
#runout_gcode:
#   在檢測到耗材耗盡後會執行的G程式碼命令列表。
#   有關G-Code 格式請見 docs/Command_Templates.md。
#   如果 pause_on_runout 被設定為 True，這個G-Code將在
#   暫停后執行。
#   預設情況是不執行任何 G-Code 命令。
#insert_gcode:
#   在檢測到耗材插入後會執行的 G-Code 命令列表。
#   關於G程式碼格式，請參見 docs/Command_Templates.md。
#   預設不執行任何 G-Code 命令，這將禁用耗材插入檢測。
#event_delay: 3.0
#   事件之間的最小延遲時間（秒）。
#   在這個時間段內觸發的事件將被默許忽略。
#   預設為3秒。
#pause_delay: 0.5
#   暫停命令和執行 runout_gcode 之間的延遲時間, 單位是秒。
#   如果在OctoPrint的情況下，增加這個延遲可能改善暫
#   停的可靠性。如果OctoPrint表現出奇怪的暫停行為，
#   考慮增加這個延遲。
#   預設為0.5秒。
#switch_pin:
#   連線到檢測開關的引腳。
#   必須提供此參數。
```

### [filament_motion_sensor]

耗材移動感測器。使用一個在耗材通過感測器時輸出引腳狀態會發生變化來檢測耗材插入和耗盡。

有關詳細信息，請參閱 [命令參考](G-Codes.md#filament_switch_sensor)。

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#   觸發感測器 switch_pin 引腳狀態變化的最小距離。
#   預設為 7 mm。
extruder:
#   該感測器相關聯的擠出機。
#   必須提供此參數。
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   以上參數詳見「filament_switch_sensor」章節。
```

### [tsl1401cl_filament_width_sensor]

基於 TSLl401CL 的印絲寬度傳感器。有關詳細信息，請參閱 [guide](TSL1401CL_Filament_Width_Sensor.md)。

```
[tsl1401cl_filament_width_sensor]
#pin:
#default_nominal_filament_diameter: 1.75 # (mm)
#   Maximum allowed filament diameter difference as mm.
#max_difference: 0.2
#   The distance from sensor to the melting chamber as mm.
#measurement_delay: 100
```

### [hall_filament_width_sensor]

霍爾耗材寬度感測器（詳見[霍爾耗材寬度感測器](Hall_Filament_Width_Sensor.md)）。

```
[hall_filament_width_sensor]
adc1:
adc2:
#   連線到感測器的模擬輸入引腳。
#   必須提供這些參數。
#cal_dia1: 1.50
#cal_dia2: 2.00
#   感測器的校準值（單位：毫米）。
#   預設 cal_dia1 為1.50，cal_dia2 為 2.00。
#raw_dia1: 9500
#raw_dia2: 10500
#   感測器的原始校準值。預設raw_dial1 為 9500
#   而 raw_dia2 為 10500。
#default_nominal_filament_diameter: 1.75
#   標稱耗材直徑。
#   必須提供此參數。
#max_difference: 0.200
#   允許的耗材最大直徑差異，單位是毫米（mm）。
#   如果耗材標稱直徑和感測器輸出之間的差異
#   超過正負 max_difference，擠出倍數將被設回
#   到100%。
#   預設為0.200。
#measurement_delay: 70
#   從感測器到熔腔/熱端的距離，單位是毫米 (mm)。
#   感測器和熱端之間的耗材將被視為標稱直徑。主機
#   模組採用先進先出的邏輯工作。它將每個感測器的值和
#   位置在一個陣列中，並會在正確的位置使用感測器值。
#   必須提供這個參數。
#enable:False
#   感測器在開機后啟用或禁用。
#   預設是 False。
#measurement_interval: 10
#   感測器讀數之間的近似距離(mm)。
#   預設為10mm。
#logging:False
#   輸出直徑到終端和 klipper.log，可以通過命令啟用或禁用。
#min_diameter: 1.0
#   觸發虛擬 filament_switch_sensor 的最小直徑。
#use_current_dia_while_delay: False
#   在未被測量的 measurement_delay 部分耗材使用目前耗材
#   感測器報告的直徑而不是標稱直徑。
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   關於上述參數的描述請參見"filament_switch_sensor"章節。
```

## 控制板特定硬體支援

### [sx1509]

將一個 SX1509 I2C 配置為 GPIO 擴充套件器。由於 I2C 通訊本身的延遲，不應將 SX1509 引腳用作步進電機的 enable （啟用)、step（步進）或 dir （方向）引腳或任何其他需要快速 bit-banging（位拆裂）的引腳。它們最適合用作靜態或G程式碼控制的數字輸出或硬體 pwm 引腳，例如風扇。可以使用「sx1509」字首定義任意數量的分段。每個擴充套件器提供可用於印表機配置的一組 16 個引腳（sx1509_my_sx1509:PIN_0 到 sx1509_my_sx1509:PIN_15）。

有關示例，請參見 [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg) 文件。

```
[sx1509 my_sx1509]
i2c_地址：
# 此擴展器使用的 I2C 地址。取決於硬件
# 跳線 這是以下地址之一：62 63 112
# 113. 必須提供此參數。
#i2c_mcu:
#i2c_bus：
#i2c_speed:
# 請參閱“常用 I2C 設置”部分了解
# 以上參數。
#i2c_bus：
# 如果你的微控制器的 I2C 實現支持
# 多個 I2C 總線，您可以在此處指定總線名稱。這
# 默認是使用默認的微控制器 i2c 總線。
```

### [samd_sercom]

SAMD SERCOM 配置以指定在給定 SERCOM 上使用哪些引腳。可以使用“samd_sercom”前綴定義任意數量的部分。在將每個 SERCOM 用作 SPI 或 I2C 外設之前，必須對其進行配置。將此配置部分放在使用 SPI 或 I2C 總線的任何其他部分之上。

```
[samd_sercom my_sercom]
sercom:
#   The name of the sercom bus to configure in the micro-controller.
#   Available names are "sercom0", "sercom1", etc.. This parameter
#   must be provided.
tx_pin:
#   MOSI pin for SPI communication, or SDA (data) pin for I2C
#   communication. The pin must have a valid pinmux configuration
#   for the given SERCOM peripheral. This parameter must be provided.
#rx_pin:
#   MISO pin for SPI communication. This pin is not used for I2C
#   communication (I2C uses tx_pin for both sending and receiving).
#   The pin must have a valid pinmux configuration for the given
#   SERCOM peripheral. This parameter is optional.
clk_pin:
#   CLK pin for SPI communication, or SCL (clock) pin for I2C
#   communication. The pin must have a valid pinmux configuration
#   for the given SERCOM peripheral. This parameter must be provided.
```

### [adc_scaled]

Duet 2 Maestro 通過vref和vssa讀數進行模擬縮放。定義一個adc_scaled分段來啟用根據板載vref和vssa監視引腳調節的虛擬adc引腳（例如「my_name:PB0"）。虛擬引腳必須先被Duet 2 Maestro 通過vref和vssa讀數進行模擬縮放。定義一個adc_scaled分段來啟用根據板載vref和vssa監視引腳調節的虛擬adc引腳（例如「my_name:PB0"）。虛擬引腳必須先被定義才能用在其他配置分段中。

有關示例，請參見 [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg) 文件。

```
[adc_scaled my_name]
vref_pin:
#   用於監測 VREF 的 ADC 引腳。這個參數必須被提供。
vssa_pin:
#   用於監測 VSSA 的 ADC 引腳。這個參數必須被提供。
#smooth_time: 2.0
#   一個時間參數（以秒為計）區間用於平滑 VREF 和
#   VSSA 測量來減少測量的干擾。預設為2秒。
```

### [replicape]

副本支持 - 有關示例，請參見 [beaglebone guide](Beaglebone.md) 和 [generic-replicape.cfg](../config/generic-replicape.cfg) 文件。

```
# The "replicape" config section adds "replicape:stepper_x_enable"
# virtual stepper enable pins (for steppers X, Y, Z, E, and H) and
# "replicape:power_x" PWM output pins (for hotbed, e, h, fan0, fan1,
# fan2, and fan3) that may then be used elsewhere in the config file.
[replicape]
revision:
#   The replicape hardware revision. Currently only revision "B3" is
#   supported. This parameter must be provided.
#enable_pin: !gpio0_20
#   The replicape global enable pin. The default is !gpio0_20 (aka
#   P9_41).
host_mcu:
#   The name of the mcu config section that communicates with the
#   Klipper "linux process" mcu instance. This parameter must be
#   provided.
#standstill_power_down: False
#   This parameter controls the CFG6_ENN line on all stepper
#   motors. True sets the enable lines to "open". The default is
#   False.
#stepper_x_microstep_mode:
#stepper_y_microstep_mode:
#stepper_z_microstep_mode:
#stepper_e_microstep_mode:
#stepper_h_microstep_mode:
#   This parameter controls the CFG1 and CFG2 pins of the given
#   stepper motor driver. Available options are: disable, 1, 2,
#   spread2, 4, 16, spread4, spread16, stealth4, and stealth16. The
#   default is disable.
#stepper_x_current:
#stepper_y_current:
#stepper_z_current:
#stepper_e_current:
#stepper_h_current:
#   The configured maximum current (in Amps) of the stepper motor
#   driver. This parameter must be provided if the stepper is not in a
#   disable mode.
#stepper_x_chopper_off_time_high:
#stepper_y_chopper_off_time_high:
#stepper_z_chopper_off_time_high:
#stepper_e_chopper_off_time_high:
#stepper_h_chopper_off_time_high:
#   This parameter controls the CFG0 pin of the stepper motor driver
#   (True sets CFG0 high, False sets it low). The default is False.
#stepper_x_chopper_hysteresis_high:
#stepper_y_chopper_hysteresis_high:
#stepper_z_chopper_hysteresis_high:
#stepper_e_chopper_hysteresis_high:
#stepper_h_chopper_hysteresis_high:
#   This parameter controls the CFG4 pin of the stepper motor driver
#   (True sets CFG4 high, False sets it low). The default is False.
#stepper_x_chopper_blank_time_high:
#stepper_y_chopper_blank_time_high:
#stepper_z_chopper_blank_time_high:
#stepper_e_chopper_blank_time_high:
#stepper_h_chopper_blank_time_high:
#   This parameter controls the CFG5 pin of the stepper motor driver
#   (True sets CFG5 high, False sets it low). The default is True.
```

## 其他自定義模組

### [palette2]

Palette 2 多材料支援 - 提供更緊密的整合，支援處於連線模式的 Palette 2 裝置。

此模塊還需要 `[virtual_sdcard]` 和 `[pause_resume]` 才能獲得完整功能。

不要和 Octoprint 的 Palette 2外掛一起使用這個模組，因為它們會發生衝突，造成初始化和列印失敗。

如果使用 OctoPrint 並通過串列埠流式傳輸 G-Code，而不通過 virtual_sd 列印，將 * 設定>序列連線>韌體和協議 * 中的「暫停命令」 設定為**M1** 和 **M0** 可以避免在開始列印時需要在Palette 2 上選擇開始列印並在 OctoPrint 中取消暫停。

```
[palette2]
serial:
#   連線到 Palette 2 的串列埠。
#baud: 115200
#   使用的波特率。
#   預設為115200。
#feedrate_splice: 0.8
#   融接時的給進率
#   預設為0.8。
#feedrate_normal: 1.0
#   不在融接時的給進率 1.0
#auto_load_speed: 2
#   自動換料時的給近率
#   預設 2 (mm/s)
#auto_cancel_variation: 0.1
#   # 當 ping 值變化高於此閾值時自動取消列印
```

### [angle]

Magnetic hall angle sensor support for reading stepper motor angle shaft measurements using a1333, as5047d, or tle5012b SPI chips. The measurements are available via the [API Server](API_Server.md) and [motion analysis tool](Debugging.md#motion-analysis-and-data-logging). See the [G-Code reference](G-Codes.md#angle) for available commands.

```
[angle my_angle_sensor]
sensor_type:
#   The type of the magnetic hall sensor chip. Available choices are
#   "a1333", "as5047d", and "tle5012b". This parameter must be
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

## 通用匯流排參數

### 常見 SPI 設定

以下參數通常適用於使用 SPI 總線的設備。

```
#spi_speed:
#   The SPI speed (in hz) to use when communicating with the device.
#   The default depends on the type of device.
#spi_bus:
#   If the micro-controller supports multiple SPI busses then one may
#   specify the micro-controller bus name here. The default depends on
#   the type of micro-controller.
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Specify the above parameters to use "software based SPI". This
#   mode does not require micro-controller hardware support (typically
#   any general purpose pins may be used). The default is to not use
#   "software spi".
```

### 通用 I2C 設定

以下參數通常適用於使用 I2C 總線的設備。

Note that Klipper's current micro-controller support for i2c is generally not tolerant to line noise. Unexpected errors on the i2c wires may result in Klipper raising a run-time error. Klipper's support for error recovery varies between each micro-controller type. It is generally recommended to only use i2c devices that are on the same printed circuit board as the micro-controller.

Most Klipper micro-controller implementations only support an `i2c_speed` of 100000. The Klipper "linux" micro-controller supports a 400000 speed, but it must be [set in the operating system](RPi_microcontroller.md#optional-enabling-i2c) and the `i2c_speed` parameter is otherwise ignored. The Klipper "rp2040" micro-controller supports a rate of 400000 via the `i2c_speed` parameter. All other Klipper micro-controllers use a 100000 rate and ignore the `i2c_speed` parameter.

```
#i2c_address:
#   The i2c address of the device. This must specified as a decimal
#   number (not in hex). The default depends on the type of device.
#i2c_mcu:
#   The name of the micro-controller that the chip is connected to.
#   The default is "mcu".
#i2c_bus:
#   If the micro-controller supports multiple I2C busses then one may
#   specify the micro-controller bus name here. The default depends on
#   the type of micro-controller.
#i2c_speed:
#   The I2C speed (in Hz) to use when communicating with the device.
#   The Klipper implementation on most micro-controllers is hard-coded
#   to 100000 and changing this value has no effect. The default is
#   100000.
```
