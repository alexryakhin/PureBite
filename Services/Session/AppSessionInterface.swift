import Foundation
import Combine

public enum AppSessionEvent {
    case login, logout
}

public protocol AppSessionInterface: AnyObject {

    var tokens: Tokens { get }
    var passwordUpdateToken: String? { get }
    var isLoggedIn: Bool { get }
    var event: PassthroughSubject<AppSessionEvent, Never> { get }

    func reset()
    func fullReset()
    func set(tokens: Tokens)
    func set(passwordUpdateToken: String?)
}
