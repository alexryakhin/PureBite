import SwiftUI
import Combine
import RichText
import CachedAsyncImage

public struct RecipeDetailsPageView: View {

    private enum Constant {
        static let imageHeight: CGFloat = 280
    }

    // MARK: - Private properties

    @ObservedObject public var viewModel: RecipeDetailsPageViewModel

    @State private var scrollOffset: CGFloat = .zero
    @State private var imageExists: Bool = true

    // MARK: - Initialization

    public init(viewModel: RecipeDetailsPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollViewWithReader(scrollOffset: $scrollOffset) {
                    VStack {
                        if imageExists, let imageUrl = viewModel.recipe?.imageUrl {
                            expandingImage(url: imageUrl)
                        } else {
                            Spacer().frame(height: 20)
                        }

                        titleView
                            .padding(.bottom, 20)

                        VStack(spacing: 20) {
                            summaryView()
                            ingredientsView()
                            instructionsView()
                            caloricBreakdownView()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 16)
                    .onChange(of: scrollOffset) { newValue in
                        let topOffset: CGFloat = !imageExists ? 70 : Constant.imageHeight + 30
                        viewModel.isNavigationTitleOnScreen = newValue > -topOffset
                    }
                }
                .overlay(overlayNavigationView, alignment: .top)
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

    private var titleView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = viewModel.recipe?.title {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
            }

            HStack {
                if let time = viewModel.recipe?.readyInMinutes {
                    Label {
                        Text(time.minutesFormatted)
                    } icon: {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.accentColor)
                    }
                    .font(.callout)
                }
                if let score = viewModel.recipe?.score {
                    StarRatingLabel(score: score)
                        .font(.callout)
                }

                if let likes = viewModel.recipe?.likes {
                    Label(
                        title: { Text("\(likes)") },
                        icon: { Image(systemName: "heart.fill").foregroundStyle(.red) }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    private func expandingImage(url: URL) -> some View {
        GeometryReader { geometry in
            let offset = geometry.frame(in: .global).minY
            let height = max(Constant.imageHeight, Constant.imageHeight + offset)

            CachedAsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Color.clear
                        .shimmering()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: height
                        )
                case .success(let imageView):
                    imageView
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: height
                        )
                        .clipped()
                case .failure:
                    Spacer().frame(height: 20)
                        .onAppear {
                            imageExists = false
                        }
                }
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.secondarySystemGroupedBackground), .clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 130)
                .offset(y: height - 130),
                alignment: .top
            )
            .offset(y: offset > 0 ? -offset : 0)
            .frame(height: height)
        }
        .frame(height: Constant.imageHeight)
    }

    // MARK: - Summary View
    @ViewBuilder
    private func summaryView() -> some View {
        if let summary = viewModel.recipe?.summary {
            VStack(alignment: .leading) {
                Text("Summary")
                    .font(.headline)
                    .tint(.primary)
                RichText(html: summary)
                    .placeholder {
                        ProgressView()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Ingredients View
    @ViewBuilder
    private func ingredientsView() -> some View {
        if let ingredients = viewModel.recipe?.ingredients.removedDuplicates {
            VStack(alignment: .leading) {
                Text("Ingredients")
                    .font(.headline)
                    .tint(.primary)
                ListWithDivider(ingredients, dividerLeadingPadding: 78) { ingredient in
                    IngredientCellView(ingredient: ingredient) {
                        viewModel.handle(.ingredientSelected(ingredient))
                    }
                }
                .padding(.vertical, 4)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Instructions View
    @ViewBuilder
    private func instructionsView() -> some View {
        if let instructions = viewModel.recipe?.instructions {
            VStack(alignment: .leading) {
                Text("Instructions")
                    .font(.headline)
                    .tint(.primary)
                RichText(html: instructions)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Nutrition Breakdown
    @ViewBuilder
    private func caloricBreakdownView() -> some View {
        if let macros = viewModel.recipe?.macros, macros.isNotEmpty {
            VStack(alignment: .leading) {
                Text("Macros")
                    .font(.headline)
                    .tint(.primary)

                LineChartView(values: [
                    .init(title: "Carbs", color: .accentColor, percentage: macros.carbohydratesPercent),
                    .init(title: "Fat", color: .orange, percentage: macros.fatPercent),
                    .init(title: "Protein", color: .red, percentage: macros.proteinPercent)
                ])
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Nutrition Breakdown
    private var overlayNavigationView: some View {
        let topOffset: CGFloat = !imageExists ? 0 : -Constant.imageHeight
        return VStack(spacing: .zero) {
            Color.clear
                .background(.thinMaterial)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 2)
            Divider()
        }
        .opacity(min(max(-(scrollOffset - topOffset) / 30, 0), 1))
    }
}

