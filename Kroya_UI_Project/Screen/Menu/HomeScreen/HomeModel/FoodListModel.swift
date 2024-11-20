//
//  FoodListModel.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/20/24.
//

import Foundation

// Payload Model
struct FoodListPayload: Codable {
    let foodSells: [FoodSellModel]
    let foodRecipes: [FoodRecipeModel]
}
