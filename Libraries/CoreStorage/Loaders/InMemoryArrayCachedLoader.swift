import Foundation

open class InMemoryArrayCachedLoader<Content>: CachedLoader<[Content]> {

    public var cache: DefaultInMemoryArrayExpirableStorage<Content> = .init()

    open override func loadCachedContent() throws -> [Content]? {
        cache.entities
    }

    open override func updateCache(with content: [Content]) {
        cache.save(entities: content)
    }

    override open func cleanCache() {
        cache.clean()
    }
}
