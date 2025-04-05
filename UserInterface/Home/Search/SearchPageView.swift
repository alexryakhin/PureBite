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

    private func recipeCell(for recipe: Recipe) -> some View {
        RecipeTileView(
            model: .init(
                recipeID: recipe.id,
                title: recipe.title,
                imageURL: recipe.image
            )
        ) { id in
            viewModel.onEvent?(.openRecipeDetails(config: .init(recipeId: recipe.id, title: recipe.title)))
        }
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
                List {
                    Section {
                        ForEach(searchQueries.trimmed.components(separatedBy: "\n"), id: \.self) { query in
                            Button(query) {
                                viewModel.searchTerm = query
                                viewModel.handle(.activateSearch)
                                viewModel.handle(.search(query: query))
                            }
                        }
                    } header: {
                        Text("Recent searches")
                    }
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
}

#if DEBUG
#Preview {
    SearchPageView(viewModel: .init(spoonacularNetworkService: SpoonacularNetworkServiceMock()))
}
#endif
