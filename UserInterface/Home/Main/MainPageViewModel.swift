import Combine
import Foundation
import Core
import CoreUserInterface
import Shared
import Services

public final class MainPageViewModel: DefaultPageViewModel {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsPageViewModel.Config)
        case openSearchScreen
    }
    public var onEvent: ((Event) -> Void)?

    @Published var isLoading: Bool = false
    @Published var categories: [MainPageRecipeCategory] = []
    @Published var selectedCategory: MealType?
    @Published var selectedCategoryRecipes: [RecipeTileView.Model] = []
    @Published var greeting: (String, String) = (.empty, .empty)

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
        $selectedCategory
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] category in
                self?.loadRecipes(for: category)
            }
            .store(in: &cancellables)
    }

    private func loadRecipes(for selectedCategory: MealType?) {
        Task { @MainActor in
            isLoading = true
            defer {
                isLoading = false
            }
            do {
                if let selectedCategory {
                    let params = SearchRecipesParams(type: selectedCategory, sort: .random, number: 20)
                    let response = try await spoonacularNetworkService.searchRecipes(params: params)
                    selectedCategoryRecipes = response.results.map {
                        RecipeTileView.Model(recipeID: <#T##Int#>, title: <#T##String#>)
                    }
                } else {
                    guard self.categories.isEmpty else { return }
                    var categories = [MainPageRecipeCategory]()
                    for try await kind in MainPageRecipeCategory.Kind.allCases {
                        let response = try await spoonacularNetworkService.searchRecipes(params: kind.searchParams)
                        categories.append(MainPageRecipeCategory(kind: kind, recipes: response.results))
                    }
                    self.categories = categories
                }
            } catch {
                errorReceived(error, displayType: .page, action: { [weak self] in
                    self?.resetAdditionalState()
                    self?.loadRecipes(for: selectedCategory)
                })
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
            ("🍝 Hey, Foodie!", "What’s on the menu today?"),
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
