//
//  UserFoodModel.swift
//  Kroya_UI_Project
//
//  Created by kosign on 8/11/24.
//
import SwiftUI

//MARK: UserFoodModel
struct UserFoodModel : Codable{
    let totalFoodRecipes: Int
    let totalFoodSells: Int
    let totalPosts : Int
//    let foodSells : [FoodModel]
    let foodRecipes : [FoodRecipeModel]
}
