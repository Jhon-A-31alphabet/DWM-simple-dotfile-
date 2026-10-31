#!/usr/bin/env bash
# Utilidades compartidas por los scripts de instalación de MYDWM.
# Compatible con Debian/Ubuntu (apt), Fedora (dnf) y Arch Linux (pacman).

if [[ -n "${MYDWM_LIB_LOADED:-}" ]]; then
	return 0
fi
MYDWM_LIB_LOADED=1

SUDO="${SUDO:-sudo}"

if [[ ${EUID} -eq 0 ]]; then
	echo "Ejecuta este script como tu usuario normal, no como root." >&2
	exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
	echo "Error: se requiere sudo para instalar paquetes y binarios del sistema." >&2
	exit 1
fi

if [[ -r /etc/os-release ]]; then
	# shellcheck disable=SC1091
	. /etc/os-release
fi
DISTRO_NAME="${PRETTY_NAME:-${NAME:-Linux}}"

PKG_MANAGER=""
if command -v apt-get >/dev/null 2>&1; then
	PKG_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
	PKG_MANAGER="dnf"
elif command -v pacman >/dev/null 2>&1; then
	PKG_MANAGER="pacman"
else
	echo "Error: no se reconoce un gestor de paquetes compatible (apt, dnf o pacman)." >&2
	exit 1
fi

echo "==> Distribución detectada: $DISTRO_NAME"
echo "==> Gestor de paquetes: $PKG_MANAGER"

update_packages() {
	case "$PKG_MANAGER" in
		apt)
			$SUDO apt-get update
			;;
		dnf)
			# dnf actualiza metadatos al instalar; no se fuerza una actualización.
			;;
		pacman)
			# No se hace -Sy para evitar actualizaciones parciales.
			;;
	esac
}

install_packages() {
	if [[ $# -eq 0 ]]; then
		return 0
	fi
	case "$PKG_MANAGER" in
		apt)
			$SUDO apt-get install -y "$@"
			;;
		dnf)
			$SUDO dnf install -y "$@"
			;;
		pacman)
			$SUDO pacman -S --needed --noconfirm "$@"
			;;
	esac
}

install_optional_packages() {
	local package
	for package in "$@"; do
		if ! install_packages "$package"; then
			echo "Advertencia: no se pudo instalar '$package'; se omite." >&2
		fi
	done
}

enable_service() {
	local service="$1"
	if ! $SUDO systemctl enable --now "$service"; then
		echo "Advertencia: no se pudo habilitar el servicio '$service'." >&2
	fi
}

backup_file() {
	local file="$1"
	if [[ -e "$file" ]]; then
		local stamp backup
		stamp="$(date +%Y%m%d-%H%M%S)"
		backup="${file}.bak.${stamp}"
		cp -a "$file" "$backup"
		echo "  Respaldo creado: $backup"
	fi
}
