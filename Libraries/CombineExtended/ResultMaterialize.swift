import Combine

public extension Result {

    func materialized() -> (success: Success?, failure: Failure?) {
        switch self {
        case .success(let success):
            return (success: success, failure: nil)
        case .failure(let failure):
            return (success: nil, failure: failure)
        }
    }

    func success() -> Success? {
        materialized().success
    }

    func failure() -> Failure? {
        materialized().failure
    }
}

public protocol ResultPublishing {
    associatedtype Success
    associatedtype Failure: Error
    var result: Result<Success, Failure> { get }
}

extension Result: ResultPublishing {
    public var result: Result<Success, Failure> {
        self
    }
}

public extension ResultPublishing {

    var success: Success? {
        return result.success()
    }

    var failure: Failure? {
        return result.failure()
    }

    var isSuccess: Bool {
        return success != nil
    }

    var isFailure: Bool {
        return failure != nil
    }
}

public extension Publisher where Output: ResultPublishing, Failure == Never {

    func success() -> AnyPublisher<Output.Success, Never> {
        map { $0.success }.ifNotNil().eraseToAnyPublisher()
    }

    func failure() -> AnyPublisher<Output.Failure, Never> {
        map { $0.failure }.ifNotNil().eraseToAnyPublisher()
    }

    var traitErrorsAsNil: AnyPublisher<Output.Success?, Never> {
        map { value -> Output.Success? in
            switch value.result {
            case .success(let success):
                return success
            case .failure:
                return nil
            }
        }.eraseToAnyPublisher()
    }

    func dematerialized() -> AnyPublisher<Output.Success, Output.Failure> {
        return self
            .setFailureType(to: Output.Failure.self)
            .tryMap { output -> Output.Success in
                switch output.result {
                case .success(let value):
                    return value
                case .failure(let error):
                    throw error
                }
            }
            .mapError { $0 as! Output.Failure }
            .eraseToAnyPublisher()
    }
}

public extension Publisher {

    func materialized() -> AnyPublisher<Result<Output, Failure>, Never> {
        return map { value in
            return Result<Output, Failure>.success(value)
        }
        .catch { error in
            return Just(Result<Output, Failure>.failure(error))
        }
        .eraseToAnyPublisher()
    }
}
