// TODO: - Check CoreNavigation deeplinkAbstract, for now causing linker error
public protocol DeepLinkAbstract {
}

public enum DeepLink: DeepLinkAbstract, Equatable {

    // MARK: - Types

    enum DeepLinkError: Error {
        case invalidParams
    }

    enum Endpoint: CaseIterable {
        case resetPassword

        var endpoint: String {
            switch self {
            case .resetPassword:
                return "password-reset/new"
            }
        }
    }

    // MARK: - Cases

    case resetPassword(token: String)
    case editProfile
    case signInFromProfile

    case applicationStatus(id: String)

    // MARK: - Public Methods

    static func getDeepLink(from endpoint: Endpoint, with params: [String: String]?) throws -> DeepLink {
        switch endpoint {
        case .resetPassword:
            guard let tokenParam = params?.first,
                  tokenParam.key == "token",
                  tokenParam.value.isNotEmpty
            else { throw DeepLinkError.invalidParams }
            return .resetPassword(token: tokenParam.value)
        }
    }
}
