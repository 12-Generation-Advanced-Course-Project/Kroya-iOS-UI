//
//  FoodCheckoutView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 10/10/24.
//

import SwiftUI

struct FoodCheckoutView: View {
    var body: some View {
        
        NavigationView{
            List {
                Section {
                    OrderCardDetail(
                        quantity: 1,
                        price: 2.24,
                        foodName: "Somlor Kari",
                        orderDate: "5 May 2023 (Mornig)"
                    )
                }
                .listRowInsets(EdgeInsets())
                
                .padding(.bottom, 15)
                
                Section {
                    DeliveryView(
                        remark: "Note (Optional)", deliveryAddress: "HRD Center",
                        contactName: "St 323 - Toul Kork",
                        contactPhone: "Cheata, +85593333939"
                    )
                }
                .listRowInsets(EdgeInsets())
                
                
                Section {
                    PaymentButtomView()
                }
                header: {
                    Text("Payment")
                        .font(.customfont(.bold, fontSize: 16))
                        .foregroundColor(.black)
                }
//                .listRowInsets(EdgeInsets())
   
            }
            .padding()
            .listStyle(.inset)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
        
        }
    }
}

#Preview {
    FoodCheckoutView()
}



//import SwiftUI
//
//struct FoodCheckoutView: View {
//
//
//
//    var body: some View {
//        NavigationView {
//            List {
//                Section {
//                    OrderCardDetail(
//                        quantity: 1,
//                        price: 2.24,
//                        foodName: "Somlor Kari",
//                        orderDate: "5 May 2023 (Mornig)"
//                    )
//                }
//                .listRowInsets(EdgeInsets())
//
//                // Delivery Section
//                Section {
//                    DeliveryView(
//                        remark: "Note (Optional)",
//                        deliveryAddress: "HRD Center",
//                        contactName: "St 323 - Toul Kork",
//                        contactPhone: "Cheata, +85593333939"
//                    )
//                }
//                .listRowInsets(EdgeInsets())
//
//                // Payment Section
//                Section {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Payment")
//                            .font(.headline)
//                            .padding(.bottom, 5)
//
//                        PaymentButtomView()
//                    }
//                    .padding(.vertical)
//                }
//                .listRowInsets(EdgeInsets())
//            }
//            .listStyle(GroupedListStyle())
//            .navigationTitle("Checkout")
//            .navigationBarTitleDisplayMode(.inline)
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    FoodCheckoutView()
//}
