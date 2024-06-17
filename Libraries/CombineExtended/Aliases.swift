import Combine

public typealias VoidPublisher = AnyPublisher<Void, Never>
public typealias IntPublisher = AnyPublisher<Int, Never>
public typealias BoolPublisher = AnyPublisher<Bool, Never>
public typealias StringPublisher = AnyPublisher<String?, Never>
public typealias NonFailingPublisher<Output> = AnyPublisher<Output, Never>

public typealias VoidPassthroughSubject = PassthroughSubject<Void, Never>
public typealias IntPassthroughSubject = PassthroughSubject<Int, Never>
public typealias BoolPassthroughSubject = PassthroughSubject<Bool, Never>
public typealias StringPassthroughSubject = PassthroughSubject<String, Never>
public typealias NonFailingPassthroughSubject<Output> = PassthroughSubject<Output, Never>

/// `CurrentValueSubject` without failures
public typealias AnySubject<Output> = CurrentValueSubject<Output, Never>
public typealias IntSubject = AnySubject<Int>
public typealias BoolSubject = AnySubject<Bool>
public typealias StringSubject = AnySubject<String>
public typealias OptionalStringSubject = AnySubject<String?>


public extension VoidPassthroughSubject {
    
    func trigger() {
        send()
    }
}
