//
//  OrderCardDetailView.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI

struct OrderCardDetailView: View {
    @StateObject var viewModel: OrderCardDetailViewModel
    
    var body: some View {
        VStack {
            // Header Section
            HStack {
                Text("Orders")
//                    .font(.system(size: 16, weight: .semibold))
                    .font(.customfont(.semibold, fontSize: 16))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 10)
            
            // Order Item Section
            VStack {
                HStack {
                    HStack(spacing: 15) {
                        Image("food_background")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(viewModel.orderItem.name)
                                    .font(.customfont(.medium, fontSize: 16))
                                Spacer()
                                Text("$ \(viewModel.orderItem.price, specifier: "%.2f")")
                                    .font(.customfont(.medium, fontSize: 16))
                            }
                            
                            Text(viewModel.orderItem.date)
                                .font(.customfont(.light, fontSize: 10))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Quantity Controls Section
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.decrementQuantity()
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.yellow)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove default button style
                    
                    Text("\(viewModel.quantity)")
                        .font(.customfont(.medium, fontSize: 16))
                        .padding(.horizontal, 10)
                       
                    
                    Button(action: {
                        viewModel.incrementQuantity()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.yellow)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove default button style
                }
                .padding(.vertical, 5)
            }
            .padding(.horizontal)
            
            // Total Price Section
            HStack {
                HStack {
                    Text("Total")
                        .font(.customfont(.semibold, fontSize: 16))
                    Spacer()
                    Text("$ \(viewModel.totalPrice, specifier: "%.2f")")
                        .font(.customfont(.semibold, fontSize: 16))
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 10)
            .offset(y: 6)
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundColor(Color(red: 0.836, green: 0.876, blue: 0.922)),
                alignment: .top
            )
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.836, green: 0.876, blue: 0.922), lineWidth: 1.5)
        )
//        .contentShape(Rectangle()) // Ensure only buttons are tappable
    }
}

#Preview {
    OrderCardDetailView(viewModel: OrderCardDetailViewModel(orderItem: OrderItem(
        name: "Somlor Kari",
        price: 2.24,
        date: "5 May 2023 ( Morning )"
    )))
}
