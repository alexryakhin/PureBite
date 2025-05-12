import SwiftUI
import Combine
import Core
import CoreUserInterface
import Shared
import Services

public struct ShoppingListDashboardPageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: ShoppingListDashboardPageViewModel
    @ObservedObject public var shoppingListViewModel: ShoppingListPageViewModel
    @ObservedObject public var ingredientSearchViewModel: IngredientSearchPageViewModel
    @ObservedObject public var groceryProductSearchViewModel: GroceryProductSearchPageViewModel

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
    }

    // MARK: - Views

    public var contentView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 24) {
                ShoppingListDashboardWidgetView(viewModel: shoppingListViewModel)
                IngredientSearchDashboardWidgetView(viewModel: ingredientSearchViewModel)
                GroceryProductSearchDashboardWidgetView(viewModel: groceryProductSearchViewModel)
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            viewModel.handle(.search)
        }
    }
}
