import Swinject
import SwinjectAutoregistration

final class HomeAssembly: Assembly, Identifiable {

    let id = "HomeAssembly"

    func assemble(container: Container) {
        container.autoregister(TabController.self, initializer: TabController.init)

        container.autoregister(HomeCoordinator.self, argument: RouterAbstract.self, initializer: HomeCoordinator.init)

        container.register(RecipeDetailsController.self) { resolver, config in
            let viewModel = RecipeDetailsViewModel(
                config: config,
                spoonacularNetworkService: resolver ~> SpoonacularNetworkServiceInterface.self,
                favoritesService: resolver ~> FavoritesServiceInterface.self
            )
            let controller = RecipeDetailsController(viewModel: viewModel)
            return controller
        }
    }
}
