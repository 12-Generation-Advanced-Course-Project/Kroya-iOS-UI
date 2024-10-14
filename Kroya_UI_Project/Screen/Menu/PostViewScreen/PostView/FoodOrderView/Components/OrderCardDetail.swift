//
//  OrderCardDetail.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 10/10/24.
//

import SwiftUI

struct OrderCardDetail: View {
    
    @State var quantity: Int
    var price: Double
    var foodName: String
    var orderDate: String
    
    var body: some View {
        VStack{
            VStack(spacing: 10) {
                HStack {
                    Text("Orders")
                        .font(.customfont(.bold, fontSize: 16))
                    Spacer()
                }
                .padding()
                
                // Order Detail
                HStack(spacing: 16) {
                    // Image of the food
                    Image("SomlorKari")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(foodName)
                            .font(.customfont(.medium, fontSize: 16))
                        
                        Text(orderDate)
                            .font(.customfont(.light, fontSize: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Price
                    Text("$ \(price, specifier: "%.2f")")
                        .font(.customfont(.medium, fontSize: 18))
                }
                .padding(.horizontal)
                
                // Quantity Controls
                HStack {
                    Spacer()
                    Button(action: {
                        if quantity > 1 {
                            quantity -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.yellow)
                    }
                    
                    Text("\(quantity)")
                        .font(.customfont(.medium, fontSize: 16))
                        .padding(.horizontal, 10)
                    
                    Button(action: {
                        quantity += 1
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1.5)
                    .background(Color(red: 0.836, green: 0.876, blue: 0.922))
                
                
                
                // Total Section
                HStack {
                    Text("Total")
                        .font(.customfont(.medium, fontSize: 16))
                    
                    Spacer()
                    
                    Text("$ \(Double(quantity) * price, specifier: "%.2f")")
                        .font(.customfont(.medium, fontSize: 16))
                }
                .padding()
                
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 0.836, green: 0.876, blue: 0.922), lineWidth: 1.5)
            )
        }
       
    }
    
}

#Preview {
    OrderCardDetail(
        quantity: 1,
        price: 2.24,
        foodName: "Somlor Kari",
        orderDate: "5 May 2023 (Mornig)"
    )
}

