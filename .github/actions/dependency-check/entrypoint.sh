#!/usr/bin/env bash
set -euo pipefail

scan_args="$1"
out_path="${OUT_PATH:-dependency-check-report}"

readarray -t ARGS <<< "$scan_args"

/usr/share/dependency-check/bin/dependency-check.sh \
      "${ARGS[@]}" \
      --out "$out_path"
exit_code=$? 


echo "report-path=${out_path}" >>"$GITHUB_OUTPUT"


exit "$exit_code"