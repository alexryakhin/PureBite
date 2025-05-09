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
    @State private var isPresented: Bool = false {
        didSet {
            print(isPresented)
        }
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
        .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            viewModel.handle(.search(query: viewModel.searchTerm))
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
                        // on tap
                    } label: {
                        SearchShoppingListCellView(item: item)
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
