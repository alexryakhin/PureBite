import Foundation

public enum Property {

    case environment(AppEnvironment)
    case fcmToken(String)

    case lastUsedAppVersion(String)
    case isOnboardingAlreadyShown(Bool)

    case isPushNotificationsEnabled(Bool)
    case isNewsletterEnabled(Bool)
}

enum PropertyKey {

    static let environment = "Environment"
    static let fcmToken = "FcmToken"
    static let lastUsedAppVersion = "LastUsedAppVersion"
    static let isOnboardingAlreadyShown = "IsOnboardingAlreadyShown"
    static let isPushNotificationsEnabled = "IsPushNotificationsEnabled"
    static let isNewsletterEnabled = "IsNewsletterEnabled"
}
