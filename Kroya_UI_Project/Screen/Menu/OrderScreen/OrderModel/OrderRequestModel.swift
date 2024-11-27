//
//  OrderRequestModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 19/11/24.
//

import SwiftUI

struct OrderRequestModel: Identifiable, Codable {
    var id: Int
    var foodSellCardResponse: FoodSellModel
    var remark: String?
    var location: String
    var paymentType: String
    var purchaseStatusType: String?
    var quantity: Int
    var totalPrice: Double // Changed from Int to Double
    var purchaseDate: String?
    var buyerInformation: BuyerInformationModel

    enum CodingKeys: String, CodingKey {
        case id = "purchaseId"
        case foodSellCardResponse, remark, location, paymentType, purchaseStatusType, quantity, totalPrice, purchaseDate, buyerInformation
    }
}

struct BuyerInformationModel: Codable {
    var userId: Int
    var fullName: String
    var phoneNumber: String
    var profileImage: String
    var location: String
}

