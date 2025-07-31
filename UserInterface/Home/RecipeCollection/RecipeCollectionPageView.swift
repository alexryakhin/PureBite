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
                    LazyVStack(spacing: 12) {
                        ForEach(recipes) { recipe in
                            RecipeDetailsLinkView(props: .init(recipeShortInfo: recipe))
                        }
                    }
                    .if(isPad) { view in
                        view.frame(maxWidth: 580, alignment: .center)
                    }
                    .padding(vertical: 12, horizontal: 16)
                    .animation(.easeInOut, value: recipes)
                }
            }
        }
    }
}
