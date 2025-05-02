import Swinject
import SwinjectAutoregistration
import CoreNavigation
import UserInterface
import Services
import Shared

final class ShoppingListAssembly: Assembly, Identifiable {

    var id: String = "ShoppingListAssembly"

    func assemble(container: Container) {
        container.autoregister(ShoppingListCoordinator.self, argument: RouterInterface.self, initializer: ShoppingListCoordinator.init)

        container.register(ShoppingListController.self) { resolver in
            let viewModel = ShoppingListPageViewModel(
                repository: resolver ~> ShoppingListRepositoryInterface.self
            )
            let controller = ShoppingListController(viewModel: viewModel)
            return controller
        }
    }
}
