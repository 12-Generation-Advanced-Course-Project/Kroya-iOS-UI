//
//  DeliveryInfo.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import Foundation

struct DeliveryInfo: Identifiable {
    let id = UUID()
    let locationName: String
    let address: String
    let recipient: String
    let phoneNumber: String
    let remarks: String?
}
