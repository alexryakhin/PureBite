import Swinject
import SwinjectAutoregistration

final class SavedAssembly: Assembly, Identifiable {

    var id: String = "SavedAssembly"

    func assemble(container: Container) {
        container.autoregister(SavedCoordinator.self, argument: RouterAbstract.self, initializer: SavedCoordinator.init)

        container.register(SavedController.self) { resolver in
            let viewModel = SavedViewModel(
                favoritesService: resolver ~> FavoritesServiceInterface.self
            )
            let controller = SavedController(viewModel: viewModel)
            return controller
        }
    }
}
