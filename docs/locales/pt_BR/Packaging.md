# Embalagem Klipper

O Klipper é uma espécie de anomalia de empacotamento entre os programas python, pois não usa setuptools para compilar e instalar. Algumas notas sobre a melhor forma de embalá-lo são as seguintes:

## módulos C

O Klipper usa um módulo C para lidar com alguns cálculos cinemáticos mais rapidamente. Este módulo precisa ser compilado no momento do empacotamento para evitar a introdução de uma dependência de tempo de execução em um compilador. Para compilar o módulo C, execute `python2 klippy/chelper/__init__.py`.

## Compilando código python

Muitas distribuições têm uma política de compilar todo o código python antes do empacotamento para melhorar o tempo de inicialização. Você pode fazer isso executando `python2 -m compileall klippy`.

## Controle de versão

Se você estiver construindo um pacote do Klipper a partir do git, é prática comum não enviar um diretório .git, portanto, o controle de versão deve ser feito sem o git. Para fazer isso, use o script enviado em `scripts/make_version.py` que deve ser executado da seguinte forma: `python2 scripts/make_version.py SEUDISTRONAME > klippy/.version`.

## Exemplo de script de empacotamento

klipper-git is packaged for Arch Linux, and has a PKGBUILD (package build script) available at [Arch User Repository](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git).
