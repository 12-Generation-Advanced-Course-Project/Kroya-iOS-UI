//
//  FoodSellModel.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/8/24.
//

import Foundation


struct FoodSellModel: Identifiable, Codable {
    let id: Int
    let photo: [Photo]
    let name: String
    let dateCooking: String
    let price: Double
    let currencyType: String
    let averageRating: Double?
    let totalRaters: Int?
    let isFavorite: Bool
    let itemType: String
    let isOrderable: Bool
    let sellerInformation: SellerInformation

    // Map foodSellId from JSON to id in the struct
    enum CodingKeys: String, CodingKey {
        case id = "foodSellId"
        case photo, name, dateCooking, price, currencyType, averageRating, totalRaters, isFavorite, itemType, isOrderable, sellerInformation
    }
}


