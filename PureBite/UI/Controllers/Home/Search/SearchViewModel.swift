import Foundation
import Combine

public final class SearchViewModel: DefaultPageViewModel<SearchContentProps> {

    public enum Event {
        case openRecipeDetails(id: Int)
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private Properties

    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(spoonacularNetworkService: SpoonacularNetworkServiceInterface) {
        self.spoonacularNetworkService = spoonacularNetworkService
        super.init()

        setInitialState()
        setupBindings()
    }

    // MARK: - Public Methods

    public func retry() {

    }

    // MARK: - Private Methods

    private func setupBindings() {
//        state.contentProps.$searchTerm
//            .removeDuplicates()
//            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
//            .sink { [weak self] searchTerm in
//                if searchTerm.isNotEmpty {
//                    self?.loadRecipes(for: searchTerm)
//                }
//            }
//            .store(in: &cancellables)
    }

    func loadRecipes(for searchTerm: String?) {
        Task { @MainActor in
            state.additionalState = .loading()
            defer {
                state.additionalState = nil
            }
            do {
                let params = SearchRecipesParams(query: searchTerm, type: nil, sort: .random, number: 20)
                let response = try await spoonacularNetworkService.searchRecipes(params: params)
                state.contentProps.searchResults = response.results
                state.contentProps.showNothingFound = response.totalResults == 0
            } catch {
                errorReceived(error, contentPreserved: true)
            }
        }
    }

    private func setInitialState() {
        state = .init(contentProps: .initial())
    }
}
