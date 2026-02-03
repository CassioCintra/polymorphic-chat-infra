#!/usr/bin/env bash
set -euo pipefail

: "${DISCORD_WEBHOOK_URL:?missing DISCORD_WEBHOOK_URL}"

status_test="$(./scripts/discord/status-label.sh "${TEST_RESULT:-unknown}")"
status_version="$(./scripts/discord/status-label.sh "${VERSION_RESULT:-unknown}")"
status_docker="$(./scripts/discord/status-label.sh "${DOCKER_RESULT:-unknown}")"
status_compose="$(./scripts/discord/status-label.sh "${UPDATE_COMPOSE_RESULT:-unknown}")"

project="${PROJECT:-unknown}"
repo="${REPO:-unknown}"
tag="${VERSION_TAG:-}"
image="${DOCKER_IMAGE:-}"
run_url="${RUN_URL:-}"

content="**Release**: ${project}
Repo: ${repo}
Test: ${status_test}
Version: ${status_version}
Docker: ${status_docker}
Compose: ${status_compose}
Tag: ${tag}
Image: ${image}
Run: ${run_url}"

payload="$(jq -nc --arg content "$content" '{content:$content}' 2>/dev/null || true)"

if [[ -z "${payload}" ]]; then
  # fallback sem jq
  payload="{\"content\":\"${content//\"/\\\"}\"}"
fi

curl -sS -X POST \
  -H "Content-Type: application/json" \
  -d "${payload}" \
  "${DISCORD_WEBHOOK_URL}" >/dev/null
