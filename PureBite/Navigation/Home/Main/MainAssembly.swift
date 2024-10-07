import Swinject
import SwinjectAutoregistration

final class MainAssembly: @preconcurrency Assembly, Identifiable {
    
    var id: String = "MainAssembly"

    @MainActor
    func assemble(container: Container) {
        container.autoregister(MainCoordinator.self, argument: Router.self, initializer: MainCoordinator.init)

        container.register(MainPageViewController.self) { resolver in
            let viewModel = MainPageViewModel(
                spoonacularNetworkService: resolver ~> SpoonacularNetworkServiceInterface.self
            )
            let controller = MainPageViewController(viewModel: viewModel)
            return controller
        }
    }
}
