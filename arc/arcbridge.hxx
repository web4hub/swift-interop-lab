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
