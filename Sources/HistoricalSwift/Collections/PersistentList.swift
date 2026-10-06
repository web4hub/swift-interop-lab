public indirect enum PersistentList<Element> {
    case empty
    case node(Element, PersistentList<Element>)

    public func push(_ element: Element) -> PersistentList<Element> { .node(element, self) }

    public func pop() -> (Element, PersistentList<Element>)? {
        guard case let .node(element, rest) = self else { return nil }
        return (element, rest)
    }

    public var count: Int {
        switch self {
        case .empty: return 0
        case let .node(_, rest): return 1 + rest.count
        }
    }
}
