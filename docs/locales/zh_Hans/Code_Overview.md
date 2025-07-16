# 代码总览

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

任务、初始化和命令函数始终在启用中断的情况下运行（但是，如果需要，它们可以暂时禁用中断）。这些函数应避免长时间的暂停、延迟或执行持续很长时间的工作。（这些“任务”功能中的长时间延迟会导致其他“任务”的调度抖动 - 超过100us的延迟可能会变得明显，超过500us的延迟可能导致命令重传，超过100ms的延迟可能导致看门狗触发重启。这些函数通过调度计时器在特定时间安排工作。

定时函数通过调用sched_add_timer() (即 **src/sched.c**)方法进行注册。调度器会在设定的时间点对注册的函数进行调用。定时器中断会在微处理器架构特定的初始化处理器中处理(例如 **src/avr/timer.c**)，该代码会调用 **src/sched.c**中的sched_timer_dispatch()。通过定时器中断执行注册的定时函数。定时函数总在中断禁用下运行。定时函数应总能在数微秒内完成。在定时函数结束时，该函数可对自身进行重新定时。

如果事件中抛出错误， 代码可调用shutdown()（**src/sched.c**中的sched_shutdown()）。调用shutdown()会导致所有标记为DECL_SHUTDOWN()宏的函数被运行。shutdown()总是在禁用中断的情况下运行。

微控制器的大部分功能涉及到通用输入输出引脚（GPIO）的操作。为了从高级任务代码中抽象出特定架构底层代码，所有的GPIO事件都在特定架构的包装器中实现（如，**src/avr/gpio.c**）。代码使用gcc的"-flto -fwhole-program "来优化编译，以实现内联函数的高性能交叉编译，大多数微小的GPIO操作函数内联到它们的调用器中，使用这些GPIO将没有任何运行时成本。

## 代码总览

上位机程序（klippy）运行在廉价计算机（如 树莓派）上，配搭mcu使用。该程序的主要编程语言为Python，同时部分功能通过CFFI在C语言上实现。

上位机程序通过** klippy/klippy.py**初始化。该文件会读取命令行参数，打开打印机的设置文件，实例化打印机的主要模块，并启用串口通讯。G代码命令的执行则通过 **klippy/gcode.py**中的 process_commands() 方法实现。此代码将G代码转化为打印机的对象调用，它将频繁地将G代码命令转化为微控制器的行动指令（通过微控制器代码中的 DECL_COMMAND 进行声明）。

Klippy上位机程序包含四个进程。主线程用于处理输入的G代码命令。第二线程通过串口实现底层IO的处理（代码位于 **klippy/chelper/serialqueue.c **以C语言实现）。第三线程则通过Python代码处理微控制器返回的信息（参照 klippy/serialhdl.py）。第四线程则负责将Debug信息写入到日志文件(见 **klippy/queuelogger.py**)，由此，其他线程的执行将不会阻塞日志的写入。

## 典型运动命令的代码流

典型的打印机运动始于klipper上位机接收到"G1"命令，并在微控制器发出对应的步进脉冲结束。本节将简述典型运动命令的代码流。[运动学](Kinematics.md)文档将更为细致的描述运动的机械原理。

* 移动命令的处理始于gcode.py，该代码将G代码转化为内部调用。G1命令将调用klippy/extras/gcode_move.py中的cmd_G1()函数。gcode_move.py中的代码将处理 原点变换（G92），绝对坐标模式（G90）和单位变换（如F6000=100mm/s）。一个移动命令的处理路径为：`_process_data() -> _process_commands() -> cmd_G1()`。最终将调用ToolHead类的方法实现移动 `cmd_G1() -> ToolHead.move()`
* The ToolHead class (in toolhead.py) handles "look-ahead" and tracks the timing of printing actions. The main codepath for a move is: `ToolHead.move() -> LookAheadQueue.add_move() -> LookAheadQueue.flush() -> Move.set_junction() -> ToolHead._process_moves()`.

   * ToolHead.move()将创建一个Move()对象实例，其中将包含移动的参数（在笛卡尔空间中，并这些参数以mm和s为单位）。
   * kinematics类将检查每个运动命令（`ToolHead.move() -> kin.check_move()`）。各种kinematics类存放于 klippy/kinematics/ 目录。check_move()能在运动命令不合理时抛出错误。如果 check_move()成功，这意味着打印机必定能完成运动命令。
   * LookAheadQueue.add_move() places the move object on the "look-ahead" queue.
   * LookAheadQueue.flush() determines the start and end velocities of each move.
   * Move.set_junction()实现移动的“梯形加减速（trapezoid generator）”。“梯形加减速”将每次移动拆分为三部分：恒加速度加速阶段、恒速度阶段、恒加速度减速阶段。所有移动均含有上述三个阶段，但单个阶段的持续时间可能为0。
   * 当ToolHead._process_moves()被调用时，一次移动的所有要素均已就绪——移动的起始位置、结束位置、加速度、起始/巡航/结束速度、以及起始/巡航/结束的距离。所有信息以笛卡尔坐标的形式存储在Move()实例中，单位为mm和s。
* Klipper uses an [iterative solver](https://en.wikipedia.org/wiki/Root-finding_algorithm) to generate the step times for each stepper. For efficiency reasons, the stepper pulse times are generated in C code. The moves are first placed on a "trapezoid motion queue": `ToolHead._process_moves() -> trapq_append()` (in klippy/chelper/trapq.c). The step times are then generated: `ToolHead._process_moves() -> ToolHead._advance_move_time() -> ToolHead._advance_flush_time() -> MCU_Stepper.generate_steps() -> itersolve_generate_steps() -> itersolve_gen_steps_range()` (in klippy/chelper/itersolve.c). The goal of the iterative solver is to find step times given a function that calculates a stepper position from a time. This is done by repeatedly "guessing" various times until the stepper position formula returns the desired position of the next step on the stepper. The feedback produced from each guess is used to improve future guesses so that the process rapidly converges to the desired time. The kinematic stepper position formulas are located in the klippy/chelper/ directory (eg, kin_cart.c, kin_corexy.c, kin_delta.c, kin_extruder.c).
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
* Do not store a reference to the `config` object in a class member variable (nor in any similar location that may persist past initial module loading). The `config` object is a reference to a "config loading phase" class and it is not valid to invoke its methods after the "config loading phase" has completed.
* 使用"pins"模块对微控制器的引脚进行定义，例如`printer.lookup_object("pins").setup_pin("pwm", config.get("my_pin"))`。此后，运行时，可通过返回的对象对针脚进行控制。
* 如果打印机对象中定义了 `get_status()` 方法，则在模块中可以通过[宏](Command_Templates.md)或[API服务](API_Server.md)输出[状态信息](Status_Reference.md)。 `get_status()` 必须返回一个Python字典对象，其键需要为字符串，而值应为整形、浮点数、列表、字典、True、False或者None。元组（或命名元组）也可以作为值（它们在API服务中将被视为列表）。列表和字典的输出值必须为“不可变的（immutable）”，即在函数内，如果 `get_status()` 需要输出上述类型的实例，则需要新建或者进行深层复制，否则API服务会识别出输出值中的内容变更。
* 如果模块需要使用系统时钟或外部文件描述符，可通过`printer.get_reactor()`对获取全局事件反应器进行访问（event reactor）。通过该反应器类可以部署定时器，等待文件描述符输入，或者“挂起”上位机程序。
* 不应使用全局变量。全部状态量应存储于 "printer objects"，并通过 `load_config()`进行访问。否则，RESTART命令的行为将无法预测。同样，任何在运行时打开的外部文件（或套接字），应在"klippy:disconnect"的事件内注册相应的回调函数进行关闭。
* 应避免访问其他"printer objects"私有对象属性（或调用命名以下划线开始的方法）。遵循这一方式可方便之后的变更。
* 推荐在类的工厂函数中将所有成员变量实例化（即避免使用Python的动态变动成员变量的功能。）
* 若一Python变量存放有一浮点数，那么建议该变量应总赋予浮点类型的量，并仅使用浮点数常量进行值运算（并绝不使用整形常数进行运算）。例如，应使用`self.speed = 1.`而非`self.speed = 1`，并以`self.speed = 2. * x` 替代 ` self.speed = 2 *x`。一致地使用浮点值可以避免Python类型转换中难以调试的怪异现象。
* 若需向 klipper 母分支提交模块的代码，请在模块代码的头部加入版权声明。详请参考已有模块的格式。

## 增加新运动学模型

本节将提供为Klipper增加新运动学模型的提示。这需要对目标运动学方程有深入的了解。这同时需要一定的软件开发技巧—尽管大多情况下只需要更新上位机软件。

有用的步骤：

1. 开始应研究 "[移动命令工作流](#code-flow-of-a-move-command)" 章节和 [动力学](Kinematics.md).
1. 参考位于klippy/kinematics/目录已有的运动学类。动力学类旨在将一个笛卡尔坐标系中的运动转化为各个步进电机的运动。建议复制已有的代码，并在其基础上进行修改。
1. 若需要的运动学方程未被Klipper涵盖，则应使用C语言实现新动力学体系中各个步进电机的位置方程（见klippy/chelper/，如kin_cart.c, kin_corexy.c, and kin_delta.c）。位置方程中应调用`move_get_coord()`以将运动的时间点（单位 ：秒）转化为对应的笛卡尔坐标位置（单位：毫米），进而计算目标步进电机运动目标位置（单位：毫米）。
1. 在新的运动学类中实现`calc_position`方法。该方法将通过各个步进电机的位置计算笛卡尔坐标系下的打印头位置；同时该方法通常只在回零和z探测时使用，因此无需过分追求效率。
1. Other methods. Implement the `check_move()`, `get_status()`, `get_steppers()`, `home()`, `clear_homing_state()`, and `set_position()` methods. These functions are typically used to provide kinematic specific checks. However, at the start of development one can use boiler-plate code here.
1. 添加测试实例。创建一个G代码文件，其中包含一系列的运动命令用于测试新增的运动学模型。 按照[调试文档](Debugging.md)将该G代码文件转换为微控制器命令。在遭遇困难状况和检查数据传递相当有用。

## 移植到新的微控制器

该节将介绍将Klipper微控制器代码移植到新架构时的一些提示。该操作将需要对嵌入式开发有一定的认识并应有目标微控制器的开发平台。

有用的步骤：

1. 首先应确定移植所需的第三方库。常见的例子为“CMSIS”包装器和厂商的“HAL”库。全部第三方代码应遵循或兼容GNU GPLv3协议。第三方代码应提交到Klipper的/lib文件夹。更新lib/README注明第三方库的获取途径和更新时间。推荐不改变内容，直接将代码复制到Klipper，但如果需要进行变更，应将所做的修改列在lib/README文件中。
1. 在src/下新建一个新架构的子目录，并创建对应的初始Kconfig和Makefile。以已有的架构作为模版，其中src/simulator给出了微控制器架构的基本需求。
1. 首要任务是在目标打印机主板上实现通讯。这是增加支持中最难的一步，实现该功能后一切将阔然开朗。在开荒时，一般使用串行总线进行开发，因为通常串行总线已于应用和控制。在此阶段，可大量使用 src/generic/ 目录中的中的辅助代码（可参考 src/simulator/Makefile 中如何将上述代码加入构建）。同时，需要在这阶段完成 timer_read_time() 的定义（用于获取现时系统时钟），但无需完全实现定时中断功能。
1. 依照[调试文档](Debugging.md)熟悉console.py工具，并使用该工具核实微控制器的连接。该工具将底层微控制器通讯协议转换为可读形式。
1. 增加对硬件中断的定时器调度的支持。参见 Klipper [commit 970831ee](https://github.com/Klipper3d/klipper/commit/970831ee0d3b91897196e92270d98b2a3067427f)，作为针对LPC176x架构的步骤1-5的例子。
1. 提供基本的 GPIO 输入和输出支持。参见 Klipper [commit c78b9076](https://github.com/Klipper3d/klipper/commit/c78b90767f19c9e8510c3155b89fb7ad64ca3c54) 作为一个例子。
1. 启动其他外围设备-参阅Klipper提交[65613aed](https://github.com/Klipper3d/klipper/commit/65613aeddfb9ef86905cb1dade9e773a02ef3c27)，[c812a40a](https://github.com/Klipper3d/klipper/commit/c812a40a3782415e454b04bf7bd2158a6f0ec8b5)，和[c381d03a](https://github.com/Klipper3d/klipper/commit/c381d03aad5c3ee761169b7c7bced519cc14da29)的例子。
1. 在config/目录新建一个配置事例，并使用Klipper.py的主程序进行设置。
1. 考虑在test/目录加入构建测试的事例。

还有一些tips：

1. 避免使用“C位段”（C bitfield）访问IO寄存器；应使用直接对32位、16位和8位的整数读写代替。C语言规范中没有对位段操作进行清晰定义（例如端序、字布局等），且在IO操作时使用C段位读写，将难以确定具体进行了何种IO操作。
1. IO寄存器操作时应使用显式赋值，避免使用“读-改-写”。也就是说，如果在一个IO寄存器中更新一个字段，而其他字段的值是已知的，那么最好是显式地写入寄存器的全部内容。显式写入产生的代码更小，更快，更容易调试。

## 坐标系变换

内部而言，Klipper使用笛卡尔坐标系追踪打印头的位置，其坐标系设置相对于设置文件中的坐标系而变化。因此，KIlipper的执行在绝大部分情况下都不会变换坐标系。如果用户进行原点的变换（如执行`G92`命令），Klipper会将后续命令转化到原始坐标系上进行执行。

然而，在部分情况下，需要获取其他坐标系中打印头的位置。Klipper提供数种工具以实现上述功能。运行GET_POSITION可以获得上述数据，如：

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

“微控制器位置”（`stepper.get_mcu_position()`）是微控制器最后一次重置后执行的“正向”步数总数 - “负向”步数总数的值。如果设备处于机械运动时，该方法将返回包含运动缓冲区中的位置值，但不包含预计队列中的运动值。

“步进电机”部分（`stepper.get_commanded_position()`）是运动学模型中记录的特定步进电机位置。通常是对应轨道的相对于设定中的position_endstop设定值的滑车位置（单位为毫米，但部分设定中使用的是弧度单位而非线性单位）。如果在机械运动时触发上述代码，则返回的值为微控制器中缓存的位置，而不包含预计队列（look-ahead queue）中的预计位置。可使用`toolhead.flush_step_generation()`或`toolhead.wati_moves()`调用完全刷新预计队列和步进脉冲生成代码。

运动学位置（`kin.cal_position()`）是在笛卡尔坐标上的，衍生于步进电机位置的，相对于设置文件中position_endstop值的位置。由于步进电机的分辨率原因，这可能与请求的笛卡尔坐标值不一致。如果在机械运动时触发上述代码，则返回的值为微控制器中缓存的位置，而不包含预计队列（look-ahead queue）中的预计位置。可使用`toolhead.flush_step_generation()`或`toolhead.wati_moves()`调用完全刷新预计队列和步进脉冲生成代码。

打印头位置（`toolhead.get_position()`）是最后的运动请求对应的，相对于设置文件限位位置的，笛卡尔坐标上的打印头位置。如果在机械运动时触发上述代码，那么返回值会依据请求运动序列中的运动终点给出（尽管buffer中的运动还没由步进电机触发）。

G代码位置时最后一次位置请求命令（`G1`或`G0`）对应的，在笛卡尔坐标系中相对设定文件中的设定原点的相对位置。这可能与“打印头位置”不一致，这是因为G代码修正的影响（比如床网，床倾角修正，调平螺母修正）。这也会因为G代码原点变更（如`G92`，`SET_GCODE_OFFSET`，`M221`）而导致返回值跟最后一次`G1`命令请求的位置不一致。`Ｍ114`命令（`gcode_move.get_status()[’gcode_position’]`）会返回现时G代码相对于此时的G代码原点的位置。

G代码基准是笛卡尔坐标系中相对于设定文件中的设定原点的相对位置。诸如`G92`，`SET_GCODE_OFFSET`和`M221`会改变的返回值。

G代码回零点是在`G28`命令执行后G代码原点。同样，该位置是笛卡尔坐标系中，相对于设置文件原点的位置。`SET_GCODE_OFFSET`命令会改变该值。

## 定时

该节将描述Klipper如何处理时钟，定时和时间戳。Klipper通过提前安排需要执行的行为事件从而执行动作。例如，要启动风扇，代码需要安排GPIO针脚在100ms后变化。代码立即执行动作反而是罕见的状况。因此，Klipper的正确运行离不开对时间的精确处理。

Klipper内部使用三种不同的时间：

* 系统时间（System time）。系统时间使用系统的单调时钟。这是一个以秒为单位储存的浮点数，在系统启动后开始累计。系统时钟的用途有限，通常只会在与操作系统进行互动时使用。在上位机中，系统时间保存在*eventtime*或*curtime*变量中。
* 打印时间（Print time）。打印时间会与主微控制器时钟同步（在“[MCU]”设置段中定义的微控制器。）这是一个以秒为单位储存的浮点数，并在主微控制最后一次启动后开始从0累加。通过乘以设定的微控制器频率，可以获得主微控制器内部硬件时钟值。上层应用可以通过打印时间计算几乎所有物理行为（比如打印头运动，加热器变动等）。在上位机代码中，打印时间通常保存在*print_time*和*move_time*变量中。
* MCU时钟，是各个微控制内部的硬件时钟累加器。它是基于微控制器设定频率为速率进行累加的，以整形保存的值。上位机软件将软件内部时间转换为mcu时间并将命令传输到微控制器上。微控制代码仅在时钟跳动时更新和追踪时间。在上位机代码中，时钟值以64位整形记录，而微控制代码则使用32位整形。在上位机代码中，时钟通常以*clock*或*tick*变量保存。

不同时钟格式的转换主要在**klipper/clocksync.py**中实现。

在检查代码时需要注意：

* 32位和64位时钟：为了降低带宽消耗和提高微控制器效率，微控制器时钟使用32位整形进行追踪。在微控制器代码中对比两个时钟时，应保持调用`time_is_before`以确定整形时钟没有出现溢出的情况。上位机软件通过将微控制器最后一次返回的时间戳累加到主机代码时钟的高位地址中，以实现32位时钟到64位时钟的转换，由于来自微控制器的信息不可能来自2^31个时间刻度的过去或未来，因此时间转换不会出现错误。主机通过简单截断高位中的值，实现64位到32位的转换。为了确保转换没有歧义，**klippy/chelper/serialqueque.c**代码会缓存信息直到代码目标时间的2^31个时间刻度内。
* 复数微控制器的情况：上位机软件支持单体打印机使用复数微控制器。此时，各微控制器的“微控制器时钟”将被分开记录。clocksync.py处理微处理器之间的时间飘变，方法在“打印时间”和“微处理器时间”的转换方法上修改得出。在次要微处理上，微处理器频率被用于上述处理，并通过持续测量漂变对次要微控制器频率进行更新。
