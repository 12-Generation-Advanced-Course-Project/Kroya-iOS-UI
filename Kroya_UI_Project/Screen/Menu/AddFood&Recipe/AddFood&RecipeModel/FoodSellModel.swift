//
//  FoodSellModel.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/8/24.
//

import Foundation


struct FoodSellModel: Codable, Identifiable {
    var id: Int
    var photo: [Photo]
    var name, dateCooking: String
    var price: Double
    var currencyType: String
    var averageRating: Double
    var totalRaters: Int
    var isFavorite: Bool
    var itemType: String
    var isOrderable: Bool
    var sellerInformation: User
    var rating: String
}
