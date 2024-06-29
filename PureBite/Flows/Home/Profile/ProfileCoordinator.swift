import Combine
import Swinject
import SwinjectAutoregistration
import EnumsMacros
import EventSenderMacro

@EventSender
final class ProfileCoordinator: Coordinator {

    @PlainedEnum
    enum Event {
        case finish
    }

    // MARK: - Public Properties

    lazy var profileNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
    private var innerRouter: RouterAbstract!

    // MARK: - Initialization

    required init(router: RouterAbstract) {
        super.init(router: router)
        innerRouter = Router(rootController: profileNavigationController)
    }

    override func start() {
        profileSearchController()
    }

    // MARK: - Private Methods

    private func profileSearchController() {
        let profileController = resolver ~> ProfileController.self

        profileController.on { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        profileNavigationController.addChild(profileController)
    }
}
