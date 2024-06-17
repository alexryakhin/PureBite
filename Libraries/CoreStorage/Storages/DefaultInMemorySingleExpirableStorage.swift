import Foundation

open class DefaultInMemorySingleExpirableStorage<StoredEntity>: InMemorySingleExpirableStorage {

    // MARK: - ExpirableGroup properties

    public var expirableGroupName: String { String(describing: StoredEntity.Type.self) }
    public var timeToLive: TimeInterval

    public let expirationsStorage: ExpirationsStorage
    public let dateProvider: DateProvider

    // MARK: - InMemoryExpirableStorage properties

    public var safeEntity: ThreadSafeObject<StoredEntity>?

    // MARK: - Initializers

    public init(
        timeToLive: TimeInterval = 60 * 5,
        expirationsStorage: ExpirationsStorage = InMemoryExpirationsStorageImpl(),
        dateProvider: DateProvider = DateProviderImpl()
    ) {
        self.timeToLive = timeToLive
        self.expirationsStorage = expirationsStorage
        self.dateProvider = dateProvider
    }
}
