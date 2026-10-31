#!/usr/bin/env bash
# Instala slstatus, dmenu, slock, nmtui y el administrador Bluetooth.
# Compatible con Debian/Ubuntu (apt), Fedora (dnf) y Arch Linux (pacman).
set -euo pipefail

BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
. "$BASE_DIR/scripts/lib.sh"

PREFIX="/usr/local"

echo "==> [2/4] Instalando barra de estado, dmenu y herramientas de red/Bluetooth"

case "$PKG_MANAGER" in
	apt)
		packages=(
			build-essential
			libx11-dev libxft-dev libxinerama-dev libfontconfig1-dev
			libxext-dev libxrandr-dev libcrypt-dev
			network-manager bluez rfkill
			x11-utils python3 procps
		)
		;;
	dnf)
		packages=(
			gcc make
			libX11-devel libXft-devel libXinerama-devel fontconfig-devel
			libXext-devel libXrandr-devel libxcrypt-devel
			NetworkManager NetworkManager-tui NetworkManager-wifi
			bluez util-linux xprop python3 procps-ng
		)
		;;
	pacman)
		packages=(
			base-devel
			libx11 libxft libxinerama fontconfig
			libxext libxrandr libxcrypt
			networkmanager bluez bluez-utils util-linux
			xorg-xprop python procps-ng
		)
		;;
esac

echo "==> Actualizando repositorios e instalando dependencias"
update_packages
install_packages "${packages[@]}"

echo "==> Compilando e instalando dmenu"
make -C "$BASE_DIR/src/dmenu-5.4" clean >/dev/null 2>&1 || true
cp "$BASE_DIR/src/dmenu-5.4/config.def.h" "$BASE_DIR/src/dmenu-5.4/config.h"
make -C "$BASE_DIR/src/dmenu-5.4"
$SUDO make -C "$BASE_DIR/src/dmenu-5.4" install

echo "==> Compilando e instalando slstatus"
make -C "$BASE_DIR/src/slstatus-1.1" clean >/dev/null 2>&1 || true
cp "$BASE_DIR/src/slstatus-1.1/config.def.h" "$BASE_DIR/src/slstatus-1.1/config.h"
make -C "$BASE_DIR/src/slstatus-1.1"
$SUDO make -C "$BASE_DIR/src/slstatus-1.1" install

echo "==> Compilando e instalando slock"
make -C "$BASE_DIR/src/slock-1.7" clean >/dev/null 2>&1 || true
cp "$BASE_DIR/src/slock-1.7/config.def.h" "$BASE_DIR/src/slock-1.7/config.h"
make -C "$BASE_DIR/src/slock-1.7"
$SUDO make -C "$BASE_DIR/src/slock-1.7" install

echo "==> Instalando estado de WiFi y Bluetooth para la barra"
$SUDO install -Dm755 "$BASE_DIR/scripts/wifi-status" "$PREFIX/bin/wifi-status"
$SUDO install -Dm755 "$BASE_DIR/scripts/bt-status" "$PREFIX/bin/bt-status"

echo "==> Instalando administrador Bluetooth"
$SUDO install -Dm755 "$BASE_DIR/scripts/bluetooth-tui" "$PREFIX/bin/bluetooth-tui"

echo "==> Habilitando servicios"
enable_service bluetooth
enable_service NetworkManager

for command in dmenu slstatus slock nmtui bluetoothctl rfkill; do
	if ! command -v "$command" >/dev/null 2>&1; then
		echo "Error: no se encontró el comando '$command' después de la instalación." >&2
		exit 1
	fi
done

echo
echo "Barra de estado, dmenu, nmtui y administrador Bluetooth instalados."
echo "Los bloques WiFi y BT de la barra se activarán al reiniciar la sesión de DWM."
