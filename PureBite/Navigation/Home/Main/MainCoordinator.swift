import Combine
import Swinject
import SwinjectAutoregistration
import UIKit
import CoreNavigation
import CoreUserInterface
import UserInterface
import Shared
import Core

final class MainCoordinator: Coordinator {

    public enum Event {
        case authorize
        case openSearchScreen
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var mainNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: mainNavigationController)
    }

    override func start() {
        showMainController()
    }

    // MARK: - Private Methods

    private func showMainController() {
        let mainController = resolver ~> MainController.self

        mainController.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let recipeShortInfo):
                self?.openRecipeDetails(with: recipeShortInfo)
            case .openSearchScreen:
                self?.onEvent?(.openSearchScreen)
            }
        }

        mainNavigationController.addChild(mainController)
    }

    private func openRecipeDetails(with recipeShortInfo: RecipeShortInfo) {
        let recipeDetailsController = resolver.resolve(RecipeDetailsController.self, argument: recipeShortInfo)

        recipeDetailsController?.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.router.popModule()
            case .showIngredientInformation(let config):
                self?.showIngredientDetails(config: config)
            }
        }

        router.push(recipeDetailsController)
    }

    private func showIngredientDetails(config: IngredientDetailsPageViewModel.Config) {
        let controller = resolver ~> (IngredientDetailsController.self, config)
        controller.onEvent = { [weak self, weak controller] event in
            switch event {
            case .finish:
                self?.router.dismissModule(controller)
            }
        }

        router.present(controller, modalPresentationStyle: .overFullScreen, animated: true)
    }
}
