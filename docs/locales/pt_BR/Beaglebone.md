# Beaglebone

Este documento descreve o processo para executar o Klipper em um Beaglebone PRU.

## Construindo uma imagem de sistema operacional

Comece instalando a imagem [Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images). É possível executar a imagem a partir de um cartão micro-SD ou do eMMC embutido. Se estiver usando o eMMC, instale-o agora no eMMC seguindo as instruções do link acima.

Em seguida, faça ssh na máquina Beaglebone (`ssh debian@beaglebone` -- a senha é `temppwd`) e instale o Klipper executando os seguintes comandos:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-beaglebone.sh
```

## Instalar o Octoprint

Em seguida, você pode instalar o Octoprint:

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

E configure o OctoPrint para começar na inicialização:

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

É necessário modificar o arquivo de configuração **/etc/default/octoprint** do OctoPrint. É preciso alterar o usuário `OCTOPRINT_USER` para `debian`, alterar `NICELEVEL` para `0`, descomentar as configurações `BASEDIR`, `CONFIGFILE` e `DAEMON` e alterar as referências de `/home/pi/` para `/home/debian/`:

```
sudo nano /etc/default/octoprint
```

Em seguida, inicie o serviço Octoprint:

```
sudo systemctl start octoprint
```

Certifique-se de que o servidor web do OctoPrint está acessível - ele deve estar em: <http://beaglebone:5000/>

## Construindo o código do micro-controlador

Para compilar o código do micro-controlador do Klipper, comece configurando-o para o "Beaglebone PRU":

```
cd ~/klipper/
make menuconfig
```

Para construir e instalar o novo código do micro-controlador, execute:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Também é necessário compilar e instalar o código do micro-controlador para um processo de host Linux. Configure-o uma segunda vez para um "processo Linux":

```
make menuconfig
```

Em seguida, instale este código de micro-controlador também:

```
sudo service klipper stop
make flash
sudo service klipper start
```

## Configuração restante

Complete a instalação configurando o Klipper e o Octoprint seguindo as instruções no documento principal [Instalação](Installation.md#configuring-klipper).

## Impressão no Beaglebone

Infelizmente, o processador Beaglebone pode às vezes ter dificuldade para executar o OctoPrint bem. Paradas de impressão são conhecidas por ocorrer em impressões complexas (a impressora pode se mover mais rápido do que o OctoPrint pode enviar comandos de movimento). Se isso ocorrer, considere usar o recurso "virtual_sdcard" (veja [Config Reference](Config_Reference.md#virtual_sdcard) para detalhes) para imprimir diretamente do Klipper.
