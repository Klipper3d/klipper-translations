# 打包 Klipper

Klipper 是個有點反常的 Python 程式，因為它不使用 setuptools 來構建和安裝。關於如何最好地打包它的一些說明如下：

## C 模組

Klipper 使用一個 C 模組來更快地處理一些運動學計算。此模組需要在包裝時間進行編譯，以避免對編譯器的執行環境依賴。要編譯 C 模組，請執行 `python2 klippy/chelper/__init__.py`。

## 編譯 Python 程式碼

許多發行版都有在打包之前編譯所有 Python 程式碼以縮短啟動時間的規定。您可以通過執行 `python2 -m compileall klippy` 來完成此操作。

## 版本管理

如果你從 git 構建 Klipper 包，通常的做法是不提供 .git 目錄，所以版本管理必須在沒有 git 的情況下處理。要做到這一點，請使用 `scripts/make_version.py` 中提供的指令碼，該指令碼應按如下方式執行：`python2 scripts/make_version.py YOURDISTRONAME > klippy/.version`。

## 示例打包指令碼

klipper-git 是 klipper 的 Arch Linux 軟體包，在[Arch User Repositiory](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git)上有一個 PKGBUILD（軟體包構建指令碼）。
