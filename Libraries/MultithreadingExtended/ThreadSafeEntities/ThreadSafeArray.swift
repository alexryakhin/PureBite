import Foundation

open class ThreadSafeArray<Value> {
    
    // MARK: - Private properties
    
    private var array: [Value] = []
    private let queue: DispatchQueue
    
    // MARK: - Public properties
    
    public final var items: [Value] {
        queue.sync {
            self.array
        }
    }
    
    public final var count: Int { items.count }
    
    public final var isEmpty: Bool { items.isEmpty }
    
    public final var last: Value? {
        items.last
    }
    
    // MARK: - Initializers
    
    public init(accessQueueName: String) {
        queue = DispatchQueue(label: accessQueueName, attributes: .concurrent)
    }

    public init(accessQueue: DispatchQueue) {
        queue = accessQueue
    }

    // MARK: - Public methods
    
    public final func append(_ newElement: Value) {
        queue.async(flags: .barrier) {
            self.array.append(newElement)
        }
    }
    
    public final func removeAll() {
        queue.async(flags: .barrier) {
            self.array.removeAll()
        }
    }
    
    public final func append(contentsOf newElements: [Value]) {
        queue.async(flags: .barrier) {
            self.array.append(contentsOf: newElements)
        }
    }
    
    public final func prepend(contentsOf newElements: [Value]) {
        queue.async(flags: .barrier) {
            self.array.insert(contentsOf: newElements, at: 0)
        }
    }
    
    public final func replaceAll(with newElements: [Value]) {
        queue.async(flags: .barrier) {
            self.array.removeAll()
            self.array = newElements
        }
    }
}
