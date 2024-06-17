import Foundation
import Combine

public enum SessionEvent {
    case login, logout
}

public protocol SessionAbstract: AnyObject {

    var tokens: Tokens { get }
    var passwordUpdateToken: String? { get }
    var isLoggedIn: Bool { get }
    var event: PassthroughSubject<SessionEvent, Never> { get }

    func reset()
    func fullReset()
    func set(tokens: Tokens)
    func set(passwordUpdateToken: String?)
}
