#if DEBUG
import Swinject
import SwinjectAutoregistration

extension AppCoordinator {

    func showDebugRoutingScreen() {
        firstStart = false
        let appSession = resolver ~> AppSession.self
        let controller = DebugRoutingController(appSession: appSession)
        controller.onAction = { [weak self] action in
            self?.handleDebugAction(action)
        }
        router.setRootModule(controller)
    }

    func handleDebugAction(_ action: DebugAction) {
        switch action {
        case .startNormally:
            start()

        case .startEntrance:
            runEntranceFlow()

        case .skipAuth:
            launchChecker.overriddenFlow = .home
            runHomeFlow()

        case .showScreen(let screen):
            showScreen(screen)

        case .startFlow(let flow):
            guard let flowConfig = flow.flowScreensConfig else { break }
            presentFlow(flowConfig)
        }
    }
}
#endif
