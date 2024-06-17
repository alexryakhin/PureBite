import Combine

public protocol OptionalType {
    
    associatedtype Wrapped

    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    
    public var value: Wrapped? {
        return self
    }
}
