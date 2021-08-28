# Code overview

本文档将描述Klipper的代码总体结构和代码流。

## 文件夹结构

**src/**包含微控制器的C源码。其中**src/atsam/**, **src/atsamd/**, **src/avr/**, **src/linux/**, **src/lpc176x/**, **src/pru/**, and **src/stm32/** 为对应微处理器架构的源码。 **src/simulator/** 包含有用于交叉编译、测试目标微处理器的代码。**src/generic/**为对不同架构均有用的代码。编译"board/somefile.h"时，编译器会优先使用 架构特定的目录 (即src/avr/somefile.h)随后找寻通用目录(即 src/generic/somefile.h)。

**klippy/**目录包含了上位机软件。软件大部分由Python实现，同时**klippy/chelper/** 目录包含了由C实现的有用代码。**klippy/kinematics/**目录包含机械运动学的实现代码。**klippy/extras/** 目录包含了上位机的扩建模块("modules")。

**lib/**包含了构建必须的第三方库代码。

**config/**包含了打印机配置的实例文件。

**scripts/**目录包含了编译微控制器代码时有用的脚本。

**test/**目录包含了自动测试示例。

在编译过程重，编译器会构建**out/**目录。该目录包含构建时的临时文件。对于AVR架构，编译器输出的为**out/klipper.elf.hex**，而对ARM架构则为**out/klipper.bin**。

## 微处理器的代码流

微控制器的代码从对应架构的代码(即**src/avr/main.c**)开始执行，前述代码会持续调用**src/sched.c**中的 sched_main() 函数。sched_main() 代码会先运行经 DECL_INIT() 宏标注的所有函数。之后它将不断重复运行由 DECL_TASK() 宏所标注的函数。

其中一个主要的任务函数为**src/command.c** 中的command_dispatch()。上述函数经由微处理器特定的 输入/输出 代码调用(即**src/avr/serial.c**, **src/generic/serial_irq.c**)，并执行输入流中的命令所对应的命令函数。命令函数通过 DECL_COMMAND() 宏进行定义 (详情参照[协议](Protocol.md) 文档)。

任务、初始化和命令函数总是在中断启用的情况下运行（然而，可根据需要将中断功能停用）。这些函数不应出现暂停、延迟或执行持续事件长于数微秒的任务。这些函数应由调度定时器在特定的事件进行调用。

定时函数通过调用sched_add_timer() (即 **src/sched.c**)方法进行注册。调度器会在设定的时间点对注册的函数进行调用。定时器中断会在微处理器架构特定的初始化处理器中处理(例如 **src/avr/timer.c**)，该代码会调用 **src/sched.c**中的sched_timer_dispatch()。通过定时器中断执行注册的定时函数。定时函数总在中断禁用下运行。定时函数应总能在数微秒内完成。在定时函数结束时，该函数可对自身进行重新定时。

如果事件中抛出错误， 代码可调用shutdown()（**src/sched.c**中的sched_shutdown()）。调用shutdown()会导致所有标记为DECL_SHUTDOWN()宏的函数被运行。shutdown()总是在禁用中断的情况下运行。

微控制器的大部分功能涉及到通用输入输出引脚（GPIO）的操作。为了从高级任务代码中抽象出特定架构底层代码，所有的GPIO事件都在特定架构的包装器中实现（如，**src/avr/gpio.c**）。代码使用gcc的"-flto -fwhole-program "来优化编译，以实现内联函数的高性能交叉编译，大多数微小的GPIO操作函数内联到它们的调用器中，使用这些GPIO将没有任何运行时成本。

## 代码总览

上位机程序（klippy）运行在廉价计算机（如 树莓派）上，配搭mcu使用。该程序的主要编程语言为Python，同时部分功能通过CFFI在C语言上实现。

上位机程序通过** klippy/klippy.py**初始化。该文件会读取命令行参数，打开打印机的设置文件，实例化打印机的主要模块，并启用串口通讯。G代码命令的执行则通过 **klippy/gcode.py**中的 process_commands() 方法实现。此代码将G代码转化为打印机的对象调用，它将频繁地将G代码命令转化为微控制器的行动指令（通过微控制器代码中的 DECL_COMMAND 进行声明）。

Klippy上位机程序包含四个进程。主线程用于处理输入的G代码命令。第二线程通过串口实现底层IO的处理（代码位于 **klippy/chelper/serialqueue.c **以C语言实现）。第三线程则通过Python代码处理微控制器返回的信息（参照 klippy/serialhdl.py）。第四线程则负责将Debug信息写入到日志文件(见 **klippy/queuelogger.py**)，由此，其他线程的执行将不会阻塞日志的写入。

## 典型运动命令的代码流

典型的打印机运动始于klipper上位机接收到"G1"命令，并在微控制器发出对应的步进脉冲结束。本节将简述典型运动命令的代码流。[运动学](Kinematics.md)文档将更为细致的描述运动的机械原理。

* 移动命令的处理始于gcode.py，该代码将G代码转化为内部调用。G1命令将调用klippy/extras/gcode_move.py中的cmd_G1()函数。gcode_move.py中的代码将处理 原点变换（G92），绝对坐标模式（G90）和单位变换（如F6000=100mm/s）。一个移动命令的处理路径为：`_process_data() -> _process_commands() -> cmd_G1()`。最终将调用ToolHead类的方法实现移动 `cmd_G1() -> ToolHead.move()`。
* ToolHead类（位于toolhead.py）处理“前瞻”行为和记录打印的时间点。移动命令的代码路径为 `ToolHead.move() -> MoveQueue.add_move() -> MoveQueue.flush() -> Move.set_junction() -> ToolHead._process_moves()`。
   * ToolHead.move()将创建一个Move()对象实例，其中将包含移动的参数（在笛卡尔空间中，并这些参数以mm和s为单位）。
   * kinematics类将检查每个运动命令（`ToolHead.move() -> kin.check_move()`）。各种kinematics类存放于 klippy/kinematics/ 目录。check_move()能在运动命令不合理时抛出错误。如果 check_move()成功，这意味着打印机必定能完成运动命令。
   * MoveQueue.add_move()将一个move实例添加到“前瞻”队列。
   * MoveQueue.flush()将进行每次运动 起始和结束 速度。
   * Move.set_junction()实现移动的“梯形加减速（trapezoid generator）”。“梯形加减速”将每次移动拆分为三部分：恒加速度加速阶段、恒速度阶段、恒加速度减速阶段。所有移动均含有上述三个阶段，但单个阶段的持续时间可能为0。
   * 当ToolHead._process_moves()被调用时，一次移动的所有要素均已就绪——移动的起始位置、结束位置、加速度、起始/巡航/结束速度、以及起始/巡航/结束的距离。所有信息以笛卡尔坐标的形式存储在Move()实例中，单位为mm和s。
* Klipper使用[迭代求解](https://en.wikipedia.org/wiki/Root-finding_algorithm)的方式生成步进电机的每步的时长。为了提高效率，步进脉冲时间是以C语言代码生成。一个运动先经过“梯形运动队列化” ：`ToolHead._process_moves() -> trapq_append()` (位于 klippy/chelper/trapq.c)，然后生成步进时间 `ToolHead._process_moves() -> ToolHead._update_move_time() -> MCU_Stepper.generate_steps() -> itersolve_generate_steps() -> itersolve_gen_steps_range()` (位于 klippy/chelper/itersolve.c)。迭代求解器通过一个时间-位置方程计算出步进时间。求解时通过“假定”时间点，以时间-位置方程计算出下一步的位置。如果计算结果与实际需求的下一步位置一致，假定值将用于实际运动；否则，通过计算结果对“假定时间”进行修正，并进行下一次试算。这种反馈方式会使迭代快速收敛。运动学所使用的时间-位置函数位于 klippy/chelper/ 目录 (例如, kin_cart.c, kin_corexy.c, kin_delta.c, kin_extruder.c)。
* 需要注意，挤出机有独特的运动学模型，使用`ToolHead._process_moves() -> PrinterExtruder.move()`类继续宁处理。尽管挤出机使用了独立的Move()类，由于Move() 实例包含了实际运动的时间，并且脉冲时间的设备是定时发送到微控制器上，因此由挤出机类产生的步进运动将与打印头的运动同步。
* 当迭代计算器计算出步进时长后，计算结果将被置于一个数组中：`itersolve_gen_steps_range() -> stepcompress_append()` (位于 klippy/chelper/stepcompress.c)。数组(结构体 stepcompress.queue)存储每一步对应的微处理器时钟计数器时间。上述的“微处理器计数器”的值指的是微处理器硬件上的计数器——其值基于微处理器最后一次上电而定。
* 接下来重要的是，对步进数据进行压缩： `stepcompress_flush() -> compress_bisect_add()` (位于 klippy/chelper/stepcompress.c)。上述代码将基于前述的 步进时间列表 生成和编码一系列的微控制器"queue_step"（队列步进）命令。这些"queue_step"命令将被队列化，优先处理，并发送到微控制器中（上位机通过 stepcompress.c:steppersync；下位机通过serialqueue.c:serialqueue)）。
* 在微控制器，queue_step命令将经由 src/command.c 处理。改代码将对命令进行解释，并调用 `command_queue_step()`。command_queue_step()（位于src/stepper.c）将每个queue_step命令的参数附加到对应的步进队列中。正常运行下，一“步”将在其执行前100ms被解释并加入队列。最后通过 `stepper_event()`结束步进事件的生成。该代码会基于queue_step命令的参数生成步进脉冲，并安排下一次步进脉冲生成的时间。硬件定时器发出中断，在设定的事件调用相应的stepper_event。queue_step命令的参数包含“间隔”、“计数”、“增量”。总体而言，stepper_event()将执行下列内容，“记录时间”: `do_step(); next_wake_time = last_wake_time + interval; interval += add;`

上面的运动过程看似十分复杂。然而，真正需要注意的只有ToolHead（打印头） 和 kinematic （运动学）类，上述两个类的代码确定了运动执行和定时。剩下的代码仅用于处理通讯和管道的问题。

## 添加上位机模块

Klippy上位机的主程序能对模块进行热加载。如果设置文件中出现了类似"[my_module]" 的字段名，程序会自动尝试加载 klippy/extras/my_module.py 文件内的模块。Klipper推荐使用上述方式扩展Klipper功能。

新增模块的最简单的方式是参照已有的模块 - 下面将以 **klippy/extras/servo.py **作为例子。

下面是另一些有用的信息：

* 模块的运作起始于模块级别的`load_config()`函数（针对形如 [my_module] 的配置块）或`load_config_prefix()`（对 [my_module my_name] 配置块）。该方法将接受一个 "config" 对象并必须返回一个与目标功能相关的新"printer object"。
* 在创建新"printer object"的实例时，可以使用"config"对象读取配置文件中相应配置块中的信息。此时可使用 `config.get()`，`config.getfloat()`， `config.getint()`等方法。应确保所需的参数在 "printer object" 构建阶段时完成读取。如果用户参数没有在该阶段完成读取，程序将认为这是配置中的错字，并抛出异常。
* 使用 `config.get_printer()` 方法获取主"printer"类的引用。该"printer"类存储了所有实例化了的"printer objects"的引用。使用`printer.lookup_object()`方法获取其他"printer objects"的引用。几乎全部的功能（包括运动控制模块）都包装为"printer objects"。需要注意的是，当一个新模块实例化的时候，并非所有其他的"printer objects"均已完成实例化。其中"gcode"和"pins"模块总是可用，但对于其他模块最好推迟查找。
* 如果代码需要在其他"printer objects"发起事件（event）时被调用，可通过`printer.register_event_handler()`注册事件处理函数。每个事件的名称是一个字符串，按照惯例，它是引发该事件的主要源模块的名称，以及正在发生的动作的简短名称（例如，"klippy:connect"）。传递给事件处理函数的参数因处理函数而异（异常处理和执行环境也是如此）。常见的两种起始事件为：
   * klippy:connect - 该事件在所有 "printer objects" 实例化后发起。它通常用于查找其他"printer objects"，核实配置，并与mcu进行初始握手。
   * klippy:ready - 该事件在所有connect处理程序成功地完成后发起。它意味着打印机转为等待常规指令的待命状态。不应在该回调函数中抛出异常。
* 如果用户配置中存在错误，应在`load_config()`或连接事件（connect event）中抛出异常。使用 `raise config.error("my error")` 或 `raise printer.config_error("my error")` 进行告警。
* 使用"pins"模块对微控制器的引脚进行定义，例如`printer.lookup_object("pins").setup_pin("pwm", config.get("my_pin"))`。此后，运行时，可通过返回的对象对针脚进行控制。
* 如果模块需要使用系统时钟或外部文件描述符，可通过`printer.get_reactor()`对获取全局事件反应器进行访问（event reactor）。通过该反应器类可以部署定时器，等待文件描述符输入，或者“挂起”上位机程序。
* 不应使用全局变量。全部状态量应存储于 "printer objects"，并通过 `load_config()`进行访问。否则，RESTART命令的行为将无法预测。同样，任何在运行时打开的外部文件（或套接字），应在"klippy:disconnect"的事件内注册相应的回调函数进行关闭。
* 应避免访问其他"printer objects"私有对象属性（或调用命名以下划线开始的方法）。遵循这一方式可方便之后的变更。
* 若需向 klipper 母分支提交模块的代码，请在模块代码的头部加入版权声明。详请参考已有模块的格式。

## 增加新运动学模型

本节将提供为Klipper增加新运动学模型的提示。这需要对目标运动学方程有深入的了解。这同时需要一定的软件开发技巧——尽管人们应该只需要更新上位机软件。

步骤：

1. 开始应研究 "[移动命令的代码流](#code-flow-of-a-move-command)" 章节和 [动力学文档](Kinematics.md).
1. 参考位于klippy/kinematics/目录已有的运动学类。动力学类旨在将一个笛卡尔坐标系中的运动转化为各个步进电机的运动。建议复制已有的代码，并在其基础上进行修改。
1. Implement the C stepper kinematic position functions for each stepper if they are not already available (see kin_cart.c, kin_corexy.c, and kin_delta.c in klippy/chelper/). The function should call `move_get_coord()` to convert a given move time (in seconds) to a cartesian coordinate (in millimeters), and then calculate the desired stepper position (in millimeters) from that cartesian coordinate.
1. Implement the `calc_position()` method in the new kinematics class. This method calculates the position of the toolhead in cartesian coordinates from the position of each stepper. It does not need to be efficient as it is typically only called during homing and probing operations.
1. Other methods. Implement the `check_move()`, `get_status()`, `get_steppers()`, `home()`, and `set_position()` methods. These functions are typically used to provide kinematic specific checks. However, at the start of development one can use boiler-plate code here.
1. Implement test cases. Create a g-code file with a series of moves that can test important cases for the given kinematics. Follow the [debugging documentation](Debugging.md) to convert this g-code file to micro-controller commands. This is useful to exercise corner cases and to check for regressions.

## Porting to a new micro-controller

This section provides some tips on porting Klipper's micro-controller code to a new architecture. This type of activity requires good knowledge of embedded development and hands-on access to the target micro-controller.

步骤：

1. Start by identifying any 3rd party libraries that will be used during the port. Common examples include "CMSIS" wrappers and manufacturer "HAL" libraries. All 3rd party code needs to be GNU GPLv3 compatible. The 3rd party code should be committed to the Klipper lib/ directory. Update the lib/README file with information on where and when the library was obtained. It is preferable to copy the code into the Klipper repository unchanged, but if any changes are required then those changes should be listed explicitly in the lib/README file.
1. Create a new architecture sub-directory in the src/ directory and add initial Kconfig and Makefile support. Use the existing architectures as a guide. The src/simulator provides a basic example of a minimum starting point.
1. The first main coding task is to bring up communication support to the target board. This is the most difficult step in a new port. Once basic communication is working, the remaining steps tend to be much easier. It is typical to use an RS-232 style serial port during initial development as these types of hardware devices are generally easier to enable and control. During this phase, make liberal use of helper code from the src/generic/ directory (check how src/simulator/Makefile includes the generic C code into the build). It is also necessary to define timer_read_time() (which returns the current system clock) in this phase, but it is not necessary to fully support timer irq handling.
1. Get familiar with the the console.py tool (as described in the [debugging document](Debugging.md)) and verify connectivity to the micro-controller with it. This tool translates the low-level micro-controller communication protocol to a human readable form.
1. Add support for timer dispatch from hardware interrupts. See Klipper [commit 970831ee](https://github.com/KevinOConnor/klipper/commit/970831ee0d3b91897196e92270d98b2a3067427f) as an example of steps 1-5 done for the LPC176x architecture.
1. Bring up basic GPIO input and output support. See Klipper [commit c78b9076](https://github.com/KevinOConnor/klipper/commit/c78b90767f19c9e8510c3155b89fb7ad64ca3c54) as an example of this.
1. Bring up additional peripherals - for example see Klipper commit [65613aed](https://github.com/KevinOConnor/klipper/commit/65613aeddfb9ef86905cb1dade9e773a02ef3c27), [c812a40a](https://github.com/KevinOConnor/klipper/commit/c812a40a3782415e454b04bf7bd2158a6f0ec8b5), and [c381d03a](https://github.com/KevinOConnor/klipper/commit/c381d03aad5c3ee761169b7c7bced519cc14da29).
1. Create a sample Klipper config file in the config/ directory. Test the micro-controller with the main klippy.py program.
1. Consider adding build test cases in the test/ directory.

## Coordinate Systems

Internally, Klipper primarily tracks the position of the toolhead in cartesian coordinates that are relative to the coordinate system specified in the config file. That is, most of the Klipper code will never experience a change in coordinate systems. If the user makes a request to change the origin (eg, a `G92` command) then that effect is obtained by translating future commands to the primary coordinate system.

However, in some cases it is useful to obtain the toolhead position in some other coordinate system and Klipper has several tools to facilitate that. This can be seen by running the GET_POSITION command. For example:

```
Send: GET_POSITION
Recv: // mcu: stepper_a:-2060 stepper_b:-1169 stepper_c:-1613
Recv: // stepper: stepper_a:457.254159 stepper_b:466.085669 stepper_c:465.382132
Recv: // kinematic: X:8.339144 Y:-3.131558 Z:233.347121
Recv: // toolhead: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode base: X:0.000000 Y:0.000000 Z:0.000000 E:0.000000
Recv: // gcode homing: X:0.000000 Y:0.000000 Z:0.000000
```

The "mcu" position (`stepper.get_mcu_position()` in the code) is the total number of steps the micro-controller has issued in a positive direction minus the number of steps issued in a negative direction since the micro-controller was last reset. If the robot is in motion when the query is issued then the reported value includes moves buffered on the micro-controller, but does not include moves on the look-ahead queue.

The "stepper" position (`stepper.get_commanded_position()`) is the position of the given stepper as tracked by the kinematics code. This generally corresponds to the position (in mm) of the carriage along its rail, relative to the position_endstop specified in the config file. (Some kinematics track stepper positions in radians instead of millimeters.) If the robot is in motion when the query is issued then the reported value includes moves buffered on the micro-controller, but does not include moves on the look-ahead queue. One may use the `toolhead.flush_step_generation()` or `toolhead.wait_moves()` calls to fully flush the look-ahead and step generation code.

The "kinematic" position (`kin.calc_position()`) is the cartesian position of the toolhead as derived from "stepper" positions and is relative to the coordinate system specified in the config file. This may differ from the requested cartesian position due to the granularity of the stepper motors. If the robot is in motion when the "stepper" positions are taken then the reported value includes moves buffered on the micro-controller, but does not include moves on the look-ahead queue. One may use the `toolhead.flush_step_generation()` or `toolhead.wait_moves()` calls to fully flush the look-ahead and step generation code.

The "toolhead" position (`toolhead.get_position()`) is the last requested position of the toolhead in cartesian coordinates relative to the coordinate system specified in the config file. If the robot is in motion when the query is issued then the reported value includes all requested moves (even those in buffers waiting to be issued to the stepper motor drivers).

The "gcode" position is the last requested position from a `G1` (or `G0`) command in cartesian coordinates relative to the coordinate system specified in the config file. This may differ from the "toolhead" position if a g-code transformation (eg, bed_mesh, bed_tilt, skew_correction) is in effect. This may differ from the actual coordinates specified in the last `G1` command if the g-code origin has been changed (eg, `G92`, `SET_GCODE_OFFSET`, `M221`). The `M114` command (`gcode_move.get_status()['gcode_position']`) will report the last g-code position relative to the current g-code coordinate system.

The "gcode base" is the location of the g-code origin in cartesian coordinates relative to the coordinate system specified in the config file. Commands such as `G92`, `SET_GCODE_OFFSET`, and `M221` alter this value.

The "gcode homing" is the location to use for the g-code origin (in cartesian coordinates relative to the coordinate system specified in the config file) after a `G28` home command. The `SET_GCODE_OFFSET` command can alter this value.

## Time

Fundamental to the operation of Klipper is the handling of clocks, times, and timestamps. Klipper executes actions on the printer by scheduling events to occur in the near future. For example, to turn on a fan, the code might schedule a change to a GPIO pin in a 100ms. It is rare for the code to attempt to take an instantaneous action. Thus, the handling of time within Klipper is critical to correct operation.

There are three types of times tracked internally in the Klipper host software:

* System time. The system time uses the system's monotonic clock - it is a floating point number stored as seconds and it is (generally) relative to when the host computer was last started. System times have limited use in the software - they are primarily used when interacting with the operating system. Within the host code, system times are frequently stored in variables named *eventtime* or *curtime*.
* Print time. The print time is synchronized to the main micro-controller clock (the micro-controller defined in the "[mcu]" config section). It is a floating point number stored as seconds and is relative to when the main mcu was last restarted. It is possible to convert from a "print time" to the main micro-controller's hardware clock by multiplying the print time by the mcu's statically configured frequency rate. The high-level host code uses print times to calculate almost all physical actions (eg, head movement, heater changes, etc.). Within the host code, print times are generally stored in variables named *print_time* or *move_time*.
* MCU clock. This is the hardware clock counter on each micro-controller. It is stored as an integer and its update rate is relative to the frequency of the given micro-controller. The host software translates its internal times to clocks before transmission to the mcu. The mcu code only ever tracks time in clock ticks. Within the host code, clock values are tracked as 64bit integers, while the mcu code uses 32bit integers. Within the host code, clocks are generally stored in variables with names containing *clock* or *ticks*.

Conversion between the different time formats is primarily implemented in the **klippy/clocksync.py** code.

Some things to be aware of when reviewing the code:

* 32bit and 64bit clocks: To reduce bandwidth and to improve micro-controller efficiency, clocks on the micro-controller are tracked as 32bit integers. When comparing two clocks in the mcu code, the `timer_is_before()` function must always be used to ensure integer rollovers are handled properly. The host software converts 32bit clocks to 64bit clocks by appending the high-order bits from the last mcu timestamp it has received - no message from the mcu is ever more than 2^31 clock ticks in the future or past so this conversion is never ambiguous. The host converts from 64bit clocks to 32bit clocks by simply truncating the high-order bits. To ensure there is no ambiguity in this conversion, the **klippy/chelper/serialqueue.c** code will buffer messages until they are within 2^31 clock ticks of their target time.
* Multiple micro-controllers: The host software supports using multiple micro-controllers on a single printer. In this case, the "MCU clock" of each micro-controller is tracked separately. The clocksync.py code handles clock drift between micro-controllers by modifying the way it converts from "print time" to "MCU clock". On secondary mcus, the mcu frequency that is used in this conversion is regularly updated to account for measured drift.
