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

    public var imageURL: URL? {
        ImageHelper.productImageUrl(for: id)
    }

    public init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
