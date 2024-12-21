//
//  Diet.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

public enum Diet: String {
    case glutenFree = "Gluten Free"
    case ketogenic = "Ketogenic"
    case vegetarian = "Vegetarian"
    case lactoVegetarian = "Lacto-Vegetarian"
    case ovoVegetarian = "Ovo-Vegetarian"
    case vegan = "Vegan"
    case pescetarian = "Pescetarian"
    case paleo = "Paleo"
    case primal = "Primal"
    case lowFodmap = "Low FODMAP"
    case whole30 = "Whole30"
}

public extension Array where Element == Diet {
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}
