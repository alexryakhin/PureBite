import SwiftUI
import Combine

struct ShoppingListPageView: View {
    
    // MARK: - Private properties
    
    @ObservedObject var viewModel: ShoppingListPageViewModel
    @State private var showingAddItemSheet = false
    @State private var showingShoppingMode = false
    @State private var selectedCategory: ShoppingCategory? = nil
    
    private var filteredItems: [ShoppingListItem] {
        viewModel.shoppingListItems.filter { item in
            let matchesSearch = viewModel.searchTerm.isEmpty || 
                item.ingredient.name.localizedCaseInsensitiveContains(viewModel.searchTerm)
            let matchesCategory = selectedCategory == nil || item.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }
    
    private var groupedItems: [ShoppingCategory: [ShoppingListItem]] {
        Dictionary(grouping: filteredItems) { $0.category }
    }
    
    private var sortedCategories: [ShoppingCategory] {
        groupedItems.keys.sorted { $0.rawValue < $1.rawValue }
    }
    
    private var progressPercentage: Double {
        let totalItems = viewModel.shoppingListItems.count
        let checkedItems = viewModel.shoppingListItems.filter(\.isChecked).count
        return totalItems > 0 ? Double(checkedItems) / Double(totalItems) : 0
    }

    init(viewModel: ShoppingListPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if viewModel.shoppingListItems.isEmpty && viewModel.searchResults.isEmpty {
                emptyStateView
            } else {
                // Items List
                itemsListView
                    .if(isPad) { view in
                        view.frame(maxWidth: 640, alignment: .center)
                    }
                    .safeAreaInset(edge: .top) {
                        // Category Filter
                        if !viewModel.shoppingListItems.isEmpty {
                            categoryFilterView
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        // Progress Footer
                        if !viewModel.shoppingListItems.isEmpty {
                            progressFooter
                        }
                    }
            }
        }
        .safeAreaInset(edge: .top) {
            OfflineBannerView()
        }
        .navigationTitle("Shopping List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if !viewModel.shoppingListItems.isEmpty {
                    Button {
                        showingShoppingMode.toggle()
                    } label: {
                        Image(systemName: showingShoppingMode ? "cart.fill" : "cart")
                            .foregroundStyle(showingShoppingMode ? .blue : .primary)
                    }
                    .buttonStyle(.bordered)
                    .clipShape(Capsule())
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddItemSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.bordered)
                .clipShape(Capsule())
            }
        }
        .trackScreen(.shoppingList)
        .searchable(
            text: $viewModel.searchTerm,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search items..."
        )
        .sheet(isPresented: $showingAddItemSheet) {
            AddItemSheetView { ingredient, unit, amount, category, notes, priority in
                viewModel.handle(.addToShoppingList(
                    ingredient: ingredient,
                    unit: unit,
                    amount: amount,
                    category: category,
                    notes: notes,
                    priority: priority
                ))
            }
        }
        .sheet(item: $viewModel.selectedSearchResultToAddToShoppingList) { ingredient in
            AddToShoppingListSheetView(model: ingredient) { unit, amount, category, notes, priority in
                viewModel.handle(.addToShoppingList(
                    ingredient: ingredient,
                    unit: unit,
                    amount: amount,
                    category: category,
                    notes: notes,
                    priority: priority
                ))
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An error occurred")
        }
    }
    
    // MARK: - Progress Header
    
    private var progressFooter: some View {
        HStack(spacing: 8) {
            Text("\(viewModel.shoppingListItems.filter(\.isChecked).count) of \(viewModel.shoppingListItems.count) items")
                .font(.caption)
                .foregroundStyle(.secondary)

            ProgressView(value: progressPercentage)
                .animation(.default, value: progressPercentage)

            if showingShoppingMode {
                Button("Done Shopping") {
                    showingShoppingMode = false
                }
                .font(.subheadline)
                .fontWeight(.medium)
            }
        }
        .padding(vertical: 12, horizontal: 16)
        .clippedWithBackground()
        .padding(8)
    }

    // MARK: - Category Filter
    
    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // All Categories Button
                Button {
                    selectedCategory = nil
                } label: {
                    Text("All")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedCategory == nil ? Color.blue : Color(.tertiarySystemFill))
                        .foregroundStyle(selectedCategory == nil ? .white : .primary)
                        .clipShape(Capsule())
                }
                
                ForEach(ShoppingCategory.allCases.filter { $0 != .uncategorized }) { category in
                    Button {
                        selectedCategory = selectedCategory == category ? nil : category
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: category.icon)
                                .font(.caption)
                            Text(category.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedCategory == category ? category.color : Color(.tertiarySystemFill))
                        .foregroundStyle(selectedCategory == category ? .white : .primary)
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .scrollClipDisabled()
        .padding(vertical: 12, horizontal: 16)
        .clippedWithBackground()
        .padding(8)
    }
    
    // MARK: - Items List
    
    private var itemsListView: some View {
        List {
            if !viewModel.searchResults.isEmpty {
                Section("Search Results") {
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
                        EmptyView()
                    } initialLoadingView: {
                        ProgressView()
                    } nextPageLoadingErrorView: {
                        Text("Error loading next page...")
                    } emptyDataView: {
                        Text("Nothing found...")
                    }
                }
            }
            
            if filteredItems.isEmpty && viewModel.searchResults.isEmpty {
                Section {
                    EmptyStateView(
                        imageSystemName: "magnifyingglass",
                        title: "No items found",
                        subtitle: selectedCategory != nil 
                        ? "Try adjusting your search or category filter"
                        : "Add some items to get started"
                    )
                }
            } else {
                ForEach(sortedCategories, id: \.self) { category in
                    if let items = groupedItems[category] {
                        Section {
                            ForEach(items) { item in
                                ShoppingListCellView(
                                    item: item,
                                    onTapAction: {
                                        viewModel.handle(.toggleCheck(shoppingListItemID: item.id))
                                    },
                                    onEdit: {
                                        // TODO: Implement edit functionality
                                    },
                                    onDelete: {
                                        viewModel.handle(.deleteFromShoppingList(shoppingListItemID: item.id))
                                    }
                                )
                            }
                        } header: {
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundStyle(category.color)
                                Text(category.rawValue)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text("\(items.count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color(.tertiarySystemFill))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "basket")
                    .font(.system(size: 60))
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 8) {
                    Text("Your shopping list is empty")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text("Add items from recipes, search, or manually to get started")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            VStack(spacing: 12) {
                Button {
                    showingAddItemSheet = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    // TODO: Navigate to recipes
                } label: {
                    Label("Browse Recipes", systemImage: "book")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Add Item Sheet

struct AddItemSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var itemName = ""
    @State private var selectedUnit = "pieces"
    @State private var amount = ""
    @State private var selectedCategory: ShoppingCategory = .uncategorized
    @State private var notes = ""
    @State private var selectedPriority: ShoppingPriority = .normal
    
    private let units = ["pieces", "lbs", "kg", "oz", "g", "cups", "tbsp", "tsp", "liters", "gallons"]
    private let onAdd: (IngredientSearchInfo, String, Double, ShoppingCategory, String?, ShoppingPriority) -> Void
    
    init(onAdd: @escaping (IngredientSearchInfo, String, Double, ShoppingCategory, String?, ShoppingPriority) -> Void) {
        self.onAdd = onAdd
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Item Details") {
                    TextField("Item name", text: $itemName)
                    
                    HStack {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        
                        Picker("Unit", selection: $selectedUnit) {
                            ForEach(units, id: \.self) { unit in
                                Text(unit.capitalized).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ShoppingCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Section("Additional Details") {
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(ShoppingPriority.allCases, id: \.self) { priority in
                            HStack {
                                Image(systemName: priority.icon)
                                Text(priority.rawValue)
                            }
                            .tag(priority)
                        }
                    }
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        addItem()
                    }
                    .disabled(itemName.isEmpty || amount.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func addItem() {
        guard let amountValue = Double(amount) else { return }
        
        let ingredient = IngredientSearchInfo(
            aisle: selectedCategory.rawValue,
            id: Int.random(in: 1000...9999),
            imageUrlPath: nil,
            name: itemName,
            possibleUnits: []
        )
        
        onAdd(ingredient, selectedUnit, amountValue, selectedCategory, notes.isEmpty ? nil : notes, selectedPriority)
        dismiss()
    }
}

struct AddToShoppingListSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var selectedUnit: String = ""
    @State var amount: String = ""
    @State var selectedCategory: ShoppingCategory = .uncategorized
    @State var notes: String = ""
    @State var selectedPriority: ShoppingPriority = .normal
    
    var model: IngredientSearchInfo
    var onAdd: (String, Double, ShoppingCategory, String?, ShoppingPriority) -> Void
    
    var amountValue: Double {
        guard let amount = Double(amount) else { return .zero }
        return amount
    }
    
    init(model: IngredientSearchInfo, onAdd: @escaping (String, Double, ShoppingCategory, String?, ShoppingPriority) -> Void) {
        self.model = model
        self.onAdd = onAdd
        _selectedUnit = State(initialValue: model.possibleUnits.first.orEmpty)
        _selectedCategory = State(initialValue: model.suggestedCategory)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Item Details") {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(model.name.capitalized)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        
                        Picker("Unit", selection: $selectedUnit) {
                            ForEach(model.possibleUnits, id: \.self) {
                                Text($0.capitalized)
                                    .tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ShoppingCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Section("Additional Details") {
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(ShoppingPriority.allCases, id: \.self) { priority in
                            HStack {
                                Image(systemName: priority.icon)
                                Text(priority.rawValue)
                            }
                            .tag(priority)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        onAdd(selectedUnit, amountValue, selectedCategory, notes.isEmpty ? nil : notes, selectedPriority)
                    }
                    .disabled(amountValue.isZero)
                    .buttonStyle(.borderedProminent)
                    .clipShape(Capsule())
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .clipShape(Capsule())
                }
            }
            .navigationTitle(model.name.capitalized)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}
