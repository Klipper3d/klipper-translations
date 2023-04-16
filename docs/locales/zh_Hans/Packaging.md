# 打包 Klipper

Klipper 是个有点反常的 Python 程序，因为它不使用 setuptools 来构建和安装。关于如何最好地打包它的一些说明如下：

## C 模块

Klipper 使用一个 C 模块来更快地处理一些运动学计算。此模块需要在包装时间进行编译，以避免对编译器的运行环境依赖。要编译 C 模块，请运行 `python2 klippy/chelper/__init__.py`。

## 编译 Python 代码

许多发行版都有在打包之前编译所有 Python 代码以缩短启动时间的规定。您可以通过运行 `python2 -m compileall klippy` 来完成此操作。

## 版本管理

如果你从 git 构建 Klipper 包，通常的做法是不提供 .git 目录，所以版本管理必须在没有 git 的情况下处理。要做到这一点，请使用 `scripts/make_version.py` 中提供的脚本，该脚本应按如下方式运行：`python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`。

## 示例打包脚本

klipper-git已经为Arch Linux打包，并且在[Arch用户存储库](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git)中提供了PKGBUILD（软件包构建脚本）。
