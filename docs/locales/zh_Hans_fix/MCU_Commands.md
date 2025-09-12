# MCU 命令

本文档提供了有关从 Klipper “主机”软件发送并由 Klipper 微控制器软件处理的底层微控制器命令的信息。本文档并非这些命令的权威参考，也不包含所有可用命令的完整列表。

对于希望了解底层微控制器命令的开发人员，本文档可能有所帮助。

有关命令格式及其传输的更多信息，请参见[协议](Protocol.md)文档。此处的命令使用“printf”风格的语法进行描述——对于不熟悉该格式的用户，只需注意“%...”序列应替换为实际整数。例如，描述中“count=%c”可替换为文本“count=10”。请注意，被视为“枚举”的参数（参见上述协议文档）采用字符串值，该值会自动转换为微控制器的整数值。这在名为“pin”（或以“_pin”结尾）的参数中很常见。

## 启动命令

可能需要采取某些一次性操作来配置微控制器及其外设。本节列出可用于此目的的常用命令。与大多数微控制器命令不同，这些命令在收到后立即执行，且不需要任何特定设置。

常见的启动命令：

* `set_digital_out pin=%u value=%c`：此命令立即配置指定引脚为数字输出 GPIO，并将其设置为低电平（value=0）或高电平（value=1）。此命令可用于配置 LED 的初始值以及步进电机驱动器微步引脚的初始值。

* `set_pwm_out pin=%u cycle_ticks=%u value=%hu`：此命令将立即配置指定引脚使用基于硬件的脉宽调制（PWM），并指定 `cycle_ticks` 的数量。“cycle_ticks”是每个开关周期持续的 MCU 时钟周期数。使用 `cycle_ticks` 值为 1 可请求最快的周期时间。“value”参数范围为 0 到 255，0 表示完全关闭，255 表示完全开启。此命令可用于启用 CPU 和喷嘴冷却风扇。

## 低级微控制器配置

大多数微控制器命令在成功调用前需要进行初始设置。本节概述了配置过程。本节及后续各节可能仅对有兴趣了解 Klipper 内部细节的开发人员有用。

当主机首次连接到微控制器时，总是先获取数据字典（更多信息参见[协议](Protocol.md)）。获取数据字典后，主机将检查微控制器是否处于“已配置”状态，若未配置则进行配置。配置过程包括以下阶段：

* `get_config`：主机首先检查微控制器是否已配置。微控制器通过“config”响应消息回应此命令。微控制器软件在上电时始终处于未配置状态。在主机完成配置过程（通过发出 `finalize_config` 命令）之前，它将保持此状态。如果微控制器已在之前会话中配置（且配置了所需的设置），则主机无需进一步操作，配置过程成功结束。

* `allocate_oids count=%c`：此命令用于通知微控制器主机所需的最大对象 ID（oid）数量。此命令只能执行一次。oid 是分配给每个步进电机、每个限位开关和每个可调度 GPIO 引脚的整数标识符。主机预先确定操作硬件所需的 oid 数量，并将其传递给微控制器，以便微控制器可以分配足够的内存来存储从 oid 到内部对象的映射。

* `config_XXX oid=%c ...`：按照惯例，以“config_”前缀开头的任何命令都会创建一个新的微控制器对象，并为其分配给定的 oid。例如，`config_digital_out` 命令将配置指定引脚为数字输出 GPIO，并创建一个内部对象，主机可使用该对象来调度对给定 GPIO 的更改。传递给 config 命令的 oid 参数由主机选择，且必须介于零和 `allocate_oids` 命令中提供的最大数量之间。config 命令只能在微控制器未处于已配置状态时运行（即在主机发送 `finalize_config` 之前），并且在已发送 `allocate_oids` 命令之后。

* `finalize_config crc=%u`：`finalize_config` 命令将微控制器从未配置状态转换为已配置状态。传递给微控制器的 crc 参数将被存储，并在“config”响应消息中返回给主机。按照惯例，主机对其将请求的配置取一个 32 位 CRC，并在后续通信会话开始时检查微控制器中存储的 CRC 是否与其期望的 CRC 完全匹配。如果 CRC 不匹配，则主机知道微控制器未按其期望的状态进行配置。

### 常见的微控制器对象

本节列出一些常用的 config 命令。

* `config_digital_out oid=%c pin=%u value=%c default_value=%c max_duration=%u`：此命令为给定的 GPIO 'pin' 创建一个内部微控制器对象。引脚将被配置为数字输出模式，并设置为由 'value' 指定的初始值（0 为低电平，1 为高电平）。创建 digital_out 对象允许主机在指定时间安排对给定引脚的 GPIO 更新（参见下面描述的 `queue_digital_out` 命令）。如果微控制器软件进入关闭模式，则所有已配置的 digital_out 对象将被设置为 'default_value'。'max_duration' 参数用于实现安全检查——如果非零，则是主机可将给定 GPIO 设置为非默认值而无需进一步更新的最大时钟周期数。例如，如果 default_value 为零且 max_duration 为 16000，则如果主机将 gpio 设置为 1，则必须在 16000 个时钟周期内安排另一次对该 gpio 引脚的更新（设为 0 或 1）。此安全功能可用于加热器引脚，以确保主机不会启用加热器后离线。

* `config_pwm_out oid=%c pin=%u cycle_ticks=%u value=%hu default_value=%hu max_duration=%u`：此命令为基于硬件的 PWM 引脚创建一个内部对象，主机可安排更新。其用法类似于 `config_digital_out`——请参见 `set_pwm_out` 和 `config_digital_out` 命令的参数描述。

* `config_analog_in oid=%c pin=%u`：此命令用于将引脚配置为模拟输入采样模式。配置后，可使用 `query_analog_in` 命令（见下文）定期采样引脚。

* `config_stepper oid=%c step_pin=%c dir_pin=%c invert_step=%c step_pulse_ticks=%u`：此命令创建一个内部步进电机对象。'step_pin' 和 'dir_pin' 参数分别指定步进和方向引脚；此命令将它们配置为数字输出模式。'invert_step' 参数指定步进是在上升沿（invert_step=0）还是下降沿（invert_step=1）发生。'step_pulse_ticks' 参数指定步进脉冲的最小持续时间。如果 mcu 导出常量 'STEPPER_BOTH_EDGE=1'，则设置 step_pulse_ticks=0 且 invert_step=-1 将设置为在步进引脚的上升沿和下降沿均进行步进。

* `config_endstop oid=%c pin=%c pull_up=%c stepper_count=%c`：此命令创建一个内部“限位开关”对象。它用于指定限位开关引脚并启用“归零”操作（参见下面的 `endstop_home` 命令）。该命令将指定引脚配置为数字输入模式。'pull_up' 参数确定是否启用引脚的硬件上拉电阻（如果可用）。'stepper_count' 参数指定此限位开关在归零操作期间可能需要停止的最大步进电机数量（参见下面的 `endstop_home`）。

* `config_spi oid=%c bus=%u pin=%u mode=%u rate=%u shutdown_msg=%*s`：此命令创建一个内部 SPI 对象。它与 `spi_transfer` 和 `spi_send` 命令一起使用（见下文）。“bus”标识要使用的 SPI 总线（如果微控制器有多个 SPI 总线可用）。“pin”指定设备的片选（CS）引脚。“mode”是 SPI 模式（应在 0 到 3 之间）。“rate”参数指定 SPI 总线速率（每秒周期数）。最后，“shutdown_msg”是在微控制器进入关闭状态时发送给指定设备的 SPI 命令。

* `config_spi_without_cs oid=%c bus=%u mode=%u rate=%u shutdown_msg=%*s`：此命令类似于 `config_spi`，但没有 CS 引脚定义。它适用于没有片选线的 SPI 设备。

## 常用命令

本节列出一些常用的运行时命令。它可能仅对希望深入了解 Klipper 的开发人员有用。

* `set_digital_out_pwm_cycle oid=%c cycle_ticks=%u`：此命令配置一个数字输出引脚（由 `config_digital_out` 创建）以使用“软件 PWM”。'cycle_ticks' 是 PWM 周期的时钟周期数。由于输出切换在微控制器软件中实现，建议 'cycle_ticks' 对应的时间为 10ms 或更长。

* `queue_digital_out oid=%c clock=%u on_ticks=%u`：此命令将在给定的时钟时间安排对数字输出 GPIO 引脚的更改。要使用此命令，必须在微控制器配置期间发出具有相同 'oid' 参数的 'config_digital_out' 命令。如果已调用 `set_digital_out_pwm_cycle`，则 'on_ticks' 是 PWM 周期的导通持续时间（以时钟周期为单位）。否则，'on_ticks' 应为 0（低电压）或 1（高电压）。

* `queue_pwm_out oid=%c clock=%u value=%hu`：安排对硬件 PWM 输出引脚的更改。更多信息请参见 'queue_digital_out' 和 'config_pwm_out' 命令。

* `query_analog_in oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u min_value=%hu max_value=%hu`：此命令设置一个重复的模拟输入采样计划。要使用此命令，必须在微控制器配置期间发出具有相同 'oid' 参数的 'config_analog_in' 命令。采样将从 'clock' 时间开始，每 'rest_ticks' 个时钟周期报告一次获得的值，将 'sample_count' 次过采样，且在过采样样本之间暂停 'sample_ticks' 个时钟周期。'min_value' 和 'max_value' 参数实现一个安全功能——微控制器软件将验证采样值（在任何过采样之后）始终在提供的范围内。此功能旨在用于连接到控制加热器的热敏电阻的引脚——可用于检查加热器是否在温度范围内。

* `get_clock`：此命令导致微控制器生成一个“clock”响应消息。主机每秒发送此命令一次，以获取微控制器时钟的值并估计主机与微控制器时钟之间的漂移。它使主机能够准确估计微控制器时钟。

### 步进电机命令

* `queue_step oid=%c interval=%u count=%hu add=%hi`：此命令为给定步进电机安排 'count' 个步进，每个步进之间相隔 'interval' 个时钟周期。第一个步进将在给定步进电机上次安排的步进之后 'interval' 个时钟周期发生。如果 'add' 非零，则每个步进后间隔将调整 'add' 量。此命令将给定的 interval/count/add 序列追加到每个步进电机的队列中。在正常操作期间可能会有数百个这样的序列排队。新序列被追加到队列末尾，当每个序列完成其 'count' 个步进后，它将从队列前端移除。此系统允许微控制器排队潜在的数十万个步进——所有步进都具有可靠和可预测的调度时间。

* `set_next_step_dir oid=%c dir=%c`：此命令指定下一个 `queue_step` 命令将使用的 dir_pin 值。

* `reset_step_clock oid=%c clock=%u`：通常，步进定时相对于给定步进电机的最后一个步进。此命令重置时钟，使下一个步进相对于提供的 'clock' 时间。主机通常仅在打印开始时发送此命令。

* `stepper_get_position oid=%c`：此命令导致微控制器生成一个包含步进电机当前位置的“stepper_position”响应消息。位置是 dir=1 生成的总步数减去 dir=0 生成的总步数。

* `endstop_home oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u pin_value=%c`：此命令在步进电机“归零”操作期间使用。要使用此命令，必须在微控制器配置期间发出具有相同 'oid' 参数的 'config_endstop' 命令。当此命令被调用时，微控制器将每 'rest_ticks' 个时钟周期采样一次限位开关引脚，并检查其值是否等于 'pin_value'。如果值匹配（并且在 'sample_ticks' 间隔的 'sample_count' 次附加采样中持续匹配），则关联步进电机的运动队列将被清除，步进电机将立即停止。主机使用此命令实现归零——主机指示限位开关采样限位开关触发，并发出一系列 `queue_step` 命令将步进电机移向限位开关。一旦步进电机触碰到限位开关，触发将被检测到，运动停止，主机收到通知。

### 运动队列

每个 `queue_step` 命令都使用微控制器“运动队列”中的一个条目。该队列在收到“finalize_config”命令时分配，并在“config”响应消息中报告可用队列条目的数量。

主机有责任确保在发送 `queue_step` 命令之前队列中有可用空间。主机通过计算每个 `queue_step` 命令的完成时间并相应地安排新的 `queue_step` 命令来实现此目的。

### SPI 命令

* `spi_transfer oid=%c data=%*s`：此命令导致微控制器向由 'oid' 指定的 spi 设备发送 'data'，并生成一个“spi_transfer_response”响应消息，其中包含传输期间返回的数据。

* `spi_send oid=%c data=%*s`：此命令类似于“spi_transfer”，但它不生成“spi_transfer_response”消息。