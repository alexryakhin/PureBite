//
//  DefaultErrorProps.swift
//  Suint One
//
//  Created by Aleksandr Riakhin on 9/30/24.
//

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

public extension DefaultErrorProps {

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