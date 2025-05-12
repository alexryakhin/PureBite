import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UserInterface
import Shared

final class ShoppingListDashboardCoordinator: Coordinator {

    public enum Event {
        case finish
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var shoppingListDashboardNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: shoppingListDashboardNavigationController)
    }

    override func start() {
        showShoppingListDashboardController()
    }

    // MARK: - Private Methods

    private func showShoppingListDashboardController() {
        let shoppingListDashboardController = resolver ~> ShoppingListDashboardController.self

        shoppingListDashboardController.onEvent = { [weak self] event in
            switch event {
            case .showItemInformation(let config):
                self?.showItemInformation(config: config)
            }
        }

        shoppingListDashboardNavigationController.addChild(shoppingListDashboardController)
    }

    private func showItemInformation(config: IngredientDetailsPageViewModel.Config) {
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
