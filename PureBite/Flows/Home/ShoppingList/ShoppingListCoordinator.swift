import Combine
import Swinject
import SwinjectAutoregistration
import EnumsMacros
import EventSenderMacro

@EventSender
final class ShoppingListCoordinator: Coordinator {

    @PlainedEnum
    enum Event {
        case finish
    }

    // MARK: - Public Properties

    lazy var shoppingListNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
    private var innerRouter: RouterAbstract!

    // MARK: - Initialization

    required init(router: RouterAbstract) {
        super.init(router: router)
        innerRouter = Router(rootController: shoppingListNavigationController)
    }

    override func start() {
        showShoppingListController()
    }

    // MARK: - Private Methods

    private func showShoppingListController() {
        let shoppingListController = resolver ~> ShoppingListController.self

        shoppingListController.on { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        shoppingListNavigationController.addChild(shoppingListController)
    }
}
