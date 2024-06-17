/// Abstract cleanable storage of objects, that is also `ExpirableGroup`, and related with a storage of expiration dates
public protocol ExpirableStorage: CleanableStorage, ExpirableGroup {

    associatedtype StoredEntity

    var expirationsStorage: ExpirationsStorage { get }
}
