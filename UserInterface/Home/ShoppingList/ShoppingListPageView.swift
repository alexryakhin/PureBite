import SwiftUI
import Combine

public struct ShoppingListPageView: View {

    // MARK: - Private properties

    @ObservedObject public var viewModel: ShoppingListPageViewModel

    var shoppingListItems: [ShoppingListItem] {
        viewModel.shoppingListItems.filter { item in
            if viewModel.searchTerm.isNotEmpty {
                item.ingredient.name.localizedCaseInsensitiveContains(viewModel.searchTerm)
            } else {
                true
            }
        }
    }

    // MARK: - Initialization

    public init(
        viewModel: ShoppingListPageViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        List {
            Section {
                ForEach(shoppingListItems) { item in
                    ShoppingListCellView(item: item) {
                        viewModel.handle(
                            .toggleCheck(shoppingListItemID: item.id)
                        )
                    }
                }
                .onDelete { offsets in
                    offsets.map { viewModel.shoppingListItems[$0] }.forEach { item in
                        viewModel.handle(.deleteFromShoppingList(shoppingListItemID: item.id))
                    }
                }
            }
            Section {
                LazyListLoadView(
                    viewModel.searchResults,
                    fetchStatus: viewModel.fetchStatus,
                    canLoadNextPage: viewModel.canLoadNextPage
                ) {
                    viewModel.handle(.loadNextPage)
                } itemView: { ingredient in
                    SearchIngredientCellView(ingredient: ingredient) {
                        viewModel.selectedSearchResultToAddToShoppingList = ingredient
                    }
                } initialView: {
                    if shoppingListItems.count < 5 {
                        Button("Search for '\(viewModel.searchTerm)'") {
                            viewModel.handle(.search)
                        }
                    }
                } initialLoadingView: {
                    Text("Loading...")
                } nextPageLoadingErrorView: {
                    Text("Error loading next page...")
                } emptyDataView: {
                    Text("Nothing found...")
                }
            } header: {
                switch viewModel.fetchStatus {
                case .firstPageLoadingError, .idleNoData, .idle, .loadingFirstPage:
                    Text("Search results")
                default:
                    EmptyView()
                }
            }
        }
        .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            viewModel.handle(.search)
        }
        .sheet(item: $viewModel.selectedSearchResultToAddToShoppingList) { ingredient in
            AddToShoppingListSheetView(model: ingredient) { unit, amount in
                viewModel.handle(.addToShoppingList(ingredient: ingredient, unit: unit, amount: amount))
            }
            .presentationDetents([.medium])
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An error occurred")
        }
    }
}

struct AddToShoppingListSheetView: View {

    @Environment(\.dismiss) var dismiss

    @State var selectedUnit: String = ""
    @State var amount: String = ""

    var model: IngredientSearchInfo
    var onAdd: (String, Double) -> Void

    var amountValue: Double {
        guard let amount = Double(amount) else { return .zero }
        return amount
    }

    init(model: IngredientSearchInfo, onAdd: @escaping (String, Double) -> Void) {
        self.model = model
        self.onAdd = onAdd
        _selectedUnit = State(initialValue: model.possibleUnits.first.orEmpty)
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(model.possibleUnits, id: \.self) {
                            Text($0.capitalized)
                                .tag($0)
                        }
                    }
                }

                Section {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Amount")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        onAdd(selectedUnit, amountValue)
                    }
                    .disabled(amountValue.isZero)
                    .bold()
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationTitle(model.name.capitalized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
