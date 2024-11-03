//
//  AddNewFoodModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 31/10/24.
//

import SwiftUI

// MARK: - AddNewFoodModel
struct AddNewFoodModel: Codable {
    var photos: [Photo]
    var name: String
    var description: String
    var durationInMinutes: Int
    var level: String
    var cuisineId: Int
    var categoryId: Int
    var ingredients: [RecipeIngredient]
    var cookingSteps: [CookingStep]
    var saleIngredients: SaleIngredient?
    var isForSale: Bool {
        return saleIngredients != nil
    }
}

// MARK: - Photo
struct Photo: Codable {
    var photo: String
}

// MARK: - Recipe Ingredient (For RecipeModal)
struct RecipeIngredient: Identifiable, Codable {
    var id: Int
    var name: String
    var quantity: Double
    var price: Double
    var selectedCurrency: Int = 0
}

// MARK: - Cooking Step (For RecipeModal)
struct CookingStep: Identifiable, Codable {
    var id: Int
    var description: String
}

// MARK: - Sale Ingredient (For SaleModalView)
struct SaleIngredient: Identifiable, Codable {
    var id = UUID()
    var cookDate: String
    var amount: Double
    var price: Double
    var location: String
    var selectedCurrency: Int
}

enum cuisine: String {
    case Soup = "Soup"
    case Salad = "Salad"
    case Dessert = "Dessert"
    case Grill = "Grill"
    
    var id: Int {
        switch self {
        case .Soup: return 1
        case .Salad: return 2
        case .Dessert: return 3
        case .Grill: return 4
        }
    }
}

enum category: String {
    case Breakfast = "Breakfast"
    case Lunch = "Lunch"
    case Dinner = "Dinner"
    case snack = "Snack"
    
    var id: Int {
        switch self {
        case .Breakfast: return 1
        case .Lunch: return 2
        case .Dinner: return 3
        case .snack: return 4
        }
    }
}

