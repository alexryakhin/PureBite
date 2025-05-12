//
//  GroceryProductShortInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

public struct GroceryProductShortInfo: Identifiable, Hashable {

    public let id: Int
    public let name: String
    public let imageExtension: String?

    public var imageURL: URL? {
        ImageHelper.productImageUrl(
            for: id,
            imageExtension: imageExtension
        )
    }

    public init(
        id: Int,
        name: String,
        imageExtension: String?
    ) {
        self.id = id
        self.name = name
        self.imageExtension = imageExtension
    }
}
