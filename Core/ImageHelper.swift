//
//  ImageHelper.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

// https://spoonacular.com/food-api/docs#Show-Images
public enum ImageHelper {

    // MARK: - Ingredients
    /**
     Endpoints like the ingredient autosuggestion will only give you an image name. You have to build the full URL by adding the base path to the beginning. The base path for ingredient images is https://img.spoonacular.com/ingredients_{SIZE}/, where {SIZE} is one of the following:

     100x100
     250x250
     500x500
     So for "apple.jpg" the full path for 100x100 is https://img.spoonacular.com/ingredients_100x100/apple.jpg
     */
    public enum IngredientsImageSize: String {
        case small = "100x100"
        case medium = "250x250"
        case large = "500x500"
    }

    public static func ingredientsImageUrl(
        for ingredient: String,
        size: IngredientsImageSize = .small
    ) -> URL? {
        URL(string: "https://img.spoonacular.com/ingredients_\(size.rawValue)/\(ingredient)")
    }

    // MARK: - Cooking Equipment
    /**
     The recipe instruction endpoint will give you information about the equipment used for cooking the dish. You will again only receive the image name for the equipment. You have to build the full URL by adding the base path to the beginning. The base path for equipment images is https://img.spoonacular.com/equipment_{SIZE}/, where {SIZE} is one of the following:

     100x100
     250x250
     500x500
     So for "slow-cooker.jpg" the full path for 100x100 is https://img.spoonacular.com/equipment_100x100/slow-cooker.jpg
     */

    public enum EquipmentImageSize: String {
        case small = "100x100"
        case medium = "250x250"
        case large = "500x500"
    }

    public static func equipmentImageUrl(
        for equipment: String,
        size: EquipmentImageSize = .small
    ) -> URL? {
        URL(string: "https://img.spoonacular.com/equipment_\(size.rawValue)/\(equipment)")
    }

    // MARK: - Recipes
    /**
     Recipe endpoints will almost always give you a recipe id {ID}. With that and the imageType {TYPE} you can build the complete image paths depending on your needs.

     The base path for image URLs is https://img.spoonacular.com/recipes/. Once you know the recipe id {ID} and image type {TYPE}, you can complete that path to show an image. The complete path follows this pattern https://img.spoonacular.com/recipes/{ID}-{SIZE}.{TYPE}, where {SIZE} is one of the following:

     90x90
     240x150
     312x150
     312x231
     480x360
     556x370
     636x393
     A complete image path might look like this: https://img.spoonacular.com/recipes/1697885-556x370.jpg
     */

    public enum RecipeImageSize: String {
        case small = "312x231"
        case medium = "480x360"
        case large = "556x370"
        case extraLarge = "636x393"
    }

    public static func recipeImageUrl(
        for recipeId: Int,
        size: RecipeImageSize = .medium
    ) -> URL? {
        URL(string: "https://img.spoonacular.com/recipes/\(recipeId)-\(size.rawValue).jpg")
    }

    // MARK: - Grocery Products
    /**
     Grocery product endpoints will almost always give you a product id {ID}. With that and the imageType {TYPE} you can build the complete image paths depending on your needs.

     The base path for image URLs is https://img.spoonacular.com/products/. Once you know the product id {ID} and image type {TYPE}, you can complete that path to show an image. The complete path follows this pattern https://img.spoonacular.com/products/{ID}-{SIZE}.{TYPE}, where {SIZE} is one of the following:

     90x90
     312x231
     636x393
     A complete image path might look like this: https://img.spoonacular.com/products/35507-636x393.jpeg
     */

    public enum ProductImageSize: String {
        case small = "90x90"
        case medium = "312x231"
        case large = "636x393"
    }

    public static func productImageUrl(
        for productId: Int,
        size: ProductImageSize = .medium
    ) -> URL? {
        URL(string: "https://img.spoonacular.com/products/\(productId)-\(size.rawValue).jpeg")
    }

    // MARK: - Menu Items
    /**
     Menu item will almost always give you a menu item id {ID}. With that and the imageType {TYPE} you can build the complete image paths depending on your needs.

     The base path for image URLs is https://img.spoonacular.com/menu-items/. Once you know the menu item id {ID} and image type {TYPE}, you can complete that path to show an image. The complete path follows this pattern https://img.spoonacular.com/menu-items/{ID}-{SIZE}.{TYPE}, where {SIZE} is one of the following:

     90x90
     312x231
     636x393
     A complete image path might look like this: https://img.spoonacular.com/menu-items/423186-636x393.png
     */

    public enum MenuItemImageSize: String {
        case small = "90x90"
        case medium = "312x231"
        case large = "636x393"
    }

    public static func menuItemImageUrl(
        for menuItemId: Int,
        size: MenuItemImageSize = .medium
    ) -> URL? {
        URL(string: "https://img.spoonacular.com/menu-items/\(menuItemId)-\(size.rawValue).png")
    }
}
