//
//  ShoppingListItem.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation
import SwiftUI // Added for Color

struct ShoppingListItem: Identifiable, Hashable {
    let id: String
    let unit: String
    let amount: Double
    let dateSaved: Date
    let ingredient: IngredientSearchInfo
    let isChecked: Bool
    let category: ShoppingCategory
    let notes: String?
    let priority: ShoppingPriority
    let isInCart: Bool

    var imageURL: URL? {
        ingredient.imageURL
    }
    
    var displayAmount: String {
        if amount.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(amount)) \(unit)"
        } else {
            return "\(amount) \(unit)"
        }
    }

    init(
        id: String,
        isChecked: Bool = false,
        dateSaved: Date = .now,
        amount: Double,
        unit: String,
        ingredient: IngredientSearchInfo,
        category: ShoppingCategory = .uncategorized,
        notes: String? = nil,
        priority: ShoppingPriority = .normal,
        isInCart: Bool = false
    ) {
        self.id = id
        self.isChecked = isChecked
        self.dateSaved = dateSaved
        self.amount = amount
        self.unit = unit
        self.ingredient = ingredient
        self.category = category
        self.notes = notes
        self.priority = priority
        self.isInCart = isInCart
    }
}

enum ShoppingCategory: String, CaseIterable, Identifiable {
    case produce = "Produce"
    case dairy = "Dairy"
    case meat = "Meat & Seafood"
    case pantry = "Pantry"
    case frozen = "Frozen"
    case bakery = "Bakery"
    case beverages = "Beverages"
    case snacks = "Snacks"
    case household = "Household"
    case health = "Health & Beauty"
    case recipe = "Recipe"
    case uncategorized = "Uncategorized"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .produce: return "leaf.fill"
        case .dairy: return "drop.fill"
        case .meat: return "fish.fill"
        case .pantry: return "cabinet.fill"
        case .frozen: return "snowflake"
        case .bakery: return "birthday.cake.fill"
        case .beverages: return "cup.and.saucer.fill"
        case .snacks: return "heart.fill"
        case .household: return "house.fill"
        case .health: return "cross.fill"
        case .recipe: return "book.fill"
        case .uncategorized: return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .produce: return .green
        case .dairy: return .blue
        case .meat: return .red
        case .pantry: return .orange
        case .frozen: return .cyan
        case .bakery: return .yellow
        case .beverages: return .purple
        case .snacks: return .pink
        case .household: return .gray
        case .health: return .mint
        case .recipe: return .indigo
        case .uncategorized: return .secondary
        }
    }
    
    // Map API aisle to local category
    static func fromAisle(_ aisle: String) -> ShoppingCategory {
        let lowercasedAisle = aisle.lowercased()
        
        let category: ShoppingCategory
        switch lowercasedAisle {
        case let aisle where aisle.contains("produce") || aisle.contains("vegetable") || aisle.contains("fruit"):
            category = .produce
        case let aisle where aisle.contains("dairy") || aisle.contains("milk") || aisle.contains("cheese") || aisle.contains("yogurt"):
            category = .dairy
        case let aisle where aisle.contains("meat") || aisle.contains("seafood") || aisle.contains("fish") || aisle.contains("poultry"):
            category = .meat
        case let aisle where aisle.contains("pantry") || aisle.contains("spice") || aisle.contains("seasoning") || aisle.contains("canned") || aisle.contains("grain"):
            category = .pantry
        case let aisle where aisle.contains("frozen"):
            category = .frozen
        case let aisle where aisle.contains("bakery") || aisle.contains("bread") || aisle.contains("pastry"):
            category = .bakery
        case let aisle where aisle.contains("beverage") || aisle.contains("drink") || aisle.contains("soda") || aisle.contains("juice"):
            category = .beverages
        case let aisle where aisle.contains("snack") || aisle.contains("chip") || aisle.contains("candy"):
            category = .snacks
        case let aisle where aisle.contains("household") || aisle.contains("cleaning") || aisle.contains("paper"):
            category = .household
        case let aisle where aisle.contains("health") || aisle.contains("beauty") || aisle.contains("personal"):
            category = .health
        default:
            category = .uncategorized
        }
        
        print("🗂️ [CATEGORY_MAPPING] Aisle: '\(aisle)' → Category: '\(category.rawValue)'")
        return category
    }
}

enum ShoppingPriority: String, CaseIterable, Identifiable {
    case low = "Low"
    case normal = "Normal"
    case high = "High"
    case urgent = "Urgent"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .low: return "1.circle.fill"
        case .normal: return "2.circle.fill"
        case .high: return "3.circle.fill"
        case .urgent: return "exclamationmark.triangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .normal: return .blue
        case .high: return .orange
        case .urgent: return .red
        }
    }
}
