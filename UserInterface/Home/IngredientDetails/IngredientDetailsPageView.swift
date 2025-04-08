import SwiftUI
import Combine
import RichText
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct IngredientDetailsPageView: PageView {

    // MARK: - Private properties

    @State private var isNutritionInfoExpanded: Bool = false
    @ObservedObject public var viewModel: IngredientDetailsPageViewModel

    // MARK: - Initialization

    public init(viewModel: IngredientDetailsPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    @ViewBuilder
    public var contentView: some View {
        GeometryReader {  geometry in
            if let ingredient = viewModel.ingredient {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            Text(ingredient.name.capitalized)
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Button {
                                viewModel.handle(.dismiss)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .frame(sideLength: 24)
                                    .font(.headline)
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Aisle")
                                .font(.headline)
                                .foregroundColor(.label)

                            Text(ingredient.aisle)
                                .foregroundColor(.label)
                                .font(.subheadline)
                        }


                        // Nutritional Info
//                        if ingredient.nutrition.nutrients.isNotEmpty {
//                            Divider()
//
//                            VStack(alignment: .leading, spacing: 4) {
//                                HStack {
//                                    Text("Nutritional Info")
//                                        .font(.headline)
//                                        .foregroundColor(.label)
//                                        .padding(.bottom, 8)
//
//                                    Button {
//                                        withAnimation {
//                                            isNutritionInfoExpanded.toggle()
//                                        }
//                                    } label: {
//                                        Text(isNutritionInfoExpanded ? "Collapse" : "Expand")
//                                            .font(.subheadline)
//                                            .fontWeight(.semibold)
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .trailing)
//                                }
//
//                                infoCell(
//                                    title: "Name",
//                                    value: "Amount, Percent of Daily Needs"
//                                )
//                                .padding(.vertical, 4)
//
//                                ForEach(
//                                    ingredient.nutrition.nutrients
//                                        .sorted(by: { $0.name < $1.name })
//                                        .filter({ $0.amount != .zero })
//                                        .prefix(isNutritionInfoExpanded ? ingredient.nutrition.nutrients.count : 5),
//                                    id: \.name
//                                ) { nutrient in
//                                    infoCell(
//                                        title: nutrient.name,
//                                        value: "\(nutrient.amount.formatted()) \(nutrient.unit), \(nutrient.percentOfDailyNeeds.formatted())%"
//                                    )
//                                }
//                            }
//                        }

                        // Additional Info
                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Additional Info")
                                .font(.headline)
                                .foregroundColor(.label)
                                .padding(.bottom, 8)

//                            infoCell(
//                                title: "Estimated Cost",
//                                value: "\(ingredient.estimatedCost.value.formatted()) \(ingredient.estimatedCost.unit)"
//                            )
                            infoCell(
                                title: "Amount",
                                value: "\(ingredient.amount.formatted()) \(ingredient.unit)"
                            )
//                            infoCell(
//                                title: "Consistency",
//                                value: ingredient.consistency
//                            )
                        }
                    }
                    .padding(16)
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(16)
                .padding(.top, geometry.frame(in: .local).height - 500)
            } else {
                Color.clear
                    .background(.ultraThinMaterial)
                    .overlay(alignment: .topTrailing) {
                        Button {
                            viewModel.handle(.dismiss)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .frame(sideLength: 24)
                                .font(.headline)
                        }
                        .padding(16)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(16)
                    .padding(.top, geometry.frame(in: .local).height - 500)
            }
        }
    }

    private func expandingImage(url: URL) -> some View {
        CachedAsyncImage(url: url) { imageView in
            imageView
                .resizable()
                .scaledToFit()
        } placeholder: {
            ShimmerView()
        }
        .overlay {
            LinearGradient(
                gradient: Gradient(colors: [Color.background, .clear, Color.background]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .offset(y: -100)
        .padding(.bottom, -200)
    }

    private func infoCell(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.label)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.label)
                .multilineTextAlignment(.trailing)
        }
    }
}

#if DEBUG
#Preview {
    IngredientDetailsPageView(
        viewModel: .init(
            config: .init(id: 1, name: "Title"),
            spoonacularNetworkService: SpoonacularNetworkServiceMock(),
            favoritesService: FavoritesServiceMock()
        )
    )
}
#endif
