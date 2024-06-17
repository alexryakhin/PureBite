public enum FetchResult<Content> {

    case success(Content)
    case error(Error)
    case cancelled

    var content: Content? {
        if case .success(let content) = self {
            return content
        }
        return nil
    }

    var error: Error? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }

    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }

    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }

    var isCancelled: Bool {
        if case .cancelled = self {
            return true
        }
        return false
    }

    func contentOrThrowError() throws -> Content? {
        if let error {
            throw error
        }
        return content
    }
}
