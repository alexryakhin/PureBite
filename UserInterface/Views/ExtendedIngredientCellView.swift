import SwiftUI
import CachedAsyncImage
import Core
import Services
import Shared
import CoreUserInterface

struct IngredientCellView: View {

    var ingredient: Ingredient

    init(ingredient: Ingredient) {
        self.ingredient = ingredient
    }

    var body: some View {
        HStack(spacing: 10) {
            CachedAsyncImage(url: ingredient.imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ShimmerView()
            }
            .frame(width: 40, height: 40)
            .padding(5)
            .background(.white)
            .cornerRadius(12)
            .shadow(radius: 1)

            VStack(alignment: .leading) {
                Text(ingredient.name.capitalized)
                    .font(.headline)
                Text("\(ingredient.amount.formatted()) \(ingredient.unit)")
                    .font(.footnote)
                    .tint(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}
