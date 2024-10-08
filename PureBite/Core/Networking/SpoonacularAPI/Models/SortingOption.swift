//
//  SortingOption.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

public enum SortingOption: String, Sendable {
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
}
