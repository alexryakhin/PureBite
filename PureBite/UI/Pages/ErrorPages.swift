public enum ErrorDisplayType {
    /// Error should be displayed as a state of the page
    case page
    /// Error should be displayed as a snackbar
    case snack
    /// Error should not be displayed
    case none
}

public protocol ErrorHandler {

    var snacksDisplay: SnacksDisplayInterface? { get set }

    func errorReceived(_ error: Error, contentPreserved: Bool)
    func errorReceived(_ error: DefaultError, contentPreserved: Bool)
}

public extension DefaultErrorProps {

    static func common(message: String?, action: @escaping VoidHandler) -> Self {
        DefaultErrorProps(
            title: "Common.Error.defaultTitle",
            message: message ?? "Common.Error.defaultMessage",
            actionProps: .init(title: "Common.Error.retryOneMoreTime", action: action)
        )
    }

    static func timeout(action: @escaping VoidHandler) -> Self {
        DefaultErrorProps(
            title: "Common.Error.defaultTitle",
            message: "Common.Error.defaultMessage",
            actionProps: .init(title: "Common.Error.retryOneMoreTime", action: action)
        )
    }

    static func networkFailure(action: @escaping VoidHandler) -> Self {
        DefaultErrorProps(
            title: "Common.Error.NoInternet.title",
            message: "Common.Error.NoInternet.message",
            actionProps: .init(title: "Common.Error.retryOneMoreTime", action: action)
        )
    }
}
