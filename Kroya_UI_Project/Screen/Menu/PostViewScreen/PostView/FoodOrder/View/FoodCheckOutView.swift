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
    @Binding var imageName:String
    var Foodname:String
    var FoodId: Int
    var Date: String
    var Price: Double
    var Currency: String
   
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // Order Card Section
                    Section {
                        OrderCardDetailView(viewModel: OrderCardDetailViewModel(orderItem: OrderItem(
                            name: Foodname,
                            price: Price,
                            date: Date
                        )), imageName: $imageName, currency: Currency)
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
                        Text(LocalizedStringKey("Payment"))
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
            .navigationTitle(LocalizedStringKey("Checkout"))
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
    
    //MARK: Helper function to format date
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Set timezone to GMT if needed
        
        // Match the input date format exactly
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Matches "2024-11-21T17:05:00"
        guard let date = formatter.date(from: dateString) else { return "Invalid Date" }
        
        // Format the output date
        formatter.dateFormat = "dd MMM yyyy" // Output format: "21 Nov 2024"
        return formatter.string(from: date)
    }
    
    
    
    //MARK: Helper function to determine time of day based on the cook date time (if available)
    private func determineTimeOfDay(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Matches "2024-11-21T17:05:00"
        
        guard let date = formatter.date(from: dateString) else { return "at current time." }
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 5..<12:
            return "in the morning."
        case 12..<17:
            return "in the afternoon."
        case 17..<21:
            return "in the evening."
        default:
            return "at night."
        }
    }
}
