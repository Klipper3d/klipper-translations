# Klipper 패키징

Klipper는 빌드 및 설치를 위해 setuptools 를 사용하지 않기 때문에 파이썬 프로그램 사이에서 다소 패키징 이상입니다. 가장 좋은 패키징 방법에 대한 몇 가지 참고 사항은 다음과 같습니다:

## C 모듈

Klipper는 C 모듈을 사용하여 일부 운동학 계산을 더 빠르게 처리합니다. 이 모듈은 컴파일러에 런타임 종속성을 도입하지 않도록 패키징 시 컴파일해야 합니다. C 모듈을 컴파일하려면 `python2 klippy/chelper/__init__.py`를 실행합니다.

## 파이썬 코드 컴파일

많은 배포판에는 시작 시간을 개선하기 위해 패키징하기 전에 모든 파이썬 코드를 컴파일하는 정책이 있습니다. `python2 -m compileall klippy`를 실행하여 이를 수행할 수 있습니다.

## 버전 관리

git에서 Klipper 패키지를 빌드하는 경우 .git 디렉토리를 제공하지 않는 것이 일반적이므로 git 없이 버전 관리를 처리해야 합니다. 이렇게 하려면 `python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`과 같이 실행되어야 하는데, `scripts/make_version.py` 에 제공된 스크립트를 사용합니다.

## 샘플 패키징 스크립트

klipper-git은 Arch Linux 용으로 패키지되어 있으며 https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git에서 PKGBUILD(패키지 빌드 스크립트)를 사용할 수 있습니다.
