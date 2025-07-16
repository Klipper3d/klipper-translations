# API do Server

Este documento descreve a Interface do Programador de Aplicativos (API) da Klipper. Esta interface permite que aplicativos externos consultem e controlem o software de host Klipper.

## Habilitando o soquete de API

Para usar o servidor API, o software host klippy.py deve ser iniciado com o parâmetro `-a`. Por exemplo:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

Isso faz com que o software host crie um Soquete de domínio Unix, um cliente pode então abrir uma conexão nesse soquete e enviar comandos para Klipper.

Consulte o projeto [Moonraker](https://github.com/Arksine/moonraker) para obter uma ferramenta popular que pode encaminhar solicitações HTTP para o API Server Unix Domain Socket do Klipper.

## Formato da solicitação

As mensagens enviadas e recebidas no soquete são strings codificadas em JSON terminadas por um caractere ASCII 0x03:

```
<json_object_1><0x03><json_object_2><0x03>...
```

O Klipper contém uma ferramenta `scripts/whconsole.py` que pode executar o enquadramento de mensagem acima. Por exemplo:

```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

Esta ferramenta pode ler uma série de comandos JSON do stdin, enviá-los ao Klipper e relatar os resultados. A ferramenta espera que cada comando JSON esteja em uma única linha, e anexará automaticamente o terminador 0x03 ao transmitir uma solicitação. (O servidor API Klipper não possui um requisito de nova linha.)

## Protocolo de API

O protocolo de comando usado no soquete de comunicação é inspirado em [json-rpc](https://www.jsonrpc.org/).

Uma solicitação pode ser semelhante a:

`{"id": 123, "method": "info", "params": {}}`

e uma resposta pode ser semelhante a:

`{"id": 123, "result": {"state_message": "Printer is ready", "klipper_path": "/home/pi/klipper", "config_file": "/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6", "hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4 (v7l)", "state": "ready", "python_path": "/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}`

Cada solicitação deve ser um dicionário JSON. (Este documento usa o termo "dicionário" do Python para descrever um "objeto JSON" - um mapeamento de chaves/valores contidos em `{}`.)

O dicionário da solicitação deve conter um parâmetro "method" que é o nome da string de um "endpoint" disponível do Klipper.

O dicionário da solicitação pode conter um parâmetro "params" que deve ser do tipo dicionário. Os "parâmetros" fornecem informações de parâmetros para o "endpoint" do Klipper que trata a solicitação. Seu conteúdo é específico para o “endpoint”.

O dicionário da solicitação pode conter um parâmetro "parâmetros" que deve ser o tipo dicionário. Os "parâmetros" fornecem informações de parâmetros adicionais para o "endpoint" do Klipper que trata a solicitação. Seu conteúdo é específico para o “endpoint”.

Se o processamento de uma solicitação resultar em um erro, a mensagem de resposta conterá um campo "error" em vez de um campo "result". Por exemplo, a solicitação: `{"id": 123, "method": "gcode/script", "params": {"script": "G1 X200"}}` pode resultar em uma resposta de erro como: ` {"id": 123, "error": {"message": "Must home axis first: 200.000 0.000 0.000 [0.000]", "error": "WebRequestError"}}`

O Klipper sempre começará a processar as solicitações na ordem em que forem recebidas. No entanto, algumas solicitações podem não ser concluídas imediatamente, o que pode fazer com que a resposta associada seja enviada fora de ordem em relação às outras respostas. Uma solicitação JSON nunca pausará o processamento de solicitações JSON futuras.

## Assinaturas (Subscriptions)

Algumas solicitações de "endpoint" do Klipper permitem "assinar" (subscribe) futuras mensagens de atualização assíncronas (async).

Por exemplo:

`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{"key": 345}}}`

pode responder com:

`{"id": 123, "result": {}}`

e fazer com que o Klipper envie mensagens semelhantes a:

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

Uma solicitação de uma assinatura aceita um dicionário "response_template" no campo "params" da solicitação. Esse dicionário "response_template" é usado como modelo para futuras mensagens assíncronas (async) - ele pode conter pares chave/valor arbitrários. Ao enviar essas futuras mensagens assíncronas, o Klipper adicionará um campo "params" contendo um dicionário com conteúdo específico do "endpoint" ao modelo de resposta e então enviará esse modelo. Se um campo "response_template" não for fornecido, o padrão será um dicionário vazio (`{}`).

## "endpoints" disponíveis

Os "endpoints" do Klipper têm o formato `<nome_do_modulo>/<algum_nome>`. Ao fazer uma solicitação para um "endpoint", o nome completo deve ser definido no parâmetro "method" do dicionário da solicitação (por exemplo, `{"method"="gcode/restart"}`).

### informações

O endpoint "info" é usado para obter informações do sistema e da versão do Klipper. Também é usado para fornecer informações de versão do Klipper. Por exemplo: `{"id": 123, "method": "info", "params": { "client_info": { "version": "v1"}}}`

Se existir, o parâmetro "client_info" deve ser um dicionário, mas esse dicionário pode ter conteúdo arbitrário. Os clientes são incentivados a fornecer o nome do cliente e sua versão do software ao se conectarem pela primeira vez à API do Klipper.

### emergency_stop

O endpoint "emergency_stop" é usado para instruir o Klipper a desligar imediatamente. Se comporta de forma semelhante ao comando G-Code `M112`. Por exemplo: `{"id": 123, "method": "emergency_stop"}`

### register_remote_method

Este endpoint permite que os clientes registrem métodos que podem ser chamados pelo klipper. Ele retornará um objeto vazio em caso de sucesso.

Por exemplo: `{"id": 123, "method": "register_remote_method", "params": {"response_template": {"action": "run_paneldue_beep"}, "remote_method": "paneldue_beep"}}` retornará : `{"id": 123, "resultado": {}}`

O `paneldue_beep` agora pode ser chamado pelo Klipper. Observe que se o método aceita parâmetros, eles devem ser fornecidos como argumentos de palavras-chave. Abaixo está um exemplo de como ele pode ser chamado a partir de um gcode_macro:

```
[gcode_macro PANELDUE_BEEP]
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

Quando a macro PANELDUE_BEEP é executada, o Klipper enviaria algo como: `{"action": "run_paneldue_beep", "params": {"frequency": 300, "duration": 1.0}}`

### objects/list

Esse endpoint consulta a lista de "objetos" disponíveis que podem ser consultados (através do endpoint"objects/query"). Por exemplo: `{"id": 123, "method": "objects/list"}` pode retornar: `{"id": 123, "result": {"objects": ["webhooks", "configfile" , "aquecedores", "gcode_move", "query_endstops", "idle_timeout", "toolhead", "extrusora"]}}`

### objects/query

Este endpoint permite consultar informações de objetos de impressora. Por exemplo: `{"id": 123, "method": "objects/query", "params": {"objects": {"toolhead": ["position"], "webhooks": null}}}` pode retornar: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready", "state_message": "Printer is ready"}, "toolhead": { "posição": [0,0, 0,0, 0,0, 0,0]}}, "eventtime": 3051555.377933684}}`

O parâmetro "objetos" na solicitação deve ser um dicionário contendo os objetos de impressora que serão consultados - a chave contém o nome do objeto de impressora e o valor é "nulo" (para consultar todos os campos) ou uma lista de nomes dos campos.

A mensagem de resposta conterá um campo "status" contendo um dicionário com as informações consultadas - a chave contém o nome do objeto impressora e o valor é um dicionário contendo seus campos. A mensagem de resposta também conterá um campo “eventtime” contendo data/hora de quando a consulta foi feita.

Os campos disponíveis estão documentados no documento [Status Reference](Status_Reference.md).

### objects/subscribe

Esse endpoint permite consultar e assinar informações de objetos de impressora. A solicitação e a resposta do endpoint são idênticas ao endpoint "objects/query". Por exemplo: `{"id": 123, "method": "objects/subscribe", "params": {"objects":{"toolhead": ["position"], "webhooks": ["state"] }, "response_template":{}}}` pode retornar: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3052153.382083195}}` e resulta em mensagens assíncronas (async) subsequentes, como: `{"params": {"status": {"webhooks": {"state": "shutdown"}}, "eventtime": 3052165.418815847}}`

### gcode/help

Este endpoint permite consultar comandos G-Code disponíveis que possuem uma string de ajuda. Por exemplo: `{"id": 123, "method": "gcode/help"}` pode retornar: `{"id": 123, "result": {"RESTORE_GCODE_STATE": "Restore a previously saved G-Code state", "PID_CALIBRATE": "Run PID calibration test", "QUERY_ADC": "Report the last value of an analog pin", ...}}`

### gcode/script

Este endpoint permite executar uma série de comandos G-Code. Por exemplo: `{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}`

Se o script G-Code fornecido gerar um erro, uma resposta de erro será gerada. No entanto, se o comando G-Code produzir um output no terminal, esse output não será fornecida na resposta. (Use o endpoint "gcode/subscribe_output" para obter o output do terminal G-Code.)

Se houver um comando G-Code sendo processado quando esta solicitação for recebida, o script fornecido será enfileirado. Este atraso pode ser significativo (por exemplo, se um comando de espera por temperatura do G-Code estiver em execução). A mensagem de resposta JSON é enviada quando o processamento do script é totalmente concluído.

### gcode/restart

Este endpoint permite solicitar uma reinicialização - é semelhante a executar o comando "RESTART" do G-Code. Por exemplo: `{"id": 123, "method": "gcode/restart"}`

Tal como acontece com o endpoint "gcode/script", este endpoint só é concluído após a conclusão de qualquer comando G-Code pendente.

### gcode/firmware_restart

Isso é semelhante ao endpoint "gcode/restart" - ele executa "FIRMWARE_RESTART". Por exemplo: `{"id": 123, "método": "gcode/firmware_restart"}`

Tal como acontece com o endpoint "gcode/script", este endpoint só é concluído após a conclusão de qualquer comando G-Code pendente.

### gcode/subscribe_output

Este endpoint é usado para assinar (subscribe) em mensagens de terminal G-Code geradas pelo Klipper. Por exemplo: `{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{}}}` pode posteriormente produzir mensagens assíncronas (async) como: `{"params": { "response": "// Klipper state: Shutdown"}}`

Este endpoint destina-se a oferecer suporte à interação humana por meio de uma interface do terminal. A análise do conteúdo da saída do terminal G-Code não é recomendada. Use o endpoint "objects/subscribe" para obter atualizações sobre o estado do Klipper.

### motion_report/dump_stepper

Este endpoint é usado para assinar o fluxo do stepper queue_step interno do Klipper. Obter essas atualizações de movimento de baixo nível pode ser útil para fins de diagnóstico e debug. Usar este endpoint pode aumentar a carga do hardware do sistema do Klipper.

Uma solicitação pode ser semelhante a: `{"id": 123, "method":"motion_report/dump_stepper", "params": {"name": "stepper_x", "response_template": {}}}` and might return: `{"id": 123, "result": {"header": ["interval", "count", "add"]}}` and might later produce asynchronous messages such as: `{"params": {"first_clock": 179601081, "first_time": 8.98, "first_position": 0, "last_clock": 219686097, "last_time": 10.984, "data": [[179601081, 1, 0], [29573, 2, -8685], [16230, 4, -1525], [10559, 6, -160], [10000, 976, 0], [10000, 1000, 0], [10000, 1000, 0], [10000, 1000, 0], [9855, 5, 187], [11632, 4, 1534], [20756, 2, 9442]]}}`

O campo "header" na resposta da consulta inicial é usado para descrever os campos encontrados nas respostas de "data" (dados) posteriores.

### motion_report/dump_trapq

Este endpoint é usado para assinar a "fila de movimento trapezoidal" (trapezoid motion queue) interna do Klipper. Obter essas atualizações de movimento de baixo nível pode ser útil para fins de diagnóstico e debug. Usar este endpoint pode aumentar a carga do hardware do sistema do Klipper.

Uma solicitação pode ter a aparência: `{"id": 123, "method": "motion_report/dump_trapq", "params": {"name": "toolhead", "response_template":{}}}` and might return: `{"id": 1, "result": {"header": ["time", "duration", "start_velocity", "acceleration", "start_position", "direction"]}}` e pode posteriormente produzir mensagens assíncronas, como: `{"params": {"data": [[4.05, 1.0, 0.0, 0.0, [300.0, 0.0, 0.0], [0.0, 0.0, 0.0]], [5.054, 0.001, 0.0, 3000.0, [300.0, 0.0, 0.0], [-1.0, 0.0, 0.0]]]}}`

O campo "header" na resposta da consulta inicial é usado para descrever os campos encontrados nas respostas de "data" (dados) posteriores.

### adxl345/dump_adxl345

Este endpoint é usado para assinar (subscribe) dados do acelerômetro ADXL345. A obtenção dessas atualizações de movimento de baixo nível pode ser útil para fins de diagnóstico e debug. Usar este endpoint pode aumentar a carga do hardware do sistema do Klipper.

Uma solicitação pode ser semelhante a: `{"id": 123, "method":"adxl345/dump_adxl345", "params": {"sensor": "adxl345", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["time","x_acceleration","y_acceleration", "z_acceleration"]}}` e pode posteriormente produzir mensagens assíncronas como: `{"params":{"overflows":0,"data":[[3292.432935,-535.44309,-1529.8374,9561.4], [3292.433256,-382.45935,-1606.32927,9561.48375]]}}`

O campo "header" na resposta da consulta inicial é usado para descrever os campos encontrados nas respostas de "data" (dados) posteriores.

### angle/dump_angle

Este endpoint é usado para assinar [angle sensor data](Config_Reference.md#angle). A obtenção dessas atualizações de movimento de baixo nível pode ser útil para fins de diagnóstico e debug. Usar este endpoint pode aumentar a carga do hardware do sistema do Klipper.

Uma solicitação pode ser semelhante a: `{"id": 123, "method":"angle/dump_angle", "params": {"sensor": "my_angle_sensor", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["time","angle"]}}` e pode posteriormente produzir mensagens assíncronas como: `{"params":{"position_offset":3.151562,"errors":0, "data":[[1290.951905,-5063],[1290.952321,-5065]]}}`

O campo "header" na resposta da consulta inicial é usado para descrever os campos encontrados nas respostas de "data" (dados) posteriores.

### load_cell/dump_force

This endpoint is used to subscribe to force data produced by a load_cell. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method":"load_cell/dump_force", "params": {"sensor": "load_cell", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["time", "force (g)", "counts", "tare_counts"]}}` and might later produce asynchronous messages such as: `{"params":{"data":[[3292.432935, 40.65, 562534, -234467]]}}`

O campo "header" na resposta da consulta inicial é usado para descrever os campos encontrados nas respostas de "data" (dados) posteriores.

### load_cell_probe/dump_taps

This endpoint is used to subscribe to details of probing "tap" events. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method":"load_cell/dump_force", "params": {"sensor": "load_cell", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["probe_tap_event"]}}` and might later produce asynchronous messages such as:

```
{"params":{"tap":'{
   "time": [118032.28039, 118032.2834, ...],
   "force": [-459.4213119680034, -458.1640702543264, ...],
}}}
```

This data can be used to render:

* The time/force graph

### pause_resume/cancel

Este endpoint é semelhante à executar "PRINT_CANCEL". Por exemplo: `{"id": 123, "method": "pause_resume/cancel"}`

Tal como acontece com o endpoint "gcode/script", este endpoint só é concluído após a conclusão de qualquer comando G-Code pendente.

### pause_resume/pause

Este endpoint é semelhante à executar "PAUSE". Por exemplo: `{"id": 123, "method": "pause_resume/pause"}`

Tal como acontece com o endpoint "gcode/script", este endpoint só é concluído após a conclusão de qualquer comando G-Code pendente.

### pause_resume/resume

Este endpoint é semelhante à executar"RESUME". Por exemplo: `{"id": 123, "method": "pause_resume/resume"}`

Tal como acontece com o endpoint "gcode/script", este endpoint só é concluído após a conclusão de qualquer comando G-Code pendente.

### query_endstops/status

Este endpoint consultará os endpoints ativos e retornará o status. Por exemplo: `{"id": 123, "method": "query_endstops/status"}` pode retornar: `{"id": 123, "result": {"y": "open", "x": "open", "z": "TRIGGERED"}}`

Tal como acontece com o endpoint "gcode/script", este endpoint só é concluído após a conclusão de qualquer comando G-Code pendente.

### bed_mesh/dump_mesh

Dumps the configuration and state for the current mesh and all saved profiles.

For example: `{"id": 123, "method": "bed_mesh/dump_mesh"}`

might return:

```
{
    "current_mesh": {
        "name": "eddy-scan-test",
        "probed_matrix": [...],
        "mesh_matrix": [...],
        "mesh_params": {
            "x_count": 9,
            "y_count": 9,
            "mesh_x_pps": 2,
            "mesh_y_pps": 2,
            "algo": "bicubic",
            "tension": 0.5,
            "min_x": 20,
            "max_x": 330,
            "min_y": 30,
            "max_y": 320
        }
    },
    "profiles": {
        "default": {
            "points": [...],
            "mesh_params": {
                "min_x": 20,
                "max_x": 330,
                "min_y": 30,
                "max_y": 320,
                "x_count": 9,
                "y_count": 9,
                "mesh_x_pps": 2,
                "mesh_y_pps": 2,
                "algo": "bicubic",
                "tension": 0.5
            }
        },
        "eddy-scan-test": {
            "points": [...],
            "mesh_params": {
                "x_count": 9,
                "y_count": 9,
                "mesh_x_pps": 2,
                "mesh_y_pps": 2,
                "algo": "bicubic",
                "tension": 0.5,
                "min_x": 20,
                "max_x": 330,
                "min_y": 30,
                "max_y": 320
            }
        },
        "eddy-rapid-test": {
            "points": [...],
            "mesh_params": {
                "x_count": 9,
                "y_count": 9,
                "mesh_x_pps": 2,
                "mesh_y_pps": 2,
                "algo": "bicubic",
                "tension": 0.5,
                "min_x": 20,
                "max_x": 330,
                "min_y": 30,
                "max_y": 320
            }
        }
    },
    "calibration": {
        "points": [...],
        "config": {
            "x_count": 9,
            "y_count": 9,
            "mesh_x_pps": 2,
            "mesh_y_pps": 2,
            "algo": "bicubic",
            "tension": 0.5,
            "mesh_min": [
                20,
                30
            ],
            "mesh_max": [
                330,
                320
            ],
            "origin": null,
            "radius": null
        },
        "probe_path": [...],
        "rapid_path": [...]
    },
    "probe_offsets": [
        0,
        25,
        0.5
    ],
    "axis_minimum": [
        0,
        0,
        -5,
        0
    ],
    "axis_maximum": [
        351,
        358,
        330,
        0
    ]
}
```

The `dump_mesh` endpoint takes one optional parameter, `mesh_args`. This parameter must be an object, where the keys and values are parameters available to [BED_MESH_CALIBRATE](#bed_mesh_calibrate). This will update the mesh configuration and probe points using the supplied parameters prior to returning the result. It is recommended to omit mesh parameters unless it is desired to visualize the probe points and/or travel path before performing `BED_MESH_CALIBRATE`.
