import SwiftUI
import Combine
import CachedAsyncImage

struct SavedRecipesPageView: View {

    // MARK: - Private properties

    @StateObject private var viewModel = SavedRecipesPageViewModel()

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
                searchResultsView
            } else {
                mainContentView
            }
        }
        .safeAreaInset(edge: .top) {
            // Custom Navigation Bar
            customNavigationBar
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

    // MARK: - Custom Navigation Bar
    private var customNavigationBar: some View {
        HStack {
            Text("Saved Recipes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Button {
                viewModel.isSearchActive.toggle()
            } label: {
                Image(systemName: viewModel.isSearchActive ? "xmark.circle.fill" : "magnifyingglass")
                    .font(.title2)
                    .foregroundStyle(.accent)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }

    // MARK: - Search Results View
    private var searchResultsView: some View {
        Group {
            if filteredRecipes.isEmpty {
                EmptyStateView.nothingFound
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredRecipes) { recipe in
                            SavedRecipeCard(recipe: recipe)
                        }
                    }
                    .padding(16)
                    .if(isPad) { view in
                        view.frame(maxWidth: 580, alignment: .center)
                    }
                    .animation(.easeInOut, value: filteredRecipes)
                }
            }
        }
    }

    // MARK: - Main Content View
    private var mainContentView: some View {
        Group {
            if viewModel.allRecipes.isEmpty {
                EmptyStateView.savedRecipesPlaceholder
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Summary section
                        summarySection
                        
                        // Grouped recipes by meal type
                        ForEach(MealType.allCases, id: \.self) { mealType in
                            if let recipes = viewModel.groupedRecipes[mealType], !recipes.isEmpty {
                                SavedRecipesSection(
                                    mealType: mealType,
                                    title: viewModel.mealTypeTitles[mealType] ?? mealType.title,
                                    recipes: Array(recipes)
                                )
                            }
                        }
                    }
                    .padding(16)
                    .if(isPad) { view in
                        view.frame(maxWidth: 580, alignment: .center)
                    }
                }
            }
        }
    }

    // MARK: - Summary Section
    private var summarySection: some View {
        CustomSectionView(header: "Your Collection") {
            HStack(spacing: 12) {
                SummaryStatCard(
                    icon: "bookmark.fill",
                    value: "\(viewModel.allRecipes.count)",
                    label: "Saved Recipes",
                    color: .blue
                )
                
                SummaryStatCard(
                    icon: "heart.fill",
                    value: "\(viewModel.groupedRecipes.values.reduce(0) { $0 + $1.count })",
                    label: "Categories",
                    color: .red
                )
                
                SummaryStatCard(
                    icon: "clock.fill",
                    value: "\(viewModel.allRecipes.filter { $0.readyInMinutes ?? 0 <= 30 }.count)",
                    label: "Quick Meals",
                    color: .orange
                )
            }
        }
    }
}

// MARK: - Supporting Views

struct SavedRecipesSection: View {
    let mealType: MealType
    let title: String
    let recipes: [RecipeShortInfo]
    
    var body: some View {
        CustomSectionView(header: title, headerFontStyle: .large) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(recipes.prefix(4))) { recipe in
                        SavedRecipeCard(recipe: recipe)
                    }
                }
            }
            .scrollClipDisabled()
        } trailingContent: {
            if recipes.count > 4 {
                NavigationLink {
                    RecipeCollectionPageView(recipes: recipes)
                } label: {
                    Text("See All")
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
            }
        }
    }
}

struct SavedRecipeCard: View {
    let recipe: RecipeShortInfo
    
    var body: some View {
        NavigationLink {
            RecipeDetailsPageView(recipeShortInfo: recipe)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Recipe image
                if let imageURL = recipe.imageUrl {
                    CachedAsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ShimmerView()
                    }
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    ShimmerView(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Recipe info
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: 180)

                    HStack(spacing: 12) {
                        if let readyInMinutes = recipe.readyInMinutes {
                            Label(readyInMinutes.minutesFormatted, systemImage: "clock")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let score = recipe.score {
                            Label(String(format: "%.1f", score), systemImage: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.yellow)
                        }
                    }
                }
            }
            .padding(12)
            .clippedWithBackground(Color(.tertiarySystemGroupedBackground))
        }
        .buttonStyle(.plain)
    }
}

struct SummaryStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .clippedWithBackground(Color(.tertiarySystemGroupedBackground))
    }
}

