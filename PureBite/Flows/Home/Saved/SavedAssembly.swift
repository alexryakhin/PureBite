import CoreNavigation
import Services
import UI
import Swinject
import SwinjectAutoregistration

final class SavedAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(SavedCoordinator.self, argument: RouterAbstract.self, initializer: SavedCoordinator.init)
    }
}
