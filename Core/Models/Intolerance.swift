//
//  Intolerance.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

enum Intolerance: String {
    case dairy = "dairy"
    case egg = "egg"
    case gluten = "gluten"
    case grain = "grain"
    case peanut = "peanut"
    case seafood = "seafood"
    case sesame = "sesame"
    case shellfish = "shellfish"
    case soy = "soy"
    case sulfite = "sulfite"
    case treeNut = "tree nut"
    case wheat = "wheat"
}

extension Array where Element == Intolerance {
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}
