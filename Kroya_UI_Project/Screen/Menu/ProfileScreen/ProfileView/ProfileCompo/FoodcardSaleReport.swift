//
//  FoodcardSaleReport.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 15/10/24.
//

import SwiftUI

// Data model for food items
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let itemsCount: Int
    let remarks: String
    let price: Double
    let paymentMethod: String
}

// View for displaying a food item card
struct FoodCardView: View {
    let item: FoodItem
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("DinnerPic")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                VStack(alignment: .leading, spacing: 1) {
                    Text(item.name)
                        .font(.customfont(.semibold, fontSize: 18))
                    Text("\(item.itemsCount) items")
                        .font(.customfont(.medium, fontSize: 12))
                        .foregroundColor(.gray)
                    Text("Remarks:  \(item.remarks)")
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(.gray)
                   
                }
            }.padding()
            HStack {
                Image(systemName: "scope")
                .foregroundColor(.yellow)
                Text("St 323 - Toeul kork")
                    .font(.customfont(.semibold, fontSize: 16))
                Image(systemName: "phone.fill")
                    .foregroundColor(.yellow)
                Text("016 860 375")
                    .font(.customfont(.semibold, fontSize: 16))
            }
            .padding(.horizontal)
            .font(.customfont(.medium, fontSize: 14))
            .foregroundColor(.gray)
            Divider().frame(maxWidth: .infinity).foregroundStyle(Color(red: 0.836, green: 0.875, blue: 0.924))
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    HStack{
                        Text("Total")
                        Spacer()
                        Text("$\(String(format: "%.2f", item.price))")
                    }
                    .font(.customfont(.semibold, fontSize: 14))
                    HStack{
                        Text("Pay with \(item.paymentMethod)")
                        Spacer()
                        Text("$\(String(format: "%.2f", item.price))")
                    }
                    .font(.customfont(.semibold, fontSize: 14))
                }
            }.padding(.horizontal,5)
                .padding(.vertical,10)
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.836, green: 0.875, blue: 0.924), lineWidth: 1.5)
        )
        
    }
}
#Preview {
    FoodCardView(item: FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR"))
}
