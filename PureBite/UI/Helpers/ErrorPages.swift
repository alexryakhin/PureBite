import UIKit

extension DefaultErrorProps {

    static func common(message: String?, action: @escaping VoidHandler) -> Self {
        DefaultErrorProps(
            title: "Ooops... Something went wrong",
            message: message ?? "Please try again later",
            image: UIImage(systemName: "exclamationmark.circle.fill"),
            actionProps: .init(title: "Try again", action: action)
        )
    }

    static func timeout(action: @escaping VoidHandler) -> Self {
        DefaultErrorProps(
            title: "Timeout",
            message: "Please try again later",
            image: UIImage(systemName: "clock.badge.exclamationmark.fill"),
            actionProps: .init(title: "Try again", action: action)
        )
    }

    static func networkFailure(action: @escaping VoidHandler) -> Self {
        DefaultErrorProps(
            title: "Network failure",
            message: "Error Message",
            image: UIImage(systemName: "exclamationmark.icloud.fill"),
            actionProps: .init(title: "Try again", action: action)
        )
    }

    static func underDevelopment() -> Self {
        DefaultErrorProps(
            title: "Under Development",
            message: "Under Development",
            image: UIImage(systemName: "wrench.adjustable.fill")
        )
    }
}
