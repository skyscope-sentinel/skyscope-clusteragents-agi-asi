#!/usr/bin/env bash
set -euo pipefail
ROOT="${HOME}/Documents/Skyscope Sentinel Intelligence - Multi Agent AGI-ASI"
chmod +x "${ROOT}/scripts/"*.sh 2>/dev/null || true
exec bash "${ROOT}/scripts/02.sh"
