import Combine
import Swinject
import SwinjectAutoregistration
import LocalAuthentication

final class AuthCoordinator: Coordinator {

    enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Read-Only properties
    private(set) var shouldBePopped: Bool = false

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
    private let appSession: AppSession = resolver ~> AppSession.self
    private var rootModule: Presentable?

    // MARK: - AuthFlowCoordinator

    required init(router: RouterAbstract) {
        super.init(router: router)
    }

    // MARK: - Public Methods

    func start(with deepLink: DeepLink? = nil) {
        if let deepLink {
            handle(deepLink: deepLink)
        } else {
            showAuthScreen()
        }
    }
    
    override func start() {
        showAuthScreen()
    }

    // MARK: - Private Methods

    func handle(deepLink: DeepLink) {
        switch deepLink {
        case .signInFromProfile:
            shouldBePopped = true
            showAuthScreen()
        default: break
        }
    }

    // MARK: - Auth

    private func showAuthScreen() {
        guard topController(ofType: AuthorizeController.self) == nil else { return }
        let controller = resolver.resolve(AuthorizeController.self)
        
        controller?.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.onEvent?(.finish)
            }
        }

        if shouldBePopped {
            router.push(controller)
            return
        }

        if let presentable = router.firstChild(AuthorizeController.self) {
            router.popToModule(presentable)
        } else {
            router.push(controller)
        }
    }

    func popToHome() {
        let tabController = router.rootController?.viewControllers.first
        router.popToModule(tabController)
    }
}
