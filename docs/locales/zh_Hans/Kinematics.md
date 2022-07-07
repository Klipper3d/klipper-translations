# 运动学

该文档提供Klipper实现机械[运动学](https://en.wikipedia.org/wiki/Kinematics)控制的概述，以供 致力于完善Klipper的开发者 或 希望对自己的设备的机械原理有进一步了解的爱好者 参考。

## 加速

Klipper总使用常加速度策略——打印头的速度总是梯度变化到新的速度，而非使用速度突变的方式。Klipper着眼于打印件和打印头之间的速度变化。离开挤出机的耗材十分脆弱，突然的移动速度和/或挤出流量突变可能会导致造成打印质量或床黏着能力的下降。甚至在无挤出时，如果打印头和打印件顶端在同一水平面时，喷嘴的速度突变有可能对刚挤出的耗材进行剐蹭。限制打印头相对于打印件的速度，可以减少剐蹭打印件的风险。

限制减速度也能减少步进电机丢步和炸机的状况。Klipper通过限制打印头的加速度来限制每个步进电机的力矩。限制打印头的加速度自然也限制了移动打印头的步进器的扭矩（反之则不一定）。

Klipper实现恒加速度控制，关键的方程如下：

```
velocity(time) = start_velocity + accel*time
```

## 梯形发生器

Klipper 使用传统的"梯形发生器"来产生每个动作的运动--每个动作都有一个起始速度，先恒定的加速度加速到一个巡航速度，再以恒定的速度巡航，最后用恒定的加速度减速到终点速度。

![trapezoid](img/trapezoid.svg.png)

因为移动时的速度图看起来像一个梯形，它被称为 "梯形发生器"。

巡航速度总是大于等于起始和终端速度。加速度阶段可能持续时间为0（如果起始速度等于巡航速度），巡航速度的持续时间也可为0（如果在加速结束后马上进行减速），减速阶段也能为0（如果终端速度等于巡航速度）。

![trapezoids](img/trapezoids.svg.png)

## 预计算（look-ahead）

拐角速度使用预计算系统进行处理。

考虑以下两个在 XY 平面上的移动：

![corner](img/corner.svg.png)

在上述的状况下，打印机可以在第一步时减速至停止，并在第二步开始时加速至巡航速度。但这种运动策略并不理想，完全减速和完全加速会大幅增加打印时间，同时挤出量会频繁变动，从而导致打印质量的下降。

要解决这种情况，klipper引入了预计算机制，预先依次计算后续的数个移动，分析其中的拐角并确定合适的拐角速度。如果下一步的速度与现时的移动速度相近，则滑车速度仅会稍微减少。

![lookahead](img/lookahead.svg.png)

然而，如果下一步形成一个尖锐的拐角（滑车将在下一步进行近于反方向的移动），则只能采用一个很低的拐角速度。

![lookahead](img/lookahead-slow.svg.png)

转角速度由“近似向心加速度”确定。最好[由作者描述](https://onehossshay.wordpress.com/2011/09/24/improving_grbl_cornering_algorithm/)。然而在Klipper中转角速度是通过指定90°角应该有的理想速度（“直角速度”）并且其他的角度的转角速度也是根据它推导出来的。

预计算的关键方程：

```
end_velocity^2 = start_velocity^2 + 2*accel*move_distance
```

### 预计算结果平滑

Klipper 实现了一种用于平滑短距离之字形移动的机制。参考以下移动：

![zigzag](img/zigzag.svg.png)

在上述情况下，从加速到减速的频繁变化会导致机器振动并且会对机器造成压力和加噪音。为了减少这种情况，Klipper既跟踪常规的移动加速度并且也跟踪虚拟的"加减速率"。利用这个系统，这些短的"zigzag"移动的最高速度被限制以使得打印机的运动可以更加平滑：

![smoothed](img/smoothed.svg.png)

具体来说，代码计算的是限制在这个虚拟的“加速到减速”率下时（默认为正常加速率的一半），每个动作的速度是多少。在上图中，灰色虚线代表了第一段移动时的虚拟加速率。如果一段移动使用这个虚拟加速度不能达到目标巡航速度，那么这段移动的最高速度将被降低到它在这个虚拟加速率下所能获得的最大速度。对于大多数移动来说，该限制将处于或高于该移动的现有限制，并且不会改变移动的行为。然而，对于短的 "之 "字形移动，这个限制会降低最高速度。请注意，它不会改变移动中的实际加速度--移动会继续使用正常的加速，直到其调整后的最高速度。

## 生成步数（Generating steps）

前瞻过程完成后给定移动的打印头运动已被确定（时间、开始位置、结束位置、每一点的速度），可以被用于生成移动的步进时间。这个过程是在Klipper代码的运动学类中完成的。在这些运动学类之外，所有的东西都是以毫米、秒为单位，在笛卡尔坐标空间进行跟踪。运动学类负责将这个通用坐标系统转换为符合打印机硬件特性的坐标系。

Klipper使用一个[迭代求解器](https://zh.wikipedia.org/wiki/%E6%B1%82%E6%A0%B9%E7%AE%97%E6%B3%95)来生成每个步进的步进时间。该代码包含了计算打印头在每个时间点上的理想笛卡尔坐标的公式，它还有运动学公式来计算基于这些笛卡尔坐标的理想步进位置。通过这些公式，Klipper可以确定步进电机在每个步进位置时的理想步进时间。然后在这些计算出的时间内安排给定的步进。

确定一个移动在恒定加速度下应该移动多远的关键公式是：

```
move_distance = (start_velocity + .5 * accel * move_time) * move_time
```

并且匀速运动的关键公式是：

```
move_distance = cruise_velocity * move_time
```

在给定移动距离的情况下用于确定移动的笛卡尔坐标的关键公式为：

```
cartesian_x_position = start_x + move_distance * total_x_movement / total_movement
cartesian_y_position = start_y + move_distance * total_y_movement / total_movement
cartesian_z_position = start_z + move_distance * total_z_movement / total_movement
```

### 笛卡尔机器

为笛卡尔坐标的打印机生成步进是最简单的情况。每个轴上的运动与笛卡尔空间中的运动直接相关。

关键公式：

```
stepper_x_position = cartesian_x_position
stepper_y_position = cartesian_y_position
stepper_z_position = cartesian_z_position
```

### CoreXY 机器

在CoreXY的机器上生成步进只比基本的卡特尔机器人复杂一点。关键公式是：

```
stepper_a_position = cartesian_x_position + cartesian_y_position
stepper_b_position = cartesian_x_position - cartesian_y_position
stepper_z_position = cartesian_z_position
```

### 三角洲机器

三角洲结构机器人上的步进生成基于勾股定理：

```
stepper_position = (sqrt(arm_length^2
                         - (cartesian_x_position - tower_x_position)^2
                         - (cartesian_y_position - tower_y_position)^2)
                    + cartesian_z_position)
```

### 步进电机加速限制

在三角洲机器运动时，打印头在笛卡尔空间中运动进行一定加速度的加速运动，其对应轴的步进电机需要高于前述加速度的加速度。这种状况在一打印壁需提供的水平运动幅度大于垂直运动幅度，并且，运动直线靠近某一垂柱时发生。尽管这些运动会要求步进电机的加速度超过打印机的加速度设置限额，但单个步进电机需要承担的有效质量是相对较小的。因此，增加的步进电机加速度不会显著增加步进电机的扭矩需求，可认为这种现象是无害的。

然而，为了避免极端状况，Klipper强制将步进电机的加速度上限设置为打印机加速度上限的3倍。（同样，步进电机的速度上限也设置为打印机速度上限的3倍。）为了实现上述设置，在打印区域水平边沿的（存在打印臂接近水平的）位置，打印头的速度和加速度上限将相应降低。

### 挤出机运动学

Klipper 在自身的运动学类中实现了挤出机的运动。由于每个打印头运动的时间和速度是完全已知的，因此可以独立于打印头运动的步长计算来计算挤出机的步长。

基本的挤出机运动计算起来很简单。步进时间的生成使用和笛卡尔结构相同的公式：

```
stepper_position = requested_e_position
```

### 压力提前

实验表明，在基本的挤出机方程之上可以改进挤出机的模型。在理想情况下，随着挤出移动的进行，沿移动的每个点应寄出相同体积的耗材，并且在移动后不应挤出任何耗材。不幸的是，在实际情况下，基本的挤出机方程会导致在挤出运动开始时挤出过少的耗材，并且在挤出结束后挤出过多的耗材。这通常被称为“溢料”。

![溢料](img/ooze.svg.png)

"压力推进"系统试图通过使用一个不同的挤出机模型来解决这个问题。它不理想的假设送入挤出机的每mm^3耗材将导致该体积的mm^3立即被挤出，而是使用基于压力的模型。当耗材被推入挤出机时，压力会增加（如[胡克定律](https://en.wikipedia.org/wiki/Hooke%27s_law)），而挤出所需的压力则由通过喷嘴孔口的流速决定（如[泊伊维尔定律](https://en.wikipedia.org/wiki/Poiseuille_law)）。关键的想法是，耗材、压力和流速之间的关系可以用一个线性系数来建模：

```
pa_position = nominal_position + pressure_advance_coefficient * nominal_velocity
```

有关如何测量压力提前系数的信息，请参阅 [压力提前](Pressure_Advance.md) 文档。

基本的压力推进公式会对挤出机电机的速度进行很大的瞬时调整。Klipper 通过实施挤出机运动的"平滑"（smoothing）以避免这种情况。

![pressure-advance](img/pressure-velocity.png)

上图以两个挤出运动为例，它们之间的转弯速度不为零。请注意，压力推进系统在加速过程中会导致额外的耗材被推入挤出机。所需的耗材流量越高，在加速过程中必须推入更多的耗材以均衡压力。在打印头减速期间，额外的耗材会被回抽（挤出机将有一个负速度）。

“平滑”由挤出机位置在一小段时间内的加权平均值实现的（由 `pressure_advance_smooth_time` 配置参数指定）。这种平均可以跨越多个 g 代码移动。请注意，挤出机电机将如何在第一次挤出运动的标称起点之前开始移动，并在最后一次挤出运动的标称结束之后继续移动。

"平滑压力提前"的关键公式：

```
smooth_pa_position(t) =
    ( definitive_integral(pa_position(x) * (smooth_time/2 - abs(t - x)) * dx,
                          from=t-smooth_time/2, to=t+smooth_time/2)
     / (smooth_time/2)^2 )
```
