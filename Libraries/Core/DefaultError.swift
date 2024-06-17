enum DefaultError: Error {
    case network(Error?)
    case timeout(Error?)
    case decodingError(Error)
    case serverSendWrongData
    case server(Error?)
    case `internal`
#if DEBUG
    case debugError(String)
#endif
}
