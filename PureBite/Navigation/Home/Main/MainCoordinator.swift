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
            }
        }

        router.push(recipeDetailsController)
    }
}
