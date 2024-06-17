public protocol CoreValidatorAbstract: AnyObject {

    func validateEmail(_ text: String?) -> StringValidationResult
    func validatePassword(_ text: String?) -> StringValidationResult
    func validateName(_ text: String?) -> StringValidationResult
}

public final class CoreValidator: CoreValidatorAbstract {

    public static var shared = CoreValidator()

    private init() { }

    public func validateEmail(_ text: String?) -> StringValidationResult {
        let validator = Validator(
            rules: [.notEmpty, .contains(allOf: ["@"])]
        )

        return validator.validate(text)
    }

    public func validatePassword(_ text: String?) -> StringValidationResult {
        let validator = Validator(
            rules: [
                .notEmpty,
                .minLength(minLen: 8),
                .containsDigit,
                .containsLowercaseLetter,
                .containsUppercaseLetter
            ]
        )

        return validator.validate(text)
    }

    public func validateName(_ text: String?) -> StringValidationResult {
        let validator = Validator(rules: [
            .notEmpty,
            .minLength(minLen: 2),
            .maxLength(maxLen: 25),
            .conformPattern(pattern: .latinicOrCyrillicWithWhitespaces)
        ])
        return validator.validate(text)
    }
}
