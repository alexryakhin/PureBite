import Foundation

public enum Property {

    case environment(AppEnvironment)
    case fcmToken(String)

    case lastUsedAppVersion(String)
    case isOnboardingAlreadyShown(Bool)
}

enum PropertyKey {

    static let environment = "Environment"
    static let fcmToken = "FcmToken"
    static let lastUsedAppVersion = "LastUsedAppVersion"
    static let isOnboardingAlreadyShown = "IsOnboardingAlreadyShown"
}
