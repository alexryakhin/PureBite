import UIKit

extension DefaultErrorProps {

    static func common(message: String?, action: @escaping VoidHandler) -> Self {
        DefaultErrorProps(
            title: "Error Title",
            message: message ?? "Error Message",
            image: UIImage(systemName: "exclamationpoint"),
            actionProps: .init(title: "Title", action: action)
        )
    }

    static func timeout(action: @escaping VoidHandler) -> Self {
        DefaultErrorProps(
            title: "Timeout",
            message: "Error Message",
            image: UIImage(systemName: "exclamationpoint"),
            actionProps: .init(title: "Title", action: action)
        )
    }

    static func networkFailure(action: @escaping VoidHandler) -> Self {
        DefaultErrorProps(
            title: "Network failure",
            message: "Error Message",
            image: UIImage(systemName: "exclamationpoint"),
            actionProps: .init(title: "Title", action: action)
        )
    }

    static func underDevelopment() -> Self {
        DefaultErrorProps(
            title: "Under Development",
            message: "Under Development",
            image: UIImage(systemName: "exclamationpoint")
        )
    }
}
