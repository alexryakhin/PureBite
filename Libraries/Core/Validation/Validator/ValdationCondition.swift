public struct ValidationCondition {
    public let rules: [ValidationRule]

    public init(rules: [ValidationRule]) {
        self.rules = rules
    }

    public static func nonEmpty() -> ValidationCondition {
        return ValidationCondition(rules: [.notEmpty])
    }

    public static func minLength(_ ml: Int) -> ValidationCondition {
        return ValidationCondition(rules: [.minLength(minLen: ml)])
    }

    public static func maxLength(_ ml: Int) -> ValidationCondition {
        return ValidationCondition(rules: [.maxLength(maxLen: ml)])
    }

    public static func mathPattern(_ pattern: String) -> ValidationCondition {
        return ValidationCondition(rules: [.matchPattern(pattern: pattern)])
    }
}
