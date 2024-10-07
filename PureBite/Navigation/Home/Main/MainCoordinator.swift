import Combine
import Swinject
import SwinjectAutoregistration
import UIKit

final class MainCoordinator: Coordinator {

    enum Event {
        case authorize
        case openSearchScreen
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var mainNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
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
        let mainController = resolver ~> MainPageViewController.self

        mainController.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let id):
                self?.openRecipeDetails(with: id)
            case .openSearchScreen:
                self?.onEvent?(.openSearchScreen)
            }
        }

        mainNavigationController.addChild(mainController)
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
