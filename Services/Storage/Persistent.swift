//
//  Persistent.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/2/24.
//
import Combine

public enum Property {
    case environment(AppEnvironment)
    case fcmToken(String)
    case lastUsedAppVersion(String)
    case isOnboardingAlreadyShown(Bool)
}

public enum PropertyKey {
    static let environment = "Environment"
    static let fcmToken = "FcmToken"
    static let lastUsedAppVersion = "LastUsedAppVersion"
    static let isOnboardingAlreadyShown = "IsOnboardingAlreadyShown"
}

public protocol Persistent: AnyObject {

    func set(_ property: Property)

    var keychainStorage: KeychainStorageInterface { get }
    var sessionStorage: AppSessionStorageInterface { get }

    var environment: AppEnvironment { get }
    var fcmToken: String? { get }

    // Auth Properties
    var lastUsedAppVersion: String? { get }
    var isFirstLaunch: Bool { get }
    var isOnboardingFlowShown: Bool { get }
}

public final class PersistentLayer: Persistent {

    public let keychainStorage: KeychainStorageInterface
    public let sessionStorage: AppSessionStorageInterface

    public var environment: AppEnvironment
    public var fcmToken: String?

    public var lastUsedAppVersion: String?

    // Auth Properties
    public var isFirstLaunch: Bool { lastUsedAppVersion == nil }
    public var isOnboardingFlowShown: Bool

    let userDefaultsStorage: UserDefaultsServiceInterface

    public init() {
        keychainStorage = KeychainStorage()
        userDefaultsStorage = UserDefaultsService()
        sessionStorage = AppSessionStorage(keychainStorage: keychainStorage)

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
        }
    }
}
