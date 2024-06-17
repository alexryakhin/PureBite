import Swinject
import SwinjectAutoregistration
import UIKit.UIWindow

final class StartUpAssembly: Assembly, Identifiable {

    let id = "StartUpAssembly"

    weak var window: UIWindow!

    init(window: UIWindow) {
        self.window = window
    }

    func assemble(container: Container) {
        container.register(NavigationController.self) { _ in
            NavigationController(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        }

        container.register(Router.self, name: RouterName.root) { resolver in
            let navigationController = resolver ~> NavigationController.self
            return Router(rootController: navigationController)
        }

        container.register(LaunchFlowCheckerAbstract.self) { resolver in
            let session = (resolver ~> ServiceLayer.self).session
            return LaunchFlowChecker(session: session)
        }

        container.register(AppCoordinator.self) { resolver in
            let persistent = (resolver ~> ServiceLayer.self).persistent
            let router = resolver ~> (Router.self, name: RouterName.root)
            return AppCoordinator(window: self.window, router: router)
        }
        .inObjectScope(.container)
    }

    func loaded(resolver: Resolver) {
        debug(String(describing: type(of: self)), "is loaded")
    }
}
