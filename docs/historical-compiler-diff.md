# Historical → Modern Swift Compiler Diff

This layer makes Swift language evolution reproducible instead of treating the old snippets as one compilable program.

The historical API concept is mapped to a modern equivalent, then the modernized fixture is observed through the current compiler:

```text
historical Swift concept
        |
        v
evolution-map.json
        |
        v
modern Swift fixture
        |
        +--> typecheck
        +--> Swift AST
        +--> SIL
        +--> LLVM IR
        |
        v
evolution-report.md
```

Run:

```bash
chmod +x Scripts/*.sh
Scripts/compare-historical.sh
```

The generated report is:

`build/historical-collections/evolution-report.md`

The toolchain fingerprint is captured in:

`build/historical-collections/toolchain-info.txt`

The semantic mapping manifest is:

`Sources/HistoricalSwift/Collections/evolution-map.json`

The current compiler artifacts are intentionally generated from modern fixtures. This avoids claiming that historical APIs such as `SequenceType`, `CollectionType`, `Generator`, `advancedBy`, or `isUniquelyReferencedNonObjC` are still accepted by today's Swift compiler.

The result is a compiler-archaeology loop:

```text
API evolution
    ↓
modernization
    ↓
type checking
    ↓
AST
    ↓
SIL
    ↓
LLVM IR
```
