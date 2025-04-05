import SwiftUI
import Combine
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct ShoppingListPageView: PageView {

    private enum Constant {
        @MainActor static let spacerHeight: CGFloat = (UIScreen.height - UIWindow.safeAreaTopInset - UIWindow.safeAreaBottomInset - 455) / 2
    }

    // MARK: - Private properties

    @ObservedObject public var viewModel: ShoppingListPageViewModel

    // MARK: - Initialization

    public init(viewModel: ShoppingListPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        ScrollView(showsIndicators: false) {
            ListWithDivider(viewModel.searchResults, dividerLeadingPadding: 72) { ingredient in
                Button {
                    viewModel.handle(.ingredientSelected(.init(id: ingredient.id, name: ingredient.name)))
                } label: {
                    SearchIngredientCellView(ingredient: ingredient)
                        .onAppear {
                            // Load next page when the last item appears
                            if ingredient == viewModel.searchResults.last, viewModel.fetchTriggerStatus != .nextPage, viewModel.canLoadNextPage {
                                viewModel.handle(.loadNextPage)
                            }
                        }
                }
            }
            .padding(.vertical, 4)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(16)
        }
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        if viewModel.searchTerm.isNotEmpty && viewModel.showNothingFound {
            EmptyStateView.nothingFound
                .onChange(of: viewModel.searchTerm) { _ in
                    viewModel.showNothingFound = false
                }
        } else if viewModel.searchTerm.isEmpty && !viewModel.isSearchFocused {
            EmptyStateView.ingredientsSearchPlaceholder
        }
    }

    public func loaderView(props: PageState.LoaderProps) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(0..<6) { _ in
                    ShimmerView(height: RecipeTileView.standardHeight)
                }
            }
            .padding(vertical: 8, horizontal: 16)
            .animation(.none, value: viewModel.searchResults)
        }
    }
}

#if DEBUG
#Preview {
    SearchPageView(viewModel: .init(spoonacularNetworkService: SpoonacularNetworkServiceMock()))
}
#endif
