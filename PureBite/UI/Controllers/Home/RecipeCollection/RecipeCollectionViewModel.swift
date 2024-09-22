import UIKit
import Combine

public final class RecipeCollectionViewModel: DefaultPageViewModel {

    public struct Config {
        public let title: String
        public let recipes: [Recipe]

        public init(title: String, recipes: [Recipe]) {
            self.title = title
            self.recipes = recipes
        }
    }

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsViewModel.Config)
        case finish
    }

    var onEvent: ((Event) -> Void)?

    public let title: String
    public let recipes: [Recipe]

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
