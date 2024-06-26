import Foundation
import Combine
import EventSenderMacro
import EnumsMacros

@EventSender
public final class MainContentProps: ObservableObject, HaveInitialState {

    @PlainedEnum
    public enum Event {
        case refresh(selectedCategory: MealType?)
        case openRecipeDetails(id: Int)
    }

    @Published var isLoading: Bool = false
    @Published var categories: [MainPageRecipeCategory] = []
    @Published var selectedCategory: MealType?
    @Published var selectedCategoryRecipes: [Recipe] = []

    private var cancellables = Set<AnyCancellable>()

    init(categories: [MainPageRecipeCategory] = []) {
        self.categories = categories

        setupBindings()
    }

    private func setupBindings() {
        $selectedCategory
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] category in
                self?.send(event: .refresh(selectedCategory: category))
            }
            .store(in: &cancellables)
    }

    public static func initial() -> Self {
        Self()
    }

    static let previewCategories: [MainPageRecipeCategory] = [MainPageRecipeCategory(kind: .recommended, recipes: [
        Recipe(id: 715415, title: "Red Lentil Soup with Chicken and Turnips", image: "https://img.spoonacular.com/recipes/715415-312x231.jpg"),
        Recipe(id: 716406, title: "Asparagus and Pea Soup: Real Convenience Food", image: "https://img.spoonacular.com/recipes/716406-312x231.jpg"),
        Recipe(id: 644387, title: "Garlicky Kale", image: "https://img.spoonacular.com/recipes/644387-312x231.jpg"),
        Recipe(id: 715446, title: "Slow Cooker Beef Stew", image: "https://img.spoonacular.com/recipes/715446-312x231.jpg"),
        Recipe(id: 782601, title: "Red Kidney Bean Jambalaya", image: "https://img.spoonacular.com/recipes/782601-312x231.jpg"),
        Recipe(id: 716426, title: "Cauliflower, Brown Rice, and Vegetable Fried Rice", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg"),
        Recipe(id: 716004, title: "Quinoa and Chickpea Salad with Sun-Dried Tomatoes and Dried Cherries", image: "https://img.spoonacular.com/recipes/716004-312x231.jpg"),
        Recipe(id: 716627, title: "Easy Homemade Rice and Beans", image: "https://img.spoonacular.com/recipes/716627-312x231.jpg"),
        Recipe(id: 664147, title: "Tuscan White Bean Soup with Olive Oil and Rosemary", image: "https://img.spoonacular.com/recipes/664147-312x231.jpg"),
        Recipe(id: 640941, title: "Crunchy Brussels Sprouts Side Dish", image: "https://img.spoonacular.com/recipes/640941-312x231.jpg")
    ])]
}

extension MainContentProps: Equatable {
    public static func == (lhs: MainContentProps, rhs: MainContentProps) -> Bool {
        false // don't compare
    }
}
