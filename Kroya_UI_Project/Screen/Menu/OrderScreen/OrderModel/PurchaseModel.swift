//
//  PurchaseModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 19/11/24.
//

import SwiftUI


//MARK: Purchase Order
struct PurchaseModel: Codable {
    var recipeId:Int
    var purchaseId:Int
    var foodSellCardResponse: FoodSellModel
    var reference:String
    var orderDate:String
    var paidBy:String
    var payer:String
    var seller:String
    var quantity:Int
    var totalPrice:Double
}
//MARK: Purchase Request
struct PurchaseRequest: Codable {
    var foodSellId: Int
    var remark: String?
    var location: String
    var quantity: Int
    var totalPrice: Double

}

//MARK: Add a Purchase
struct PurchaseResponse: Decodable {
    let message: String
    let payload: PurchaseModel?
    let statusCode: String
    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case message, payload, statusCode, timestamp
    }
    
    init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.message = try container.decode(String.self, forKey: .message)
           self.statusCode = try container.decode(String.self, forKey: .statusCode)
           self.timestamp = try? container.decode(String.self, forKey: .timestamp)

           // Attempt to decode payload as T; fallback to nil if it's not decodable.
           if let decodedPayload = try? container.decode(PurchaseModel.self, forKey: .payload) {
               self.payload = decodedPayload
           } else {
               self.payload = nil
           }
       }
}
