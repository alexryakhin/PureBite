import SwiftUI
import Combine
import CachedAsyncImage

struct SavedRecipesPageView: View {

    // MARK: - Private properties

    @ObservedObject var viewModel: SavedRecipesPageViewModel


    init(viewModel: SavedRecipesPageViewModel) {
        self.viewModel = viewModel
    }

    private var filteredRecipes: [RecipeShortInfo] {
        if viewModel.searchTerm.removingSpaces.isEmpty {
            viewModel.allRecipes
        } else {
            viewModel.allRecipes.filter {
                $0.title.localizedCaseInsensitiveContains(viewModel.searchTerm)
            }
        }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if viewModel.isSearchActive {
                if filteredRecipes.isEmpty {
                    EmptyStateView.nothingFound
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredRecipes) { recipe in
                                singleTileView(
                                    recipe: recipe,
                                    height: RecipeTileView.standardHeight
                                )
                            }
                        }
                        .padding(vertical: 12, horizontal: 16)
                        .animation(.easeInOut, value: filteredRecipes)
                    }
                }
            } else {
                if viewModel.allRecipes.isEmpty {
                    EmptyStateView.savedRecipesPlaceholder
                } else {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            ForEach(MealType.allCases, id: \.self) { mealType in
                                if let recipes = viewModel.groupedRecipes[mealType] {
                                    recipeCollectionView(
                                        mealType: mealType,
                                        recipes: Array(recipes)
                                    )
                                }
                            }
                        }
                        .padding(vertical: 12, horizontal: 16)
                    }
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

    @ViewBuilder
    func recipeCollectionView(mealType: MealType, recipes: [RecipeShortInfo]) -> some View {
        if recipes.isNotEmpty {
            VStack(spacing: 8) {
                Section {
                    VStack(spacing: 12) {
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
                                        Text("\(recipes.count - 2)+ Recipes")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                        }
                    }
                    .frame(height: RecipeTileView.standardHeight)
                } header: {
                    Text(mealType.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private func singleTileView(recipe: RecipeShortInfo, height: CGFloat? = nil) -> some View {
        RecipeTileView(
            props: .init(
                recipeShortInfo: recipe,
                height: height,
                aspectRatio: nil,
                onTap: {
                    viewModel.onEvent?(.openRecipeDetails(recipeShortInfo: recipe))
                }
            )
        )
    }
}

