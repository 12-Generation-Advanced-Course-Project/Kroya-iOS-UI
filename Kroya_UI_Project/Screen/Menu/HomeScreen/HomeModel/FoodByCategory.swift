//
//  Model.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 8/10/24.
//

import SwiftUI

struct PayloadCategory: Decodable {
    let foodRecipes: [FoodRecipeModel]
    let foodSells: [FoodSellModel]
}
