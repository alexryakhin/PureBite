//
//  IngredientCellView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/29/24.
//

import SwiftUI
import CachedAsyncImage
import Core
import Services
import Shared

struct SearchIngredientCellView: View {

    var ingredient: IngredientSearchResponse.Ingredient

    init(ingredient: IngredientSearchResponse.Ingredient) {
        self.ingredient = ingredient
    }

    var body: some View {
        HStack(spacing: 10) {
            if let image = ingredient.image {
                CachedAsyncImage(url: URL(string: "https://img.spoonacular.com/ingredients_100x100/\(image)")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "minus.circle.fill")
                            .frame(sideLength: 24)
                            .foregroundColor(.accentColor)
                    @unknown default:
                        EmptyView()
                    }
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
            Text(ingredient.name.capitalized)
                .font(.headline)
                .foregroundColor(.label)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}
