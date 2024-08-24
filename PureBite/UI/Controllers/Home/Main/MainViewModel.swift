import Combine
import Foundation

public final class MainViewModel: DefaultPageViewModel<MainContentProps> {

    public enum Event {
        case openRecipeDetails(id: Int)
        case openSearchScreen
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
        loadRecipes(for: nil)
    }

    // MARK: - Private Methods

    private func setupBindings() {
        state.contentProps.$selectedCategory
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] category in
                self?.loadRecipes(for: category)
            }
            .store(in: &cancellables)
    }

    private func loadRecipes(for selectedCategory: MealType?) {
        Task { @MainActor in
            state.contentProps.isLoading = true
            defer {
                state.contentProps.isLoading = false
            }
            do {
                if let selectedCategory {
                    let params = SearchRecipesParams(type: selectedCategory, sort: .random, number: 20)
                    let response = try await spoonacularNetworkService.searchRecipes(params: params)
                    state.contentProps.selectedCategoryRecipes = response.results
                } else {
                    guard state.contentProps.categories.isEmpty else { return }
                    var categories = [MainPageRecipeCategory]()
                    for try await kind in MainPageRecipeCategory.Kind.allCases {
                        let response = try await spoonacularNetworkService.searchRecipes(params: kind.searchParams)
                        categories.append(MainPageRecipeCategory(kind: kind, recipes: response.results))
                    }
                    state.contentProps.categories = categories
                }
            } catch {
                errorReceived(error, contentPreserved: true)
            }
        }
    }

    private func setInitialState() {
        state = .init(contentProps: .initial())
    }
}
