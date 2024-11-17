//
//  FoodRecipeDetailsResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 15/11/24.
//

import SwiftUI
import Foundation


struct FoodRecipeDetail: Decodable {
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
    let isFavorite: Bool
    let itemType: String
    let user: userModel
    let createdAt: String
    let ratingPercentages: RatingPercentages?
}
