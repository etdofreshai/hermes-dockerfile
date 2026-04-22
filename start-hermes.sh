#!/usr/bin/env bash
set -euo pipefail

mkdir -p /opt/data
touch /opt/data/.env

upsert_env() {
  local key="$1"
  local value="${2-}"
  local env_file="/opt/data/.env"

  if [[ -z "$value" ]]; then
    return
  fi

  if grep -q "^${key}=" "$env_file" 2>/dev/null; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$env_file"
  else
    printf "%s=%s\n" "$key" "$value" >> "$env_file"
  fi
}

# Persist the most common Dokploy-provided secrets/config into Hermes' data dir
# so the agent can reboot without requiring an interactive setup flow.
for key in \
  OPENAI_API_KEY \
  OPENROUTER_API_KEY \
  TELEGRAM_BOT_TOKEN \
  DISCORD_BOT_TOKEN \
  SLACK_BOT_TOKEN \
  SLACK_APP_TOKEN \
  API_SERVER_ENABLED \
  API_SERVER_HOST \
  API_SERVER_PORT \
  API_SERVER_KEY \
  HONCHO_API_KEY \
  HONCHO_BASE_URL \
  OPENAI_BASE_URL \
  OPENROUTER_BASE_URL \
  GITHUB_TOKEN \
  GITLAB_TOKEN \
  DOKPLOY_TOKEN \
  DOKPLOY_VIEWER_URL \
  DOKPLOY_VIEWER_TOKEN \
  MEMORY_DATABASE_API_URL \
  MEMORY_DATABASE_API_TOKEN
do
  upsert_env "$key" "${!key-}"
done

if [[ ! -f /opt/data/config.yaml ]]; then
  cat >&2 <<'MSG'
Hermes is starting with no config.yaml yet.
This is okay for a first boot if your env vars are sufficient, but you'll likely
want to exec into the container later and run `hermes setup` or add a config file
for messaging, memory, and command policy.
MSG
fi

exec hermes gateway run
