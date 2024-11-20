//
//  SearchModel.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/19/24.
//

import Foundation
struct SearchModel: Decodable {
    let foodSells: [FoodSellModel]
    let foodRecipes: [FoodRecipeModel]
}

