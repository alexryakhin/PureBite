import SwiftUI
import Combine
import CachedAsyncImage

struct MainPageSearchView: View {

    // MARK: - Private properties

    @ObservedObject var viewModel: MainPageSearchViewModel

    init(viewModel: MainPageSearchViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
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
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            if !viewModel.isLoading {
                filtersButton
            }
        }
        .sheet(isPresented: $viewModel.isFilterSheetPresented) {
            MainPageSearchFilterSheetView(filters: $viewModel.filters) {
                viewModel.handle(.applyFilters)
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

    private func recipeCell(for recipe: RecipeShortInfo) -> some View {
        NavigationLink {
            RecipeDetailsPageView(recipeShortInfo: recipe)
        } label: {
            RecipeTileView(props: .init(recipeShortInfo: recipe))
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
