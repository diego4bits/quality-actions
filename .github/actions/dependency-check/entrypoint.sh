#!/usr/bin/env bash
set -euo pipefail

# flags come from env, not $1
scan_args="${SCAN_ARGS}"
out_path="${OUT_PATH}"

# binary first, then flags, then --out
eval "/usr/share/dependency-check/bin/dependency-check.sh ${scan_args} --out \"${out_path}\""
exit_code=$?

echo "report-path=${out_path}" >>"$GITHUB_OUTPUT"
exit $exit_code
