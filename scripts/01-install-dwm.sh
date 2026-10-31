#!/usr/bin/env bash
# Instala DWM desde el código fuente de MYDWM y la configuración de picom.
# Compatible con Debian/Ubuntu (apt), Fedora (dnf) y Arch Linux (pacman).
set -euo pipefail

BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
. "$BASE_DIR/scripts/lib.sh"

SRC_DIR="$BASE_DIR/src/dwm-6.8"

echo "==> [1/4] Instalando DWM y picom"
echo "    Fuente: $SRC_DIR"

if [[ ! -f "$SRC_DIR/config.def.h" || ! -f "$SRC_DIR/Makefile" ]]; then
	echo "Error: no se encontró el código fuente de DWM en $SRC_DIR" >&2
	exit 1
fi

case "$PKG_MANAGER" in
	apt)
		packages=(
			build-essential
			libx11-dev libxft-dev libxinerama-dev libfontconfig1-dev
			libxext-dev libxrandr-dev libcrypt-dev
			xorg xinit x11-xserver-utils x11-xkb-utils x11-utils xkb-data
			xserver-xorg-input-libinput
			picom feh scrot xdg-user-dirs kitty redshift fonts-dejavu-core
		)
		;;
	dnf)
		packages=(
			gcc gcc-c++ make
			libX11-devel libXft-devel libXinerama-devel fontconfig-devel
			libXext-devel libXrandr-devel libxcrypt-devel
			xorg-x11-server-Xorg xorg-x11-xinit setxkbmap xkbcomp
			xkeyboard-config xprop xorg-x11-drv-libinput
			picom feh scrot xdg-user-dirs kitty redshift dejavu-sans-fonts
		)
		;;
	pacman)
		packages=(
			base-devel
			libx11 libxft libxinerama fontconfig
			libxext libxrandr libxcrypt
			xorg-server xorg-xinit xorg-setxkbmap xorg-xkbcomp xorg-xprop
			xkeyboard-config xf86-input-libinput
			picom feh scrot xdg-user-dirs kitty redshift ttf-dejavu
		)
		;;
esac
optional_packages=(xcape)

echo "==> Actualizando repositorios e instalando dependencias de DWM"
update_packages
install_packages "${packages[@]}"
install_optional_packages "${optional_packages[@]}"

echo "==> Compilando DWM"
make -C "$SRC_DIR" clean >/dev/null 2>&1 || true
cp "$SRC_DIR/config.def.h" "$SRC_DIR/config.h"
make -C "$SRC_DIR"

echo "==> Instalando DWM"
$SUDO make -C "$SRC_DIR" install

echo "==> Instalando capturador de pantalla"
$SUDO install -Dm755 "$BASE_DIR/scripts/scrot-shot" "/usr/local/bin/scrot-shot"

echo "==> Instalando configuración de picom"
mkdir -p "$HOME/.config/picom"
if [[ -f "$HOME/.config/picom/picom.conf" ]] && ! cmp -s "$BASE_DIR/configs/picom.conf" "$HOME/.config/picom/picom.conf"; then
	backup_file "$HOME/.config/picom/picom.conf"
fi
install -Dm644 "$BASE_DIR/configs/picom.conf" "$HOME/.config/picom/picom.conf"

if command -v picom >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]; then
	echo "==> Reiniciando picom"
	pkill -x picom 2>/dev/null || true
	sleep 0.5
	picom --config "$HOME/.config/picom/picom.conf" -b || true
fi

echo
echo "DWM y picom instalados."
echo "La nueva sesión de DWM se aplicará al cerrar sesión y volver a entrar."
