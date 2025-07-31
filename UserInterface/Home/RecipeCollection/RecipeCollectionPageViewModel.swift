import Foundation
import Core
import CoreUserInterface
import Shared

@MainActor
public final class RecipeCollectionPageViewModel: SwiftUIBaseViewModel {

    public struct Config {
        public let title: String
        public let recipes: [RecipeShortInfo]

        public init(title: String, recipes: [RecipeShortInfo]) {
            self.title = title
            self.recipes = recipes
        }
    }

    public enum Event {
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
    }
    public var onEvent: ((Event) -> Void)?

    public let config: Config

    public override init() {
        self.config = Config(title: "", recipes: [])
        super.init()
    }

    public init(config: Config) {
        self.config = config
        super.init()
    }
}
