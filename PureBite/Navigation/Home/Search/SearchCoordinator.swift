import Combine
import Swinject
import SwinjectAutoregistration

final class SearchCoordinator: Coordinator {

    enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var searchNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: searchNavigationController)
    }

    override func start() {
        showSearchController()
    }

    // MARK: - Private Methods

    private func showSearchController() {
        let searchController = resolver ~> SearchPageViewController.self

        searchController.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let id):
                self?.openRecipeDetails(with: id)
            }
        }

        searchNavigationController.addChild(searchController)
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
