import SwiftUI
import CachedAsyncImage

struct RecipeCollectionView: PageView {

    typealias Props = RecipeCollectionContentProps

    @ObservedObject var viewModel: RecipeCollectionViewModel
    @ObservedObject var props: Props

    init(viewModel: RecipeCollectionViewModel) {
        self.viewModel = viewModel
        self.props = viewModel.state.contentProps
    }

    var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(props.recipes) { recipe in
                    singleTileView(recipe: recipe)
                        .frame(height: (UIScreen.width - 40) / 2.5)
                }
            }
            .padding(16)
        }
    }

    private func singleTileView(recipe: Recipe) -> some View {
        Button {
            viewModel.onEvent?(.openRecipeDetails(id: recipe.id))
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
                        Color.clear.shimmering()
                            .frame(
                                width: frame.width,
                                height: frame.height
                            )
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
