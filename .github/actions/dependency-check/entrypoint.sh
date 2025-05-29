#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Inputs
#   $1  → raw multiline string with scan flags (scan-args)
#   $OUT_PATH (env) → destination directory/file for the reports (out)
# ---------------------------------------------------------------------------

scan_args="$1"
out_path="${OUT_PATH:-dependency-check-report}"
mapfile -t args <<< $scanargs

# Run the scanner, forcing its --out to the explicit value.
# shellcheck disable=SC2086  # we *want* word splitting for scan_args
exec /usr/share/dependency-check/bin/dependency-check.sh \
     "${args[@]}" \
     --out "$out_path"
exit_code=$?

# Surface the report location to later workflow steps
echo "report-path=${out_path}" >>"$GITHUB_OUTPUT"

exit "$exit_code"
