#!/usr/bin/env bash
set -euo pipefail
tag="${1:?missing tag}"

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

git add -A
git commit -m "chore(release): ${tag} [skip ci]" || echo "No changes to commit"

git push origin HEAD:master
