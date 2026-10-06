#include "CFXMLInterface.hxx"

namespace CFXML {

Interface::Interface() = default;

std::string Interface::parse(const std::string& xml) {
    return "Parsed XML: " + xml;
}

}
