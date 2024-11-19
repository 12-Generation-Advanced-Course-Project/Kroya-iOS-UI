//
//  OrderModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 8/10/24.
//

import Foundation

// MARK: - Payload
struct OrderModel: Codable {
    let foodSellID: Int
    let name: String
    let price: Int?
    let orderCount: Int?
    let photo: [Photo]
    let dateCooking: String?
    let isOrderable: Bool
    let itemType: String
    let foodCardType: String
    let purchaseID: Int?
    let quantity: Int?
    let totalPrice: Int?
    let purchaseStatusType: String?
    let purchaseDate: String?

    enum CodingKeys: String, CodingKey {
        case foodSellID = "foodSellId"
        case name, price, orderCount, photo, dateCooking, isOrderable, itemType, foodCardType
        case purchaseID = "purchaseId"
        case quantity, totalPrice, purchaseStatusType, purchaseDate
    }
    
}


