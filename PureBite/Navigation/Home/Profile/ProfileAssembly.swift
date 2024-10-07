import Swinject
import SwinjectAutoregistration

final class ProfileAssembly: @preconcurrency Assembly, Identifiable {

    var id: String = "ProfileAssembly"

    @MainActor
    func assemble(container: Container) {
        container.autoregister(ProfileCoordinator.self, argument: Router.self, initializer: ProfileCoordinator.init)

        container.register(ProfilePageViewController.self) { resolver in
            let viewModel = ProfilePageViewModel(arg: 0)
            let controller = ProfilePageViewController(viewModel: viewModel)
            return controller
        }
    }
}
