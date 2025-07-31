import SwiftUI
import Combine
import CachedAsyncImage

struct SavedRecipesPageView: View {

    // MARK: - Private properties

    @ObservedObject var viewModel: SavedRecipesPageViewModel

    init(viewModel: SavedRecipesPageViewModel) {
        self.viewModel = viewModel
    }

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

            VStack(spacing: 0) {
                // Custom Navigation Bar
                customNavigationBar
                
                if viewModel.isSearchActive {
                    searchResultsView
                } else {
                    mainContentView
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
                    LazyVStack(spacing: 24) {
                        // Summary section
                        summarySection
                        
                        // Grouped recipes by meal type
                        ForEach(MealType.allCases, id: \.self) { mealType in
                            if let recipes = viewModel.groupedRecipes[mealType], !recipes.isEmpty {
                                SavedRecipesSection(
                                    mealType: mealType,
                                    recipes: Array(recipes)
                                )
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
    }

    // MARK: - Summary Section
    private var summarySection: some View {
        CustomSectionView(header: "Your Collection") {
            HStack(spacing: 20) {
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
        } trailingContent: {
            EmptyView()
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Supporting Views

struct SavedRecipesSection: View {
    let mealType: MealType
    let recipes: [RecipeShortInfo]
    
    var body: some View {
        CustomSectionView(header: mealType.title) {
            if recipes.count <= 3 {
                // Show all recipes in a grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(recipes) { recipe in
                        SavedRecipeCard(recipe: recipe)
                    }
                }
            } else {
                // Show first 3 + "See All" button
                VStack(spacing: 12) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(recipes.prefix(3)) { recipe in
                            SavedRecipeCard(recipe: recipe)
                        }
                    }
                    
                    if recipes.count > 3 {
                        Button {
                            // Navigate to full category view
                        } label: {
                            HStack {
                                Text("View all \(recipes.count) recipes")
                                Image(systemName: "chevron.right")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.accent)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        } trailingContent: {
            if recipes.count > 3 {
                Button("See All") {
                    // Navigate to full category view
                }
                .font(.subheadline)
                .foregroundStyle(.accent)
            } else {
                EmptyView()
            }
        }
        .padding(.horizontal, 16)
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
                    
                    HStack(spacing: 12) {
                        if let readyInMinutes = recipe.readyInMinutes {
                            Label("\(readyInMinutes)m", systemImage: "clock")
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
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
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
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

