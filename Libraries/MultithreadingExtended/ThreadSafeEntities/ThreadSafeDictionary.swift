import Foundation

open class ThreadSafeDictionary<Key: Hashable, Value> {

    // MARK: - Private properties

    private var dict: [Key: Value] = [:]
    private let queue: DispatchQueue

    // MARK: - Public properties

    public final var dictionary: [Key: Value] {
        queue.sync {
            self.dict
        }
    }

    // MARK: - Initializers

    public init(accessQueueName: String) {
        queue = DispatchQueue(label: accessQueueName, attributes: .concurrent)
    }

    public init(accessQueue: DispatchQueue) {
        queue = accessQueue
    }

    // MARK: - Public methods

    public final func value(forKey key: Key) -> Value? {
        queue.sync {
            return dict[key]
        }
    }

    public final func updateValue(_ value: Value, forKey key: Key) {
        queue.async(flags: .barrier) {
            self.dict[key] = value
        }
    }

    public final func deleteValue(forKey key: Key) {
        queue.async(flags: .barrier) {
            self.dict[key] = nil
        }
    }

    public final func deleteAll() {
        queue.async(flags: .barrier) {
            self.dict.removeAll()
        }
    }
}
