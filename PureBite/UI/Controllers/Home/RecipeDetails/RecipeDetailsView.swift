import SwiftUI
import Combine
import RichText

struct RecipeDetailsView: PageView {

    typealias Props = RecipeDetailsContentProps
    typealias ViewModel = RecipeDetailsViewModel

    // MARK: - Private properties

    @ObservedObject var props: Props
    @ObservedObject var viewModel: ViewModel

    @State private var scrollOffset: CGFloat = .zero

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.props = viewModel.state.contentProps
    }

    // MARK: - Views

    var contentView: some View {
        ScrollViewWithReader(scrollOffset: $scrollOffset) {
            VStack {
                if let image = props.recipe.image {
                    expandingImage(urlString: image)
                } else {
                    Spacer().frame(height: 50)
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
                viewModel.handle(.handleScroll(newValue))
            }
        }
        .overlay(overlayNavigationView, alignment: .top)
    }

    private var titleView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(props.recipe.title)
                .font(.title)
                .fontWeight(.bold)

            HStack {
                if let time = props.recipe.readyInMinutes {
                    Label {
                        Text(time.minutesFormatted)
                    } icon: {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(.accent)
                    }
                    .font(.callout)
                }
                if let healthScore = props.recipe.healthScore {
                    StarRatingLabel(score: healthScore)
                        .font(.callout)
                }

                if let aggregateLikes = props.recipe.aggregateLikes {
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

            AsyncImage(url: URL(string: urlString)) { imageView in
                imageView
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: height
                    )
                    .clipped()
            } placeholder: {
                Color.background
                    .shimmering()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: height
                    )
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.background, Color.clear]),
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

    private func overlayButtons() -> some View {
        HStack {
            Button {
                viewModel.onEvent?(.finish)
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.headline)
            }
            .foregroundStyle(.primary)
            .frame(width: 16, height: 16, alignment: .center)
            .padding(12)
            .background()
            .clipShape(Circle())
            .shadow(radius: 5)

            Spacer()

            Button {
                viewModel.handle(.favorite)
            } label: {
                Image(systemName: "bookmark")
                    .font(.headline)
            }
            .foregroundStyle(.primary)
            .frame(width: 16, height: 16, alignment: .center)
            .padding(12)
            .background()
            .clipShape(Circle())
            .shadow(radius: 5)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 4)
    }

    // MARK: - Summary View
    @ViewBuilder
    private func summaryView() -> some View {
        if let summary = props.recipe.summary {
            VStack(alignment: .leading) {
                Text("Summary")
                    .font(.headline)
                    .tint(.primary)
                RichText(html: summary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.surfaceBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Ingredients View
    @ViewBuilder
    private func ingredientsView() -> some View {
        if let ingredients = props.recipe.extendedIngredients {
            VStack(alignment: .leading) {
                Text("Ingredients")
                    .font(.headline)
                    .tint(.primary)

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(ingredients, id: \.name) { ingredient in
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 10) {
                                if let image = ingredient.image {
                                    AsyncImage(url: URL(string: "https://img.spoonacular.com/ingredients_100x100/\(image)")) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        case .failure:
                                            Image(systemName: "xmark.circle")
                                                .resizable()
                                                .scaledToFit()
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .frame(width: 40, height: 40)
                                    .padding(5)
                                    .background(.white)
                                    .cornerRadius(12)
                                }
                                VStack(alignment: .leading) {
                                    Text(ingredient.name?.capitalized ?? "").textStyle(.headline)
                                    if let amount = ingredient.amount {
                                        Text("\(amount, specifier: amount.defaultSpecifier) \(ingredient.unit.orEmpty)")
                                            .textStyle(.footnote)
                                            .tint(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            if ingredients.last?.id != ingredient.id {
                                Divider()
                                    .padding(.leading, 72)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
                .background(.surfaceBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Instructions View
    @ViewBuilder
    private func instructionsView() -> some View {
        if let instructions = props.recipe.instructions {
            VStack(alignment: .leading) {
                Text("Instructions")
                    .font(.headline)
                    .tint(.primary)

                RichText(html: instructions)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.surfaceBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Nutrition Breakdown
    @ViewBuilder
    private func caloricBreakdownView() -> some View {
        if let caloricBreakdown = props.recipe.nutrition?.caloricBreakdown {
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
                .background(.surfaceBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Nutrition Breakdown
    private var overlayNavigationView: some View {
        VStack(spacing: .zero) {
            Color.clear
                .background(.thinMaterial)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 2)
            Divider()
        }
        .opacity(min(max(-scrollOffset / 70, 0), 1))
//        .frame(height: 2)
    }
}

#if DEBUG
#Preview {
    RecipeDetailsView(
        viewModel: .init(
            recipeId: 1,
            spoonacularNetworkService: SpoonacularNetworkServiceMock(),
            favoritesService: FavoritesServiceMock()
        )
    )
}
#endif
