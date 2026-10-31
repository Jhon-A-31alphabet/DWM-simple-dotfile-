SHELL := /bin/bash

ROOT := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
SCRIPTS := $(ROOT)/scripts
SRC := $(ROOT)/src

.PHONY: setup dwm bar tuis xinit verify clean help

help:
	@echo "MYDWM - objetivos disponibles:"
	@echo "  make setup   Instala y configura todo (DWM, barra, TUIs y sesión)."
	@echo "  make dwm     Instala DWM y picom."
	@echo "  make bar     Instala slstatus, dmenu, slock, nmtui y Bluetooth."
	@echo "  make tuis    Instala los selectores TUI y sus accesos."
	@echo "  make xinit   Configura dwm-session, ~/.xinitrc y la sesión GDM."
	@echo "  make verify  Verifica que todo esté instalado."
	@echo "  make clean   Limpia los artefactos de compilación."

setup:
	@echo "==> Configuración completa de MYDWM"
	@$(MAKE) --no-print-directory dwm
	@$(MAKE) --no-print-directory bar
	@$(MAKE) --no-print-directory tuis
	@$(MAKE) --no-print-directory xinit
	@$(MAKE) --no-print-directory verify
	@echo
	@echo "Instalación completa. Cierra sesión y elige 'DWM' en GDM."

dwm:
	@bash "$(SCRIPTS)/01-install-dwm.sh"

bar:
	@bash "$(SCRIPTS)/02-install-bar.sh"

tuis:
	@bash "$(SCRIPTS)/03-install-tuis.sh"

xinit:
	@bash "$(SCRIPTS)/04-configure-xinit.sh"

verify:
	@echo "==> Verificando instalación de MYDWM"
	@set -euo pipefail; \
	for command in dwm dmenu slstatus slock picom feh scrot kitty nmtui bluetoothctl rfkill xprop python3; do \
		command -v "$$command" >/dev/null 2>&1 || { echo "Falta el comando: $$command"; exit 1; }; \
	done; \
	for file in \
		/usr/local/bin/wallpaper-tui \
		/usr/local/bin/dwm-colors-tui \
		/usr/local/bin/bluetooth-tui \
		/usr/local/bin/bt-status \
		/usr/local/bin/wifi-status \
		/usr/local/bin/dwm-session \
		/usr/local/bin/dwm-dmenu \
		/usr/local/bin/redshift-auto \
		/usr/local/bin/scrot-shot \
		"$$HOME/.xinitrc" \
		"$$HOME/.config/picom/picom.conf" \
		"$$HOME/.local/share/applications/wallpaper-tui.desktop" \
		"$$HOME/.local/share/applications/dwm-colors-tui.desktop" \
		"$$HOME/.local/share/applications/bluetooth-tui.desktop" \
		/usr/share/xsessions/dwm.desktop; do \
		[[ -e "$$file" ]] || { echo "Falta el archivo: $$file"; exit 1; }; \
	done; \
	for file in /usr/local/bin/wallpaper-tui /usr/local/bin/dwm-colors-tui /usr/local/bin/bluetooth-tui /usr/local/bin/bt-status /usr/local/bin/wifi-status /usr/local/bin/scrot-shot; do \
		[[ -x "$$file" ]] || { echo "No es ejecutable: $$file"; exit 1; }; \
	done; \
	for desktop in wallpaper-tui dwm-colors-tui bluetooth-tui; do \
		desktop_file="$$HOME/.local/share/applications/$$desktop.desktop"; \
		grep -q '^Exec=/usr/local/bin/' "$$desktop_file" \
			|| { echo "El acceso $$desktop no apunta a /usr/local/bin."; exit 1; }; \
	done; \
	command -v strings >/dev/null 2>&1 && strings /usr/local/bin/dwm | grep -q '_DWM_RELOAD_COLORS' \
		|| { echo "DWM no incluye la recarga de colores en caliente."; exit 1; }; \
	grep -q '/usr/local/bin/bt-status' "$(SRC)/slstatus-1.1/config.def.h" \
		|| { echo "slstatus no apunta a /usr/local/bin/bt-status."; exit 1; }; \
	grep -q '/usr/local/bin/wifi-status' "$(SRC)/slstatus-1.1/config.def.h" \
		|| { echo "slstatus no apunta a /usr/local/bin/wifi-status."; exit 1; }; \
	grep -q '/usr/local/bin/bluetooth-tui' "$(SRC)/dwm-6.8/config.def.h" \
		|| { echo "DWM no apunta a /usr/local/bin/bluetooth-tui."; exit 1; }; \
	grep -q 'scrht' "$(SRC)/slstatus-1.1/config.def.h" \
		|| { echo "slstatus no incluye el bloque scrht."; exit 1; }; \
	grep -q 'ControlMask,.*XK_s' "$(SRC)/dwm-6.8/config.def.h" \
		|| { echo "DWM no incluye el atajo Ctrl+S."; exit 1; }; \
	grep -q 'ClkScrot' "$(SRC)/dwm-6.8/config.def.h" \
		|| { echo "DWM no incluye el clic del bloque scrht."; exit 1; }; \
	grep -q '\.config/wallpaper' /usr/local/bin/dwm-session \
		|| { echo "dwm-session no lee ~/.config/wallpaper."; exit 1; }; \
	grep -q '/usr/local/bin/dwm-session' "$$HOME/.xinitrc" \
		|| { echo "~/.xinitrc no inicia /usr/local/bin/dwm-session."; exit 1; }; \
	[[ -d "$$HOME/wallpapers" ]] || { echo "Falta ~/wallpapers."; exit 1; }; \
	[[ -f "$$HOME/.config/wallpaper" ]] || { echo "Falta ~/.config/wallpaper."; exit 1; }; \
	[[ -f "$$HOME/.config/dwm/colors" ]] || { echo "Falta ~/.config/dwm/colors."; exit 1; }; \
	for file in /usr/local/bin/wallpaper-tui /usr/local/bin/dwm-colors-tui /usr/local/bin/bluetooth-tui; do \
		python3 -c 'import sys; compile(open(sys.argv[1], encoding="utf-8").read(), sys.argv[1], "exec")' "$$file" \
			|| { echo "Error de sintaxis Python: $$file"; exit 1; }; \
	done
	@echo "Verificación completada correctamente."

clean:
	@echo "==> Limpiando artefactos de compilación"
	@make -C "$(SRC)/dwm-6.8" clean >/dev/null 2>&1 || true
	@make -C "$(SRC)/dmenu-5.4" clean >/dev/null 2>&1 || true
	@make -C "$(SRC)/slstatus-1.1" clean >/dev/null 2>&1 || true
	@make -C "$(SRC)/slock-1.7" clean >/dev/null 2>&1 || true
	@find "$(SRC)" -name '__pycache__' -type d -prune -exec rm -rf {} + 2>/dev/null || true
	@echo "Limpieza completada."
