//
//  sale.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct PopularSellTab: View {
    var isSelected: Int?
    @StateObject private var popularSell = PopularFoodVM()
  
    var body: some View {
        VStack {
            if popularSell.popularFoodSell.isEmpty && !popularSell.isLoading{
                Text("No Popular Food Sell Found!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(popularSell.popularFoodSell) { popularsell in
                            NavigationLink(destination: foodDetailDestination(for: popularsell)) {
                                FoodOnSaleViewCell(foodSale: popularsell)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .overlay(
                    Group {
                        if popularSell.isLoading {
                            Color.white
                                .edgesIgnoringSafeArea(.all)
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                .scaleEffect(2)
                        }
                    }
                )
            }
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if popularSell.popularFoodSell.isEmpty {
                popularSell.getAllPopular()
            }
        }
    }
    
    // MARK: - Food Detail Destination
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
            theMainImage: "ahmok",
            subImage1: "ahmok1",
            subImage2: "ahmok2",
            subImage3: "ahmok3",
            subImage4: "ahmok4",
            showOrderButton: foodSale.isOrderable,
            showPrice: foodSale.isOrderable
        )
    }
}
//#Preview {
//   SaleTab()
//}
