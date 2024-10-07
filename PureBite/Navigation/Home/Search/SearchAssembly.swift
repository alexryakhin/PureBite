import Swinject
import SwinjectAutoregistration

final class SearchAssembly: @preconcurrency Assembly, Identifiable {

    var id: String = "SearchAssembly"

    @MainActor
    func assemble(container: Container) {
        container.autoregister(SearchCoordinator.self, argument: Router.self, initializer: SearchCoordinator.init)

        container.register(SearchPageViewController.self) { resolver in
            let viewModel = SearchPageViewModel(spoonacularNetworkService: resolver ~> SpoonacularNetworkServiceInterface.self)
            let controller = SearchPageViewController(viewModel: viewModel)
            return controller
        }
    }
}
