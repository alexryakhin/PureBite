import Combine
import Swinject
import SwinjectAutoregistration
import EnumsMacros
import EventSenderMacro

@EventSender
final class SavedCoordinator: Coordinator {

    @PlainedEnum
    enum Event {
        case finish
    }
    
    // MARK: - Public Properties

    lazy var savedNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
    private var innerRouter: RouterAbstract!

    // MARK: - Initialization

    required init(router: RouterAbstract) {
        super.init(router: router)
        innerRouter = Router(rootController: savedNavigationController)
    }

    override func start() {
        showSavedController()
    }

    // MARK: - Private Methods

    private func showSavedController() {
        let savedController = resolver ~> SavedController.self

        savedController.on { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        savedNavigationController.addChild(savedController)
    }
}
