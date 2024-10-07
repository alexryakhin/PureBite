//
//  Recipe.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

// MARK: - Recipe
public struct Recipe: Codable, Identifiable, Equatable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let aggregateLikes: Int?
    public let analyzedInstructions: [AnalyzedInstruction]?
    public let cheap: Bool?
    public let cookingMinutes: Int?
    public let creditsText: String?
    public let cuisines: [String]?
    public let dairyFree: Bool?
    public let diets, dishTypes: [String]?
    public let extendedIngredients: [ExtendedIngredient]?
    public let gaps: String?
    public let glutenFree: Bool?
    public let healthScore: Int?
    public let image: String?
    public let imageType, instructions: String?
    public let lowFodmap: Bool?
    public let nutrition: Nutrition?
    public let occasions: [String]?
    public let originalID: String?
    public let preparationMinutes: Int?
    public let pricePerServing: Double?
    public let readyInMinutes, servings: Int?
    public let sourceName: String?
    public let sourceURL: String?
    public let spoonacularScore: Double?
    public let spoonacularSourceURL: String?
    public let summary: String?
    public let sustainable: Bool?
    public let taste: Taste?
    public let vegan, vegetarian, veryHealthy, veryPopular: Bool?
    public let weightWatcherSmartPoints: Int?

    public enum CodingKeys: String, CodingKey {
        case aggregateLikes, analyzedInstructions, cheap, cookingMinutes, creditsText, cuisines, dairyFree, diets, dishTypes, extendedIngredients, gaps, glutenFree, healthScore, id, image, imageType, instructions, lowFodmap, nutrition, occasions
        case originalID = "originalId"
        case preparationMinutes, pricePerServing, readyInMinutes, servings, sourceName
        case sourceURL = "sourceUrl"
        case spoonacularScore
        case spoonacularSourceURL = "spoonacularSourceUrl"
        case summary, sustainable, taste, title, vegan, vegetarian, veryHealthy, veryPopular, weightWatcherSmartPoints
    }

    init(
        id: Int,
        title: String,
        aggregateLikes: Int? = nil,
        analyzedInstructions: [AnalyzedInstruction]? = nil,
        cheap: Bool? = nil,
        cookingMinutes: Int? = nil,
        creditsText: String? = nil,
        cuisines: [String]? = nil,
        dairyFree: Bool? = nil,
        diets: [String]? = nil,
        dishTypes: [String]? = nil,
        extendedIngredients: [ExtendedIngredient]? = nil,
        gaps: String? = nil,
        glutenFree: Bool? = nil,
        healthScore: Int? = nil,
        image: String? = nil,
        imageType: String? = nil,
        instructions: String? = nil,
        lowFodmap: Bool? = nil,
        nutrition: Nutrition? = nil,
        occasions: [String]? = nil,
        originalID: String? = nil,
        preparationMinutes: Int? = nil,
        pricePerServing: Double? = nil,
        readyInMinutes: Int? = nil,
        servings: Int? = nil,
        sourceName: String? = nil,
        sourceURL: String? = nil,
        spoonacularScore: Double? = nil,
        spoonacularSourceURL: String? = nil,
        summary: String? = nil,
        taste: Taste? = nil,
        sustainable: Bool? = nil,
        vegan: Bool? = nil,
        vegetarian: Bool? = nil,
        veryHealthy: Bool? = nil,
        veryPopular: Bool? = nil,
        weightWatcherSmartPoints: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.aggregateLikes = aggregateLikes
        self.analyzedInstructions = analyzedInstructions
        self.cheap = cheap
        self.cookingMinutes = cookingMinutes
        self.creditsText = creditsText
        self.cuisines = cuisines
        self.dairyFree = dairyFree
        self.diets = diets
        self.dishTypes = dishTypes
        self.extendedIngredients = extendedIngredients
        self.gaps = gaps
        self.glutenFree = glutenFree
        self.healthScore = healthScore
        self.image = image
        self.imageType = imageType
        self.instructions = instructions
        self.lowFodmap = lowFodmap
        self.nutrition = nutrition
        self.occasions = occasions
        self.originalID = originalID
        self.preparationMinutes = preparationMinutes
        self.pricePerServing = pricePerServing
        self.readyInMinutes = readyInMinutes
        self.servings = servings
        self.sourceName = sourceName
        self.sourceURL = sourceURL
        self.spoonacularScore = spoonacularScore
        self.spoonacularSourceURL = spoonacularSourceURL
        self.summary = summary
        self.taste = taste
        self.sustainable = sustainable
        self.vegan = vegan
        self.vegetarian = vegetarian
        self.veryHealthy = veryHealthy
        self.veryPopular = veryPopular
        self.weightWatcherSmartPoints = weightWatcherSmartPoints
    }

    public static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.extendedIngredients == rhs.extendedIngredients
    }
}

// MARK: - AnalyzedInstruction
public struct AnalyzedInstruction: Codable, Hashable, Sendable {
    public let name: String?
    public let steps: [Step]?
}

// MARK: - Step
public struct Step: Codable, Hashable, Sendable {
    public let equipment, ingredients: [Ent]?
    public let number: Int?
    public let step: String?
    public let length: Length?
}

// MARK: - Ent
public struct Ent: Codable, Hashable, Sendable {
    public let id: Int?
    public let image: String?
    public let localizedName, name: String?
}

// MARK: - Length
public struct Length: Codable, Hashable, Sendable {
    public let number: Int?
    public let unit: String?
}

// MARK: - ExtendedIngredient
public struct ExtendedIngredient: Codable, Equatable, Hashable, Sendable, Identifiable {
    public static func == (lhs: ExtendedIngredient, rhs: ExtendedIngredient) -> Bool {
        lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.image == rhs.image
    }
    
    public let aisle: String?
    public let amount: Double?
    public let consistency: Consistency?
    public let id: Int?
    public let image: String?
    public let measures: Measures?
    public let meta: [String]?
    public let name, nameClean, original, originalName: String?
    public let unit: String?
}

public enum Consistency: String, Codable, Hashable, Sendable {
    case liquid = "LIQUID"
    case solid = "SOLID"
}

// MARK: - Measures
public struct Measures: Codable, Hashable, Sendable {
    public let metric, us: Metric?
}

// MARK: - Metric
public struct Metric: Codable, Hashable, Sendable {
    public let amount: Double?
    public let unitLong, unitShort: String?
}

// MARK: - Nutrition
public struct Nutrition: Codable, Hashable, Sendable {
    public let caloricBreakdown: CaloricBreakdown?
    public let flavonoids: [Nutrient]?
    public let ingredients: [Ingredient]?
    public let nutrients, properties: [Nutrient]?
    public let weightPerServing: WeightPerServing?
}

// MARK: - CaloricBreakdown
public struct CaloricBreakdown: Codable, Hashable, Sendable {
    public let percentCarbs, percentFat, percentProtein: Double?
}

// MARK: - Nutrient
public struct Nutrient: Codable, Hashable, Sendable {
    public let amount: Double?
    public let name: String?
    public let unit: Unit?
    public let percentOfDailyNeeds: Double?
}

public enum Unit: String, Codable, Sendable {
    case empty = ""
    case g = "g"
    case iu = "IU"
    case kcal = "kcal"
    case mg = "mg"
    case unit = "%"
    case µg = "µg"
}

// MARK: - WeightPerServing
public struct WeightPerServing: Codable, Hashable, Sendable {
    public let amount: Int?
    public let unit: Unit?
}

// MARK: - Taste
public struct Taste: Codable, Hashable, Sendable {
    public let bitterness: Double?
    public let fattiness: Double?
    public let saltiness: Double?
    public let savoriness: Double?
    public let sourness: Double?
    public let spiciness: Double?
    public let sweetness: Double?
}
