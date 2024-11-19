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
    var totalPrice:Int
}
//MARK: Purchase Request
struct PurchaseRequest: Encodable {
    var foodSellId: Int
    var remark: String?
    var location: String
    var quantity: Int
    var totalPrice: Int
    
//    func toDictionary() -> [String: Any] {
//        var dict: [String: Any] = [
//            "foodSellId": self.foodSellId,
//            "location": self.location,
//            "quantity": self.quantity,
//            "totalPrice": self.totalPrice
//        ]
//        
//        // Add 'remark' if it's not nil
//        if let remark = self.remark {
//            dict["remark"] = remark
//        }
//        
//        return dict
//    }
}
struct PurchaseRequestType : Encodable {
    var paymentType : String
}
