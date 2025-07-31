import SwiftUI
import Combine
import CachedAsyncImage
import Charts

struct RecipeDetailsPageView: View {

    private enum Constant {
        static let imageHeight: CGFloat = 320
        static let headerHeight: CGFloat = 200
    }

    // MARK: - Private properties

    @StateObject var viewModel: RecipeDetailsPageViewModel
    @Environment(\.dismiss) var dismiss

    init(recipeShortInfo: RecipeShortInfo) {
        self._viewModel = .init(wrappedValue: .init(recipeShortInfo: recipeShortInfo))
    }

    @State private var scrollOffset: CGFloat = .zero
    @State private var imageExists: Bool = true
    @State private var shouldHaveNavigationTitle: Bool = false
    @State private var selectedTab: RecipeTab = .overview
    @State private var showingNutritionSheet = false

    // MARK: - Body

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if viewModel.isLoading {
                RecipeDetailsLoadingView()
            } else {
                ScrollViewWithReader(scrollOffset: $scrollOffset) {
                    VStack(spacing: 0) {
                        // Hero Image Section
                        if imageExists, let imageUrl = viewModel.recipe?.imageUrl {
                            heroImageView(url: imageUrl)
                        }

                        // Content
                        VStack(spacing: 16) {
                            // Recipe Header
                            recipeHeaderView
                            
                            // Tab Picker
                            tabPickerView
                            
                            // Tab Content
                            tabContentView
                        }
                        .padding(16)
                    }
                    .onChange(of: scrollOffset) { newValue in
                        let topOffset: CGFloat = !imageExists ? 70 : Constant.imageHeight + 30
                        withAnimation {
                            shouldHaveNavigationTitle = newValue <= -topOffset
                        }
                    }
                }
                .safeAreaInset(edge: .top) {
                    CustomNavigationBar(
                        title: viewModel.recipeShortInfo.title,
                        isFavorite: viewModel.isFavorite,
                        onFavorite: { viewModel.handle(.favorite) },
                        onNutrition: { showingNutritionSheet = true }
                    )
                    .opacity(shouldHaveNavigationTitle ? 1 : 0)
                    .overlay {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                            }

                            Spacer()

                            HStack(spacing: 16) {
                                Button {
                                    showingNutritionSheet = true
                                } label: {
                                    Image(systemName: "chart.pie.fill")
                                        .font(.title3)
                                        .foregroundStyle(.accent)
                                }

                                Button {
                                    viewModel.handle(.favorite)
                                } label: {
                                    Image(systemName: viewModel.isFavorite ? "bookmark.fill" : "bookmark")
                                        .font(.title3)
                                        .foregroundStyle(viewModel.isFavorite ? .yellow : .primary)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .opacity(!shouldHaveNavigationTitle ? 1 : 0)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar) // Ensure it's hidden
        .navigationBarHidden(true)
        .sheet(isPresented: $showingNutritionSheet) {
            NutritionDetailSheet(recipe: viewModel.recipe)
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An error occurred")
        }
    }

    // MARK: - Hero Image View
    private func heroImageView(url: URL) -> some View {
        GeometryReader { geometry in
            let offset = geometry.frame(in: .global).minY
            let height = max(Constant.imageHeight, Constant.imageHeight + offset)

            CachedAsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ShimmerView()
                        .frame(width: UIScreen.main.bounds.width, height: height)
                case .success(let imageView):
                    imageView
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: height)
                        .clipped()
                case .failure:
                    Color(.systemGray5)
                        .frame(width: UIScreen.main.bounds.width, height: height)
                        .onAppear { imageExists = false }
                }
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, Color(.systemGroupedBackground)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                .offset(y: height - 100),
                alignment: .bottom
            )
            .offset(y: offset > 0 ? -offset : 0)
            .frame(height: height)
        }
        .frame(height: Constant.imageHeight)
    }

    // MARK: - Recipe Header
    private var recipeHeaderView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and Rating
            VStack(alignment: .leading, spacing: 8) {
                if let title = viewModel.recipe?.title {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                
                HStack(spacing: 16) {
                    if let score = viewModel.recipe?.score {
                        StarRatingView(score: score)
                    }
                    
                    if let likes = viewModel.recipe?.likes {
                        Label("\(likes)", systemImage: "heart.fill")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }
                }
            }
            
            // Quick Stats
            if let recipe = viewModel.recipe {
                QuickStatsView(recipe: recipe)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Tab Picker
    private var tabPickerView: some View {
        Picker("Recipe Sections", selection: $selectedTab) {
            ForEach(RecipeTab.allCases, id: \.self) { tab in
                Text(tab.title).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .padding(.vertical, 8)
    }

    // MARK: - Tab Content
    @ViewBuilder
    private var tabContentView: some View {
        switch selectedTab {
        case .overview:
            overviewTabView
        case .ingredients:
            IngredientsTabView(
                ingredients: viewModel.recipe?.ingredients.removedDuplicates ?? [],
                onIngredientSelected: { ingredient in
                    viewModel.handle(.ingredientSelected(ingredient))
                }
            )
        case .instructions:
            InstructionsTabView(instructions: viewModel.recipe?.instructions)
        case .nutrition:
            NutritionTabView(recipe: viewModel.recipe)
        }
    }

    private var overviewTabView: some View {
        LazyVStack(spacing: 16) {
            if let summary = viewModel.recipe?.summary {
                CustomSectionView(header: "About this recipe") {
                    HTMLTextView(htmlString: summary)
                }
            }

            if let macros = viewModel.recipe?.macros, macros.isNotEmpty {
                MacrosChartView(macros: macros)
            }

            if let recipe = viewModel.recipe {
                RecipeRecommendationsView(
                    recipe: recipe,
                    similarRecipes: viewModel.similarRecipes,
                    isLoadingSimilarRecipes: viewModel.isLoadingSimilarRecipes,
                    onLoadSimilarRecipes: { viewModel.handle(.loadSimilarRecipes) }
                )
            }
        }
    }
}

// MARK: - Supporting Views

struct HTMLTextView: View {
    let htmlString: String
    
    var body: some View {
        Text(attributedString)
            .textSelection(.enabled)
            .font(.body)
            .lineSpacing(4)
    }
    
    private var attributedString: AttributedString {
        do {
            let data = Data(htmlString.utf8)
            let attributedString = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            
            // Apply custom styling
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            
            // Set font family and size
            let font = UIFont.preferredFont(forTextStyle: .body)
            let range = NSRange(location: 0, length: mutableAttributedString.length)
            mutableAttributedString.addAttribute(.font, value: font, range: range)
            
            // Set line spacing
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            paragraphStyle.paragraphSpacing = 8
            mutableAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            
            return AttributedString(mutableAttributedString)
        } catch {
            return AttributedString(htmlString)
        }
    }
}

struct CustomNavigationBar: View {
    let title: String
    let isFavorite: Bool
    let onFavorite: () -> Void
    let onNutrition: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: onNutrition) {
                    Image(systemName: "chart.pie.fill")
                        .font(.title3)
                        .foregroundStyle(.accent)
                }
                
                Button(action: onFavorite) {
                    Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundStyle(isFavorite ? .yellow : .primary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .overlay(alignment: .bottom) {
            Divider()
        }
        .animation(.easeInOut(duration: 0.3), value: true)
    }
}

struct RecipeDetailsLoadingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Hero Image Shimmer
                ShimmerView(height: 320)
                
                VStack(spacing: 16) {
                    // Recipe Header Shimmer
                    VStack(alignment: .leading, spacing: 16) {
                        // Title Shimmer
                        ShimmerView(height: 32)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Rating and Stats Shimmer
                        HStack(spacing: 16) {
                            ShimmerView(width: 100, height: 20)
                            ShimmerView(width: 60, height: 20)
                        }
                        
                        // Quick Stats Shimmer
                        HStack(spacing: 20) {
                            ForEach(0..<3, id: \.self) { _ in
                                VStack(spacing: 8) {
                                    ShimmerView(width: 24, height: 24)
                                        .clipShape(Circle())
                                    
                                    ShimmerView(width: 40, height: 16)
                                    
                                    ShimmerView(width: 50, height: 12)
                                }
                            }
                        }
                        .clippedWithPaddingAndBackground()
                    }
                    .padding(.horizontal, 20)
                    
                    // Tab Picker Shimmer
                    ShimmerView(height: 32)
                        .padding(.horizontal, 20)
                    
                    // Content Shimmer
                    LazyVStack(spacing: 24) {
                        // Summary Card Shimmer
                        VStack(alignment: .leading, spacing: 12) {
                            ShimmerView(height: 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 8) {
                                ForEach(0..<4, id: \.self) { _ in
                                    ShimmerView(height: 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .clippedWithPaddingAndBackground()
                        .padding(.horizontal, 20)
                        
                        // Nutrition Chart Shimmer
                        VStack(alignment: .leading, spacing: 16) {
                            ShimmerView(height: 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ShimmerView(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            HStack(spacing: 20) {
                                ForEach(0..<3, id: \.self) { _ in
                                    HStack(spacing: 8) {
                                        ShimmerView(width: 12, height: 12)
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            ShimmerView(width: 40, height: 10)
                                            ShimmerView(width: 30, height: 10)
                                        }
                                    }
                                }
                            }
                        }
                        .clippedWithPaddingAndBackground()
                        .padding(.horizontal, 20)
                        
                        // Similar Recipes Shimmer
                        VStack(alignment: .leading, spacing: 16) {
                            ShimmerView(height: 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(0..<3, id: \.self) { _ in
                                        VStack(alignment: .leading, spacing: 8) {
                                            ShimmerView(width: 120, height: 80)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            
                                            ShimmerView(width: 100, height: 12)
                                            
                                            ShimmerView(width: 80, height: 10)
                                        }
                                        .frame(width: 120)
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                            .scrollClipDisabled()
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 100)
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading recipe...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct StarRatingView: View {
    let score: Double
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index < Int(score) ? "star.fill" : "star")
                    .foregroundStyle(index < Int(score) ? .yellow : .gray)
                    .font(.caption)
            }
            Text(String(format: "%.1f", score))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct QuickStatsView: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 20) {
            StatItem(
                icon: "clock.fill",
                value: recipe.readyInMinutes.minutesFormatted,
                label: "Time"
            )
            
            StatItem(
                icon: "person.2.fill",
                value: "\(recipe.servings)",
                label: "Servings"
            )
            
            StatItem(
                icon: "flame.fill",
                value: "\(Int(recipe.macros.calories))",
                label: "Calories"
            )
        }
        .padding(vertical: 16, horizontal: 20)
        .clippedWithBackground()
    }
}

struct StatItem: View {
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

// MARK: - Tab Content Views

struct MacrosChartView: View {
    let macros: Macros
    
    var body: some View {
        CustomSectionView(header: "Nutrition Breakdown") {
            VStack(alignment: .leading, spacing: 16) {
                Chart {
                    SectorMark(
                        angle: .value("Carbs", macros.carbohydratesPercent),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .foregroundStyle(.blue)

                    SectorMark(
                        angle: .value("Protein", macros.proteinPercent),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .foregroundStyle(.red)

                    SectorMark(
                        angle: .value("Fat", macros.fatPercent),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .foregroundStyle(.orange)
                }
                .frame(height: 200)

                // Legend
                HStack(spacing: 20) {
                    MacroLegendItem(color: .blue, name: "Carbs", value: "\(Int(macros.carbohydratesGrams))g")
                    MacroLegendItem(color: .red, name: "Protein", value: "\(Int(macros.proteinGrams))g")
                    MacroLegendItem(color: .orange, name: "Fat", value: "\(Int(macros.fatGrams))g")
                }
            }
        }
    }
}

struct MacroLegendItem: View {
    let color: Color
    let name: String
    let value: String
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct RecipeRecommendationsView: View {
    let recipe: Recipe
    let similarRecipes: [RecipeShortInfo]
    let isLoadingSimilarRecipes: Bool
    let onLoadSimilarRecipes: () -> Void
    
    var body: some View {
        CustomSectionView(header: "You might also like") {
            VStack(alignment: .leading, spacing: 16) {
                if similarRecipes.isEmpty && !isLoadingSimilarRecipes {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<3, id: \.self) { _ in
                                RecommendationCard()
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .scrollClipDisabled()
                } else if isLoadingSimilarRecipes {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<3, id: \.self) { _ in
                                RecommendationCard()
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .scrollClipDisabled()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 16) {
                            ForEach(similarRecipes.prefix(5), id: \.id) { recipe in
                                SimilarRecipeCard(recipe: recipe)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .scrollClipDisabled()
                }
            }
        }
        .onAppear {
            onLoadSimilarRecipes()
        }
    }
}

struct SimilarRecipeCard: View {
    let recipe: RecipeShortInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageURL = recipe.imageUrl {
                CachedAsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "fork.knife")
                                .foregroundStyle(.secondary)
                        )
                }
                .frame(width: 120, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.3))
                    .frame(width: 120, height: 80)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .foregroundStyle(.secondary)
                    )
            }
            
            Text(recipe.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .frame(width: 120)
    }
}

struct RecommendationCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.3))
                .frame(width: 120, height: 80)
                .overlay(
                    Image(systemName: "fork.knife")
                        .foregroundStyle(.secondary)
                )
            
            Text("Similar Recipe")
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
        }
        .frame(width: 120)
    }
}

struct IngredientsTabView: View {
    let ingredients: [IngredientRecipeInfo]
    let onIngredientSelected: (IngredientRecipeInfo) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(ingredients, id: \.id) { ingredient in
                IngredientRowView(ingredient: ingredient) {
                    onIngredientSelected(ingredient)
                }
            }
        }
    }
}

struct IngredientRowView: View {
    let ingredient: IngredientRecipeInfo
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Ingredient Image or Icon
                if let imageUrl = ingredient.imageURL {
                    CachedAsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "leaf.fill")
                            .foregroundStyle(.green)
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundStyle(.green)
                        .frame(width: 50, height: 50)
                        .background(.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(ingredient.name.capitalized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                    
                    Text("\(ingredient.amount, specifier: "%.1f") \(ingredient.unit)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "bag.fill.badge.plus")
                    .foregroundStyle(.accent)
                    .font(.title2)
            }
            .clippedWithPaddingAndBackground()
        }
        .buttonStyle(.plain)
    }
}

struct InstructionsTabView: View {
    let instructions: String?
    
    var body: some View {
        if let instructions = instructions {
            InstructionsView(instructions: instructions)
        } else {
            EmptyStateView(title: "No instructions available")
                .frame(maxWidth: .infinity, alignment: .center)
                .clippedWithPaddingAndBackground()
                .padding(16)
        }
    }
}

struct InstructionsView: View {
    let instructions: String
    
    var body: some View {
        CustomSectionView(header: "Instructions") {
            VStack(alignment: .leading, spacing: 16) {
                // Try to parse as numbered steps first
                if let steps = parseNumberedSteps(from: instructions) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.accent)
                                    .frame(width: 24, alignment: .center)

                                Text(step)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                } else {
                    // Fallback to HTML rendering
                    HTMLTextView(htmlString: instructions)
                }
            }
        }
    }
    
    private func parseNumberedSteps(from htmlString: String) -> [String]? {
        // First, try to extract <li> tags from HTML
        let liPattern = "<li[^>]*>(.*?)</li>"
        
        do {
            let regex = try NSRegularExpression(pattern: liPattern, options: [.dotMatchesLineSeparators])
            let range = NSRange(location: 0, length: htmlString.utf16.count)
            let matches = regex.matches(in: htmlString, range: range)
            
            if matches.count > 1 {
                var steps: [String] = []
                
                for match in matches {
                    let stepRange = match.range(at: 1) // Capture group for the content
                    if let range = Range(stepRange, in: htmlString) {
                        let stepText = String(htmlString[range])
                            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if !stepText.isEmpty {
                            steps.append(stepText)
                        }
                    }
                }
                
                if steps.count > 1 {
                    print("🔍 [INSTRUCTIONS_DEBUG] Found \(steps.count) steps from <li> tags")
                    return steps
                }
            }
        } catch {
            print("❌ [INSTRUCTIONS_DEBUG] Regex error for <li> pattern: \(error)")
        }
        
        // Fallback: Remove HTML tags and try to split by common step indicators
        let cleanText = htmlString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        
        print("🔍 [INSTRUCTIONS_DEBUG] Clean text: \(cleanText.prefix(200))...")
        
        // Try to split by common step indicators
        let stepPatterns = [
            "\\d+\\.\\s*",           // "1. "
            "Step\\s*\\d+\\s*",      // "Step 1"
            "\\d+\\)\\s*",           // "1) "
            "\\d+\\s*\\."            // "1 ."
        ]
        
        for pattern in stepPatterns {
            do {
                let regex = try NSRegularExpression(pattern: pattern)
                let range = NSRange(location: 0, length: cleanText.utf16.count)
                let matches = regex.matches(in: cleanText, range: range)
                
                print("🔍 [INSTRUCTIONS_DEBUG] Pattern '\(pattern)' found \(matches.count) matches")
                
                if matches.count > 1 {
                    var steps: [String] = []
                    var lastEnd = 0
                    
                    for match in matches {
                        let stepStart = match.range.location
                        if stepStart > lastEnd {
                            let stepText = String(cleanText[cleanText.index(cleanText.startIndex, offsetBy: lastEnd)..<cleanText.index(cleanText.startIndex, offsetBy: stepStart)])
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                            if !stepText.isEmpty {
                                steps.append(stepText)
                            }
                        }
                        lastEnd = match.range.location + match.range.length
                    }
                    
                    // Add the last step
                    if lastEnd < cleanText.count {
                        let lastStep = String(cleanText[cleanText.index(cleanText.startIndex, offsetBy: lastEnd)...])
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        if !lastStep.isEmpty {
                            steps.append(lastStep)
                        }
                    }
                    
                    if steps.count > 1 {
                        print("🔍 [INSTRUCTIONS_DEBUG] Found \(steps.count) steps")
                        return steps
                    }
                }
            } catch {
                print("❌ [INSTRUCTIONS_DEBUG] Regex error for pattern '\(pattern)': \(error)")
                continue
            }
        }
        
        // If no numbered steps found, try to split by sentences that look like instructions
        let sentences = cleanText.components(separatedBy: ". ")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        if sentences.count > 2 {
            print("🔍 [INSTRUCTIONS_DEBUG] Using sentence-based parsing with \(sentences.count) sentences")
            return sentences
        }
        
        print("🔍 [INSTRUCTIONS_DEBUG] No numbered steps found, using HTMLTextView")
        return nil
    }
}

struct NutritionTabView: View {
    let recipe: Recipe?
    
    var body: some View {
        VStack(spacing: 20) {
            if let macros = recipe?.macros {
                NutritionDetailView(macros: macros)
            }
            
            if let recipe = recipe {
                NutritionFactsView(recipe: recipe)
            }
        }
    }
}

struct NutritionDetailView: View {
    let macros: Macros
    
    var body: some View {
        CustomSectionView(header: "Nutrition Facts") {
            VStack(spacing: 12) {
                NutritionRow(label: "Calories", value: "\(Int(macros.calories))")
                NutritionRow(label: "Protein", value: "\(Int(macros.proteinGrams))g")
                NutritionRow(label: "Carbohydrates", value: "\(Int(macros.carbohydratesGrams))g")
                NutritionRow(label: "Fat", value: "\(Int(macros.fatGrams))g")
            }
        }
    }
}

struct NutritionRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct NutritionFactsView: View {
    let recipe: Recipe
    
    var body: some View {
        CustomSectionView(header: "Health Score") {
            CircularProgressView(
                progress: Double(recipe.healthScore) / 100.0,
                score: Int(recipe.healthScore)
            )
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    let score: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray.opacity(0.3), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: progress)
            
            VStack(spacing: 4) {
                Text("\(score)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("out of 100")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 120, height: 120)
    }
}

struct NutritionDetailSheet: View {
    let recipe: Recipe?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if let macros = recipe?.macros {
                        MacrosChartView(macros: macros)
                        NutritionDetailView(macros: macros)
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Nutrition Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Enums

enum RecipeTab: CaseIterable {
    case overview, ingredients, instructions, nutrition
    
    var title: String {
        switch self {
        case .overview: return "Overview"
        case .ingredients: return "Ingredients"
        case .instructions: return "Instructions"
        case .nutrition: return "Nutrition"
        }
    }
}
