import Swinject
import SwinjectAutoregistration

final class AuthAssembly: Assembly, Identifiable {

    let id = "AuthAssembly"

    func assemble(container: Container) {

        container.autoregister(AuthCoordinator.self, argument: RouterAbstract.self, initializer: AuthCoordinator.init)

        // MARK: - Auth

        container.register(AuthorizeController.self) { resolver in
            let viewModel = AuthorizeViewModel(arg: 0)
            let controller = AuthorizeController(viewModel: viewModel)
            return controller
        }
    }
}
