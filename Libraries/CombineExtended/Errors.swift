import Combine

public extension Publisher {

    func skippingErrors() -> AnyPublisher<Output, Never> {
        self
            .catch { _ in Empty<Output, Never>() }
            .eraseToAnyPublisher()
    }

    func replaceErrors(with element: Output) -> AnyPublisher<Output, Never> {
        self
            .catch { _ in Just(element) }
            .eraseToAnyPublisher()
    }
}

public extension Publisher where Failure == Never {

    func raiseError<E: Error>(when errorChecker: @escaping (Output) -> E?) -> AnyPublisher<Output, E> {

        func check(value: Output) throws -> Output {
            if let error = errorChecker(value) {
                throw error
            }
            return value
        }

        return tryMap { value in
            try check(value: value)
        }
        .mapError { error in
            error as! E
        }
        .eraseToAnyPublisher()
    }
}
