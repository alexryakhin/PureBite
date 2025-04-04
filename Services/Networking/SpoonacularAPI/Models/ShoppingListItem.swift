//
//  ShoppingListItem.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public struct ShoppingListItem: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let amount: Double
    public let unit: String
    public let isChecked: Bool
}
