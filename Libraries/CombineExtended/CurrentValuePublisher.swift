import Combine

/// `CurrentValuePublisher` without errors
public typealias Relay<Output> = CurrentValuePublisher<Output, Never>

/// Read-only `CurrentValueSubject` wrapper. You can only subscribe to changes and get current value, but cannot send value
public final class CurrentValuePublisher<Output, Failure: Error> {

    private let subject: CurrentValueSubject<Output, Failure>

    public var value: Output { subject.value }
    public var publisher: AnyPublisher<Output, Failure> { subject.eraseToAnyPublisher() }

    public init(currentValueSubject: CurrentValueSubject<Output, Failure>) {
        self.subject = currentValueSubject
    }

    public init(value: Output) {
        self.subject = .init(value)
    }
}

public extension CurrentValueSubject {

    var readonly: CurrentValuePublisher<Output, Failure> {
        CurrentValuePublisher(currentValueSubject: self)
    }
}
