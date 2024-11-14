//
//  Draft.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 2/11/24.
//

import SwiftData
import SwiftUI

@Model
class Draft {
    var id: UUID
    var email: String
    var foodName: String
    var descriptionText: String
    var selectedLevel: String?
    var selectedCuisine: String?
    var selectedCategory: String?
    var duration: Double
    var amount: Double
    var price: Double
    var location: String
    var currency: String
    var isForSale: Bool
    var cookDate: Date
    var selectedImagesData: Data?
    var ingredients: [RecipeIngredient]
    var cookingSteps: [CookingStep]
    init(id: UUID = UUID(), email: String ,foodName: String = "", descriptionText: String = "", selectedLevel: String? = nil,
         selectedCuisine: String? = nil, selectedCategory: String? = nil, duration: Double = 0,
         amount: Double = 0, price: Double = 0, location: String = "",currency: String = "", isForSale: Bool = false,
         cookDate: Date = Date(), selectedImagesData: Data? = nil,
         ingredients: [RecipeIngredient] = [], cookingSteps: [CookingStep] = []) {
        self.id = id
        self.email = email
        self.foodName = foodName
        self.descriptionText = descriptionText
        self.selectedLevel = selectedLevel
        self.selectedCuisine = selectedCuisine
        self.selectedCategory = selectedCategory
        self.duration = duration
        self.amount = amount
        self.price = price
        self.location = location
        self.currency = currency
        self.isForSale = isForSale
        self.cookDate = cookDate
        self.selectedImagesData = selectedImagesData
        self.ingredients = ingredients
        self.cookingSteps = cookingSteps
    }
}
