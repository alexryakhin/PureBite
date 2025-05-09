import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UserInterface
import Shared

final class HomeCoordinator: Coordinator {

    public enum Event {
        case authorize
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - AuthFlowCoordinator

    required init(router: RouterInterface) {
        super.init(router: router)
    }

    override func start() {
        showTabController()
    }

    private func showTabController() {
        guard topController(ofType: TabController.self) == nil else { return }

        let mainNavigationController = assignMainCoordinator()
        let recipeSearchNavigationController = assignRecipeSearchCoordinator()
        let savedRecipesNavigationController = assignSavedRecipesCoordinator()
        let shoppingListNavigationController = assignShoppingListCoordinator()
//        let profileNavigationController = assignProfileCoordinator()

        let controller = resolver ~> TabController.self

        controller.controllers = [
            mainNavigationController,
            recipeSearchNavigationController,
            savedRecipesNavigationController,
            shoppingListNavigationController,
            // TODO: add later
//            profileNavigationController
        ]

        router.setRootModule(controller)
    }

    private func assignMainCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: MainAssembly())

        // Main flow coordinator
        guard let mainCoordinator = child(ofType: MainCoordinator.self)
                ?? resolver.resolve(MainCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate MainCoordinator") }
        mainCoordinator.start()

        mainCoordinator.onEvent = { [weak self] event in
            switch event {
            case .authorize:
                self?.onEvent?(.authorize)
            case .openSearchScreen:
                self?.switchTabToRecipeSearchController()
            }
        }

        let mainNavigationController = mainCoordinator.mainNavigationController

        if !contains(child: MainCoordinator.self) {
            addDependency(mainCoordinator)
        }

        return mainNavigationController
    }

    private func assignRecipeSearchCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: RecipeSearchAssembly())

        // Search flow coordinator
        guard let searchCoordinator = child(ofType: RecipeSearchCoordinator.self)
                ?? resolver.resolve(RecipeSearchCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate SearchCoordinator") }
        searchCoordinator.start()

        searchCoordinator.onEvent = { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        let searchNavigationController = searchCoordinator.searchNavigationController

        if !contains(child: RecipeSearchCoordinator.self) {
            addDependency(searchCoordinator)
        }

        return searchNavigationController
    }

    private func assignSavedRecipesCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: SavedRecipesAssembly())

        // Saved flow coordinator
        guard let savedRecipesCoordinator = child(ofType: SavedRecipesCoordinator.self)
                ?? resolver.resolve(SavedRecipesCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate SavedRecipesCoordinator") }
        savedRecipesCoordinator.start()

        savedRecipesCoordinator.onEvent = { [weak self] event in
            switch event {
            case .finish:
                break
            }
        }

        let savedRecipesNavigationController = savedRecipesCoordinator.savedRecipesNavigationController

        if !contains(child: SavedRecipesCoordinator.self) {
            addDependency(savedRecipesCoordinator)
        }

        return savedRecipesNavigationController
    }

    private func assignShoppingListCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: ShoppingListAssembly())

        // ShoppingList flow coordinator
        guard let shoppingListCoordinator = child(ofType: ShoppingListCoordinator.self)
                ?? resolver.resolve(ShoppingListCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate ShoppingListCoordinator") }
        shoppingListCoordinator.start()

        shoppingListCoordinator.onEvent = { [weak self] event in
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

        profileCoordinator.onEvent = { [weak self] event in
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

    private func switchTabToRecipeSearchController() {
        if let tabController = router.firstChild(TabController.self) {
            tabController.controllers.enumerated().forEach { index, controller in
                if let searchController = controller.children.first(RecipeSearchController.self) {
                    tabController.forceSwitchTab(to: index)
                    searchController.activateSearch(query: nil)
                }
            }
        }
    }
}
