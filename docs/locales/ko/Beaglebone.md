# 비글본

이 문서는 비글본 PRU 에서 클리퍼를 실행시키는 과정에 대해 설명합니다.

## OS 이미지 빌드하기

시작은 다음 이미지를 설치하는 것부터 입니다. [Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images) 이 이미지는 마이크로SD 카드나 내장된 eMMC 로 부터 실행시킬 수 있습니다. 만일 eMMC 를 사용한다면, 위 링크로 부터 다음 절차에 따라 eMMC 에 지금 설치하십시오.

그리고 비글본 장치로 접속하십시오. (ssh debian@beaglebone -- password is "temppwd") 그다음 아래 명령어를 실행시켜 클리퍼를 설치하시면 됩니다.:

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

필수적으로 옥토프린터의 **/etc/default/octoprint** configuration 을 수정해줘야할 필요가 있습니다. OCTOPRINT_USER 사용자는 "debian" 으로 NICELEVEL 은 0 으로 BASEDIR, CONFIGFILE, DAEMON 셋팅들은 코멘트해제, 그리고 참조(references) 를 "/home/pi/" 에서 "/home/debian/" 으로 변경시킵니다:

```
sudo nano /etc/default/octoprint
```

그 다음 옥토프린터 서비스를 시작합니다:

```
sudo systemctl start octoprint
```

Make sure the octoprint web server is accessible - it should be at: <http://beaglebone:5000/>

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

또한 리눅스 호스트 프로세스를 위해서 마이크로 컨트롤러 코드를 컴파일하고 설치해줄 필요가 있습니다. 두번째로 "make menuconfig" 를 실행시키고, "Linux process"를 위해 그것을 설정해줍니다.:

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

다음 문서 [the main installation document](Installation.md#configuring-klipper) 를 보면서 클리퍼와 옥토프린터의 설정을 완료하십시오.

## 비글본으로 출력해보기

불행하게도, 비글본 프로세서는 옥토프린터를 돌리는데 간혹 버거울 수 있습니다. 프린터 실속(속도를 잃음)은 복잡한 출력을 할 때 발생하는 것으로 알려져 있습니다. (프린터는 옥토프린터가 이동명령을 보내는것보다 더 빨리 움직일 수 있다) 만일 이런 현상이 발생한다면, 클리퍼로 부터 직접적으로 출력하기 위해 "virtual_sdcard" 를 사용할것을 고려해보십시오. (자세한 내용은 다음 링크 참조. [config reference](Config_Reference.md#virtual_sdcard) ).
