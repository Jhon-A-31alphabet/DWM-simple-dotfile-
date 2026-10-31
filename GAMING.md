# Corrección de juegos (Steam y Heroic)

> **Documento opcional.** Steam, Heroic y Proton 11 no forman parte de
> `make setup`; este archivo recoge la configuración manual aplicada en esta
> máquina.

## Steam

### Síntoma

Los juegos se cerraban solos a los pocos segundos de pulsar "Jugar".

### Causa

Al activar el registro de Proton se encontró este error:

```text
err:steamclient:create_win_interface Don't recognize interface name: SteamClient023
[S_API] SteamAPI_Init(): No SteamClient023
```

Los juegos actualizados usan una interfaz nueva de Steamworks
(`SteamClient023`) que la versión **Proton 9.0** instalada no reconoce. Por eso
el juego abortaba justo después de iniciar la API de Steam.

### Solución

Se cambió el Proton predeterminado a **Proton 11.0**, que sí reconoce esa
interfaz:

```text
Steam > Configuración > Compatibilidad > Herramienta de compatibilidad
```

También se dejaron asignados explícitamente a Proton 11 estos juegos:

- Geometry Dash (`322170`)
- Brawlhalla (`291550`)
- ASTRONEER (`361420`)

La configuración quedó en:

```text
~/.var/app/com.valvesoftware.Steam/.local/share/Steam/config/config.vdf
```

Respaldos creados:

```text
config.vdf.bak-antes-proton11
config.vdf.bak-global-proton11
```

### Verificación

Se comprobó que abren y muestran su ventana:

- Geometry Dash: ventana de 1920x1080 con Proton 11.
- Brawlhalla: ventana de 1920x1080 con Proton 11.

## Heroic Games Launcher

No fue necesario corregir nada. Los dos juegos instalados abren correctamente:

- **Prodeus**: ventana de 1920x1080 con GE-Proton.
- **Magical Blush Demo**: ventana de 1024x768 con GE-Proton.

El primer arranque de un juego de Heroic puede tardar más porque crea el
prefix de Wine y prepara DXVK. Los siguientes arranques son más rápidos.
