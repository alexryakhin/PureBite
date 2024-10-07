//
//  AppCoordinator.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/29/24.
//

import SwiftUI
import Swinject
import SwinjectAutoregistration
import Combine

final class AppCoordinator: BaseCoordinator {

#if DEBUG
    let router: RouterInterface
    let resolver: Resolver
    let launchChecker: LaunchFlowCheckerInterface
#else
    private let router: RouterInterface
    private let resolver: Resolver
    private let launchChecker: LaunchFlowCheckerInterface
#endif

    private let window: UIWindow
    private let persistent: Persistent
    private lazy var appSession = resolver ~> AppSession.self
    private lazy var deepLinkService = resolver ~> DeepLinkServiceInterface.self

    private var cancellables = Set<AnyCancellable>()

    var isLogged = false

    init(
        window: UIWindow,
        router: RouterInterface
    ) {
        self.window = window
        self.router = router

        resolver = DIContainer.shared.resolver

        persistent = resolver ~> Persistent.self
        launchChecker = resolver ~> LaunchFlowCheckerInterface.self

        super.init()

        // Only after checking first launch!
        saveLastUsedAppVersion()

        if window.isKeyWindow == false {
            window.rootViewController = router.rootController
            window.makeKeyAndVisible()
        }

        registerAssemblies()
    }

    override func start() {
        debug("AppCoordinator start")
        if let existingHomeCoordinator = child(ofType: HomeCoordinator.self) {
            existingHomeCoordinator.start()
            return
        }

        DIContainer.shared.assemble(assembly: HomeAssembly())
        let homeCoordinator = resolver ~> (HomeCoordinator.self, argument: router)

        homeCoordinator.onEvent = { [weak self] event in
            switch event {
            case .authorize:
                // TODO: authorize
                break
            }
        }

        addDependency(homeCoordinator)

        homeCoordinator.start()
    }


    private func saveLastUsedAppVersion() {
        if let appVersion = GlobalConstant.appVersion {
            persistent.set(.lastUsedAppVersion(appVersion))
        }
    }

    private func registerAssemblies() {
//        DIContainer.shared.assemble(assembly: AuthAssembly())
    }
}
