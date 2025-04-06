import Foundation
import Combine
import SwiftUI
import Core
import CoreUserInterface
import Shared
import Services

public final class ShoppingListPageViewModel: DefaultPageViewModel {

    public enum Event {
        case showIngredientInformation(IngredientDetailsPageViewModel.Config)
        case activateSearch(query: String?)
    }

    public enum Input {
        case loadNextPage
        case search(query: String)
        case ingredientSelected(IngredientDetailsPageViewModel.Config)
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
    @Published var searchResults: [IngredientSearchResponse.Ingredient] = []
    @Published var showNothingFound: Bool = false

    @Published var fetchTriggerStatus: FetchTrigger = .idle
    @Published var canLoadNextPage: Bool = false

    // MARK: - Private Properties

    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private var itemsOffset: Int = 0
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(spoonacularNetworkService: SpoonacularNetworkServiceInterface) {
        self.spoonacularNetworkService = spoonacularNetworkService
        super.init()
        additionalState = .placeholder()
    }

    public func handle(_ input: Input) {
        switch input {
        case .loadNextPage:
            fetchTriggerStatus = .nextPage
            loadIngredients(for: searchTerm)
        case .search(let query):
            withAnimation {
                additionalState = .loading()
            }
            searchResults.removeAll()
            fetchTriggerStatus = .firstBatch
            loadIngredients(for: query)
        case .ingredientSelected(let config):
            onEvent?(.showIngredientInformation(config))
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

    private func loadIngredients(for searchTerm: String?) {
        guard let searchTerm = searchTerm?.nilIfEmpty else {
            return
        }
        if !searchQueries.components(separatedBy: "\n").contains(searchTerm) {
            searchQueries.append(contentsOf: "\(searchTerm)\n")
        }
        additionalState = .loading()
        Task { @MainActor in
            defer {
                fetchTriggerStatus = .idle
            }
            do {
                let params = SearchIngredientsParams(
                    query: searchTerm,
                    metaInformation: true,
                    offset: itemsOffset,
                    number: 15
                )
                let response = try await spoonacularNetworkService.searchIngredients(params: params)
                searchResults.append(contentsOf: response.results)
                itemsOffset += response.results.count
                canLoadNextPage = response.totalResults > itemsOffset
                showNothingFound = response.totalResults == 0
                additionalState = response.totalResults == 0 ? .placeholder() : nil
            } catch {
                errorReceived(error, displayType: .page, action: { [weak self] in
                    self?.resetAdditionalState()
                    self?.loadIngredients(for: searchTerm)
                })
            }
        }
    }
}
