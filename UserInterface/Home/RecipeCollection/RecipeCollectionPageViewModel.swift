import Foundation

@MainActor
final class RecipeCollectionPageViewModel: SwiftUIBaseViewModel {

    struct Config {
        let title: String
        let recipes: [RecipeShortInfo]

        init(title: String, recipes: [RecipeShortInfo]) {
            self.title = title
            self.recipes = recipes
        }
    }

    enum Event {
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
    }
    var onEvent: ((Event) -> Void)?

    let config: Config

    override init() {
        self.config = Config(title: "", recipes: [])
        super.init()
    }

    init(config: Config) {
        self.config = config
        super.init()
    }
}
