//
//  RecipeSearchFilters.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/2/25.
//

struct RecipeSearchFilters: Hashable {
    var mealType: MealType?
    var selectedCuisines: Set<Cuisine>
    var selectedDiets: Set<Diet>
    var maxReadyTime: Double
    var sortBy: SortingOption
    var minCalories: Int?
    var maxCalories: Int?
    var minProtein: Int?
    var maxProtein: Int?
    var minCarbs: Int?
    var maxCarbs: Int?
    var minFat: Int?
    var maxFat: Int?

    init(
        mealType: MealType? = nil,
        selectedCuisines: Set<Cuisine> = [],
        selectedDiets: Set<Diet> = [],
        maxReadyTime: Double = 120,
        sortBy: SortingOption = .healthiness,
        minCalories: Int? = nil,
        maxCalories: Int? = nil,
        minProtein: Int? = nil,
        maxProtein: Int? = nil,
        minCarbs: Int? = nil,
        maxCarbs: Int? = nil,
        minFat: Int? = nil,
        maxFat: Int? = nil
    ) {
        self.mealType = mealType
        self.selectedCuisines = selectedCuisines
        self.selectedDiets = selectedDiets
        self.maxReadyTime = maxReadyTime
        self.sortBy = sortBy
        self.minCalories = minCalories
        self.maxCalories = maxCalories
        self.minProtein = minProtein
        self.maxProtein = maxProtein
        self.minCarbs = minCarbs
        self.maxCarbs = maxCarbs
        self.minFat = minFat
        self.maxFat = maxFat
    }

    static let initial = RecipeSearchFilters()

    var isApplied: Bool {
        self.hashValue != Self.initial.hashValue
    }
}
