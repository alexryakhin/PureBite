// Created by: Jullian Mercier
// https://jllnmercier.medium.com/combine-single-valued-publisher-25c5775a4de

import Combine

public extension Publisher {

    func asSingle() -> Publishers.Single<Self> {
        return Publishers.Single(upstream: self)
    }
}

public extension Publishers {

    struct Single<Upstream: Publisher>: Publisher {
        public typealias Output = Upstream.Output
        public typealias Failure = Upstream.Failure

        private let upstream: Upstream

        public init(upstream: Upstream) {
            self.upstream = upstream
        }

        public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            subscriber.receive(subscription: Subscription(upstream: upstream, downstream: subscriber))
        }
    }
}

extension Publishers.Single {

    final class Subscription<Downstream: Subscriber>: Combine.Subscription where Upstream.Output == Downstream.Input, Upstream.Failure == Downstream.Failure {
        private var sink: AsSingleSink<Upstream, Downstream>?

        init(upstream: Upstream, downstream: Downstream) {
            sink = .init(upstream: upstream, downstream: downstream)
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            sink = nil
        }
    }
}

final class AsSingleSink<Upstream: Publisher, Downstream: Subscriber>: Subscriber where Upstream.Output == Downstream.Input, Downstream.Failure == Upstream.Failure {
    private var downstream: Downstream
    private var _element: Upstream.Output?

    init(upstream: Upstream, downstream: Downstream) {
        self.downstream = downstream
        upstream.subscribe(self)
    }

    func receive(subscription: Subscription) {
        subscription.request(.max(1))
    }

    func receive(_ input: Upstream.Output) -> Subscribers.Demand {
        _element = input
        _ = downstream.receive(input)
        downstream.receive(completion: .finished)
        return .none
    }

    func receive(completion: Subscribers.Completion<Upstream.Failure>) {
        switch completion {
        case .failure(let err):
            downstream.receive(completion: .failure(err))
        case .finished:
            if _element == nil {
                fatalError("❌ Sequence doesn’t contain any elements.")
            }
        }
    }
}
