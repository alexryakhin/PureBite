import Combine
import EnumsMacros
import EventSenderMacro
import Foundation

@EventSender
public final class MainViewModel: DefaultPageViewModel<MainContentProps> {

    @PlainedEnum
    public enum Event {
        case openRecipeDetails(id: Int)
    }

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
        state.contentProps.on { [weak self] event in
            switch event {
            case .refresh(let selectedCategory):
                self?.loadRecipies(for: selectedCategory)
            case .openRecipeDetails(let id):
                self?.send(event: .openRecipeDetails(id: id))
            }
        }
    }

    private func loadRecipies(for selectedCategory: MealType?) {
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
