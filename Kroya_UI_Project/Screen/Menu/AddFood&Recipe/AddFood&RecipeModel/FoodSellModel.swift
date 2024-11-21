//
//  FoodSellModel.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/8/24.
//

import Foundation


// MARK: - Food Sell Model
struct FoodSellModel: Identifiable, Codable {
    
    var id: Int
    var photo: [Photo]
    var name: String
    var dateCooking: String?
    var price: Double
    var currencyType: String?
    var averageRating: Double?
    var totalRaters: Int?
    var isFavorite: Bool?
    var itemType: String
    var isOrderable: Bool
    var sellerInformation: SellerInformation?
    
    // Map `foodSellId` from JSON to `id` in the struct
    enum CodingKeys: String, CodingKey {
        case id = "foodSellId"
        case photo, name, dateCooking, price, currencyType, averageRating, totalRaters, isFavorite, itemType, isOrderable, sellerInformation
    }
}





