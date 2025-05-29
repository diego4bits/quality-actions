#!/usr/bin/env bash
set -euo pipefail

scan_args="$1"
out_path="/github/workspace"

eval "/usr/share/dependency-check/bin/dependency-check.sh ${scan_args} --out \"${report_dir}\""
exit_code=$? 


echo "report-path=${out_path}" >>"$GITHUB_OUTPUT"


exit "$exit_code"