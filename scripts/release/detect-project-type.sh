#!/usr/bin/env bash
set -euo pipefail

if [[ -f pom.xml ]]; then
  echo "type=maven" >> "${GITHUB_OUTPUT}"
  exit 0
fi

if [[ -f package.json ]]; then
  echo "type=node" >> "${GITHUB_OUTPUT}"
  exit 0
fi

echo "Could not detect pom.xml or package.json" >&2
exit 1
