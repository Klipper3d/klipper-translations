# Packaging Klipper

Klipper является своего рода аномалией упаковки среди программ на Python, поскольку он не использует setuptools для сборки и установки. Некоторые замечания относительно того, как лучше всего его упаковать, следующие:

## Модули C

Klipper использует модуль C для более быстрой обработки некоторых кинематических вычислений. Этот модуль должен быть скомпилирован во время упаковки, чтобы избежать введения зависимости времени выполнения от компилятора. Чтобы скомпилировать модуль C, запустите `python2 klippy/chelper/__init__.py `.

## Компиляция кода python

Во многих дистрибутивах существует политика компиляции всего кода python перед упаковкой, чтобы увеличить время запуска. Вы можете сделать это, запустив "python2 -m compileall klippy`.

## Versioning

If you are building a package of Klipper from git, it is usual practice not to ship a .git directory, so the versioning must be handled without git. To do this, use the script shipped in `scripts/make_version.py` which should be run as follows: `python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`.

## Sample packaging script

klipper-git is packaged for Arch Linux, and has a PKGBUILD (package build script) available at [Arch User Repository](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git).
