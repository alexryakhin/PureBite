//
//  FoodItem.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//


import Foundation

// https://spoonacular.com/food-api/docs#Image-Classification-Categories
public enum FoodItem: String, Codable, CaseIterable {
    case agnolotti = "agnolotti"
    case ahiTuna = "ahi_tuna"
    case antipastoSalad = "antipasto_salad"
    case appleCake = "apple_cake"
    case babka = "babka"
    case bakedApple = "baked_apple"
    case bakedBeans = "baked_beans"
    case bakedPotato = "baked_potato"
    case bakedSalmon = "baked_salmon"
    case baklava = "baklava"
    case beefRibs = "beef_ribs"
    case beefStew = "beef_stew"
    case beefStroganoff = "beef_stroganoff"
    case beer = "beer"
    case bibimbap = "bibimbap"
    case biscotti = "biscotti"
    case brisket = "brisket"
    case brownies = "brownies"
    case burger = "burger"
    case burrito = "burrito"
    case calzone = "calzone"
    case capreseSalad = "caprese_salad"
    case cheesecake = "cheesecake"
    case chickenNuggets = "chicken_nuggets"
    case chickenWings = "chicken_wings"
    case chili = "chili"
    case chowMein = "chow_mein"
    case chowder = "chowder"
    case churros = "churros"
    case coffee = "coffee"
    case coleslaw = "coleslaw"
    case cookies = "cookies"
    case cremeBrulee = "creme_brulee"
    case crepes = "crepes"
    case cupcakes = "cupcakes"
    case donut = "donut"
    case falafel = "falafel"
    case fishAndChips = "fish_and_chips"
    case frenchToast = "french_toast"
    case fruitSalad = "fruit_salad"
    case gyros = "gyros"
    case iceCream = "ice_cream"
    case lasagne = "lasagne"
    case lobsterRoll = "lobster_roll"
    case macarons = "macarons"
    case nachos = "nachos"
    case omelet = "omelet"
    case paella = "paella"
    case pancakes = "pancakes"
    case sushi = "sushi"
    case other = "other"

    public var displayName: String {
        switch self {
        case .agnolotti: return "Agnolotti"
        case .ahiTuna: return "Ahi Tuna"
        case .antipastoSalad: return "Antipasto Salad"
        case .appleCake: return "Apple Cake"
        case .babka: return "Babka"
        case .bakedApple: return "Baked Apple"
        case .bakedBeans: return "Baked Beans"
        case .bakedPotato: return "Baked Potato"
        case .bakedSalmon: return "Baked Salmon"
        case .baklava: return "Baklava"
        case .beefRibs: return "Beef Ribs"
        case .beefStew: return "Beef Stew"
        case .beefStroganoff: return "Beef Stroganoff"
        case .beer: return "Beer"
        case .bibimbap: return "Bibimbap"
        case .biscotti: return "Biscotti"
        case .brisket: return "Brisket"
        case .brownies: return "Brownies"
        case .burger: return "Burger"
        case .burrito: return "Burrito"
        case .calzone: return "Calzone"
        case .capreseSalad: return "Caprese Salad"
        case .cheesecake: return "Cheesecake"
        case .chickenNuggets: return "Chicken Nuggets"
        case .chickenWings: return "Chicken Wings"
        case .chili: return "Chili"
        case .chowMein: return "Chow Mein"
        case .chowder: return "Chowder"
        case .churros: return "Churros"
        case .coffee: return "Coffee"
        case .coleslaw: return "Coleslaw"
        case .cookies: return "Cookies"
        case .cremeBrulee: return "Crème Brûlée"
        case .crepes: return "Crêpes"
        case .cupcakes: return "Cupcakes"
        case .donut: return "Donut"
        case .falafel: return "Falafel"
        case .fishAndChips: return "Fish and Chips"
        case .frenchToast: return "French Toast"
        case .fruitSalad: return "Fruit Salad"
        case .gyros: return "Gyros"
        case .iceCream: return "Ice Cream"
        case .lasagne: return "Lasagne"
        case .lobsterRoll: return "Lobster Roll"
        case .macarons: return "Macarons"
        case .nachos: return "Nachos"
        case .omelet: return "Omelet"
        case .paella: return "Paella"
        case .pancakes: return "Pancakes"
        case .sushi: return "Sushi"
        case .other: return "Other"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = FoodItem(rawValue: rawValue.lowercased()) ?? .other
    }
}

public extension Array where Element == FoodItem {
    var toData: Data {
        guard let data = try? JSONEncoder().encode(self) else {
            return Data()
        }
        return data
    }
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}
