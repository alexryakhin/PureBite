import SwiftUI
import Combine
import CachedAsyncImage

struct SavedView: PageView {

    typealias Props = SavedContentProps
    typealias ViewModel = SavedViewModel

    // MARK: - Private properties

    @ObservedObject var props: Props
    @ObservedObject var viewModel: ViewModel

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.props = viewModel.state.contentProps
    }

    // MARK: - Views

    var contentView: some View {
        ScrollViewWithCustomNavBar {
            VStack(spacing: 16) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    if let recipes = props.groupedRecipes[mealType] {
                        recipeCollectionView(
                            mealType: mealType,
                            recipes: recipes
                        )
                    }
                }
            }
            .padding(16)
        } navigationBar: {
            VStack(spacing: 12) {
                Text("Saved")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SearchInputView(text: .constant(.empty), placeholder: "Search saved recipes")
            }
            .padding(16)
        }
    }

    @ViewBuilder
    func recipeCollectionView(mealType: MealType, recipes: [Recipe]) -> some View {
        if recipes.isNotEmpty {
            VStack {
                Text(mealType.title)
                    .textStyle(.headline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack {
                    if recipes.count == 1 {
                        singleTileView(recipe: recipes[0])
                    } else if recipes.count == 2 {
                        HStack(spacing: 8) {
                            singleTileView(recipe: recipes[0])
                            singleTileView(recipe: recipes[1])
                        }
                    } else if recipes.count == 3 {
                        HStack(spacing: 8) {
                            singleTileView(recipe: recipes[0])
                            VStack(spacing: 8) {
                                singleTileView(recipe: recipes[1])
                                singleTileView(recipe: recipes[2])
                            }
                        }
                    } else {
                        HStack(spacing: 8) {
                            singleTileView(recipe: recipes[0])
                            VStack(spacing: 8) {
                                singleTileView(recipe: recipes[1])
                                Button {
                                    print("TODO: Show more recipes")
                                } label: {
                                    Text("\(recipes.count - 2)+ Recipes")
                                        .textStyle(.headline)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                        .background(.accent)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .tint(.white)
                            }
                        }
                    }
                }
                .frame(height: (UIScreen.width - 40) / 2)
            }
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

#Preview {
    SavedView(viewModel: .init(favoritesService: FavoritesServiceMock()))
}
