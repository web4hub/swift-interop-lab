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
