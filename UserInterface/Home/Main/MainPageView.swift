import SwiftUI
import Combine
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

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
            LazyVStack(spacing: 16) {
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
            .padding(.bottom, 16)
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
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(MealType.mainCategories, id: \.self) { type in
                        categoryCellView(for: type)
                    }
                }
                .padding(.horizontal, 16)
                .scrollTargetLayoutIfAvailable()
            }
            .scrollTargetBehaviorIfAvailable()
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
                        ? Color.accentColor
                        : .surface
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
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 8) {
                    ForEach(category.recipes) {
                        recipeCell(for: $0)
                    }
                }
                .padding(.horizontal, 16)
                .scrollTargetLayoutIfAvailable()
            }
            .scrollTargetBehaviorIfAvailable()
        }
    }

    private func recipeCell(for recipe: RecipeShortInfo) -> some View {
        RecipeTileView(
            props: .init(
                recipeShortInfo: recipe,
                onTap: {
                    viewModel.onEvent?(.openRecipeDetails(recipeShortInfo: recipe))
                }
            )
        )
    }

    private var selectedCategoryRecipes: some View {
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
            ForEach(viewModel.selectedCategoryRecipes) { recipe in
                recipeCell(for: recipe)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var loaderView: some View {
        if viewModel.selectedCategory != nil {
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                ForEach(0..<10) { _ in
                    ShimmerView(height: RecipeTileView.standardHeight)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        } else {
            VStack(spacing: 16) {
                ForEach(0..<5) { _ in
                    VStack(spacing: 12) {
                        ShimmerView(width: UIScreen.width / 2, height: 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(0..<10) { _ in
                                    ShimmerView(
                                        height: RecipeTileView.standardHeight,
                                        aspectRatio: 16/9
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .scrollTargetLayoutIfAvailable()
                        }
                        .scrollTargetBehaviorIfAvailable()
                    }
                }
            }
        }
    }
}

