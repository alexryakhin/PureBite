public enum DefaultError: Error {

    case network(NetworkError)
    case timeout(Error?)
    case decodingError(Error)
    case serverSendWrongData
    case `internal`
#if DEBUG
    case debugError(String)
#endif
    case fileDoesNotExist(String)
    case fileReadError(String)
    case coreDataError(String)

    var errorDescription: String? {
        switch self {
        case .fileDoesNotExist(let message):
            return message
        case .fileReadError(let message):
            return message
        case .decodingError(let error):
            return "Failed to decode JSON: \(error)"
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .timeout(let error):
            return "Timeout error: \(error?.localizedDescription ?? "Unknown error")"
        case .serverSendWrongData:
            return "Error: server send wrong data"
        case .internal:
            return "Internal error"
        case .coreDataError(let message):
            return message
            #if DEBUG
        case .debugError(let message):
            return "DEBUG error: \(message)"
            #endif
        }
    }
}
