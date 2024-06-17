import Foundation

public class ThreadSafeObject<Value> {
    
    // MARK: - Private properties
    
    private var object: Value?
    private let queue: DispatchQueue
    
    // MARK: - Public properties
    
    public final var item: Value? {
        queue.sync {
            self.object
        }
    }
    
    public final var isClear: Bool {
        item == nil
    }
    
    // MARK: - Initializers
    
    public init(accessQueueName: String) {
        queue = DispatchQueue(label: accessQueueName, attributes: .concurrent)
    }

    public init(accessQueue: DispatchQueue) {
        queue = accessQueue
    }

    // MARK: - Public methods
    
    public final func update(object: Value) {
        queue.async(flags: .barrier) {
            self.object = object
        }
    }
    
    public final func remove() {
        queue.async(flags: .barrier) {
            self.object = nil
        }
    }
}
