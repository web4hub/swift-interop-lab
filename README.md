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
