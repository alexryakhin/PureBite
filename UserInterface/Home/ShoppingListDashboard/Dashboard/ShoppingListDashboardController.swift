import UIKit
import Combine
import SwiftUI
import Core
import CoreUserInterface
import Shared

public final class ShoppingListDashboardController: PageViewController<ShoppingListDashboardPageView>, NavigationBarVisible {

    public enum Event {
        case showItemInformation(IngredientDetailsPageViewModel.Config)
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: ShoppingListDashboardPageViewModel
    private let shoppingListViewModel: ShoppingListPageViewModel
    private let ingredientSearchViewModel: IngredientSearchPageViewModel
    private let groceryProductSearchViewModel: GroceryProductSearchPageViewModel

    // MARK: - Initialization

    public init(
        viewModel: ShoppingListDashboardPageViewModel,
        shoppingListViewModel: ShoppingListPageViewModel,
        ingredientSearchViewModel: IngredientSearchPageViewModel,
        groceryProductSearchViewModel: GroceryProductSearchPageViewModel
    ) {
        self.viewModel = viewModel
        self.shoppingListViewModel = shoppingListViewModel
        self.ingredientSearchViewModel = ingredientSearchViewModel
        self.groceryProductSearchViewModel = groceryProductSearchViewModel
        super.init(
            rootView: ShoppingListDashboardPageView(
                viewModel: viewModel,
                shoppingListViewModel: shoppingListViewModel,
                ingredientSearchViewModel: ingredientSearchViewModel,
                groceryProductSearchViewModel: groceryProductSearchViewModel
            )
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.shoppingList.item
        setupBindings()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Shopping List"
        resetNavBarAppearance()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] event in
            switch event {
//            case .showItemInformation(let config):
//                self?.onEvent?(.showItemInformation(config))
            case .search(let query):
                self?.ingredientSearchViewModel.handle(.search(query))
                self?.groceryProductSearchViewModel.handle(.search(query))
            }
        }
    }
}
