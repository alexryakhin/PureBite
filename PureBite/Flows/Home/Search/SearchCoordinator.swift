import Combine
import Swinject
import SwinjectAutoregistration
import EnumsMacros
import EventSenderMacro

@EventSender
final class SearchCoordinator: Coordinator {

    @PlainedEnum
    enum Event {
        case finish
    }

    // MARK: - Public Properties

    lazy var searchNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
    private var innerRouter: RouterAbstract!

    // MARK: - Initialization

    required init(router: RouterAbstract) {
        super.init(router: router)
        innerRouter = Router(rootController: searchNavigationController)
    }

    override func start() {
        showSearchController()
    }

    // MARK: - Private Methods

    private func showSearchController() {
        let searchController = resolver ~> SearchController.self

        searchController.on { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        searchNavigationController.addChild(searchController)
    }
}
