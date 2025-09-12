# 运动学

本文概述了 Klipper 如何实现机器人运动（其[运动学](https://zh.wikipedia.org/wiki/運動學)）。其内容可能对希望参与 Klipper 软件开发的开发者以及希望更好地了解其机器机械原理的用户都有所帮助。

## 加速度

每当打印头改变速度时，Klipper 都会实施恒定加速度方案——速度是逐渐变化到新的速度，而不是突然突变。Klipper 始终在打印头和打印件之间强制执行加速度。从挤出机中挤出的耗材可能非常脆弱——快速的突变和/或挤出机流量变化会导致打印质量差和附着力差。即使在不挤出时，如果打印头与打印件处于同一水平，打印头的快速突变也可能导致最近沉积的耗材被破坏。限制打印头相对于打印件的速度变化，可以降低破坏打印的风险。

限制加速度也很重要，以防止步进电机失步或对机器施加过大的应力。Klipper 通过限制打印头的加速度来限制每个步进电机的扭矩。在打印头处强制执行加速度，自然也限制了移动打印头的步进电机的扭矩（反之则不一定成立）。

Klipper 实现了恒定加速度。恒定加速度的关键公式是：
```
velocity(time) = start_velocity + accel*time
```

## 梯形发生器

Klipper 使用传统的“梯形发生器”来模拟每次移动的运动——每次移动都有一个起始速度，以恒定加速度加速到巡航速度，在恒定速度下巡航，然后以恒定加速度减速到结束速度。

[trapezoid](img/trapezoid.svg.png)

之所以称为“梯形发生器”，是因为移动的速度图看起来像一个梯形。

巡航速度始终大于或等于起始速度和结束速度。加速阶段的持续时间可能为零（如果起始速度等于巡航速度），巡航阶段的持续时间可能为零（如果移动在加速后立即开始减速），和/或减速阶段的持续时间可能为零（如果结束速度等于巡航速度）。

[trapezoids](img/trapezoids.svg.png)

## 预读（Look-ahead）

“预读”系统用于确定移动之间的转弯速度。

考虑以下包含在 XY 平面上的两个移动：

[corner](img/corner.svg.png)

在上述情况下，可以在第一次移动后完全减速，然后在下一次移动开始时完全加速，但这并不理想，因为所有这些加速和减速会大大增加打印时间，并且挤出机流量的频繁变化会导致打印质量差。

为了解决这个问题，“预读”机制会将多个传入的移动排队，并分析移动之间的角度，以确定两个移动之间“连接点”处可以达到的合理速度。如果下一个移动的方向几乎相同，则打印头只需稍微减速（甚至完全不减速）即可。

[lookahead](img/lookahead.svg.png)

然而，如果下一个移动形成一个锐角（打印头在下一个移动中几乎要反向移动），则只允许很小的连接点速度。

[lookahead](img/lookahead-slow.svg.png)

连接点速度是使用“近似的向心加速度”来确定的。最好由[作者描述](https://onehossshay.wordpress.com/2011/09/24/improving_grbl_cornering_algorithm/)。然而，在 Klipper 中，连接点速度是通过指定 90° 转角应具有的期望速度（“直角速度”）来配置的，其他角度的连接点速度则由此推导得出。

预读的关键公式：
```
end_velocity^2 = start_velocity^2 + 2*accel*move_distance
```

### 最小巡航比例

Klipper 还实现了一种机制，用于平滑短“之字形”移动的运动。考虑以下移动：

[zigzag](img/zigzag.svg.png)

在上述情况下，频繁的加速到减速的变化会导致机器振动，从而对机器造成应力并增加噪音。Klipper 实现了一种机制，以确保在加速和减速之间始终有一定距离以巡航速度移动。这是通过降低某些移动（或移动序列）的最高速度来实现的，以确保以巡航速度移动的最小距离相对于加速和减速期间移动的距离。

Klipper 通过跟踪常规移动加速度以及虚拟的“加速到减速”速率来实现此功能：

[smoothed](img/smoothed.svg.png)

具体来说，代码会计算如果每个移动受到此虚拟“加速到减速”速率限制时其速度会是多少。在上图中，虚线灰线代表第一次移动的虚拟加速速率。如果一个移动无法使用此虚拟加速速率达到其完整的巡航速度，则其最高速度会降低到在此虚拟加速速率下可获得的最大速度。

对于大多数移动，此限制将等于或高于移动现有的限制，因此不会引起行为变化。然而，对于短的之字形移动，此限制会降低最高速度。请注意，它不会改变移动内的实际加速度——移动继续使用正常的加速度方案，直到调整后的最高速度。

## 生成步进脉冲

一旦预读过程完成，给定移动的打印头运动就完全确定了（时间、起始位置、结束位置、每个点的速度），就可以生成该移动的步进时间。此过程在 Klipper 代码的“运动学类”中完成。在这些运动学类之外，所有内容都以毫米、秒和笛卡尔坐标空间来跟踪。运动学类的任务是将这种通用坐标系转换为特定打印机的硬件细节。

Klipper 使用[迭代求解器](https://zh.wikipedia.org/wiki/求根算法)为每个步进电机生成步进时间。代码包含计算每个时刻头部理想笛卡尔坐标的公式，以及根据这些笛卡尔坐标计算理想步进电机位置的运动学公式。有了这些公式，Klipper 就可以确定步进电机在每个步进位置的理想时间。然后在这些计算出的时间安排给定的步进。

确定在恒定加速度下移动应行进多远的关键公式是：
```
move_distance = (start_velocity + .5 * accel * move_time) * move_time
```
以及恒定速度运动的关键公式是：
```
move_distance = cruise_velocity * move_time
```

给定移动距离确定移动的笛卡尔坐标的关鍵公式是：
```
cartesian_x_position = start_x + move_distance * total_x_movement / total_movement
cartesian_y_position = start_y + move_distance * total_y_movement / total_movement
cartesian_z_position = start_z + move_distance * total_z_movement / total_movement
```

### 笛卡尔机器人

为笛卡尔打印机生成步进是最简单的情况。每个轴上的移动直接与笛卡尔空间中的移动相关。

关键公式：
```
stepper_x_position = cartesian_x_position
stepper_y_position = cartesian_y_position
stepper_z_position = cartesian_z_position
```

### CoreXY 机器人

在 CoreXY 机器上生成步进仅比基本笛卡尔机器人稍微复杂一点。关键公式是：
```
stepper_a_position = cartesian_x_position + cartesian_y_position
stepper_b_position = cartesian_x_position - cartesian_y_position
stepper_z_position = cartesian_z_position
```

### 三角洲（Delta）机器人

三角洲机器人上的步进生成基于毕达哥拉斯定理：
```
stepper_position = (sqrt(arm_length^2
                         - (cartesian_x_position - tower_x_position)^2
                         - (cartesian_y_position - tower_y_position)^2)
                    + cartesian_z_position)
```

### 步进电机加速度限制

在三角洲运动学中，笛卡尔空间中加速的移动可能需要某个特定步进电机的加速度大于移动本身的加速度。当步进臂比垂直更水平，并且移动线经过该步进塔附近时，可能会发生这种情况。尽管这些移动可能需要的步进电机加速度大于打印机配置的最大移动加速度，但该步进移动的有效质量会更小。因此，更高的步进加速度不会导致步进扭矩显著增加，因此被认为是无害的。

然而，为了避免极端情况，Klipper 对步进加速度施加了上限，即打印机配置的最大移动加速度的三倍。（同样，步进的最大速度限制为最大移动速度的三倍。）为了强制执行此限制，构建包络边缘的移动（步进臂可能几乎水平）将具有较低的最大加速度和速度。

### 挤出机运动学

Klipper 在其自己的运动学类中实现了挤出机运动。由于每次移动的打印头运动的时序和速度都已完全知晓，因此可以独立于打印头运动的步进时间计算来计算挤出机的步进时间。

基本的挤出机运动计算很简单。步进时间生成使用笛卡尔机器人使用的相同公式：
```
stepper_position = requested_e_position
```

### 压力提前（Pressure advance）

实验表明，可以改进基本挤出机公式之外的挤出机建模。在理想情况下，随着挤出移动的进行，移动的每个点都应沉积相同体积的耗材，并且在移动结束后不应再挤出任何体积。不幸的是，通常会发现基本挤出公式在挤出移动开始时导致从挤出机中挤出的耗材过少，而在挤出结束后导致过多的耗材挤出。这通常被称为“渗出（ooze）”。

[ooze](img/ooze.svg.png)

“压力提前”系统试图通过使用不同的挤出机模型来解决这个问题。它不简单地认为输入挤出机的每立方毫米耗材会立即从挤出机中挤出相同数量，而是使用基于压力的模型。当耗材被推入挤出机时压力增加（如[胡克定律](https://zh.wikipedia.org/wiki/胡克定律)），而挤出所需的压力主要由通过喷嘴孔的流速决定（如[泊肃叶定律](https://zh.wikipedia.org/wiki/泊肃葉定律)）。关键思想是，耗材、压力和流速之间的关系可以用一个线性系数来建模：
```
pa_position = nominal_position + pressure_advance_coefficient * nominal_velocity
```

有关如何找到此压力提前系数的信息，请参阅[压力提前](Pressure_Advance.md)文档。

基本的压力提前公式可能导致挤出机电机发生突然的速度变化。Klipper 实现了挤出机运动的“平滑”处理以避免这种情况。

[pressure-advance](img/pressure-velocity.png)

上图显示了两个挤出移动之间具有非零转弯速度的示例。请注意，压力提前系统在加速期间会导致额外的耗材被推入挤出机。所需的耗材流速越高，在加速期间为补偿压力而必须推入的耗材就越多。在打印头减速期间，多余的耗材会被回抽（挤出机会具有负速度）。

“平滑”是通过在一小段时间内（由 `pressure_advance_smooth_time` 配置参数指定）对挤出机位置进行加权平均来实现的。这种平均可以跨越多个 G 代码移动。请注意，挤出机电机会在第一次挤出移动的名义开始之前就开始移动，并在最后一次挤出移动的名义结束后继续移动。

“平滑压力提前”的关键公式：
```
smooth_pa_position(t) =
    ( definitive_integral(pa_position(x) * (smooth_time/2 - abs(t - x)) * dx,
                          from=t-smooth_time/2, to=t+smooth_time/2)
     / (smooth_time/2)^2 )
```