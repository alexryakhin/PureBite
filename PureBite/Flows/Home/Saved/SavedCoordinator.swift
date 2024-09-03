import Combine
import Swinject
import SwinjectAutoregistration

final class SavedCoordinator: Coordinator {

    enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var savedNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
    private var innerRouter: RouterAbstract!

    // MARK: - Initialization

    required init(router: RouterAbstract) {
        super.init(router: router)
        innerRouter = Router(rootController: savedNavigationController)
    }

    override func start() {
        showSavedController()
    }

    // MARK: - Private Methods

    private func showSavedController() {
        let savedController = resolver ~> SavedController.self

        savedController.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let id):
                self?.openRecipeDetails(with: id)
            case .openCategory(let config):
                self?.openRecipeCollection(with: config)
            }
        }

        savedNavigationController.addChild(savedController)
    }

    private func openRecipeCollection(with config: RecipeCollectionViewModel.Config) {
        let recipeCollectionController = resolver.resolve(RecipeCollectionController.self, argument: config)

        recipeCollectionController?.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let id):
                self?.openRecipeDetails(with: id)
            case .finish:
                self?.router.popModule()
            }
        }

        router.push(recipeCollectionController)
    }

    private func openRecipeDetails(with id: Int) {
        let recipeDetailsController = resolver.resolve(RecipeDetailsController.self, argument: id)

        recipeDetailsController?.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.router.popModule()
            }
        }

        router.push(recipeDetailsController)
    }
}
