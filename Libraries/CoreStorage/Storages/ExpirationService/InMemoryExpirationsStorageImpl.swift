import Foundation

public final class InMemoryExpirationsStorageImpl: ThreadSafeDictionary<String, Date>,
                                                   CleanableStorage,
                                                   ExpirationsStorage {

    public init() {
        super.init(accessQueueName: "expirations_queue")
    }

    public func expirationDate(forKey key: String) -> Date? {
        value(forKey: key)
    }

    public func updateExpirationDate(forKey key: String, timeToLive: TimeInterval) {
        let expirationDate = Date().addingTimeInterval(timeToLive)
        updateValue(expirationDate, forKey: key)
    }

    public func invalidateExpirationDate(forKey key: String) {
        deleteValue(forKey: key)
    }

    public func clean() {
        deleteAll()
    }
}
