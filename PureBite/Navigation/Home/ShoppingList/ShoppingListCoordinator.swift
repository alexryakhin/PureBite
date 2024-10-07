import Combine
import Swinject
import SwinjectAutoregistration

final class ShoppingListCoordinator: Coordinator {

    enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var shoppingListNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
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
        let shoppingListController = resolver ~> ShoppingListPageViewController.self

        shoppingListController.onEvent = { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        shoppingListNavigationController.addChild(shoppingListController)
    }
}
