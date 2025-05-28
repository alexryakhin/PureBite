import Foundation
import Combine
import SwiftUI
import Core
import CoreUserInterface
import Shared
import Services

public final class ShoppingListPageViewModel: DefaultPageViewModel {

    public enum Input {
        case search
        case finishSearch
        case addToShoppingList(ingredient: IngredientSearchInfo, unit: String, amount: Double)
        case toggleCheck(shoppingListItemID: String)
        case deleteFromShoppingList(shoppingListItemID: String)
        case loadNextPage
    }

    @Published var searchTerm: String = .empty
    @Published var fetchStatus: PaginationFetchStatus = .initial
    @Published var searchResults: [IngredientSearchInfo] = []
    @Published var shoppingListItems: [ShoppingListItem] = []
    @Published var selectedSearchResultToAddToShoppingList: IngredientSearchInfo?

    var canLoadNextPage: Bool {
        ingredientSearchRepository.canLoadNextPage
    }

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let ingredientSearchRepository: IngredientSearchRepository
    private let shoppingListRepository: ShoppingListRepositoryInterface

    // MARK: - Initialization

    public init(
        ingredientSearchRepository: IngredientSearchRepository,
        shoppingListRepository: ShoppingListRepositoryInterface
    ) {
        self.ingredientSearchRepository = ingredientSearchRepository
        self.shoppingListRepository = shoppingListRepository
        super.init()
        setupBindings()
    }

    public func handle(_ input: Input) {
        switch input {
        case .search:
            ingredientSearchRepository.search(query: searchTerm)
        case .finishSearch:
            searchTerm = .empty
            searchResults.removeAll()
            ingredientSearchRepository.reset()
            if shoppingListItems.isEmpty {
                additionalState = .placeholder()
            }
        case .addToShoppingList(let ingredient, let unit, let amount):
            shoppingListRepository.addIngredient(ingredient, unit: unit, amount: amount)
            selectedSearchResultToAddToShoppingList = nil
        case .toggleCheck(let shoppingListItemID):
            shoppingListRepository.toggleCheck(shoppingListItemID)
        case .deleteFromShoppingList(let shoppingListItemID):
            shoppingListRepository.removeItem(shoppingListItemID)
        case .loadNextPage:
            ingredientSearchRepository.loadNextPage()
        }
    }

    private func setupBindings() {
        ingredientSearchRepository.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.searchResults = items
            }
            .store(in: &cancellables)

        ingredientSearchRepository.fetchStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.fetchStatus = status
                switch status {
                case .loadingFirstPage:
                    break
                case .loadingNextPage:
                    break // show loading view below the list of results
                case .nextPageLoadingError:
                    break // show error view below the list of results
                case .firstPageLoadingError:
                    self?.errorReceived(CoreError.unknownError, displayType: .page)
                case .initial:
                    break
                case .idle:
                    self?.resetAdditionalState()
                case .idleNoData:
                    if self?.shoppingListItems.isEmpty ?? true {
                        self?.additionalState = .placeholder()
                    }
                @unknown default:
                    fatalError("Unknown fetch status: \(status)")
                }
            }
            .store(in: &cancellables)

        shoppingListRepository.shoppingListItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                if items.isNotEmpty {
                    self?.shoppingListItems = items
                    self?.resetAdditionalState()
                } else {
                    self?.additionalState = .placeholder()
                }
            }
            .store(in: &cancellables)

        $searchTerm.combineLatest($fetchStatus)
            .sink { [weak self] newValue, fetchStatus in
                if newValue.isEmpty && fetchStatus != .initial {
                    self?.handle(.finishSearch)
                    self?.fetchStatus = .initial
                }
            }
            .store(in: &cancellables)
    }
}
