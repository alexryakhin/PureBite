import SwiftUI
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct RecipeCollectionPageView: PageView {

    @ObservedObject public var viewModel: RecipeCollectionPageViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private var filteredRecipes: [RecipeShortInfo] {
        if viewModel.searchTerm.removingSpaces.isEmpty {
            viewModel.recipes
        } else {
            viewModel.recipes.filter {
                $0.title.localizedCaseInsensitiveContains(viewModel.searchTerm)
            }
        }
    }

    public var contentView: some View {
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
