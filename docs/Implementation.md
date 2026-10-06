# study
`swift-interop-lab`, studying: **`.hxx` header → `.cxx` C++ implementation → `.mm` Objective-C++ bridge → Swift → importer/AST/SIL/LLVM IR**.

The cleanest project-native example is a `CFXMLInterface` that keeps the C++ API simple while letting `.mm` interact with Foundation/ARC.

```cmake
Sources/
└── CFXML/
    ├── CFXMLInterface.hxx
    ├── CFXMLInterface.cxx
    └── CFXMLInterface.mm
```

### 1. `CFXMLInterface.hxx`

```cpp
#pragma once

#include <cstdint>
#include <string>

namespace CFXML {

struct ParseResult {
    bool success;
    std::int64_t nodeCount;
    std::string rootElement;
};

class Interface {
public:
    Interface() = default;
    ~Interface() = default;

    ParseResult parse(const std::string& xml) const;
};

} // namespace CFXML
```

This is your **C++ interface/header**.

Notice the important part:

```cpp
struct ParseResult
```

is a normal C++ value type, so it can be implemented entirely in `.cxx`.

---

### 2. `CFXMLInterface.cxx`

```cpp
#include "CFXMLInterface.hxx"

#include <cctype>
#include <string>

namespace CFXML {

ParseResult Interface::parse(const std::string& xml) const {
    ParseResult result{
        .success = !xml.empty(),
        .nodeCount = 0,
        .rootElement = {}
    };

    if (xml.empty()) {
        return result;
    }

    for (char character : xml) {
        if (character == '<') {
            ++result.nodeCount;
        }
    }

    const std::size_t rootStart = xml.find('<');
    const std::size_t rootEnd = xml.find('>', rootStart);

    if (rootStart != std::string::npos &&
        rootEnd != std::string::npos) {

        std::size_t nameStart = rootStart + 1;

        if (nameStart < rootEnd && xml[nameStart] == '/') {
            ++nameStart;
        }

        std::size_t nameEnd = nameStart;

        while (nameEnd < rootEnd &&
               !std::isspace(
                   static_cast<unsigned char>(xml[nameEnd]))) {
            ++nameEnd;
        }

        result.rootElement =
            xml.substr(nameStart, nameEnd - nameStart);
    }

    return result;
}

} // namespace CFXML
```

Now `.cxx` is **pure C++**:

```cmake
CFXMLInterface.hxx
        ↓
CFXML::Interface
        ↓
CFXMLInterface.cxx
        ↓
C++ implementation
```

No Foundation.
No Objective-C.
No ARC.

---

### 3. `CFXMLInterface.mm`

Now the interesting part.

```objc
#import <Foundation/Foundation.h>

#include "CFXMLInterface.hxx"

#include <string>

namespace CFXML {

static NSString *ToNSString(const std::string& value) {
    return [NSString stringWithUTF8String:value.c_str()];
}

static std::string ToStdString(NSString *value) {
    if (value == nil) {
        return {};
    }

    const char *utf8 = [value UTF8String];

    if (utf8 == nullptr) {
        return {};
    }

    return std::string(utf8);
}

} // namespace CFXML
```

This is where `.mm` becomes special.

You can simultaneously use:

```objc
NSString *
```

and:

```cpp
std::string
```

inside the same translation unit.

That's **Objective-C++**.

---

### 4. Add an ARC-owned struct

This makes it directly relevant to the Swift proposal you've been studying.

Create:

```cmake
Sources/
└── CFXML/
    └── CFXMLArcEntry.hxx
```

```objc
#pragma once

#include <cstdint>

#ifdef __OBJC__

#import <Foundation/Foundation.h>

namespace CFXML {

struct ArcEntry {
    __strong NSObject *_Nonnull object;
    __weak NSObject *_Nullable delegate;
    std::int64_t value;
};

} // namespace CFXML

#else

namespace CFXML {

struct ArcEntry {
    void *object;
    void *delegate;
    std::int64_t value;
};

} // namespace CFXML

#endif
```

Now your `.mm` can construct it:

```objc
#import <Foundation/Foundation.h>

#include "CFXMLArcEntry.hxx"

namespace CFXML {

ArcEntry makeArcEntry(
    NSObject *object,
    NSObject *delegate,
    std::int64_t value
) {
    ArcEntry entry = {
        .object = object,
        .delegate = delegate,
        .value = value
    };

    return entry;
}

} // namespace CFXML
```

And **this** is exactly where your compiler-observation work becomes interesting:

```cmake
CFXMLArcEntry.hxx
        │
        ▼
      Clang
        │
        ├── __strong
        ├── __weak
        ├── NSObject *
        ├── nullability
        └── struct layout
        │
        ▼
 Swift Clang Importer
        │
        ▼
   Swift imported type
        │
        ▼
      Swift AST
        │
        ▼
       SIL
        │
        ▼
     LLVM IR
```

### 5. Swift side

For example:

```swift
import Foundation

let parser = CFXML.Interface()

let xml = """
<book>
    <title>Swift Interop</title>
</book>
"""

let result = parser.parse(xml)

print("success:", result.success)
print("nodes:", result.nodeCount)
print("root:", result.rootElement)
```

Conceptually:

```cmake
Swift
  │
  │ CFXML.Interface()
  ▼
Swift Clang Importer
  │
  ▼
C++ declaration
  │
  ▼
CFXML::Interface
```

---

### And your `.hpp` vs `.hxx` decision

For **your project**, I would stick with `.hxx`, not mix `.hpp` and `.hxx`.

So your convention becomes:

```ascii
┌─────────────────────────────┐
│      swift-interop-lab      │
├─────────────────────────────┤
│ C header          → .hxx    │
│ C source          → .cc     │
│ C++ header        → .hxx    │
│ C++ source        → .cxx    │
│ Objective-C++     → .mm     │
│ Swift             → .swift  │
└─────────────────────────────┘
```

Then your CFXML experiment fits naturally:

```cmake
Sources/
├── CFXML/
│   ├── CFXMLInterface.hxx
│   ├── CFXMLInterface.cxx
│   ├── CFXMLArcEntry.hxx
│   └── CFXMLArcEntry.mm
│
└── CompilerObservation/
    ├── Observation.hxx
    ├── Observation.mm
    └── main.swift

Scripts/
├── clang-ast.sh
├── swift-import-ast.sh
├── swift-ast.sh
├── swift-sil.sh
├── swift-ir.sh
└── observe.sh
```

So the distinction in your lab is very clean:

**`.hxx` = declaration/interface**

**`.cxx` = pure C++ implementation**

**`.mm` = C++ + Objective-C/Foundation/ARC implementation**

That gives you a real end-to-end laboratory rather than just isolated extension examples. 🔥
