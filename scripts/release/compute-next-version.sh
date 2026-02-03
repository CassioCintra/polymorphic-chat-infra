#!/usr/bin/env bash
set -euo pipefail

bump="${1:-patch}"

git fetch --tags

last="$(git tag -l "v*" --sort=-v:refname | head -n 1 || true)"
[[ -z "${last}" ]] && last="v0.0.0"

v="${last#v}"
IFS='.' read -r major minor patch <<< "$v"

case "$bump" in
  major) major=$((major+1)); minor=0; patch=0 ;;
  minor) minor=$((minor+1)); patch=0 ;;
  patch|*) patch=$((patch+1)) ;;
esac

next="v${major}.${minor}.${patch}"
echo "next=$next" >> "${GITHUB_OUTPUT}"
echo "next_version=${major}.${minor}.${patch}" >> "${GITHUB_OUTPUT}"
