import Combine
import Swinject
import SwinjectAutoregistration

final class EntranceCoordinator: Coordinator {

    enum Event {
        case successLoggingIn
        case failureLoggingIn
        case logOut
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private Properties

    private var innerRouter: RouterAbstract!

    // MARK: - Initialization

    required init(router: RouterAbstract) {
        super.init(router: router)
    }

    override func start() {
        let sessionStorage = resolver ~> SessionStorageAbstract.self

        if sessionStorage.pin == nil {
            onEvent?(.successLoggingIn)
        } else {
            showEnterPin()
        }
    }

    // MARK: - Private Methods

    private func showEnterPin() {
//        let controller = resolver ~> EnterPinController.self
//
//        controller.onEvent = { [weak self] event in
//            switch event {
//            case .success:
//                self?.onEvent?(.successLoggingIn)
//            case .failure:
//                self?.onEvent?(.failureLoggingIn)
//            case .logOut:
//                self?.onEvent?(.logOut)
//            }
//        }
//
//        router.push(controller)
        
        onEvent?(.successLoggingIn)
    }
}
