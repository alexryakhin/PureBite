import Foundation

public struct ValidationPattern {

    public static let latinic: ValidationPattern = ValidationPattern(subset: "a-zA-Z")
    public static let cyrillic: ValidationPattern = ValidationPattern(subset: "а-яА-ЯёЁ")
    public static let uppercaseDigit: ValidationPattern = ValidationPattern(subset: "A-ZА-ЯЁ")
    public static let lowercaseDigit: ValidationPattern = ValidationPattern(subset: "a-zа-яё")
    public static let digit: ValidationPattern = ValidationPattern(part: "\\d")
    public static let latinicEssay: ValidationPattern = ValidationPattern(
        subsetFrom: [.latinic, .digits],
        rawSubpatterns: [" "]
    )
    public static let cyrillicEssay: ValidationPattern = ValidationPattern(
        subsetFrom: [.cyrillic, .digits],
        rawSubpatterns: [" "]
    )
    public static let essay: ValidationPattern = ValidationPattern(
        subsetFrom: [.latinic, .cyrillic, .digits],
        rawSubpatterns: [" "]
    )
    public static let latinicAndCyrillic: ValidationPattern = ValidationPattern(subsetFrom: [.cyrillic, .latinic])
    public static let latinicOrCyrillic: ValidationPattern = ValidationPattern(
        part: "\(ValidationPattern.latinic.part)|\(ValidationPattern.cyrillic.part)"
    )
    public static let latinicOrCyrillicWithWhitespaces: ValidationPattern = ValidationPattern(
        subsetFrom: [.latinic, .cyrillic],
        rawSubpatterns: [" "]
    )
    public static let password: ValidationPattern = ValidationPattern(subset: "a-zA-Z0-9\\-/\\*\\+!")
    public static let amount: ValidationPattern = ValidationPattern(full: "^(?!(0))[0-9]{1,11}[.|,]{0,1}[0-9]{0,2}$")
    public static let birthDate: ValidationPattern = ValidationPattern(full: "\\d{2}\\.\\d{2}\\.\\d{4}")

    let part: String
    let full: String

    /// - Parameter part: regex to verify
    public init(part: String) {
        self.part = part
        full = "^\(part)*$"
    }

    /// - Parameter subset: charachter class
    public init(subset: String) {
        part = "[\(subset)]"
        full = "^[\(part)]*$"
    }

    public init(part: String, full: String) {
        self.part = part
        self.full = full
    }

    init(full: String) {
        self.part = full
        self.full = full
    }

    // swiftlint:disable:next cyclomatic_complexity
    public init(subsetFrom rules: [ValidationRule], rawSubpatterns: [String] = []) {
        guard !rules.isEmpty else {
            full = ".*"
            part = ".*"
            return
        }
        var pattern = "^["
        var count: Int = 0
        for rule in rules {
            if count > .zero {
                pattern.append("|")
            }
            switch rule {
            case .notEmpty,
                 .minLength,
                 .maxLength,
                 .charactersOfSet,
                 .contains,
                 .validShortDate,
                 .shortDateIsBeforeToday:
                continue
            case let .matchPattern(subpattern):
                pattern.append(subpattern)
            case .latinic:
                pattern.append(ValidationPattern.latinic.part)
            case .cyrillic:
                pattern.append(ValidationPattern.cyrillic.part)
            case .digits:
                pattern.append(ValidationPattern.digit.part)
            case .amount:
                pattern.append(ValidationPattern.amount.part)
            case let .conformPattern(subpattern):
                pattern.append(subpattern.part)
            case .containsDigit:
                pattern.append(ValidationPattern.digit.part)
            case .containsUppercaseLetter:
                pattern.append(ValidationPattern.uppercaseDigit.part)
            case .containsLowercaseLetter:
                pattern.append(ValidationPattern.lowercaseDigit.part)
            }
            count += 1
        }
        for subpattern in rawSubpatterns {
            if count > .zero {
                pattern.append("|")
            }
            pattern.append(subpattern)
            count += 1
        }
        pattern.append("]*$")
        full = pattern
        part = pattern
    }

    /// Combined regex with regexes from rules, including addition into each pattern
    init(subsetFrom rules: [ValidationRule], withAddition addition: String) { // swiftlint:disable:this cyclomatic_complexity
        guard !rules.isEmpty else {
            full = ".*"
            part = ".*"
            return
        }
        var pattern = "^["
        var count = 0
        for rule in rules {
            if count > .zero {
                pattern.append("|")
            }
            switch rule {
            case .notEmpty,
                 .minLength,
                 .maxLength,
                 .charactersOfSet,
                 .contains,
                 .validShortDate,
                 .shortDateIsBeforeToday:
                continue
            case let .matchPattern(subpattern):
                pattern.append(subpattern)
            case .latinic:
                pattern.append(ValidationPattern.latinic.part)
            case .cyrillic:
                pattern.append(ValidationPattern.cyrillic.part)
            case .digits:
                pattern.append(ValidationPattern.digit.part)
            case .amount:
                pattern.append(ValidationPattern.amount.part)
            case .containsDigit:
                pattern.append(ValidationPattern.digit.part)
            case .containsUppercaseLetter:
                pattern.append(ValidationPattern.uppercaseDigit.part)
            case .containsLowercaseLetter:
                pattern.append(ValidationPattern.lowercaseDigit.part)

            case let .conformPattern(subpattern):
                pattern.append(subpattern.part)
            }
            pattern.append(addition)
            count += 1
        }
        pattern.append("]*$")
        full = pattern
        part = pattern
    }
}
