open class InMemorySingleCachedLoader<Content>: CachedLoader<Content> {

    public var cache: DefaultInMemorySingleExpirableStorage<Content> = .init()

    open override func loadCachedContent() throws -> Content? {
        cache.entity
    }

    open override func updateCache(with content: Content) {
        cache.save(entity: content)
    }

    /// Load expirable cached content
    override func loadExpirableCachedContent() throws -> ExpirableItem<Content>? {
        guard let cachedContent = try loadCachedContent() else {
            return nil
        }
        return ExpirableItem(item: cachedContent, isExpired: cache.isExpired())
    }

    override open func cleanCache() {
        cache.clean()
    }
}
