import Foundation

public enum DefaultParsers {

    public enum Number {

        public static func isNumber(_ text: String) -> Bool {
            return number(text) != nil
        }

        public static func number(_ text: String) -> Decimal? {
            let whitespaces = CharacterSet.whitespacesAndNewlines
            let components = text.components(separatedBy: whitespaces)
            let clearedText = components.joined(separator: "")

            let decimalNumber = NSDecimalNumber(string: clearedText.normalizedDecimalSeparator, locale: Locale.current).decimalValue
            guard decimalNumber.isNormal || decimalNumber.isZero else {
                return nil
            }

            return decimalNumber
        }
    }
}

public extension String {

    var normalizedDecimalSeparator: String {
        guard let decimalSeparator = Locale.current.decimalSeparator else {
            return self
        }
        let separators = [",", "."]
        var result = self
        for separator in separators where separator != decimalSeparator {
            result = result.replacingOccurrences(of: separator, with: decimalSeparator)
        }
        return result
    }

    var formattedNumber: String {
        self.filter { $0.isNumber }
    }
}
