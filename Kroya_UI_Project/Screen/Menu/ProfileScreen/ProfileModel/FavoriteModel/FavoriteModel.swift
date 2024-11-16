//
//  FavoriteModel.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/14/24.

import Foundation

struct FavoritePayload: Decodable {
    let favoriteFoodSells: [FoodSellModel]?
    let favoriteFoodRecipes: [FoodRecipeModel]?
}
