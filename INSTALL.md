# Instalación de MYDWM

## Distribuciones compatibles

| Distribución | Gestor | Dependencias |
| --- | --- | --- |
| Debian / Ubuntu | `apt` | `build-essential`, librerías X11/Xft y paquetes de sesión |
| Fedora | `dnf` | `gcc`, `make`, librerías X11/Xft y paquetes de sesión |
| Arch Linux | `pacman` | `base-devel`, librerías X11/Xft y paquetes de sesión |

`scripts/lib.sh` detecta el gestor de paquetes y cada script selecciona los
nombres de paquetes correctos para `apt`, `dnf` o `pacman`. El proceso de
compilación e instalación es el mismo en las tres distribuciones.

## Requisitos

- Debian/Ubuntu, Fedora o Arch Linux con systemd.
- Un usuario normal con permisos de `sudo`.
- Conexión a Internet para instalar paquetes.
- Haber iniciado sesión en una sesión gráfica para probar las TUIs y DWM.

No ejecutes los scripts como `root`; usan `sudo` solo para las operaciones del
sistema. En Arch Linux, instala `sudo` si tu sistema mínimo no lo incluye y
actualiza la base de datos antes de empezar:

```sh
sudo pacman -Syu
```

`xcape` es opcional: se intenta instalar, pero si no está en los repositorios de
tu distribución el instalador continúa. Sin `xcape`, usa `Super + P` para abrir
dmenu; `Super` sola requiere `xcape`.

## Instalación completa

```sh
cd ~/Documentos/MYDWM
make setup
```

El `Makefile` ejecuta, en orden:

1. `scripts/01-install-dwm.sh`
2. `scripts/02-install-bar.sh`
3. `scripts/03-install-tuis.sh`
4. `scripts/04-configure-xinit.sh`
5. `make verify`

Al finalizar, cierra sesión y selecciona **DWM** en GDM.

## Instalación por partes

### 1. DWM y picom

```sh
make dwm
```

Instala dependencias, compila DWM desde `src/dwm-6.8`, lo instala en
`/usr/local/bin/dwm` y copia `configs/picom.conf` a `~/.config/picom/`. Si
picom está en ejecución, lo reinicia.

También instala `scrot` y `/usr/local/bin/scrot-shot`. La captura se puede
disparar con `Ctrl+S` o con el bloque `scrht` de la barra.

### 2. Barra, dmenu y red/Bluetooth

```sh
make bar
```

Compila e instala:

- `dmenu`
- `slstatus`
- `slock`

Instala `nmtui` mediante el paquete de NetworkManager de cada distribución,
además de `bluez` y `rfkill`. En Fedora se incluye `NetworkManager-tui` y
`NetworkManager-wifi`; en Arch se incluyen `bluez-utils` y `util-linux` (que
proporciona `rfkill`). También instala `/usr/local/bin/wifi-status`,
`/usr/local/bin/bt-status` y `/usr/local/bin/bluetooth-tui`, y habilita
`bluetooth` y `NetworkManager`.

`wifi-status` usa `iwgetid` si está disponible y, si no, `nmcli` de
NetworkManager. Así la barra funciona en distribuciones donde
`wireless-tools` ya no está en los repositorios.

### 3. TUIs

```sh
make tuis
```

Instala en `/usr/local/bin`:

- `wallpaper-tui`
- `dwm-colors-tui`
- `bluetooth-tui`
- `bt-status`

Crea `~/wallpapers`, copia el fondo por defecto desde
`assets/wallpapers/ballena_minimalista.jpg` y crea
`~/.config/dwm/colors` si no existe. No sobrescribe el fondo ni el tema que ya
tenga el usuario.

Instala los accesos de dmenu en `~/.local/share/applications`.

### Capturas de pantalla

`make dwm` instala `scrot` y `scrot-shot`. `make bar` compila el bloque
`scrht` en slstatus. Las capturas se guardan en `~/Imágenes/Capturas/`.

### 4. Sesión y xinit

```sh
make xinit
```

Instala:

- `/usr/local/bin/dwm-session`
- `/usr/local/bin/dwm-dmenu`
- `/usr/local/bin/redshift-auto`
- `~/.xinitrc`
- `/usr/share/xsessions/dwm.desktop`

`dwm-session` aplica el fondo guardado en `~/.config/wallpaper`, inicia picom,
redshift, slstatus, xcape y DWM.

## Verificación

```sh
make verify
```

Verifica:

- Comandos del sistema.
- Binarios de `/usr/local/bin`.
- Scripts ejecutables.
- Accesos `.desktop`.
- `~/.xinitrc` y la sesión de GDM.
- `~/.config/wallpaper`, `~/wallpapers` y `~/.config/dwm/colors`.
- Que DWM tenga el soporte de recarga de colores.
- Que slstatus y DWM apunten a las rutas correctas, incluido `wifi-status`.
- Que existan `scrot`, `scrot-shot`, el bloque `scrht` y el atajo `Ctrl+S`.

## Archivos de estado

```text
~/.config/picom/picom.conf
~/.config/dwm/colors
~/.config/wallpaper
~/.fehbg
~/wallpapers/
```

El instalador conserva las preferencias existentes de color, fondo y
wallpapers. `picom.conf` y `~/.xinitrc` se respaldan si cambian.

## Problemas comunes

### La barra no muestra WiFi o Bluetooth

Comprueba que `slstatus` está instalado y que la sesión se reinició:

```sh
command -v slstatus
pgrep -a slstatus
```

Reinicia la sesión de DWM.

### El clic en `BT:` no abre el administrador

Comprueba:

```sh
ls -l /usr/local/bin/bluetooth-tui
grep -n 'bluetooth-tui' ~/Documentos/MYDWM/src/dwm-6.8/config.def.h
```

Si el binario se instaló después de iniciar DWM, cierra sesión y vuelve a
entrar.

### El editor de colores no cambia nada en vivo

Comprueba:

```sh
strings /usr/local/bin/dwm | grep _DWM_RELOAD_COLORS
```

Si no aparece, DWM no es la versión con recarga en caliente; vuelve a ejecutar
`make dwm` y reinicia la sesión.

### El fondo vuelve al anterior tras reiniciar

Comprueba:

```sh
cat ~/.config/wallpaper
grep -n 'WALLPAPER' /usr/local/bin/dwm-session
```

`dwm-session` debe leer `~/.config/wallpaper`.

### La tecla Super sola no abre dmenu

Comprueba que `xcape` esté instalado y en ejecución:

```sh
command -v xcape
pgrep -a xcape
```

Si no está disponible en los repositorios de tu distribución, el instalador
muestra una advertencia y continúa. Usa `Super + P` para abrir dmenu o instala
`xcape` desde los repositorios/COPR correspondientes.

### Bluetooth no enciende

Comprueba `rfkill` y el servicio:

```sh
rfkill list bluetooth
systemctl status bluetooth --no-pager
```

El administrador usa `rfkill` + `bluetoothctl`; el servicio `bluetoothd`
permanece activo. Para detener el servicio systemd hace falta `sudo`.

## Limpieza de compilación

```sh
make clean
```

Elimina objetos y binarios de `src/`. No desinstala nada de `/usr/local/bin`.
