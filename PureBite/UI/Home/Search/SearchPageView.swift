import SwiftUI
import Combine
import CachedAsyncImage

public struct SearchPageView: PageView {

    private enum Constant {
        @MainActor static let spacerHeight: CGFloat = (UIScreen.height - UIWindow.safeAreaTopInset - UIWindow.safeAreaBottomInset - 455) / 2
    }

    // MARK: - Private properties

    @ObservedObject public var viewModel: SearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: SearchPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.searchResults) { recipe in
                    recipeCell(for: recipe)
                        .onAppear {
                            // Load next page when the last item appears
                            if recipe == viewModel.searchResults.last, viewModel.fetchTriggerStatus != .nextPage, viewModel.canLoadNextPage {
                                viewModel.handle(.loadNextPage)
                            }
                        }
                }
            }
            .padding(vertical: 8, horizontal: 16)
            .animation(.none, value: viewModel.searchResults)
        }
    }

    private func recipeCell(for recipe: Recipe) -> some View {
        RecipeTileView(recipe: recipe) { id in
            viewModel.onEvent?(.openRecipeDetails(config: .init(recipeId: recipe.id, title: recipe.title)))
        }
        .frame(height: RecipeTileView.standardHeight)
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        if viewModel.searchTerm.isNotEmpty && viewModel.showNothingFound {
            EmptyStateView.nothingFound
                .onChange(of: viewModel.searchTerm) { _ in
                    viewModel.showNothingFound = false
                }
        } else if viewModel.searchTerm.isEmpty && !viewModel.isSearchFocused {
            EmptyStateView.searchPlaceholder
        }
    }
}

#if DEBUG
#Preview {
    SearchPageView(viewModel: .init(spoonacularNetworkService: SpoonacularNetworkServiceMock()))
}
#endif
