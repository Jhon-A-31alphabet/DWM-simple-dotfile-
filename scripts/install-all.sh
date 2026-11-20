#!/usr/bin/env bash
# Instala y configura MYDWM completo.
# Se apoya en sudo-once.sh para pedir la contraseña una sola vez.
set -euo pipefail

BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# Si se ejecuta directamente (sin pasar por make setup), se reejecuta bajo
# sudo-once.sh para que la autenticación también sea única.
if [[ -z "${MYDWM_SUDO_READY:-}" || -z "${SUDO:-}" ]]; then
	exec bash "$BASE_DIR/scripts/sudo-once.sh" bash "$BASE_DIR/scripts/install-all.sh" "$@"
fi

echo "==> Configuración completa de MYDWM"

bash "$BASE_DIR/scripts/01-install-dwm.sh"
bash "$BASE_DIR/scripts/02-install-bar.sh"
bash "$BASE_DIR/scripts/03-install-tuis.sh"
bash "$BASE_DIR/scripts/04-configure-xinit.sh"
make -C "$BASE_DIR" --no-print-directory verify

echo
echo "Instalación completa. Cierra sesión y elige 'DWM' en GDM."
