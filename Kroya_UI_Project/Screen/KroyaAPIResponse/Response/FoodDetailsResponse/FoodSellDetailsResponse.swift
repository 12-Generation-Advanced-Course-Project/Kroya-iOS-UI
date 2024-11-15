//
//  FoodSellDetailsResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 15/11/24.
//

import SwiftUI
import Foundation

struct FoodSellDetails: Decodable {
    let id: Int
    let foodRecipeDTO: FoodRecipeDTO
    let dateCooking: String
    let amount: Int
    let price: Double
    let currencyType: String
    let location: String
    let status: String?
    let itemType: String
    let isFavorite: Bool
    let isOrderable: Bool
    let ratingPercentages: RatingPercentages
}

struct RatingPercentages: Decodable {
    let one: Int
    let two: Int
    let three: Int
    let four: Int
    let five: Int
    
    // Custom initializer to map from JSON keys "1", "2", "3", etc.
    enum CodingKeys: String, CodingKey {
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
    }
}

