import Combine

public extension Publisher {

    /// Republish output of publisher into two other publishers on the given condition
    func splitted<P: Publisher>(
        condition: @escaping (Output) -> Bool,
        _ firstPublisher: P,
        _ secondPublisher: P
    ) -> AnyPublisher<P.Output, Never> where Failure == Never, P.Failure == Never {
        return flatMap { output -> AnyPublisher<P.Output, Never> in
            if condition(output) {
                return firstPublisher.eraseToAnyPublisher()
            } else {
                return secondPublisher.eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }

    /// Republish output of publisher into two other publishers on the given condition
    func split<P: Publisher>(
        condition: @escaping (Output) -> Bool,
        firstPublisherMaker: @escaping (Output) -> P,
        secondPublisherMaker: @escaping (Output) -> P
    ) -> AnyPublisher<P.Output, Never> where Failure == Never, P.Failure == Never {
        return flatMap { output -> P in
            if condition(output) {
                return firstPublisherMaker(output)
            } else {
                return secondPublisherMaker(output)
            }
        }.eraseToAnyPublisher()
    }

    func flatMap<P>(
        first: P,
        second: P,
        condition: @escaping (Output) -> Bool
    ) -> AnyPublisher<P.Output, Failure> where P: Publisher, P.Failure == Self.Failure {
        map { element -> P in
            if condition(element) {
                return first
            } else {
                return second
            }
        }
        .switchToLatest()
        .eraseToAnyPublisher()
    }
}

