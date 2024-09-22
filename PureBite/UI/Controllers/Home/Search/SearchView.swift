import SwiftUI
import Combine
import CachedAsyncImage

struct SearchView: PageView {

    private enum Constant {
        static let spacerHeight: CGFloat = (UIScreen.height - UIWindow.safeAreaTopInset - UIWindow.safeAreaBottomInset - 455) / 2
    }

    typealias ViewModel = SearchViewModel

    // MARK: - Private properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    var contentView: some View {
        ScrollView {
            ListWithDivider(viewModel.searchResults) { recipe in
                recipeCell(for: recipe)
            }
            .background(.surfaceBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(vertical: 8, horizontal: 16)
        }
    }

    private func recipeCell(for recipe: Recipe) -> some View {
        Button {
            viewModel.onEvent?(.openRecipeDetails(config: .init(recipeId: recipe.id, title: recipe.title)))
        } label: {
            HStack(alignment: .center, spacing: 8) {
                if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.clear
                            .shimmering()
                            .frame(height: 45)
                    }
                    .frame(width: 55, height: 45)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                VStack(alignment: .leading) {
                    Text(recipe.title)
                        .textStyle(.headline)
                        .tint(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(vertical: 12, horizontal: 16)
    }

    func placeholder(props: ScreenState.PlaceholderProps) -> some View {
        if !viewModel.isSearchFocused {
            if viewModel.searchTerm.isNotEmpty && viewModel.showNothingFound {
                EmptyStateView.nothingFound
            } else if viewModel.searchTerm.isEmpty {
                EmptyStateView.searchPlaceholder
            }
        }
    }
}

#if DEBUG
#Preview {
    SearchView(viewModel: .init(spoonacularNetworkService: SpoonacularNetworkServiceMock()))
}
#endif
