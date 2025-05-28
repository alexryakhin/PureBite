import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UserInterface
import Shared
import Core

final class SavedRecipesCoordinator: Coordinator {

    public enum Event {
        case finish
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var savedRecipesNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: savedRecipesNavigationController)
    }

    override func start() {
        showSavedRecipesController()
    }

    // MARK: - Private Methods

    private func showSavedRecipesController() {
        let savedRecipesController = resolver ~> SavedRecipesController.self

        savedRecipesController.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let recipeShortInfo):
                self?.openRecipeDetails(with: recipeShortInfo)
            case .openCategory(let config):
                self?.openRecipeCollection(with: config)
            }
        }

        savedRecipesNavigationController.addChild(savedRecipesController)
    }

    private func openRecipeCollection(with config: RecipeCollectionPageViewModel.Config) {
        let recipeCollectionController = resolver.resolve(RecipeCollectionController.self, argument: config)

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
