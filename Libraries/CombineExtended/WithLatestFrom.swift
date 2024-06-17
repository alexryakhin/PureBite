import Combine
import Foundation

public extension Publisher {

    func withLatestFrom<P>(
        _ other: P
    ) -> AnyPublisher<(Self.Output, P.Output), Failure> where P: Publisher, Self.Failure == P.Failure {
        let other = other
        // Note: Do not use `.map(Optional.some)` and `.prepend(nil)`.
        // There is a bug in iOS versions prior 14.5 in `.combineLatest`. If P.Output itself is Optional.
        // In this case prepended `Optional.some(nil)` will become just `nil` after `combineLatest`.
            .map { (value: $0, ()) }
            .prepend((value: nil, ()))

        return map { (value: $0, token: UUID()) }
            .combineLatest(other)
            .removeDuplicates(by: { (old, new) in
                let lhs = old.0, rhs = new.0
                return lhs.token == rhs.token
            })
            .map { ($0.value, $1.value) }
            .compactMap { (left, right) in
                right.map { (left, $0) }
            }
            .eraseToAnyPublisher()
    }

    func withLatestFrom2<P, R>(
        _ one: P, _ two: R
    ) -> AnyPublisher<(Output, P.Output, R.Output), Failure> where P: Publisher, R: Publisher, Self.Failure == P.Failure, Self.Failure == R.Failure {
        self.withLatestFrom(one)
            .withLatestFrom(two)
            .map { ($0.0, $0.1, $1) }
            .eraseToAnyPublisher()
    }

    func withLatestFrom3<P, R, Q>(
        _ one: P, _ two: R, _ three: Q
    ) -> AnyPublisher<(Output, P.Output, R.Output, Q.Output), Failure> where P: Publisher, R: Publisher, Q: Publisher, Self.Failure == P.Failure, Self.Failure == R.Failure, Self.Failure == Q.Failure {
        self.withLatestFrom2(one, two)
            .withLatestFrom(three)
            .map { ($0.0, $0.1, $0.2, $1) }
            .eraseToAnyPublisher()
    }
}
