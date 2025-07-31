import SwiftUI
import CachedAsyncImage

struct IngredientCellView: View {

    private let ingredient: IngredientRecipeInfo
    private let onAddToShoppingCart: VoidHandler
    @State private var isShowingDialog: Bool = false

    init(
        ingredient: IngredientRecipeInfo,
        onAddToShoppingCart: @escaping VoidHandler
    ) {
        self.ingredient = ingredient
        self.onAddToShoppingCart = onAddToShoppingCart
    }

    var body: some View {
        CellWrapper(onTapAction: {
            isShowingDialog.toggle()
        }) {
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
                Text(ingredient.amount.formatted() + " " + ingredient.unit)
                    .font(.footnote)
                    .tint(.secondary)
            }
            .lineLimit(1)
        } trailingContent: {
            Button {
                onAddToShoppingCart()
            } label: {
                Image(systemName: "cart.fill.badge.plus")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
