//
//  SearchByIngredientsView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import SwiftUI
import CachedAsyncImage

struct SearchByIngredientsView: View {
    @StateObject private var viewModel = SearchByIngredientsViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var newIngredient: String = ""

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Search Results
                if viewModel.isLoading {
                    loadingSection
                } else if !viewModel.searchResults.isEmpty {
                    resultsSection
                } else if viewModel.hasSearched && !viewModel.ingredients.isEmpty {
                    ContentUnavailableView {
                        Label("No recipes found", systemImage: "magnifyingglass")
                    } description: {
                        Text("Try adding different ingredients or check your spelling")
                    } actions: {
                        Button("Clear Ingredients") {
                            viewModel.handle(.clearIngredients)
                        }
                        .buttonStyle(.bordered)
                        .clipShape(Capsule())
                    }
                } else if !viewModel.ingredients.isEmpty {
                    ContentUnavailableView {
                        Label("Ready to Search", systemImage: "magnifyingglass")
                    } description: {
                        Text("Tap the Search button to find recipes with your ingredients")
                    } actions: {
                        Button("Search") {
                            viewModel.handle(.search)
                        }
                        .buttonStyle(.borderedProminent)
                        .clipShape(Capsule())
                    }
                } else {
                    ContentUnavailableView {
                        Label("Search by Ingredients", systemImage: "carrot")
                    } description: {
                        Text("Add ingredients you have to find recipes you can make")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                // Ingredients Input
                ingredientsInputSection
            }
        }
        .navigationTitle("Search by Ingredients")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Search") {
                    viewModel.handle(.search)
                }
                .buttonStyle(.bordered)
                .clipShape(Capsule())
                .tint(viewModel.ingredients.isEmpty ? .secondary : .accent)
                .disabled(viewModel.ingredients.isEmpty)
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

    // MARK: - Ingredients Input Section

    private var ingredientsInputSection: some View {
        VStack(spacing: 16) {
            // Add ingredient input
            HStack {
                TextField("Add ingredient...", text: $newIngredient)
                    .onSubmit(addIngredientButtonAction)
                    .clippedWithPaddingAndBackground(Color(.tertiarySystemGroupedBackground))

                Button("Add", action: addIngredientButtonAction)
                    .disabled(newIngredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .buttonStyle(.bordered)
                    .clipShape(Capsule())
            }

            // Ingredients list
            if !viewModel.ingredients.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.ingredients, id: \.self) { ingredient in
                            HStack(spacing: 4) {
                                Text(ingredient)
                                    .font(.caption)
                                    .fontWeight(.medium)

                                Button {
                                    viewModel.handle(.removeIngredient(ingredient))
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.accent.opacity(0.1))
                            .foregroundStyle(.accent)
                            .clipShape(Capsule())
                        }
                    }
                }

                Button("Clear All") {
                    viewModel.handle(.clearIngredients)
                }
                .buttonStyle(.bordered)
                .clipShape(Capsule())
                .font(.caption)
            }
        }
        .clippedWithPaddingAndBackground()
        .padding(8)
    }

    private func addIngredientButtonAction() {
        withAnimation {
            viewModel.handle(.addIngredient(newIngredient))
            newIngredient = ""
        }
    }

        // MARK: - Loading Section
    
    private var loadingSection: some View {
        ContentUnavailableView {
            ProgressView()
                .scaleEffect(1.2)
        } description: {
            Text("Finding recipes...")
        }
    }

    // MARK: - Results Section

    private var resultsSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.searchResults, id: \.id) { recipe in
                    NavigationLink {
                        RecipeDetailsPageView(recipeShortInfo: .init(id: recipe.id, title: recipe.title))
                    } label: {
                        RecipeByIngredientsCard(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Supporting Views

struct RecipeByIngredientsCard: View {
    let recipe: RecipeByIngredientsResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Recipe image
            if let imageURL = recipe.image, let url = URL(string: imageURL) {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ShimmerView()
                }
                .frame(height: 160)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ShimmerView(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Recipe info
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                // Ingredient stats
                HStack(spacing: 16) {
                    Label("\(recipe.usedIngredientCount) used", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                    Label("\(recipe.missedIngredientCount) missing", systemImage: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                    if let likes = recipe.likes, likes > 0 {
                        Label("\(likes) likes", systemImage: "heart.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
            }
        }
        .clippedWithPaddingAndBackground()
    }
}
