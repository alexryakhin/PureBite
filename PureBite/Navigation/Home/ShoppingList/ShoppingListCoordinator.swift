import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UserInterface
import Shared

final class ShoppingListCoordinator: Coordinator {

    public enum Event {
        case finish
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var shoppingListNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: shoppingListNavigationController)
    }

    override func start() {
        showShoppingListController()
    }

    // MARK: - Private Methods

    private func showShoppingListController() {
        let shoppingListController = resolver ~> ShoppingListController.self
        shoppingListNavigationController.addChild(shoppingListController)
    }
}
