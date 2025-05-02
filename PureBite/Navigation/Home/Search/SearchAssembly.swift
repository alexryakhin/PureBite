import Swinject
import SwinjectAutoregistration
import CoreNavigation
import UserInterface
import Services
import Shared

final class RecipeSearchAssembly: Assembly, Identifiable {

    var id: String = "RecipeSearchAssembly"

    func assemble(container: Container) {
        container.autoregister(RecipeSearchCoordinator.self, argument: RouterInterface.self, initializer: RecipeSearchCoordinator.init)

        container.register(RecipeSearchController.self) { resolver in
            let viewModel = RecipeSearchPageViewModel(recipeSearchRepository: resolver ~> RecipeSearchRepository.self)
            let controller = RecipeSearchController(viewModel: viewModel)
            return controller
        }
    }
}
