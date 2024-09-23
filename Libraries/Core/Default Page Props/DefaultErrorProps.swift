import Foundation
import UIKit

public struct DefaultErrorProps: Hashable {

    public struct ActionControlProps {

        public let title: String
        public let action: VoidHandler

        public init(title: String, action: @escaping VoidHandler) {
            self.title = title
            self.action = action
        }
    }

    public let title: String
    public let message: String
    public let image: UIImage?
    public let actionProps: ActionControlProps?

    public init(
        title: String,
        message: String,
        image: UIImage?,
        actionProps: ActionControlProps? = nil
    ) {
        self.title = title
        self.message = message
        self.image = image
        self.actionProps = actionProps
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(message)
        hasher.combine(image)
        if let actionProps {
            hasher.combine(actionProps.title)
        }
    }

    public static func == (lhs: DefaultErrorProps, rhs: DefaultErrorProps) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
