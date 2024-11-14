//
//  PopularModel.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/11/24.
//

import Foundation


// Payload Model
struct PopularPayload: Decodable {
    let popularSells: [FoodSellModel]
    let popularRecipes: [FoodRecipeModel]


}
