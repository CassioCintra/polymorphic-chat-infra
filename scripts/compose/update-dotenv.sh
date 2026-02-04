#!/usr/bin/env bash
set -euo pipefail

project_key="${1:?missing project_key}"
version_tag="${2:?missing version_tag}"

file="deploy/.env"
[[ -f "$file" ]] || { echo "$file not found" >&2; exit 1; }

case "$project_key" in
  backend) key="BACKEND_VERSION" ;;
  frontend) key="FRONTEND_VERSION" ;;
  *) echo "invalid project_key (use backend|frontend)" >&2; exit 1 ;;
esac

if grep -q "^${key}=" "$file"; then
  sed -i "s/^${key}=.*/${key}=${version_tag}/" "$file"
else
  echo "${key}=${version_tag}" >> "$file"
fi

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

git add "$file"

if git diff --cached --quiet; then
  echo "No changes"
  exit 0
fi

git commit -m "chore(deploy): update ${key} to ${version_tag} [skip ci]"

: "${INFRA_PAT:?missing INFRA_PAT}"

git remote set-url origin "https://x-access-token:${INFRA_PAT}@github.com/CassioCintra/polymorphic-chat-infra.git"

git config --local --unset-all http.https://github.com/.extraheader 2>/dev/null || true
git config --local --unset-all "http.https://github.com/CassioCintra/polymorphic-chat-infra.git/.extraheader" 2>/dev/null || true

git push origin HEAD:master

