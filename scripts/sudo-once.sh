#!/usr/bin/env bash
# Ejecuta un comando con una sola autenticación de sudo.
# Mantiene la credencial activa mientras dura el comando y nunca guarda la
# contraseña: solo reutiliza la caché temporal de sudo.
set -euo pipefail

if [[ ${EUID} -eq 0 ]]; then
	echo "Ejecuta este script como tu usuario normal, no como root." >&2
	exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
	echo "Error: se requiere sudo para instalar paquetes y binarios del sistema." >&2
	exit 1
fi

if [[ $# -eq 0 ]]; then
	echo "Uso: $0 <comando> [argumentos...]" >&2
	exit 2
fi

# Si ya hay una credencial válida, no se pide nada.
if ! sudo -n true 2>/dev/null; then
	printf '%s\n' '==> Autenticación de sudo (solo se pedirá una vez)'
	if ! sudo -v; then
		echo "Error: no se pudo autenticar con sudo." >&2
		exit 1
	fi
fi

# Los scripts de instalación son procesos hijos. Comprobamos que también
# pueden reutilizar la credencial antes de empezar a modificar el sistema.
if ! bash -c 'sudo -n true' >/dev/null 2>&1; then
	cat >&2 <<'EOF'
Error: sudo no permite reutilizar la autenticación entre procesos.

Este instalador necesita que `sudo -n` funcione después de `sudo -v`.
Comprueba la configuración de sudo (timestamp_timeout/timestamp_type)
o ejecuta la instalación desde una terminal interactiva.
EOF
	exit 1
fi

# Renueva la credencial cada 50 segundos para que no caduque durante una
# instalación larga. Se detiene al terminar el comando o al interrumpirlo.
keepalive() {
	while sleep 50; do
		if [[ -r /dev/tty ]]; then
			sudo -n -v </dev/tty >/dev/null 2>&1 || return 1
		else
			sudo -n -v >/dev/null 2>&1 || return 1
		fi
	done
}

keepalive &
keepalive_pid=$!

cleanup() {
	kill "$keepalive_pid" 2>/dev/null || true
	wait "$keepalive_pid" 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP

export SUDO="sudo -n"
export MYDWM_SUDO_READY=1

"$@"
