//
//  FoodRecipeRequest.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 9/11/24.
//
import SwiftUI
//MARK: Model For Post Food Recipe
struct FoodRecipeRequest: Encodable {
    struct Photo: Encodable {
        let photo: String
    }

    struct Ingredient: Encodable {
        let name: String
        let quantity: Double
        let price: Double
    }

    struct CookingStep: Encodable {
        let description: String
    }
    
    let photo: [Photo]
    let name: String
    let description: String
    let durationInMinutes: Int
    let level: String
    let cuisineId: Int
    let categoryId: Int
    let ingredients: [Ingredient]
    let cookingSteps: [CookingStep]
}

