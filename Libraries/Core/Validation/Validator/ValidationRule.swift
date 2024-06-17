import Foundation

public protocol ValidationRuleAbstract: Error, Hashable {
    var isRegexRule: Bool { get }
    func validate(string: String?) -> Bool
}

public enum ValidationRule: Error, Equatable, Hashable, ValidationRuleAbstract {
    case notEmpty
    case minLength(minLen: Int)
    case maxLength(maxLen: Int)
    case matchPattern(pattern: String)
    // Whole string must match pattern
    case conformPattern(pattern: ValidationPattern)
    case latinic
    case cyrillic
    case digits
    case amount
    case contains(allOf: [String])
    case containsDigit
    case containsUppercaseLetter
    case containsLowercaseLetter
    case charactersOfSet(set: CharacterSet)
    // Date check
    case validShortDate
    case shortDateIsBeforeToday

    public var isRegexRule: Bool {
        switch self {
        case .notEmpty, .maxLength, .minLength, .charactersOfSet, .contains, .validShortDate, .shortDateIsBeforeToday:
            return false
        case .conformPattern, .latinic, .cyrillic, .digits, .amount, .matchPattern, .containsDigit, .containsUppercaseLetter, .containsLowercaseLetter:
            return true
        }
    }

    public static func == (lhs: ValidationRule, rhs: ValidationRule) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    public func validate(string: String?) -> Bool {
        guard let string = string, string.count > .zero else {
            if case .notEmpty = self {
                return false
            } else {
                return true
            }
        }

        switch self {
        case .notEmpty:
            return string.isNotEmpty
        case let .minLength(minLen):
            return string.count >= minLen
        case let .maxLength(maxLen):
            return string.count <= maxLen
        case let .contains(symbols):
            return symbols.allSatisfy { string.contains($0) }

        case let .charactersOfSet(set):
            return string.trimmingCharacters(in: set).count == .zero

        case .validShortDate:
            return DateFormatter().convertStringToDate(string: string, format: .shortDateWithDots) != nil
        case .shortDateIsBeforeToday:
            guard let date = DateFormatter().convertStringToDate(string: string, format: .shortDateWithDots)
            else { return false }
            return date.isEarlier(than: Date.now, granularity: .day)

        case .containsDigit:
            return ValidationRule.matchPattern(pattern: ValidationPattern.digit.part).validate(string: string)
        case .containsUppercaseLetter:
            return ValidationRule.matchPattern(pattern: ValidationPattern.uppercaseDigit.part).validate(string: string)
        case .containsLowercaseLetter:
            return ValidationRule.matchPattern(pattern: ValidationPattern.lowercaseDigit.part).validate(string: string)
        case .latinic:
            return ValidationRule.matchPattern(pattern: ValidationPattern.latinic.full).validate(string: string)
        case .cyrillic:
            return ValidationRule.matchPattern(pattern: ValidationPattern.cyrillic.full).validate(string: string)
        case .digits:
            return ValidationRule.matchPattern(pattern: ValidationPattern.digit.full).validate(string: string)
        case .amount:
            return ValidationRule.matchPattern(pattern: ValidationPattern.amount.full).validate(string: string)
        case let .conformPattern(pattern):
            return string.isMatching(pattern: pattern.full)

        case let .matchPattern(pattern):
            return string.isMatching(pattern: pattern)
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .notEmpty:
            return hasher.combine(0)
        case .minLength:
            return hasher.combine(1)
        case .maxLength:
            return hasher.combine(2)
        case .matchPattern:
            return hasher.combine(3)
        case .conformPattern:
            return hasher.combine(4)
        case .latinic:
            return hasher.combine(5)
        case .cyrillic:
            return hasher.combine(6)
        case .digits:
            return hasher.combine(7)
        case .charactersOfSet:
            return hasher.combine(8)
        case .amount:
            return hasher.combine(9)
        case .contains:
            return hasher.combine(10)
        case .containsDigit:
            return hasher.combine(11)
        case .containsUppercaseLetter:
            return hasher.combine(12)
        case .containsLowercaseLetter:
            return hasher.combine(13)
        case .validShortDate:
            return hasher.combine(14)
        case .shortDateIsBeforeToday:
            return hasher.combine(15)
        }
    }
}
