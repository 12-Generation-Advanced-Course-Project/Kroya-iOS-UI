//
//  NewView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/19/24.
//



import SwiftUI

struct NewItemFoodOrderCardView: View {
    
    var iselected: Int?
    @Binding var show3dot: Bool
    @State private var isPresented = false
    @State var foodItems: [FoodItem] = [
        FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: nil, timeAgo: "10m ago"),
        FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: "Reject", timeAgo: "15m ago"),
        FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: "Reject", timeAgo: "15m ago"),
        FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: "Reject", timeAgo: "15m ago")
    ]
    
    var showEllipsis: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
//                ForEach(foodItems.indices, id: \.self) { index in
//                    if foodItems[index].status != nil { // Check if status is not nil
//                        NavigationLink(destination: ReceiptView(isPresented: $isPresented, isOrderReceived: foodItems[index].status != nil)) {
//                            ItemFoodOrderCard(item: $foodItems[index], showEllipsis: showEllipsis, show3dot: $show3dot)
//                        }
//                    } else {
//                        ItemFoodOrderCard(item: $foodItems[index], showEllipsis: showEllipsis, show3dot: $show3dot)
//                    }
//                }
            }
            .padding(.horizontal, 15)
        }
    }
}




