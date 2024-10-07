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
    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: savedNavigationController)
    }

    override func start() {
        showSavedController()
    }

    // MARK: - Private Methods

    private func showSavedController() {
        let savedController = resolver ~> SavedPageViewController.self

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

    private func openRecipeCollection(with config: RecipeCollectionPageViewModel.Config) {
        let recipeCollectionController = resolver.resolve(RecipeCollectionPageViewController.self, argument: config)

        recipeCollectionController?.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let config):
                self?.openRecipeDetails(with: config)
            case .finish:
                self?.router.popModule()
            }
        }

        router.push(recipeCollectionController)
    }

    private func openRecipeDetails(with config: RecipeDetailsPageViewModel.Config) {
        let recipeDetailsController = resolver.resolve(RecipeDetailsPageViewController.self, argument: config)

        recipeDetailsController?.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.router.popModule()
            }
        }

        router.push(recipeDetailsController)
    }
}
