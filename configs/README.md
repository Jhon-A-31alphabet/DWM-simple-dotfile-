# Configuraciones de DWM

Archivos guardados en esta carpeta:

- `dwm-config.h`: copia de la configuración usada para compilar DWM
  (`src/dwm-6.8/config.def.h`).
  - `borderpx = 5`: bordes de 5 px.
  - `gappx = 30`: separación de 30 px entre ventanas.
  - `bargap = 20`: separación de 20 px entre la barra y las ventanas.
  - Colores por defecto cyan y soporte para recargar colores en caliente.
  - Bloques WiFi, Bluetooth y scrht clicables.
- `slstatus-config.h`: configuración de la barra de estado. Incluye WiFi
  mediante `wifi-status`, Bluetooth, batería, RAM, CPU, hora y fecha.
- `dmenu-config.h`: configuración de dmenu. La selección usa fondo cyan.
- `picom.conf`: sin transparencia global (solo kitty al 85 % de opacidad) y
  con `corner-radius = 0` para que ventanas y barra sean cuadradas.
- `xinitrc`: copia de `~/.xinitrc`, que inicia `dwm-session`.
- `wallpaper-tui.desktop`, `dwm-colors-tui.desktop`,
  `bluetooth-tui.desktop`: accesos para dmenu/escritorio. Se instalan en
  `~/.local/share/applications`.

## Barra de estado

La barra usa `slstatus` y muestra:

```text
WiFi: <red> | BT: on/off | scrht | BAT: ... | RAM: ... | CPU: ... | hora | fecha
```

- Clic izquierdo en `WiFi:` abre `nmtui`.
- Clic izquierdo en `BT:` abre el administrador Bluetooth.
- Clic izquierdo en `scrht` toma una captura con `scrot`.
- `Ctrl+S` también toma una captura.
- Clic central en el resto del texto de estado abre kitty.

## Herramientas TUI

Se instalan en `/usr/local/bin` y aparecen en dmenu:

- `wallpaper-tui`: selector de fondos con `feh`.
- `dwm-colors-tui`: editor de colores de DWM en caliente.
- `bluetooth-tui`: dispositivos, escaneo, conexión y encendido/apagado.
- `bt-status`: estado de Bluetooth para `slstatus`.
- `wifi-status`: estado de WiFi para `slstatus`; usa `iwgetid` o `nmcli`.

## Herramientas del sistema

- `nmtui`: incluido en `network-manager`.
- `bluez` y `bluetoothctl`: pila y cliente Bluetooth.
- `rfkill`: bloqueo/desbloqueo de la radio Bluetooth.
- `wifi-status`: consulta el SSID con `iwgetid` o, si no está disponible, con
  `nmcli` de NetworkManager.
- `python3`, Pillow y `xprop`: dependencias de las TUIs (los nombres de los
  paquetes cambian según la distribución).
- `scrot` y `scrot-shot`: capturas con `Ctrl+S` o clic en `scrht`.
- `bluetuith` es opcional; el administrador integrado es `bluetooth-tui` y no
  depende de `bluetuith`.

## Instalación

La forma recomendada es usar el Makefile de la raíz:

```sh
cd ~/Documentos/MYDWM
make setup
```

También se puede ejecutar por partes:

```sh
make dwm
make bar
make tuis
make xinit
make verify
```

`make dwm` compila e instala DWM y picom. `make bar` instala slstatus, dmenu,
slock, nmtui y Bluetooth. `make tuis` instala los selectores TUI. `make xinit`
configura la sesión y `~/.xinitrc`.

Después hay que reiniciar la sesión de DWM (cerrar sesión y volver a entrar)
para que se use el binario nuevo.

## Estado del usuario

El instalador conserva estas preferencias si ya existen:

```text
~/.config/dwm/colors
~/.config/wallpaper
~/wallpapers/
```

Las configuraciones existentes de `picom.conf` y `~/.xinitrc` se respaldan
antes de reemplazarlas.
