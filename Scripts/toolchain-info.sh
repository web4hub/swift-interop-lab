#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
OUTPUT="${1:-${ROOT_DIR}/build/toolchain-info.txt}"
mkdir -p "$(dirname "$OUTPUT")"
{
  echo "platform=$(uname -s)"
  echo "architecture=$(uname -m)"
  echo "kernel=$(uname -sr)"
  if command -v swiftc >/dev/null 2>&1; then echo "swiftc=$(swiftc --version | head -n 1)"; else echo "swiftc=NOT_FOUND"; fi
  if command -v clang >/dev/null 2>&1; then echo "clang=$(clang --version | head -n 1)"; else echo "clang=NOT_FOUND"; fi
} > "$OUTPUT"
cat "$OUTPUT"
