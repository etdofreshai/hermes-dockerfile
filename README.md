# Hermes Dokploy Service

This repo is set up to mirror the Dokploy patterns already working in your stack:

- GitHub-backed `Dockerfile` application
- one persistent volume
- runtime secrets supplied from Dokploy env vars
- Hermes state persisted under `/opt/data`

## Why this shape

Your current live services follow two useful patterns:

- `Claude Code Server`: a Dockerfile app with a single durable home-directory mount
- `OpenClaw`: a durable state mount and env-driven configuration

Hermes fits that same model well. The official docs recommend mounting a single
data directory and running the gateway persistently.

## Dokploy app settings

Recommended Dokploy configuration:

- Build type: `Dockerfile`
- Repository: this repo
- Volume mount:
  - name: `hermes-data`
  - mount path: `/opt/data`
- Exposed port:
  - `8642`
- Domain:
  - optional at first; prefer private/internal access until the service is stable

## Suggested env vars

At minimum:

- `OPENAI_API_KEY` or `OPENROUTER_API_KEY`
- `API_SERVER_KEY`

If you want chat control:

- `TELEGRAM_BOT_TOKEN`
- `DISCORD_BOT_TOKEN`
- `SLACK_BOT_TOKEN`
- `SLACK_APP_TOKEN`

If you want Hermes to reach your existing internal helpers/skills:

- `DOKPLOY_TOKEN`
- `DOKPLOY_VIEWER_URL`
- `DOKPLOY_VIEWER_TOKEN`
- `MEMORY_DATABASE_API_URL`
- `MEMORY_DATABASE_API_TOKEN`

## First boot notes

This image writes selected Dokploy env vars into `/opt/data/.env` on startup and
then launches:

```bash
hermes gateway run
```

That is enough for a basic non-interactive boot, but for a polished setup you
will usually want to exec into the container once and run:

```bash
hermes setup
```

or manually create `/opt/data/config.yaml`.

## Recommended next step

Start simple:

- run Hermes privately
- persist `/opt/data`
- use it for memory, scheduled jobs, and agent API access
- keep Codex as the main coding surface

Then add public chat channels or a dashboard only after the base gateway is stable.
