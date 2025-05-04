import Swinject
import SwinjectAutoregistration
import CoreNavigation
import UserInterface
import Services
import Shared

final class SavedRecipesAssembly: Assembly, Identifiable {

    var id: String = "SavedRecipesAssembly"

    func assemble(container: Container) {
        container.autoregister(
            SavedRecipesCoordinator.self,
            argument: RouterInterface.self,
            initializer: SavedRecipesCoordinator.init
        )

        container.register(SavedRecipesController.self) { resolver in
            let viewModel = SavedRecipesPageViewModel(
                savedRecipesService: resolver ~> SavedRecipesServiceInterface.self
            )
            let controller = SavedRecipesController(viewModel: viewModel)
            return controller
        }

        container.register(RecipeCollectionController.self) { resolver, config in
            let viewModel = RecipeCollectionPageViewModel(config: config)
            let controller = RecipeCollectionController(viewModel: viewModel)
            return controller
        }
    }
}
