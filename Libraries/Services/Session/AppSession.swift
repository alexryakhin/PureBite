import Foundation
import Combine

public final class AppSession: SessionAbstract {

    // MARK: - Properties

    public let sessionStorage: SessionStorageAbstract

    public var tokens: Tokens = .initial
    public var passwordUpdateToken: String?

    public var isLoggedIn: Bool { tokens.accessToken.nilIfEmpty != nil }

    public var event = PassthroughSubject<SessionEvent, Never>()

    // MARK: - Init

    public init(
        sessionStorage: SessionStorageAbstract
    ) {
        self.sessionStorage = sessionStorage
        self.tokens = Tokens(
            accessToken: sessionStorage.accessToken ?? "",
            refreshToken: sessionStorage.refreshToken ?? "",
            logoutToken: sessionStorage.logoutToken ?? ""
        )
    }

    // MARK: - Public Methods

    public func reset() {
        flushTokens()
        event.send(.logout)
    }

    public func fullReset() {
        flushTokens()
        sessionStorage.flush()
        event.send(.logout)
    }

    public func resetWithoutTriggeringLogout() {
        flushTokens()
    }

    public func set(tokens: Tokens) {
        self.tokens = tokens
        sessionStorage.accessToken = tokens.accessToken
        sessionStorage.refreshToken = tokens.refreshToken
        event.send(tokens.accessToken.nilIfEmpty == nil ? .logout : .login)
    }

    public func set(passwordUpdateToken: String?) {
        self.passwordUpdateToken = passwordUpdateToken
        sessionStorage.passwordUpdateToken = passwordUpdateToken
    }

    // MARK: - Private Methods

    private func flushTokens() {
        debug("Tokens deleted from Keychain")
        tokens = .initial
        passwordUpdateToken = nil
        sessionStorage.accessToken = nil
        sessionStorage.refreshToken = nil
    }
}
