//
//  FoodCheckOutView.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//
import SwiftUI

struct FoodCheckOutView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isReceiptActive = false
    @StateObject private var PurchaesViewModel = OrderViewModel()
    @State private var isPresented = false
    @Binding var imageName: String
    @State private var selectedAddress: Address?
    var Foodname: String
    var FoodId: Int
    var Date: String
    var Price: Double
    var Currency: String
    var PhoneNumber: String
    var ReciptentName: String
    @State private var remark: String? = ""
    @State private var unitPrice: Int = 0
    @State private var Quantity: Int = 0
    @State private var SelectPayment: String = ""
    
    var Location: String {
        selectedAddress?.specificLocation ?? ""
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // Order Card Section
                    Section {
                        OrderCardDetailView(viewModel: OrderCardDetailViewModel(orderItem: OrderItem(name: Foodname, price: Price, date: Date)), imageName: $imageName, currency: Currency, totalPrice: $unitPrice, quantity: $Quantity)
                    }
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom, 12)
                    .padding(.top, 5)
                    .listRowSeparator(.hidden)
                    
                    // Delivery Card Section
                    Section {
                        DeliveryCardDetailView(selectedAddress: $selectedAddress, remark: $remark)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    
                    // Payment Section
                    Section {
                        PaymentButtonView(payment: $SelectPayment)
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
                    guard !Location.isEmpty else {
                        print("Error: Address not selected.")
                        return
                    }
                    guard !SelectPayment.isEmpty else {
                        print("Error: Payment method not selected.")
                        return
                    }
                    guard Quantity > 0 else {
                        print("Error: Quantity must be greater than zero.")
                        return
                    }
                    
                    let totalPrice = Double(unitPrice) * Double(Quantity)
                    let purchase = PurchaseRequest(
                        foodSellId: FoodId,
                        remark: remark,
                        location: Location,
                        quantity: Quantity,
                        totalPrice: Int(totalPrice)
                    )
                    
                    PurchaesViewModel.addPurchase(purchase: purchase, paymentType: SelectPayment)
                    print("This is Purchase \(purchase)")
                }
                .font(.customfont(.semibold, fontSize: 16))
                .frame(maxWidth: .infinity, maxHeight: 44)
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


