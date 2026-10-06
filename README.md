# swift-interop-lab

A focused laboratory for C, Objective-C, C++, Objective-C++, Clang ASTs, Swift Clang importing, ARC ownership, layout, bridging, calling conventions, SIL, and LLVM IR.

## File-extension convention

This repository uses a deliberate source naming convention:

| Language | Extension |
|---|---|
| C header | `.hxx` |
| C source | `.cc` |
| C++ header | `.hxx` |
| C++ source | `.cxx` |
| Objective-C / Objective-C++ | `.mm` |

No new `.h` or `.c` files should be introduced. Use `.hxx` for headers, `.cc` for C implementation, `.cxx` for C++ implementation, and `.mm` for Objective-C++.

## Build

For the lab itself:

```bash
cmake -G Ninja -B build
cmake --build build
ctest --test-dir build --output-on-failure
```

For the Swift compiler dependency workflow:

```bash
cmake -G Ninja -B <build-folder> -DFOUNDATION_SWIFTPM_DEPS=YES
cmake --build <build-folder> --target WindowsSwiftPMDependencies
```

The `WindowsSwiftPMDependencies` target belongs to the Swift compiler build workflow; it is separate from this lab's small CMake project.

## Architecture

```text
C / ObjC / C++ / ObjC++
          |
          v
        Clang
          |
          +---- AST
          +---- ownership
          +---- nullability
          +---- layout
          +---- calling convention
          |
          v
   Swift Clang Importer
          |
          v
      Swift AST
          |
          v
         SIL
          |
          v
       LLVM IR
          |
          v
     machine code
```

## ARC struct experiment

The central experiment models ARC-qualified fields:

```objc
typedef struct {
    __strong NSObject *_Nonnull object;
    __weak id _Nullable delegate;
    int64_t cost;
} CacheEntry;
```

Conceptual Swift shape:

```swift
struct CacheEntry {
    var object: NSObject
    weak var delegate: AnyObject?
    var cost: Int64
}
```

Ownership, nullability, and bridging are separate dimensions:

```text
__strong / __weak    -> ownership
_Nonnull / _Nullable -> nullability
NSString* / String   -> bridging
```

## Experimental importer flag

When supported by the installed Swift toolchain:

```text
-enable-experimental-feature ImportCStructsWithArcFields
```

This flag is intentionally opt-in. The repository does not assume that every Swift release implements the proposal.

## Layout

```text
swift-interop-lab/
├── Sources/
│   ├── CInterop/
│   │   ├── include/
│   │   │   ├── ArcStructs.hxx
│   │   │   └── CTypes.hxx
│   │   └── ArcStructs.cc
│   ├── ObjCInterop/
│   │   ├── ArcStructs.hxx
│   │   └── ArcStructs.mm
│   ├── ObjCxxInterop/
│   │   ├── Bridge.hxx
│   │   └── Bridge.mm
│   ├── CxxInterop/
│   │   ├── Bridge.hxx
│   │   └── Bridge.cxx
│   └── SwiftInterop/
│       └── main.swift
├── Examples/
├── Compiler/
├── Tests/
├── docs/
├── scripts/
└── CMakeLists.txt
```

## Scope

This is an interoperability research lab, not a replacement Swift compiler. The goal is to make foreign-language declarations, ownership semantics, ABI/layout behavior, and Swift compiler lowering observable and reproducible.
