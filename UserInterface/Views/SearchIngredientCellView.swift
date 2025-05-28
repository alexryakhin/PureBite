import SwiftUI
import CachedAsyncImage
import Core
import Services
import Shared
import CoreUserInterface

struct SearchIngredientCellView: View {

    private let ingredient: IngredientSearchInfo
    private let onShowDetails: VoidHandler

    init(
        ingredient: IngredientSearchInfo,
        onShowDetails: @escaping VoidHandler
    ) {
        self.ingredient = ingredient
        self.onShowDetails = onShowDetails
    }

    var body: some View {
        CellWrapper(
            vPadding: nil,
            hPadding: nil,
            onTapAction: onShowDetails
        ) {
            CachedAsyncImage(url: ingredient.imageURL) { phase in
                switch phase {
                case .empty:
                    ShimmerView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                }
            }
            .frame(width: 40, height: 40)
            .padding(5)
            .background(.white)
            .cornerRadius(12)
            .shadow(radius: 1)
        } mainContent: {
            VStack(alignment: .leading) {
                Text(ingredient.name.capitalized)
                    .font(.headline)
                Text(ingredient.aisle)
                    .font(.footnote)
                    .tint(.secondary)
            }
            .lineLimit(1)
        }
    }
}
