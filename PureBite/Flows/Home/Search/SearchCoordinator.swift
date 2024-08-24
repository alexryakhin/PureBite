import Combine
import Swinject
import SwinjectAutoregistration

final class SearchCoordinator: Coordinator {

    enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

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

        searchController.onEvent = { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        searchNavigationController.addChild(searchController)
    }
}
