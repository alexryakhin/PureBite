import Combine
import Swinject
import SwinjectAutoregistration
import EnumsMacros
import EventSenderMacro

@EventSender
final class EntranceCoordinator: Coordinator {

    @PlainedEnum
    enum Event {
        case successLoggingIn
        case failureLoggingIn
        case logOut
    }

    // MARK: - Private Properties

    private var innerRouter: RouterAbstract!

    // MARK: - Initialization

    required init(router: RouterAbstract) {
        super.init(router: router)
    }

    override func start() {
        let sessionStorage = resolver ~> SessionStorageAbstract.self

        if sessionStorage.pin == nil {
            send(event: .successLoggingIn)
        } else {
            showEnterPin()
        }
    }

    // MARK: - Private Methods

    private func showEnterPin() {
//        let controller = resolver ~> EnterPinController.self
//
//        controller.on { [weak self] event in
//            switch event {
//            case .success:
//                self?.send(event: .successLoggingIn)
//            case .failure:
//                self?.send(event: .failureLoggingIn)
//            case .logOut:
//                self?.send(event: .logOut)
//            }
//        }
//
//        router.push(controller)
        
        send(event: .successLoggingIn)
    }
}
