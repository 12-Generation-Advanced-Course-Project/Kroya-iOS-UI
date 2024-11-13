//
//  RecipeModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 7/11/24.
//

import SwiftUI
import Foundation

//MARK: FoodRecipe for get all
struct FoodRecipeModel: Identifiable, Codable {
    let id: Int
    let photo: [Photo]
    let name: String
    let description: String
    let level: String
    let averageRating: Double?
    let totalRaters: Int?
    let isFavorite: Bool
    let itemType: String
    let user: userModel
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
    case Snack = "Snack"
    
    var id: Int {
        switch self {
        case .Breakfast: return 1
        case .Lunch: return 2
        case .Dinner: return 3
        case .Snack: return 4
        }
    }
}
