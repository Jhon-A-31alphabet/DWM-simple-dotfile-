# Capturas de pantalla con scrot

DWM incluye dos formas de tomar una captura:

- **Ctrl + S**
- **Clic izquierdo en `scrht`** en la barra de estado

El bloque `scrht` se muestra junto a `WiFi:` y `BT:`:

```text
WiFi: red | BT: on/off | scrht | BAT: ... | RAM: ... | CPU: ... | hora | fecha
```

## Instalación

```sh
make dwm   # instala scrot y /usr/local/bin/scrot-shot
make bar   # compila slstatus con el bloque scrht
```

## Ubicación de las capturas

El script usa el directorio de imágenes del usuario:

```text
~/Imágenes/Capturas/
```

Si `xdg-user-dir PICTURES` devuelve otra ruta, se usa esa. El nombre del
archivo incluye fecha y hora con nanosegundos para evitar colisiones:

```text
captura-2026-10-31-15-22-19-998147241.png
```

## Funcionamiento

- `Ctrl+S` ejecuta `/usr/local/bin/scrot-shot`.
- El clic en `scrht` ejecuta el mismo script.
- El script ejecuta `scrot` y guarda una captura de pantalla completa.
- Si `scrot` no está en el `PATH`, usa el respaldo local
  `~/.local/opt/scrot/usr/bin/scrot` cuando existe.

## Archivos

```text
~/Documentos/MYDWM/scripts/scrot-shot
/usr/local/bin/scrot-shot
~/Documentos/MYDWM/src/dwm-6.8/config.def.h   (Ctrl+S y clic scrht)
~/Documentos/MYDWM/src/slstatus-1.1/config.def.h  (bloque scrht)
~/Documentos/MYDWM/SCREENSHOTS.md
```

## Verificación

```sh
command -v scrot
test -x /usr/local/bin/scrot-shot
make verify
```

En una sesión DWM de prueba se comprobó que tanto `Ctrl+S` como el clic en
`scrht` generan una imagen PNG de 1280x720.
