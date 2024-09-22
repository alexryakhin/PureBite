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
        case openRecipeDetails(id: Int)
        case finish
    }

    var onEvent: ((Event) -> Void)?

    public let title: String
    public let recipes: [Recipe]

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(config: Config) {
        self.title = config.title
        self.recipes = config.recipes
        super.init()
        setupBindings()
    }

    // MARK: - Public Methods
    public func handleSearchInput(_ input: String) {
        print("Handle search: \(input)")
    }

    // MARK: - Private Methods

    private func setupBindings() {}
}
