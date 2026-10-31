#!/usr/bin/env bash
# Instala los scripts de sesión, el archivo xinit y la entrada de GDM.
# Compatible con Debian/Ubuntu (apt), Fedora (dnf) y Arch Linux (pacman).
set -euo pipefail

BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
. "$BASE_DIR/scripts/lib.sh"

PREFIX="/usr/local"

echo "==> [4/4] Configurando scripts de sesión y xinit"

echo "==> Instalando scripts de sesión"
$SUDO install -Dm755 "$BASE_DIR/scripts/dwm-session" "$PREFIX/bin/dwm-session"
$SUDO install -Dm755 "$BASE_DIR/scripts/dwm-dmenu" "$PREFIX/bin/dwm-dmenu"
$SUDO install -Dm755 "$BASE_DIR/scripts/redshift-auto" "$PREFIX/bin/redshift-auto"

echo "==> Instalando entrada de sesión para GDM"
$SUDO install -Dm644 "$BASE_DIR/session/dwm.desktop" "/usr/share/xsessions/dwm.desktop"

echo "==> Instalando ~/.xinitrc"
if [[ -f "$HOME/.xinitrc" ]] && ! cmp -s "$BASE_DIR/configs/xinitrc" "$HOME/.xinitrc"; then
	backup_file "$HOME/.xinitrc"
fi
install -Dm755 "$BASE_DIR/configs/xinitrc" "$HOME/.xinitrc"

for script in dwm-session dwm-dmenu redshift-auto; do
	if [[ ! -x "$PREFIX/bin/$script" ]]; then
		echo "Error: no se instaló $PREFIX/bin/$script" >&2
		exit 1
	fi
done

sh -n "$PREFIX/bin/dwm-session"
sh -n "$PREFIX/bin/dwm-dmenu"
sh -n "$PREFIX/bin/redshift-auto"

echo
echo "Sesión DWM configurada."
echo "Al cerrar sesión y volver a entrar, DWM iniciará:"
echo "  - fondo de pantalla"
echo "  - picom"
echo "  - redshift-auto"
echo "  - slstatus"
echo "  - xcape para abrir dmenu con la tecla Super"
echo "  - dwm"
echo
echo "En GDM selecciona la sesión 'DWM'."
