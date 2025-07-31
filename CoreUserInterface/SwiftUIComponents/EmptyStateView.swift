//
//  EmptyStateView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/30/24.
//

import SwiftUI

public struct EmptyStateView: View {

    private let imageSystemName: String?
    private let title: String
    private let subtitle: String?
    private let instructions: String?

    public init(
        imageSystemName: String? = nil,
        title: String,
        subtitle: String? = nil,
        instructions: String? = nil
    ) {
        self.imageSystemName = imageSystemName
        self.title = title
        self.subtitle = subtitle
        self.instructions = instructions
    }

    public var body: some View {
        VStack(spacing: 20) {
            if let imageSystemName {
                Image(systemName: imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.secondary)
            }

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let instructions {
                Text(instructions)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(16)
        .multilineTextAlignment(.center)
    }

    public static let nothingFound = Self(
        imageSystemName: "flashlight.off.circle.fill",
        title: "Nothing Found",
        subtitle: "We couldn't find any recipes that match your search.",
        instructions: "Try using different keywords or adjusting your filters."
    )

    public static let searchPlaceholder = Self(
        imageSystemName: "magnifyingglass.circle.fill",
        title: "Start searching for recipes",
        instructions: "Try typing an ingredient or dish name to find new recipes."
    )

    public static let shoppingListPlaceholder = Self(
        imageSystemName: "basket",
        title: "Shopping List is empty",
        instructions: "You can add items from the search here or directly from your recipes."
    )

    public static let ingredientsSearchPlaceholder = Self(
        imageSystemName: "magnifyingglass.circle.fill",
        title: "Start searching for ingredients",
        instructions: "Try typing an ingredient name into the search bar."
    )

    public static let savedRecipesPlaceholder = Self(
        imageSystemName: "bookmark.circle.fill",
        title: "No Saved Recipes",
        subtitle: "You haven't saved any recipes yet. Save some to get started."
    )
}

#Preview {
    EmptyStateView.nothingFound
}
