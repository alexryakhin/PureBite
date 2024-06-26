import Combine
import EventSenderMacro
import EnumsMacros
import Swinject
import SwinjectAutoregistration

@EventSender
final class HomeCoordinator: Coordinator {

    @PlainedEnum
    enum Event {
        case authorize
    }

    private let persistent: Persistent = resolver ~> Persistent.self
    private let appSession: AppSession = resolver ~> AppSession.self

    // MARK: - AuthFlowCoordinator

    required init(router: RouterAbstract) {
        super.init(router: router)
    }

    override func start() {
        showTabController()
    }

    private func showTabController() {
        guard topController(ofType: TabController.self) == nil else { return }

        let mainNavigationController = assignMainCoordinator()
        let searchNavigationController = assignSearchCoordinator()
        let savedNavigationController = assignSavedCoordinator()
        let shoppingListNavigationController = assignShoppingListCoordinator()
        let profileNavigationController = assignProfileCoordinator()

        let controller = resolver ~> TabController.self

        controller.controllers = [
            mainNavigationController,
            searchNavigationController,
            savedNavigationController,
            shoppingListNavigationController,
            profileNavigationController
        ]

        router.setRootModule(controller, transitionOptions: [])
    }

    private func assignMainCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: MainAssembly())

        // Main flow coordinator
        guard let mainCoordinator = child(ofType: MainCoordinator.self)
                ?? resolver.resolve(MainCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate MainCoordinator") }
        mainCoordinator.start()

        mainCoordinator.on { [weak self] event in
            switch event {
            case .authorize:
                self?.send(event: .authorize)
            }
        }

        let mainNavigationController = mainCoordinator.mainNavigationController

        if !contains(child: MainCoordinator.self) {
            addDependency(mainCoordinator)
        }

        return mainNavigationController
    }

    private func assignSearchCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: SearchAssembly())

        // Search flow coordinator
        guard let searchCoordinator = child(ofType: SearchCoordinator.self)
                ?? resolver.resolve(SearchCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate SearchCoordinator") }
        searchCoordinator.start()

        searchCoordinator.on { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        let searchNavigationController = searchCoordinator.searchNavigationController

        if !contains(child: SearchCoordinator.self) {
            addDependency(searchCoordinator)
        }

        return searchNavigationController
    }

    private func assignSavedCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: SavedAssembly())

        // Saved flow coordinator
        guard let savedCoordinator = child(ofType: SavedCoordinator.self)
                ?? resolver.resolve(SavedCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate SavedCoordinator") }
        savedCoordinator.start()

        savedCoordinator.on { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        let savedNavigationController = savedCoordinator.savedNavigationController

        if !contains(child: SavedCoordinator.self) {
            addDependency(savedCoordinator)
        }

        return savedNavigationController
    }

    private func assignShoppingListCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: ShoppingListAssembly())

        // ShoppingList flow coordinator
        guard let shoppingListCoordinator = child(ofType: ShoppingListCoordinator.self)
                ?? resolver.resolve(ShoppingListCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate ShoppingListCoordinator") }
        shoppingListCoordinator.start()

        shoppingListCoordinator.on { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        let shoppingListNavigationController = shoppingListCoordinator.shoppingListNavigationController

        if !contains(child: ShoppingListCoordinator.self) {
            addDependency(shoppingListCoordinator)
        }

        return shoppingListNavigationController
    }

    private func assignProfileCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: ProfileAssembly())

        // Profile flow coordinator
        guard let profileCoordinator = child(ofType: ProfileCoordinator.self)
                ?? resolver.resolve(ProfileCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate ProfileCoordinator") }
        profileCoordinator.start()

        profileCoordinator.on { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        let profileNavigationController = profileCoordinator.profileNavigationController

        if !contains(child: ProfileCoordinator.self) {
            addDependency(profileCoordinator)
        }

        return profileNavigationController
    }
}
