//
//  OrderModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 8/10/24.
//

import Foundation

// MARK: - OrderModel
struct OrderModel: Identifiable, Decodable {
    var id = UUID()
    var foodSellId: Int
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
    let totalPrice: Double?
    let purchaseStatusType: String?
    let purchaseDate: String?
    let currencyType: String?

    enum CodingKeys: String, CodingKey {
        case foodSellId = "foodSellId"
        case name, price, orderCount, photo, dateCooking, isOrderable, itemType, foodCardType
        case purchaseID = "purchaseId"
        case quantity, totalPrice, purchaseStatusType, purchaseDate, currencyType
    }
}

// MARK: - OrderModelForBuyer
struct OrderModelForBuyer: Identifiable, Decodable {
    var id: Int // Use `purchaseId` as the unique identifier
    var foodSellId: Int
    var name: String
    var photo: [Photo] // Update to handle an array of photos
    var quantity: Int
    var totalPrice: Double // Changed from Int to Double
    var dateCooking: String
    var isOrderable: Bool
    var itemType: String
    var foodCardType: String
    var purchaseStatusType: String
    var purchaseDate: String

    enum CodingKeys: String, CodingKey {
        case id = "purchaseId"
        case foodSellId, name, photo, quantity, totalPrice, dateCooking, isOrderable, itemType, foodCardType, purchaseStatusType, purchaseDate
    }
}


