import Combine

public final class RecipeCollectionViewModel: DefaultPageViewModel<RecipeCollectionContentProps> {

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

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(config: Config) {
        super.init()

        setInitialState(config: config)
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {}

    private func setInitialState(config: Config) {
        state = .init(contentProps: .init(title: config.title, recipes: config.recipes))
    }
}
