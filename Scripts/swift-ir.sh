#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

require_tool swiftc

INPUT="${1:-${OBS_DIR}/main.swift}"
OUTPUT="${2:-${BUILD_DIR}/swift.ll}"

mkdir -p "$(dirname "${OUTPUT}")"
swiftc -emit-ir "${INPUT}" -o "${OUTPUT}"

echo "LLVM IR: ${OUTPUT}"
