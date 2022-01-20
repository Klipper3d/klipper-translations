# MCU commands

该文档介绍了Klipper上位机软件发送到微控制器的，并由微处理器负责执行的底层命令。该文档不是这些命令的权威文档，也并未包含所有命令。

若想深入了解底层微处理器命令，该文档是不错的入门材料。

关于命令的格式和传输的更多信息，见[protocol](Protocol.md)文件。这里的命令是使用其 "printf "风格的语法描述的--对于那些不熟悉这种格式的人来说，只需注意在看到'%...'序列时，应该用一个实际的整数来代替。例如，"count=%c "的描述可以被替换为 "count=10"。请注意，那些被认为是 "枚举 "的参数（见上述协议文件）采取的是一个字符串值，对于微控制器来说，它被自动转换为一个整数值。这在名为 "pin"（或后缀为"_pin"）的参数中很常见。

## 启动命令

可能需要采取某些一次性的命令来配置微控制器及其片上外备。本节列出了可用于该目的的常用命令。与大多数微控制器的命令不同，这些命令在收到后立即运行，它们不需要任何特殊的设置。

常见的启动命令：

* `set_digital_out pin=%u value=%c`：该命令立即将指定的引脚配置为数字输出GPIO，并将其设置为低电平（value=0）或高电平（value=1）。这条命令对于配置LED的初始值和配置步进驱动器微步进引脚的初始值很有用。
* `set_pwm_out pin=%u cycle_ticks=%u value=%hu`：该命令将立即配置指定的引脚，使其使用硬件的脉宽调制（PWM）和给定的cycle_ticks。“cycle_ticks”是指每个通电和断电周期应该持续的MCU时钟数。cycle_ticks的值为1表示使用最快的周期时间。“value”参数在0-255之间，0表示完全关闭状态，255表示完全开启状态。该命令对启用CPU和喷嘴冷却风扇很有用。

## 底层微控制器配置

微控制器中的大多数命令在成功调用之前需要进行初始设置。本节提供了一个配置过程的概述。本节和下面的章节适用于对Klipper的内部细节感兴趣的开发者。

当主机第一次连接到微控制器时，它总是从获得一个数据字典开始（更多信息见[protocol](Protocol.md)）。获得数据字典后，主机将检查微控制器是否处于 "已配置 "状态，如果不是，就进行配置。配置包括以下几个阶段：

* `get_config`：主机首先检查微控制器是否已经被配置。微控制器用一个 "config "的响应信息来回应这个命令。微控制器软件在上电时总是以未配置的状态启动。在主机完成配置过程之前（通过发出finalize_config命令），它一直处于这种状态。如果微控制器已经在前一个会话中进行了配置（并且配置了所需的设置），那么主机就不需要进一步的操作，配置过程成功结束。
* `allocate_oids count=%c`：这条命令是用来通知微控制器主机所需的对象标识（oid）的最大数量。这条命令只有效一次。oid是分配给每个步进电机、每个限位开关和每个可调度的gpio引脚的一个整数标识。主机事先确定操作硬件所需的oid数量，并将其传递给微控制器，以便它可以分配足够的内存来存储从oid到内部对象的映射。
* `config_XXX oid=%c ...`：按照惯例，任何以 "config_"开头的命令都会创建一个新的微控制器对象，并将给定的oid赋予它。例如，config_digital_out命令将把指定的引脚配置为数字输出GPIO，并创建一个内部对象，主机可以用它来安排改变指定的GPIO的输出。传入config命令的oid参数由主机选择，必须介于0和allocate_oids命令中提供的最大计数之间。config命令只能在微控制器不处于已配置状态时（即在主机发送finalize_config之前）和allocate_oids命令被发送之后运行。
* `finalize_config crc=%u`：finalize_config命令将微控制器从未配置状态转换为已配置状态。传递给微控制器的crc参数被储存起来，并在 "config "响应信息中反馈给主机。按照惯例，主机对它所要求的配置采取32位的CRC，并在随后的通信会话开始时，检查存储在微控制器中的CRC是否与它所希望的CRC正确匹配。如果CRC不匹配，那么主机就知道微控制器还没有被配置到主机所希望的状态。

### 常见的微控制器对象

本节列出了一些常用的配置命令。

* `config_digital_out oid=%c pin=%u value=%c default_value=%c max_duration=%u`：该命令为给定的GPIO'pin'创建一个内部微控制器对象。该引脚将被配置为数字输出模式，并被设置为'value'指定的初始值（0为低，1为高）。创建一个digital_out对象允许主机在指定的时间内对指定引脚刷新GPIO输出状态（见下面描述的queue_digital_out命令）。如果微控制器软件进入关机模式，那么所有配置的digital_out对象将被设置为'default_value'。max_duration "参数用于实现安全检查--如果它是非零，那么它代表主机可以将指定的GPIO设为非默认值而不需要刷新的最大时钟数。例如，如果default_value是0，max_duration是16000，那么如果主机将gpio设置为1，它必须在16000个时钟刻度内刷新gpio引脚的输出（为0或1）。这个安全功能可用于加热器引脚，以确保主机不会启用加热器后脱机。
* `config_pwm_out oid=%c pin=%u cycle_ticks=%u value=%hu default_value=%hu max_duration=%u`：该命令为基于硬件的PWM引脚创建一个内部对象，主机可以定期刷新。它的用法与config_digital_out类似--参数说明见'set_pwm_out'和'config_digital_out'命令的描述。
* `config_analog_in oid=%c pin=%u`：该命令用于将一个引脚配置为模拟输入采样模式。一旦配置完成，就可以使用query_analog_in命令（见下文）以固定的时间间隔对该引脚进行采样。
* `config_stepper oid=%c step_pin=%c dir_pin=%c invert_step=%c step_pulse_ticks=%u` : This command creates an internal stepper object. The 'step_pin' and 'dir_pin' parameters specify the step and direction pins respectively; this command will configure them in digital output mode. The 'invert_step' parameter specifies whether a step occurs on a rising edge (invert_step=0) or falling edge (invert_step=1). The 'step_pulse_ticks' parameter specifies the minimum duration of the step pulse. If the mcu exports the constant 'STEPPER_BOTH_EDGE=1' then setting step_pulse_ticks=0 and invert_step=-1 will setup for stepping on both the rising and falling edges of the step pin.
* `config_endstop oid=%c pin=%c pull_up=%c stepper_count=%c` : 该命令创建一个内部的 "endstop"对象。它用于指定限位开关的引脚，并启用 "homing "操作（见下面的endstop_home命令）。该命令将把指定的引脚配置为数字输入模式。‘pull_up’参数决定是否启用硬件为引脚提供的上拉电阻（如果有的话）。‘stepper_count’参数规定了在归零操作中，该限位开关触发器可能需要的最大步进数（见下文endstop_home）。
* `config_spi oid=%c bus=%u pin=%u mode=%u rate=%u shutdown_msg=%*s` : This command creates an internal SPI object. It is used with spi_transfer and spi_send commands (see below). The "bus" identifies the SPI bus to use (if the micro-controller has more than one SPI bus available). The "pin" specifies the chip select (CS) pin for the device. The "mode" is the SPI mode (should be between 0 and 3). The "rate" parameter specifies the SPI bus rate (in cycles per second). Finally, the "shutdown_msg" is an SPI command to send to the given device should the micro-controller go into a shutdown state.
* `config_spi_without_cs oid=%c bus=%u mode=%u rate=%u shutdown_msg=%*s` : This command is similar to config_spi, but without a CS pin definition. It is useful for SPI devices that do not have a chip select line.

## Common commands

This section lists some commonly used run-time commands. It is likely only of interest to developers looking to gain insight into Klipper.

* `set_digital_out_pwm_cycle oid=%c cycle_ticks=%u` : This command configures a digital output pin (as created by config_digital_out) to use "software PWM". The 'cycle_ticks' is the number of clock ticks for the PWM cycle. Because the output switching is implemented in the micro-controller software, it is recommended that 'cycle_ticks' correspond to a time of 10ms or greater.
* `queue_digital_out oid=%c clock=%u on_ticks=%u` : This command will schedule a change to a digital output GPIO pin at the given clock time. To use this command a 'config_digital_out' command with the same 'oid' parameter must have been issued during micro-controller configuration. If 'set_digital_out_pwm_cycle' has been called then 'on_ticks' is the on duration (in clock ticks) for the pwm cycle. Otherwise, 'on_ticks' should be either 0 (for low voltage) or 1 (for high voltage).
* `queue_pwm_out oid=%c clock=%u value=%hu` : Schedules a change to a hardware PWM output pin. See the 'queue_digital_out' and 'config_pwm_out' commands for more info.
* `query_analog_in oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u min_value=%hu max_value=%hu` : This command sets up a recurring schedule of analog input samples. To use this command a 'config_analog_in' command with the same 'oid' parameter must have been issued during micro-controller configuration. The samples will start as of 'clock' time, it will report on the obtained value every 'rest_ticks' clock ticks, it will over-sample 'sample_count' number of times, and it will pause 'sample_ticks' number of clock ticks between over-sample samples. The 'min_value' and 'max_value' parameters implement a safety feature - the micro-controller software will verify the sampled value (after any oversampling) is always between the supplied range. This is intended for use with pins attached to thermistors controlling heaters - it can be used to check that a heater is within a temperature range.
* `get_clock` : This command causes the micro-controller to generate a "clock" response message. The host sends this command once a second to obtain the value of the micro-controller clock and to estimate the drift between host and micro-controller clocks. It enables the host to accurately estimate the micro-controller clock.

### Stepper commands

* `queue_step oid=%c interval=%u count=%hu add=%hi` : This command schedules 'count' number of steps for the given stepper, with 'interval' number of clock ticks between each step. The first step will be 'interval' number of clock ticks since the last scheduled step for the given stepper. If 'add' is non-zero then the interval will be adjusted by 'add' amount after each step. This command appends the given interval/count/add sequence to a per-stepper queue. There may be hundreds of these sequences queued during normal operation. New sequence are appended to the end of the queue and as each sequence completes its 'count' number of steps it is popped from the front of the queue. This system allows the micro-controller to queue potentially hundreds of thousands of steps - all with reliable and predictable schedule times.
* `set_next_step_dir oid=%c dir=%c` : This command specifies the value of the dir_pin that the next queue_step command will use.
* `reset_step_clock oid=%c clock=%u` : Normally, step timing is relative to the last step for a given stepper. This command resets the clock so that the next step is relative to the supplied 'clock' time. The host usually only sends this command at the start of a print.
* `stepper_get_position oid=%c` : This command causes the micro-controller to generate a "stepper_position" response message with the stepper's current position. The position is the total number of steps generated with dir=1 minus the total number of steps generated with dir=0.
* `endstop_home oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u pin_value=%c` : This command is used during stepper "homing" operations. To use this command a 'config_endstop' command with the same 'oid' parameter must have been issued during micro-controller configuration. When this command is invoked, the micro-controller will sample the endstop pin every 'rest_ticks' clock ticks and check if it has a value equal to 'pin_value'. If the value matches (and it continues to match for 'sample_count' additional samples spread 'sample_ticks' apart) then the movement queue for the associated stepper will be cleared and the stepper will come to an immediate halt. The host uses this command to implement homing - the host instructs the endstop to sample for the endstop trigger and then it issues a series of queue_step commands to move a stepper towards the endstop. Once the stepper hits the endstop, the trigger will be detected, the movement halted, and the host notified.

### Move queue

Each queue_step command utilizes an entry in the micro-controller "move queue". This queue is allocated when it receives the "finalize_config" command, and it reports the number of available queue entries in "config" response messages.

It is the responsibility of the host to ensure that there is available space in the queue before sending a queue_step command. The host does this by calculating when each queue_step command completes and scheduling new queue_step commands accordingly.

### SPI Commands

* `spi_transfer oid=%c data=%*s` : This command causes the micro-controller to send 'data' to the spi device specified by 'oid' and it generates a "spi_transfer_response" response message with the data returned during the transmission.
* `spi_send oid=%c data=%*s` : This command is similar to "spi_transfer", but it does not generate a "spi_transfer_response" message.
