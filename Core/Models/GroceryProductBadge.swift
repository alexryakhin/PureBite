//
//  GroceryProductBadge.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

public enum GroceryProductBadge: String, Codable, CaseIterable {
    case eggFree = "egg_free"
    case wheatFree = "wheat_free"
    case grainFree = "grain_free"
    case peanutFree = "peanut_free"
    case primal = "primal"
    case vegetarian = "vegetarian"
    case nutFree = "nut_free"
    case vegan = "vegan"
    case pescatarian = "pescetarian"
    case dairyFree = "dairy_free"
    case glutenFree = "gluten_free"
    case paleo = "paleo"
    case msgFree = "msg_free"
    case noArtificialColors = "no_artificial_colors"
    case noArtificialFlavors = "no_artificial_flavors"
    case noArtificialIngredients = "no_artificial_ingredients"
    case grassFed = "grass_fed"
    case noAddedSugar = "no_added_sugar"
    case pastureRaised = "pasture_raised"
    case freeRange = "free_range"
    case cageFree = "cage_free"
    case wildCaught = "wild_caught"
    case fairTrade = "fair_trade"
    case noAdditives = "no_additives"
    case hormoneFree = "hormone_free"
    case noPreservatives = "no_preservatives"
    case sugarFree = "sugar_free"
    case sulfiteFree = "sulfite_free"
    case cornFree = "corn_free"
    case soyFree = "soy_free"
    case nitrateFree = "nitrate_free"
    case gmoFree = "gmo_free"
    case organic = "organic"
    case kosher = "kosher"
    case halal = "halal"
    case sustainable = "sustainable"
    case nonAlcoholic = "non_alcoholic"
    case lactoseFree = "lactose_free"
    case wholeGrain = "whole_grain"
    case wholeWheat = "whole_wheat"
    case multigrain = "multigrain"
    case sproutedGrain = "sprouted_grain"

    public var name: String {
        switch self {
        case .eggFree: return "Egg Free"
        case .wheatFree: return "Wheat Free"
        case .grainFree: return "Grain Free"
        case .peanutFree: return "Peanut Free"
        case .primal: return "Primal"
        case .vegetarian: return "Vegetarian"
        case .nutFree: return "Nut Free"
        case .vegan: return "Vegan"
        case .dairyFree: return "Dairy Free"
        case .paleo: return "Paleo"
        case .msgFree: return "Msg Free"
        case .noArtificialColors: return "No Artificial Colors"
        case .noArtificialFlavors: return "No Artificial Flavors"
        case .noArtificialIngredients: return "No Artificial Ingredients"
        case .grassFed: return "Grass Fed"
        case .noAddedSugar: return "No Added Sugar"
        case .wildCaught: return "Wild Caught"
        case .fairTrade: return "Fair Trade"
        case .noAdditives: return "No Additives"
        case .hormoneFree: return "Hormone Free"
        case .noPreservatives: return "No Preservatives"
        case .sulfiteFree: return "Sulfite Free"
        case .cornFree: return "Corn Free"
        case .pescatarian: return "Pescatarian"
        case .glutenFree: return "Gluten Free"
        case .pastureRaised: return "Pasture Raised"
        case .freeRange: return "Free Range"
        case .cageFree: return "Cage Free"
        case .sugarFree: return "Sugar Free"
        case .soyFree: return "Soy Free"
        case .nitrateFree: return "Nitrate Free"
        case .gmoFree: return "Gmo Free"
        case .organic: return "Organic"
        case .kosher: return "Kosher"
        case .halal: return "Halal"
        case .sustainable: return "Sustainable"
        case .nonAlcoholic: return "Non Alcoholic"
        case .lactoseFree: return "Lactose Free"
        case .wholeGrain: return "Whole Grain"
        case .wholeWheat: return "Whole Wheat"
        case .multigrain: return "Multigrain"
        case .sproutedGrain: return "Sprouted Grain"
        }
    }
}

public extension Array where Element == GroceryProductBadge {
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}

public extension String {
    var toGroceryProductBadges: [GroceryProductBadge] {
        self.components(separatedBy: ",").compactMap({ GroceryProductBadge(rawValue: $0) })
    }
}
