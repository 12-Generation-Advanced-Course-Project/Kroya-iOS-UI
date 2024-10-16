//
//  OrderCardDetailViewModel.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI

class OrderCardDetailViewModel: ObservableObject {
    
    @Published var orderItem: OrderItem
    @Published var quantity: Int = 1
    
    var totalPrice: Double {
        return orderItem.price * Double(quantity)
    }
    
    init(orderItem: OrderItem) {
        self.orderItem = orderItem
    }
    
    func incrementQuantity() {
        quantity += 1
    }
    
    func decrementQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
}
