import SwiftUI
import Combine
import RichText
import CachedAsyncImage
import SwiftUISnackbar

public struct RecipeDetailsPageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: RecipeDetailsPageViewModel

    @State private var scrollOffset: CGFloat = .zero

    // MARK: - Initialization

    public init(viewModel: RecipeDetailsPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        ScrollViewWithReader(scrollOffset: $scrollOffset) {
            VStack {
                if let image = viewModel.recipe?.image {
                    expandingImage(urlString: image)
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
                let topOffset: CGFloat = viewModel.recipe?.image == nil ? 0 : 250
                viewModel.isNavigationTitleOnScreen = newValue > -topOffset
            }
        }
        .overlay(overlayNavigationView, alignment: .top)
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
                            .foregroundStyle(.accent)
                    }
                    .font(.callout)
                }
                if let healthScore = viewModel.recipe?.healthScore {
                    StarRatingLabel(score: healthScore)
                        .font(.callout)
                }

                if let aggregateLikes = viewModel.recipe?.aggregateLikes {
                    Label(
                        title: { Text("\(aggregateLikes)") },
                        icon: { Image(systemName: "heart.fill").foregroundStyle(.red) }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    private func expandingImage(urlString: String) -> some View {
        GeometryReader { geometry in
            let offset = geometry.frame(in: .global).minY
            let height = max(280, 280 + offset)

            CachedAsyncImage(url: URL(string: urlString)) { imageView in
                imageView
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: height
                    )
                    .clipped()
            } placeholder: {
                Color.clear
                    .shimmering()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: height
                    )
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.background, .clear]),
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
        .frame(height: 280)
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
                        ProgressView().onDisappear {
                            viewModel.resetAdditionalState()
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .backgroundColor(.surfaceBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Ingredients View
    @ViewBuilder
    private func ingredientsView() -> some View {
        if let ingredients = viewModel.recipe?.extendedIngredients?.removedDuplicates {
            VStack(alignment: .leading) {
                Text("Ingredients")
                    .font(.headline)
                    .tint(.primary)

                ListWithDivider(ingredients, dividerLeadingPadding: 72) { ingredient in
                    ingredientView(ingredient)
                }
                .padding(.vertical, 4)
                .backgroundColor(.surfaceBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private func ingredientView(_ ingredient: ExtendedIngredient) -> some View {
        HStack(spacing: 10) {
            if let image = ingredient.image {
                CachedAsyncImage(url: URL(string: "https://img.spoonacular.com/ingredients_100x100/\(image)")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "minus.circle.fill")
                            .frame(sideLength: 24)
                            .foregroundStyle(.accent)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 40, height: 40)
                .padding(5)
                .background(.white)
                .cornerRadius(12)
                .shadow(radius: 1)
            } else {
                Image(systemName: "minus.circle.fill")
                    .frame(sideLength: 24)
                    .foregroundStyle(.accent)
                    .frame(width: 40, height: 40)
                    .padding(5)
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(radius: 1)
            }
            VStack(alignment: .leading) {
                Text(ingredient.name?.capitalized ?? "")
                    .font(.headline)
                if let amount = ingredient.amount, let str = NumberFormatter().string(from: NSNumber(value: amount)) {

                    Text("\(str) \(ingredient.unit.orEmpty)")
                        .font(.footnote)
                        .tint(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
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
                    .backgroundColor(.surfaceBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Nutrition Breakdown
    @ViewBuilder
    private func caloricBreakdownView() -> some View {
        if let caloricBreakdown = viewModel.recipe?.nutrition?.caloricBreakdown {
            VStack(alignment: .leading) {
                Text("Nutrition Breakdown")
                    .font(.headline)
                    .tint(.primary)

                LineChartView(values: [
                    .init(title: "Carbs", color: .accent, percentage: caloricBreakdown.percentCarbs ?? 0),
                    .init(title: "Fat", color: .orange, percentage: caloricBreakdown.percentFat ?? 0),
                    .init(title: "Protein", color: .red, percentage: caloricBreakdown.percentProtein ?? 0)
                ])
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .backgroundColor(.surfaceBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Nutrition Breakdown
    private var overlayNavigationView: some View {
        let topOffset: CGFloat = viewModel.recipe?.image == nil ? 250 : 0
        return VStack(spacing: .zero) {
            Color.clear
                .background(.thinMaterial)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 2)
            Divider()
        }
        .opacity(min(max(-(scrollOffset - topOffset) / 70, 0), 1))
    }
}

#if DEBUG
#Preview {
    RecipeDetailsPageView(
        viewModel: .init(
            config: .init(recipeId: 1, title: "Title"),
            spoonacularNetworkService: SpoonacularNetworkServiceMock(),
            favoritesService: FavoritesServiceMock()
        )
    )
}
#endif
