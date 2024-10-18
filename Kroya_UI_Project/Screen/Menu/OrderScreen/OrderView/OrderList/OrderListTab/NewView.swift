//
//  NewView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/19/24.
//

import SwiftUI

struct NewView: View {
    var iselected:Int?
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                FoodCardView(item: FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR"))
                
                FoodCardView(item: FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR"))
                
                FoodCardView(item: FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR"))
            }.padding(.horizontal, 15)
        }}
}

#Preview {
    NewView()
}
