# swift-interop-lab

A focused laboratory for C, Objective-C, C++, Objective-C++, Clang ASTs, Swift Clang importing, ARC ownership, layout, bridging, calling conventions, SIL, and LLVM IR.

## File-extension convention

| Language | Extension |
|---|---|
| C header | `.hxx` |
| C source | `.cc` |
| C++ header | `.hxx` |
| C++ source | `.cxx` |
| Objective-C / Objective-C++ | `.mm` |

No new `.h` or `.c` files should be introduced.

## Compiler-observation layer

The pipeline is now executable stage-by-stage:

```text
C / Objective-C / C++ / Objective-C++
                |
                v
             Clang
                |
                +---- Clang AST
                |
                v
       Swift Clang Importer
                |
                +---- Swift imported AST
                |
                v
            Swift AST
                |
                v
               SIL
                |
                v
            LLVM IR
```

Run everything:

```bash
chmod +x Scripts/*.sh
Scripts/observe.sh
```

Run individual stages:

```bash
Scripts/clang-ast.sh
Scripts/swift-import-ast.sh
Scripts/swift-ast.sh
Scripts/swift-sil.sh
Scripts/swift-ir.sh
```

The Objective-C importer stage is guarded to macOS because ARC/Foundation importing is not a portable Swift-on-Linux assumption.

The importer stage uses the experimental feature:

```text
-enable-experimental-feature ImportCStructsWithArcFields
```

Artifacts are written to `build/compiler-observation/`.

## ARC observation fixture

```objc
typedef struct {
    __strong NSObject *_Nonnull object;
    __weak id _Nullable delegate;
    int64_t value;
} ObservationEntry;
```

This fixture lets the lab observe ownership, nullability, importer behavior, and eventual Swift lowering.

## Swift compiler dependency workflow

```bash
cmake -G Ninja -B <build-folder> -DFOUNDATION_SWIFTPM_DEPS=YES
cmake --build <build-folder> --target WindowsSwiftPMDependencies
```

`WindowsSwiftPMDependencies` belongs to the Swift compiler build workflow, not this small observation harness.

## Layout

```text
swift-interop-lab/
├── Sources/CompilerObservation/
│   ├── Observation.hxx
│   ├── Observation.mm
│   └── main.swift
├── Scripts/
│   ├── common.sh
│   ├── clang-ast.sh
│   ├── swift-import-ast.sh
│   ├── swift-ast.sh
│   ├── swift-sil.sh
│   ├── swift-ir.sh
│   └── observe.sh
├── docs/compiler-observation.md
├── .codex/
├── config.jsq
└── README.md
```


## Historical Swift collections observation

The historical Swift collection material is now preserved as modern, isolated compiler fixtures:

```text
Sources/HistoricalSwift/Collections/
├── MergeSort.swift
├── BinarySearch.swift
├── PersistentList.swift
├── TaggedListIndex.swift
└── CopyOnWrite.swift

Scripts/
├── collections-ast.sh
├── collections-sil.sh
├── collections-ir.sh
└── collections-observe.sh
```

Run the observation pipeline:

```bash
chmod +x Scripts/*.sh
Scripts/collections-observe.sh
```

This produces AST, SIL, and LLVM IR artifacts under `build/historical-collections/`.

The old Swift snippets are treated as historical language/library archaeology rather than as a single modern source file. The fixtures preserve the important transitions: generic algorithms, persistent lists, index identity, collection conformance, slicing/index semantics, and copy-on-write storage.

See `docs/historical-collections.md` for the progression and interpretation.


## Historical → modern compiler diff

The collections lab now includes a semantic evolution map and a reproducible compiler report:

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

This captures the current Swift/Clang toolchain identity and generates per-fixture AST, SIL, LLVM IR, plus `evolution-report.md`.

The semantic mappings include:

```text
SequenceType                 → Sequence
CollectionType               → Collection
RandomAccessIndexType        → RandomAccessCollection
Generator                    → IteratorProtocol
advancedBy                   → index(_:offsetBy:)
isUniquelyReferencedNonObjC → isKnownUniquelyReferenced
appendContentsOf             → append(contentsOf:)
ForwardIndexType             → modern Collection index model
```

See `docs/historical-compiler-diff.md`.
