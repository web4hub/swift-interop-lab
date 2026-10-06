public struct TaggedListIndex: Comparable, Hashable, Sendable {
    public let tag: Int
    public init(_ tag: Int) { self.tag = tag }
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.tag < rhs.tag }
}

public struct TaggedList<Element>: RandomAccessCollection {
    public typealias Index = TaggedListIndex
    private var storage: [Element]

    public init(_ elements: [Element] = []) { storage = elements }
    public var startIndex: Index { .init(0) }
    public var endIndex: Index { .init(storage.count) }
    public var count: Int { storage.count }
    public subscript(position: Index) -> Element { storage[position.tag] }
    public func index(after i: Index) -> Index { .init(i.tag + 1) }
    public func index(before i: Index) -> Index { .init(i.tag - 1) }
    public func index(_ i: Index, offsetBy distance: Int) -> Index { .init(i.tag + distance) }
    public func distance(from start: Index, to end: Index) -> Int { end.tag - start.tag }
}
