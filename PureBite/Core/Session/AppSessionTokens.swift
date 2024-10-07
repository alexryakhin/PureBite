import Combine
import Foundation

public struct Tokens {

    public let accessToken: String
    public let refreshToken: String
    public let logoutToken: String

    public init(
        accessToken: String = .empty,
        refreshToken: String = .empty,
        logoutToken: String = .empty
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.logoutToken = logoutToken
    }
}
