# Editor de colores de DWM

Script TUI en Python para cambiar en caliente:

- Color de los bordes de las ventanas.
- Color de fondo de la barra de estado.
- Color de acento de la barra (etiqueta seleccionada, título y bloques
  WiFi/BT/scrht).

## Instalación

El setup instala el editor en `/usr/local/bin` y su acceso de dmenu:

```sh
make tuis
```

## Uso

Desde una terminal:

```sh
dwm-colors-tui
```

También aparece en **dmenu** como **Cambiar colores de DWM**.

Controles:

- `↑` / `↓` o `j` / `k`: moverse entre los tres colores.
- `Enter`: editar el color seleccionado.
- Mientras se edita: `Enter` acepta, `Esc` cancela y `Backspace` borra.
- `a`: aplicar los colores actuales.
- `1` a `5`: aplicar un preset inmediatamente.
- `r`: recargar los valores desde el archivo.
- `q` o `Esc`: salir.

Se aceptan estos formatos de color:

```text
#00FFFF
00FFFF
#0FF
rgb(0,255,255)
0,255,255
0 255 255
```

## Presets

| Tecla | Color    | Hex       |
|-------|----------|-----------|
| `1`   | Cyan     | `#00FFFF` |
| `2`   | Azul     | `#0000FF` |
| `3`   | Verde    | `#00FF00` |
| `4`   | Rojo     | `#FF0000` |
| `5`   | Amarillo | `#FFFF00` |

Al usar un preset, el borde y el fondo de la barra usan ese color exacto. El
acento usa un tono de la misma familia para que la etiqueta seleccionada se
distinga del fondo. El texto se elige automáticamente en negro o blanco según
el contraste.

## Aplicación inmediata

El script escribe:

```text
~/.config/dwm/colors
```

y envía la propiedad X11 `_DWM_RELOAD_COLORS` a DWM. El DWM instalado incluye
soporte para recargar los colores sin cerrar la sesión.

> La sesión que estaba abierta antes de instalar esta versión de DWM sigue
> usando el binario anterior en memoria. Hay que cerrar sesión y volver a
> entrar una vez. A partir de ahí, cada cambio del script se aplica al
> instante. El propio script avisa si detecta que el DWM en ejecución es
> anterior.

## Archivo de colores

```text
border=#00FFFF
bar_bg=#222222
bar_fg=#BBBBBB
accent=#00FFFF
accent_fg=#000000
```

Los colores `bar_fg` y `accent_fg` los calcula automáticamente el script para
mantener el texto legible.

## Archivos

```text
~/Documentos/MYDWM/scripts/dwm-colors-tui   fuente
/usr/local/bin/dwm-colors-tui               ejecutable instalado
~/.local/share/applications/dwm-colors-tui.desktop
~/.config/dwm/colors
~/Documentos/MYDWM/DWM-COLORS.md
```

La comprobación de que el DWM en ejecución es la versión con recarga en caliente
se puede hacer con:

```sh
strings /usr/local/bin/dwm | grep _DWM_RELOAD_COLORS
```
