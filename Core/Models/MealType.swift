//
//  MealType.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

public enum MealType: String, Codable, Hashable, CaseIterable {
    case mainCourse = "main course"
    case sideDish = "side dish"
    case dessert = "dessert"
    case appetizer = "appetizer"
    case salad = "salad"
    case bread = "bread"
    case breakfast = "breakfast"
    case soup = "soup"
    case beverage = "beverage"
    case sauce = "sauce"
    case other = "other"

    public var title: String {
        switch self {
        case .mainCourse: "Main Course"
        case .sideDish: "Side Dish"
        case .dessert: "Dessert"
        case .appetizer: "Appetizer"
        case .salad: "Salad"
        case .bread: "Bread"
        case .breakfast: "Breakfast"
        case .soup: "Soup"
        case .beverage: "Beverage"
        case .sauce: "Sauce"
        case .other: "Other"
        }
    }

    public var emoji: String {
        switch self {
        case .mainCourse: "🍽"
        case .sideDish: "🍲"
        case .dessert: "🍰"
        case .appetizer: "🍤"
        case .salad: "🥗"
        case .bread: "🍞"
        case .breakfast: "🍳"
        case .soup: "🥣"
        case .beverage: "🍹"
        case .sauce: "🥫"
        case .other: "🥡"
        }
    }

    public static var mainCategories: [MealType] {
        [.mainCourse, .sideDish, .dessert, .appetizer, .salad, .bread, .breakfast, .soup, .beverage, .sauce]
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
