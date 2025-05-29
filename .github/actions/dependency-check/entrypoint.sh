#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Inputs
#   $1  → raw multiline string with scan flags (scan-args)
#   $OUT_PATH (env) → destination directory/file for the reports (out)
# ---------------------------------------------------------------------------

scan_args="$1"
out_path="${OUT_PATH:-dependency-check-report}"

# Declara un array para almacenar los argumentos
declare -a args

# Lee el string multilínea en el array.
# -t: Remueve el salto de línea final de cada línea.
# <<< "$scan_args": Proporciona el string (con comillas para preservar
#                   los saltos de línea) a mapfile como entrada.
# Se verifica si scan_args no está vacío antes de llamar a mapfile
# para evitar errores si la entrada está vacía.
if [[ -n "$scan_args" ]]; then
    mapfile -t args <<< "$scan_args"
fi

# Ejecuta el escáner.
# "${args[@]}": Expande el array de forma segura, donde cada elemento
#               se convierte en un argumento separado. Esto evita problemas
#               con espacios o caracteres especiales en los flags/valores.
/usr/share/dependency-check/bin/dependency-check.sh \
      "${args[@]}" \
      --out "$out_path"
exit_code=$? # Captura el código de salida del comando anterior

# Muestra la ubicación del informe para pasos posteriores del flujo de trabajo
echo "report-path=${out_path}" >>"$GITHUB_OUTPUT"

# Sale con el código de salida del escáner
exit "$exit_code"