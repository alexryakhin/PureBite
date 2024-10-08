import SwiftUI
import Combine
import CachedAsyncImage

public struct MainPageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: MainPageViewModel

    @State private var categorySize: CGSize = .zero
    @State private var scrollOffset: CGPoint = .zero
    private let screenWidth = UIScreen.main.bounds.width
    // MARK: - Initialization

    public init(viewModel: MainPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        ScrollViewWithCustomNavBar {
            VStack(spacing: 16) {
                categoriesView

                if viewModel.isLoading {
                    loaderView
                } else {
                    if viewModel.selectedCategory != nil {
                        selectedCategoryRecipes
                    } else {
                        ForEach(viewModel.categories) { category in
                            recipesCategoryView(category)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        } navigationBar: {
            VStack(spacing: 12) {
                welcomeView
                searchView
            }
            .padding(16)
        }
    }

    // MARK: - Welcome section
    private var welcomeView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.greeting.0)
                .font(.subheadline)
            Text(viewModel.greeting.1)
                .font(.title3)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Search
    private var searchView: some View {
        SearchInputView(text: .constant(""))
            .disabled(true)
            .onTapGesture {
                viewModel.onEvent?(.openSearchScreen)
            }
    }

    // MARK: - Categories
    private var categoriesView: some View {
        VStack {
            Text("Categories")
                .font(.callout)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(MealType.mainCategories, id: \.self) { type in
                        categoryCellView(for: type)
                    }
                }
                .scrollTargetLayoutIfAvailable()
            }
            .scrollTargetBehaviorIfAvailable()
            .scrollClipDisabledIfAvailable()
        }
    }

    private func categoryCellView(for type: MealType) -> some View {
        VStack(alignment: .center, spacing: 8) {
            ChildSizeReader(size: $categorySize) {
                Text(type.emoji)
                    .font(.largeTitle)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(12)
                    .background(
                        viewModel.selectedCategory == type
                        ? .accent
                        : .surfaceBackground
                    )
                    .cornerRadius(12)
            }

            Text(type.title)
                .font(.caption)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .frame(width: categorySize.width)
        }
        .onTapGesture {
            withAnimation {
                viewModel.selectedCategory = viewModel.selectedCategory == type ? nil : type
            }
        }
    }

    // MARK: - Recipes

    private func recipesCategoryView(_ category: MainPageRecipeCategory) -> some View {
        VStack {
            Text(category.kind.title)
                .font(.callout)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 8) {
                    ForEach(category.recipes) {
                        recipeCell(for: $0)
                    }
                }
                .scrollTargetLayoutIfAvailable()
            }
            .scrollTargetBehaviorIfAvailable()
            .scrollClipDisabledIfAvailable()
        }
    }

    private func recipeCell(for recipe: Recipe, imageSize: CGSize = .init(width: 180, height: 150)) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    Color.clear.shimmering()
                }
                .frame(width: imageSize.width, height: imageSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
        }
        .frame(width: imageSize.width)
        .onTapGesture {
            viewModel.onEvent?(.openRecipeDetails(config: .init(recipeId: recipe.id, title: recipe.title)))
        }
    }

    private var selectedCategoryRecipes: some View {
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
            ForEach(viewModel.selectedCategoryRecipes) { recipe in
                recipeCell(for: recipe, imageSize: .init(width: screenWidth / 2 - 24, height: 150))
                    .frame(height: 210, alignment: .top)
            }
        }
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var loaderView: some View {
        if viewModel.selectedCategory != nil {
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                ForEach(0..<10) { _ in
                    Color.clear.shimmering()
                        .frame(height: 200)
                }
            }
            .padding(.vertical, 12)
        } else {
            VStack(spacing: 40) {
                ForEach(0..<5) { _ in
                    VStack(spacing: 12) {
                        Rectangle()
                            .frame(height: 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .shimmering()
                            .padding(.trailing, 200)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(0..<10) { _ in
                                    Color.clear.shimmering()
                                        .frame(width: 180, height: 160)
                                }
                            }
                            .scrollTargetLayoutIfAvailable()
                        }
                        .scrollTargetBehaviorIfAvailable()
                        .scrollClipDisabledIfAvailable()
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    MainPageView(
        viewModel: .init(
            spoonacularNetworkService: SpoonacularNetworkServiceMock()
        )
    )
}
#endif
