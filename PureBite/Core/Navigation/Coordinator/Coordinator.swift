//
//  Coordinator.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/6/24.
//

import Swinject
import SwinjectAutoregistration
import UIKit

open class Coordinator: BaseCoordinator, RoutableCoordinator {

    public static let resolver: Resolver = DIContainer.shared.resolver
    public let resolver: Resolver = DIContainer.shared.resolver

    public let router: RouterInterface

    public required init(router: RouterInterface) {
        self.router = router
    }

    open func topController<T>(ofType _: T.Type) -> T? {
        return lastController() as? T
    }

    open func lastController() -> UIViewController? {
        router.rootController?.viewControllers.last
    }
}