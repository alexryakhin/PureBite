import Foundation

public enum PasswordValidationState {
    case pending
    case ok
    case error

    public static func validatePasswordLength(_ password: String, currentState: Self) -> Self {
        guard password.count < 8 || password.count > 16 else { return Self.ok }
        return currentState == Self.pending ? Self.pending : Self.error
    }

    public static func validatePasswordVariety(_ password: String, currentState: Self) -> Self {
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        let isUppercaseContained = uppercasePredicate.evaluate(with: password)

        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        let isLowercaseContained = lowercasePredicate.evaluate(with: password)

        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        let isNumberContained = numberPredicate.evaluate(with: password)

        if isUppercaseContained && isLowercaseContained && isNumberContained { return Self.ok }
        return currentState == Self.pending ? Self.pending : Self.error
    }

    public static func validatePasswordSpecialSymbol(_ password: String, currentState: Self) -> Self {
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[.?!,:;\\-()'\\/]+.*")
        let isSpecialCharacterContained = specialCharacterPredicate.evaluate(with: password)

        if isSpecialCharacterContained { return Self.ok }
        return currentState == Self.pending ? Self.pending : Self.error
    }

    public static func validatePasswordEquality(_ password: String, confirmPassword: String, currentState: Self) -> Self {
        if password == confirmPassword && !password.isEmpty { return Self.ok }
        return currentState == Self.pending ? Self.pending : Self.error
    }
}
