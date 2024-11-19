//
//  NewView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/19/24.
//



import SwiftUI

struct NewItemFoodOrderCardView: View {
    
    @State private var isPresented = false
    @Binding  var show3dot: Bool
    let showEllipsis: Bool
    @Environment(\.dismiss) var dismiss
    @StateObject private var orderRequestVM = OrderRequestViewModel()
    var sellerId:Int
    
    var body: some View {
        NavigationView {
            VStack {
                // Loading Indicator or Content
                if orderRequestVM.isLoading {
                    ZStack {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                            .scaleEffect(2)
                            .offset(y: -80)
                    }
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(orderRequestVM.ordersRequestModel) { foodSale in
                                ItemFoodOrderCard(orderRequest: foodSale, show3dot: $show3dot)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .onAppear{
                orderRequestVM.fetchOrderForSellerById(sellerId:sellerId)
            }
        }
    }
    
    
    
    
}
    




