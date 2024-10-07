import Swinject
import SwinjectAutoregistration

final class SavedAssembly: @preconcurrency Assembly, Identifiable {

    var id: String = "SavedAssembly"

    @MainActor
    func assemble(container: Container) {
        container.autoregister(SavedCoordinator.self, argument: Router.self, initializer: SavedCoordinator.init)

        container.register(SavedPageViewController.self) { resolver in
            let viewModel = SavedPageViewModel(
                favoritesService: resolver ~> FavoritesServiceInterface.self
            )
            let controller = SavedPageViewController(viewModel: viewModel)
            return controller
        }

        container.register(RecipeCollectionPageViewController.self) { resolver, config in
            let viewModel = RecipeCollectionPageViewModel(config: config)
            let controller = RecipeCollectionPageViewController(viewModel: viewModel)
            return controller
        }
    }
}
