import CoreData

public protocol InMemoryExpirableStorage: ExpirableStorage {

    var entities: [StoredEntity]? { get }
    var safeEntities: ThreadSafeArray<StoredEntity>? { get set }

    func save(entities: [StoredEntity])
    func recreateSafeStore()
}

public extension InMemoryExpirableStorage {

    var entities: [StoredEntity]? {
        safeEntities?.items
    }

    func save(entities: [StoredEntity]) {
        if safeEntities == nil {
            recreateSafeStore()
        }
        safeEntities?.replaceAll(with: entities)
        updateExpirationDate()
    }

    func recreateSafeStore() {
        safeEntities = .init(accessQueueName: "\(expirableGroupName)_queue")
    }
}

// MARK: - CleanableStorage

public extension InMemoryExpirableStorage {

    func clean() {
        safeEntities = nil
        resetExpirationDate()
    }
}
