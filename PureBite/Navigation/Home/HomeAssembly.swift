import Swinject
import SwinjectAutoregistration

final class HomeAssembly: @preconcurrency Assembly, Identifiable {

    let id = "HomeAssembly"

    @MainActor
    func assemble(container: Container) {
        container.autoregister(TabController.self, initializer: TabController.init)

        container.autoregister(HomeCoordinator.self, argument: RouterInterface.self, initializer: HomeCoordinator.init)

        container.register(RecipeDetailsPageViewController.self) { resolver, config in
            let viewModel = RecipeDetailsPageViewModel(
                config: config,
                spoonacularNetworkService: resolver ~> SpoonacularNetworkServiceInterface.self,
                favoritesService: resolver ~> FavoritesServiceInterface.self
            )
            let controller = RecipeDetailsPageViewController(viewModel: viewModel)
            return controller
        }
    }
}
