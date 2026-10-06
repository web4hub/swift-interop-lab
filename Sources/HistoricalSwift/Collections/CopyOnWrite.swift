public struct ReferenceBackedBuffer<Element> {
    private final class Box {
        var storage: [Element]
        init(_ storage: [Element]) { self.storage = storage }
        func clone() -> Box { Box(storage) }
    }

    private var box: Box
    public init(_ elements: [Element] = []) { box = Box(elements) }

    public mutating func append(_ element: Element) {
        if !isKnownUniquelyReferenced(&box) { box = box.clone() }
        box.storage.append(element)
    }

    public mutating func extend<S: Sequence>(_ sequence: S) where S.Element == Element {
        if !isKnownUniquelyReferenced(&box) { box = box.clone() }
        box.storage.append(contentsOf: sequence)
    }

    public var elements: [Element] { box.storage }
}
