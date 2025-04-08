//
//  MealType.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation
/*
 "lunch",
 "soup",
 "main course",
 "main dish",
 "dinner"

 */
public enum MealType: String, Codable, Hashable, CaseIterable {
    case mainCourse = "main course"
    case mainDish = "main dish"
    case sideDish = "side dish"
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case dessert = "dessert"
    case appetizer = "appetizer"
    case salad = "salad"
    case bread = "bread"
    case soup = "soup"
    case beverage = "beverage"
    case sauce = "sauce"
    case other = "other"

    public var title: String {
        switch self {
        case .mainCourse: "Main Course"
        case .mainDish: "Main Dish"
        case .sideDish: "Side Dish"
        case .breakfast: "Breakfast"
        case .lunch: "Lunch"
        case .dinner: "Dinner"
        case .dessert: "Dessert"
        case .appetizer: "Appetizer"
        case .salad: "Salad"
        case .bread: "Bread"
        case .soup: "Soup"
        case .beverage: "Beverage"
        case .sauce: "Sauce"
        case .other: "Other"
        }
    }

    public var emoji: String {
        switch self {
        case .mainCourse: "🍽"
        case .mainDish: "🍽"
        case .sideDish: "🍲"
        case .breakfast: "🍳"
        case .lunch: "🍽"
        case .dinner: "🍽"
        case .dessert: "🍰"
        case .appetizer: "🍤"
        case .salad: "🥗"
        case .bread: "🍞"
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
