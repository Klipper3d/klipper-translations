# Contacto

Este documento provee información de contacto para Klipper.

1. [Foro Comunitario](#community-forum)
1. [Chat de Discord](#discord-chat)
1. [Tengo una pregunta sobre Klipper](#i-have-a-question-about-klipper)
1. [Tengo un sugerencia sobre funcionalidades](#i-have-a-feature-request)
1. [¡Ayuda! ¡No funciona!](#help-it-doesnt-work)
1. [He diagnosticado un defecto en software de Klipper](#i-have-diagnosed-a-defect-in-the-klipper-software)
1. [He realizado cambios que me gustaría añadir a Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)

## Foro Comunitario

Hay un [servidor comunitario de Discourse para Klipper](https://community.klipper3d.org) para discutir sobre Klipper.

## Chat de Discord

Existe un servidor de Discord dedicado a Klipper en: <https://discord.klipper3d.org>.

Este servidor es administrado por una comunidad de entusiastas de Klipper dedicados a conversar sobre Klipper. Permite a los usuarios chatear con otros usuario en tiempo real.

## Tengo una pregunta sobre Klipper

Muchas de las preguntas que recibimos ya están respondiddas en la [documentación de Klipper](Overview.md). Por favor, asegúrese de leer la documentación y seguir las instrucciones que allí se indican.

Es posible buscar preguntas similares en el [Foro Comunitario de Klipper](#community-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Community Forum](#community-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

Many questions we receive are general 3d-printing questions that are not specific to Klipper. If you have a general question or are experiencing general printing problems, then you will likely get a better response by asking in a general 3d-printing forum or a forum dedicated to your printer hardware.

No crees una Issue (reporte de problemas) en el GitHub de Klipper para realizar una pregunta.

## Tengo una sugerencia para una nueva funcionalidad

Todas las nuevas funcionalidades requieren que alguien esté interesado y sea capaz de implementarlas. Si estás interesado en ayudar a implementar o probar una nueva funcionalidad, puedes buscar desarrollos que se están llevando a cabo ahora mismo en el [Foro Comunitario de Klipper](#community-forum). También hay un [Chat de Discord para Klipper](#discord-chat) para conversaciones entre colaboradores.

No abráis un fallo en el GitHub de Klipper para pedir una nueva funcionalidad.

## ¡Ayuda! ¡Esto no funciona!

Desafortunadamente, recibimos muchísimas más peticiones de ayuda de las que posiblemente podamos responder. La mayoría de los reportes de problemas que vemos se achican eventualmente a:

1. Errores sutiles en el hardware, o
1. No seguir todos los pasos descritos en la documentación de Klipper.

Si estás experimentando problemas le recomendamos que lea cuidadosamente la [documentación de Klipper](Overview.md) y verifique por segunda vez que sigue todos los pasos.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then you will likely get a better response by searching in a general 3d-printing forum or in a forum dedicated to your printer hardware.

También es posible buscar problemas similares en el [Foro de la Comunidad de Klipper](#community-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Community Forum](#community-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

No abráis un fallo en el GitHub de Klipper para pedir ayuda.

## He diagnosticado un defecto en el software de Klipper

Klipper es un proyecto de código libre y apreciamos cuando colaboradores diagnostican errores en el software.

Hay información importante que será necesaria para poder arreglar un error. Por favor siga los siguientes pasos:

1. Be sure the bug is in the Klipper software. If you are thinking "there is a problem, I can't figure out why, and therefore it is a Klipper bug", then **do not** open a github issue. In that case, someone interested and able will need to first research and diagnose the root cause of the problem. If you would like to share the results of your research or check if other users are experiencing similar issues then you can search the [Klipper Community Forum](#community-forum).
1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you will need to reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting an issue.
1. If possible, run an `M112` command in the OctoPrint terminal window immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. Obtain the Klipper log file from the event. The log file has been engineered to answer common questions the Klipper developers have about the software and its environment (software version, hardware type, configuration, event timing, and hundreds of other questions).
   1. El archivo de registro de Klipper está localizado en `/tmp/klippy.log`en el ordenador "anfitrión" de Klipper (la Raspberry PI).
   1. An "scp" or "sftp" utility is needed to copy this log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). If using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or `parent folder` until you get to the root directory, click on the `tmp` folder, and then select the `klippy.log` file.
   1. Copia el archivo de registro a tu escritorio de tal manera que pueda ser adjuntado a su reporte de errores.
   1. No modifique el archivo de registro de ninguna forma; no provea un cacho del registro. Solamente el archivo de registro completo y sin modificar provee la información necesaria.
   1. Si el archivo de registro es muy grande (por ejemplo, mayor de 2MB de espacio) entonces uno puede necesitar comprimir el registro usando zip o gzip.

   1. Open a new github issue at <https://github.com/Klipper3d/klipper/issues> and provide a clear description of the problem. The Klipper developers need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The Klipper log file **must be attached** to that ticket:![adjuntar un reporte de errores](img/attach-issue.png)

## Estoy realizando cambios que me gustaría que fueran incluidos en Klipper

Klipper es un software de código libre y apreciamos nuevos contribuidores.

Nuevas contribuciones (tanto para código como documentación) son presentadas mediante Pull Requests de GitHub. Mirese el documento [CONTRIBUYENDO](CONTRIBUTING.md) para más información importante.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Community Forum](#community-forum) or on the [Klipper Community Discord](#discord-chat). If you would like to provide an update on your current progress then you can open a Github issue with the location of your code, an overview of the changes, and a description of its current status.
