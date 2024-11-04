//
//  Receipt.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 13/10/24.
//

import SwiftUI

struct Receipt: Identifiable {
    var id = UUID()
    var item: String
    var qty: Int
    var referenceNumber: String
    var orderDate: String
    var paidBy: String
    var payer: String
    var sellerName: String
    var sellerPhone: String
    var amount: String
    var paidTo: String
    var address: String
}
