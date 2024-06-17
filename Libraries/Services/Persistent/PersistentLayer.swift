import Combine

public protocol Persistent: AnyObject {

    func set(_ property: Property)

    var keychainStorage: KeychainStorage { get }
    var sessionStorage: SessionStorageAbstract { get }

    var environment: AppEnvironment { get }
    var fcmToken: String? { get }

    // Auth Properties
    var lastUsedAppVersion: String? { get }
    var isFirstLaunch: Bool { get }
    var isOnboardingFlowShown: Bool { get }

    // Notifications
    var isPushNotificationsEnabled: Bool { get }
    var isNewsletterEnabled: Bool { get }
}

public final class PersistentLayer: Persistent {

    public let keychainStorage: KeychainStorage
    public let sessionStorage: SessionStorageAbstract

    public var environment: AppEnvironment
    public var fcmToken: String?

    public var lastUsedAppVersion: String?

    // Auth Properties
    public var isFirstLaunch: Bool { lastUsedAppVersion == nil }
    public var isOnboardingFlowShown: Bool

    // Notifications
    public var isPushNotificationsEnabled: Bool
    public var isNewsletterEnabled: Bool

    let userDefaultsStorage: UserDefaults

    public init() {
        keychainStorage = KeychainStorage()
        userDefaultsStorage = UserDefaultsService()
        sessionStorage = SessionStorage(keychainStorage: keychainStorage)

        if
            let environmentName = userDefaultsStorage.loadString(forKey: PropertyKey.environment),
            let savedEnvironment = AppEnvironment.named(environmentName) {
            environment = savedEnvironment
        } else {
            #if DEBUG
            environment = AppEnvironment.debug
            #else
            environment = AppEnvironment.release
            #endif
        }

        fcmToken = userDefaultsStorage.loadString(forKey: PropertyKey.fcmToken)
        lastUsedAppVersion = userDefaultsStorage.loadString(forKey: PropertyKey.lastUsedAppVersion)
        isOnboardingFlowShown = userDefaultsStorage.loadBool(forKey: PropertyKey.isOnboardingAlreadyShown)
        isPushNotificationsEnabled = userDefaultsStorage.loadBool(forKey: PropertyKey.isPushNotificationsEnabled)
        isNewsletterEnabled = userDefaultsStorage.loadBool(forKey: PropertyKey.isNewsletterEnabled)
    }

    public func set(_ property: Property) {
        switch property {
        case .environment(let environment):
            self.environment = environment
            userDefaultsStorage.save(string: environment.name, forKey: PropertyKey.environment)
        case .fcmToken(let fcmToken):
            self.fcmToken = fcmToken
            userDefaultsStorage.save(string: fcmToken, forKey: PropertyKey.fcmToken)
        case .isOnboardingAlreadyShown(let isShown):
            isOnboardingFlowShown = isShown
            userDefaultsStorage.save(bool: isShown, forKey: PropertyKey.isOnboardingAlreadyShown)
        case .lastUsedAppVersion(let version):
            lastUsedAppVersion = version
            userDefaultsStorage.save(string: version, forKey: PropertyKey.lastUsedAppVersion)
        case .isPushNotificationsEnabled(let isEnabled):
            isPushNotificationsEnabled = isEnabled
            userDefaultsStorage.save(bool: isEnabled, forKey: PropertyKey.isPushNotificationsEnabled)
        case .isNewsletterEnabled(let isEnabled):
            isNewsletterEnabled = isEnabled
            userDefaultsStorage.save(bool: isEnabled, forKey: PropertyKey.isNewsletterEnabled)
        }
    }
}
