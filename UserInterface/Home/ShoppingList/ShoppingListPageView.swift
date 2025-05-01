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

    @AppStorage(UserDefaultsKey.ingredientSearchQueries.rawValue) 
    private var searchQueries: String = ""

    @ObservedObject public var viewModel: ShoppingListPageViewModel

    // MARK: - Initialization

    public init(viewModel: ShoppingListPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 24) {
                if viewModel.isSearchFocused {
                    searchResultsSection
                } else {
                    previousQueriesSectionView
                    // saved items
                }
            }
            .padding(vertical: 12, horizontal: 16)
        }
    }

    // Show placeholder if no local ingredients saved
    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        if viewModel.showNothingFound {
            EmptyStateView.nothingFound
        } else if viewModel.searchTerm.isEmpty && !viewModel.isSearchFocused {
            if searchQueries.isEmpty {
                EmptyStateView.ingredientsSearchPlaceholder
            } else {
                ScrollView {
                    LazyVStack(spacing: 24) {
                        previousQueriesSectionView
                        // some previously clicked ingredients
                    }
                    .padding(vertical: 12, horizontal: 16)
                }
            }
        }
    }

    public func loaderView(props: PageState.LoaderProps) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(0..<10) { _ in
                    ShimmerView(height: 60)
                }
            }
            .padding(vertical: 8, horizontal: 16)
            .animation(.none, value: viewModel.searchResults)
        }
    }

    @ViewBuilder
    public var searchResultsSection: some View {
        if viewModel.searchResults.isNotEmpty {
            CustomSectionView(header: "Search results") {
                ListWithDivider(viewModel.searchResults, dividerLeadingPadding: 72) { item in
                    Button {
                        viewModel.handle(.itemSelected(.init(id: item.id    q, name: ingredient.name)))
                    } label: {
                        SearchShoppingListCellView(item: item)
                            .onAppear {
                                // Load next page when the last item appears
                                if ingredient == viewModel.searchResults.last, viewModel.fetchTriggerStatus != .nextPage, viewModel.canLoadNextPage {
                                    viewModel.handle(.loadNextPage)
                                }
                            }
                    }
                }
                .clippedWithBackground(.surface)
            }
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
