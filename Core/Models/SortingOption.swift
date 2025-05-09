//
//  SortingOption.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

// https://spoonacular.com/food-api/docs#Recipe-Sorting-Options
public enum SortingOption: String, Codable, Hashable, CaseIterable {
    case empty = ""
    case metaScore = "meta-score"
    case popularity = "popularity"
    case healthiness = "healthiness"
    case price = "price"
    case time = "time"
    case random = "random"
    case maxUsedIngredients = "max-used-ingredients"
    case minMissingIngredients = "min-missing-ingredients"
    case alcohol = "alcohol"
    case caffeine = "caffeine"
    case copper = "copper"
    case energy = "energy"
    case calories = "calories"
    case calcium = "calcium"
    case carbohydrates = "carbohydrates"
    case carbs = "carbs"
    case choline = "choline"
    case cholesterol = "cholesterol"
    case totalFat = "total-fat"
    case fluoride = "fluoride"
    case transFat = "trans-fat"
    case saturatedFat = "saturated-fat"
    case monoUnsaturatedFat = "mono-unsaturated-fat"
    case polyUnsaturatedFat = "poly-unsaturated-fat"
    case fiber = "fiber"
    case folate = "folate"
    case folicAcid = "folic-acid"
    case iodine = "iodine"
    case iron = "iron"
    case magnesium = "magnesium"
    case manganese = "manganese"
    case vitaminB3 = "vitamin-b3"
    case niacin = "niacin"
    case vitaminB5 = "pantothenic-acid"
    case phosphorus = "phosphorus"
    case potassium = "potassium"
    case protein = "protein"
    case vitaminB2 = "riboflavin"
    case selenium = "selenium"
    case sodium = "sodium"
    case vitaminB1 = "thiamin"
    case vitaminA = "vitamin-a"
    case vitaminB6 = "vitamin-b6"
    case vitaminB12 = "vitamin-b12"
    case vitaminC = "vitamin-c"
    case vitaminD = "vitamin-d"
    case vitaminE = "vitamin-e"
    case vitaminK = "vitamin-k"
    case sugar = "sugar"
    case zinc = "zinc"

    public var name: String {
        switch self {
        case .empty: return "None"
        case .metaScore: return "Meta Score"
        case .popularity: return "Popularity"
        case .healthiness: return "Healthiness"
        case .price: return "Price"
        case .time: return "Time"
        case .random: return "Random"
        case .maxUsedIngredients: return "Max Used Ingredients"
        case .minMissingIngredients: return "Min Missing Ingredients"
        case .alcohol: return "Alcohol"
        case .caffeine: return "Caffeine"
        case .copper: return "Copper"
        case .energy: return "Energy"
        case .calories: return "Calories"
        case .calcium: return "Calcium"
        case .carbohydrates: return "Carbohydrates"
        case .carbs: return "Carbs"
        case .choline: return "Choline"
        case .cholesterol: return "Cholesterol"
        case .totalFat: return "Total Fat"
        case .fluoride: return "Fluoride"
        case .transFat: return "Trans Fat"
        case .saturatedFat: return "Saturated Fat"
        case .monoUnsaturatedFat: return "Mono Unsaturated Fat"
        case .polyUnsaturatedFat: return "Poly Unsaturated Fat"
        case .fiber: return "Fiber"
        case .folate: return "Folate"
        case .folicAcid: return "Folic Acid"
        case .iodine: return "Iodine"
        case .iron: return "Iron"
        case .magnesium: return "Magnesium"
        case .manganese: return "Manganese"
        case .vitaminB3: return "Vitamin B3"
        case .niacin: return "Niacin"
        case .vitaminB5: return "Pantothenic Acid"
        case .phosphorus: return "Phosphorus"
        case .potassium: return "Potassium"
        case .protein: return "Protein"
        case .vitaminB2: return "Riboflavin"
        case .selenium: return "Selenium"
        case .sodium: return "Sodium"
        case .vitaminB1: return "Thiamin"
        case .vitaminA: return "Vitamin A"
        case .vitaminB6: return "Vitamin B6"
        case .vitaminB12: return "Vitamin B12"
        case .vitaminC: return "Vitamin C"
        case .vitaminD: return "Vitamin D"
        case .vitaminE: return "Vitamin E"
        case .vitaminK: return "Vitamin K"
        case .sugar: return "Sugar"
        case .zinc: return "Zinc"
        }
    }

    public static let filterAvailableOptions: [SortingOption] = [
        .popularity,
        .healthiness,
        .time,
        .protein,
        .totalFat,
        .carbs,
        .sugar,
        .calories,
        .fiber,
        .price
    ]
}
