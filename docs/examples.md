# cleanest side-by-side example of `.cxx` vs `.mm`, using your `.hxx` convention.

### 1. `.cxx` — pure C++

`CFXMLInterface.hxx`

```cpp
#pragma once

#include <string>

namespace CFXML {

class Interface {
public:
    Interface();
    std::string parse(const std::string& xml);
};

}
```

`CFXMLInterface.cxx`

```cpp
#include "CFXMLInterface.hxx"

namespace CFXML {

Interface::Interface() = default;

std::string Interface::parse(const std::string& xml) {
    return "Parsed XML: " + xml;
}

}
```

This is **C++ only**:

```text
CFXMLInterface.hxx
        ↓
CFXMLInterface.cxx
        ↓
      Clang++
        ↓
      LLVM IR
```

No Objective-C runtime. No `NSObject`. No `@interface`. No `__weak`.

---

### 2. `.mm` — Objective-C++

`CFXMLInterface.hxx`

```cpp
#pragma once

#include <string>

class CFXMLInterface {
public:
    std::string parse(const std::string& xml);
};
```

`CFXMLInterface.mm`

```objc
#import <Foundation/Foundation.h>
#include "CFXMLInterface.hxx"

std::string CFXMLInterface::parse(const std::string& xml) {
    NSString *input =
        [NSString stringWithUTF8String:xml.c_str()];

    NSString *result =
        [NSString stringWithFormat:@"Parsed XML: %@", input];

    return [result UTF8String];
}
```

Now one source file contains **both C++ and Objective-C**:

```text
C++
 ├── std::string
 ├── class
 └── methods

Objective-C
 ├── NSString
 ├── [object message]
 └── Foundation

        ↓

   Objective-C++
        ↓
       Clang
```

That's exactly what `.mm` means.

---

### 3. `.mm` + ARC

This is where your Swift ARC-struct proposal becomes especially interesting.

`ArcBridge.hxx`

```cpp
#pragma once

#include <cstdint>

#ifdef __OBJC__
#import <Foundation/Foundation.h>

struct ArcEntry {
    __strong NSObject *object;
    __weak NSObject *delegate;
    int64_t value;
};

#else

struct ArcEntry {
    void *object;
    void *delegate;
    int64_t value;
};

#endif
```

`ArcBridge.mm`

```objc
#import "ArcBridge.hxx"

ArcEntry makeEntry(NSObject *object,
                   NSObject *delegate,
                   int64_t value) {

    ArcEntry entry = {
        .object = object,
        .delegate = delegate,
        .value = value
    };

    return entry;
}
```

Here:

```text
.mm
 │
 ├── C++ struct
 │
 ├── Objective-C NSObject
 │
 ├── __strong
 │
 ├── __weak
 │
 └── ARC
 │
 ▼
Clang AST
 │
 ▼
Swift Clang Importer
 │
 ▼
Swift struct
```

Conceptually, Swift can see something like:

```swift
struct ArcEntry {
    var object: NSObject
    weak var delegate: NSObject?
    var value: Int64
}
```

---

### 4. `.cxx` cannot do the Objective-C part

This:

```cpp
#include <Foundation/Foundation.h>

NSString *name = @"Hello";
```

doesn't belong in a normal `.cxx` translation unit.

But this works in `.mm`:

```objc
#import <Foundation/Foundation.h>

NSString *name = @"Hello";
```

Because `.mm` tells Clang:

> “Parse this file as Objective-C++.”

---

### 5. The really useful comparison

```text
                    .cxx                         .mm
                     │                           │
                     ▼                           ▼
                 C++ mode                 Objective-C++ mode
                     │                           │
          ┌──────────┴─────────┐       ┌────────┴─────────┐
          │                    │       │                  │
       C++ STL              C++       C++ STL        Objective-C
       classes             syntax     classes          syntax
          │                    │       │                  │
          └──────────┬─────────┘       └────────┬─────────┘
                     │                           │
                     ▼                           ▼
                   Clang                       Clang
                                                 │
                                      ┌──────────┴──────────┐
                                      │                     │
                                    ARC                 ObjC runtime
                                      │                     │
                                      └──────────┬──────────┘
                                                 ▼
                                            LLVM / Swift
```

So for your lab, the rule is simple:

```text
Pure C++ logic
    → .cxx

C++ + Objective-C/Foundation/ARC
    → .mm
```

And your `.hxx` can be the shared interface:

```text
CFXMLInterface.hxx
       │
       ├── CFXMLInterface.cxx   ← pure C++
       │
       └── CFXMLInterface.mm    ← Objective-C++
```

That last pattern is especially useful when you're testing **C++ ↔ Objective-C ↔ Swift interop**. 🚀
