import SwiftUI

struct FoodCheckOutView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isReceiptActive = false
    @StateObject private var PurchaesViewModel = OrderViewModel()
    @State private var isPresented = false
    @Binding var imageName: String
    @State private var selectedAddress: Address?
    @Environment(\.modelContext) private var context
    var Foodname: String
    var FoodId: Int
    var Date: String
    var Price: Double
    var Currency: String
    var PhoneNumber: String
    var ReciptentName: String
    @State private var remark: String? = ""
    @State private var totalPrice: Int = 0
    @State private var Quantity: Int = 1
    @State private var SelectPayment: String = ""
    @State private var navigationTrigger = false
    @State private var warningMessage: String? 
    let exchangeRateToRiel: Double = 4100
    
    var totalPriceInRiel: Double {
        if Currency.uppercased() == "RIEL" {
            return Double(totalPrice)
        } else {
            return Double(totalPrice) * exchangeRateToRiel 
        }
    }
    var Location: String {
        selectedAddress?.addressDetail ?? ""
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    List {
                        // Order Card Section
                        Section {
                            OrderCardDetailView(
                                viewModel: OrderCardDetailViewModel(
                                    orderItem: OrderItem(name: Foodname, price: Price, date: Date)
                                ),
                                imageName: $imageName,
                                currency: Currency,
                                totalPrice: $totalPrice,
                                quantity: $Quantity
                            )
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
                            PaymentButtonView(
                                payment: $SelectPayment,
                                PurchaesViewModel: PurchaesViewModel,
                                amount: Int(totalPriceInRiel),
                                remark: remark ?? "Good",
                                Location: Location,
                                Qty: Quantity,
                                FoodSellId: FoodId
                            ).environment(\.modelContext, context)
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
                    
                    // Warning Message
                    if let warningMessage = warningMessage {
                        Text(warningMessage)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                    }
                    
                    // Place Order Button
                    Button("Place an order") {
                        // Validation Logic
                        guard !Location.isEmpty else {
                            warningMessage = "Please select a delivery address."
                            return
                        }
                        guard !SelectPayment.isEmpty else {
                            warningMessage = "Please select a payment method."
                            return
                        }
                        
                        warningMessage = nil // Clear any previous warning
                        
                        let Amount = totalPriceInRiel // Convert to RIEL
                        
                        let purchase = PurchaseRequest(
                            foodSellId: FoodId,
                            remark: remark,
                            location: Location,
                            quantity: Quantity,
                            totalPrice: Amount
                        )
                        
                        // Debug: Print the details for verification
                        print("Order Details (in RIEL): \(purchase)")
                        
                        PurchaesViewModel.addPurchase(purchase: purchase, paymentType: SelectPayment)
                        withAnimation(.easeInOut) {
                            navigationTrigger = true
                        }
                    }
                    .font(.customfont(.semibold, fontSize: 16))
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .navigationTitle(LocalizedStringKey("Checkout"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }
            .fullScreenCover(isPresented: $PurchaesViewModel.isOrderSuccess, content: {
                ReceiptView(
                    isPresented: $isPresented,
                    isOrderReceived: false,
                    PurchaseId: PurchaesViewModel.Purchases?.purchaseId ?? 0, dismissToRoot: {
                        navigationTrigger = false
                    }
                )
            })
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
}


// MARK: Helper functions
private extension FoodCheckOutView {
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Matches "2024-11-21T17:05:00"
        guard let date = formatter.date(from: dateString) else { return "Invalid Date" }
        formatter.dateFormat = "dd MMM yyyy" // Output format: "21 Nov 2024"
        return formatter.string(from: date)
    }
    
    func determineTimeOfDay(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
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
