//
//  Recipe.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

// MARK: - Recipe
public struct Recipe: Codable, Identifiable {
    public let id: Int
    public let title: String
    public let aggregateLikes: Int?
    public let analyzedInstructions: [AnalyzedInstruction]?
    public let cheap: Bool?
    public let cookingMinutes: Int?
    public let creditsText: String?
    public let cuisines: [JSONAny]?
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
    public let originalID: JSONNull?
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
        cuisines: [JSONAny]? = nil,
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
        originalID: JSONNull? = nil,
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
}

// MARK: - AnalyzedInstruction
public struct AnalyzedInstruction: Codable {
    public let name: String?
    public let steps: [Step]?
}

// MARK: - Step
public struct Step: Codable {
    public let equipment, ingredients: [Ent]?
    public let number: Int?
    public let step: String?
    public let length: Length?
}

// MARK: - Ent
public struct Ent: Codable {
    public let id: Int?
    public let image: String?
    public let localizedName, name: String?
}

// MARK: - Length
public struct Length: Codable {
    public let number: Int?
    public let unit: String?
}

// MARK: - ExtendedIngredient
public struct ExtendedIngredient: Codable, Equatable {
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

public enum Consistency: String, Codable {
    case liquid = "LIQUID"
    case solid = "SOLID"
}

// MARK: - Measures
public struct Measures: Codable {
    public let metric, us: Metric?
}

// MARK: - Metric
public struct Metric: Codable {
    public let amount: Double?
    public let unitLong, unitShort: String?
}

// MARK: - Nutrition
public struct Nutrition: Codable {
    public let caloricBreakdown: CaloricBreakdown?
    public let flavonoids: [Nutrient]?
    public let ingredients: [Ingredient]?
    public let nutrients, properties: [Nutrient]?
    public let weightPerServing: WeightPerServing?
}

// MARK: - CaloricBreakdown
public struct CaloricBreakdown: Codable {
    public let percentCarbs, percentFat, percentProtein: Double?
}

// MARK: - Nutrient
public struct Nutrient: Codable {
    public let amount: Double?
    public let name: String?
    public let unit: Unit?
    public let percentOfDailyNeeds: Double?
}

public enum Unit: String, Codable {
    case empty = ""
    case g = "g"
    case iu = "IU"
    case kcal = "kcal"
    case mg = "mg"
    case unit = "%"
    case µg = "µg"
}

// MARK: - WeightPerServing
public struct WeightPerServing: Codable {
    public let amount: Int?
    public let unit: Unit?
}

// MARK: - Taste
public struct Taste: Codable {
    public let bitterness: Double?
    public let fattiness: Double?
    public let saltiness: Double?
    public let savoriness: Double?
    public let sourness: Double?
    public let spiciness: Double?
    public let sweetness: Double?
}
// MARK: - Encode/decode helpers

public final class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public func hash(into hasher: inout Hasher) {
            // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

public final class JSONCodingKey: CodingKey {
    public let key: String

    required public init?(intValue: Int) {
            return nil
    }

    required public init?(stringValue: String) {
            key = stringValue
    }

    public var intValue: Int? {
            return nil
    }

    public var stringValue: String {
            return key
    }
}

public final class JSONAny: Codable {

    public let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is JSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = JSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is JSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is JSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAny.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAny.encode(to: &container, value: self.value)
            }
    }
}
