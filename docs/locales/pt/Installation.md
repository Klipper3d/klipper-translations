# Instalação

Estas instruções assumem que o o software irá correr num anfitrião/host linux que esteja a executar uma interface compatível com Klipper. É recomendado que seja usado um minicomputador, tal como uma Raspberry Pi ou um dispositivo Linux baseado em Debian, como host/anfitrião (ver o [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) para mais opções).

Para o propósito destas instruções, host/anfitrião relaciona-se com o dispositivo Linux e MCU relaciona-se com a placa da impressora. Minicomputador relaciona-se com pequenos computadores, tais como Raspberry Pi.

## Obter um ficheiro de configuração de Klipper

A maioria das definições do Klipper são determinadas pelo "ficheiro de configuração da impressora" printer.cfg, que irá ser guardado no host/anfitrião. Uma configuração apropriada pode ser frequentemente encontrada procurando no Klipper [config directory](../config/) por um ficheiro que começa com o prefixo "printer-" que corresponda à impressora alvo. O ficheiro de configuração do Klipper contèm informação técnica sobre a impressora que será preciso durante a Instalação.

Se não houver um ficheiro de configuração apropriado para a tua impressora no diretório de configurações do Klipper, então tenta procurar no website do fabricante da impressora se eles têm uma configuração apropriada para Klipper.

Se não encontrares qualquer ficheiro de configuração específico para a tua impressora, mas o tipo de placa-mãe for conhecida, então procura pela configuração mais apropriada que comece com o prefixo "generic-". Esses ficheiros de exemplo para a placa-mãe devem permitir concluir a Instalação inicial, mas irão requerer alguma customização para desbloquear a total funcionalidade da impressora.Instalação.

É também possível criar uma configuração para a impressora de raiz. No entanto, isto requer um grande conhecimento técnico sobre a impressora e sobre os seus componentes. É recomendado que a maioria dos utilizadores comecem com um ficheiro de configuração apropriado. Se fores criar um ficheiro de configuração desde a raiz, então começa com o exemplo mais próximo possível [config file](../config/) e usa o Klipper [config reference](Config_Reference.md) para mais informações.

## Interação com o Klipper

O Klipper é um firmware para impressoras 3d, então precisa de alguma maneira do utilizador interagir com ele.

Atualmente, as melhores escolhas são as interfaces que buscam informação através do [Moonraker web API](https://moonraker.readthedocs.io/) e também há a opção de usar o [Octoprint](https://octoprint.org/) para controlar o Klipper.

A escolha é do utilizador em qual usar, mas as bases do Klipper são as mesmas em todos os casos. Nós encorajamos os utilizadores a investigar as opções disponíveis e a fazer uma decisão informada.

## Obter uma imagem de Sistema Operativo (OS) para SBC

Existem diversas maneiras de obter uma imagem de SO para o Klipper para usar eum minicomputador, a maioria depende da interface que prefiras usar. Alguns fabricantes de minicomputadores também disponibilizam as suas próprias imagens de Klipper.

Existem duas interfaces baseadas em Moonraker, o [Fluidd](https://docs.fluidd.xyz/) e o [Mainsail](https://docs.mainsail.xyz/), sendo que este último tem uma imagem de instalação pré-feita, o ["MainsailOS"](https://docs-os.mainsail.xyz/), isto tem a opção para Raspberry Pi e para algumas variantes de OrangePI.

O Fluidd pode ser instalado através do KIAUH (o ajudante de instalação e atualização do Klipper), o qual é explicado abaixo e é um instalador de terceiros para todas as coisas relacionadas com o Klipper.

O OctoPrint pode ser instalado através da popular imagem Octopi ou através do KIAUH, sendo este processo explicado em <OctoPrint.md>

## Instalar através do KIAUH

Normalmente começarias com a imagem base do minicomputador, RPiOS Lite por exemplo, ou no caso de um dispositivo Linux x86, Ubuntu Server. Por favor, nota que essas variantes de desktop não são recomendadas devido a determinados programas de ajudantes que podem impedir algumas funções do Klipper de funcionar e até mascarar o acesso a placas de algumas impressoras.

O KIAUH pode ser usado para instalar o Klipper e os seus programas associados numas variada de sistemas baseados em Linux que executam alguma versão de Debian. Mais informações podem ser encontradas em https://github.com/dw-0/kiauh

## Construindo e atualizando o micro controlador

Para compilar o código do Micro-controlador, começa por executar os seguintes comandos no seus dispositivo host/anfitrião:

```
cd ~/klipper/
make menuconfig
```

Os comentários no topo do ficheiro de configuração da impressora (printer.cfg)(#obtain-a-klipper-configuration-file) devem explicar as definições que deves colocar durante o "make menuconfig". Abre o ficheiro num browser ou editor de texto e procura pelas instruções no início do texto. Quando as definições corretas do "menuconfig" estiverem colocadas, pressiona "Q" para sair e, depois, "Y" para salvar. Depois coloca:

```
make
```

Se os comentários no topo do [printer configuration file](#obtain-a-klipper-configuration-file) mostrarem passos especificos para gravar a imagem final na placa da impressora, então segue esses passos e depois procede para [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Caso contrário, os seguintes passos são usados frequentemente para gravar na placa controladora da impressora. Primeiro, é necessário descobrir a porta serial conectada ao micro-controlador. Executa o seguinte:

```
ls /dev/serial/by-id/*
```

Deve relatar algo semelhante ao seguinte:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

É comum para cada impressora ter um nome único de porta serial. Este nome único será usado quando estiver a gravar no Micro-controlador. É possível que existam múltiplas linhas no output - caso seja esse o caso, escolhe a linha que corresponde ao Micro-controlador. Se existirem diversas linhas e a escolha for ambígua, desconecta a placa e executa o comando novamente, a linha que desaparecer será a placa da impressora (vê o [FAQ](FAQ.md#wheres-my-serial-port) para mais informação).

Para micro-controladores comuns com STM32 ou chips clones, chips LPC e outros, é frequente que eles precisem de que a gravação inicial do Klipper seja feita através de cartão SD.

Ao gravar através deste método, é importante que te certifiques que a placa da impressora não esteja conectada com USB ao host/anfitrião, visto que algumas placas são capazes de devolver corrente e interromper a gravação de ser concluida.

Por favor, nota que a maioria das impressoras que usa cartão SD para gravar, irá implementar algum tipo de proteção para loops de gravação para quando o cartão é deixado. Estes são os dois métodos mais comuns:

Mudança de nome de ficheiro é necessária (normalmente nas placas das impressoras originais/stock):

Estas placas precisam de um ficheiro de firmware que tenha um nome diferente cada vez que gravas (p.e firmware1.bin, firmware2.bin, etc...). Se tu reutilizares o mesmo nome, a placa pode apenas ignorar e não irá atualizar.

Mudança de nome automática (normalmente nas placas do mercado de acessórios):

Outras placas permitem usar o mesmo nome de ficheiro, comummente firmware.bin, mas depois de gravar, a placa muda o nome do ficheiro para firmware.cur. Isto ajuda a saber se o firmware foi gravado com sucesso e previne que grave novamente na próxima inicialização.

Antes de gravar, certifica-te de verificar qual o comportamento da tua placa.

Para Micro-controladores comuns que usem os chips Atmega. por exemplo o 2560, o código pode ser gravado em algo similar a:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Certifica-te de atualizar o FLASH_DEVICE com o nome da porta serial único da tua impressora.

Para Micro-controladores comuns que usem os chips RP2040, o código pode ser gravado como algo similar a:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

É importante notar que os chips RP2040 podem precisar de ser colocados em modo de Boot antes desta operação.

## Configurar o Klipper

O próximo passo é copiar o [ficheiro de configuração da impressora](#obtain-a-klipper-configuration-file) para o Host/anfitrião.

Discutivelmente, o método mais de colocar o ficheiro de configuração do Klipper é através dos editores integrados no Mainsail e Fluidd. Esses permitem ao utilizador abrir os exemplos de configuração e salvá-los para serem o printer.cfg.

Outra opção será usar um editor que suporta a edição de ficheiros "scp" e/ou protocolos "sftp". Existem ferramentas gratuitas que suportam isso (p.e Notepad++, WinSCP, e Cyberduck). Carrega o ficheiro de configuração no editor e depois salva o ficheiro como "printer.cfg" no diretório principal do utilizador PI (p.e /home/pi/printer.cfg).

Em alternativa, também podes copiar e editar o ficheiro diretamente para o host/anfitrião por SSH. Isso poderá se parecer algo como o seguinte (certifica-te de alterar o comando para usar o nome de ficheiro de configuração da impressora):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

É comum que cada impressora tenha um nome único para o micro-controlador. O nome poderá ser alterado depois de o Klipper ser gravado, então reexecuta estes passos outra vez, mesmo que eles já tenham sido feitos quando gravou. Executa:

```
ls /dev/serial/by-id/*
```

Deve relatar algo semelhante ao seguinte:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Depois atualiza o ficheiro de configuração com o nome único da impressora. Por exemplo, atualiza a secção `MCU`, de forma a se parecer algo como:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Depois de criar e editar o ficheiro, será necessário enviar um comando de "restart" na consola de comandos para carregar a configuração. Um comando de "status" irá dizer se a impressora está pronta ("ready"), se o ficheiro de configuração foi lido com sucesso e se o micro-controlador foi encontrado com sucesso e configurado.

Quando se costumiza um ficheiro de configuração de impressora, não é pouco comum que o Klipper reporte um erro de configuração- Se ocorrer um erro, faz qualquer correção necessária ao ficheiro de configuração e depois clica em "restart" até o "status" dizer que a impressora está pronta.

O Klipper irá reportar mensagens de erro através da consola de comandos e pop-ups no Fluidd e Mainsail. O comando de "status" poderá ser usado para voltar a emitir as mensagens de erro. Um arquivo de log está disponível e é localizado em `~/printer_data/logs/klippy.log`.

Depois de o Klipper detectar que a impressora está pronta, segue para o [config check document](Config_checks.md) para realizar algumas verificações básicas nas definições do ficheiro de configuração. Vê a principal [documentation reference](Overview.md) para outras informações.
