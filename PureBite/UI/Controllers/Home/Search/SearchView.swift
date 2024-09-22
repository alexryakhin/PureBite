import SwiftUI
import Combine

struct SearchView: PageView {

    private enum Constant {
        static let spacerHeight: CGFloat = (UIScreen.height - UIWindow.safeAreaTopInset - UIWindow.safeAreaBottomInset - 455) / 2
    }

    typealias ViewModel = SearchViewModel

    // MARK: - Private properties

    @ObservedObject var viewModel: ViewModel
    @FocusState private var isSearchFocused: Bool

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    var contentView: some View {
        ScrollViewWithCustomNavBar {
            if viewModel.searchResults.isNotEmpty {
                ListWithDivider(viewModel.searchResults) { recipe in
                    recipeCell(for: recipe)
                }
                .background(.surfaceBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(vertical: 8, horizontal: 16)
            } else {
                Spacer()
                    .frame(height: Constant.spacerHeight)
                if !isSearchFocused {
                    if viewModel.searchTerm.isNotEmpty && viewModel.showNothingFound {
                        NoResultsView()
                    } else if viewModel.searchTerm.isEmpty {
                        SearchPlaceholderView()
                    }
                }
                Spacer()
                    .frame(height: Constant.spacerHeight)
            }
        } navigationBar: {
            searchView
        }
    }

    // MARK: - Search
    private var searchView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search")
                .textStyle(.largeTitle)
                .fontWeight(.bold)
            HStack(spacing: 0) {
                SearchInputView(text: $viewModel.searchTerm, placeholder: "Search any recipes")
                    .focused($isSearchFocused, equals: true)
                    .onChange(of: viewModel.shouldActivateSearch) { newValue in
                        if newValue { isSearchFocused = true }
                    }
                    .onSubmit {
                        viewModel.loadRecipes(for: viewModel.searchTerm)
                    }

                if isSearchFocused {
                    StyledButton(text: "Cancel", style: .textMini) {
                        // cancel
                        isSearchFocused = false
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .animation(.default)
        }
        .padding(16)
    }

    private func recipeCell(for recipe: Recipe) -> some View {
        Button {
            viewModel.onEvent?(.openRecipeDetails(id: recipe.id))
        } label: {
            HStack(alignment: .center, spacing: 8) {
                if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.clear
                            .shimmering()
                            .frame(height: 45)
                    }
                    .frame(width: 55, height: 45)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                VStack(alignment: .leading) {
                    Text(recipe.title)
                        .textStyle(.headline)
                        .tint(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(vertical: 12, horizontal: 16)
    }
}

#if DEBUG
#Preview {
    SearchView(viewModel: .init(spoonacularNetworkService: SpoonacularNetworkServiceMock()))
}
#endif
