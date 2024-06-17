import Combine

public enum InputFilterStrategy {

    public enum HintMessage {
        case none
        case normal(String)
        case dynamic(AnyPublisher<String, Never>)
    }

    case disallowInput(HintMessage)
    case allowInvalidInput(HintMessage)
    case allowValidInput
    case allowWithReplace(String)
}
