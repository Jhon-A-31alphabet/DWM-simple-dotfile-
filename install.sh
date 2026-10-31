#!/usr/bin/env bash
# Compatibilidad: el instalador ahora está dividido en scripts y orquestado
# por el Makefile. Este archivo ejecuta la instalación completa.
set -euo pipefail

BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASE_DIR"
exec make setup
