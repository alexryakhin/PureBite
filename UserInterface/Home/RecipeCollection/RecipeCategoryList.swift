//
//  RecipeCategoryList.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import SwiftUI

enum RecipeCategory: CaseIterable {
    case recommended
    case trending
    case quickMeals
    case healthy
    case vegetarian
    case desserts
    case soups
    case breakfast
    case lunch
    case dinner
    
    var title: String {
        switch self {
        case .recommended: "Recommended for you"
        case .trending: "Trending Recipes"
        case .quickMeals: "Quick Meals"
        case .healthy: "Healthy Recipes"
        case .vegetarian: "Vegetarian"
        case .desserts: "Desserts"
        case .soups: "Soups"
        case .breakfast: "Breakfast"
        case .lunch: "Lunch"
        case .dinner: "Dinner"
        }
    }
    
    var icon: String {
        switch self {
        case .recommended: "heart.fill"
        case .trending: "flame.fill"
        case .quickMeals: "clock.fill"
        case .healthy: "leaf.fill"
        case .vegetarian: "carrot.fill"
        case .desserts: "birthday.cake.fill"
        case .soups: "bowl.fill"
        case .breakfast: "sunrise.fill"
        case .lunch: "sun.max.fill"
        case .dinner: "moon.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .recommended: .red
        case .trending: .orange
        case .quickMeals: .green
        case .healthy: .mint
        case .vegetarian: .green
        case .desserts: .pink
        case .soups: .blue
        case .breakfast: .yellow
        case .lunch: .orange
        case .dinner: .purple
        }
    }
    
    var searchParams: SearchRecipesParams {
        switch self {
        case .recommended:
            return SearchRecipesParams(
                sort: .random,
                number: 20
            )
        case .trending:
            return SearchRecipesParams(
                sort: .popularity,
                number: 20
            )
        case .quickMeals:
            return SearchRecipesParams(
                maxReadyTime: 30,
                sort: .time,
                number: 20
            )
        case .healthy:
            return SearchRecipesParams(
                sort: .healthiness,
                number: 20
            )
        case .vegetarian:
            return SearchRecipesParams(
                diet: [.vegetarian],
                sort: .popularity,
                number: 20
            )
        case .desserts:
            return SearchRecipesParams(
                type: .dessert,
                sort: .popularity,
                number: 20
            )
        case .soups:
            return SearchRecipesParams(
                type: .soup,
                sort: .popularity,
                number: 20
            )
        case .breakfast:
            return SearchRecipesParams(
                type: .breakfast,
                sort: .popularity,
                number: 20
            )
        case .lunch:
            return SearchRecipesParams(
                type: .lunch,
                sort: .popularity,
                number: 20
            )
        case .dinner:
            return SearchRecipesParams(
                type: .dinner,
                sort: .popularity,
                number: 20
            )
        }
    }
}

struct RecipeCategoryList: View {
    let category: RecipeCategory
    @StateObject private var viewModel = RecipeCategoryListViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ContentUnavailableView {
                    ProgressView()
                        .scaleEffect(1.2)
                } description: {
                    Text("Loading \(category.title.lowercased())...")
                }
            } else if viewModel.recipes.isEmpty {
                ContentUnavailableView {
                    Label("No recipes found", systemImage: category.icon)
                } description: {
                    Text("Try again later or check your connection")
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.recipes) { recipe in
                            RecipeDetailsLinkView(
                                props: .init(
                                    recipeShortInfo: recipe,
                                    aspectRatio: nil
                                )
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .safeAreaInset(edge: .top) {
            OfflineBannerView()
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.large)
        .trackScreen(ScreenEvent(rawValue: "screen_\(category.title.lowercased().replacingOccurrences(of: " ", with: "_"))") ?? .mainPage)
        .onAppear {
            if viewModel.recipes.isEmpty && !viewModel.isLoading {
                viewModel.loadRecipes(for: category)
            }
            // Track category viewed
            AnalyticsService.shared.trackCategory(.viewed(name: category.title))
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

@MainActor
final class RecipeCategoryListViewModel: SwiftUIBaseViewModel {
    @Published var recipes: [RecipeShortInfo] = []
    
    private let spoonacularNetworkService: SpoonacularNetworkService
    
    override init() {
        self.spoonacularNetworkService = SpoonacularNetworkService.shared
        super.init()
    }
    
    func loadRecipes(for category: RecipeCategory) {
        Task {
            setLoading(true)
            defer {
                setLoading(false)
            }
            
            do {
                if category == .recommended {
                    // Load similar recipes based on saved recipes
                    let savedRecipesService = SavedRecipesService.shared
                    let savedRecipes = savedRecipesService.savedRecipes
                    
                    if savedRecipes.isEmpty {
                        // If no saved recipes, show empty state
                        recipes = []
                        return
                    }
                    
                    // Get similar recipes based on saved recipes
                    var recommendedRecipes: [RecipeShortInfo] = []
                    for savedRecipe in savedRecipes.prefix(3) { // Use up to 3 saved recipes
                        do {
                            let similarRecipes = try await spoonacularNetworkService.similarRecipes(id: savedRecipe.id)
                            recommendedRecipes.append(contentsOf: similarRecipes)
                        } catch {
                            print("❌ [RECOMMENDED] Error loading similar recipes for \(savedRecipe.id): \(error)")
                        }
                    }
                    
                    // Remove duplicates and limit to 20
                    let uniqueRecipes = Array(Set(recommendedRecipes)).prefix(20)
                    recipes = Array(uniqueRecipes)
                } else {
                    // Load regular categories
                    let response = try await spoonacularNetworkService.searchRecipes(params: category.searchParams)
                    recipes = response.results.map(\.recipeShortInfo)
                }
            } catch {
                handleError(error)
            }
        }
    }
} 
