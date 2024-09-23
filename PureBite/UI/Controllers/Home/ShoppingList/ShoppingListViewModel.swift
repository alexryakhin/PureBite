import Foundation
import Combine

public final class ShoppingListViewModel: DefaultPageViewModel {

    public enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(arg: Int) {
        super.init()

        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {}
}
