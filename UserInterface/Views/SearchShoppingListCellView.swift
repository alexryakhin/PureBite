//
//  SearchShoppingListCellView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/29/24.
//

import SwiftUI
import CachedAsyncImage
import Core
import Services
import Shared
import CoreUserInterface

struct SearchShoppingListCellView: View {

    let item: ShoppingListItem

    init(item: ShoppingListItem) {
        self.item = item
    }

    var body: some View {
        HStack(spacing: 10) {
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
            Text(item.name.orEmpty.capitalized)
                .font(.headline)
                .foregroundColor(.label)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}
