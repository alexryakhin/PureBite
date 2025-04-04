import Foundation
import Combine
import SwiftUI

public final class SearchPageViewModel: DefaultPageViewModel {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsPageViewModel.Config)
    }

    public enum Input {
        case loadNextPage
        case search(query: String)
    }

    public enum FetchTrigger {
        case firstBatch
        case nextPage
        case idle
    }

    var onEvent: ((Event) -> Void)?

    @Published var isSearchFocused: Bool = false
    @Published var searchTerm: String = .empty
    @Published var searchResults: [Recipe] = []
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
            loadRecipes(for: searchTerm)
        case .search(let query):
            withAnimation {
                additionalState = .loading()
            }
            searchResults.removeAll()
            fetchTriggerStatus = .firstBatch
            loadRecipes(for: query)
        }
    }

    // MARK: - Private Methods

    private func loadRecipes(for searchTerm: String?) {
        self.searchTerm = searchTerm ?? .empty
        Task { @MainActor in
            defer {
                fetchTriggerStatus = .idle
            }
            do {
                let params = SearchRecipesParams(
                    query: searchTerm,
                    sort: .healthiness,
                    offset: itemsOffset,
                    number: 15
                )
                let response = try await spoonacularNetworkService.searchRecipes(params: params)
                searchResults.append(contentsOf: response.results)
                itemsOffset += response.results.count
                canLoadNextPage = response.totalResults > itemsOffset
                showNothingFound = response.totalResults == 0
                additionalState = response.totalResults == 0 ? .placeholder() : nil
            } catch {
                errorReceived(error, displayType: .page, action: { [weak self] in
                    self?.loadRecipes(for: searchTerm)
                })
            }
        }
    }
}
