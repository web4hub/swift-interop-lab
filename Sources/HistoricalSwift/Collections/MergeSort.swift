public enum MergeSort {
    public static func sort<T>(_ input: [T], by areInIncreasingOrder: (T, T) -> Bool) -> [T] {
        guard input.count > 1 else { return input }
        var values = input
        var buffer = values

        func merge(_ low: Int, _ mid: Int, _ high: Int) {
            var left = low
            var right = mid
            var destination = low
            while left < mid && right < high {
                if areInIncreasingOrder(values[right], values[left]) {
                    buffer[destination] = values[right]; right += 1
                } else {
                    buffer[destination] = values[left]; left += 1
                }
                destination += 1
            }
            while left < mid { buffer[destination] = values[left]; left += 1; destination += 1 }
            while right < high { buffer[destination] = values[right]; right += 1; destination += 1 }
            values[low..<high] = buffer[low..<high]
        }

        var width = 1
        while width < values.count {
            var low = 0
            while low < values.count {
                let mid = min(low + width, values.count)
                let high = min(low + width * 2, values.count)
                if mid < high { merge(low, mid, high) }
                low += width * 2
            }
            width *= 2
        }
        return values
    }

    public static func stableSort<T: Comparable>(_ input: [T]) -> [T] {
        sort(input, by: <)
    }
}
