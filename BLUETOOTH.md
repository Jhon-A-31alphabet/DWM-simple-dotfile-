# Administrador Bluetooth en la barra de DWM

La barra de estado muestra un bloque Bluetooth junto al bloque WiFi:

```text
WiFi: red | BT: on | BAT: ... | RAM: ... | CPU: ... | hora | fecha
```

El bloque cambia entre `BT: on` y `BT: off` según el estado del adaptador.

El setup instala el bloque, `bt-status` y `bluetooth-tui`. Si la sesión ya
estaba abierta antes de instalar la barra o DWM, cierra sesión y vuelve a
entrar para que el clic use el binario y las rutas nuevos.

## Instalación

```sh
make bar    # barra, bluez, rfkill, bt-status y bluetooth-tui
make tuis   # acceso de dmenu y dependencias Python
```

## Abrir el administrador

Haz **clic izquierdo** sobre el bloque `BT: ...` de la barra. Se abre una
ventana flotante de kitty con el administrador Bluetooth en modo TUI.

También se puede abrir desde una terminal:

```sh
bluetooth-tui
```

o desde dmenu como **Administrador Bluetooth**.

## Funciones

- Muestra el adaptador, su estado y el estado del servicio `bluetooth`.
- Lista los dispositivos conocidos, indicando si están conectados (`C`) o
  emparejados (`P`).
- Permite escanear dispositivos cercanos.
- Permite conectar y desconectar un dispositivo.
- Permite encender y apagar Bluetooth.

Controles:

| Tecla | Acción |
|-------|--------|
| `↑` / `↓` o `j` / `k` | Moverse por la lista |
| `Enter` | Conectar/desconectar el dispositivo seleccionado |
| `e` | Escanear dispositivos (8 segundos) |
| `p` | Encender/apagar Bluetooth |
| `r` | Recargar la lista |
| `q` o `Esc` | Salir |

## Encendido y apagado

Al apagar Bluetooth, el administrador:

1. Apaga el adaptador con `bluetoothctl power off`.
2. Bloquea la radio con `rfkill block bluetooth`.

Al encenderlo:

1. Desbloquea la radio con `rfkill unblock bluetooth`.
2. Espera a que aparezca el controlador.
3. Enciende el adaptador con `bluetoothctl power on`.

El servicio `bluetoothd` se mantiene activo; el estado se muestra en la cabecera
del administrador. Detener o iniciar el servicio de systemd requiere permisos
de administrador (`sudo systemctl stop bluetooth` / `sudo systemctl start
bluetooth`), por eso el botón `p` controla la radio y el adaptador, que es lo
que determina si Bluetooth está encendido o apagado para el usuario.

## Verificación realizada

Se probó el flujo completo:

- Bluetooth apagado inicialmente mediante `rfkill`.
- Encendido desde el administrador.
- Escaneo de dispositivos: se encontraron 6 dispositivos.
- Apagado de nuevo desde el administrador.
- Clic en el bloque `BT:` de la barra: abrió correctamente la ventana
  `Administrador Bluetooth`.

## Archivos

```text
~/Documentos/MYDWM/scripts/bluetooth-tui   fuente
~/Documentos/MYDWM/scripts/bt-status       fuente
/usr/local/bin/bluetooth-tui               ejecutable instalado
/usr/local/bin/bt-status                   ejecutable instalado
~/.local/share/applications/bluetooth-tui.desktop
~/Documentos/MYDWM/BLUETOOTH.md
```

El bloque de la barra se genera desde:

```text
~/Documentos/MYDWM/src/slstatus-1.1/config.def.h
```

y el clic se maneja en:

```text
~/Documentos/MYDWM/src/dwm-6.8/dwm.c
~/Documentos/MYDWM/src/dwm-6.8/config.def.h
```
