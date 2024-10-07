import SwiftUI
import Combine
import CachedAsyncImage

public struct SearchPageView: PageView {

    private enum Constant {
        @MainActor static let spacerHeight: CGFloat = (UIScreen.height - UIWindow.safeAreaTopInset - UIWindow.safeAreaBottomInset - 455) / 2
    }

    // MARK: - Private properties

    @ObservedObject public var viewModel: SearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: SearchPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        ScrollView {
            ListWithDivider(viewModel.searchResults) { recipe in
                recipeCell(for: recipe)
            }
            .backgroundColor(.surfaceBackground)
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
                        .font(.headline)
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

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        if viewModel.searchTerm.isNotEmpty && viewModel.showNothingFound {
            EmptyStateView.nothingFound
                .onChange(of: viewModel.searchTerm) { _ in
                    viewModel.showNothingFound = false
                }
        } else if viewModel.searchTerm.isEmpty && !viewModel.isSearchFocused {
            EmptyStateView.searchPlaceholder
        }
    }
}

#if DEBUG
#Preview {
    SearchPageView(viewModel: .init(spoonacularNetworkService: SpoonacularNetworkServiceMock()))
}
#endif
