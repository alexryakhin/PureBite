//
//  MealType.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

public enum MealType: String, Codable, Hashable, CaseIterable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case dessert = "dessert"
    case appetizer = "appetizer"
    case salad = "salad"
    case soup = "soup"
    case beverage = "beverage"
    case sauce = "sauce"
    case other = "other"

    public var title: String {
        switch self {
        case .breakfast: "Breakfast"
        case .lunch: "Lunch"
        case .dinner: "Dinner"
        case .dessert: "Dessert"
        case .appetizer: "Appetizer"
        case .salad: "Salad"
        case .soup: "Soup"
        case .beverage: "Beverage"
        case .sauce: "Sauce"
        case .other: "Other"
        }
    }

    public var emoji: String {
        switch self {
        case .breakfast: "🍳"
        case .lunch: "🍲"
        case .dinner: "🍽"
        case .dessert: "🍰"
        case .appetizer: "🍤"
        case .salad: "🥗"
        case .soup: "🥣"
        case .beverage: "🍹"
        case .sauce: "🥫"
        case .other: "🥡"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = MealType(rawValue: rawValue.lowercased()) ?? .other
    }

    public static var mainCategories: [MealType] {
        [.breakfast, .lunch, .dinner, .dessert, .appetizer, .salad, .soup, .beverage, .sauce]
    }
}

public extension Array where Element == MealType {
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}

public extension String {
    var toMealTypes: [MealType] {
        self.components(separatedBy: ",").compactMap({ MealType(rawValue: $0) })
    }
}
