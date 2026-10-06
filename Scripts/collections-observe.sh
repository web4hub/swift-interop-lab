#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
echo "== swift-interop-lab historical collections observation =="
"$(dirname "$0")/collections-ast.sh"
"$(dirname "$0")/collections-sil.sh"
"$(dirname "$0")/collections-ir.sh"
echo
echo "Artifacts:"
find "$${ROOT_DIR/build/historical-collections" -maxdepth 1 -type f -print | sort
