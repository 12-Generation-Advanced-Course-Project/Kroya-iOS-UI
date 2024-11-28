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
    var isFavorite: Bool
    let isOrderable: Bool
    let ratingPercentages: RatingPercentages?
}

struct RatingPercentages: Decodable {
    let one: Double
    let two: Double
    let three: Double
    let four: Double
    let five: Double

    // Custom initializer to map from JSON keys "1", "2", "3", etc.
    enum CodingKeys: String, CodingKey {
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
    }

    // Converts the object into a `[String: Double]` dictionary for easier access.
    func toDictionary() -> [String: Double] {
        return [
            "1": one,
            "2": two,
            "3": three,
            "4": four,
            "5": five
        ]
    }
}


