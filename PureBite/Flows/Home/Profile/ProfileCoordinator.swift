import Core
import CoreNavigation
import Services
import UI
import Combine
import Swinject
import SwinjectAutoregistration
import EnumsMacros
import EventSenderMacro

@EventSender
final class ProfileCoordinator: Coordinator {

    @PlainedEnum
    enum Event {
        case finish
    }

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self

    private var innerRouter: RouterAbstract!

    // MARK: - Initialization

    required init(router: RouterAbstract) {
        super.init(router: router)
    }

    override func start() {
    }

    // MARK: - Private Methods
}
