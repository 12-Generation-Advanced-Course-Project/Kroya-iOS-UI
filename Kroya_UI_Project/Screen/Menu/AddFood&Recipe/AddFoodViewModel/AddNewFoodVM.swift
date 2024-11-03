//
//  AddNewFoodVM.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 31/10/24.
//

import SwiftUI

class AddNewFoodVM: ObservableObject {
    @Published var AllNewFoodandRecipe: [AddNewFoodModel] = []
    @Published var addNewFood: AddNewFoodModel?
    
    //MARK: Add New Food or Recipe
    func AddNewRecipeFood(_ newFood: AddNewFoodModel) {
        AllNewFoodandRecipe.append(newFood)
    }
    
    //MARK: Get all Food
    func GetAllRecipeFood() {
        let data = AddNewFoodModel.init(photos: [], name: "", description: "", durationInMinutes: 0, level: "", cuisineId: 0, categoryId: 0, ingredients: [], cookingSteps: [])
        AllNewFoodandRecipe.append(data)
    }
}
