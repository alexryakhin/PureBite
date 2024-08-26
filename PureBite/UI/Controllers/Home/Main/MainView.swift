import SwiftUI
import Combine

struct MainView: PageView {

    typealias Props = MainContentProps

    // MARK: - Private properties

    @ObservedObject var props: Props
    @ObservedObject var viewModel: MainViewModel

    @State private var categorySize: CGSize = .zero
    @State private var scrollOffset: CGPoint = .zero
    private let screenWidth = UIScreen.main.bounds.width
    // MARK: - Initialization

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.props = viewModel.state.contentProps
    }

    // MARK: - Views

    var contentView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                welcomeView
                searchView
                Divider()
            }
            .padding(.top, 12)
            .background(.thinMaterial)
            .zIndex(1)
            ScrollView {
                VStack(spacing: 16) {
                    categoriesView

                    if props.isLoading {
                        loaderView
                    } else {
                        if props.selectedCategory != nil {
                            selectedCategoryRecipes
                        } else {
                            ForEach(props.categories) { category in
                                recipesCategoryView(category)
                            }
                        }
                    }
                }
                .padding(.vertical, 12)
            }
            .scrollClipDisabledIfAvailable()
        }
    }

    // MARK: - Welcome section
    private var welcomeView: some View {
        VStack(alignment: .leading) {
            Text(props.greeting.0)
                .textStyle(.subheadline)
            Text(props.greeting.1)
                .textStyle(.title3)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    // MARK: - Search
    private var searchView: some View {
        SearchInputView(text: .constant(""), placeholder: "Search any recipes")
            .clipShape(Capsule())
            .shadow(radius: 2)
            .padding(.horizontal, 16)
            .disabled(true)
            .onTapGesture {
                viewModel.onEvent?(.openSearchScreen)
            }
    }

    // MARK: - Categories
    private var categoriesView: some View {
        VStack {
            Text("Categories")
                .textStyle(.callout)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(MealType.allCases, id: \.self) { type in
                        categoryCellView(for: type)
                    }
                }
                .scrollTargetLayoutIfAvailable()
                .padding(.horizontal, 16)
            }
            .scrollTargetBehaviorIfAvailable()
        }
    }

    private func categoryCellView(for type: MealType) -> some View {
        VStack(alignment: .center, spacing: 8) {
            ChildSizeReader(size: $categorySize) {
                Text(type.emoji)
                    .textStyle(.largeTitle)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(12)
                    .background(
                        props.selectedCategory == type
                        ? .accent
                        : .surfaceBackground
                    )
                    .cornerRadius(12)
            }

            Text(type.title)
                .textStyle(.caption1)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .frame(width: categorySize.width)
        }
        .onTapGesture {
            withAnimation {
                props.selectedCategory = props.selectedCategory == type ? nil : type
            }
        }
    }

    // MARK: - Recipes

    private func recipesCategoryView(_ category: MainPageRecipeCategory) -> some View {
        VStack {
            Text(category.kind.title)
                .textStyle(.callout)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 8) {
                    ForEach(category.recipes) {
                        recipeCell(for: $0)
                    }
                }
                .scrollTargetLayoutIfAvailable()
                .padding(.horizontal, 16)
            }
            .scrollTargetBehaviorIfAvailable()
        }
    }

    private func recipeCell(for recipe: Recipe, imageSize: CGSize = .init(width: 180, height: 150)) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    Color.surfaceBackground.shimmering()
                }
                .frame(width: imageSize.width, height: imageSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .textStyle(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
        }
        .frame(width: imageSize.width)
        .onTapGesture {
            viewModel.onEvent?(.openRecipeDetails(id: recipe.id))
        }
    }

    private var selectedCategoryRecipes: some View {
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
            ForEach(props.selectedCategoryRecipes) { recipe in
                recipeCell(for: recipe, imageSize: .init(width: screenWidth / 2 - 16, height: 150))
                    .frame(height: 210, alignment: .top)
            }
        }
        .padding(12)
    }

    @ViewBuilder
    private var loaderView: some View {
        if props.selectedCategory != nil {
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                ForEach(0..<10) { _ in
                    Color.surfaceBackground.shimmering()
                        .frame(height: 200)
                }
            }
            .padding(12)
        } else {
            ForEach(0..<5) { _ in
                VStack {
                    Rectangle()
                        .frame(height: 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .shimmering()
                        .padding(.horizontal, 16)
                        .padding(.trailing, 200)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(0..<10) { _ in
                                Color.surfaceBackground.shimmering()
                                    .frame(width: 180, height: 160)
                            }
                        }
                        .scrollTargetLayoutIfAvailable()
                        .padding(.horizontal, 16)
                    }
                    .scrollTargetBehaviorIfAvailable()
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    MainView(
        viewModel: .init(
            spoonacularNetworkService: SpoonacularNetworkServiceMock()
        )
    )
}
#endif
