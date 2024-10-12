//
//  OrderItem.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import Foundation

struct OrderItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let date: String
}
