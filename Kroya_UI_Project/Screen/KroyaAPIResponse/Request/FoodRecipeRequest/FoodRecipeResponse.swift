//
//  FoodRecipeResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 9/11/24.
//

import SwiftUI
import Foundation

//MARK: Payload for FoodRecipeResponse
struct FoodRecipeResponse: Decodable {
    var id: Int?
    var photo: [Photo]
    var name: String?
    var description: String?
    var durationInMinutes: Int?
    var level: String?
    var cuisineName: String?
    var categoryName: String?
    var ingredients: [RecipeIngredient]
    var cookingSteps: [CookingStep]
    var totalRaters: Int?
    var averageRating: Double?
    var isFavorite: Bool?
    var itemType: String?
    var user: userModel?
    var createdAt: String?
    var ratingPercentages: RatingPercentages?
}


// MARK: - Cooking Step (For RecipeModal)
struct CookingStep: Identifiable, Codable {
    var id: Int?
    var description: String
}

// MARK: - Recipe Ingredient (For RecipeModal)
struct RecipeIngredient: Identifiable, Codable {
    var id: Int?
    var name: String
    var quantity: Double
    var price: Double
    var selectedCurrency: Int?
}
