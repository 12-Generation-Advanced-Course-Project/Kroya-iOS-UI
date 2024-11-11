//
//  FoodSellResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 9/11/24.
//

import SwiftUI
import Foundation


// MARK: - FoodSellResponse
struct FoodSellResponse: Decodable {
    let id: Int
    let foodRecipeDTO: FoodRecipeDTO
    let dateCooking: String
    let amount: Int
    let price: Int
    let currencyType: String
    let location: String
    let status: Bool?
    let itemType: String
    let isFavorite: Bool
    let isOrderable: Bool
    let ratingPercentages: Double?
}

// MARK: - FoodRecipeDTO
struct FoodRecipeDTO: Decodable {
    let id: Int
    let photo: [Photo]
    let name: String
    let description: String
    let durationInMinutes: Int
    let level: String
    let cuisineName: String
    let categoryName: String
    let ingredients: [RecipeIngredient]
    let cookingSteps: [CookingStep]
    let totalRaters: Int?
    let averageRating: Double?
    let createdAt: String
    let user: User
}
