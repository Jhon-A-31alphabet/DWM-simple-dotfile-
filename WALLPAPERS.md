# Selector de fondos de pantalla

Script TUI en Python para cambiar el fondo de DWM usando `feh`.

## Instalación

El setup instala el selector en `/usr/local/bin`, crea `~/wallpapers` y copia
un fondo por defecto:

```sh
make tuis
```

## Carpeta de fondos

El script crea automáticamente:

```text
~/wallpapers
```

Ahí se deben guardar los fondos en formato `.jpg`, `.jpeg`, `.png`, `.webp`,
`.bmp`, `.gif`, `.tif` o `.tiff`.

En el primer arranque, si la carpeta está vacía, el script copia los fondos
que ya existían en `~/Imágenes/fondos` para que haya opciones disponibles.

## Uso

Desde una terminal:

```sh
wallpaper-tui
```

También aparece en dmenu como **Cambiar fondo de pantalla**.

Controles:

- `↑` / `↓` o `j` / `k`: moverse.
- `Enter`: aplicar el fondo seleccionado inmediatamente.
- `r`: recargar la lista después de añadir o quitar archivos.
- `q` o `Esc`: salir.

Al aplicar un fondo, el script:

1. Ejecuta `feh --bg-fill <imagen>` y lo aplica inmediatamente.
2. Guarda la ruta elegida en `~/.config/wallpaper`.

`dwm-session` lee `~/.config/wallpaper` al iniciar DWM, por lo que la elección
se mantiene en los siguientes inicios de sesión. El instalador de sesión se
puede volver a aplicar con:

```sh
make xinit
```

Si el archivo de estado apunta a una imagen que ya no existe, `dwm-session`
usa el fondo por defecto `~/Imágenes/fondos/ballena_minimalista.jpeg` o
`ballena_minimalista.jpg`.

## Archivos

```text
~/Documentos/MYDWM/scripts/wallpaper-tui        fuente
/usr/local/bin/wallpaper-tui                    ejecutable instalado
~/.local/share/applications/wallpaper-tui.desktop
~/.config/wallpaper                             última elección
~/wallpapers/                                   fondos disponibles
~/Documentos/MYDWM/assets/wallpapers/           fondo por defecto del instalador
~/Documentos/MYDWM/scripts/dwm-session          inicio con fondo persistente
```
