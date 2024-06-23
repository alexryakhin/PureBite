//
//  SearchRecipesParams.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/22/24.
//

import Foundation

public struct SearchRecipesParams: SpoonacularAPIParams {
    //The (natural language) recipe search query.
    public let query: String?
    public let cuisines: [Cuisine]
    public let excludeCuisines: [Cuisine]
    public let diet: [Diet]
    public let intolerances: [Intolerance]
    public let equipment: [Equipment]
    public let includeIngredients: String?
    public let excludeIngredients: String?
    public let type: MealType?
    public let instructionsRequired: Bool?
    public let fillIngredients: Bool?
    public let addRecipeInformation: Bool?
    public let addRecipeInstructions: Bool?
    public let addRecipeNutrition: Bool?
    public let author: String?
    public let tags: String?
    public let recipeBoxId: Int?
    public let titleMatch: String?
    public let maxReadyTime: Int?
    public let minServings: Int?
    public let maxServings: Int?
    public let ignorePantry: Bool?
    public let sort: SortingOption
    public let sortDirection: String?
    public let minCarbs: Int?
    public let maxCarbs: Int?
    public let minProtein: Int?
    public let maxProtein: Int?
    public let minCalories: Int?
    public let maxCalories: Int?
    public let minFat: Int?
    public let maxFat: Int?
    public let minFiber: Int?
    public let maxFiber: Int?
    public let minSugar: Int?
    public let maxSugar: Int?
    public let offset: Int?
    public let number: Int?

    public init(
        query: String? = nil,
        cuisines: [Cuisine] = [],
        excludeCuisines: [Cuisine] = [],
        diet: [Diet] = [],
        intolerances: [Intolerance] = [],
        equipment: [Equipment] = [],
        includeIngredients: String? = nil,
        excludeIngredients: String? = nil,
        type: MealType? = nil,
        instructionsRequired: Bool? = nil,
        fillIngredients: Bool? = nil,
        addRecipeInformation: Bool? = nil,
        addRecipeInstructions: Bool? = nil,
        addRecipeNutrition: Bool? = nil,
        author: String? = nil,
        tags: String? = nil,
        recipeBoxId: Int? = nil,
        titleMatch: String? = nil,
        maxReadyTime: Int? = nil,
        minServings: Int? = nil,
        maxServings: Int? = nil,
        ignorePantry: Bool? = nil,
        sort: SortingOption = .empty,
        sortDirection: String? = nil,
        minCarbs: Int? = nil,
        maxCarbs: Int? = nil,
        minProtein: Int? = nil,
        maxProtein: Int? = nil,
        minCalories: Int? = nil,
        maxCalories: Int? = nil,
        minFat: Int? = nil,
        maxFat: Int? = nil,
        minFiber: Int? = nil,
        maxFiber: Int? = nil,
        minSugar: Int? = nil,
        maxSugar: Int? = nil,
        offset: Int? = nil,
        number: Int? = nil
    ) {
        self.query = query
        self.cuisines = cuisines
        self.excludeCuisines = excludeCuisines
        self.diet = diet
        self.intolerances = intolerances
        self.equipment = equipment
        self.includeIngredients = includeIngredients
        self.excludeIngredients = excludeIngredients
        self.type = type
        self.instructionsRequired = instructionsRequired
        self.fillIngredients = fillIngredients
        self.addRecipeInformation = addRecipeInformation
        self.addRecipeInstructions = addRecipeInstructions
        self.addRecipeNutrition = addRecipeNutrition
        self.author = author
        self.tags = tags
        self.recipeBoxId = recipeBoxId
        self.titleMatch = titleMatch
        self.maxReadyTime = maxReadyTime
        self.minServings = minServings
        self.maxServings = maxServings
        self.ignorePantry = ignorePantry
        self.sort = sort
        self.sortDirection = sortDirection
        self.minCarbs = minCarbs
        self.maxCarbs = maxCarbs
        self.minProtein = minProtein
        self.maxProtein = maxProtein
        self.minCalories = minCalories
        self.maxCalories = maxCalories
        self.minFat = minFat
        self.maxFat = maxFat
        self.minFiber = minFiber
        self.maxFiber = maxFiber
        self.minSugar = minSugar
        self.maxSugar = maxSugar
        self.offset = offset
        self.number = number
    }

    func queryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []

        if let query = query {
            queryItems.append(URLQueryItem(name: "query", value: query))
        }
        if !cuisines.isEmpty {
            queryItems.append(URLQueryItem(name: "cuisine", value: cuisines.toString))
        }
        if !excludeCuisines.isEmpty {
            queryItems.append(URLQueryItem(name: "excludeCuisine", value: excludeCuisines.toString))
        }
        if !diet.isEmpty {
            queryItems.append(URLQueryItem(name: "diet", value: diet.toString))
        }
        if !intolerances.isEmpty {
            queryItems.append(URLQueryItem(name: "intolerances", value: intolerances.toString))
        }
        if !equipment.isEmpty {
            queryItems.append(URLQueryItem(name: "equipment", value: equipment.toString))
        }
        if let includeIngredients = includeIngredients {
            queryItems.append(URLQueryItem(name: "includeIngredients", value: includeIngredients))
        }
        if let excludeIngredients = excludeIngredients {
            queryItems.append(URLQueryItem(name: "excludeIngredients", value: excludeIngredients))
        }
        if let type = type {
            queryItems.append(URLQueryItem(name: "type", value: type.rawValue))
        }
        if let instructionsRequired = instructionsRequired {
            queryItems.append(URLQueryItem(name: "instructionsRequired", value: String(instructionsRequired)))
        }
        if let fillIngredients = fillIngredients {
            queryItems.append(URLQueryItem(name: "fillIngredients", value: String(fillIngredients)))
        }
        if let addRecipeInformation = addRecipeInformation {
            queryItems.append(URLQueryItem(name: "addRecipeInformation", value: String(addRecipeInformation)))
        }
        if let addRecipeInstructions = addRecipeInstructions {
            queryItems.append(URLQueryItem(name: "addRecipeInstructions", value: String(addRecipeInstructions)))
        }
        if let addRecipeNutrition = addRecipeNutrition {
            queryItems.append(URLQueryItem(name: "addRecipeNutrition", value: String(addRecipeNutrition)))
        }
        if let author = author {
            queryItems.append(URLQueryItem(name: "author", value: author))
        }
        if let tags = tags {
            queryItems.append(URLQueryItem(name: "tags", value: tags))
        }
        if let recipeBoxId = recipeBoxId {
            queryItems.append(URLQueryItem(name: "recipeBoxId", value: String(recipeBoxId)))
        }
        if let titleMatch = titleMatch {
            queryItems.append(URLQueryItem(name: "titleMatch", value: titleMatch))
        }
        if let maxReadyTime = maxReadyTime {
            queryItems.append(URLQueryItem(name: "maxReadyTime", value: String(maxReadyTime)))
        }
        if let minServings = minServings {
            queryItems.append(URLQueryItem(name: "minServings", value: String(minServings)))
        }
        if let maxServings = maxServings {
            queryItems.append(URLQueryItem(name: "maxServings", value: String(maxServings)))
        }
        if let ignorePantry = ignorePantry {
            queryItems.append(URLQueryItem(name: "ignorePantry", value: String(ignorePantry)))
        }
        if sort != .empty {
            queryItems.append(URLQueryItem(name: "sort", value: sort.rawValue))
        }
        if let sortDirection = sortDirection {
            queryItems.append(URLQueryItem(name: "sortDirection", value: sortDirection))
        }
        if let minCarbs = minCarbs {
            queryItems.append(URLQueryItem(name: "minCarbs", value: String(minCarbs)))
        }
        if let maxCarbs = maxCarbs {
            queryItems.append(URLQueryItem(name: "maxCarbs", value: String(maxCarbs)))
        }
        if let minProtein = minProtein {
            queryItems.append(URLQueryItem(name: "minProtein", value: String(minProtein)))
        }
        if let maxProtein = maxProtein {
            queryItems.append(URLQueryItem(name: "maxProtein", value: String(maxProtein)))
        }
        if let minCalories = minCalories {
            queryItems.append(URLQueryItem(name: "minCalories", value: String(minCalories)))
        }
        if let maxCalories = maxCalories {
            queryItems.append(URLQueryItem(name: "maxCalories", value: String(maxCalories)))
        }
        if let minFat = minFat {
            queryItems.append(URLQueryItem(name: "minFat", value: String(minFat)))
        }
        if let maxFat = maxFat {
            queryItems.append(URLQueryItem(name: "maxFat", value: String(maxFat)))
        }
        if let minFiber = minFiber {
            queryItems.append(URLQueryItem(name: "minFiber", value: String(minFiber)))
        }
        if let maxFiber = maxFiber {
            queryItems.append(URLQueryItem(name: "maxFiber", value: String(maxFiber)))
        }
        if let minSugar = minSugar {
            queryItems.append(URLQueryItem(name: "minSugar", value: String(minSugar)))
        }
        if let maxSugar = maxSugar {
            queryItems.append(URLQueryItem(name: "maxSugar", value: String(maxSugar)))
        }
        if let offset = offset {
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        if let number = number {
            queryItems.append(URLQueryItem(name: "number", value: String(number)))
        }

        return queryItems
    }
}
