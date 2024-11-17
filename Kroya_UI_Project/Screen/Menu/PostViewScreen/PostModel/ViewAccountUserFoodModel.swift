//
//  ViewAccountUserFoodModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 16/11/24.
//

import SwiftUI
struct ViewAccountUserFoodModel:Decodable{
    var fullName:String
    var email:String
    var profileImage:String
    var totalFoodRecipes:Int
    var totalFoodSells:Int
    var totalPosts:Int
    var foodRecipes: [FoodRecipeModel]
    var foodSells:[FoodSellModel]
}
