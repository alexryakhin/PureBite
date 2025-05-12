import Swinject
import SwinjectAutoregistration
import CoreNavigation
import UserInterface
import Services
import Shared

final class ShoppingListDashboardAssembly: Assembly, Identifiable {

    var id: String = "ShoppingListDashboardAssembly"

    func assemble(container: Container) {
        container.autoregister(ShoppingListDashboardCoordinator.self, argument: RouterInterface.self, initializer: ShoppingListDashboardCoordinator.init)

        container.register(ShoppingListPageViewModel.self) { resolver in
            ShoppingListPageViewModel(
                shoppingListRepository: resolver ~> ShoppingListRepositoryInterface.self
            )
        }

        container.register(ShoppingListController.self) { resolver in
            ShoppingListController(viewModel: resolver ~> ShoppingListPageViewModel.self)
        }

        container.register(IngredientSearchPageViewModel.self) { resolver in
            IngredientSearchPageViewModel(
                ingredientSearchRepository: resolver ~> IngredientSearchRepository.self
            )
        }

        container.register(IngredientSearchController.self) { resolver in
            IngredientSearchController(viewModel: resolver ~> IngredientSearchPageViewModel.self)
        }

        container.register(GroceryProductSearchPageViewModel.self) { resolver in
            GroceryProductSearchPageViewModel(
                groceryProductSearchRepository: resolver ~> GroceryProductSearchRepository.self
            )
        }

        container.register(GroceryProductSearchController.self) { resolver in
            GroceryProductSearchController(viewModel: resolver ~> GroceryProductSearchPageViewModel.self)
        }

        container.register(ShoppingListDashboardController.self) { resolver in
            let viewModel = ShoppingListDashboardPageViewModel()
            let controller = ShoppingListDashboardController(
                viewModel: viewModel,
                shoppingListViewModel: resolver ~> ShoppingListPageViewModel.self,
                ingredientSearchViewModel: resolver ~> IngredientSearchPageViewModel.self,
                groceryProductSearchViewModel: resolver ~> GroceryProductSearchPageViewModel.self
            )
            return controller
        }
    }
}
