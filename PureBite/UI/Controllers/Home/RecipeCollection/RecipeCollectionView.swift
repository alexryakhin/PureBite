import SwiftUI
import CachedAsyncImage

struct RecipeCollectionView: PageView {

    typealias ViewModel = RecipeCollectionViewModel

    @ObservedObject var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.recipes) { recipe in
                    singleTileView(recipe: recipe)
                        .frame(height: (UIScreen.width - 40) / 2.5)
                }
            }
            .padding(16)
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
                                .background(Color.surfaceBackground)
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
