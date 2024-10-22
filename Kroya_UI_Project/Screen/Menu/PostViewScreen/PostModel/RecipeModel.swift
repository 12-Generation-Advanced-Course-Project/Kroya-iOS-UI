//
//  RecipeModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 22/10/24.
//

import Foundation

struct RecipeModel: Identifiable {
    
    var id = UUID()                 // Unique identifier
    var imageName: String           // Name of the image asset
    var dishName: String            // Name of the dish
    var cookingDate: String         // Cooking date for the dish
    var status: String              // Status of the dish (e.g., "Available", "Sold Out", etc.)
    var rating: Double              // Rating of the dish
    var reviewCount: Int            // Number of reviews
    var level: String
}
