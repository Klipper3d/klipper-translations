# Malha da Base

O módulo "Bed Mesh" pode ser usado para compensar irregularidades na superfície da cama a fim de obter uma primeira camada consistente em toda cama. Deve-se observar que a correção baseada em software não alcançará um resultado perfeito, podendo apenas se aproximar da forma da cama. Além disso, o "Bed Mesh" não pode corrigir problemas mecânicos e/ou elétricos. Se um eixo estiver desalinhado ou uma sonda não for precisa, o módulo "bed_mesh" não receberá resultados precisos do processo de sondagem da superfície.

Antes de realizar a Calibração da Malha (Mesh Calibration), é necessário garantir que o Z-Offset da sua sonda esteja calibrado. Se estiver usando um fim de curso (endstop) para o homing do eixo Z, ele também precisará ser calibrado. Para mais informações, consulte [Calibraçao de Sonda](Probe_Calibrate.md) e "Z_ENDSTOP_CALIBRATE" em [Nivelamento Manual](Manual_Level.md).

## Configuração básica

### Camas Retangulares

Este exemplo pressupõe uma impressora com uma cama retangular de 250 mm x 220 mm e uma sonda com um deslocamento (offset) de x de 24 mm e um deslocamento (offset) de y de 5 mm.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `speed: 120` *Valor padrão: 50* A velocidade com a qual a ferramenta (bico ou cabeça de impressão) se move entre os pontos.
- `horizontal_move_z: 5` *Valor padrão: 5* A coordenada Z para a qual a sonda é elevada antes de se deslocar entre os pontos de sondagem.
- `mesh_min: 35, 6` *Obrigatório* A primeira coordenada sondada, mais próxima à origem. Esta coordenada é relativa à localização da sonda.
- `mesh_max: 240, 198` *Required* The probed coordinate farthest from the origin. This is not necessarily the last point probed, as the probing process occurs in a zig-zag fashion. As with `mesh_min`, this coordinate is relative to the probe's location.
- `probe_count: 5, 3` *Valor padrão: 3, 3* O número de pontos a serem sondados em cada eixo, especificados como valores inteiros X, Y. Neste exemplo, 5 pontos serão sondados ao longo do eixo X e 3 pontos ao longo do eixo Y, totalizando 15 pontos sondados. Observe que, se você quisesse uma grade quadrada, por exemplo, 3x3, isso poderia ser especificado como um único valor inteiro que é usado para ambos os eixos, por exemplo, `probe_count: 3`. Lembre-se de que uma malha requer um `probe_count` mínimo de 3 ao longo de cada eixo.

A ilustração abaixo demonstra como as opções `mesh_min`, `mesh_max` e `probe_count` são utilizadas para gerar os pontos de sondagem. As setas indicam a direção do procedimento de sondagem, começando em `mesh_min`. Para referência, quando a sonda está em `mesh_min`, o bico (nozzle) estará em (11, 1), e quando a sonda estiver em `mesh_max`, o bico estará em (206, 193).

![bedmesh_rect_basic](img/bedmesh_rect_basic.svg)

### Camas circulares

Este exemplo pressupõe uma impressora equipada com uma cama redonda com raio de 100 mm. Utilizaremos os mesmos deslocamentos (offsets) da sonda do exemplo retangular, 24 mm no eixo X e 5 mm no eixo Y.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius: 75` *Requerido* O raio da malha sondada em milímetros (mm), relativo à `mesh_origin` (origem da malha). É importante notar que os deslocamentos da sonda limitam o tamanho do raio da malha. Neste exemplo, um raio maior que 76 moveria a ferramenta para além do alcance da impressora.
- `mesh_origin: 0, 0` *Valor padrão: 0, 0* O ponto central da malha. Esta coordenada é relativa à localização da sonda. Embora o padrão seja 0, 0, pode ser útil ajustar a origem para sondar uma porção maior da cama. Veja a ilustração abaixo.
- `round_probe_count: 5` *Valor padrão: 5* Este é um valor inteiro que define o número máximo de pontos sondados ao longo dos eixos X e Y. Por "máximo", entendemos o número de pontos sondados ao longo da origem da malha. Esse valor deve ser um número ímpar, pois é necessário que o centro da malha seja sondado.

A ilustração abaixo mostra como os pontos sondados são gerados. Como você pode ver, definir `mesh_origin` com (-10, 0) nos permite especificar um raio maior para a malha de 85.

![bedmesh_round_basic](img/bedmesh_round_basic.svg)

## Configuração avançada

Abaixo, as opções de configuração mais avançadas são explicadas em detalhes. Cada exemplo será baseado na configuração básica de cama retangular mostrada acima. Todas as opções avançadas também se aplicam a camas redondas da mesma maneira.

### Interpolação de malha (Mesh Interpolation)

Embora seja possível amostrar diretamente a matriz sondada usando interpolação bilinear simples para determinar os valores Z entre os pontos sondados, muitas vezes é útil interpolar pontos extras usando algoritmos de interpolação mais avançados para aumentar a densidade da malha. Esses algoritmos adicionam curvatura à malha, tentando simular as propriedades do material da cama. A Malha da Cama oferece interpolação de Lagrange e bicúbica para realizar esse objetivo.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
mesh_pps: 2, 3
algorithm: bicubic
bicubic_tension: 0.2
```

- `mesh_pps: 2, 3` *Valor padrão: 2, 2* A opção `mesh_pps` é uma abreviação para "Mesh Points Per Segment" (Pontos de Malha por Segmento). Essa opção especifica quantos pontos serão interpolados para cada segmento ao longo dos eixos X e Y. Um 'segmento' é o espaço entre cada ponto sondado. Assim como `probe_count`, `mesh_pps` é especificado como um par de números inteiros X, Y, e também pode ser especificado como um único número inteiro que se aplica a ambos os eixos.
- `algorithm: lagrange` *Valor padrão: lagrange* O algoritmo usado para interpolar a malha. Pode ser `lagrange` ou `bicubic`. A interpolação de Lagrange é limitada a 6 pontos sondados, pois a oscilação tende a ocorrer com um número maior de amostras. A interpolação bicúbica requer um mínimo de 4 pontos sondados ao longo de cada eixo; se menos de 4 pontos forem especificados, a amostragem de Lagrange será forçada. Se mesh_pps estiver definido como 0, este valor será ignorado, pois nenhuma interpolação de malha será realizada.
- `bicubic_tension: 0.2` *Valor padrão: 0.2* Se a opção `algorithm` for definida como bicubic, é possível especificar o valor de tensão (tension). Quanto maior a tensão, mais inclinação é interpolada. Tome cuidado ao ajustar esse valor, pois valores mais altos também criam mais overshoot (sobressinal), o que resultará em valores interpolados mais altos ou mais baixos do que seus pontos sondados.

A ilustração abaixo mostra como as opções acima são usadas para gerar uma malha interpolada.

![bedmesh_interpolated](img/bedmesh_interpolated.svg)

### Divisão de Movimento

A Malha da Cama funciona interceptando comandos de movimento gcode e aplicando uma transformação em suas coordenadas Z. Movimentos longos devem ser divididos em movimentos menores para seguir corretamente a forma da cama. As opções abaixo controlam o comportamento de divisão.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
move_check_distance: 5
split_delta_z: .025
```

- `move_check_distance: 5` *Valor padrão: 5* A distância mínima para verificar a mudança desejada em Z antes de realizar uma divisão (split) de movimento. Neste exemplo, um movimento com comprimento superior a 5 mm será analisado pelo algoritmo. A cada intervalo de 5 mm, ocorrerá uma consulta à malha Z (mesh Z lookup), comparando-a com o valor de Z do movimento anterior. Se a diferença (delta) atender ao limite definido por `split_delta_z`, o movimento será dividido (split) e o deslocamento continuará. Esse processo se repete até que o final do movimento seja alcançado, onde um ajuste final será aplicado. Movimentos mais curtos que a `move_check_distance` têm o ajuste correto de Z aplicado diretamente ao movimento sem divisão ou travessia.
- `split_delta_z: .025` *Valor padrão: .025* Como mencionado anteriormente, este é o desvio mínimo necessário para acionar a divisão (split) de movimento. Neste exemplo, qualquer valor de Z com um desvio de +/- 0,025 mm acionará uma divisão.

Geralmente, os valores padrão para essas opções são suficientes; na verdade, o valor padrão de 5 mm para `move_check_distance` pode ser exagerado. No entanto, um usuário avançado pode desejar experimentar com essas opções na tentativa de obter a camada inicial ideal.

### Desvanecimento de Malha (Mesh Fade)

Quando a opção "fade" está habilitada, o ajuste em Z é gradualmente reduzido ao longo de uma distância específica, conforme definido pela configuração. Isso é alcançado aplicando pequenos ajustes à altura da camada, seja aumentando ou diminuindo, dependendo da forma da cama de impressão. O objetivo do "fade" é fazer uma transição dos ajustes da altura das camadas usados para compensar as irregularidades da cama para uma altura de camada mais uniforme na parte superior da impressão.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
fade_start: 1
fade_end: 10
fade_target: 0
```

- `fade_start: 1` *Valor padrão: 1* A altura em Z na qual começar a reduzir gradualmente o ajuste. É uma boa ideia aguardar algumas camadas antes de iniciar o processo de "fade".
- `fade_end: 10` *Valor padrão: 0* A altura em Z em que o processo de "fade" deve ser concluído. Se esse valor for menor que `fade_start`, o "fade" será desabilitado. Esse valor pode ser ajustado dependendo do quão deformada é a superfície de impressão. Uma superfície significativamente deformada deve ter o "fade" concluído ao longo de uma distância maior. Uma superfície quase plana pode reduzir esse valor para que o "fade" seja concluído mais rapidamente. Um valor de 10mm é uma escolha razoável para começar, se o valor padrão de 1 para `fade_start` for usado.
- `fade_target: 0` *Valor padrão: O valor médio da coordenada Z da malha* O `fade_target` pode ser considerado como um deslocamento Z adicional aplicado em toda a cama após a conclusão do fade. Geralmente, gostaríamos que esse valor fosse 0, no entanto, há circunstâncias em que não deve ser. Por exemplo, suponha que sua posição de homing (inicial) na cama seja uma exceção, ou seja, ela está 0,2 mm abaixo da altura média sondada da cama. Se o `fade_target` for 0, o fade reduzirá a impressão em uma média de 0,2 mm em toda a cama. Ao definir o `fade_target` para 0,2, a área de homing se expandirá em 0,2 mm, mas o restante da cama será dimensionado com precisão. Geralmente, é uma boa ideia deixar o `fade_target` fora da configuração para que a altura média da malha seja usada; no entanto, pode ser desejável ajustar manualmente o `fade_target` se você desejar imprimir em uma parte específica da cama.

### Configurando a posição de referência zero

Many probes are susceptible to "drift", ie: inaccuracies in probing introduced by heat or interference. This can make calculating the probe's z-offset challenging, particularly at different bed temperatures. As such, some printers use an endstop for homing the Z axis and a probe for calibrating the mesh. In this configuration it is possible offset the mesh so that the (X, Y) `reference position` applies zero adjustment. The `reference postion` should be the location on the bed where a [Z_ENDSTOP_CALIBRATE](./Manual_Level.md#calibrating-a-z-endstop) paper test is performed. The bed_mesh module provides the `zero_reference_position` option for specifying this coordinate:

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
zero_reference_position: 125, 110
probe_count: 5, 3
```

- `zero_reference_position: ` *Valor padrão: Nenhum (desabilitado)* A `zero_reference_position` espera uma coordenada (X, Y) correspondente à `reference position` descrita acima. Se a coordenada estiver dentro da malha, então a malha será deslocada para que a posição de referência aplique ajuste zero. Se a coordenada estiver fora da malha, então a coordenada será sondada após a calibração, com o z-value resultante usado como z-offset. Observe que esta coordenada NÃO deve estar em um local especificado como `faulty_region` se uma sonda for necessária.

#### Obsoleto relative_reference_index

As configurações existentes que usam a opção `relative_reference_index` devem ser atualizadas para usar a `zero_reference_position`. A resposta ao comando gcode [BED_MESH_OUTPUT PGP=1](#output) incluirá a coordenada (X, Y) associada ao índice; esta posição pode ser usada como o valor para `zero_reference_position`. A saída será semelhante à seguinte:

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (1.0, 1.0) | (24.0, 6.0)
// 1 | (36.7, 1.0) | (59.7, 6.0)
// 2 | (72.3, 1.0) | (95.3, 6.0)
// 3 | (108.0, 1.0) | (131.0, 6.0)
... (additional generated points)
// bed_mesh: relative_reference_index 24 is (131.5, 108.0)
```

*Nota: A saída acima também é impressa em `klippy.log` durante a inicialização.*

Usando o exemplo acima, vemos que o `relative_reference_index` é impresso junto com sua coordenada. Portanto, a `zero_reference_position` é `131,5, 108`.

### Regiões defeituosas

É possível que algumas áreas da cama relatem resultados imprecisos durante a sondagem devido a uma "falha" em locais específicos. O melhor exemplo disso são camas com séries de ímãs integrados usados para manter folhas de aço removíveis. O campo magnético nos arredores desses ímãs pode fazer com que uma sonda indutiva seja acionada a uma distância maior ou menor do que o normal, resultando em uma malha que não representa com precisão a superfície nessas áreas. **Observação: Isso não deve ser confundido com o viés de localização da sonda, que produz resultados imprecisos em toda a cama.**

As opções `faulty_region` podem ser configuradas para compensar esse efeito. Se um ponto gerado estiver localizado dentro de uma região com falha, a malha da cama tentará sondar até 4 pontos nas bordas dessa região. Esses valores sondados serão calculados em uma média e inseridos na malha como o valor Z na coordenada gerada (X, Y).

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
faulty_region_1_min: 130.0, 0.0
faulty_region_1_max: 145.0, 40.0
faulty_region_2_min: 225.0, 0.0
faulty_region_2_max: 250.0, 25.0
faulty_region_3_min: 165.0, 95.0
faulty_region_3_max: 205.0, 110.0
faulty_region_4_min: 30.0, 170.0
faulty_region_4_max: 45.0, 210.0
```

- `faulty_region_{1...99}_min` `faulty_region_{1..99}_max` * Valor padrão: Nenhum (desativado)* As Regiões com Falha (Faulty Regions) são definidas de maneira semelhante à própria malha, onde as coordenadas mínimas e máximas (X, Y) devem ser especificadas para cada região. Uma região com falha pode se estender para fora da malha, mas os pontos alternativos gerados sempre estarão dentro do limite da malha. Nenhuma região pode sobrepor-se a outra.

A imagem abaixo ilustra como os pontos de substituição são gerados quando um ponto gerado está localizado dentro de uma região com falha. As regiões mostradas correspondem às mostradas na configuração de exemplo acima. Os pontos de substituição e suas coordenadas são identificados em verde.

![bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

### Malhas Adaptativas

Adaptive bed meshing is a way to speed up the bed mesh generation by only probing the area of the bed used by the objects being printed. When used, the method will automatically adjust the mesh parameters based on the area occupied by the defined print objects.

The adapted mesh area will be computed from the area defined by the boundaries of all the defined print objects so it covers every object, including any margins defined in the configuration. After the area is computed, the number of probe points will be scaled down based on the ratio of the default mesh area and the adapted mesh area. To illustrate this consider the following example:

For a 150mmx150mm bed with `mesh_min` set to `25,25` and `mesh_max` set to `125,125`, the default mesh area is a 100mmx100mm square. An adapted mesh area of `50,50` means a ratio of `0.5x0.5` between the adapted area and default mesh area.

If the `bed_mesh` configuration specified `probe_count` as `7x7`, the adapted bed mesh will use 4x4 probe points (7 * 0.5 rounded up).

![adaptive_bedmesh](img/adaptive_bed_mesh.svg)

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
adaptive_margin: 5
```

- `adaptive_margin`  *Default Value: 0*  Margin (in mm) to add around the area of the bed used by the defined objects. The diagram below shows the adapted bed mesh area with an `adaptive_margin` of 5mm. The adapted mesh area (area in green) is computed as the used bed area (area in blue) plus the defined margin.

   ![adaptive_bedmesh_margin](img/adaptive_bed_mesh_margin.svg)

By nature, adaptive bed meshes use the objects defined by the Gcode file being printed. Therefore, it is expected that each Gcode file will generate a mesh that probes a different area of the print bed. Therefore, adapted bed meshes should not be re-used. The expectation is that a new mesh will be generated for each print if adaptive meshing is used.

It is also important to consider that adaptive bed meshing is best used on machines that can normally probe the entire bed and achieve a maximum variance less than or equal to 1 layer height. Machines with mechanical issues that a full bed mesh normally compensates for may have undesirable results when attempting print moves **outside** of the probed area. If a full bed mesh has a variance greater than 1 layer height, caution must be taken when using adaptive bed meshes and attempting print moves outside of the meshed area.

## Surface Scans

Some probes, such as the [Eddy Current Probe](./Eddy_Probe.md), are capable of "scanning" the surface of the bed. That is, these probes can sample a mesh without lifting the tool between samples. To activate scanning mode, the `METHOD=scan` or `METHOD=rapid_scan` probe parameter should be passed in the `BED_MESH_CALIBRATE` gcode command.

### Scan Height

The scan height is set by the `horizontal_move_z` option in `[bed_mesh]`. In addition it can be supplied with the `BED_MESH_CALIBRATE` gcode command via the `HORIZONTAL_MOVE_Z` parameter.

The scan height must be sufficiently low to avoid scanning errors. Typically a height of 2mm (ie: `HORIZONTAL_MOVE_Z=2`) should work well, presuming that the probe is mounted correctly.

It should be noted that if the probe is more than 4mm above the surface then the results will be invalid. Thus, scanning is not possible on beds with severe surface deviation or beds with extreme tilt that hasn't been corrected.

### Rapid (Continuous) Scanning

When performing a `rapid_scan` one should keep in mind that the results will have some amount of error. This error should be low enough to be useful on large print areas with reasonably thick layer heights. Some probes may be more prone to error than others.

It is not recommended that rapid mode be used to scan a "dense" mesh. Some of the error introduced during a rapid scan may be gaussian noise from the sensor, and a dense mesh will reflect this noise (ie: there will be peaks and valleys).

Bed Mesh will attempt to optimize the travel path to provide the best possible result based on the configuration. This includes avoiding faulty regions when collecting samples and "overshooting" the mesh when changing direction. This overshoot improves sampling at the edges of a mesh, however it requires that the mesh be configured in a way that allows the tool to travel outside of the mesh.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5
scan_overshoot: 8
```

- `scan_overshoot` *Default Value: 0 (disabled)* The maximum amount of travel (in mm) available outside of the mesh. For rectangular beds this applies to travel on the X axis, and for round beds it applies to the entire radius. The tool must be able to travel the amount specified outside of the mesh. This value is used to optimize the travel path when performing a "rapid scan". The minimum value that may be specified is 1. The default is no overshoot.

If no scan overshoot is configured then travel path optimization will not be applied to changes in direction.

## Gcode para Malha da Cama

### Calibração

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic | scan | rapid_scan] \ [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] \ [ADAPTIVE_MARGIN=<value>]` *Default Profile: default* *Default Method: automatic if a probe is detected, otherwise manual*  *Default Adaptive: 0*  *Default Adaptive Margin: 0*

Inicia o procedimento de sondagem para a Calibração da Malha da Cama (Bed Mesh Calibration).

The mesh will be immediately ready to use when the command completes and saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. The `METHOD` parameter takes one of the following values:

- `METHOD=manual`: enables manual probing using the nozzle and the paper test
- `METHOD=automatic`: Automatic (standard) probing. This is the default.
- `METHOD=scan`: Enables surface scanning. The tool will pause over each position to collect a sample.
- `METHOD=rapid_scan`: Enables continuous surface scanning.

XY positions are automatically adjusted to include the X and/or Y offsets when a probing method other than `manual` is selected.

É possível especificar os parâmetros da malha para modificar a área sondada. Os seguintes parâmetros estão disponíveis:

- Camas retangulares (cartesianas):
   - `MESH_MIN`
   - `MESH_MAX`
   - `PROBE_COUNT`
- Camas circulares (delta):
   - `MESH_RADIUS`
   - `MESH_ORIGIN`
   - `ROUND_PROBE_COUNT`
- Todas as camas:
   - `MESH_PPS`
   - `ALGORITHM`
   - `ADAPTIVE`
   - `ADAPTIVE_MARGIN`

Consulte a documentação de configuração acima para obter detalhes sobre como cada parâmetro se aplica à malha.

### Perfis

`BED_MESH_PROFILE SAVE=<nome> LOAD=<nome> REMOVE=<nome>`

Após a execução de um BED_MESH_CALIBRATE, é possível salvar o estado atual da malha em um perfil com um nome. Isso permite carregar uma malha sem a necessidade de sondar a cama novamente. Após salvar um perfil usando `BED_MESH_PROFILE SAVE=<nome>`, o código G (gcode) `SAVE_CONFIG` pode ser executado para escrever o perfil no arquivo printer.cfg.

Os perfis podem ser carregados executando `BED_MESH_PROFILE LOAD=<nome>`.

Deve ser observado que cada vez que ocorre um BED_MESH_CALIBRATE, o estado atual é automaticamente salvo no perfil *default*. O perfil *default* pode ser removido da seguinte forma:

`BED_MESH_PROFILE REMOVE=default`

Qualquer outro perfil salvo pode ser removido da mesma maneira, substituindo *default* pelo nome do perfil que você deseja remover.

#### Carregando o perfil padrão

Versões anteriores do `bed_mesh` sempre carregavam o perfil chamado *default* na inicialização, caso estivesse presente. Esse comportamento foi removido para permitir que o usuário determine quando um perfil é carregado. Se o usuário desejar carregar o perfil `default`, é recomendado adicionar `BED_MESH_PROFILE LOAD=default` no macro `START_PRINT` ou na configuração de "Start G-Code" do slicer, dependendo do que for aplicável.

Note that this is not required if a new mesh is generated with `BED_MESH_CALIBRATE` in the `START_PRINT` macro or the slicer's "Start G-Code" and may produce unexpected results, especially with adaptive meshing.

Alternativamente, o antigo comportamento de carregar um perfil na inicialização pode ser restaurado com `[delayed_gcode]`:

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### Saída

`BED_MESH_OUTPUT PGP=[0 | 1]`

Mostra o estado atual da malha no terminal. Observe que a malha em si é exibida

O parâmetro PGP é uma abreviação para "Print Generated Points" (Exibir Pontos Gerados). Se `PGP=1` for definido, os pontos sondados gerados serão exibidos no terminal:

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (11.0, 1.0) | (35.0, 6.0)
// 1 | (62.2, 1.0) | (86.2, 6.0)
// 2 | (113.5, 1.0) | (137.5, 6.0)
// 3 | (164.8, 1.0) | (188.8, 6.0)
// 4 | (216.0, 1.0) | (240.0, 6.0)
// 5 | (216.0, 97.0) | (240.0, 102.0)
// 6 | (164.8, 97.0) | (188.8, 102.0)
// 7 | (113.5, 97.0) | (137.5, 102.0)
// 8 | (62.2, 97.0) | (86.2, 102.0)
// 9 | (11.0, 97.0) | (35.0, 102.0)
// 10 | (11.0, 193.0) | (35.0, 198.0)
// 11 | (62.2, 193.0) | (86.2, 198.0)
// 12 | (113.5, 193.0) | (137.5, 198.0)
// 13 | (164.8, 193.0) | (188.8, 198.0)
// 14 | (216.0, 193.0) | (240.0, 198.0)
```

Os pontos "Ajustados pela Ferramenta" se referem à localização da ponta da extrusora (bico) para cada ponto, enquanto os pontos "Sondados" (Probe) se referem à localização da sonda. Observe que, ao realizar a sondagem manualmente, os pontos "Sondados" (Probe) se referirão tanto à localização da ferramenta quanto à localização da ponta da extrusora (bico).

### Limpar Estado da Malha

`BED_MESH_CLEAR`

Este gcode pode ser usado para limpar o estado interno da malha.

### Aplicar deslocamentos em X/Y

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value>]`

This is useful for printers with multiple independent extruders, as an offset is necessary to produce correct Z adjustment after a tool change. Offsets should be specified relative to the primary extruder. That is, a positive X offset should be specified if the secondary extruder is mounted to the right of the primary extruder, a positive Y offset should be specified if the secondary extruder is mounted "behind" the primary extruder, and a positive ZFADE offset should be specified if the secondary extruder's nozzle is above the primary extruder's.

Note that a ZFADE offset does *NOT* directly apply additional adjustment. It is intended to compensate for a `gcode offset` when [mesh fade](#mesh-fade) is enabled. For example, if a secondary extruder is higher than the primary and needs a negative gcode offset, ie: `SET_GCODE_OFFSET Z=-.2`, it can be accounted for in `bed_mesh` with `BED_MESH_OFFSET ZFADE=.2`.

## Bed Mesh Webhooks APIs

### Dumping mesh data

`{"id": 123, "method": "bed_mesh/dump_mesh"}`

Dumps the configuration and state for the current mesh and all saved profiles.

The `dump_mesh` endpoint takes one optional parameter, `mesh_args`. This parameter must be an object, where the keys and values are parameters available to [BED_MESH_CALIBRATE](#bed_mesh_calibrate). This will update the mesh configuration and probe points using the supplied parameters prior to returning the result. It is recommended to omit mesh parameters unless it is desired to visualize the probe points and/or travel path before performing `BED_MESH_CALIBRATE`.

## Visualization and analysis

Most users will likely find that the visualizers included with applications such as Mainsail, Fluidd, and Octoprint are sufficient for basic analysis. However, Klipper's `scripts` folder contains the `graph_mesh.py` script that may be used to perform additional visualizations and more detailed analysis, particularly useful for debugging hardware or the results produced by `bed_mesh`:

```
usage: graph_mesh.py [-h] {list,plot,analyze,dump} ...

Graph Bed Mesh Data

positional arguments:
  {list,plot,analyze,dump}
    list                List available plot types
    plot                Plot a specified type
    analyze             Perform analysis on mesh data
    dump                Dump API response to json file

options:
  -h, --help            show this help message and exit
```

### Pre-requisites

Like most graphing tools provided by Klipper, `graph_mesh.py` requires the `matplotlib` and `numpy` python dependencies. In addition, connecting to Klipper via Moonraker's websocket requires the `websockets` python dependency. While all visualizations can be output to an `svg` file, most of the visualizations offered by `graph_mesh.py` are better viewed in live preview mode on a desktop class PC. For example, the 3D visualizations may be rotated and zoomed in preview mode, and the path visualizations can optionally be animated in preview mode.

### Plotting Mesh data

The `graph_mesh.py` tool can plot several types of visualizations. Available types can be shown by running `graph_mesh.py list`:

```
graph_mesh.py list
points    Plot original generated points
path      Plot probe travel path
rapid     Plot rapid scan travel path
probedz   Plot probed Z values
meshz     Plot mesh Z values
overlay   Plots the current probed mesh overlaid with a profile
delta     Plots the delta between current probed mesh and a profile
```

Several options are available when plotting visualizations:

```
usage: graph_mesh.py plot [-h] [-a] [-s] [-p PROFILE_NAME] [-o OUTPUT] <plot type> <input>

positional arguments:
  <plot type>           Type of data to graph
  <input>               Path/url to Klipper Socket or path to json file

options:
  -h, --help            show this help message and exit
  -a, --animate         Animate paths in live preview
  -s, --scale-plot      Use axis limits reported by Klipper to scale plot X/Y
  -p PROFILE_NAME, --profile-name PROFILE_NAME
                        Optional name of a profile to plot for 'probedz'
  -o OUTPUT, --output OUTPUT
                        Output file path
```

Below is a description of each argument:

- `plot type`: A required positional argument designating the type of visualization to generate. Must be one of the types output by the `graph_mesh.py list` command.
- `input`: A required positional argument containing a path or url to the input source. This must be one of the following:
   - A path to Klipper's Unix Domain Socket
   - A url to an instance of Moonraker
   - A path to a json file produced by `graph_mesh.py dump <input>`
- `-a`: Optional animation for the `path` and `rapid` visualization types. Animations only apply to a live preview.
- `-s`: Optionally scales a plot using the `axis_minimum` and `axis_maximum` values reported by Klipper's `toolhead` object when the dump file was generated.
- `-p`: A profile name that may be specified when generating the `probedz` 3D mesh visualization. When generating an `overlay` or `delta` visualization this argument must be provided.
- `-o`: An optional file path indicating that the script should save the visualization to this location rather than run in preview mode. Images are saved in `svg` format.

For example, to plot an animated rapid path, connecting via Klipper's unix socket:

```
graph_mesh.py plot -a rapid ~/printer_data/comms/klippy.sock
```

Or to plot a 3d visualization of the mesh, connecting via Moonraker:

```
graph_mesh.py plot meshz http://my-printer.local
```

### Bed Mesh Analysis

The `graph_mesh.py` tool may also be used to perform an analysis on the data provided by the [bed_mesh/dump_mesh](#dumping-mesh-data) API:

```
graph_mesh.py analyze <input>
```

As with the `plot` command, the `<input>` must be a path to Klipper's unix socket, a URL to an instance of Moonraker, or a path to a json file generated by the dump command.

To begin, the analysis will perform various checks on the points and probe paths generated by `bed_mesh` at the time of the dump. This includes the following:

- The number of probe points generated, without any additions
- The number of probe points generated including any points generated as the result faulty regions and/or a configured zero reference position.
- The number of probe points generated when performing a rapid scan.
- The total number of moves generated for a rapid scan.
- A validation that the probe points generated for a rapid scan are identical to the probe points generated for a standard probing procedure.
- A "backtracking" check for both the standard probe path and a rapid scan path. Backtracking can be defined as moving to the same position more than once during the probing procedure. Backtracking should never occur during a standard probe. Faulty regions *can* result in backtracking during a rapid scan in an attempt to avoid entering a faulty region when approaching or leaving a probe location, however should never occur otherwise.

Next each probed mesh present in the dump will by analyzed, beginning with the mesh loaded at the time of the dump (if present) and followed by any saved profiles. The following data is extracted:

- Mesh shape (Min X,Y, Max X,Y Probe Count)
- Mesh Z range, (Minimum Z, Maximum Z)
- Mean Z value in the mesh
- Standard Deviation of the Z values in the Mesh

In addition to the above, a delta analysis is performed between meshes with the same shape, reporting the following:

- The range of the delta between to meshes (Minimum and Maximum)
- The mean delta
- Standard Deviation of the delta
- The absolute maximum difference
- The absolute mean

### Save mesh data to a file

The `dump` command may be used to save the response to a file which can be shared for analysis when troubleshooting:

```
graph_mesh.py dump -o <output file name> <input>
```

The `<input>` should be a path to Klipper's unix socket or a URL to an instance of Moonraker. The `-o` option may be used to specify the path to the output file. If omitted, the file will be saved in the working directory, with a file name in the following format:

`klipper-bedmesh-{year}{month}{day}{hour}{minute}{second}.json`
