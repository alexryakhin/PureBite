import Foundation

/// Storage of expiration dates associated to the key
public protocol ExpirationsStorage {
    
    func expirationDate(forKey key: String) -> Date?
    func updateExpirationDate(forKey key: String, timeToLive: TimeInterval)
    func invalidateExpirationDate(forKey key: String)
}
