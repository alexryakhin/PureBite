import SwiftUI
import Combine

struct SavedView: PageView {

    typealias ViewModel = SavedViewModel

    // MARK: - Private properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private var filteredRecipes: [Recipe] {
        if viewModel.searchTerm.removingSpaces.isEmpty {
            viewModel.allRecipes
        } else {
            viewModel.allRecipes.filter {
                $0.title.localizedCaseInsensitiveContains(viewModel.searchTerm)
            }
        }
    }

    // MARK: - Views

    var contentView: some View {
        if viewModel.isSearchActive {
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
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        if let recipes = viewModel.groupedRecipes[mealType] {
                            recipeCollectionView(
                                mealType: mealType,
                                recipes: Array(recipes)
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }

    }

    @ViewBuilder
    func recipeCollectionView(mealType: MealType, recipes: [Recipe]) -> some View {
        if recipes.isNotEmpty {
            Section {
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
                                    viewModel.onEvent?(
                                        .openCategory(
                                            config: .init(
                                                title: mealType.title,
                                                recipes: recipes
                                            )
                                        )
                                    )
                                } label: {
                                    ZStack {
                                        let height = (((UIScreen.width - 40) / 2) - 8) / 2
                                        let width = (UIScreen.width - 40) / 2
                                        Image("foodMosaic")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: width, height: height)
                                            .clipped()
                                            .opacity(0.5)
                                            .background(Color.accentColor)
                                            .cornerRadius(10)
                                        Text("\(recipes.count - 2)+ Recipes")
                                            .textStyle(.headline)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .tint(.white)
                            }
                        }
                    }
                }
                .frame(height: (UIScreen.width - 40) / 2)
            } header: {
                Text(mealType.title)
                    .textStyle(.headline)
                    .foregroundStyle(.primary)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.background)
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
                    AsyncImage(url: URL(string: recipe.image)) { image in
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

    func placeholder(props: ScreenState.PlaceholderProps) -> some View {
        EmptyStateView.savedRecipesPlaceholder
    }
}

#if DEBUG
#Preview {
    SavedView(viewModel: .init(favoritesService: FavoritesServiceMock()))
}
#endif
