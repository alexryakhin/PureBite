//
//  MealType.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

public enum MealType: String, CaseIterable {
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

    var title: String {
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
        }
    }

    var emoji: String {
        switch self {
        case .mainCourse:"🍽"
        case .sideDish:"🍲"
        case .dessert:"🍰"
        case .appetizer:"🍤"
        case .salad:"🥗"
        case .bread:"🍞"
        case .breakfast:"🍳"
        case .soup:"🥣"
        case .beverage:"🍹"
        case .sauce:"🥫"
        }
    }
}
