import Combine
import Foundation

@MainActor
public final class MainPageViewModel: SwiftUIBaseViewModel {

    public enum Event {
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
    }
    public var onEvent: ((Event) -> Void)?

    @Published var categories: [MainPageRecipeCategory] = []
    @Published var selectedCategory: MealType?
    @Published var selectedCategoryRecipes: [RecipeShortInfo] = []
    @Published var greeting: (String, String) = (.empty, .empty)

    // MARK: - Private Properties

    private let spoonacularNetworkService: SpoonacularNetworkService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public override init() {
        self.spoonacularNetworkService = SpoonacularNetworkService.shared
        super.init()

        setInitialState()
        setupBindings()
        loadRecipes(for: nil)
    }

    // MARK: - Private Methods

    private func setupBindings() {
        $selectedCategory
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] category in
                self?.loadRecipes(for: category)
            }
            .store(in: &cancellables)
    }

    private func loadRecipes(for selectedCategory: MealType?) {
        Task { @MainActor in
            setLoading(true)
            defer {
                setLoading(false)
            }
            do {
                if let selectedCategory {
                    let maxSugar: Int? = switch selectedCategory {
                    case .breakfast, .lunch, .dinner, .salad, .soup: 10
                    default: nil
                    }
                    let minProtein: Int? = switch selectedCategory {
                    case .breakfast: 10
                    case .lunch, .dinner: 25
                    default: nil
                    }
                    let params = SearchRecipesParams(
                        type: selectedCategory,
                        sort: .random,
                        minProtein: minProtein,
                        maxSugar: maxSugar,
                        number: 12
                    )
                    let response = try await spoonacularNetworkService.searchRecipes(params: params)
                    selectedCategoryRecipes = response.results.map(\.recipeShortInfo)
                } else {
                    guard self.categories.isEmpty else { return }
                    var categories = [MainPageRecipeCategory]()
                    for try await kind in MainPageRecipeCategory.Kind.allCases {
                        let response = try await spoonacularNetworkService.searchRecipes(params: kind.searchParams)
                        categories.append(
                            MainPageRecipeCategory(
                                kind: kind,
                                recipes: response.results.map(\.recipeShortInfo)
                            )
                        )
                    }
                    self.categories = categories
                }
            } catch {
                handleError(error)
            }
        }
    }

    private func randomGreeting() -> (String, String) {
        let greetings = [
            ("🍳 Hello, Chef!", "What's cooking today?"),
            ("🍳 Ready to cook?", "Let's find a recipe!"),
            ("🥘 Hey there!", "What will you create today?"),
            ("🍽️ Welcome back!", "Time to make something delicious."),
            ("🥗 Let's whip up", "something tasty!"),
            ("🍲 Hi there!", "Ready for a new recipe?"),
            ("🍝 Hey, Foodie!", "What's on the menu today?"),
            ("🍕 Hello!", "Let's create a culinary masterpiece."),
            ("🍳 Greetings, Chef!", "What will you cook today?"),
            ("🍰 Welcome!", "Ready to find your next favorite dish?"),
            ("🍰 Hey there!", "Got a tasty dish in mind?")
        ]

        return greetings.randomElement() ?? ("👩‍🍳 Hello, Chef!", "Let's get started!")
    }

    private func setInitialState() {
        greeting = randomGreeting()
    }
}
