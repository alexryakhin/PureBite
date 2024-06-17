import Foundation

public enum DefaultValidations {

    public enum Integer {

        public enum CheckResult {
            case validInput(Int)
            case invalidInput
            case empty
            case tooManyCharacters
            case zeroNumber
            case tooBigNumber(Int)
        }

        public static func validate(
            text: String?,
            maxCharactersCount: Int = 15,
            maxValue: Int? = nil
        ) -> CheckResult {
            guard let text = text?.trimmed.nilIfEmpty else {
                return .empty
            }

            guard !text.contains(where: { !$0.isNumber }) else {
                return .invalidInput
            }

            if text.count > maxCharactersCount {
                return .tooManyCharacters
            }

            guard let number = DefaultParsers.Number.number(text)?.int else {
                return .invalidInput
            }

            if number == 0 {
                return .zeroNumber
            }

            if let maxValue = maxValue, number > maxValue {
                return .tooBigNumber(number)
            }

            return .validInput(number)
        }
    }

    public enum Price {

        public enum CheckResult {
            case validInput(Decimal)
            case invalidInput
            case empty
            case tooManyCharacters
            case separator
            case firstCharacterSeparator
            case lastCharacterSeparator
            case invalidStep
            case tooManyFractions
            case zeroNumber
            case tooBigNumber(Decimal)
        }

        public static func validate(
            text: String?,
            maxWholePartCount: Int = 9,
            maxFractionalDigits: Int? = nil,
            priceStep: Double? = nil,
            maxValue: Decimal? = nil
        ) -> CheckResult {
            guard let text = text?.trimmed.nilIfEmpty else {
                return .empty
            }

            let separator = Locale.current.decimalSeparator

            if let separator = separator {
                if text == separator {
                    return .separator
                }

                if text.count > 1,
                   let firstChar = text.first,
                   String(firstChar) == separator {

                    let otherText = String(text.dropFirst())
                    if DefaultParsers.Number.isNumber(otherText) {
                        return .firstCharacterSeparator
                    } else {
                        return .invalidInput
                    }
                }

                if text.count > 1,
                   let lastChar = text.last,
                   String(lastChar) == separator {

                    if text.indicesOf(string: separator).count == 1 {
                        return validate(
                            text: String(text.dropLast()),
                            maxWholePartCount: maxWholePartCount,
                            maxFractionalDigits: maxFractionalDigits,
                            priceStep: priceStep,
                            maxValue: maxValue
                        )
                    } else {
                        return .invalidInput
                    }
                }
            }

            guard let number = DefaultParsers.Number.number(text) else {
                return .invalidInput
            }

            if let maxFractionalDigits = maxFractionalDigits,
               let separator = separator,
               let lastSeparatorIndex = text.indicesOf(string: separator).last,
               lastSeparatorIndex != (text.count - 1) {
                let charactersBeforeSeparator = lastSeparatorIndex + 1
                if charactersBeforeSeparator > maxWholePartCount {
                    return .tooManyCharacters
                }
                let charactersAfterSeparator = text.count - lastSeparatorIndex - 1
                if charactersAfterSeparator > maxFractionalDigits {
                    return .tooManyFractions
                }
            } else if text.count > maxWholePartCount {
                return .tooManyCharacters
            }

            if number.isZero {
                return .zeroNumber
            }

            if let maxValue = maxValue, number > maxValue {
                return .tooBigNumber(number)
            }

            if let priceStep = priceStep {
                var left = number
                var right = Decimal(priceStep)
                var result = Decimal()
                NSDecimalDivide(&result, &left, &right, .down)

                if !result.fraction.isZero {
                    return .invalidStep
                }
            }

            return .validInput(number)
        }
    }
}
