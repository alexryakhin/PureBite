import Foundation
import Combine
import Core
import CoreUserInterface
import Shared
import Services

public final class ShoppingListPageViewModel: DefaultPageViewModel {

    enum Input {
    }

    enum Output {

    }

    var onOutput: ((Output) -> Void)?

    @Published var searchTerm: String = .empty
    @Published var shoppingListItems: [ShoppingListItem] = []

    // MARK: - Private Properties
    private let shoppingListRepository: ShoppingListRepositoryInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(shoppingListRepository: ShoppingListRepositoryInterface) {
        self.shoppingListRepository = shoppingListRepository
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        
    }

    // MARK: - Private Methods

    private func setupBindings() {
        shoppingListRepository.shoppingListItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                if items.isEmpty {
                    self?.additionalState = .placeholder()
                } else {
                    self?.shoppingListItems = items
                }
            }
            .store(in: &cancellables)
    }
}
