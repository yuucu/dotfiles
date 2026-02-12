#!/bin/bash
set -euo pipefail

EXIT_CODE=0

staged_files=$(git diff --cached --name-only --diff-filter=ACMR)

if [ -z "$staged_files" ]; then
  exit 0
fi

shell_files=$(echo "$staged_files" | rg '\.sh$' || true)
if [ -n "$shell_files" ] && command -v shellcheck >/dev/null 2>&1; then
  while IFS= read -r file; do
    [ -f "$file" ] || continue
    shellcheck "$file" || EXIT_CODE=1
  done <<< "$shell_files"
fi

lua_files=$(echo "$staged_files" | rg '^dot_config/nvim/.*\.lua$' || true)
if [ -n "$lua_files" ] && command -v stylua >/dev/null 2>&1; then
  while IFS= read -r file; do
    [ -f "$file" ] || continue
    stylua --check "$file" || EXIT_CODE=1
  done <<< "$lua_files"
fi

exit "$EXIT_CODE"
