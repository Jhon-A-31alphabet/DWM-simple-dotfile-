#!/usr/bin/env bash
# Instala las TUIs de fondos, colores y Bluetooth, sus accesos y sus assets.
# Compatible con Debian/Ubuntu (apt), Fedora (dnf) y Arch Linux (pacman).
set -euo pipefail

BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
. "$BASE_DIR/scripts/lib.sh"

PREFIX="/usr/local"
APPLICATIONS_DIR="$HOME/.local/share/applications"
DEFAULT_WALLPAPER="$HOME/Imágenes/fondos/ballena_minimalista.jpg"

echo "==> [3/4] Instalando TUIs y accesos directos"

case "$PKG_MANAGER" in
	apt)
		packages=(python3 python3-pil x11-utils feh)
		;;
	dnf)
		packages=(python3 python3-pillow xprop feh)
		;;
	pacman)
		packages=(python python-pillow xorg-xprop feh)
		;;
esac

echo "==> Actualizando repositorios e instalando dependencias de las TUIs"
update_packages
install_packages "${packages[@]}"

echo "==> Instalando scripts TUI"
for script in wallpaper-tui dwm-colors-tui bluetooth-tui; do
	$SUDO install -Dm755 "$BASE_DIR/scripts/$script" "$PREFIX/bin/$script"
done
$SUDO install -Dm755 "$BASE_DIR/scripts/bt-status" "$PREFIX/bin/bt-status"

echo "==> Instalando accesos de dmenu/escritorio"
mkdir -p "$APPLICATIONS_DIR"
for desktop in wallpaper-tui dwm-colors-tui bluetooth-tui; do
	install -Dm644 "$BASE_DIR/configs/$desktop.desktop" "$APPLICATIONS_DIR/$desktop.desktop"
done
if command -v update-desktop-database >/dev/null 2>&1; then
	update-desktop-database "$APPLICATIONS_DIR" >/dev/null 2>&1 || true
fi

echo "==> Creando carpetas de estado"
mkdir -p "$HOME/.config/dwm" "$HOME/wallpapers" "$HOME/Imágenes/fondos"

if [[ ! -f "$HOME/.config/dwm/colors" ]]; then
	echo "==> Creando tema de colores por defecto"
	cat >"$HOME/.config/dwm/colors" <<'EOF'
border=#00FFFF
bar_bg=#222222
bar_fg=#BBBBBB
accent=#00FFFF
accent_fg=#000000
EOF
fi

echo "==> Instalando fondo de pantalla por defecto"
ASSET_WALLPAPER="$BASE_DIR/assets/wallpapers/ballena_minimalista.jpg"
if [[ -f "$ASSET_WALLPAPER" ]]; then
	if [[ ! -f "$DEFAULT_WALLPAPER" ]]; then
		install -Dm644 "$ASSET_WALLPAPER" "$DEFAULT_WALLPAPER"
	fi
	if [[ ! -e "$HOME/Imágenes/fondos/ballena_minimalista.jpeg" && ! -L "$HOME/Imágenes/fondos/ballena_minimalista.jpeg" ]]; then
		ln -s ballena_minimalista.jpg "$HOME/Imágenes/fondos/ballena_minimalista.jpeg"
	fi
	if [[ -z "$(find "$HOME/wallpapers" -maxdepth 1 -type f \
		\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
		-print -quit 2>/dev/null)" ]]; then
		install -Dm644 "$ASSET_WALLPAPER" "$HOME/wallpapers/ballena_minimalista.jpg"
	fi
	if [[ ! -f "$HOME/.config/wallpaper" ]]; then
		printf '%s\n' "$HOME/wallpapers/ballena_minimalista.jpg" >"$HOME/.config/wallpaper"
	fi
else
	echo "Advertencia: no se encontró $ASSET_WALLPAPER; no se copió el fondo por defecto." >&2
fi

for command in wallpaper-tui dwm-colors-tui bluetooth-tui bt-status; do
	if [[ ! -x "$PREFIX/bin/$command" ]]; then
		echo "Error: no se instaló $PREFIX/bin/$command" >&2
		exit 1
	fi
done

echo
echo "TUIs instaladas:"
echo "  - wallpaper-tui"
echo "  - dwm-colors-tui"
echo "  - bluetooth-tui"
echo "Aparecen en dmenu como:"
echo "  - Cambiar fondo de pantalla"
echo "  - Cambiar colores de DWM"
echo "  - Administrador Bluetooth"
