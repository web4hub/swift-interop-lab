// CFXMLInterface.cxx

#include "CFXMLInterface.hpp"

#include <string>

CFXMLInterface::CFXMLInterface() = default;

std::string CFXMLInterface::parse(const std::string& xml) {
    return "Parsed: " + xml;
}
