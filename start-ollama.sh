#!/usr/bin/env bash
set -euo pipefail

PORT_TO_USE="${PORT:-11434}"
export OLLAMA_HOST="${OLLAMA_HOST:-0.0.0.0:${PORT_TO_USE}}"

pull_model_list() {
  local raw_list="$1"
  IFS=',' read -r -a models <<< "$raw_list"

  for model in "${models[@]}"; do
    model="$(echo "$model" | xargs)"
    if [[ -n "$model" ]]; then
      echo "Baixando modelo: ${model}"
      ollama pull "$model"
    fi
  done
}

ollama serve &
OLLAMA_PID=$!

if [[ -n "${OLLAMA_MODEL:-}" || -n "${OLLAMA_MODELS:-}" || -n "${OLLAMA_EMBED_MODELS:-}" ]]; then
  echo "Aguardando servidor Ollama ficar disponível..."
  until curl -fsS "http://127.0.0.1:${PORT_TO_USE}/api/tags" >/dev/null 2>&1; do
    sleep 1
  done

  if [[ -n "${OLLAMA_MODEL:-}" ]]; then
    echo "Baixando modelo: ${OLLAMA_MODEL}"
    ollama pull "${OLLAMA_MODEL}"
  fi

  if [[ -n "${OLLAMA_MODELS:-}" ]]; then
    pull_model_list "${OLLAMA_MODELS}"
  fi

  if [[ -n "${OLLAMA_EMBED_MODELS:-}" ]]; then
    pull_model_list "${OLLAMA_EMBED_MODELS}"
  fi
fi

wait "${OLLAMA_PID}"
