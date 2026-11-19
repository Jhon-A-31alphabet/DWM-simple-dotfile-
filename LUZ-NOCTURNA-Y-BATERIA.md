# Luz nocturna y perfil de energía

Documentación de las dos TUIs nuevas de MYDWM:

- **luz nocturna** (`redshift-tui`): controla el tono cálido de la pantalla y
  permite programar un horario automático.
- **Bateria** (`battery-tui`): cambia el perfil de energía del equipo entre
  rendimiento, equilibrado y ahorro de batería.

También se documenta `redshift-night-scheduler`, el proceso que mantiene
aplicada la luz nocturna aunque la TUI esté cerrada.

## Instalación y accesos

Las TUIs se instalan con:

```sh
make tuis
```

El setup completo (`make setup`) también instala la barra, DWM y la sesión.
Los binarios quedan en `/usr/local/bin`:

```text
/usr/local/bin/redshift-tui
/usr/local/bin/battery-tui
/usr/local/bin/redshift-night-scheduler
```

Los accesos de dmenu se crean a partir de:

```text
configs/redshift-tui.desktop
configs/battery-tui.desktop
```

y se copian a `~/.local/share/applications`. En dmenu aparecen con los nombres
exactos:

- **luz nocturna**
- **Bateria**

En la barra de slstatus se muestran como los dos primeros bloques:

```text
Bateria | luz nocturna | WiFi: ... | BT: ... | scrht | BAT: ... | ...
```

El clic izquierdo sobre cualquiera de los dos bloques abre su TUI en una
ventana flotante de `kitty`. El clic se implementa en DWM con los comandos
`batterycmd` y `nightcmd`, y el parser `statusblock` de `dwm.c` identifica el
bloque pulsado.

> Si DWM o slstatus se instalaron con la sesión ya abierta, cierra sesión y
> vuelve a entrar para que aparezcan los bloques y los clics nuevos.

## luz nocturna

### Qué hace

`redshift-tui` es una TUI de Python con `curses`. Permite elegir un porcentaje
de luz nocturna entre `0 %` y `100 %`, en pasos de `10 %`, o configurar una
ventana horaria automática con su propio porcentaje.

El porcentaje se convierte en temperatura de color con esta fórmula:

```text
kelvin = 6500 - 50 * porcentaje
```

Por tanto:

| Porcentaje | Temperatura |
| ---: | ---: |
| 0 % | 6500 K (neutro) |
| 10 % | 6000 K |
| 20 % | 5500 K |
| 30 % | 5000 K |
| 40 % | 4500 K |
| 50 % | 4000 K |
| 60 % | 3500 K |
| 70 % | 3000 K |
| 80 % | 2500 K |
| 90 % | 2000 K |
| 100 % | 1500 K (máximo tono cálido) |

La TUI aplica el cambio inmediatamente. Para ello detiene cualquier proceso
`redshift` anterior y ejecuta:

```sh
redshift -P -O <kelvin> -b 1:1
```

`-P` conserva la configuración de Redshift, `-O` fija la temperatura y
`-b 1:1` mantiene el brillo sin cambios. El comando tiene un tiempo máximo de
10 segundos; si falla, el error se muestra en la propia TUI.

### Uso

Desde una terminal:

```sh
redshift-tui
```

o desde dmenu como **luz nocturna**.

| Tecla | Acción |
| --- | --- |
| `↑` / `k` | Subir en la lista o en los campos de Auto |
| `↓` / `j` | Bajar en la lista o en los campos de Auto |
| `Tab` | Pasar al siguiente campo |
| `Shift + Tab` | Volver al campo anterior |
| `0`-`9` | Escribir en el campo de Auto que esté enfocado |
| `Backspace` | Borrar el último dígito del campo |
| `Enter` | Aplicar el porcentaje o validar y aplicar Auto |
| `q` / `Esc` | Salir de la TUI |

La lista superior muestra los once niveles disponibles. El nivel seleccionado
se marca con `>` y, si está activo el modo manual, el nivel aplicado se marca
con `*`.

### Modo manual

Al pulsar `Enter` sobre un porcentaje:

1. Se guarda `mode=manual` junto con el porcentaje elegido.
2. Se calcula su temperatura.
3. Se aplica Redshift en caliente.
4. Se cancela el horario Auto.

El modo manual se mantiene hasta que se elija otro porcentaje o se configure y
aplique Auto. Aunque se cierre la TUI, `redshift-night-scheduler` sigue
aplicando el porcentaje manual.

### Modo Auto

La sección **Auto** tiene cinco campos:

- `begin`: hora y minuto de inicio, en formato de 24 horas.
- `end`: hora y minuto de fin, en formato de 24 horas.
- `temperatura`: porcentaje de luz nocturna que se aplica dentro del horario.

Al pulsar `Enter` con el foco en Auto, la TUI valida:

- La hora debe estar entre `00` y `23`.
- Los minutos deben estar entre `00` y `59`.
- La temperatura debe estar entre `0` y `100 %`.
- `begin` y `end` no pueden ser iguales.

El horario puede cruzar la medianoche. Por ejemplo:

```text
begin=20:00
end=07:00
```

significa que el tono cálido se aplica desde las 20:00 hasta las 07:00 del día
siguiente. En cambio:

```text
begin=07:00
end=20:00
```

se interpreta como el mismo día. Si `begin == end`, la TUI muestra un error y
no guarda el cambio.

Al aplicar Auto:

1. Se guarda `mode=auto`, `begin`, `end` y `auto_percent`.
2. Si la hora actual está dentro de la ventana, se aplica el porcentaje de
   Auto.
3. Si está fuera, se aplica `6500 K` (neutro).
4. El scheduler seguirá recalculando el estado cada 10 segundos.

Elegir un porcentaje manual después de configurar Auto cancela el modo Auto y
vuelve al modo manual.

### Estado persistente

La TUI y el scheduler comparten el archivo:

```text
~/.config/redshift-night
```

Ejemplo en modo manual:

```text
mode=manual
percent=40
auto_percent=60
begin=20:00
end=07:00
kelvin=4500
```

Ejemplo en modo Auto:

```text
mode=auto
percent=40
auto_percent=60
begin=20:00
end=07:00
kelvin=3500
```

Significado de cada clave:

| Clave | Descripción |
| --- | --- |
| `mode` | `manual` o `auto`. |
| `percent` | Porcentaje manual recordado. Es el efectivo en modo manual. |
| `auto_percent` | Porcentaje que se aplica dentro de la ventana Auto. |
| `begin` | Inicio de la ventana Auto, en formato `HH:MM`. |
| `end` | Fin de la ventana Auto, en formato `HH:MM`. |
| `kelvin` | Última temperatura calculada por la TUI; es informativa. El scheduler vuelve a calcularla a partir del resto de claves. |

Si el archivo no existe, se usan estos valores por defecto:

```text
mode=auto
percent=0
auto_percent=60
begin=20:00
end=07:00
```

El instalador crea ese estado inicial solo si el archivo no existe; no
sobrescribe una configuración previa del usuario. La TUI escribe el archivo de
forma atómica mediante un archivo temporal y `os.replace`, para evitar estados
a medio escribir.

### Scheduler

`redshift-night-scheduler` es el proceso que mantiene el efecto después de
cerrar la TUI. `dwm-session` lo inicia al entrar en DWM y antes elimina
cualquier instancia anterior para evitar duplicados.

Cada 10 segundos:

1. Lee `~/.config/redshift-night`.
2. Si `mode=manual`, calcula la temperatura de `percent`.
3. Si `mode=auto` y la hora actual está dentro de `begin`-`end`, calcula la
   temperatura de `auto_percent`.
4. Si `mode=auto` y está fuera de la ventana, usa `6500 K`.
5. Si la temperatura objetivo cambió respecto a la última aplicada, ejecuta
   Redshift.

El scheduler reintenta en la siguiente vuelta si Redshift falla y evita repetir
el mismo mensaje de error de forma continua. El antiguo `redshift-auto` ya no
se usa: `make xinit` lo elimina de `/usr/local/bin` y detiene su proceso.

## Bateria

### Qué hace

`battery-tui` es una TUI de Python con `curses` que permite cambiar el perfil
de energía del equipo. Muestra tres opciones:

| Opción | Clave interna |
| --- | --- |
| Rendimiento | `performance` |
| Equilibrado | `balanced` |
| Ahorro de bateria | `power-saver` |

La TUI muestra el backend detectado en la cabecera. El perfil actual se marca
con `*` y el perfil seleccionado con `>`.

### Uso

Desde una terminal:

```sh
battery-tui
```

o desde dmenu como **Bateria**.

| Tecla | Acción |
| --- | --- |
| `↑` / `k` | Perfil anterior |
| `↓` / `j` | Perfil siguiente |
| `Enter` | Aplicar el perfil seleccionado |
| `q` / `Esc` | Salir |

Después de aplicar un perfil, la TUI permanece abierta y muestra un mensaje de
confirmación o el error devuelto por el backend.

### Detección automática del backend

`battery-tui` busca primero `power-profiles-daemon` (PPD) y después TLP. No
instala ninguno de los dos automáticamente, porque son alternativas
incompatibles entre sí.

La detección sigue este orden:

1. Si existe `powerprofilesctl` y el servicio
   `power-profiles-daemon` está activo, usa PPD.
2. Si PPD no está activo, comprueba TLP:
   - Si existe `tlpctl` y responde a `tlpctl get`, usa la interfaz `tlpctl`.
   - Si solo existe el comando `tlp`, lee su versión. Con TLP 1.9 o superior
     usa `tlp` para aplicar perfiles.
   - Con TLP 1.8 o anterior muestra un aviso, porque esa versión no admite los
     tres perfiles.
3. Si los servicios no aparecen activos, hace una comprobación de respaldo:
   intenta `powerprofilesctl get`, luego `tlpctl get` y, por último, el comando
   `tlp` con su versión.
4. Si no encuentra nada, muestra un aviso y no permite aplicar perfiles.

Si PPD y TLP están activos a la vez, la TUI muestra una advertencia y usa PPD.

### Cambio de perfil

La orden depende del backend:

- **PPD**: `powerprofilesctl set <perfil>`.
- **TLP con `tlpctl`**: `tlpctl set <perfil>`.
- **TLP 1.9+ con solo el comando `tlp`**:
  - usa `pkexec tlp <perfil>` si `pkexec` está disponible;
  - si no, usa `sudo -n tlp <perfil>`.
- **TLP 1.8 o anterior**: no aplica cambios y muestra un aviso.

El caso de `tlp` con `pkexec` puede abrir un diálogo de autorización. La ruta
`sudo -n` no pregunta contraseña: funciona solo si ya existe una sesión de
`sudo` válida en caché; si no, la TUI muestra el error correspondiente.

La lectura del perfil actual se hace con `powerprofilesctl get`, `tlpctl get`
o `tlp-stat -s`, según el backend.

### Requisitos y convivencia

- Para PPD se necesita el comando `powerprofilesctl` y el servicio
  `power-profiles-daemon` activo.
- Para TLP se necesita TLP 1.9 o superior. La TUI prefiere `tlpctl` cuando
  está disponible.
- No se debe tener PPD y TLP activos simultáneamente. Si ocurre, `Bateria`
  avisa y usa PPD, pero lo recomendable es dejar solo uno.
- `make tuis` no instala PPD ni TLP. Si no hay ninguno, la TUI lo indica.

## Verificación

Después de instalar, se puede comprobar el estado con:

```sh
make verify
```

Para probar las TUIs manualmente:

```sh
battery-tui
redshift-tui
```

Para comprobar la luz nocturna persistente:

```sh
cat ~/.config/redshift-night
pgrep -af redshift-night-scheduler
pgrep -a redshift
```

El scheduler debe estar ejecutándose después de iniciar DWM. Si `mode=auto` y
la hora actual está fuera de `begin`-`end`, Redshift debe estar en `6500 K`.
Para forzar un valor manual, abre `luz nocturna` y elige un porcentaje.

## Archivos

```text
~/Documentos/MYDWM/scripts/redshift-tui             fuente de luz nocturna
~/Documentos/MYDWM/scripts/battery-tui              fuente de Bateria
~/Documentos/MYDWM/scripts/redshift-night-scheduler  scheduler de luz nocturna
/usr/local/bin/redshift-tui                         ejecutable instalado
/usr/local/bin/battery-tui                          ejecutable instalado
/usr/local/bin/redshift-night-scheduler             ejecutable instalado
~/.local/share/applications/redshift-tui.desktop    acceso de dmenu
~/.local/share/applications/battery-tui.desktop     acceso de dmenu
~/.config/redshift-night                            estado de luz nocturna
```

La integración con la barra y los clics está en:

```text
src/slstatus-1.1/config.def.h
src/dwm-6.8/config.def.h
src/dwm-6.8/dwm.c
```

## Problemas comunes

### `Bateria` dice que no hay backend

Instala uno de los dos, no ambos:

```sh
# Opción A: power-profiles-daemon
powerprofilesctl get

# Opción B: TLP 1.9 o superior
tlp-stat -s | grep -i 'TLP version'
```

Con TLP 1.8 la TUI muestra un aviso. Actualiza a TLP 1.9+ o usa PPD.

### El cambio de perfil con TLP falla

Comprueba que TLP está activo y que tienes permisos:

```sh
systemctl is-active tlp
tlpctl get
```

Si solo existe `tlp`, la TUI intenta `pkexec`. También puedes probar el cambio
desde una terminal con `sudo tlp balanced` para comprobar que el comando
funciona.

### La luz nocturna no cambia o vuelve al valor anterior

Comprueba el estado y el scheduler:

```sh
cat ~/.config/redshift-night
pgrep -af redshift-night-scheduler
pgrep -a redshift
```

Si `mode=auto`, fuera de `begin`-`end` se aplica `6500 K`; es el
comportamiento esperado. Elige un porcentaje manual en `luz nocturna` para
cancelar Auto. Si el scheduler no está activo, vuelve a iniciar la sesión o
ejecuta `make xinit`.

### Los bloques o los clics no aparecen en la barra

Comprueba que la versión instalada de slstatus y DWM es la nueva y reinicia la
sesión:

```sh
strings /usr/local/bin/slstatus | grep -E 'Bateria|luz nocturna'
pgrep -a slstatus
```

Si faltan, ejecuta `make bar`, `make dwm` y vuelve a entrar en DWM.
