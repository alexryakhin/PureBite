import Swinject
import SwinjectAutoregistration

final class SearchAssembly: Assembly, Identifiable {

    var id: String = "SearchAssembly"

    func assemble(container: Container) {
        container.autoregister(SearchCoordinator.self, argument: RouterAbstract.self, initializer: SearchCoordinator.init)

        container.register(SearchController.self) { resolver in
            let viewModel = SearchViewModel(arg: 0)
            let controller = SearchController(viewModel: viewModel)
            return controller
        }
    }
}
