#!/usr/bin/env bash
set -euo pipefail
new_version="${1:?missing new_version}"
mvn -B versions:set -DnewVersion="${new_version}" -DgenerateBackupPoms=false
