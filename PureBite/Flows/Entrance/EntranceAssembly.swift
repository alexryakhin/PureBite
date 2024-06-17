import Swinject
import SwinjectAutoregistration

final class EntranceAssembly: Assembly, Identifiable {

    let id = "EntranceAssembly"

    func assemble(container: Container) {
        container.autoregister(
            EntranceCoordinator.self,
            argument: RouterAbstract.self,
            initializer: EntranceCoordinator.init
        )
    }
}
