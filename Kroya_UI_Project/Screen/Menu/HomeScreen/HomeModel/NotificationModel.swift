//
//  NotificationModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 22/11/24.
//

import SwiftUI

// MARK: - Food Sell Model

struct NotificationModel: Identifiable, Codable {
    
    let id = UUID()
    let notificationID: Int
    let purchaseID: Int
    let foodSellID: Int
    let description: String
    var isRead: Bool
    let foodPhoto: String
    let itemType: String
    let foodCardType: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case purchaseID = "purchaseId"
        case foodSellID = "foodSellId"
        case description, isRead, foodPhoto, itemType, foodCardType, createdDate
    }
}                                                                                                                                                                                                                      

