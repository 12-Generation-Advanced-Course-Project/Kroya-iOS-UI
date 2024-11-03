//
//  NewView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/19/24.
//

import SwiftUI



struct NewItemFoodOrderCardView: View {
    
    var iselected: Int?
    @State private var isPresented = false
    @State  var foodItems : [FoodItem] = [
        FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: nil, timeAgo: "10m ago"),
        FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR",status: "Reject", timeAgo: "15m ago"),
        FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR",status: "Accept", timeAgo: "15m ago"),
        FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR",status: "Reject", timeAgo: "15m ago")
    ]
    
    var showEllipsis: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach($foodItems){ item in
               
                        ItemFoodOrderCard(item: item, showEllipsis: showEllipsis)

                }
                  }
            .padding(.horizontal, 15)
        }
    }
}
