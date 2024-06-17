import Combine

public extension Publisher {

    func asVoid() -> AnyPublisher<Void, Failure> {
        map { _ in Void() }.eraseToAnyPublisher()
    }

    func asTrue() -> AnyPublisher<Bool, Failure> {
        map { _ in true }.eraseToAnyPublisher()
    }

    func asFalse() -> AnyPublisher<Bool, Failure> {
        map { _ in false }.eraseToAnyPublisher()
    }

    func asOptional() -> AnyPublisher<Output?, Failure> {
        map { $0 }.eraseToAnyPublisher()
    }
}

public extension Publisher where Output == Bool {

    func isTrue() -> AnyPublisher<Bool, Failure> {
        map { $0 == true }.eraseToAnyPublisher()
    }

    func isFalse() -> AnyPublisher<Bool, Failure> {
        map { $0 == false }.eraseToAnyPublisher()
    }

    func inverted() -> AnyPublisher<Bool, Failure> {
        map { !$0 }.eraseToAnyPublisher()
    }
}

public extension Publisher where Output == String {

    func isEmpty() -> AnyPublisher<Bool, Failure> {
        map { $0.isEmpty }.eraseToAnyPublisher()
    }

    func isNotEmpty() -> AnyPublisher<Bool, Failure> {
        isEmpty().inverted()
    }
}

public extension Publisher {

    func replace<O>(withElement element: O) -> AnyPublisher<O, Failure> {
        map { _ in element }.eraseToAnyPublisher()
    }
}

public extension Publisher where Output: AdditiveArithmetic {

    func isZero() -> AnyPublisher<Bool, Failure> {
        map { $0 == .zero }.eraseToAnyPublisher()
    }

    func isNotZero() -> AnyPublisher<Bool, Failure> {
        isZero().inverted()
    }
}

public extension Publisher where Output: OptionalType {

    func isNil() -> AnyPublisher<Bool, Failure> {
        flatMap { output -> AnyPublisher<Bool, Failure> in
            if output.value != nil {
                return Future<Bool, Failure> {
                    $0(.success(false))
                }
                .eraseToAnyPublisher()
            } else {
                return Future<Bool, Failure> {
                    $0(.success(true))
                }
                .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }

    func isNotNil() -> AnyPublisher<Bool, Failure> {
        isNil().inverted()
    }
}

public extension Publisher where Output == Bool {

    func or<P: Publisher>(_ other: P) -> AnyPublisher<Bool, Failure> where P.Output == Bool, P.Failure == Failure {
        Publishers.CombineLatest(self, other)
            .map { $0 || $1 }
            .eraseToAnyPublisher()
    }

    func and<P: Publisher>(_ other: P) -> AnyPublisher<Bool, Failure> where P.Output == Bool, P.Failure == Failure {
        Publishers.CombineLatest(self, other)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
}
