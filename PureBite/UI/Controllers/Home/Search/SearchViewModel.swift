import Foundation
import Combine

public final class SearchViewModel: DefaultPageViewModel<SearchContentProps> {

    public enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(arg: Int) {
        super.init()

        setInitialState()
        setupBindings()
    }

    // MARK: - Public Methods

    public func retry() {

    }

    // MARK: - Private Methods

    private func setupBindings() {
    }

    private func setInitialState() {
        state = .init(contentProps: .initial())
    }
}
