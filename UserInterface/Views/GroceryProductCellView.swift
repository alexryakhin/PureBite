import SwiftUI
import CachedAsyncImage
import Core
import Services
import Shared
import CoreUserInterface

struct GroceryProductCellView: View {

    private let product: GroceryProductShortInfo
    private let onTapAction: VoidHandler
    private let onShoppingCartAction: VoidHandler

    init(
        product: GroceryProductShortInfo,
        onTapAction: @escaping VoidHandler,
        onShoppingCartAction: @escaping VoidHandler
    ) {
        self.product = product
        self.onTapAction = onTapAction
        self.onShoppingCartAction = onShoppingCartAction
    }

    var body: some View {
        CellWrapper {
            CachedAsyncImage(url: product.imageURL) { phase in
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
                Text(product.name.capitalized)
                    .font(.headline)
//                Text("\(ingredient.amount.formatted()) \(ingredient.unit)")
//                    .font(.footnote)
//                    .tint(.secondary)
            }
            .multilineTextAlignment(.leading)
        } trailingContent: {
            Button {
                onShoppingCartAction()
            } label: {
                Image(systemName: "cart.badge.plus")
            }
            .buttonStyle(.borderedProminent)
        } onTapAction: {
            onTapAction()
        }
    }
}
