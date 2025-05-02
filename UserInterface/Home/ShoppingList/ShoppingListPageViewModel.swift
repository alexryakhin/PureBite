import Foundation
import Combine
import SwiftUI
import Core
import CoreUserInterface
import Shared
import Services

public final class ShoppingListPageViewModel: DefaultPageViewModel {

    public enum Event {
        case showItemInformation(IngredientDetailsPageViewModel.Config)
        case activateSearch(query: String?)
    }

    public enum Input {
        case loadNextPage
        case search(query: String)
        case itemSelected(IngredientDetailsPageViewModel.Config)
        case activateSearch
        case finishSearch
    }

    public enum FetchTrigger {
        case firstBatch
        case nextPage
        case idle
    }

    public var onEvent: ((Event) -> Void)?

    @AppStorage(UserDefaultsKey.ingredientSearchQueries.rawValue)
    private var searchQueries: String = ""

    @Published var isSearchFocused: Bool = false
    @Published var searchTerm: String = .empty
    @Published var searchResults: [ShoppingListItem] = []

    var showNothingFound: Bool {
        isSearchFocused && searchTerm.isNotEmpty && searchResults.isEmpty
    }

    // MARK: - Private Properties

    private let repository: ShoppingListRepositoryInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(repository: ShoppingListRepositoryInterface) {
        self.repository = repository
        super.init()
        additionalState = .placeholder()
    }

    public func handle(_ input: Input) {
        switch input {
        case .loadNextPage:
            break
        case .search(let query):
            break
        case .itemSelected(let config):
            onEvent?(.showItemInformation(config))
        case .activateSearch:
            onEvent?(.activateSearch(query: searchTerm.nilIfEmpty))
        case .finishSearch:
            searchResults.removeAll()
            searchTerm = .empty
            isSearchFocused = false
            additionalState = .placeholder()
        }
    }

    // MARK: - Private Methods

}
