import Foundation
import Combine
import SwiftUI

public final class SearchPageViewModel: DefaultPageViewModel, @unchecked Sendable {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsPageViewModel.Config)
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
        additionalState = .placeholder()
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {}

    func loadRecipes(for searchTerm: String?) {
        Task { @MainActor in
            withAnimation {
                additionalState = .loading()
            }
            do {
                let params = SearchRecipesParams(query: searchTerm, sort: .healthiness, number: 20)
                let response = try await spoonacularNetworkService.searchRecipes(params: params)
                searchResults = response.results
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
