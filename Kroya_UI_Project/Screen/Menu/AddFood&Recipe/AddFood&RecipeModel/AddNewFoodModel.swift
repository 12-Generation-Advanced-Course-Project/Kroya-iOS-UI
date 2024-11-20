//
//  AddNewFoodModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 31/10/24.
//

import SwiftUI
// MARK: - AddNewFoodModel
struct AddNewFoodModel: Identifiable, Decodable {
    var id = UUID()
    var photos: [Photo]
    var name: String?
    var description: String?
    var durationInMinutes: Int?
    var level: String?
    var cuisineId: Int?
    var categoryId: Int?
    var ingredients: [RecipeIngredient]
    var cookingSteps: [CookingStep]
    var saleIngredients: SaleIngredient?
    var rating: Double?
    var reviewCount: Int?

    var isForSale: Bool {
        return saleIngredients != nil
    }
    var statusType: String {
        if isForSale, let price = saleIngredients?.price {
            return "Food on Sale - $\(String(format: "%.2f", price))"
        } else {
            return "Recipe"
        }
    }
}

// MARK: - Photo
struct Photo: Codable {
    let photo: String
}




// MARK: - Sale Ingredient (For SaleModalView)
struct SaleIngredient: Identifiable, Codable {
    var id = UUID()
    var cookDate: String?
    var amount: Double
    var price: Double
    var location: String?
    var selectedCurrency: Int
}

