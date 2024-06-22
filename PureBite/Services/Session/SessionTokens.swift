import Combine
import Foundation

public struct Tokens {

    public let accessToken: String
    public let refreshToken: String
    public let logoutToken: String

    public init(accessToken: String, refreshToken: String, logoutToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.logoutToken = logoutToken
    }

    static let initial = Tokens(accessToken: "", refreshToken: "", logoutToken: "")
}
