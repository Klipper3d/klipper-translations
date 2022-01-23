# MCU命令

该文档介绍了Klipper上位机软件发送到微控制器的，并由微处理器负责执行的底层命令。该文档不是这些命令的权威文档，也并未包含所有命令。

若想深入了解底层微处理器命令，该文档是不错的入门材料。

关于命令的格式和传输的更多信息，见[protocol](Protocol.md)文件。这里的命令是使用其 "printf "风格的语法描述的--对于那些不熟悉这种格式的人来说，只需注意在看到'%...'序列时，应该用一个实际的整数来代替。例如，"count=%c "的描述可以被替换为 "count=10"。请注意，那些被认为是 "enumerations "的参数（见上述协议文件）采取的是一个字符串值，对于微控制器来说，它被自动转换为一个整数值。这在名为 "pin"（或后缀为"_pin"）的参数中很常见。

## 启动命令

可能需要采取某些一次性的命令来配置微控制器及其片上外备。本节列出了可用于该目的的常用命令。与大多数微控制器的命令不同，这些命令在收到后立即运行，它们不需要任何特殊的设置。

常见的启动命令：

* `set_digital_out pin=%u value=%c`：该命令立即将指定的引脚配置为数字输出GPIO，并将其设置为低电平（value=0）或高电平（value=1）。这条命令对于配置LED的初始值和配置步进驱动器微步进引脚的初始值很有用。
* `set_pwm_out pin=%u cycle_ticks=%u value=%hu`：该命令将立即配置指定的引脚，使其使用硬件的脉宽调制（PWM）和给定的cycle_ticks。“cycle_ticks”是指每个通电和断电周期应该持续的MCU时钟数。cycle_ticks的值为1表示使用最短的周期时间。“value”参数在0-255之间，0表示完全关闭状态，255表示完全开启状态。该命令对启用CPU和喷嘴冷却风扇很有用。

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
* `config_stepper oid=%c step_pin=%c dir_pin=%c invert_step=%c step_pulse_ticks=%u`：该命令创建一个内部步进器对象。'step_pin'和'dir_pin'参数分别指定步进和方向引脚；该命令将把它们配置为数字输出模式。'invert_step'参数指定步进是发生在上升沿（invert_step=0）还是下降沿（invert_step=1）。'step_pulse_ticks'参数指定了步进脉冲的最小持续时间。如果MCU输出常数 "STEPPER_BOTH_EDGE=1"，那么设置step_pulse_ticks=0和invert_step=-1将设置在步进引脚的上升沿和下降沿都进行步进输出。
* `config_endstop oid=%c pin=%c pull_up=%c stepper_count=%c` : 该命令创建一个内部的 "endstop"对象。它用于指定限位开关的引脚，并启用 "homing "操作（见下面的endstop_home命令）。该命令将把指定的引脚配置为数字输入模式。‘pull_up’参数决定是否启用硬件为引脚提供的上拉电阻（如果有的话）。‘stepper_count’参数规定了在归零操作中，该限位开关触发器可能需要的最大步进数（见下文endstop_home）。
* `config_spi oid=%c bus=%u pin=%u mode=%u rate=%u shutdown_msg=%*s`：该命令创建了一个内部SPI对象。它与spi_transfer和spi_send命令一起使用（见下文）。"bus"标识了要使用的SPI总线（如果微控制器有一个以上的SPI总线可用）。"pin"指定了设备的片选（CS）引脚。"mode"指定SPI模式（应该在0到3之间）。"rate "参数指定了SPI总线的速率（以每秒周期为单位）。最后，"shutdown_msg "是在微控制器进入关机状态时向给定设备发送的SPI命令。
* `config_spi_without_cs oid=%c bus=%u mode=%u rate=%u shutdown_msg=%*s` : 这个命令类似于config_spi，但是没有CS引脚的定义。它对没有芯片选择线的SPI设备很有用。

## 常用命令

本节列出了一些常用的运行时命令。对希望深入了解Klipper的开发者可能会感兴趣。

* `set_digital_out_pwm_cycle oid=%c cycle_ticks=%u`：该命令将数字输出引脚（由config_digital_out创建）配置为使用 "软件PWM"。'cycle_ticks' 是PWM周期的时钟数。因为输出切换是在微控制器软件中实现的，建议把'cycle_ticks'对应的时间设为10ms或更大。
* `queue_digital_out oid=%c clock=%u on_ticks=%u` : 这个命令将安排在设定的时钟时间内改变数字输出GPIO引脚。要使用这条命令，必须在微控制器配置过程中发出具有相同‘oid’参数的'config_digital_out'命令。如果'set_digital_out_pwm_cycle'已经被调用，那么'on_ticks'就是pwm周期的开启时间（以时钟数为单位）。否则，'on_ticks'应该是0（低电压）或1（高电压）。
* `queue_pwm_out oid=%c clock=%u value=%hu` ：安排改变一个硬件PWM输出引脚。更多信息请参考 'queue_digital_out' 和 'config_pwm_out' 命令。
* `query_analog_in oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u min_value=%hu max_value=%hu`：此命令设置了一个对模拟输入的循环采样。要使用这条命令，必须在微控制器配置时发出具有相同'oid'参数的 'config_analog_in '命令。采样将从'clock'时间开始，它将每隔'rest_ticks'时钟数报告获得的值，'sample_count'是过量采样次数，'sample_ticks'是在过量采样之间暂停的时钟数。"min_value "和 "max_value "参数实现了安全功能--微控制器软件将验证采样值（在每次过采样之后）总是在安全范围内。这是为连接到控制加热器的热敏电阻的引脚而设计的--它可以用来检查加热器是否在一个温度范围内。
* `get_clock`：该命令使微控制器产生一个 "clock"响应消息。主机每秒发送一次这个命令，以获得微控制器的时钟值，并估计主机和微控制器时钟之间的漂移。它使主机能够准确估计微控制器的时钟。

### 步进器命令

* `queue_step oid=%c interval=%u count=%hu add=%hi`：该命令安排指定的步进电机输出'count'个步数，'interval'是每步之间的时钟数间隔。命令中的第一步与上一个步进输出命令最后一步的时间间隔为'interval'个时钟数。如果'add'不为零，那么每步之后的间隔将以'add'的增量调整。该命令将给定的间隔/计数/增量序列附加到每个步进队列中。在正常操作中，可能有数百个这样的序列排队。新的序列被添加到队列的末尾，当每个序列完成了它的 'count'步数后它就从队列的前面弹出去。这个系统允许微控制器将几十万步排入队列--所有这些都有可靠且可预测的调度时序。
* `set_next_step_dir oid=%c dir=%c`：该命令指定了下一个queue_step命令将使用的dir_pin的值。
* `reset_step_clock oid=%c clock=%u`：通常情况下步进时序是相对于给定步进的上一步。这条命令重置了时钟，使下一步是相对于提供的 'clock' 时间。通常主机只在打印开始时发送此命令。
* `stepper_get_position oid=%c`：该命令使微控制器生成一个 "stepper_position "响应消息，其中包含步进器的当前位置。该位置是dir=1时产生的总步数减去dir=0时的总步数。
* `endstop_home oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u pin_value=%c`：该命令用于步进电机 "homing"操作。要使用这条命令，必须在微控制器配置过程中发出具有相同 'oid '参数的 'config_endstop '命令。当这个命令被调用时，微控制器将在每一个'rest_ticks'时钟刻度上对限位开关引脚进行采样，并检查它的值是否等于'pin_value'。如果开关被触发（并且以间隔'sample_ticks'为周期，额外持续'sample_count'次被触发），那么相关步进的运动队列将被清除，步进将立即停止。主机使用该命令实现归位–主机指示限位开关对限位开关的触发进行采样，然后发出一系列queue_step命令，使步进向限位移动。一旦步进电机撞到限位开关，检测到触发，运动就会停止并通知主机。

### 运动队列

每个queue_step命令都利用了微控制器 "move queue "中的一个条目。这个队列是在它收到 "finalize_config "命令时分配的，它在 "config "响应信息中报告可用队列条目的数量。

在发送queue_step命令之前，主机有责任确保队列中有可用空间。这需要主机通过计算每个queue_step命令完成的时间并相应地安排新的queue_step命令来实现。

### SPI 命令

* `spi_transfer oid=%c data=%*s`：这条命令使微控制器向 'oid '指定的spi设备发送 'data' ，并生成一个 "spi_transfer_response "的响应消息，其中包括传输期间返回的数据。
* `spi_send oid=%c data=%*s`：这个命令与 "spi_transfer "类似，但它不产生 "spi_transfer_response "消息。
