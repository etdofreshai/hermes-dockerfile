FROM nousresearch/hermes-agent:latest

ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:${PATH}

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    ffmpeg \
    openssh-client \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain stable && \
    rustup component add clippy rustfmt

RUN python3 -m pip install --break-system-packages --no-cache-dir faster-whisper

RUN npm install -g --no-audit @openai/codex

ENV HERMES_HOME=/opt/data
ENV API_SERVER_ENABLED=true
ENV API_SERVER_HOST=0.0.0.0
ENV API_SERVER_PORT=8642

COPY start-hermes.sh /usr/local/bin/start-hermes.sh
RUN chmod +x /usr/local/bin/start-hermes.sh

VOLUME ["/opt/data"]

ENTRYPOINT ["/usr/local/bin/start-hermes.sh"]
