import Swinject
import SwinjectAutoregistration

final class ShoppingListAssembly: @preconcurrency Assembly, Identifiable {

    var id: String = "ShoppingListAssembly"

    @MainActor
    func assemble(container: Container) {
        container.autoregister(ShoppingListCoordinator.self, argument: Router.self, initializer: ShoppingListCoordinator.init)

        container.register(ShoppingListPageViewController.self) { resolver in
            let viewModel = ShoppingListPageViewModel(arg: 0)
            let controller = ShoppingListPageViewController(viewModel: viewModel)
            return controller
        }
    }
}
