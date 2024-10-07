import SwiftUI
import CachedAsyncImage

public struct RecipeCollectionPageView: PageView {

    @ObservedObject public var viewModel: RecipeCollectionPageViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private var filteredRecipes: [Recipe] {
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
                LazyVStack(spacing: 16) {
                    ForEach(filteredRecipes) { recipe in
                        singleTileView(recipe: recipe)
                            .frame(height: (UIScreen.width - 40) / 2.5)
                    }
                }
                .padding(16)
                .animation(.easeInOut, value: filteredRecipes)
            }
        }
    }

    private func singleTileView(recipe: Recipe) -> some View {
        Button {
            viewModel.onEvent?(.openRecipeDetails(config: .init(recipeId: recipe.id, title: recipe.title)))
        } label: {
            GeometryReader { geo in
                let frame = geo.frame(in: .local)
                ZStack(alignment: .bottomLeading) {
                    CachedAsyncImage(url: URL(string: recipe.image)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: frame.width,
                                height: frame.height
                            )
                            .clipped()
                            .cornerRadius(10)
                    } placeholder: {
                        if recipe.image == nil {
                            Image("foodMosaic")
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: frame.width,
                                    height: frame.height
                                )
                                .clipped()
                                .backgroundColor(.surfaceBackground)
                                .cornerRadius(10)
                        } else {
                            Color.clear.shimmering()
                                .frame(
                                    width: frame.width,
                                    height: frame.height
                                )
                        }
                    }

                    Text(recipe.title)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(5)
                        .padding(5)
                        .frame(
                            width: frame.width,
                            height: frame.height,
                            alignment: .bottomLeading
                        )
                }
            }
        }
    }
}
