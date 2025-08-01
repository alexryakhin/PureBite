//
//  RecipeCategoryList.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import SwiftUI

enum RecipeCategory: CaseIterable {
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
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if viewModel.recipes.isEmpty && !viewModel.isLoading {
                viewModel.loadRecipes(for: category)
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
                let response = try await spoonacularNetworkService.searchRecipes(params: category.searchParams)
                recipes = response.results.map(\.recipeShortInfo)
            } catch {
                handleError(error)
            }
        }
    }
} 
