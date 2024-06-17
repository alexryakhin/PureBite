public extension StringProtocol {

    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }

    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }

    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }

    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return self[index(startIndex, offsetBy: range.lowerBound)...]
    }

    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return self[...index(startIndex, offsetBy: range.upperBound)]
    }

    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return self[..<index(startIndex, offsetBy: range.upperBound)]
    }
}
