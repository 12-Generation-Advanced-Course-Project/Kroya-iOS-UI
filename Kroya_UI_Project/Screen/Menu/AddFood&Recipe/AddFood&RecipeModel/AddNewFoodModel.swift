//
//  AddNewFoodModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 31/10/24.
//

import SwiftUI

// MARK: - AddNewFoodModel
struct AddNewFoodModel: Codable {
    var photos: [Photo]
    var name: String
    var description: String
    var durationInMinutes: Int
    var level: String
    var cuisineId: Int
    var categoryId: Int
    var ingredients: [RecipeIngredient]
    var cookingSteps: [CookingStep]
}

// MARK: - Photo
struct Photo: Codable {
    var photo: String
}

// MARK: - Recipe Ingredient (For RecipeModal)
struct RecipeIngredient: Identifiable, Codable {
    var id: Int
    var name: String
    var quantity: Double
    var price: Double
    var selectedCurrency: Int = 0
}

// MARK: - Cooking Step (For RecipeModal)
struct CookingStep: Identifiable, Codable {
    var id: Int
    var description: String
}

// MARK: - Sale Ingredient (For SaleModalView)
struct SaleIngredient: Identifiable, Codable {
    var id = UUID()
    var cookDate: String
    var amount: Double
    var price: String
    var location: String
    var selectedCurrency: Int
}

// Example usage for each view
// You can initialize and use these structures in `AddNewFood`, `RecipeModal`, and `SaleModalView`.
