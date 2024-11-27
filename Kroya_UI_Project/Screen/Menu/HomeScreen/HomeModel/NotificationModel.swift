//
//  NotificationModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 22/11/24.
//

import SwiftUI

import Foundation

// MARK: - NotificationModel
struct NotificationModel: Codable, Identifiable {
    var id: Int { notificationID } // Use API's unique `notificationID` as `id`
    let notificationID: Int
    let purchaseID: Int
    let foodSellId: Int
    let description: String
    var isRead: Bool
    let foodPhoto: String
    let itemType: String
    let foodCardType: String
    let purchaseStatusType: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case purchaseID = "purchaseId"
        case foodSellId = "foodSellId"
        case description, isRead, foodPhoto, itemType, foodCardType, purchaseStatusType, createdDate
    }
}
