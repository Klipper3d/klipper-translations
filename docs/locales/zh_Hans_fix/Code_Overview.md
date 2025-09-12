# 代码概览

本文档描述了 Klipper 的整体代码布局和主要代码流程。

## 目录结构

**src/** 目录包含微控制器代码的 C 源文件。**src/atsam/**、**src/atsamd/**、**src/avr/**、**src/linux/**、**src/lpc176x/**、**src/pru/** 和 **src/stm32/** 目录包含特定于架构的微控制器代码。**src/simulator/** 目录包含代码存根，允许在其他架构上对微控制器代码进行测试编译。**src/generic/** 目录包含在不同架构中可能有用的辅助代码。构建过程会安排对 "board/somefile.h" 的包含首先在当前架构目录（例如 src/avr/somefile.h）中查找，然后在 generic 目录（例如 src/generic/somefile.h）中查找。

**klippy/** 目录包含主机软件。大部分主机软件是用 Python 编写的，但 **klippy/chelper/** 目录包含一些 C 语言辅助代码。**klippy/kinematics/** 目录包含机器人运动学代码。**klippy/extras/** 目录包含主机代码的可扩展“模块”。

**lib/** 目录包含构建某些目标所必需的外部第三方库代码。

**config/** 目录包含示例打印机配置文件。

**scripts/** 目录包含用于编译微控制器代码的构建时脚本。

**test/** 目录包含自动化测试用例。

在编译期间，构建可能会创建一个 **out/** 目录。该目录包含临时的构建时对象。最终生成的微控制器对象在 AVR 上为 **out/klipper.elf.hex**，在 ARM 上为 **out/klipper.bin**。

## 微控制器代码流程

微控制器代码的执行从特定于架构的代码开始（例如 **src/avr/main.c**），最终调用位于 **src/sched.c** 中的 sched_main()。sched_main() 代码首先运行所有使用 DECL_INIT() 宏标记的函数。然后，它会反复运行所有使用 DECL_TASK() 宏标记的函数。

其中一个主要的任务函数是位于 **src/command.c** 中的 command_dispatch()。该函数由特定于板卡的输入/输出代码（例如 **src/avr/serial.c**、**src/generic/serial_irq.c**）调用，并运行与输入流中找到的命令相关联的命令函数。命令函数使用 DECL_COMMAND() 宏声明（更多信息请参见[协议](Protocol.md)文档）。

任务、初始化和命令函数始终在中断启用的情况下运行（不过，如果需要，它们可以暂时禁用中断）。这些函数应避免长时间的暂停、延迟或执行耗时较长的工作。（这些“任务”函数中的长时间延迟会导致其他“任务”的调度抖动——超过 100 微秒的延迟可能会变得明显，超过 500 微秒的延迟可能会导致命令重传，超过 100 毫秒的延迟可能会导致看门狗重启。）这些函数通过调度定时器在特定时间安排工作。

通过调用 sched_add_timer()（位于 **src/sched.c**）来调度定时器函数。调度器代码会安排在请求的时钟时间调用给定函数。定时器中断最初在特定于架构的中断处理程序（例如 **src/avr/timer.c**）中处理，该处理程序调用位于 **src/sched.c** 中的 sched_timer_dispatch()。定时器中断导致执行调度的定时器函数。定时器函数始终在中断禁用的情况下运行。定时器函数应始终在几微秒内完成。在定时器事件完成后，函数可以选择重新调度自身。

如果检测到错误，代码可以调用 shutdown()（一个调用位于 **src/sched.c** 中的 sched_shutdown() 的宏）。调用 shutdown() 会导致所有使用 DECL_SHUTDOWN() 宏标记的函数运行。关闭函数始终在中断禁用的情况下运行。

微控制器的许多功能涉及与通用输入/输出引脚 (GPIO) 的交互。为了将低级特定于架构的代码与高级任务代码分离，所有 GPIO 事件都在特定于架构的包装器中实现（例如 **src/avr/gpio.c**）。代码使用 gcc 的 "-flto -fwhole-program" 优化进行编译，该优化能够出色地在编译单元之间内联函数，因此这些微小的 gpio 函数大多被内联到它们的调用者中，使用它们不会产生运行时成本。

## Klippy 代码概览

主机代码 (Klippy) 旨在运行在与微控制器配对的低成本计算机（例如 Raspberry Pi）上。代码主要用 Python 编写，但它确实使用 CFFI 在 C 代码中实现了一些功能。

初始执行从 **klippy/klippy.py** 开始。它读取命令行参数，打开打印机配置文件，实例化主打印机对象，并启动串行连接。G-code 命令的主要执行在 **klippy/gcode.py** 的 process_commands() 方法中。此代码将 G-code 命令转换为打印机对象调用，这些调用通常将操作转换为要在微控制器上执行的命令（如微控制器代码中的 DECL_COMMAND 宏所声明）。

Klippy 主机代码中有四个线程。主线程处理传入的 gcode 命令。第二个线程（完全位于 **klippy/chelper/serialqueue.c** C 代码中）处理与串行端口的低级 IO。第三个线程用于在 Python 代码中处理来自微控制器的响应消息（参见 **klippy/serialhdl.py**）。第四个线程将调试消息写入日志（参见 **klippy/queuelogger.py**），以便其他线程永远不会因日志写入而阻塞。

## 移动指令的代码流程

典型的打印机移动始于将“G1”命令发送到 Klippy 主机，并在微控制器上产生相应的步进脉冲时完成。本节概述了典型移动指令的代码流程。[运动学](Kinematics.md)文档提供了有关移动机制的进一步信息。

*   移动指令的处理从 gcode.py 开始。gcode.py 的目标是将 G-code 转换为内部调用。G1 命令将调用 klippy/extras/gcode_move.py 中的 cmd_G1()。gcode_move.py 代码处理原点变化（例如 G92）、相对与绝对位置的变化（例如 G90）以及单位变化（例如 F6000=100mm/s）。移动的代码路径为：`_process_data() -> _process_commands() -> cmd_G1()`。最终调用 ToolHead 类来执行实际请求：`cmd_G1() -> ToolHead.move()`

*   ToolHead 类（在 toolhead.py 中）处理“前瞻”并跟踪打印操作的时序。移动的主要代码路径为：`ToolHead.move() -> LookAheadQueue.add_move() -> LookAheadQueue.flush() -> Move.set_junction() -> ToolHead._process_moves()`。
    *   ToolHead.move() 创建一个包含移动参数的 Move() 对象（在笛卡尔空间中，单位为秒和毫米）。
    *   运动学类有机会审核每次移动（`ToolHead.move() -> kin.check_move()`）。运动学类位于 klippy/kinematics/ 目录中。check_move() 代码如果移动无效可能会引发错误。如果 check_move() 成功完成，则底层运动学必须能够处理该移动。
    *   LookAheadQueue.add_move() 将移动对象放置在“前瞻”队列上。
    *   LookAheadQueue.flush() 确定每次移动的开始和结束速度。
    *   Move.set_junction() 在移动上实现“梯形发生器”。 “梯形发生器”将每次移动分为三个部分：恒定加速度阶段，接着是恒定速度阶段，最后是恒定减速度阶段。每次移动都包含这三个按此顺序的阶段，但某些阶段的持续时间可能为零。
    *   当调用 ToolHead._process_moves() 时，移动的所有信息都已知——它的起始位置、结束位置、加速度、起始/巡航/结束速度，以及在加速/巡航/减速期间行进的距离。所有信息都存储在 Move() 类中，以毫米和秒为单位的笛卡尔空间中。

*   Klipper 使用一种[迭代求解器](https://en.wikipedia.org/wiki/Root-finding_algorithm)来生成每个步进电机的步进时间。出于效率考虑，步进脉冲时间在 C 代码中生成。首先将移动放置在“梯形运动队列”上：`ToolHead._process_moves() -> trapq_append()`（在 klippy/chelper/trapq.c 中）。然后生成步进时间：`ToolHead._process_moves() -> ToolHead._advance_move_time() -> ToolHead._advance_flush_time() -> MCU_Stepper.generate_steps() -> itersolve_generate_steps() -> itersolve_gen_steps_range()`（在 klippy/chelper/itersolve.c 中）。迭代求解器的目标是根据给定的时间计算步进位置的函数来找到步进时间。这通过反复“猜测”各种时间直到步进位置公式返回步进电机上下一步的期望位置来完成。每次猜测产生的反馈用于改进未来的猜测，从而使过程快速收敛到期望时间。运动学步进位置公式位于 klippy/chelper/ 目录中（例如 kin_cart.c, kin_corexy.c, kin_delta.c, kin_extruder.c）。

*   请注意，挤出机在自己的运动学类中处理：`ToolHead._process_moves() -> PrinterExtruder.move()`。由于 Move() 类指定了确切的移动时间，并且步进脉冲以特定时序发送到微控制器，因此即使代码是分开的，挤出机类产生的步进移动也将与头部移动同步。

*   在迭代求解器计算出步进时间后，它们被添加到一个数组中：`itersolve_gen_steps_range() -> stepcompress_append()`（在 klippy/chelper/stepcompress.c 中）。该数组（struct stepcompress.queue）存储了每个步进对应的微控制器时钟计数器时间。这里的“微控制器时钟计数器”值直接对应于微控制器的硬件计数器——它相对于微控制器上次通电时是相对的。

*   下一个主要步骤是压缩步进：`stepcompress_flush() -> compress_bisect_add()`（在 klippy/chelper/stepcompress.c 中）。此代码生成并编码一系列微控制器“queue_step”命令，这些命令对应于上一阶段构建的步进时间列表。然后这些“queue_step”命令被排队、优先排序并发送到微控制器（通过 stepcompress.c:steppersync 和 serialqueue.c:serialqueue）。

*   微控制器上对 queue_step 命令的处理从 src/command.c 开始，该文件解析命令并调用 `command_queue_step()`。command_queue_step() 代码（在 src/stepper.c 中）只是将每个 queue_step 命令的参数附加到每个步进电机的队列中。在正常操作下，queue_step 命令的解析和排队至少在第一次步进时间前 100 毫秒完成。最后，步进事件的生成在 `stepper_event()` 中完成。它从硬件定时器中断在第一次步进的预定时间被调用。stepper_event() 代码生成一个步进脉冲，然后重新安排自己在给定 queue_step 参数的下一次步进脉冲时间运行。每个 queue_step 命令的参数是“interval”、“count”和“add”。从高层次来看，stepper_event() 运行以下代码 'count' 次：`do_step(); next_wake_time = last_wake_time + interval; interval += add;`

上述过程似乎很复杂才能执行一次移动。然而，真正有趣的部分只在 ToolHead 和运动学类中。正是代码的这一部分指定了移动及其时序。其余的处理部分大多只是通信和管道。

## 添加主机模块

Klippy 主机代码具有动态模块加载功能。如果在打印机配置文件中找到名为 “[my_module]” 的配置部分，则软件将自动尝试加载 Python 模块 klippy/extras/my_module.py。这种模块系统是向 Klipper 添加新功能的首选方法。

添加新模块最简单的方法是使用现有模块作为参考——例如参见 **klippy/extras/servo.py**。

以下内容也可能有用：
*   模块的执行从模块级别的 `load_config()` 函数（对于形式为 [my_module] 的配置部分）或 `load_config_prefix()`（对于形式为 [my_module my_name] 的配置部分）开始。此函数接收一个“config”对象，必须返回一个与给定配置部分相关联的新“printer object”。
*   在实例化新的打印机对象过程中，可以使用 config 对象从给定的配置部分读取参数。这通过 `config.get()`、`config.getfloat()`、`config.getint()` 等方法完成。务必在构造打印机对象期间读取配置中的所有值——如果用户指定了在该阶段未读取的配置参数，则会被认为是配置中的拼写错误，并引发错误。
*   使用 `config.get_printer()` 方法获取对主“printer”类的引用。这个“printer”类存储了所有已实例化的“printer objects”的引用。使用 `printer.lookup_object()` 方法查找对其他打印机对象的引用。几乎所有功能（甚至核心运动学模块）都封装在这些打印机对象之一中。但是请注意，当实例化一个新模块时，并非所有其他打印机对象都已实例化。 “gcode”和“pins”模块将始终可用，但对于其他模块，最好推迟查找。
*   如果代码需要在其他打印机对象引发的“事件”期间被调用，请使用 `printer.register_event_handler()` 方法注册事件处理程序。每个事件名称都是一个字符串，按照惯例，它是引发事件的主源模块的名称以及正在发生的操作的简短名称（例如，“klippy:connect”）。传递给每个事件处理程序的参数特定于给定事件（异常处理和执行上下文也是如此）。两个常见的启动事件是：
    *   klippy:connect - 在所有打印机对象实例化后生成。它通常用于查找其他打印机对象，验证配置设置，并与打印机硬件进行初始“握手”。
    *   klippy:ready - 在所有连接处理程序成功完成后生成。它表示打印机正在过渡到准备处理正常操作的状态。不要在此回调中引发错误。
*   如果用户的配置中有错误，请务必在 `load_config()` 或“连接事件”阶段引发它。使用 `raise config.error("my error")` 或 `raise printer.config_error("my error")` 报告错误。
*   不要将 `config` 对象的引用存储在类成员变量中（或任何类似在初始模块加载后可能持续存在的位置）。`config` 对象是对“配置加载阶段”类的引用，在“配置加载阶段”完成后调用其方法是无效的。
*   使用“pins”模块在微控制器上配置引脚。这通常通过类似 `printer.lookup_object("pins").setup_pin("pwm", config.get("my_pin"))` 的代码完成。然后可以在运行时控制返回的对象。
*   如果打印机对象定义了 `get_status()` 方法，则该模块可以通过[宏](Command_Templates.md)和[API 服务器](API_Server.md)导出[状态信息](Status_Reference.md)。`get_status()` 方法必须返回一个 Python 字典，其键为字符串，值为整数、浮点数、字符串、列表、字典、True、False 或 None。元组（和命名元组）也可以使用（这些在通过 API 服务器访问时显示为列表）。导出的列表和字典必须被视为“不可变”——如果其内容发生变化，则必须从 `get_status()` 返回一个新对象，否则 API 服务器将无法检测到这些变化。
*   如果模块需要访问系统定时或外部文件描述符，则使用 `printer.get_reactor()` 获取对全局“事件反应器”类的访问。该反应器类允许您安排定时器、等待文件描述符上的输入以及“休眠”主机代码。
*   不要使用全局变量。所有状态都应存储在 `load_config()` 函数返回的打印机对象中。这一点很重要，否则 RESTART 命令可能无法按预期执行。同样出于类似原因，如果打开了任何外部文件（或套接字），请务必注册一个“klippy:disconnect”事件处理程序并在该回调中关闭它们。
*   避免访问其他打印机对象的内部成员变量（或调用以下划线开头的方法）。遵守此约定有助于更轻松地管理未来的更改。
*   建议在 Python 类的 Python 构造函数中为所有成员变量赋值。（因此避免利用 Python 动态创建新成员变量的能力。）
*   如果 Python 变量要存储浮点数值，则建议始终使用浮点常量赋值和操作该变量（切勿使用整数常量）。例如，优先使用 `self.speed = 1.` 而不是 `self.speed = 1`，优先使用 `self.speed = 2. * x` 而不是 `self.speed = 2 * x`。一致使用浮点值可以避免 Python 类型转换中难以调试的怪异问题。
*   如果要将模块提交给主 Klipper 代码，请务必在模块顶部放置版权声明。请参阅现有模块以了解首选格式。

## 添加新的运动学

本节提供了一些关于向 Klipper 添加对额外类型打印机运动学支持的提示。这类活动需要对目标运动学的数学公式有出色的理解。它还需要软件开发技能——尽管您只需要更新主机软件。

有用的步骤：
1.  首先学习[移动代码流程](#code-flow-of-a-move-command)部分和[运动学文档](Kinematics.md)。
2.  查看 klippy/kinematics/ 目录中的现有运动学类。运动学类的任务是将笛卡尔坐标中的移动转换为每个步进电机上的移动。您应该能够复制其中一个文件作为起点。
3.  实现每个步进电机的 C 步进运动学位置函数（如果尚不可用）（参见 klippy/chelper/ 中的 kin_cart.c、kin_corexy.c 和 kin_delta.c）。该函数应调用 `move_get_coord()` 将给定的移动时间（以秒为单位）转换为笛卡尔坐标（以毫米为单位），然后从该笛卡尔坐标计算所需的步进电机位置（以毫米为单位）。
4.  在新的运动学类中实现 `calc_position()` 方法。此方法根据每个步进电机的位置计算工具头在笛卡尔坐标中的位置。它不需要高效，因为它通常只在归位和探测操作期间调用。
5.  其他方法。实现 `check_move()`、`get_status()`、`get_steppers()`、`home()`、`clear_homing_state()` 和 `set_position()` 方法。这些函数通常用于提供运动学特定的检查。然而，在开发初期，可以在此处使用样板代码。
6.  实现测试用例。创建一个包含一系列移动的 g-code 文件，以测试给定运动学的重要情况。遵循[调试文档](Debugging.md)将此 g-code 文件转换为微控制器命令。这对于测试边界情况和检查回归非常有用。

## 移植到新的微控制器

本节提供了一些将 Klipper 微控制器代码移植到新架构的提示。这类活动需要对嵌入式开发有深入了解，并能直接访问目标微控制器。

有用的步骤：
1.  首先确定在移植过程中将使用的任何第三方库。常见示例包括“CMSIS”包装器和制造商“HAL”库。所有第三方代码都需要与 GNU GPLv3 兼容。第三方代码应提交到 Klipper lib/ 目录。在 lib/README 文件中更新有关库的获取位置和时间的信息。最好将代码原封不动地复制到 Klipper 仓库中，但如果需要任何更改，则应在 lib/README 文件中明确列出这些更改。
2.  在 src/ 目录中创建一个新的架构子目录，并添加初始的 Kconfig 和 Makefile 支持。以现有架构为指南。src/simulator 提供了最小启动点的基本示例。
3.  第一个主要编码任务是启动与目标板的通信支持。这是新移植中最困难的步骤。一旦基本通信正常工作，剩余的步骤通常会容易得多。在初始开发期间，通常使用 UART 类型的串行设备，因为这类硬件设备通常更容易启用和控制。在此阶段，充分利用 src/generic/ 目录中的辅助代码（检查 src/simulator/Makefile 如何将通用 C 代码包含到构建中）。在此阶段还需要定义 timer_read_time()（返回当前系统时钟），但不需要完全支持定时器 irq 处理。
4.  熟悉 console.py 工具（如[调试文档](Debugging.md)中所述），并使用它验证与微控制器的连接。该工具将低级微控制器通信协议转换为人类可读的形式。
5.  添加从硬件中断进行定时器调度的支持。参见 Klipper [commit 970831ee](https://github.com/Klipper3d/klipper/commit/970831ee0d3b91897196e92270d98b2a3067427f) 作为 LPC176x 架构步骤 1-5 的示例。
6.  启动基本的 GPIO 输入和输出支持。参见 Klipper [commit c78b9076](https://github.com/Klipper3d/klipper/commit/c78b90767f19c9e8510c3155b89fb7ad64ca3c54) 作为此步骤的示例。
7.  启动其他外设——例如参见 Klipper commit [65613aed](https://github.com/Klipper3d/klipper/commit/65613aeddfb9ef86905cb1dade9e773a02ef3c27)、[c812a40a](https://github.com/Klipper3d/klipper/commit/c812a40a3782415e454b04bf7bd2158a6f0ec8b5) 和 [c381d03a](https://github.com/Klipper3d/klipper/commit/c381d03aad5c3ee761169b7c7bced519cc14da29)。
8.  在 config/ 目录中创建一个示例 Klipper 配置文件。使用主 klippy.py 程序测试微控制器。
9.  考虑在 test/ 目录中添加构建测试用例。

额外的编码提示：
1.  避免使用“C 位字段”来访问 IO 寄存器；更喜欢对 32 位、16 位或 8 位整数进行直接读写操作。C 语言规范没有明确说明编译器必须如何实现 C 位字段（例如，字节序和位布局），并且很难确定对 C 位字段读写将发生什么 IO 操作。
2.  优先写入显式值到 IO 寄存器，而不是使用读-修改-写操作。也就是说，如果更新 IO 寄存器中的一个字段，而其他字段具有已知值，则最好显式写入寄存器的全部内容。显式写入产生的代码更小、更快且更容易调试。

## 坐标系

在内部，Klipper 主要跟踪工具头在笛卡尔坐标中的位置，该位置相对于配置文件中指定的坐标系。也就是说，Klipper 的大部分代码永远不会经历坐标系的变化。如果用户请求更改原点（例如，`G92` 命令），则通过将未来的命令转换到主坐标系来实现该效果。

然而，在某些情况下，获得工具头在其他坐标系中的位置是有用的，Klipper 有几种工具可以促进这一点。这可以通过运行 GET_POSITION 命令看到。例如：

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

“mcu”位置（代码中的 `stepper.get_mcu_position()`）是微控制器自上次重置以来在正方向发出的总步数减去在负方向发出的步数。如果机器人在发出查询时处于运动状态，则报告的值包括缓冲在微控制器上的移动，但不包括在前瞻队列上的移动。

“stepper”位置（`stepper.get_commanded_position()`）是运动学代码跟踪的给定步进电机的位置。这通常对应于沿其导轨的滑架位置（以 mm 为单位），相对于配置文件中指定的 position_endstop。（某些运动学以弧度而不是毫米跟踪步进电机位置。）如果机器人在发出查询时处于运动状态，则报告的值包括缓冲在微控制器上的移动，但不包括在前瞻队列上的移动。可以使用 `toolhead.flush_step_generation()` 或 `toolhead.wait_moves()` 调用来完全清空前瞻和步进生成代码。

“kinematic”位置（`kin.calc_position()`）是根据“stepper”位置导出的工具头笛卡尔位置，相对于配置文件中指定的坐标系。由于步进电机的粒度，这可能与请求的笛卡尔位置不同。如果在获取“stepper”位置时机器人处于运动状态，则报告的值包括缓冲在微控制器上的移动，但不包括在前瞻队列上的移动。可以使用 `toolhead.flush_step_generation()` 或 `toolhead.wait_moves()` 调用来完全清空前瞻和步进生成代码。

“toolhead”位置（`toolhead.get_position()`）是工具头在笛卡尔坐标中相对于配置文件中指定的坐标系的最后请求位置。如果机器人在发出查询时处于运动状态，则报告的值包括所有请求的移动（甚至那些在缓冲区中等待发送到步进电机驱动器的移动）。

“gcode”位置是来自 `G1`（或 `G0`）命令的最后请求位置，以笛卡尔坐标相对于配置文件中指定的坐标系。如果启用了 g-code 转换（例如，bed_mesh、bed_tilt、skew_correction），则这可能与“toolhead”位置不同。如果 g-code 原点已更改（例如，`G92`、`SET_GCODE_OFFSET`、`M221`），则这可能与最后一个 `G1` 命令中指定的实际坐标不同。`M114` 命令（`gcode_move.get_status()['gcode_position']`）将报告相对于当前 g-code 坐标系的最后 g-code 位置。

“gcode base”是 g-code 原点在笛卡尔坐标中相对于配置文件中指定的坐标系的位置。像 `G92`、`SET_GCODE_OFFSET` 和 `M221` 这样的命令会改变这个值。

“gcode homing”是在 `G28` 归位命令后要用于 g-code 原点的位置（在笛卡尔坐标中相对于配置文件中指定的坐标系）。`SET_GCODE_OFFSET` 命令可以改变这个值。

## 时间

Klipper 正确运行的基础是处理时钟、时间和时间戳。Klipper 通过安排事件在不久的将来发生来在打印机上执行操作。例如，要打开风扇，代码可能会安排在 100 毫秒后更改 GPIO 引脚。代码很少尝试采取即时操作。因此，Klipper 内部的时间处理对于正确操作至关重要。

Klipper 主机软件内部跟踪三种类型的时间：
*   系统时间。系统时间使用系统的单调时钟——它是一个以秒为单位存储的浮点数，通常相对于主机计算机上次启动时。系统时间在软件中的用途有限——它们主要用于与操作系统交互。在主机代码中，系统时间通常存储在名为 *eventtime* 或 *curtime* 的变量中。
*   打印时间。打印时间与主微控制器时钟同步（在 "[mcu]" 配置部分中定义的微控制器）。它是一个以秒为单位存储的浮点数，相对于主 mcu 上次重启时。可以通过将打印时间乘以 mcu 的静态配置频率来将其转换为主微控制器的硬件时钟。高级主机代码使用打印时间来计算几乎所有物理操作（例如，头部移动、加热器变化等）。在主机代码中，打印时间通常存储在名为 *print_time* 或 *move_time* 的变量中。
*   MCU 时钟。这是每个微控制器上的硬件时钟计数器。它以整数形式存储，其更新速率相对于给定微控制器的频率。主机软件在传输到 mcu 之前将其内部时间转换为时钟。mcu 代码只跟踪时钟滴答声。在主机代码中，时钟值以 64 位整数形式跟踪，而 mcu 代码使用 32 位整数。在主机代码中，时钟通常存储在名称包含 *clock* 或 *ticks* 的变量中。

不同时间格式之间的转换主要在 **klippy/clocksync.py** 代码中实现。

在审查代码时需要注意的一些事项：
*   32 位和 64 位时钟：为了减少带宽并提高微控制器效率，微控制器上的时钟以 32 位整数形式跟踪。当在 mcu 代码中比较两个时钟时，必须始终使用 `timer_is_before()` 函数以确保正确处理整数溢出。主机软件通过附加从上次收到的 mcu 时间戳中获取的高阶位，将 32 位时钟转换为 64 位时钟——来自 mcu 的消息永远不会超过 2^31 个时钟滴答在未来或过去，因此这种转换从不模糊。主机通过简单地截断高阶位将 64 位时钟转换为 32 位时钟。为了确保这种转换没有歧义，**klippy/chelper/serialqueue.c** 代码将缓冲消息，直到它们在其目标时间的 2^31 个时钟滴答范围内。
*   多个微控制器：主机软件支持在单个打印机上使用多个微控制器。在这种情况下，每个微控制器的“MCU 时钟”被单独跟踪。clocksync.py 代码通过修改从“打印时间”到“MCU 时钟”的转换方式来处理微控制器之间的时钟漂移。在辅助 mcu 上，用于此转换的 mcu 频率会定期更新以考虑测量到的漂移。