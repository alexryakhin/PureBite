import SwiftUI
import Combine
import CachedAsyncImage

struct MainPageView: View {

    @ObservedObject var viewModel: MainPageViewModel
    var onSearchTap: () -> Void

    // MARK: - Private properties

    @State private var categorySize: CGSize = .zero
    @State private var scrollOffset: CGPoint = .zero
    private var namespace: Namespace.ID

    init(
        viewModel: MainPageViewModel,
        namespace: Namespace.ID,
        onSearchTap: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.namespace = namespace
        self.onSearchTap = onSearchTap
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 16) {
                    // Hero Section
                    heroSection

                    // Search Bar
                    searchSection

                    // Quick Actions
                    quickActionsSection

                    // Categories
                    categoriesSection

                    // Content
                    if viewModel.isLoading {
                        loaderView
                    } else {
                        if viewModel.selectedCategory != nil {
                            selectedCategorySection
                        } else {
                            contentSection
                        }
                    }
                }
                .if(isPad) { view in
                    view.frame(maxWidth: 580, alignment: .center)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An error occurred")
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            Spacer()

            // Welcome text
            VStack(spacing: 8) {
                Text(viewModel.greeting.0)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)

                Text(viewModel.greeting.1)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)

            // Stats row
            HStack(spacing: 24) {
                MainPageStatItem(icon: "fork.knife", value: "\(viewModel.totalRecipes)", label: "Recipes")
                MainPageStatItem(icon: "heart.fill", value: "\(viewModel.favoriteRecipes)", label: "Favorites")
                MainPageStatItem(icon: "clock.fill", value: "\(viewModel.quickRecipes)", label: "Quick")
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .background {
            LinearGradient(
                colors: [.accentColor.opacity(0.1), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }

    // MARK: - Search Section
    private var searchSection: some View {
        VStack(spacing: 16) {
            // Search bar
            Button {
                onSearchTap()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    
                    Text("Search recipes...")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "slider.horizontal.3")
                        .foregroundStyle(.secondary)
                }
                .clippedWithPaddingAndBackground()
                .matchedGeometryEffect(id: "mainSearchBar", in: namespace)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        CustomSectionView(header: "Quick Actions") {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                NavigationLink {
                    SavedRecipesPageView()
                } label: {
                    QuickActionCard(
                        icon: "bookmark.fill",
                        title: "Favorites",
                        subtitle: "Your saved recipes",
                        color: .yellow
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(
                    destination: Group {
                        if let randomRecipe = viewModel.selectedRandomRecipe {
                            RecipeDetailsPageView(recipeShortInfo: randomRecipe)
                        }
                    },
                    isActive: Binding(
                        get: { viewModel.selectedRandomRecipe != nil },
                        set: { _ in
                            if viewModel.selectedRandomRecipe != nil {
                                viewModel.selectedRandomRecipe = nil
                            }
                        }
                    )
                ) {
                    QuickActionCard(
                        icon: viewModel.isFindingRandomRecipe ? "clock.fill" : "dice.fill",
                        title: "Random Recipe",
                        subtitle: viewModel.isFindingRandomRecipe ? "Finding recipe..." : "Under 30 min",
                        color: .orange,
                        onTap: {
                            if !viewModel.isFindingRandomRecipe {
                                viewModel.fetchRandomRecipe()
                            }
                        }
                    )
                }
                .buttonStyle(.plain)

                NavigationLink {
                    SearchByIngredientsView()
                } label: {
                    QuickActionCard(
                        icon: "magnifyingglass",
                        title: "Search by Ingredients",
                        subtitle: "Available to you",
                        color: .green
                    )
                }
                .buttonStyle(.plain)

                NavigationLink {
                    RecipeCategoryList(category: .trending)
                } label: {
                    QuickActionCard(
                        icon: "star.fill",
                        title: "Trending",
                        subtitle: "Popular recipes",
                        color: .purple
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Categories Section
    private var categoriesSection: some View {
        CustomSectionView(header: "Explore Categories") {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(MealType.mainCategories, id: \.self) { type in
                        CategoryCard(
                            type: type,
                            isSelected: viewModel.selectedCategory == type,
                            onTap: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    viewModel.selectedCategory = viewModel.selectedCategory == type ? nil : type
                                }
                            }
                        )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Content Section
    private var contentSection: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.categories) { category in
                RecipeCategorySection(category: category)
            }
        }
    }

    // MARK: - Selected Category Section
    private var selectedCategorySection: some View {
        VStack(spacing: 16) {
            // Header with back button
            HStack {
                Button {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        viewModel.selectedCategory = nil
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Back to Explore")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                }
                
                Spacer()
                
                if let selectedCategory = viewModel.selectedCategory {
                    Text(selectedCategory.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal, 20)
            
            // Grid of recipes
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.selectedCategoryRecipes) { recipe in
                    RecipeDetailsLinkView(props: .init(recipeShortInfo: recipe))
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 100)
    }

    @ViewBuilder
    private var loaderView: some View {
        if viewModel.selectedCategory != nil {
            // Grid loading for selected category
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(0..<10, id: \.self) { _ in
                    ShimmerView(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 20)
        } else {
            // Horizontal loading for categories
            VStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { _ in
                    ShimmerView(height: 200)
                        .padding(.horizontal, 16)
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct MainPageStatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.accent)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct CategoryCard: View {
    let type: MealType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Text(type.emoji)
                    .font(.system(size: 32))
                    .frame(width: 64, height: 64)
                    .background(
                        isSelected ? .accent : Color(.tertiarySystemGroupedBackground)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                
                Text(type.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .accent : .primary)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(.plain)
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let onTap: (() -> Void)?

    init(
        icon: String,
        title: String,
        subtitle: String,
        color: Color,
        onTap: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.color = color
        self.onTap = onTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .clippedWithPaddingAndBackground(Color(.tertiarySystemGroupedBackground))
        .ifLet(onTap) { view, onTapAction in
            Button(action: onTapAction) { view }
                .buttonStyle(.plain)
        }
    }
}

struct RecipeCategorySection: View {
    let category: MainPageRecipeCategory
    
    var body: some View {
        CustomSectionView(header: category.kind.title) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(category.recipes) { recipe in
                        RecipeDetailsLinkView(props: .init(recipeShortInfo: recipe))
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
        } trailingContent: {
            NavigationLink {
                RecipeCategoryList(category: category.kind.recipeCategory)
            } label: {
                Text("See All")
                    .font(.subheadline)
                    .foregroundStyle(.accent)
            }
        }
        .padding(.horizontal, 16)
    }
}
