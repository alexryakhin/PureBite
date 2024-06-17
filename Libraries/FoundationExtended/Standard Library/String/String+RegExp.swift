import Foundation

public extension String {

    func isMatching(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: NSRegularExpression.Options()
            )
            let matchCounts = regex.numberOfMatches(
                in: self,
                options: NSRegularExpression.MatchingOptions(),
                range: NSRange(
                    location: 0,
                    length: count
                )
            )
            return matchCounts > 0
        } catch {
            return false
        }
    }
}
