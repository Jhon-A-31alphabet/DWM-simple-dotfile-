# Atajos de teclado de DWM

Configuración personal de DWM incluida en esta carpeta (`MYDWM`).

## Teclas modificadoras

| Nombre | Tecla |
| --- | --- |
| `MODKEY` / `Super` | Tecla Windows (Super_L) |
| `Alt` / `Mod1` | Tecla Alt |
| `Ctrl` / `Control` | Tecla Control |
| `Shift` | Tecla Shift |

> Al pulsar y soltar `Super` sin combinarla con otra tecla, `xcape` genera
> `Super + P` automáticamente y abre el menú de aplicaciones.

## Lanzar aplicaciones

| Atajo | Acción |
| --- | --- |
| `Super + P` | Abrir `dwm-dmenu` (menú de aplicaciones, apagar, reiniciar y bloquear) |
| `Super` (pulsar y soltar) | Abrir `dwm-dmenu` mediante `xcape` |
| `F13` | Abrir `dwm-dmenu` |
| `Super + F13` | Abrir `dwm-dmenu` |
| `Super + Shift + Enter` | Abrir una terminal (`kitty`) |
| `Ctrl + Alt + Z` | Abrir una terminal (`kitty`) |
| `Super + Shift + V` | Abrir el control de volumen (`pavucontrol`) |

## Capturas de pantalla

| Atajo | Acción |
| --- | --- |
| `Ctrl + S` | Tomar una captura de pantalla con `scrot` |
| `Clic izquierdo` en `scrht` de la barra | Tomar una captura de pantalla |

Las capturas se guardan en `~/Imágenes/Capturas/` con fecha y hora.

## Gestión de ventanas

| Atajo | Acción |
| --- | --- |
| `Super + Shift + C` | Cerrar la ventana enfocada |
| `Alt + F4` | Cerrar la ventana enfocada |
| `Ctrl + Alt + X` | Cerrar la ventana enfocada |
| `Super + Shift + Space` | Alternar entre ventana flotante y mosaico |
| `Super + Return` | Intercambiar la ventana enfocada con la ventana maestra (`zoom`) |
| `Super + J` | Enfocar la siguiente ventana |
| `Super + K` | Enfocar la ventana anterior |
| `Ctrl + J` | Enfocar la siguiente ventana (atajo alternativo) |
| `Super + Tab` | Volver a la vista de etiquetas anterior |

## Diseños (layouts)

| Atajo | Acción |
| --- | --- |
| `Super + T` | Diseño en mosaico (`tile`) |
| `Super + F` | Diseño flotante (`floating`) |
| `Super + M` | Diseño monocle (una ventana maximizada) |
| `Super + Space` | Rotar entre todos los diseños |

## Área maestra y espacio de trabajo

| Atajo | Acción |
| --- | --- |
| `Super + H` | Reducir el tamaño del área maestra |
| `Super + L` | Aumentar el tamaño del área maestra |
| `Super + I` | Aumentar el número de ventanas maestras |
| `Super + D` | Reducir el número de ventanas maestras |

## Etiquetas (escritorios)

| Atajo | Acción |
| --- | --- |
| `Super + 1` … `Super + 9` | Ver la etiqueta indicada |
| `Super + Ctrl + 1` … `Super + Ctrl + 9` | Mostrar u ocultar la etiqueta indicada |
| `Super + Shift + 1` … `Super + Shift + 9` | Mover la ventana enfocada a la etiqueta indicada |
| `Super + Ctrl + Shift + 1` … `Super + Ctrl + Shift + 9` | Añadir o quitar la etiqueta indicada a la ventana enfocada |
| `Super + 0` | Ver todas las etiquetas |
| `Super + Shift + 0` | Mover la ventana enfocada a todas las etiquetas |
| `Alt + Left` | Ver la etiqueta anterior |
| `Alt + Right` | Ver la etiqueta siguiente |

## Monitores

| Atajo | Acción |
| --- | --- |
| `Super + ,` | Enfocar el monitor anterior |
| `Super + .` | Enfocar el monitor siguiente |
| `Super + Shift + ,` | Enviar la ventana enfocada al monitor anterior |
| `Super + Shift + .` | Enviar la ventana enfocada al monitor siguiente |

## Barra de estado y sistema

| Atajo | Acción |
| --- | --- |
| `Super + B` | Mostrar u ocultar la barra de estado |
| `Super + Shift + Q` | Salir de DWM (finaliza la sesión gráfica) |

## Teclas multimedia y de hardware

| Atajo | Acción |
| --- | --- |
| Tecla de bajar volumen | Bajar el volumen un 5 % (`pamixer`) |
| Tecla de subir volumen | Subir el volumen un 5 % (`pamixer`) |
| Tecla de silencio | Activar o desactivar el silencio (`pamixer`) |
| Tecla de bajar brillo | Bajar el brillo un 5 % (`brightnessctl`) |
| Tecla de subir brillo | Subir el brillo un 5 % (`brightnessctl`) |

## Atajos con el ratón

| Atajo | Acción |
| --- | --- |
| `Super + Clic izquierdo` sobre una ventana | Mover la ventana |
| `Super + Clic central` sobre una ventana | Alternar ventana flotante |
| `Super + Clic derecho` sobre una ventana | Redimensionar la ventana |
| `Clic izquierdo` en el borde o esquina de una ventana | Redimensionar arrastrando ese borde o esquina |
| `Clic izquierdo` en una etiqueta de la barra | Ver esa etiqueta |
| `Clic derecho` en una etiqueta de la barra | Mostrar u ocultar esa etiqueta |
| `Super + Clic izquierdo` en una etiqueta | Mover la ventana enfocada a esa etiqueta |
| `Super + Clic derecho` en una etiqueta | Añadir o quitar esa etiqueta a la ventana enfocada |
| `Clic izquierdo` en el símbolo del diseño | Rotar al siguiente diseño |
| `Clic derecho` en el símbolo del diseño | Cambiar al diseño monocle |
| `Clic central` en el título de la ventana | Intercambiar la ventana con la maestra (`zoom`) |
| `Clic izquierdo` en el bloque `WiFi:` de la barra | Abrir `nmtui` |
| `Clic izquierdo` en el bloque `BT:` de la barra | Abrir el administrador Bluetooth |
| `Clic izquierdo` en el bloque `scrht` de la barra | Tomar una captura con `scrot` |
| `Clic central` en el resto del texto de estado | Abrir una terminal (`kitty`) |

## Herramientas TUI

Se pueden abrir desde dmenu:

| Entrada de dmenu | Comando | Función |
| --- | --- | --- |
| Cambiar fondo de pantalla | `wallpaper-tui` | Elegir un fondo de `~/wallpapers` y aplicarlo con `feh` |
| Cambiar colores de DWM | `dwm-colors-tui` | Cambiar bordes, barra y acento en caliente |
| Administrador Bluetooth | `bluetooth-tui` | Ver, escanear, conectar y encender/apagar Bluetooth |

## Apariencia configurada

- Borde de las ventanas: **5 píxeles** (por defecto cyan; configurable con
  `dwm-colors-tui`).
- La barra de estado **no tiene borde**.
- Separación entre ventanas: **30 píxeles**.
- Separación entre la barra de estado y las ventanas: **20 píxeles**.
- Sombras de Picom: **desactivadas**.
- Esquinas redondeadas de Picom: **desactivadas** (`corner-radius = 0`).
- Transparencia: **solo kitty**, al **85 %** de opacidad.
- Acento de la barra: etiqueta seleccionada, título enfocado y bloques
  WiFi/BT/scrht.
- Los colores de bordes y barra se guardan en `~/.config/dwm/colors`.

## Archivos relacionados

- Código fuente de DWM con los cambios: `src/dwm-6.8/`
- Configuración de DWM: `src/dwm-6.8/config.h` y `src/dwm-6.8/config.def.h`
- Configuración de Picom: `configs/picom.conf`
- Scripts de sesión: `scripts/dwm-session`, `scripts/dwm-dmenu`,
  `scripts/redshift-auto`
- TUIs: `scripts/wallpaper-tui`, `scripts/dwm-colors-tui`,
  `scripts/bluetooth-tui`
- Capturas: `scripts/scrot-shot`
- Instalador: `make setup` o `./install.sh`
- Documentación: `README.md`, `INSTALL.md` y `SCREENSHOTS.md`
