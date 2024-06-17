import Foundation

public enum CachedLoaderError: Error {
    case noCache
}

public protocol CachedLoaderInterface: ContentObserverInterface {

    /// Return only *last* value (or throws an error) for cache policies `useAndThenFetch` and `.useAndThenFetchIgnoringFails`, but `state` will be updated with all intermediate results
    /// - Parameters:
    ///   - throws: is `true`, will throw an error. Set error state otherwise
    @discardableResult
    func load(cacheUsagePolicy: CacheUsagePolicy, requestId: String, throws: Bool) async throws -> Content?
    func load(cacheUsagePolicy: CacheUsagePolicy, requestId: String)
}

public extension CachedLoaderInterface {
    
    @discardableResult
    func load(cacheUsagePolicy: CacheUsagePolicy, throws: Bool = false) async throws -> Content? {
        try await load(cacheUsagePolicy: cacheUsagePolicy, requestId: UUID().uuidString, throws: `throws`)
    }
    
    func load(cacheUsagePolicy: CacheUsagePolicy, requestId: String) {
        Task {
            try await load(cacheUsagePolicy: cacheUsagePolicy, requestId: requestId, throws: false)
        }
    }
    
    func load(cacheUsagePolicy: CacheUsagePolicy) {
        load(cacheUsagePolicy: cacheUsagePolicy, requestId: UUID().uuidString)
    }
}

// MARK: - CachedLoader

open class CachedLoader<Content>: ContentLoader<Content>, CachedLoaderInterface {

    private var cacheUsagePolicies: [RequestId: CacheUsagePolicy] = [:]

    @discardableResult
    final public func load(cacheUsagePolicy: CacheUsagePolicy, requestId: String, throws: Bool) async throws -> Content? {
        cacheUsagePolicies[requestId] = cacheUsagePolicy

        let previousContent = content

        switch cacheUsagePolicy {
        case .ignore:
            state = .loading(previousContent: previousContent)
            let result = await performFetch(requestId: requestId, previousContent: previousContent)
            return `throws` ? try result.contentOrThrowError() : result.content

        case .ignoreAndResetPreviousContent:
            state = .loading(previousContent: nil)
            let result = await performFetch(requestId: requestId, previousContent: nil)
            return `throws` ? try result.contentOrThrowError() : result.content

        case .useIfFetchFails:
            state = .loading(previousContent: previousContent)
            let result = await performFetch(requestId: requestId, previousContent: previousContent)
            return `throws` ? try result.contentOrThrowError() : result.content

        case .useIfUpToDate:
            if
                let contentWithExpirationStatus = try? loadExpirableCachedContent(),
                !contentWithExpirationStatus.isExpired
            {
                state = .loadedCache(contentWithExpirationStatus.item)
                cacheUsagePolicies[requestId] = nil
                return contentWithExpirationStatus.item
            }

            state = .loading(previousContent: previousContent)
            let result = await performFetch(requestId: requestId, previousContent: previousContent)
            return `throws` ? try result.contentOrThrowError() : result.content

        case .useAndThenFetch, .useAndThenFetchIgnoringFails:
            if
                let contentWithExpirationStatus = try? loadExpirableCachedContent(),
                !contentWithExpirationStatus.isExpired
            {
                state = .loadedCache(contentWithExpirationStatus.item)
            } else {
                state = .loading(previousContent: previousContent)
            }
            let result = await performFetch(requestId: requestId, previousContent: previousContent)
            return `throws` ? try result.contentOrThrowError() : result.content
        }
    }

    /// Load expirable cached content here (override in successor if loader is cached). Subscribers will not be notified!
    func loadExpirableCachedContent() throws -> ExpirableItem<Content>? {
        guard let cachedContent = try loadCachedContent() else {
            return nil
        }
        return ExpirableItem(item: cachedContent, isExpired: false)
    }

    override open func contentReceived(_ content: Content, requestId: RequestId) {
        updateCache(with: content)
        cacheUsagePolicies[requestId] = nil
        state = .loaded(content)
    }

    override open func errorReceived(_ error: Error, requestId: RequestId, previousContent: Content?) {
        let newState: LoaderState<Content>

        switch cacheUsagePolicies[requestId] {
        case .none, .ignore, .ignoreAndResetPreviousContent, .useIfUpToDate:
            newState = .error(previousContent: previousContent, error: error)

        case .useIfFetchFails, .useAndThenFetch:
            if
                let contentWithExpirationStatus = try? loadExpirableCachedContent(),
                !contentWithExpirationStatus.isExpired
            {
                newState = .loadedCache(contentWithExpirationStatus.item)
            } else {
                newState = .error(previousContent: previousContent, error: error)
            }

        case .useAndThenFetchIgnoringFails:
            if let contentWithExpirationStatus = try? loadExpirableCachedContent() {
                newState = .loadedCache(contentWithExpirationStatus.item)
            } else {
                newState = .error(previousContent: previousContent, error: error)
            }
        }

        cacheUsagePolicies[requestId] = nil
        state = newState
    }

    // MARK: - Methods to implement

    /// Load cached content (override in successor if loader is cached)
    open func loadCachedContent() throws -> Content? {
        assertionFailure("\(#function) not implemented")
        return nil
    }

    open func updateCache(with content: Content) {
        assertionFailure("\(#function) not implemented")
    }

    open func cleanCache() {
        assertionFailure()
    }
}
