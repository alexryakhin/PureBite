import Swinject
import SwinjectAutoregistration

final class HomeAssembly: Assembly, Identifiable {

    let id = "HomeAssembly"

    func assemble(container: Container) {
        container.autoregister(TabController.self, initializer: TabController.init)

        container.autoregister(HomeCoordinator.self, argument: RouterAbstract.self, initializer: HomeCoordinator.init)
    }
}
