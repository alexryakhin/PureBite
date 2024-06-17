import Combine

public extension Publisher where Output == Bool {

    /// `Bool` publisher, ignores `false` input
    func ifTrue() -> AnyPublisher<Bool, Failure> {
        filter { $0 == true }.eraseToAnyPublisher()
    }

    /// `Bool` publisher, ignores `true` input
    func ifFalse() -> AnyPublisher<Bool, Failure> {
        filter { $0 == false }.eraseToAnyPublisher()
    }

    /// `Void` publisher, ignores `false` input
    func whenTrue() -> AnyPublisher<Void, Failure> {
        ifTrue().asVoid().eraseToAnyPublisher()
    }

    /// `Void` publisher, ignores `true` input
    func whenFalse() -> AnyPublisher<Void, Failure> {
        ifFalse().asVoid().eraseToAnyPublisher()
    }
}

public extension Publisher {

    /// Ignores output when last value of `filteringPublisher` is `false`
    func filter<O: Publisher>(whenTrue filteringPublisher: O) -> AnyPublisher<Output, Failure> where O.Output == Bool, O.Failure == Failure {
        withLatestFrom(filteringPublisher).filter { $0.1 == true }.map { $0.0 }.eraseToAnyPublisher()
    }

    /// Ignores output when last value of `filteringPublisher` is `true`
    func filter<O: Publisher>(whenFalse filteringPublisher: O) -> AnyPublisher<Output, Failure> where O.Output == Bool, O.Failure == Failure {
        filter(whenTrue: filteringPublisher.inverted())
    }
}

public extension Publisher where Output: OptionalType {

    /// `Output.Wrapped` publisher, ignores `nil` input
    func ifNotNil() -> AnyPublisher<Output.Wrapped, Failure> {
        flatMap { output -> AnyPublisher<Output.Wrapped, Failure> in
            if let value = output.value {
                return Future<Output.Wrapped, Failure> {
                    $0(.success(value))
                }
                .eraseToAnyPublisher()
            } else {
                return Empty<Output.Wrapped, Failure>().eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }

    /// `Void` publisher, ignores `nil` input
    func whenNotNil() -> AnyPublisher<Void, Failure> {
        ifNotNil().asVoid().eraseToAnyPublisher()
    }
}
