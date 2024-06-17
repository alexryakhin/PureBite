import Foundation
import KeychainAccess

public protocol KeychainStorageAbstract: AnyObject {

    func contains(valueForKey key: KeychainStorage.Key) -> Bool
    func value<Type>(forKey key: KeychainStorage.Key) -> Type?
    func set(value: Any?, withKey key: KeychainStorage.Key)
    func delete(valueWithKey key: KeychainStorage.Key)

    func flushStorage()
}

// MARK: - KeychainStorage

public final class KeychainStorage: KeychainStorageAbstract {

    public enum Key: String {
        case login
        case clientId
        case accessToken
        case refreshToken
        case logoutToken
        case passwordUpdateToken
        case deviceId
        case pin
        case biometricAuthEnabled
    }

    // MARK: - Properties

    private let keychain: Keychain

    // MARK: - Init

    public init() {
        guard let service = Bundle.main.infoDictionary?[String(kCFBundleIdentifierKey)] as? String else {
            fatalError("Failed to resolve bundle identifier from .plist dict")
        }

        keychain = Keychain(service: service).accessibility(.afterFirstUnlock)
    }

    // MARK: - Public Methods

    public func contains(valueForKey key: KeychainStorage.Key) -> Bool {
        let keyName = key.rawValue
        do {
            if
                let data = try keychain.getData(keyName),
                let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any]
            {
                return dictionary[keyName] != nil
            }
        } catch {
            fault(error.localizedDescription)
            assertionFailure(error.localizedDescription)
        }
        return false
    }

    public func value<Type>(forKey key: KeychainStorage.Key) -> Type? {
        let keyName = key.rawValue
        do {
            if
                let data = try keychain.getData(keyName),
                let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any],
                let value = dictionary[keyName] as? Type {
                return value
            }
        } catch {
            fault(error.localizedDescription)
            assertionFailure(error.localizedDescription)
        }
        return nil
    }

    public func set(value: Any?, withKey key: KeychainStorage.Key) {
        guard let value = value else {
            delete(valueWithKey: key)
            return
        }
        let keyName = key.rawValue
        do {
            let data = [keyName: value]
            try keychain.set(
                NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false),
                key: keyName
            )
        } catch {
            fault(error.localizedDescription)
            assertionFailure(error.localizedDescription)
        }
    }

    public func delete(valueWithKey key: KeychainStorage.Key) {
        let keyName = key.rawValue
        do {
            try keychain.remove(keyName)
        } catch {
            fault(error.localizedDescription)
            assertionFailure(error.localizedDescription)
        }
    }

    public func flushStorage() {
        do {
            try keychain.removeAll()
        } catch {
            fault(error.localizedDescription)
            assertionFailure(error.localizedDescription)
        }
    }
}
