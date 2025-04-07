import Swinject
import SwinjectAutoregistration
import CoreUserInterface
import CoreNavigation
import UserInterface
import Services
import Shared

final class HomeAssembly: Assembly, Identifiable {

    let id = "HomeAssembly"

    func assemble(container: Container) {
        container.autoregister(TabController.self, initializer: TabController.init)

        container.autoregister(HomeCoordinator.self, argument: RouterInterface.self, initializer: HomeCoordinator.init)

        container.register(RecipeDetailsController.self) { resolver, recipeShortInfo in
            let viewModel = RecipeDetailsPageViewModel(
                recipeShortInfo: recipeShortInfo,
                spoonacularNetworkService: resolver ~> SpoonacularNetworkServiceInterface.self,
                favoritesService: resolver ~> FavoritesServiceInterface.self
            )
            let controller = RecipeDetailsController(viewModel: viewModel)
            return controller
        }

        container.register(IngredientDetailsController.self) { resolver, config in
            let viewModel = IngredientDetailsPageViewModel(
                config: config,
                spoonacularNetworkService: resolver ~> SpoonacularNetworkServiceInterface.self,
                favoritesService: resolver ~> FavoritesServiceInterface.self
            )
            let controller = IngredientDetailsController(viewModel: viewModel)
            return controller
        }
    }
}
