import UIKit
import Combine
import Core
import CoreUserInterface
import Shared
import Services

public final class RecipeCollectionPageViewModel: DefaultPageViewModel {

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
        case finish
    }

    public var onEvent: ((Event) -> Void)?

    public let title: String
    public let recipes: [RecipeShortInfo]

    @Published var searchTerm: String = .empty

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(config: Config) {
        self.title = config.title
        self.recipes = config.recipes
        super.init()
    }
}
