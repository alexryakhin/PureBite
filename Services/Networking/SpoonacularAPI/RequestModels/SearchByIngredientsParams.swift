//
//  SearchByIngredientsParams.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import Foundation

struct SearchByIngredientsParams: SpoonacularAPIParams {
    let ingredients: [String]
    let number: Int?
    let ranking: Int?
    let ignorePantry: Bool?
    
    init(
        ingredients: [String],
        number: Int? = 10,
        ranking: Int? = 1,
        ignorePantry: Bool? = true
    ) {
        self.ingredients = ingredients
        self.number = number
        self.ranking = ranking
        self.ignorePantry = ignorePantry
    }
    
    func queryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        // Join ingredients with commas
        let ingredientsString = ingredients.joined(separator: ",")
        queryItems.append(URLQueryItem(name: "ingredients", value: ingredientsString))
        
        if let number = number {
            queryItems.append(URLQueryItem(name: "number", value: String(number)))
        }
        
        if let ranking = ranking {
            queryItems.append(URLQueryItem(name: "ranking", value: String(ranking)))
        }
        
        if let ignorePantry = ignorePantry {
            queryItems.append(URLQueryItem(name: "ignorePantry", value: String(ignorePantry)))
        }
        
        return queryItems
    }
} 