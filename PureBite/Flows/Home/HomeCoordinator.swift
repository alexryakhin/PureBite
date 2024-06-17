import Combine
import EventSenderMacro
import EnumsMacros
import Swinject
import SwinjectAutoregistration

@EventSender
final class HomeCoordinator: Coordinator {

    @PlainedEnum
    enum Event {
        case authorize
    }

    private let persistent: Persistent = resolver ~> Persistent.self
    private let appSession: AppSession = resolver ~> AppSession.self

    // MARK: - AuthFlowCoordinator

    required init(router: RouterAbstract) {
        super.init(router: router)
    }

    override func start() {
        showTabController()
    }

    private func showTabController() {
        guard topController(ofType: TabController.self) == nil else { return }

        let mainNavigationController = assignMainCoordinator()
        let controller2 = NavigationController(rootViewController: ViewController())
        let controller3 = NavigationController(rootViewController: ViewController())
        let controller4 = NavigationController(rootViewController: ViewController())
        let controller5 = NavigationController(rootViewController: ViewController())

        let controller = resolver ~> TabController.self

        controller.controllers = [
            mainNavigationController,
            controller2,
            controller3,
            controller4,
            controller5
        ]

        router.setRootModule(controller, transitionOptions: [])
    }

    private func assignMainCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: MainAssembly())

        // Main flow coordinator
        guard let mainCoordinator = child(ofType: MainCoordinator.self)
                ?? resolver.resolve(MainCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate MainCoordinator") }
        mainCoordinator.start()

        mainCoordinator.on { [weak self] event in
            switch event {
            case .authorize:
                self?.send(event: .authorize)
            }
        }

        let mainNavigationController = mainCoordinator.mainNavigationController

        if !contains(child: MainCoordinator.self) {
            addDependency(mainCoordinator)
        }

        return mainNavigationController
    }
}
