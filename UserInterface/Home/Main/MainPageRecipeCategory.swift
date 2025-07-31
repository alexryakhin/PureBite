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
        case highProtein
        case quickAndEasy
        case global
        case keto

        var title: String {
            switch self {
            case .recommended: "Recommended for you"
            case .highProtein: "High Protein"
            case .quickAndEasy: "Quick & Easy"
            case .global: "Global Cuisines"
            case .keto: "Keto Recipes"
            }
        }

        var searchParams: SearchRecipesParams {
            switch self {
            case .recommended: return .init(minProtein: 20, maxSugar: 10, number: 10)
            case .highProtein: return .init(minProtein: 45, number: 10)
            case .quickAndEasy: return .init(maxReadyTime: 15, number: 10)
            case .global: return .init(cuisines: [.italian, .chinese, .mexican], number: 10)
            case .keto: return .init(maxCarbs: 10, number: 10)
            }
        }
    }
}
