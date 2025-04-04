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
import CoreNavigation
import CoreUserInterface
import Shared

final class AppCoordinator: BaseCoordinator {

#if DEBUG
    let router: RouterInterface
    let resolver: Resolver
#else
    private let router: RouterInterface
    private let resolver: Resolver
#endif

    private let window: BaseWindow

    private var cancellables = Set<AnyCancellable>()

    init(
        window: BaseWindow,
        router: RouterInterface
    ) {
        self.window = window
        self.router = router

        resolver = DIContainer.shared.resolver

        super.init()

        if window.isKeyWindow == false {
            window.rootViewController = router.rootController
            window.makeKeyAndVisible()
        }

        registerAssemblies()
        setupBindings()
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

    private func registerAssemblies() {
        DIContainer.shared.assemble(assembly: DebugAssembly())
    }

    private func setupBindings() {
        #if DEBUG
        window.onShakeDetected = { [weak self] in
            self?.presentDebugPanel()
        }
        #endif
    }

    private func presentDebugPanel() {
        let debugCoordinator = resolver ~> (DebugCoordinator.self, argument: router)

        debugCoordinator.onEvent = { [weak self, weak debugCoordinator] event in
            switch event {
            case .finish:
                debugCoordinator?.router.dismissModule()
                self?.removeDependency(debugCoordinator)
            }
        }

        addDependency(debugCoordinator)

        debugCoordinator.start()
    }
}
