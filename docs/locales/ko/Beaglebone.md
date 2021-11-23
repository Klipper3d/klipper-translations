# 비글본

이 문서는 비글본 PRU 에서 클리퍼를 실행시키는 과정에 대해 설명합니다.

## OS 이미지 빌드하기

시작은 다음 이미지를 설치하는 것부터 입니다. [Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images) 이 이미지는 마이크로SD 카드나 내장된 eMMC 로 부터 실행시킬 수 있습니다. 만일 eMMC 를 사용한다면, 위 링크로 부터 다음 절차에 따라 eMMC 에 지금 설치하십시오.

Then ssh into the Beaglebone machine (`ssh debian@beaglebone` -- password is `temppwd`) and install Klipper by running the following commands:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-beaglebone.sh
```

## 옥토프린트 설치

이제 옥토프린터를 설치하실 수 있습니다. :

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

그리고 옥토프린터를 부팅시 시작하도록 셋업을 해줍니다.:

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

It is necessary to modify OctoPrint's **/etc/default/octoprint** configuration file. One must change the `OCTOPRINT_USER` user to `debian`, change `NICELEVEL` to `0`, uncomment the `BASEDIR`, `CONFIGFILE`, and `DAEMON` settings and change the references from `/home/pi/` to `/home/debian/`:

```
sudo nano /etc/default/octoprint
```

그 다음 옥토프린터 서비스를 시작합니다:

```
sudo systemctl start octoprint
```

Make sure the OctoPrint web server is accessible - it should be at: <http://beaglebone:5000/>

## 마이크로 컨트롤러 코드를 빌드하기

클리퍼의 마이크로 컨트롤러 코드를 컴파일하기 위해 "Beaglebone PRU"에 대한 설정을 해줍니다.:

```
cd ~/klipper/
make menuconfig
```

새로운 마이크로 컨트롤러 코드를 빌드하고 설치하기 위해 다음을 실행시킵니다. :

```
sudo service klipper stop
make flash
sudo service klipper start
```

It is also necessary to compile and install the micro-controller code for a Linux host process. Configure it a second time for a "Linux process":

```
메뉴 설정하기
```

그리고나서 이 마이크로 컨트롤러 코드를 설치해줍니다.:

```
sudo service klipper stop
make flash
sudo service klipper start
```

## 나머지 설정

Complete the installation by configuring Klipper and Octoprint following the instructions in the main [Installation](Installation.md#configuring-klipper) document.

## 비글본으로 출력해보기

Unfortunately, the Beaglebone processor can sometimes struggle to run OctoPrint well. Print stalls have been known to occur on complex prints (the printer may move faster than OctoPrint can send movement commands). If this occurs, consider using the "virtual_sdcard" feature (see [Config Reference](Config_Reference.md#virtual_sdcard) for details) to print directly from Klipper.
