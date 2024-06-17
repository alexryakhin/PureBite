import Foundation
import Combine

public protocol ContentFetcherInterface: AnyObject {
    associatedtype Content
    func fetch(withRequestId requestId: String) async -> FetchResult<Content>
}

public extension ContentFetcherInterface {
    func fetch() async -> FetchResult<Content> {
        await fetch(withRequestId: UUID().uuidString)
    }
}

public protocol ContentObserverInterface: AnyObject {
    associatedtype Content

    func observe(stateHandler: @escaping (LoaderState<Content>) -> Void, useMainThread: Bool) -> AnyCancellable
    func observe(stateHandler: @escaping (LoaderState<Content>) -> Void) -> AnyCancellable
}

public extension ContentObserverInterface {
    func observe(stateHandler: @escaping (LoaderState<Content>) -> Void) -> AnyCancellable {
        observe(stateHandler: stateHandler, useMainThread: true)
    }
}

open class ContentLoader<Content>: ContentFetcherInterface, ContentObserverInterface {

    public typealias RequestId = String

    /// Current loader state
    @Published
    var state: LoaderState<Content> = .initial {
        didSet {
            switch state {
            case .loading, .loadedCache:
                generalState = .loading
            case .cacheAndError, .error:
                generalState = .error
            case .initial:
                generalState = .initial
            case .loaded:
                generalState = .finished
            }
        }
    }

    var generalState: LoaderGeneralState = .initial
    var content: Content? { state.content }
    var error: Error? { state.error }
    var isCompleted: Bool {
        state.isLoaded || state.isError
    }
    /// Active remote data loading task
    private var task: Task<FetchResult<Content>, Never>?

    public init() { }

    // MARK: - Public Methods

    @discardableResult
    public func fetch(withRequestId requestId: RequestId = UUID().uuidString) async -> FetchResult<Content> {
        if let task {
            return await task.value
        }
        let previousContent = content
        state = .loading(previousContent: previousContent)
        return await performFetch(previousContent: previousContent)
    }


    public func fetch(withRequestId requestId: RequestId = UUID().uuidString) {
        Task {
            await fetch(withRequestId: requestId)
        }
    }

    /// Begin cancellable remote content loading task. Do not call it directly
    @discardableResult
    final func performFetch(requestId: RequestId = UUID().uuidString, previousContent: Content?) async -> FetchResult<Content> {
        if let task, !task.isCancelled {
            return await task.value
        }

        task?.cancel()

        let task: Task<FetchResult<Content>, Never> = Task {
            defer {
                self.task?.cancel()
            }
            guard !Task.isCancelled else {
                return .cancelled
            }
            do {
                let content = try await loadContent()
                guard !Task.isCancelled else {
                    return .cancelled
                }

                contentReceived(content, requestId: requestId)
                return .success(content)
            } catch {
                guard !Task.isCancelled else {
                    return .cancelled
                }
                errorReceived(error, requestId: requestId, previousContent: previousContent)
                return .error(error)
            }
        }

        self.task = task
        return await task.value
    }

    open func contentReceived(_ content: Content, requestId: RequestId) {
        state = .loaded(content)
    }

    open func errorReceived(_ error: Error, requestId: RequestId, previousContent: Content?) {
        if case let .loadedCache(content) = state {
            state = .cacheAndError(content, error)
        } else {
            state = .error(previousContent: previousContent, error: error)
        }

    }

    public final func observe(stateHandler: @escaping (LoaderState<Content>) -> Void, useMainThread: Bool) -> AnyCancellable {
        if useMainThread {
            $state
                .dropFirst()
                .receive(on: RunLoop.main)
                .sink { state in
                    stateHandler(state)
                }
        } else {
            $state
                .dropFirst()
                .sink { state in
                    stateHandler(state)
                }
        }
    }

    // MARK: - Methods to implement

    /// Load content here (override in successor)
    open func loadContent() async throws -> Content {
        fatalError("loadContent() has not been implemented")
    }
}
