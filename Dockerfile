FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
  PORT=11434 \
  OLLAMA_MODELS=/root/.ollama/models

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://ollama.com/install.sh | bash

COPY start-ollama.sh /usr/local/bin/start-ollama.sh
RUN chmod +x /usr/local/bin/start-ollama.sh

EXPOSE 11434
VOLUME ["/root/.ollama"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=5 \
  CMD bash -lc 'curl -fsS "http://127.0.0.1:${PORT:-11434}/api/tags" >/dev/null || exit 1'

CMD ["/usr/local/bin/start-ollama.sh"]
