import SwiftUI
import Combine

struct RecipeDetailsView: PageView {

    typealias Props = RecipeDetailsContentProps
    typealias ViewModel = RecipeDetailsViewModel

    // MARK: - Private properties

    @ObservedObject var props: Props
    @ObservedObject var viewModel: ViewModel

    @State private var isShowingFullSummary: Bool = false

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.props = viewModel.state.contentProps
    }

    // MARK: - Views

    var contentView: some View {
        ScrollView {
            VStack {
                if let image = props.recipe.image {
                    expandingImage(urlString: image)
                }

                titleView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlay(alignment: .top) {
            overlayButtons()
        }
    }

    private var titleView: some View {
        VStack(alignment: .leading) {
            Text("\(props.recipe.title)")
                .textStyle(.title3)
                .fontWeight(.semibold)

            HStack {
                if let time = props.recipe.readyInMinutes {
                    Label {
                        Text("\(time) min")
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


            if let summary = props.recipe.summary {
                Text(summary.htmlStringFormatted)
                    .lineLimit(isShowingFullSummary ? 999 : 2)

                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isShowingFullSummary.toggle()
                        }
                    }) {
                        Text(isShowingFullSummary ? "Shrink" : "More")
                            .textStyle(.callout)
                            .foregroundColor(.accent)
                    }
                }
            }

            ingredientsView()
            instructionsView()

            if let caloricBreakdown = props.recipe.nutrition?.caloricBreakdown {
                // Nutrition Breakdown
                Text("Nutrition Breakdown")
                    .font(.headline)

                LineChartView(values: [
                    .init(title: "Carbs", color: .accent, percentage: caloricBreakdown.percentCarbs ?? 0),
                    .init(title: "Fat", color: .orange, percentage: caloricBreakdown.percentFat ?? 0),
                    .init(title: "Protein", color: .red, percentage: caloricBreakdown.percentProtein ?? 0)
                ])
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
                props.send(event: .finish)
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.headline)
            }
            .foregroundStyle(.primary)
            .padding(16)
            .background()
            .clipShape(Circle())
            .shadow(radius: 5)

            Spacer()

            Button {
                props.send(event: .favorite)
            } label: {
                Image(systemName: "bookmark")
                    .font(.headline)
            }
            .foregroundStyle(.primary)
            .padding(16)
            .background()
            .clipShape(Circle())
            .shadow(radius: 5)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Ingredients View
    @ViewBuilder
    private func ingredientsView() -> some View {
        if let ingredients = props.recipe.extendedIngredients {
            Text("Ingredients")
                .font(.headline)

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
                                Text("\(ingredient.amount ?? 0, specifier: "%.2f") \(ingredient.unit ?? "")")
                                    .textStyle(.footnote)
                            }
                        }
                        .padding(.vertical, 6)
                        if ingredients.last?.id != ingredient.id {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Instructions View
    @ViewBuilder
    private func instructionsView() -> some View {
        if let instructions = props.recipe.analyzedInstructions {
            Text("Instructions")
                .font(.headline)
            ForEach(instructions, id: \.name) { instruction in
                ForEach(instruction.steps ?? [], id: \.number) { step in
                    Text("\(step.number ?? 0). \(step.step ?? "")")
                }
            }
        }
    }
}

#Preview {
    RecipeDetailsView(viewModel: .init(recipeId: 1, spoonacularNetworkService: SpoonacularNetworkServiceMock()))
}

extension String {
    var htmlStringFormatted: AttributedString {
        if let nsAttributedString = try? NSAttributedString(data: Data(self.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            var attributedString = AttributedString(nsAttributedString)

            attributedString.font = .body
            attributedString.foregroundColor = .label
            attributedString.underlineColor = .accent
            return attributedString
        } else {
            return AttributedString(self)
        }
    }
}
