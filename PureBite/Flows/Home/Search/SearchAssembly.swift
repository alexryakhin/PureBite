import CoreNavigation
import Services
import UI
import Swinject
import SwinjectAutoregistration

final class SearchAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(SearchCoordinator.self, argument: RouterAbstract.self, initializer: SearchCoordinator.init)
    }
}
