import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UserInterface
import Shared

final class ProfileCoordinator: Coordinator {

    public enum Event {
        case finish
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var profileNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: profileNavigationController)
    }

    override func start() {
        profileSearchController()
    }

    // MARK: - Private Methods

    private func profileSearchController() {
        let profileController = resolver ~> ProfileController.self

        profileController.onEvent = { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        profileNavigationController.addChild(profileController)
    }
}
