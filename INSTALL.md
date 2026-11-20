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
- Ejecutar la instalación desde una terminal interactiva para el único
  prompt de `sudo`.
- Conexión a Internet para instalar paquetes.
- Haber iniciado sesión en una sesión gráfica para probar las TUIs y DWM.
- Para el perfil de energía: `power-profiles-daemon` o TLP 1.9 o superior.
  `make tuis` no instala ninguno automáticamente porque son incompatibles entre
  sí; si no hay ninguno, `Bateria` muestra un aviso.

No ejecutes los scripts como `root`; usan `sudo` solo para las operaciones del
sistema. En Arch Linux, instala `sudo` si tu sistema mínimo no lo incluye y
actualiza la base de datos antes de empezar:

```sh
sudo pacman -Syu
```

La instalación completa solicita la contraseña de `sudo` una sola vez al
inicio. `scripts/sudo-once.sh` autentica, mantiene la credencial activa
mientras dura el proceso y ejecuta el resto con `sudo -n`, sin volver a
preguntar ni guardar la contraseña. Si la configuración de `sudo` no permite
reutilizar la autenticación, el instalador se detiene antes de modificar el
sistema.

`xcape` es opcional: se intenta instalar, pero si no está en los repositorios de
tu distribución el instalador continúa. Sin `xcape`, usa `Super + P` para abrir
dmenu; `Super` sola requiere `xcape`.

## Instalación completa

```sh
cd ~/Documentos/MYDWM
make setup
```

`make setup` delega en `scripts/install-all.sh`. Primero
`scripts/sudo-once.sh` pide la contraseña una sola vez y mantiene la credencial
activa; después se ejecuta, en orden:

1. `scripts/01-install-dwm.sh`
2. `scripts/02-install-bar.sh`
3. `scripts/03-install-tuis.sh`
4. `scripts/04-configure-xinit.sh`
5. `make verify`

Al finalizar, cierra sesión y selecciona **DWM** en GDM.

Los objetivos individuales (`make dwm`, `make bar`, `make tuis` y `make xinit`)
también usan `sudo-once.sh` y piden la contraseña una sola vez cada uno.

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
- `battery-tui`
- `redshift-tui`
- `bt-status`

Crea `~/wallpapers`, copia el fondo por defecto desde
`assets/wallpapers/ballena_minimalista.jpg` y crea
`~/.config/dwm/colors` si no existe. No sobrescribe el fondo ni el tema que ya
tenga el usuario.

También crea `~/.config/redshift-night` con un horario Auto inicial
(20:00-07:00, 60 %) solo si el archivo no existe. La TUI `luz nocturna` permite
cambiarlo o elegir un porcentaje manual; el modo manual cancela Auto.

Instala los accesos de dmenu en `~/.local/share/applications`. `Bateria`
detecta PPD o TLP 1.9+ en tiempo de ejecución; no instala ninguno de los dos.

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
- `/usr/local/bin/redshift-night-scheduler`
- `~/.xinitrc`
- `/usr/share/xsessions/dwm.desktop`

`dwm-session` aplica el fondo guardado en `~/.config/wallpaper`, inicia picom,
`redshift-night-scheduler`, slstatus, xcape y DWM. El instalador elimina el
antiguo `/usr/local/bin/redshift-auto` si existe.

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
- Que slstatus y DWM apunten a las rutas correctas, incluidos `wifi-status`,
  `Bateria`, `luz nocturna`, `battery-tui` y `redshift-tui`.
- Que `dwm-session` inicie `redshift-night-scheduler` y no el antiguo
  `redshift-auto`.
- Que existan `scrot`, `scrot-shot`, el bloque `scrht` y el atajo `Ctrl+S`.
- Que `~/.config/redshift-night` exista y que las TUIs nuevas tengan sintaxis
  Python válida.

## Archivos de estado

```text
~/.config/picom/picom.conf
~/.config/dwm/colors
~/.config/wallpaper
~/.config/redshift-night
~/.fehbg
~/wallpapers/
```

`redshift-night` contiene `mode` (`manual` o `auto`), `percent`,
`auto_percent`, `begin` y `end`; la TUI añade `kelvin` con la última
temperatura aplicada. El instalador conserva las
preferencias existentes de color, fondo, luz nocturna y wallpapers.
`picom.conf` y `~/.xinitrc` se respaldan si cambian.

## Problemas comunes

### La instalación vuelve a pedir la contraseña de sudo

Comprueba que la credencial se puede reutilizar desde un proceso hijo:

```sh
sudo -v
bash -c 'sudo -n true'
```

Si el segundo comando falla, `sudo` no está reutilizando la autenticación. En
ese caso el instalador se detiene con un mensaje de error en lugar de pedir la
contraseña varias veces. Revisa `timestamp_timeout` y `timestamp_type` en la
configuración de `sudo`, o ejecuta `make setup` desde una terminal interactiva.

### La barra no muestra WiFi o Bluetooth

Comprueba que `slstatus` está instalado y que la sesión se reinició:

```sh
command -v slstatus
pgrep -a slstatus
```

Reinicia la sesión de DWM.

### La barra no muestra `Bateria` o `luz nocturna`

Comprueba que la versión instalada de slstatus es la nueva y reinicia la
sesión:

```sh
strings /usr/local/bin/slstatus | grep -E 'Bateria|luz nocturna'
pgrep -a slstatus
```

Si no aparecen, ejecuta `make bar` y vuelve a iniciar sesión.

### El clic en `Bateria` o `luz nocturna` no abre su TUI

Comprueba los binarios y vuelve a instalar si faltan:

```sh
ls -l /usr/local/bin/battery-tui /usr/local/bin/redshift-tui
grep -n 'battery-tui\|redshift-tui' \
  ~/Documentos/MYDWM/src/dwm-6.8/config.def.h
```

DWM guarda los clics en el binario compilado; después de `make dwm` hay que
cerrar sesión y volver a entrar.

### `Bateria` dice que no hay backend

Instala uno de los dos, no ambos:

```sh
# Opción A: power-profiles-daemon
powerprofilesctl get

# Opción B: TLP 1.9 o superior
tlp-stat -s | grep -i 'TLP version'
```

Con TLP 1.8 la TUI muestra un aviso porque esa versión no tiene los tres
perfiles. Actualiza a TLP 1.9+ o usa power-profiles-daemon.

### La luz nocturna no cambia o vuelve al valor anterior

Comprueba el estado y el scheduler:

```sh
cat ~/.config/redshift-night
pgrep -af redshift-night-scheduler
pgrep -a redshift
```

`redshift-night-scheduler` debe estar ejecutándose tras iniciar DWM. Si
`mode=auto`, fuera de `begin`-`end` se aplica 6500 K; elige un porcentaje
manual en `luz nocturna` para cancelar Auto. El antiguo `redshift-auto` ya no
se usa y el instalador lo elimina.

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
