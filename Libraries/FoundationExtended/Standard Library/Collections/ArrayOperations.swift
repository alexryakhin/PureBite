public extension Array {

    mutating func append(_ item: Element?) {
        if let item = item {
            append(item)
        }
    }

    mutating func prepend(_ item: Element?) {
        if let item = item {
            append(item)
        }
    }

    /// New array with elements from origin and additional `value` at the end
    func appending(_ value: Element?) -> Array {
        guard let value else { return self }
        return self + [value]
    }

    /// New array with elements from origin and additional `value` at the start
    func prepending(_ value: Element?) -> Array {
        guard let value else { return self }
        return [value] + self
    }

    /// Returns elements, divided in groups by item-delimiter
    /// E.g.: ["Anna", "Andrew", "Paul"].delimited { "–" } => ["Anna", "–", "Andrew", "–", "Paul"]
    func delimited(_ makeDelimiter: (_ idx: Int) -> Element?) -> [Element] {
        guard count > 1 else {
            return self
        }
        return self.dropFirst().enumerated().reduce([self[0]], { (result, item) in
            if let newElement = makeDelimiter(item.offset + 1) {
                return result + [newElement, item.element]
            } else {
                return result + [item.element]
            }
        })
    }

    /// Returns elements, divided in groups by item-delimiter
    func delimited(_ makeDelimiter: () -> Element?) -> [Element] {
        guard count > 1 else {
            return self
        }
        return self.dropFirst().enumerated().reduce([self[0]], { (result, item) in
            if let newElement = makeDelimiter() {
                return result + [newElement, item.element]
            } else {
                return result + [item.element]
            }
        })
    }
}
