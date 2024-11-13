//
//  PopularModel.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/11/24.
//

import Foundation


// Payload Model
struct PopularPayload: Codable {
    let popularSells: [FoodSellModel]
    let popularRecipes: [FoodRecipeModel]


}

enum PopularFoodItem {
    case sell(FoodSellModel)
    case recipe(FoodRecipeModel)
}
