# Packaging Klipper

Klipper es anómalo respecto a otros programas Python porque no utiliza setuptools para la compilación y la instalación. A continuación proporcionamos algunas notas relativas al empaquetamiento óptimo del programa:

## Módulos en C

Klipper se sirve de un módulo escrito en lenguaje C para efectuar determinados cálculos cinemáticos con mayor rapidez. Este módulo ha de compilarse durante el empaquetamiento para evitar introducir una dependencia de ejecución en el compilador. Para compilar el módulo en C, ejecute `python2 klippy/chelper/__init__.py`.

## Compilar el código Python

Muchas distribuciones tienen una normativa que manda compilar todo código escrito en Python antes de empaquetarlo para mejorar el tiempo que tarda en iniciar. Para hacerlo, puede ejecutar `python2 -m compileall klippy`.

## Versionado

Si va a crear un paquete para Klipper a partir de Git, es práctica habitual no incluir el directorio .git; por este motivo, el versionado debe poderse manejar sin Git. Para lograrlo, utilice la secuencia de órdenes que se encuentra en `scripts/make_version.py`, que debe ejecutarse de la siguiente manera: `python2 scripts/make_version.py NOMBREDESUDISTRIBUCIÓN > klippy/.version`.

## Secuencia de órdenes simple para empaquetamiento

klipper-git is packaged for Arch Linux, and has a PKGBUILD (package build script) available at [Arch User Repositiory](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git).
