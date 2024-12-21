import SwiftUI
import Combine
import RichText
import CachedAsyncImage
import SwiftUISnackbar

public struct RecipeDetailsPageView: PageView {

    private enum Constant {
        static let imageHeight: CGFloat = 280
    }

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
                if let imageUrl = viewModel.recipe?.image {
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
                let topOffset: CGFloat = viewModel.recipe?.image == nil ? 70 : Constant.imageHeight + 30
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

    private func expandingImage(url: URL) -> some View {
        GeometryReader { geometry in
            let offset = geometry.frame(in: .global).minY
            let height = max(Constant.imageHeight, Constant.imageHeight + offset)

            CachedAsyncImage(url: url) { imageView in
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
                    Button {
                        viewModel.handle(
                            .ingredientSelected(
                                .init(
                                    id: ingredient.id,
                                    name: ingredient.name ?? .empty,
                                    amount: ingredient.amount,
                                    unit: ingredient.unit
                                )
                            )
                        )
                    } label: {
                        ExtendedIngredientCellView(ingredient: ingredient)
                    }
                }
                .padding(.vertical, 4)
                .backgroundColor(.surfaceBackground)
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
        let topOffset: CGFloat = viewModel.recipe?.image == nil ? 0 : -Constant.imageHeight
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
