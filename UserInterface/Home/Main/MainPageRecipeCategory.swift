import Foundation

struct MainPageRecipeCategory: Identifiable {
    let id: String = UUID().uuidString
    let kind: Kind
    let recipes: [RecipeShortInfo]

    init(kind: Kind, recipes: [RecipeShortInfo]) {
        self.kind = kind
        self.recipes = recipes
    }

    enum Kind: CaseIterable {
        case recommended
        case quickMeals
        case healthy
        case desserts

        var title: String {
            switch self {
            case .recommended: "Recommended for you"
            case .quickMeals: "Quick Meals"
            case .healthy: "Healthy Recipes"
            case .desserts: "Desserts"
            }
        }

        var searchParams: SearchRecipesParams {
            switch self {
            case .recommended: return .init(sort: .random, number: 10)
            case .quickMeals: return .init(maxReadyTime: 30, sort: .time, number: 10)
            case .healthy: return .init(sort: .healthiness, number: 10)
            case .desserts: return .init(type: .dessert, sort: .popularity, number: 10)
            }
        }
        
        var recipeCategory: RecipeCategory {
            switch self {
            case .recommended: return .recommended
            case .quickMeals: return .quickMeals
            case .healthy: return .healthy
            case .desserts: return .desserts
            }
        }
    }
}
