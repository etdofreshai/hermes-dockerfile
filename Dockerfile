FROM nousresearch/hermes-agent:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --break-system-packages --no-cache-dir faster-whisper

ENV HERMES_HOME=/opt/data
ENV API_SERVER_ENABLED=true
ENV API_SERVER_HOST=0.0.0.0
ENV API_SERVER_PORT=8642

COPY start-hermes.sh /usr/local/bin/start-hermes.sh
RUN chmod +x /usr/local/bin/start-hermes.sh

VOLUME ["/opt/data"]

ENTRYPOINT ["/usr/local/bin/start-hermes.sh"]
