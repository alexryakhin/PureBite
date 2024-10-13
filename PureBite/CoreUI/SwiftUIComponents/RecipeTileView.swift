//
//  RecipeTileView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/12/24.
//

import SwiftUI
import CachedAsyncImage

public struct RecipeTileView: View {

    static let standardHeight: CGFloat = 160

    private var recipe: Recipe
    private var onTap: (Int) -> Void

    public init(recipe: Recipe, onTap: @escaping (Int) -> Void) {
        self.recipe = recipe
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            onTap(recipe.id)
        } label: {
            GeometryReader { geo in
                let frame = geo.frame(in: .local)
                ZStack(alignment: .bottomLeading) {
                    CachedAsyncImage(url: URL(string: recipe.image)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: frame.width,
                                height: frame.height
                            )
                            .clipped()
                            .cornerRadius(12)
                    } placeholder: {
                        if recipe.image == nil {
                            Image("foodMosaic300")
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: frame.width,
                                    height: frame.height
                                )
                                .clipped()
                                .backgroundColor(.surfaceBackground)
                                .cornerRadius(12)
                        } else {
                            Color.clear.shimmering()
                                .frame(
                                    width: frame.width,
                                    height: frame.height
                                )
                        }
                    }

                    Text(recipe.title)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.label)
                        .padding(5)
                        .background(.thinMaterial)
                        .cornerRadius(6)
                        .padding(5)
                        .frame(
                            width: frame.width,
                            height: frame.height,
                            alignment: .bottomLeading
                        )
                }
            }
        }
    }
}
