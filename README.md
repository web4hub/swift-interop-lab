# swift-interop-lab
```cmake
├── README.md
├── LICENSE
├── .gitignore
│
├── Sources/
│   ├── CInterop/
│   │   ├── include/
│   │   │   ├── ArcStructs.hxx
│   │   │   └── CTypes.hxx
│   │   └── ArcStructs.cxx
│   │
│   ├── ObjCInterop/
│   │   ├── ArcStructs.hxx
│   │   └── ArcStructs.mm
│   │
│   ├── ObjCxxInterop/
│   │   ├── Bridge.hpp
│   │   └── Bridge.mm
│   │
│   ├── CxxInterop/
│   │   ├── Bridge.hpp
│   │   └── Bridge.cpp
│   │
│   └── SwiftInterop/
│       └── main.swift
│
├── Tests/
│   ├── CInteropTests/
│   ├── ObjCInteropTests/
│   ├── ObjCxxInteropTests/
│   └── CxxInteropTests/
│
├── Examples/
│   ├── 01-basic-c/
│   ├── 02-arc-strong/
│   ├── 03-arc-weak/
│   ├── 04-nsstring-bridging/
│   ├── 05-objective-c/
│   ├── 06-cpp/
│   └── 07-objective-cpp/
│
├── Compiler/
│   ├── AST/
│   ├── Importer/
│   ├── Ownership/
│   ├── Layout/
│   ├── Bridging/
│   └── CallingConvention/
│
├── docs/
│   ├── architecture.md
│   ├── arc.md
│   ├── clang-importer.md
│   ├── cxx-interop.md
│   └── memory-model.md
│
└── Package.swift
