////
////  BreakFastFoodSaleTab.swift
////  Kroya_UI_Project
////
////  Created by KAK-LY on 13/11/24.
////
//
//import SwiftUI
//
//// MARK: - FoodOnSaleView
//struct BreakFastFoodSaleTab: View {
//    var iselected: Int?
//    @ObservedObject  var categoryVM = CategoryMV()
//    
//    var body: some View {
//        VStack {
//            if categoryVM.FoodSellByCategory.isEmpty && !categoryVM.isLoading {
//                Text("No Food Items Available")
//                    .font(.title3)
//                    .foregroundColor(.gray)
//                    .padding()
//            } else {
//                ScrollView(showsIndicators: false) {
//                    LazyVStack(spacing: 8) {
//                        ForEach(categoryVM.FoodSellByCategory) { foodSale in
//                            NavigationLink(destination: foodDetailDestination(for: foodSale)) {
//                                FoodOnSaleViewCell(foodSale: foodSale)
//                                    .frame(maxWidth: .infinity)
//                                    .padding(.horizontal, 20)
//                            }
//                        }
//                    }
//                }
//                .overlay(
//                    Group {
//                        if categoryVM.isLoading {
//                            LoadingOverlay()
//                        }
//                    }
//                )
//            }
//        }
//        .padding(.top, 8)
//        .navigationBarBackButtonHidden(true)
//        .onAppear {
//           
//        }
//    }
//    
//    // MARK: - Food Detail Destination
//    @ViewBuilder
//    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
//        FoodDetailView(
//            theMainImage: "ahmok",
//            subImage1: "ahmok1",
//            subImage2: "ahmok2",
//            subImage3: "ahmok3",
//            subImage4: "ahmok4",
//            showOrderButton: foodSale.isOrderable,
//            showPrice: foodSale.isOrderable
//        )
//    }
//}
