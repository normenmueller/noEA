#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# Version information
# ----------------------------------------------------------------------
VERSION="0.0.1"
COPYRIGHT_YEAR="2026"
AUTHOR="nemron"

print_version() {
  echo "asmcp, v${VERSION}, © ${COPYRIGHT_YEAR} ${AUTHOR}"
}

# ----------------------------------------------------------------------
# Usage info
# ----------------------------------------------------------------------
print_usage() {
  cat <<'EOF'
Usage: asmcp [options]

Options:
  --dev              Start in development mode (default)
  --prod             Build + start in production mode
  --port <n>         Override server port (SERVER_PORT)
  --model <path>     Override model path (MODEL_PATH)
  --http             Enable HTTP test endpoints (ENABLE_HTTP_ENDPOINTS=true)
  --version          Show version and exit
  -h, --help         Show this help and exit

Default model path: data/archimate-scribe-demo-model.xml
Default port: 3030 (or config/settings.json)
EOF
}

MODE="dev"
PORT=""
MODEL_PATH_ARG=""
ENABLE_HTTP_FLAG=""
DEFAULT_MODEL="data/archimate-scribe-demo-model.xml"

to_bool() {
  case "${1:-}" in
    true|1|yes|on) echo "true" ;;
    *) echo "false" ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dev) MODE="dev"; shift ;;
    --prod) MODE="prod"; shift ;;
    --port) PORT="${2:-}"; shift 2 ;;
    --model) MODEL_PATH_ARG="${2:-}"; shift 2 ;;
    --http) ENABLE_HTTP_FLAG="true"; shift ;;
    --version) print_version; exit 0 ;;
    -h|--help) print_usage; exit 0 ;;
    *) echo "Unknown option: $1"; print_usage; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
MAIN_DIR="$ROOT_DIR/main"
CONFIG_FILE="$MAIN_DIR/config/settings.json"

if [[ ! -d "$MAIN_DIR" ]]; then
  echo "Error: $MAIN_DIR not found."
  exit 1
fi

if [[ ! -f "$MAIN_DIR/package.json" ]]; then
  echo "Error: package.json not found in $MAIN_DIR."
  exit 1
fi

if [[ ! -d "$MAIN_DIR/node_modules" ]]; then
  echo "Dependencies missing. Run: (cd \"$MAIN_DIR\" && npm install)"
  exit 1
fi

CONFIG_MODEL=""
CONFIG_PORT=""
CONFIG_HTTP=""
if command -v node >/dev/null 2>&1 && [[ -f "$CONFIG_FILE" ]]; then
  CONFIG_MODEL="$(node -e "const fs=require('fs');const j=JSON.parse(fs.readFileSync(process.argv[1],'utf8'));console.log(j.modelPath||'');" "$CONFIG_FILE" 2>/dev/null || true)"
  CONFIG_PORT="$(node -e "const fs=require('fs');const j=JSON.parse(fs.readFileSync(process.argv[1],'utf8'));console.log(j.serverPort||'');" "$CONFIG_FILE" 2>/dev/null || true)"
  CONFIG_HTTP="$(node -e "const fs=require('fs');const j=JSON.parse(fs.readFileSync(process.argv[1],'utf8'));console.log(j.enableHttpEndpoints===true?'true':'false');" "$CONFIG_FILE" 2>/dev/null || true)"
fi

if [[ -n "$PORT" ]]; then export SERVER_PORT="$PORT"; fi
if [[ -n "$MODEL_PATH_ARG" ]]; then
  export MODEL_PATH="$MODEL_PATH_ARG"
elif [[ -z "${MODEL_PATH:-}" ]]; then
  export MODEL_PATH="$DEFAULT_MODEL"
fi
if [[ -n "$ENABLE_HTTP_FLAG" ]]; then export ENABLE_HTTP_ENDPOINTS="true"; fi

EFFECTIVE_PORT="${SERVER_PORT:-${CONFIG_PORT:-3030}}"
EFFECTIVE_MODEL="${MODEL_PATH:-${CONFIG_MODEL:-$DEFAULT_MODEL}}"

HTTP_ENV="$(to_bool "${ENABLE_HTTP_ENDPOINTS:-}")"
HTTP_CFG="$(to_bool "${CONFIG_HTTP:-}")"
EFFECTIVE_HTTP="$HTTP_ENV"
if [[ "$HTTP_ENV" == "false" && "$HTTP_CFG" == "true" ]]; then
  EFFECTIVE_HTTP="true"
fi

print_version
echo "Mode: $MODE"
echo "Root: $ROOT_DIR"
echo "Main: $MAIN_DIR"
echo "Config: $CONFIG_FILE $( [[ -f "$CONFIG_FILE" ]] && echo "(found)" || echo "(missing)" )"
echo "Model: $EFFECTIVE_MODEL"
echo "Port: $EFFECTIVE_PORT"
echo "MCP: http://localhost:${EFFECTIVE_PORT}/mcp"
echo "HTTP endpoints: $EFFECTIVE_HTTP"
if [[ "$EFFECTIVE_HTTP" == "true" ]]; then
  echo "HTTP: http://localhost:${EFFECTIVE_PORT}/health"
  echo "HTTP: http://localhost:${EFFECTIVE_PORT}/views"
  echo "HTTP: http://localhost:${EFFECTIVE_PORT}/views/<name>"
  echo "HTTP: http://localhost:${EFFECTIVE_PORT}/elements"
  echo "HTTP: http://localhost:${EFFECTIVE_PORT}/elements/<name>"
fi
echo "Stop: press Ctrl+C"
echo

trap 'echo "Server stopped."' EXIT

cd "$MAIN_DIR"
if [[ "$MODE" == "prod" ]]; then
  npm run build
  npm start
else
  npm run dev
fi
