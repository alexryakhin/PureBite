import Foundation

// MARK: - LoaderState

enum LoaderGeneralState {
    case initial
    case loading
    case finished
    case error
}

public enum LoaderState<Content>: Equatable {
    case initial
    case loading(previousContent: Content?)
    case loadedCache(Content)
    case loaded(Content)
    case cacheAndError(Content, Error)
    case error(previousContent: Content?, error: Error)

    // MARK: - Public Properties

    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    public var isLoaded: Bool {
        if case .loaded = self {
            return true
        }
        return false
    }

    public var isError: Bool {
        if case .error = self {
            return true
        }
        if case .cacheAndError = self {
            return true
        }
        return false
    }

    public var isContent: Bool {
        if case .loaded = self {
            return true
        }
        if case .loadedCache = self {
            return true
        }
        if case .cacheAndError = self {
            return true
        }
        return false
    }

    public var isUpToDateContent: Bool {
        if case .loaded = self {
            return true
        }
        return false
    }

    public var isCachedContent: Bool {
        if case .loadedCache = self {
            return true
        }
        if case .cacheAndError = self {
            return true
        }
        return false
    }

    public var content: Content? {
        switch self {
        case .initial:
            return nil
        case .loading(let previousContent), .error(let previousContent, _):
            return previousContent
        case .loadedCache(let content), .loaded(let content), .cacheAndError(let content, _):
            return content
        }
    }

    public var error: Error? {
        switch self {
        case .cacheAndError(_, let error), .error(_, let error):
            return error
        default:
            return nil
        }
    }

    // MARK: - Equatable

    public static func == (lhs: LoaderState<Content>, rhs: LoaderState<Content>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial),
            (.loading, .loading),
            (.loadedCache, .loadedCache),
            (.loaded, .loaded),
            (.cacheAndError, .cacheAndError),
            (.error, .error):
            return true
        default:
            return false
        }
    }
}

public extension LoaderState {

    var debugDescription: String {
        switch self {
        case .initial:
            return "initial"
        case .loading(let previousContent):
            return "loading (has previousContent: \(previousContent != nil))"
        case .loadedCache:
            return "loaded from cache"
        case .loaded:
            return "loaded"
        case .cacheAndError:
            return "cache and error"
        case .error(let previousContent, _):
            return "error (has previousContent: \(previousContent != nil))"
        }
    }
}
