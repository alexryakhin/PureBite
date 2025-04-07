//
//  Recipe.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

public struct Macros: Hashable {
    public let protein: Double
    public let carbohydrates: Double
    public let fat: Double

    public init(protein: Double, carbohydrates: Double, fat: Double) {
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
    }
}

public struct Recipe: Identifiable, Hashable {
    public let id: Int
    public let title: String

    /// HTML format
    public let summary: String
    /// HTML format
    public let instructions: String

    public let dateSaved: Date?

    public let cuisines: [Cuisine]
    public let diets: [Diet]
    public let mealTypes: [MealType]
    public let occasions: [Occasion]

    public let ingredients: [Ingredient]
    public let macros: Macros

    public let score: Double
    public let servings: Int

    public let likes: Int
    public let cookingMinutes: Int?
    public let healthScore: Int
    public let preparationMinutes: Int
    public let pricePerServing: Double
    public let readyInMinutes: Int

    public let isCheap: Bool
    public let isVegan: Bool
    public let isSustainable: Bool
    public let isVegetarian: Bool
    public let isVeryHealthy: Bool
    public let isVeryPopular: Bool
    public let isGlutenFree: Bool
    public let isDairyFree: Bool

    public var imageUrl: URL? {
        ImageHelper.recipeImageUrl(for: id)
    }

    public init(
        id: Int,
        title: String,
        summary: String,
        instructions: String,
        dateSaved: Date?,
        cuisines: [Cuisine],
        diets: [Diet],
        mealTypes: [MealType],
        occasions: [Occasion],
        ingredients: [Ingredient],
        macros: Macros,
        score: Double,
        servings: Int,
        likes: Int,
        cookingMinutes: Int?,
        healthScore: Int,
        preparationMinutes: Int,
        pricePerServing: Double,
        readyInMinutes: Int,
        isCheap: Bool,
        isVegan: Bool,
        isSustainable: Bool,
        isVegetarian: Bool,
        isVeryHealthy: Bool,
        isVeryPopular: Bool,
        isGlutenFree: Bool,
        isDairyFree: Bool
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.instructions = instructions
        self.dateSaved = dateSaved
        self.cuisines = cuisines
        self.diets = diets
        self.mealTypes = mealTypes
        self.occasions = occasions
        self.ingredients = ingredients
        self.macros = macros
        self.score = score
        self.servings = servings
        self.likes = likes
        self.cookingMinutes = cookingMinutes
        self.healthScore = healthScore
        self.preparationMinutes = preparationMinutes
        self.pricePerServing = pricePerServing
        self.readyInMinutes = readyInMinutes
        self.isCheap = isCheap
        self.isVegan = isVegan
        self.isSustainable = isSustainable
        self.isVegetarian = isVegetarian
        self.isVeryHealthy = isVeryHealthy
        self.isVeryPopular = isVeryPopular
        self.isGlutenFree = isGlutenFree
        self.isDairyFree = isDairyFree
    }
}

extension Recipe {
    public static let mock = Recipe(
        id: 716429,
        title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",
        summary: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs might be a good recipe to expand your main course repertoire. One portion of this dish contains approximately <b>19g of protein </b>,  <b>20g of fat </b>, and a total of  <b>584 calories </b>. For  <b>$1.63 per serving </b>, this recipe  <b>covers 23% </b> of your daily requirements of vitamins and minerals. This recipe serves 2. It is brought to you by fullbellysisters.blogspot.com. 209 people were glad they tried this recipe. A mixture of scallions, salt and pepper, white wine, and a handful of other ingredients are all it takes to make this recipe so scrumptious. From preparation to the plate, this recipe takes approximately  <b>45 minutes </b>. All things considered, we decided this recipe  <b>deserves a spoonacular score of 83% </b>. This score is awesome. If you like this recipe, take a look at these similar recipes: <a href=\"https://spoonacular.com/recipes/cauliflower-gratin-with-garlic-breadcrumbs-318375\">Cauliflower Gratin with Garlic Breadcrumbs</a>, < href=\"https://spoonacular.com/recipes/pasta-with-cauliflower-sausage-breadcrumbs-30437\">Pasta With Cauliflower, Sausage, & Breadcrumbs</a>, and <a href=\"https://spoonacular.com/recipes/pasta-with-roasted-cauliflower-parsley-and-breadcrumbs-30738\">Pasta With Roasted Cauliflower, Parsley, And Breadcrumbs</a>.",
        instructions: "<ol><li>Spread the dry beans out on a baking sheet and pick out any pebbles. </li><li>Place the beans in a big soup pot, cover with water by 3 inches and allow them to soak overnight or for 6-8 hours, then discard that water. </li><li>Return the soaked beans to the pot and cover with 3 inches of water again, bring to a boil. Reduce heat to medium low, put the cover on and allow to cook until the beans start to get tender but still firm, about 1 1/2 hours. Drain the beans.</li><li>Heat the oil in a soup pot over med-high heat. </li><li>Add the onion along with a pinch of salt and saute until softened and golden. </li><li>Stir in 1 tbsp of ground cumin, add the beans along with the broth or water and bring to a boil. Reduce heat to medium-low, cover and cook for 30 min. </li><li>Meanwhile peel and chop the sweet potatoes. </li><li>Wash the kale, remove the stems and chop the leaves.</li><li>Remove half of the beans and liquid and set aside to cool a bit. </li><li>Add the sweet potatoes and kale to the pot with some salt and pepper. Cover and cook for 10 minutes. </li><li>Transfer the cooled beans to a blender and puree until smooth, then return them to the pot. </li><li>Stir in the remaining 1 tbsp of ground cumin. </li><li>Now add 1 tbsp of the chipotles in adobo. Taste and continue to add more until it has a spice level that you like. </li><li>Adjust the salt &amp; pepper as needed.</li><li>Serve with a dollop of sour cream.</li></ol>",
        dateSaved: nil,
        cuisines: [.italian],
        diets: [],
        mealTypes: [.mainCourse],
        occasions: [.fall],
        ingredients: [
            Ingredient(id: 1001, amount: 1, imageUrlPath: "butter-sliced.jpg", unit: "tbsp", name: "butter", aisle: "Milk, Eggs, Other Dairy")
        ],
        macros: .init(protein: 50, carbohydrates: 25, fat: 25),
        score: 83,
        servings: 2,
        likes: 855,
        cookingMinutes: 25,
        healthScore: 53,
        preparationMinutes: 20,
        pricePerServing: 165.5,
        readyInMinutes: 45,
        isCheap: false,
        isVegan: false,
        isSustainable: true,
        isVegetarian: false,
        isVeryHealthy: false,
        isVeryPopular: true,
        isGlutenFree: false,
        isDairyFree: false
    )
}

public extension Recipe {
    var shortInfo: RecipeShortInfo {
        RecipeShortInfo(id: id, title: title)
    }
}
