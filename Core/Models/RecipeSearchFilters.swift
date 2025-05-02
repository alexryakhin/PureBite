//
//  RecipeSearchFilters.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/2/25.
//

public struct RecipeSearchFilters: Hashable {
    public var mealType: MealType?
    public var selectedCuisines: Set<Cuisine>
    public var selectedDiets: Set<Diet>
    public var maxReadyTime: Double
    public var sortBy: SortingOption
    public var minCalories: Int?
    public var maxCalories: Int?
    public var minProtein: Int?
    public var maxProtein: Int?
    public var minCarbs: Int?
    public var maxCarbs: Int?
    public var minFat: Int?
    public var maxFat: Int?

    public init(
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

    public static let initial = RecipeSearchFilters()

    public var isApplied: Bool {
        self.hashValue != Self.initial.hashValue
    }
}
