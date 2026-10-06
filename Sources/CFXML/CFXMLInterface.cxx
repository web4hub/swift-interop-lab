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
