import SwiftUI
import CachedAsyncImage

struct RecipeCollectionPageView: View {

    @ObservedObject var viewModel: RecipeCollectionPageViewModel

    init(viewModel: RecipeCollectionPageViewModel) {
        self.viewModel = viewModel
    }

    private var filteredRecipes: [RecipeShortInfo] {
        viewModel.config.recipes
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if filteredRecipes.isEmpty {
                EmptyStateView.nothingFound
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredRecipes) { recipe in
                            RecipeDetailsLinkView(props: .init(recipeShortInfo: recipe))
                        }
                    }
                    .padding(vertical: 12, horizontal: 16)
                    .animation(.easeInOut, value: filteredRecipes)
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
}
