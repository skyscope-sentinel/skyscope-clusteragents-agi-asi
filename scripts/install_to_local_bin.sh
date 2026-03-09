#!/usr/bin/env bash
set -euo pipefail

ROOT="${HOME}/Documents/Skyscope Sentinel Intelligence - Multi Agent AGI-ASI"
mkdir -p "${HOME}/.local/bin"

install_file() {
  local src="$1"
  local dest="$2"
  cp -f "${src}" "${dest}"
  chmod +x "${dest}"
}

install_file "${ROOT}/bin/skyscope-ai" "${HOME}/.local/bin/skyscope-ai"

TOOLS=(
  "blackbox.ai"
  "goose"
  "openai-codex"
  "crush"
  "opencode"
  "qwen"
  "factory.ai"
  "google-gemini"
)

for t in "${TOOLS[@]}"; do
  if command -v "${t}" >/dev/null 2>&1; then
    install_file "${ROOT}/bin/${t}" "${HOME}/.local/bin/${t}-skyscope"
  else
    install_file "${ROOT}/bin/${t}" "${HOME}/.local/bin/${t}"
  fi
done

ZSHRC="${HOME}/.zshrc"
BLOCK_START="# >>> skyscope-sentinel >>>"
BLOCK_END="# <<< skyscope-sentinel <<<"

if [[ -f "${ZSHRC}" ]]; then
  if ! grep -Fq "${BLOCK_START}" "${ZSHRC}"; then
    {
      echo ""
      echo "${BLOCK_START}"
      echo 'export PATH="$HOME/.local/bin:$PATH"'
      echo "${BLOCK_END}"
      echo ""
    } >> "${ZSHRC}"
  fi
fi
