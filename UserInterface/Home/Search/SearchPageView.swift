import SwiftUI
import Combine
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct SearchPageView: PageView {

    private enum Constant {
        @MainActor static let spacerHeight: CGFloat = (UIScreen.height - UIWindow.safeAreaTopInset - UIWindow.safeAreaBottomInset - 455) / 2
    }

    // MARK: - Private properties

    @AppStorage(UserDefaultsKey.searchQueries.rawValue) private var searchQueries: String = .empty
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

    private func recipeCell(for recipe: RecipeShortInfo) -> some View {
        RecipeTileView(
            props: .init(
                recipeShortInfo: recipe,
                onTap: {
                    viewModel.onEvent?(.openRecipeDetails(recipeShortInfo: recipe))
                }
            )
        )
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        if viewModel.searchTerm.isNotEmpty && viewModel.showNothingFound {
            EmptyStateView.nothingFound
                .onChange(of: viewModel.searchTerm) { _ in
                    viewModel.showNothingFound = false
                }
        } else if viewModel.searchTerm.isEmpty && !viewModel.isSearchFocused {
            if searchQueries.isEmpty {
                EmptyStateView.searchPlaceholder
            } else {
                ScrollView {
                    LazyVStack(spacing: 24) {
                        previousQueriesSectionView
                    }
                    .padding(vertical: 12, horizontal: 16)
                }
            }
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

    private var previousQueriesSectionView: some View {
        CustomSectionView(header: "Recent searches") {
            ListWithDivider(searchQueries.trimmed.components(separatedBy: "\n").suffix(5)) { query in
                CellWrapper {
                    Text(query)
                } onTapAction: {
                    viewModel.searchTerm = query
                    viewModel.handle(.activateSearch)
                    viewModel.handle(.search(query: query))
                }
            }
            .clippedWithBackground(.surface)
        } headerTrailingContent: {
            SectionHeaderButton("Clear") {
                searchQueries = .empty
            }
        }
    }
}

#if DEBUG
#Preview {
    SearchPageView(viewModel: .init(spoonacularNetworkService: SpoonacularNetworkServiceMock()))
}
#endif
