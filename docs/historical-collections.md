# Historical Swift Collections Lab

This lab preserves the ideas represented by the supplied historical Swift collection code while using isolated modern Swift fixtures for compiler observation.

The progression is:

```text
Java merge sort
     |
     v
Array-specific Swift algorithms
     |
     v
generic Sequence / Collection algorithms
     |
     +---- map <- reduce
     +---- binary search
     +---- one-sided ranges / slicing
     |
     v
persistent List
     |
     v
index identity -> tagged positions
     |
     v
Collection conformance
     |
     v
copy-on-write storage
     |
     v
Swift AST -> SIL -> LLVM IR
```

The modern fixtures are deliberately separate from the old source because APIs such as `SequenceType`, `CollectionType`, `ForwardIndexType`, `Generator`, `advancedBy`, `appendContentsOf`, and `isUniquelyReferencedNonObjC` belong to older Swift language/library generations.

## Compiler observation

Run:

```bash
chmod +x Scripts/*.sh
Scripts/collections-observe.sh
```

Artifacts:

```text
build/historical-collections/
├── merge-sort.ast.txt
├── merge-sort.sil
└── merge-sort.ll
```

The same `MergeSort.swift` fixture is passed through all three compiler stages.

## Fixtures

- `MergeSort.swift`: generic stable merge-sort evolution.
- `BinarySearch.swift`: ordered search over `RandomAccessCollection`.
- `PersistentList.swift`: recursive value-oriented list with structural sharing.
- `TaggedListIndex.swift`: explicit index position and constant-time distance.
- `CopyOnWrite.swift`: reference-backed uniqueness checking analogous to the historical buffer design.

The goal is compiler/library archaeology: preserve the design ideas, modernize the syntax where necessary, and make the resulting types observable in today's Swift compiler.
