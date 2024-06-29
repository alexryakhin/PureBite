import CoreNavigation
import Services
import UI
import Swinject
import SwinjectAutoregistration

final class ProfileAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(ProfileCoordinator.self, argument: RouterAbstract.self, initializer: ProfileCoordinator.init)
    }
}
