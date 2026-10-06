#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

require_tool swiftc

FIXTURE_DIR="${ROOT_DIR}/Sources/HistoricalSwift/Collections"
OUTPUT_DIR="${ROOT_DIR}/build/historical-collections"
REPORT="${OUTPUT_DIR}/evolution-report.md"
mkdir -p "${OUTPUT_DIR}"

"$(dirname "$0")/toolchain-info.sh" "${OUTPUT_DIR}/toolchain-info.txt" >/dev/null

fixtures=("MergeSort.swift" "BinarySearch.swift" "PersistentList.swift" "TaggedListIndex.swift" "CopyOnWrite.swift")

{
  echo "# Historical → Modern Swift Compiler Report"
  echo
  echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo
  echo "## Toolchain"
  echo
  cat "${OUTPUT_DIR}/toolchain-info.txt"
  echo
  echo "## Fixture observations"
  echo
} > "${REPORT}"

for fixture in "${fixtures[@]}"; do
  source_file="${FIXTURE_DIR}/${fixture}"
  stem="${fixture%.swift}"
  ast="${OUTPUT_DIR}/${stem}.ast.txt"
  sil="${OUTPUT_DIR}/${stem}.sil"
  ir="${OUTPUT_DIR}/${stem}.ll"

  swiftc -typecheck "${source_file}"
  swiftc -dump-ast "${source_file}" > "${ast}"
  swiftc -emit-sil "${source_file}" -o "${sil}"
  swiftc -emit-ir "${source_file}" -o "${ir}"

  {
    echo "### ${fixture}"
    echo
    echo "Source: ${source_file}"
    echo "AST: ${ast}"
    echo "SIL: ${sil}"
    echo "LLVM IR: ${ir}"
    echo "Typecheck: PASSED"
    echo
  } >> "${REPORT}"
done

{
  echo "## Historical → modern mappings"
  echo
  echo "| Historical | Modern | Category |"
  echo "|---|---|---|"
  python3 - "${FIXTURE_DIR}/evolution-map.json" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
for item in data["mappings"]:
    print("| %s | %s | %s |" % (item["historical"], item["modern"], item["category"]))
PY
} >> "${REPORT}"

echo "Compiler report: ${REPORT}"
