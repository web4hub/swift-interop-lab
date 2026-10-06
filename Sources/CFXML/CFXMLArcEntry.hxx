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
