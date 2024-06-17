public extension String {
    var isNotEmpty: Bool { !isEmpty }
    var nilIfEmpty: String? { isNotEmpty ? self : nil }
}

public extension Optional where Wrapped == String {
    var orEmpty: String { self ?? "" }
    var isEmpty: Bool { self?.isEmpty ?? true }
}

public extension String {

    static let empty = ""

    func first(_ k: Int) -> String? {
        String(prefix(k))
    }

    func last(_ k: Int) -> String? {
        String(suffix(k))
    }
}

public extension String {
    
    func indicesOf(string: String) -> [Int] {
        // Converting to an array of utf8 characters makes indexing and comparing a lot easier
        let search = self.utf8.map { $0 }
        let word = string.utf8.map { $0 }

        var indices = [Int]()

        // m - the beginning of the current match in the search string
        // i - the position of the current character in the string we're trying to match
        var m = 0, i = 0
        while m + i < search.count {
            if word[i] == search[m + i] {
                if i == word.count - 1 {
                    indices.append(m)
                    m += i + 1
                    i = 0
                } else {
                    i += 1
                }
            } else {
                m += 1
                i = 0
            }
        }

        return indices
    }
}
