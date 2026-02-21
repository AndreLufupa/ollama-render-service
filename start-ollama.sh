#!/usr/bin/env bash
set -euo pipefail

PORT_TO_USE="${PORT:-11434}"
export OLLAMA_HOST="${OLLAMA_HOST:-0.0.0.0:${PORT_TO_USE}}"

ollama serve &
OLLAMA_PID=$!

if [[ -n "${OLLAMA_MODEL:-}" ]]; then
  echo "Aguardando servidor Ollama ficar disponível..."
  until curl -fsS "http://127.0.0.1:${PORT_TO_USE}/api/tags" >/dev/null 2>&1; do
    sleep 1
  done

  echo "Baixando modelo: ${OLLAMA_MODEL}"
  ollama pull "${OLLAMA_MODEL}"
fi

wait "${OLLAMA_PID}"
