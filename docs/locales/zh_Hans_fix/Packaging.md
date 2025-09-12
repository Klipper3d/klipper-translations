# 打包 Klipper

Klipper 在 Python 程序中是一种比较特殊的打包情况，因为它不使用 setuptools 来构建和安装。有关如何最好地打包它的注意事项如下：

## C 模块

Klipper 使用一个 C 模块来更快地处理一些运动学计算。该模块需要在打包时编译，以避免引入运行时对编译器的依赖。要编译 C 模块，请运行 `python2 klippy/chelper/__init__.py`。

## 编译 Python 代码

许多发行版都有在打包前编译所有 Python 代码的策略，以提高启动速度。您可以通过运行 `python2 -m compileall klippy` 来实现这一点。

## 版本控制

如果您是从 git 构建 Klipper 的软件包，通常的做法是不包含 .git 目录，因此必须在没有 git 的情况下处理版本控制。为此，请使用 `scripts/make_version.py` 中附带的脚本，其运行方式如下：`python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`。

## 示例打包脚本

klipper-git 为 Arch Linux 打包，并在 [Arch 用户仓库](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git) 提供了 PKGBUILD（打包构建脚本）。