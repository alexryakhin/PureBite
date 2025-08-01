import SwiftUI
import Combine
import CachedAsyncImage

struct MainPageSearchView: View {


    // MARK: - Private properties

    @ObservedObject private var viewModel: MainPageSearchViewModel
    @FocusState private var isFocused: Bool
    private var namespace: Namespace.ID
    private var onSearchCancel: () -> Void

    init(
        viewModel: MainPageSearchViewModel,
        namespace: Namespace.ID,
        onSearchCancel: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.namespace = namespace
        self.onSearchCancel = onSearchCancel
    }

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                OfflineBannerView()
                if viewModel.totalResults != 0 {
                    CustomSectionHeader(text: "Recipes found: \(viewModel.totalResults)")
                }
                LazyLoadView(
                    viewModel.searchResults,
                    fetchStatus: viewModel.fetchStatus,
                    usingListWithDivider: false,
                    canLoadNextPage: viewModel.canLoadNextPage
                ) {
                    viewModel.handle(.loadNextPage)
                } itemView: { recipe in
                    RecipeDetailsLinkView(props: .init(recipeShortInfo: recipe, aspectRatio: nil))
                } initialLoadingView: {
                    ForEach(0..<4) { _ in
                        ShimmerView(height: RecipeDetailsLinkView.standardHeight)
                    }
                } nextPageLoadingErrorView: {
                    ProgressView()
                } emptyDataView: {
                    Text("Nothing found...")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .if(isPad) { view in
                view.frame(maxWidth: 580, alignment: .center)
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .top) {
            HStack(spacing: 8) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("Search recipes...", text: $viewModel.searchTerm)
                        .submitLabel(.search)
                        .focused($isFocused)
                        .onSubmit {
                            viewModel.handle(.search)
                        }

                    Spacer()

                    if !viewModel.isLoading {
                        Button {
                            viewModel.isFilterSheetPresented.toggle()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(.accent)
                                .overlay(alignment: .topTrailing) {
                                    if viewModel.filters.isApplied {
                                        Color.red
                                            .frame(width: 8, height: 8)
                                            .clipShape(Circle())
                                            .offset(x: 2, y: -2)
                                    }
                                }
                        }
                    }
                }
                .clippedWithPaddingAndBackground()
                .matchedGeometryEffect(id: "mainSearchBar", in: namespace)

                Button {
                    withAnimation {
                        isFocused = false
                        onSearchCancel()
                    }
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.bordered)
                .clipShape(Capsule())
            }
            .padding(vertical: 12, horizontal: 16)
            .background(.thinMaterial)
            .overlay(alignment: .bottom) {
                Divider()
            }
        }
        .sheet(isPresented: $viewModel.isFilterSheetPresented) {
            MainPageSearchFilterSheetView(filters: $viewModel.filters) {
                viewModel.handle(.applyFilters)
            }
        }
        .onAppear {
            isFocused = true
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An error occurred")
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
        .clipShape(Capsule())
        .padding(vertical: 12, horizontal: 16)
    }
}
