import SwiftUI
import CachedAsyncImage

public struct RecipeCollectionPageView: View {

    @ObservedObject public var viewModel: RecipeCollectionPageViewModel

    public init(viewModel: RecipeCollectionPageViewModel) {
        self.viewModel = viewModel
    }

    private var filteredRecipes: [RecipeShortInfo] {
        viewModel.config.recipes
    }

    public var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if filteredRecipes.isEmpty {
                EmptyStateView.nothingFound
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredRecipes) { recipe in
                            singleTileView(recipe: recipe)
                        }
                    }
                    .padding(vertical: 12, horizontal: 16)
                    .animation(.easeInOut, value: filteredRecipes)
                }
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

    private func singleTileView(recipe: RecipeShortInfo) -> some View {
        RecipeTileView(
            props: .init(
                recipeShortInfo: recipe,
                onTap: {
                    viewModel.onEvent?(.openRecipeDetails(recipeShortInfo: recipe))
                }
            )
        )
    }
}
