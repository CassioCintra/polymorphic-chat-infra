#!/usr/bin/env bash
set -euo pipefail
tag="${1:?missing tag}"

git tag -a "${tag}" -m "Release ${tag}"
git push origin "${tag}"
