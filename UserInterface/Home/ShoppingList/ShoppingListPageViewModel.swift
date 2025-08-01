import Foundation
import Combine
import SwiftUI

@MainActor
final class ShoppingListPageViewModel: SwiftUIBaseViewModel {

    enum Input {
        case search
        case finishSearch
        case addToShoppingList(
            ingredient: IngredientSearchInfo,
            unit: String,
            amount: Double,
            category: ShoppingCategory?,
            notes: String?,
            priority: ShoppingPriority?
        )
        case toggleCheck(shoppingListItemID: String)
        case deleteFromShoppingList(shoppingListItemID: String)
        case loadNextPage
        case editItem(shoppingListItemID: String)
        case toggleShoppingMode
    }

    @Published var searchTerm: String = .empty
    @Published var fetchStatus: PaginationFetchStatus = .initial
    @Published var searchResults: [IngredientSearchInfo] = []
    @Published var shoppingListItems: [ShoppingListItem] = []
    @Published var selectedSearchResultToAddToShoppingList: IngredientSearchInfo?
    @Published var isShoppingMode: Bool = false

    var canLoadNextPage: Bool {
        ingredientSearchRepository.canLoadNextPage
    }
    
    var progressPercentage: Double {
        let totalItems = shoppingListItems.count
        let checkedItems = shoppingListItems.filter(\.isChecked).count
        return totalItems > 0 ? Double(checkedItems) / Double(totalItems) : 0
    }
    
    var groupedItems: [ShoppingCategory: [ShoppingListItem]] {
        Dictionary(grouping: shoppingListItems) { $0.category }
    }

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let ingredientSearchRepository: IngredientSearchRepository
    private let shoppingListRepository: ShoppingListRepository

    override init() {
        self.ingredientSearchRepository = IngredientSearchRepository.shared
        self.shoppingListRepository = ShoppingListRepository.shared
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .search:
            ingredientSearchRepository.search(query: searchTerm)
        case .finishSearch:
            searchTerm = .empty
            searchResults.removeAll()
            ingredientSearchRepository.reset()
        case .addToShoppingList(let ingredient, let unit, let amount, let category, let notes, let priority):
            shoppingListRepository.addIngredient(
                ingredient,
                unit: unit,
                amount: amount,
                category: category ?? .uncategorized,
                notes: notes,
                priority: priority ?? .normal
            )
            trackIngredientAdded(ingredient.name)
            selectedSearchResultToAddToShoppingList = nil
        case .toggleCheck(let shoppingListItemID):
            shoppingListRepository.toggleCheck(shoppingListItemID)
            // Track item checked/unchecked
            if let item = shoppingListItems.first(where: { $0.id == shoppingListItemID }) {
                trackItemChecked(item.ingredient.name, isChecked: !item.isChecked)
            }
        case .deleteFromShoppingList(let shoppingListItemID):
            shoppingListRepository.removeItem(shoppingListItemID)
        case .loadNextPage:
            ingredientSearchRepository.loadNextPage()
        case .editItem(let shoppingListItemID):
            // TODO: Implement edit functionality
            break
        case .toggleShoppingMode:
            isShoppingMode.toggle()
        }
    }

    private func setupBindings() {
        ingredientSearchRepository.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                print("📱 [SHOPPING_LIST] Received \(items.count) search results")
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

        // Debounced search
        $searchTerm
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                if !query.isEmpty {
                    self?.ingredientSearchRepository.search(query: query)
                } else {
                    self?.searchResults.removeAll()
                    self?.ingredientSearchRepository.reset()
                }
            }
            .store(in: &cancellables)
    }
}
