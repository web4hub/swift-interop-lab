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
