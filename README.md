# Control Remoto Infrarrojo

Este proyecto consiste en un sistema que permite simular pulsaciones de teclas mediante un teclado matricial conectado a un microcontrolador (como un ESP32) y la ejecución de comandos en un sistema Windows a través de un puerto serie. 

## Descripción

El proyecto consta de dos archivos principales:

1. **`teclado_serial.ino`**: 
   - Este archivo es un programa para el microcontrolador ESP32 que lee las pulsaciones de un teclado matricial.
   - Cuando se presiona una tecla, se envía un comando por el puerto serie en el formato `KEY:<tecla>`.
   - También permite actualizar la configuración de las teclas y eliminar archivos de configuración en el sistema de archivos SPIFFS del ESP32.

2. **`esp32_app_serial.ps1`**: 
   - Este archivo está diseñado para ejecutarse en un entorno Windows usando PowerShell. 
   - Utiliza la API de Windows para simular pulsaciones de teclas cuando recibe comandos a través de un puerto serie.
   - Mapea teclas desde el teclado matricial a los códigos de las teclas del teclado numérico y realiza la simulación de las pulsaciones correspondientes.

## Requisitos

- Un microcontrolador ESP32.
- Un teclado matricial de 4x5.
- Un ordenador con Windows para ejecutar el script de PowerShell.
- Conexión entre el ESP32 y el ordenador a través de un puerto serie.

## Configuración

### En el ESP32

1. Conectar el teclado matricial a los pines definidos en el archivo `teclado_serial.ino`.
2. Cargar el código en el ESP32 usando el IDE de Arduino.
3. Asegurarse de que SPIFFS está habilitado y funcionando correctamente.

### En Windows

1. Abrir PowerShell.
2. Cambiar el valor de `$portName` en `esp32_app_serial.ps1` al puerto correcto al que está conectado el ESP32.
3. Ejecutar el script en PowerShell. El script estará a la espera de comandos enviados desde el ESP32.

## Uso

- Al presionar las teclas en el teclado matricial, se enviarán las señales correspondientes al ordenador, que simulará las pulsaciones de teclas.
- Puedes modificar la asignación de teclas editando el archivo `teclado_serial.ino` y subiendo de nuevo el código al ESP32.

## Notas

- Asegúrate de que el puerto serie utilizado está disponible y no está siendo usado por otra aplicación.
- Se recomienda verificar la configuración del teclado matricial y la conexión eléctrica para un funcionamiento óptimo.

## Contribuciones

Las contribuciones son bienvenidas. Si tienes alguna sugerencia o encuentras un error, no dudes en abrir un *issue* o un *pull request*.


