public enum BinarySearch {
    public static func firstIndex<C: RandomAccessCollection>(
        of value: C.Element,
        in collection: C,
        by areInIncreasingOrder: (C.Element, C.Element) -> Bool
    ) -> C.Index? {
        var low = collection.startIndex
        var high = collection.endIndex
        while low < high {
            let distance = collection.distance(from: low, to: high)
            let mid = collection.index(low, offsetBy: distance / 2)
            if areInIncreasingOrder(collection[mid], value) {
                low = collection.index(after: mid)
            } else {
                high = mid
            }
        }
        guard low != collection.endIndex,
              !areInIncreasingOrder(value, collection[low]) else { return nil }
        return low
    }
}
