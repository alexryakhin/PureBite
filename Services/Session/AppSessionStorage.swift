import Foundation

public protocol AppSessionStorageInterface: AnyObject {

    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var logoutToken: String? { get set }
    var passwordUpdateToken: String? { get set }
    var pin: String? { get set }
    var biometricAuthEnabled: Bool? { get set }

    func flush()
}

public final class AppSessionStorage: AppSessionStorageInterface {

    private let keychainStorage: KeychainStorageInterface

    public init(keychainStorage: KeychainStorageInterface) {
        self.keychainStorage = keychainStorage
    }

    public var accessToken: String? {
        get { return keychainStorage.value(forKey: .accessToken) }
        set { keychainStorage.set(value: newValue, withKey: .accessToken) }
    }

    public var refreshToken: String? {
        get { return keychainStorage.value(forKey: .refreshToken) }
        set { keychainStorage.set(value: newValue, withKey: .refreshToken) }
    }

    public var logoutToken: String? {
        get { return keychainStorage.value(forKey: .logoutToken) }
        set { keychainStorage.set(value: newValue, withKey: .logoutToken) }
    }

    public var passwordUpdateToken: String? {
        get { return keychainStorage.value(forKey: .passwordUpdateToken) }
        set { keychainStorage.set(value: newValue, withKey: .passwordUpdateToken) }
    }

    public var pin: String? {
        get { return keychainStorage.value(forKey: .pin) }
        set { keychainStorage.set(value: newValue, withKey: .pin) }
    }

    public var biometricAuthEnabled: Bool? {
        get { return keychainStorage.value(forKey: .biometricAuthEnabled) }
        set { keychainStorage.set(value: newValue, withKey: .biometricAuthEnabled) }
    }

    public func flush() {
        keychainStorage.flushStorage()
        debug("Keychain cleared")
    }
}
