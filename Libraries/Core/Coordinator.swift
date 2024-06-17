import Swinject
import SwinjectAutoregistration

// swiftlint:disable:next final_class
open class Coordinator: BaseCoordinator, RoutableCoordinator {

    public static let resolver: Resolver = DIContainer.shared.resolver
    public let resolver: Resolver = DIContainer.shared.resolver

    public let router: RouterAbstract

    public required init(router: RouterAbstract) {
        self.router = router
    }

    open func topController<T>(ofType _: T.Type) -> T? {
        return lastController() as? T
    }

    open func lastController() -> UIViewController? {
        router.rootController?.viewControllers.last
    }
}
