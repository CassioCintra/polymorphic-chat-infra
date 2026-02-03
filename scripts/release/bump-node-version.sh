#!/usr/bin/env bash
set -euo pipefail
new_version="${1:?missing new_version}"
npm version "${new_version}" --no-git-tag-version
