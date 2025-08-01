import SwiftUI
import CachedAsyncImage

struct RecipeCollectionPageView: View {

    private let recipes: [RecipeShortInfo]

    init(recipes: [RecipeShortInfo]) {
        self.recipes = recipes
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if recipes.isEmpty {
                EmptyStateView.nothingFound
            } else {
                ScrollView {
                    if isPad {
                        LazyVGrid(
                            columns: Array(
                                repeating: GridItem(.flexible(), spacing: 16),
                                count: 2
                            ),
                            spacing: 12
                        ) {
                            ForEach(recipes) { recipe in
                                RecipeDetailsLinkView(props: .init(recipeShortInfo: recipe))
                            }
                        }
                        .padding(vertical: 12, horizontal: 16)
                        .animation(.easeInOut, value: recipes)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(recipes) { recipe in
                                RecipeDetailsLinkView(props: .init(recipeShortInfo: recipe))
                            }
                        }
                        .padding(vertical: 12, horizontal: 16)
                        .animation(.easeInOut, value: recipes)
                    }
                }
            }
        }
    }
}
