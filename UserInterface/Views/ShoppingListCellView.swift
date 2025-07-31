//
//  ShoppingListCellView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/29/24.
//

import SwiftUI
import CachedAsyncImage

struct ShoppingListCellView: View {

    private let item: ShoppingListItem
    private let onTapAction: () -> Void

    init(
        item: ShoppingListItem,
        onTapAction: @escaping () -> Void
    ) {
        self.item = item
        self.onTapAction = onTapAction
    }

    var body: some View {
        CellWrapper(
            vPadding: nil,
            hPadding: nil,
            onTapAction: onTapAction,
            leadingContent: {
                if let imageURL = item.imageURL {
                    CachedAsyncImage(url: imageURL) { image in
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
                } else {
                    Image(systemName: "minus.circle.fill")
                        .frame(sideLength: 24)
                        .foregroundColor(.accentColor)
                        .frame(width: 40, height: 40)
                        .padding(5)
                        .background(.white)
                        .cornerRadius(12)
                        .shadow(radius: 1)
                }
            },
            mainContent: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.ingredient.name.capitalized)
                        .font(.headline)
                        .foregroundColor(.label)
                        .strikethrough(item.isChecked)
                    Text(item.amount.formatted() + " " + item.unit)
                        .font(.caption)
                        .foregroundColor(.secondaryLabel)
                }
            },
            trailingContent: {
                Image(systemName: item.isChecked ? "checkmark.square" : "square")
                    .frame(sideLength: 20)
            }
        )
    }
}
