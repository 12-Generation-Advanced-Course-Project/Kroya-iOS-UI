//
//  FavoriteRequest.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/15/24.
//

import Foundation

struct FavoriteRequest: Encodable {
    let favoriteFoodSells: [FoodSellRequest]?
    let favoriteFoodRecipes: [FoodRecipeRequest]?
}
