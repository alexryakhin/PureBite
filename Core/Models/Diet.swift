//
//  Diet.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

public enum Diet: String, Codable, Hashable, CaseIterable {
    case glutenFree = "gluten free"
    case dairyFree = "dairy free"
    case ketogenic = "ketogenic"
    case vegetarian = "vegetarian"
    case lactoOvoVegetarian = "lacto ovo vegetarian"
    case lactoVegetarian = "lacto vegetarian"
    case ovoVegetarian = "ovo vegetarian"
    case vegan = "vegan"
    case pescetarian = "pescetarian"
    case paleo = "paleo"
    case primal = "primal"
    case lowFodmap = "low fodmap"
    case whole30 = "whole30"
}

public extension Array where Element == Diet {
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}

public extension String {
    var toDiets: [Diet] {
        self.components(separatedBy: ",").compactMap({ Diet(rawValue: $0) })
    }
}
