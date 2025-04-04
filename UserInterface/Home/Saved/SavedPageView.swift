import SwiftUI
import Combine
import CachedAsyncImage

public struct SavedPageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: SavedPageViewModel

    // MARK: - Initialization

    public init(viewModel: ViewModel) {
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

    public var contentView: some View {
        if viewModel.isSearchActive {
            if filteredRecipes.isEmpty {
                EmptyStateView.nothingFound
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredRecipes) { recipe in
                            singleTileView(recipe: recipe)
                                .frame(height: RecipeTileView.standardHeight)
                        }
                    }
                    .padding(vertical: 12, horizontal: 16)
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
                                        Image("foodMosaic300")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: width, height: height)
                                            .clipped()
                                            .opacity(0.25)
                                            .background(Color.accentColor)
                                            .cornerRadius(10)
                                            .foregroundColor(.systemBackground)
                                        Text("\(recipes.count - 2)+ Recipes")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                            .foregroundColor(.systemBackground)
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
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func singleTileView(recipe: Recipe) -> some View {
        RecipeTileView(recipe: recipe) { id in
            viewModel.onEvent?(.openRecipeDetails(config: .init(recipeId: id, title: recipe.title)))
        }
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyStateView.savedRecipesPlaceholder
    }
}

#if DEBUG
#Preview {
    SavedPageView(viewModel: .init(favoritesService: FavoritesServiceMock()))
}
#endif
