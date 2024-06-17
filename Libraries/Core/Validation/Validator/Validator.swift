import Foundation

public enum StringValidationResult {
    case valid
    case invalid(failedCondition: ValidationCondition, firstFailedRule: ValidationRule)

    public var isValid: Bool {
        if case .valid = self { return true }
        return false
    }
}

public protocol ValidatorAbstract {
    func validate(_ string: String?) -> StringValidationResult
}

public struct Validator: ValidatorAbstract {
    public let validationCondition: ValidationCondition

    /// Creates string validator with condition
    /// - Parameters:
    ///   - validationCondition: condition to verify
    ///   - isNecessary: append .notEmpty rule if validationCondition rules dont contain it
    public init(validationCondition: ValidationCondition = ValidationCondition.nonEmpty(),
                isNecessary: Bool = true) {
        if isNecessary {
            var rules = validationCondition.rules
            if !rules.contains(.notEmpty) {
                rules.prepend(.notEmpty)
            }
            self.validationCondition = ValidationCondition(rules: rules)
        } else {
            self.validationCondition = validationCondition
        }
    }

    /// Creates string validator with rules
    /// - Parameters:
    ///   - rules: rules to verify
    ///   - isNecessary: append .notEmpty rule if _rules_ dont contain it
    /// - Warning: Regex rules are not compatible! Use _combinedPatternRules_ constructor if needed
    public init(rules: [ValidationRule],
                isNecessary: Bool = true) {
        self.init(validationCondition: ValidationCondition(rules: rules),
                  isNecessary: isNecessary)
    }

    /// Creates string validator with rules
    /// - Parameters:
    ///   - isNecessary: append .notEmpty rule if _validationCondition rules_ dont contain it
    public init(rule: ValidationRule,
                isNecessary: Bool = true) {
        self.init(validationCondition: ValidationCondition(rules: [rule]),
                  isNecessary: isNecessary)
    }

    /// Creates string validator. Disjunctively merge regex-rules into one and verify it along with non-regex rules
    /// - Parameters:
    ///   - combinedPatternRules: rules for merging
    ///   - isNecessary: append .notEmpty rule if combinedPatternRules dont contain it
    ///   - subsetString: allow other characters from string
    /// - Important: Dont forget escape special characters!
    public init(combinedPatternRules: [ValidationRule],
                isNecessary: Bool = true,
                withAllowedCharacters subsetString: String) {
        let regexRules: [ValidationRule] = combinedPatternRules.filter({ $0.isRegexRule })
        if regexRules.isEmpty {
            self.init(rules: combinedPatternRules, isNecessary: isNecessary)
        }

        let nonRegexRules: [ValidationRule] = combinedPatternRules.filter({ !$0.isRegexRule })
        let pattern: ValidationPattern = ValidationPattern(
            subsetFrom: regexRules,
            rawSubpatterns: [subsetString]
        )
        let rules: [ValidationRule] = nonRegexRules.appending(ValidationRule.conformPattern(pattern: pattern))
        self.init(rules: rules,
                  isNecessary: isNecessary)
    }

    public func validate(_ string: String?) -> StringValidationResult {
        for rule in validationCondition.rules where !rule.validate(string: string) {
            return StringValidationResult.invalid(
                failedCondition: validationCondition,
                firstFailedRule: rule
            )
        }
        return .valid
    }

    public func rules() -> [ValidationRule] {
        return validationCondition.rules
    }
}

public struct ValidAlwaysValidator: ValidatorAbstract {

    public func validate(_ string: String?) -> StringValidationResult {
        return .valid
    }

    public init() { }
}

public struct NonNilValidator: ValidatorAbstract {

    public func validate(_ string: String?) -> StringValidationResult {
        return string == nil ? .invalid(failedCondition: .nonEmpty(), firstFailedRule: .notEmpty) : .valid
    }

    public init() { }
}

public struct ValidatorProxy: ValidatorAbstract {

    public typealias FieldKey = String
    public typealias ValidatingClosure = ((FieldKey, String?) -> StringValidationResult)

    private let fieldKey: FieldKey
    private let validatingClosure: ValidatingClosure

    public func validate(_ string: String?) -> StringValidationResult {
        return validatingClosure(fieldKey, string)
    }

    public init(validatingClosure: @escaping ValidatingClosure, fieldKey: FieldKey) {
        self.validatingClosure = validatingClosure
        self.fieldKey = fieldKey
    }
}
