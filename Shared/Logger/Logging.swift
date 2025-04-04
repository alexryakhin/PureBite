public let logger = Logger()

public func debug(_ message: String...) {
    logger.debug(message.joined(separator: " "))
}

public func info(_ message: String...) {
    logger.info(message.joined(separator: " "))
}

public func warn(_ message: String...) {
    logger.warn(message.joined(separator: " "))
}

// Named fault in order to distinguish it from error objects
public func fault(_ message: String...) {
    logger.error(message.joined(separator: " "))
}
