//
//  Diet.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

enum Diet: String, Codable, Hashable, CaseIterable {
    case glutenFree = "gluten free"
    case dairyFree = "dairy free"
    case ketogenic = "ketogenic"
    case vegetarian = "vegetarian"
    case lactoOvoVegetarian = "lacto ovo vegetarian"
    case lactoVegetarian = "lacto vegetarian"
    case ovoVegetarian = "ovo vegetarian"
    case vegan = "vegan"
    case pescatarian = "pescatarian"
    case paleo = "paleolithic"
    case primal = "primal"
    case lowFodmap = "low fodmap"
    case whole30 = "whole 30"
    case fodmapFriendly = "fodmap friendly"
    case other = "other"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Diet(rawValue: rawValue.lowercased()) ?? .other
    }
}

extension Array where Element == Diet {
    var toData: Data {
        guard let data = try? JSONEncoder().encode(self) else {
            return Data()
        }
        return data
    }
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}


extension Data {
    var toDiets: [Diet] {
        guard let diets = try? JSONDecoder().decode([Diet].self, from: self) else {
            return []
        }
        return diets
    }
}
