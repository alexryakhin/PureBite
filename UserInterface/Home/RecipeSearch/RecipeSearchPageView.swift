import SwiftUI
import Combine
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct RecipeSearchPageView: PageView {

    private enum Constant {
        @MainActor static let spacerHeight: CGFloat = (UIScreen.height - UIWindow.safeAreaTopInset - UIWindow.safeAreaBottomInset - 455) / 2
    }

    // MARK: - Private properties

    @ObservedObject public var viewModel: RecipeSearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: RecipeSearchPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                CustomSectionHeader(text: "Recipes found: \(viewModel.totalResults)")
                LazyLoadView(
                    viewModel.searchResults,
                    fetchStatus: viewModel.fetchStatus,
                    usingListWithDivider: false,
                    canLoadNextPage: viewModel.canLoadNextPage
                ) {
                    viewModel.handle(.loadNextPage)
                } itemView: { recipe in
                    recipeCell(for: recipe)
                } initialLoadingView: {
                    ProgressView()
                } nextPageLoadingErrorView: {
                    Text("Error loading next page...")
                } emptyDataView: {
                    Text("Nothing found...")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(vertical: 12, horizontal: 16)
        }
        .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            viewModel.handle(.search)
        }
        .safeAreaInset(edge: .bottom) {
            if viewModel.additionalState == nil {
                filtersButton
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isFilterSheetPresented.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                .if(viewModel.filters.isApplied, transform: { button in
                    button.buttonStyle(.borderedProminent)
                })
            }
        }
        .sheet(isPresented: $viewModel.isFilterSheetPresented) {
            RecipeSearchFilterSheetView(filters: $viewModel.filters) {
                viewModel.handle(.applyFilters)
            }
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
        if viewModel.fetchStatus == .idleNoData {
            VStack {
                EmptyStateView.nothingFound
                if viewModel.filters.isApplied {
                    filtersButton
                }
            }
        } else if viewModel.fetchStatus == .initial {
            if viewModel.searchQueries.isEmpty {
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
            ListWithDivider(viewModel.searchQueries) { query in
                CellWrapper {
                    Text(query)
                } onTapAction: {
                    viewModel.searchTerm = query
                    viewModel.handle(.activateSearch)
                }
            }
            .clippedWithBackground(.surface)
        } headerTrailingContent: {
            SectionHeaderButton("Clear") {
                viewModel.handle(.clearRecentQueries)
            }
        }
    }

    private var filtersButton: some View {
        Button {
            viewModel.isFilterSheetPresented.toggle()
        } label: {
            Label(
                viewModel.filters.isApplied ? "Filters applied" : "Apply filters",
                systemImage: "slider.horizontal.3"
            )
        }
        .buttonStyle(.borderedProminent)
        .padding(vertical: 12, horizontal: 16)
    }
}
