public protocol InMemorySingleExpirableStorage: ExpirableStorage {

    var entity: StoredEntity? { get }
    var safeEntity: ThreadSafeObject<StoredEntity>? { get set }
    
    func save(entity: StoredEntity)
}

public extension InMemorySingleExpirableStorage {

    var entity: StoredEntity? {
        return safeEntity?.item
    }
    
    func save(entity: StoredEntity) {
        if safeEntity == nil {
            recreateSafeStore()
        }
        safeEntity?.update(object: entity)
        updateExpirationDate()
    }

    func recreateSafeStore() {
        safeEntity = .init(accessQueueName: "\(expirableGroupName)_queue")
    }
}

public extension InMemorySingleExpirableStorage {

    func clean() {
        safeEntity?.remove()
        safeEntity = nil
        resetExpirationDate()
    }
}
