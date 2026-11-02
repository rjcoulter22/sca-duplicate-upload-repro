#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if ! git remote get-url origin >/dev/null 2>&1; then
  echo "Set the real test repository origin before uploading." >&2
  exit 1
fi
if ! git diff --quiet HEAD --; then
  echo "Commit fixture changes before uploading." >&2
  exit 1
fi
exec datadog-ci sbom upload --service sca-duplicate-upload-repro --env ci --git-repository . sbom.json
