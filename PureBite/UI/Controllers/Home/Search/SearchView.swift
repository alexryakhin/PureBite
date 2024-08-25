import SwiftUI
import Combine

struct SearchView: PageView {

    typealias Props = SearchContentProps
    typealias ViewModel = SearchViewModel

    // MARK: - Private properties

    @ObservedObject var props: Props
    @ObservedObject var viewModel: ViewModel
    @FocusState private var isSearchFocused: Bool

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.props = viewModel.state.contentProps
    }

    // MARK: - Views

    var contentView: some View {
        VStack(spacing: 12) {
            searchView

            if props.searchResults.isNotEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(props.searchResults) { recipe in
                            recipeCell(
                                for: recipe,
                                isLastCell: props.searchResults.last?.id == recipe.id
                            )
                        }
                    }
                    .background(.surfaceBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(16)
                }
            } else {
                Spacer()
                if !isSearchFocused {
                    if props.searchTerm.isNotEmpty && props.showNothingFound {
                        NoResultsView()
                    } else if props.searchTerm.isEmpty {
                        SearchPlaceholderView()
                    }
                }
                Spacer()
            }
        }
    }

    // MARK: - Search
    private var searchView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search")
                .textStyle(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            HStack(spacing: 0) {
                SearchInputView(text: $props.searchTerm, placeholder: "Search any recipes")
                    .focused($isSearchFocused, equals: true)
                    .onChange(of: props.shouldActivateSearch) { newValue in
                        if newValue { isSearchFocused = true }
                    }
                    .onSubmit {
                        viewModel.loadRecipes(for: props.searchTerm)
                    }

                if isSearchFocused {
                    StyledButton(text: "Cancel", style: .textMini) {
                        // cancel
                        isSearchFocused = false
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .padding(.horizontal, 16)
            .animation(.default)
        }
    }

    func loader(props: ScreenState.LoaderProps) -> some View {
        VStack(spacing: 12) {
            searchView
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    private func recipeCell(for recipe: Recipe, isLastCell: Bool) -> some View {
        VStack(spacing: 0) {
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
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            if !isLastCell {
                Divider().padding(.leading, 16 + 55 + 8)
            }
        }
    }
}

#if DEBUG
#Preview {
    SearchView(viewModel: .init(spoonacularNetworkService: SpoonacularNetworkServiceMock()))
}
#endif
