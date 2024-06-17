import Foundation

/// Abstract group of objects which has expiration status
public protocol ExpirableGroup: AnyObject {

    /// Unique name of the group used as key
    var expirableGroupName: String { get }
    /// Time interval in which group is alive, and expired if this interval elapsed
    var timeToLive: TimeInterval { get }

    var expirationsStorage: ExpirationsStorage { get }
    var dateProvider: DateProvider { get }

    func isExpired() -> Bool
    func updateExpirationDate()
    func resetExpirationDate()
}

public extension ExpirableGroup {
    
    func isExpired() -> Bool {
        guard let expirationDate = expirationsStorage.expirationDate(forKey: expirableGroupName) else {
            return true
        }

        let currentDate = dateProvider.currentDate()
        let isExpired = expirationDate <= currentDate
        return isExpired
    }

    func updateExpirationDate() {
        expirationsStorage.updateExpirationDate(forKey: expirableGroupName, timeToLive: timeToLive)
    }

    func resetExpirationDate() {
        expirationsStorage.invalidateExpirationDate(forKey: expirableGroupName)
    }
}
