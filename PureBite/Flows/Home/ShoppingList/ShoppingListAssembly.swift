import CoreNavigation
import Services
import UI
import Swinject
import SwinjectAutoregistration

final class ShoppingListAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(ShoppingListCoordinator.self, argument: RouterAbstract.self, initializer: ShoppingListCoordinator.init)
    }
}
