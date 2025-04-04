import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UserInterface

final class DebugCoordinator: Coordinator {

    public enum Event {
        case finish
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Public Properties

    lazy var debugNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: debugNavigationController)
    }

    override func start() {
        presentDebugController()
    }

    // MARK: - Private Methods

    private func presentDebugController() {
        let debugController = resolver ~> DebugController.self

        debugController.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.onEvent?(.finish)
            }
        }

        debugNavigationController.addChild(debugController)
        router.present(debugNavigationController, modalPresentationStyle: .fullScreen, animated: true)
    }
}
