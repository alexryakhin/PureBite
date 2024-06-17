#if DEBUG
import SwinjectAutoregistration

extension AppCoordinator: DebugNavigationDelegate {

    // swiftlint:disable:next cyclomatic_complexity
    func showScreen(_ screen: DebugScreen) {
        switch screen {
        case .homeMain:
            runHomeFlow()
        }
    }

    func startFromDebug() {
        firstStart = true
        start()
    }

    func presentFlow(_ config: FlowScreensConfig) {
        let controller = FlowScreensController(config)
        controller.onChooseScreen = { [weak self] screen in
            self?.showScreen(screen)
        }
        router.present(controller)
    }
}
#endif
