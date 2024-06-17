import Combine

public extension Publisher where Self.Failure == Never {

    func sink() -> AnyCancellable {
        sink(receiveValue: { _ in })
    }
}

public extension Publisher {

    /// Publisher combined with the given publisher but ignoring its elements
    func triggering<P: Publisher>(on publisher: P) -> AnyPublisher<Output, Failure> where P.Failure == Failure {
        combineLatest(publisher).map { $0.0 }.eraseToAnyPublisher()
    }

    func assign<S>(to observer: S) -> AnyCancellable where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        sink { completion in
            observer.receive(completion: completion)
        } receiveValue: { output in
            _ = observer.receive(output)
        }
    }

    /// Republish events to the given subject
    func bind<T: Subject>(to subject: T) -> AnyCancellable where Self.Output == T.Output, Self.Failure == T.Failure {
        return self.sink { completion in
            subject.send(completion: completion)
        } receiveValue: { value in
            subject.send(value)
        }
    }

    /// Republish events to the given subject
    func bind<T: Subject>(to subjects: [T]) -> [AnyCancellable] where Self.Output == T.Output, Self.Failure == T.Failure {
        subjects.map { bind(to: $0) }
    }
}

public extension Array where Element == AnyCancellable {

    func store(in cancellables: inout Set<AnyCancellable>) {
        forEach {
            $0.store(in: &cancellables)
        }
    }
}

public extension Publisher {

    func onNext(_ action: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveOutput: action).eraseToAnyPublisher()
    }
}
