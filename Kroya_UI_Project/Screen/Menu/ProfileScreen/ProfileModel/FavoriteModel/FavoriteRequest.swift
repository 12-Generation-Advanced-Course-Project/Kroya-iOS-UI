//
//  FavoriteRequest.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/15/24.
//

import Foundation

//struct FavoriteRequest: Encodable {
//    let foodId: Int  // Use this for identifying the item to be toggled
//    let itemType: String  // e.g., "FOOD_SELL" or "FOOD_RECIPE"
//    let favoriteFoodSells: [FoodSellRequest]?
//    let favoriteFoodRecipes: [FoodRecipeRequest]?
//}

//struct ToggleFavoriteRequest: Encodable {
//    let foodId: Int  // Use this for identifying the item to be toggled
//    let itemType: String  // e.g., "FOOD_SELL" or "FOOD_RECIPE"
//}
struct FavoriteRequest: Encodable {
    let foodId: Int
    let itemType: String // "FOOD_SELL" or "FOOD_RECIPE"
}
