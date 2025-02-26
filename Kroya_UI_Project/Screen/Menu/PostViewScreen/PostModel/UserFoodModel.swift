//
//  UserFoodModel.swift
//  Kroya_UI_Project
//
//  Created by kosign on 8/11/24.
//
import SwiftUI

//MARK: UserFoodModel
struct UserFoodModel : Decodable{
    let totalFoodRecipes: Int
    let totalFoodSells: Int
    let totalPosts : Int
    
//    let foodSells : [FoodModel]
    let foodRecipes : [FoodRecipeModel]
    let foodSells : [FoodSellModel]
}
