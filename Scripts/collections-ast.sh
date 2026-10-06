#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_tool swiftc
INPUT="${ROOT_DIR}/Sources/HistoricalSwift/Collections/MergeSort.swift"
OUTPUT="${ROOT_DIR}/build/historical-collections/merge-sort.ast.txt"
mkdir -p "$(dirname "$${OUTPUT")"
swiftc -dump-ast "$${INPUT" > "$${OUTPUT"
echo "Swift AST: $${OUTPUT"
