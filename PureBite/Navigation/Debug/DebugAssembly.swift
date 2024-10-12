import Swinject
import SwinjectAutoregistration

final class DebugAssembly: @preconcurrency Assembly, Identifiable {

    var id: String = "DebugAssembly"

    @MainActor
    func assemble(container: Container) {
        container.autoregister(DebugCoordinator.self, argument: RouterInterface.self, initializer: DebugCoordinator.init)

        container.register(DebugPageViewController.self) { resolver in
            let viewModel = DebugPageViewModel(featureToggleService: resolver ~> FeatureToggleServiceInterface.self)
            let controller = DebugPageViewController(viewModel: viewModel)
            return controller
        }
    }
}
