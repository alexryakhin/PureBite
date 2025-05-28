import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UserInterface
import Shared
import Core

final class RecipeSearchCoordinator: Coordinator {

    public enum Event {
        case finish
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var searchNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: searchNavigationController)
    }

    override func start() {
        showRecipeSearchController()
    }

    // MARK: - Private Methods

    private func showRecipeSearchController() {
        let recipeSearchController = resolver ~> RecipeSearchController.self

        recipeSearchController.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let recipeShortInfo):
                self?.openRecipeDetails(with: recipeShortInfo)
            }
        }

        searchNavigationController.addChild(recipeSearchController)
    }

    private func openRecipeDetails(with recipeShortInfo: RecipeShortInfo) {
        let recipeDetailsController = resolver.resolve(RecipeDetailsController.self, argument: recipeShortInfo)

        recipeDetailsController?.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.router.popModule()
            }
        }

        router.push(recipeDetailsController)
    }
}
