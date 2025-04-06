//
//  OilType.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/24/24.
//
import Foundation

public enum OilType: String, Codable, CaseIterable {
    case cookingOil = "cooking oil"
    case tunaInOliveOil = "tuna in olive oil"
    case cannedAnchovies = "canned anchovies"
    case albacoreTunaPackedInOil = "albacore tuna packed in oil"
    case oilCuredBlackOlives = "oil cured black olives"
    case oilPackedSunDriedTomatoes = "oil packed sun dried tomatoes"
    case mctOil = "mct oil"
    case soybeanOil = "soybean oil"
    case cornOil = "corn oil"
    case palmOil = "palm oil"
    case flaxOil = "flax oil"
    case hempOil = "hemp oil"
    case oliveOil = "olive oil"
    case chiliOil = "chili oil"
    case saladOil = "salad oil"
    case lemonOil = "lemon oil"
    case basilOil = "basil oil"
    case vegetableOil = "vegetable oil"
    case oliveOilSpray = "olive oil spray"
    case canolaOil = "canola oil"
    case sesameOil = "sesame oil"
    case peanutOil = "peanut oil"
    case walnutOil = "walnut oil"
    case garlicOil = "garlic oil"
    case almondOil = "almond oil"
    case coconutOil = "coconut oil"
    case avocadoOil = "avocado oil"
    case truffleOil = "truffle oil"
    case mustardOil = "mustard oil"
    case hazelnutOil = "hazelnut oil"
    case grapeSeedOil = "grape seed oil"
    case sunflowerOil = "sunflower oil"
    case safflowerOil = "safflower oil"
    case riceBranOil = "rice bran oil"
    case pistachioOil = "pistachio oil"
    case vegetableOilCookingSpray = "vegetable oil cooking spray"
    case shortening = "shortening"
    case lightOliveOil = "light olive oil"
    case pumpkinSeedOil = "pumpkin seed oil"
    case darkSesameOil = "dark sesame oil"
    case virginOliveOil = "virgin olive oil"
    case extraVirginOliveOil = "extra virgin olive oil"
    case expellerPressedCanolaOil = "expeller pressed canola oil"

    public static let excludedOils: [OilType] = [
        .grapeSeedOil,
        .sunflowerOil,
        .safflowerOil,
        .canolaOil,
        .vegetableOil,
        .vegetableOilCookingSpray,
        .shortening,
        .riceBranOil,
        .expellerPressedCanolaOil,
        .saladOil,
        .soybeanOil
    ]

    public var name: String {
        switch self {
        case .cookingOil: return "Cooking Oil"
        case .tunaInOliveOil: return "Tuna in Olive Oil"
        case .cannedAnchovies: return "Canned Anchovies"
        case .albacoreTunaPackedInOil: return "Albacore Tuna Packed in Oil"
        case .oilCuredBlackOlives: return "Oil Cured Black Olives"
        case .oilPackedSunDriedTomatoes: return "Oil Packed Sun Dried Tomatoes"
        case .mctOil: return "MCT Oil"
        case .soybeanOil: return "Soybean Oil"
        case .cornOil: return "Corn Oil"
        case .palmOil: return "Palm Oil"
        case .flaxOil: return "Flax Oil"
        case .hempOil: return "Hemp Oil"
        case .oliveOil: return "Olive Oil"
        case .chiliOil: return "Chili Oil"
        case .saladOil: return "Salad Oil"
        case .lemonOil: return "Lemon Oil"
        case .basilOil: return "Basil Oil"
        case .vegetableOil: return "Vegetable Oil"
        case .oliveOilSpray: return "Olive Oil Spray"
        case .canolaOil: return "Canola Oil"
        case .sesameOil: return "Sesame Oil"
        case .peanutOil: return "Peanut Oil"
        case .walnutOil: return "Walnut Oil"
        case .garlicOil: return "Garlic Oil"
        case .almondOil: return "Almond Oil"
        case .coconutOil: return "Coconut Oil"
        case .avocadoOil: return "Avocado Oil"
        case .truffleOil: return "Truffle Oil"
        case .mustardOil: return "Mustard Oil"
        case .hazelnutOil: return "Hazelnut Oil"
        case .grapeSeedOil: return "Grape Seed Oil"
        case .sunflowerOil: return "Sunflower Oil"
        case .safflowerOil: return "Safflower Oil"
        case .riceBranOil: return "Rice Bran Oil"
        case .pistachioOil: return "Pistachio Oil"
        case .vegetableOilCookingSpray: return "Vegetable Oil Cooking Spray"
        case .shortening: return "Shortening"
        case .lightOliveOil: return "Light Olive Oil"
        case .pumpkinSeedOil: return "Pumpkin Seed Oil"
        case .darkSesameOil: return "Dark Sesame Oil"
        case .virginOliveOil: return "Virgin Olive Oil"
        case .extraVirginOliveOil: return "Extra Virgin Olive Oil"
        case .expellerPressedCanolaOil: return "Expeller Pressed Canola Oil"
        }
    }
}
