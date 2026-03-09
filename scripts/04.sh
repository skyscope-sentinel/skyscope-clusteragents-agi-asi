#!/usr/bin/env bash
set -euo pipefail

ROOT="${HOME}/Documents/Skyscope Sentinel Intelligence - Multi Agent AGI-ASI"
MODEL_DEFAULT="nvidia/nemotron-3-nano-30b-a3b:free"

mkdir -p "${ROOT}/bin"
mkdir -p "${ROOT}/scripts"

cat > "${ROOT}/bin/skyscope-ai" <<'SH'
#!/usr/bin/env bash
set -euo pipefail

MODEL="${OPENROUTER_MODEL:-nvidia/nemotron-3-nano-30b-a3b:free}"
API_KEY="${OPENROUTER_API_KEY:-}"

if [[ -z "${API_KEY}" ]]; then
  echo "OPENROUTER_API_KEY is not set. Set it in your shell environment and retry." >&2
  exit 2
fi

SYSTEM_PROMPT="${SKYSCOPE_SYSTEM_PROMPT:-You are a helpful assistant. Respond concisely and safely.}"
OUTPUT_MODE="text"

usage() {
  cat <<'USAGE'
Usage:
  skyscope-ai "your prompt"
  echo "your prompt" | skyscope-ai

Environment:
  OPENROUTER_API_KEY   required
  OPENROUTER_MODEL     optional (default: nvidia/nemotron-3-nano-30b-a3b:free)
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--json" ]]; then
  OUTPUT_MODE="json"
  shift
fi

PROMPT=""
if [[ $# -gt 0 ]]; then
  PROMPT="$*"
else
  PROMPT="$(cat)"
fi

REQ_JSON="$(PROMPT_OVERRIDE="${PROMPT}" SYSTEM_PROMPT_OVERRIDE="${SYSTEM_PROMPT}" MODEL_OVERRIDE="${MODEL}" python3 - <<PY
import json, os
model = os.environ.get("MODEL_OVERRIDE") or os.environ.get("OPENROUTER_MODEL") or "nvidia/nemotron-3-nano-30b-a3b:free"
system_prompt = os.environ.get("SYSTEM_PROMPT_OVERRIDE") or os.environ.get("SKYSCOPE_SYSTEM_PROMPT") or "You are a helpful assistant. Respond concisely and safely."
prompt = os.environ.get("PROMPT_OVERRIDE") or ""
print(json.dumps({
  "model": model,
  "messages": [
    {"role":"system","content": system_prompt},
    {"role":"user","content": prompt}
  ]
}))
PY
)"

RESP="$(curl -sS https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  --data "${REQ_JSON}")"

if [[ "${OUTPUT_MODE}" == "json" ]]; then
  printf '%s\n' "${RESP}"
  exit 0
fi

python3 - <<PY
import json, sys
raw = sys.stdin.read()
try:
  data = json.loads(raw)
except Exception:
  sys.stdout.write(raw)
  sys.exit(0)
choices = data.get("choices") or []
if not choices:
  sys.stdout.write(raw)
  sys.exit(0)
msg = choices[0].get("message") or {}
content = msg.get("content") or ""
sys.stdout.write(content)
PY <<<"${RESP}"
SH

chmod +x "${ROOT}/bin/skyscope-ai"

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
  cat > "${ROOT}/bin/${t}" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)/skyscope-ai" "\$@"
SH
  chmod +x "${ROOT}/bin/${t}"
done

cat > "${ROOT}/scripts/install_to_local_bin.sh" <<'SH'
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
SH

chmod +x "${ROOT}/scripts/install_to_local_bin.sh"

exec bash "${ROOT}/scripts/05.sh"
