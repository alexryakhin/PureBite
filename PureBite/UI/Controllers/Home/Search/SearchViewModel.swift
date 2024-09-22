import Foundation
import Combine
import SwiftUI

public final class SearchViewModel: DefaultPageViewModel {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsViewModel.Config)
    }
    var onEvent: ((Event) -> Void)?

    @Published var isSearchFocused: Bool = false
    @Published var searchTerm: String = .empty
    @Published var searchResults: [Recipe] = []
    @Published var showNothingFound: Bool = false

    // MARK: - Private Properties

    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(spoonacularNetworkService: SpoonacularNetworkServiceInterface) {
        self.spoonacularNetworkService = spoonacularNetworkService
        super.init()
        state.additionalState = .empty()
        setupBindings()
    }

    // MARK: - Public Methods

    public func retry() {

    }

    // MARK: - Private Methods

    private func setupBindings() {
    }

    func loadRecipes(for searchTerm: String?) {
        Task { @MainActor in
            withAnimation {
                state.additionalState = .loading()
            }
            do {
                let params = SearchRecipesParams(query: searchTerm, sort: .healthiness, number: 20)
                let response = try await spoonacularNetworkService.searchRecipes(params: params)
                searchResults = response.results
                showNothingFound = response.totalResults == 0
                state.additionalState = response.totalResults == 0 ? .empty() : nil
            } catch {
                errorReceived(error, contentPreserved: false)
            }
        }
    }
}
