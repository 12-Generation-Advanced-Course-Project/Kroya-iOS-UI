//
//  FoodCheckOutView.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI

struct FoodCheckOutView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Order Card Section
                    Section {
                        OrderCardDetailView(viewModel: OrderCardDetailViewModel(orderItem: OrderItem(
                            name: "Somlor Kari",
                            price: 2.24,
                            date: "5 May 2023 ( Morning )"
                        )))
                    }
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom, 12)
                    .padding(.top, 5)
                    .listRowSeparator(.hidden) // Hide the separator
                    
                    // Delivery Card Section
                    Section {
                        DeliveryCardDetailView(viewModel: DeliveryCardDetailViewModel(deliveryInfo: DeliveryInfo(
                            locationName: "HRD Center",
                            address: "St 323 - Toul Kork",
                            recipient: "Cheata",
                            phoneNumber: "+85593333929",
                            remarks: nil
                        )))
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden) // Hide the separator
                    
                    // Payment Section
                    Section {
                        PaymentButtomView()
                    } header: {
                        Text("Payment")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                
                
                //Next
                NavigationLink(destination: RecipeModalView(), label: {
                    Text("Place an order")
                        .font(.customfont(.semibold, fontSize: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                })
                .padding(.bottom, 10)

            }
            .padding(.horizontal)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FoodCheckOutView()
}
