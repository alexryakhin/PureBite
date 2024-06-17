public final class Weak<Wrapped> where Wrapped: AnyObject {
    private weak var object: Wrapped?

    public init?(object: Wrapped?) {
        self.object = object
    }

    public var value: Wrapped? {
        get {
            return object
        }
        set {
            object = newValue
        }
    }

    public var isNil: Bool { object == nil }
}
