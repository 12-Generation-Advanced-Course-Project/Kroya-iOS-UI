//
//  FoodCheckOutView.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI

struct FoodCheckOutView: View {
    
    // properties
    @Environment(\.dismiss) var dismiss
    @State private var isReceiptActive = false
    @State private var isPresented = false
    var body: some View {
        NavigationStack {
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
                        PaymentButtonView()
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
                
                
                Button("Place an order") {
                    self.isReceiptActive = true
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(maxWidth: .infinity , maxHeight: 44)
                //                .padding(.bottom, 10)
                .background(Color.yellow)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                NavigationLink(destination: ReceiptView(isPresented: $isPresented, isOrderReceived: false), isActive: $isReceiptActive) {
                    EmptyView()
                }
                
            }
            .padding(.horizontal)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Circle()
                            .fill(.white)
                            .frame(width: 25, height: 25)
                            .padding(10)
                            .overlay(
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    FoodCheckOutView()
}
