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
