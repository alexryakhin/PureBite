import Foundation
import Combine
import SwiftUI

@MainActor
public final class ShoppingListPageViewModel: SwiftUIBaseViewModel {

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
    private let shoppingListRepository: ShoppingListRepository

    // MARK: - Initialization

    public override init() {
        self.ingredientSearchRepository = IngredientSearchRepository()
        self.shoppingListRepository = ShoppingListRepository.shared
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
                    self?.setLoading(true)
                case .loadingNextPage:
                    break // show loading view below the list of results
                case .nextPageLoadingError:
                    break // show error view below the list of results
                case .firstPageLoadingError:
                    self?.handleError(CoreError.unknownError)
                case .initial:
                    break
                case .idle:
                    self?.setLoading(false)
                case .idleNoData:
                    break
                @unknown default:
                    fatalError("Unknown fetch status: \(status)")
                }
            }
            .store(in: &cancellables)

        shoppingListRepository.$shoppingListItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.shoppingListItems = items
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
